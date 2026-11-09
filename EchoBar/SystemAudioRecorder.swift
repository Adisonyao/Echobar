import AudioToolbox
import CoreAudio
import Foundation
import os

struct WAVEncoding: Sendable {
    enum SampleRate: Int, CaseIterable, Sendable {
        case source = 0
        case voice = 16_000
        case compact = 24_000
        case standard = 32_000
        case cd = 44_100
        case studio = 48_000

        var title: String {
            guard self != .source else { return L10n.text("source") }
            return (Double(rawValue) / 1000).formatted(.number.precision(.fractionLength(0...1)).locale(L10n.locale)) + " kHz"
        }
    }

    enum BitDepth: Int, CaseIterable, Sendable {
        case small = 8
        case standard = 16
        case high = 24

        var title: String { "\(rawValue) bit" }
    }

    var sampleRate: SampleRate
    var bitDepth: BitDepth

    var estimatedMegabytesPerHour: Int {
        let rate = sampleRate == .source ? 48_000 : sampleRate.rawValue
        return Int((Double(rate * 2 * (bitDepth.rawValue / 8)) * 3600 / 1_000_000).rounded())
    }

    func fileFormat(for input: AudioStreamBasicDescription) -> AudioStreamBasicDescription {
        let bytes = UInt32(bitDepth.rawValue / 8) * input.mChannelsPerFrame
        // Standard 8-bit WAV uses unsigned PCM. Wider WAV samples are signed.
        let signedFlag = bitDepth == .small ? 0 : kAudioFormatFlagIsSignedInteger
        return AudioStreamBasicDescription(
            mSampleRate: sampleRate == .source ? input.mSampleRate : Double(sampleRate.rawValue),
            mFormatID: kAudioFormatLinearPCM,
            mFormatFlags: signedFlag | kAudioFormatFlagIsPacked,
            mBytesPerPacket: bytes, mFramesPerPacket: 1, mBytesPerFrame: bytes,
            mChannelsPerFrame: input.mChannelsPerFrame, mBitsPerChannel: UInt32(bitDepth.rawValue), mReserved: 0
        )
    }
}

struct RecordingOutcome: Sendable {
    let url: URL
    let warning: String?
}

enum RecorderError: LocalizedError {
    case audio(String, OSStatus)
    case unsupportedFormat
    case noAudio
    case couldNotSave(URL, Error)

    var errorDescription: String? {
        switch self {
        case let .audio(_, status):
            return L10n.text("error.audio", String(status))
        case .unsupportedFormat:
            return L10n.text("error.format")
        case .noAudio:
            return L10n.text("error.empty")
        case let .couldNotSave(url, error):
            return L10n.text("error.save", url.lastPathComponent) + "\n" + error.localizedDescription
        }
    }
}

// The control queue owns the HAL objects. The I/O callback only touches the sink.
final class SystemAudioRecorder: @unchecked Sendable {
    private let control = DispatchQueue(label: "app.echobar.audio-control", qos: .userInitiated)
    private var tap = AudioObjectID(kAudioObjectUnknown)
    private var device = AudioObjectID(kAudioObjectUnknown)
    private var callback: AudioDeviceIOProcID?
    private var running = false
    private var checkpointTimer: DispatchSourceTimer?
    private var session: CaptureSession?
    private let liveSpectrum = OSAllocatedUnfairLock<AudioSpectrum?>(initialState: nil)

    var frequencyLevels: [Float] {
        let spectrum = liveSpectrum.withLock { $0 }
        return spectrum?.levels ?? AudioSpectrum.silence
    }

    func start(in folder: URL, encoding: WAVEncoding) async throws {
        try await perform { try self.begin(in: folder, encoding: encoding) }
    }

    func recover() async -> [URL] {
        (try? await perform { RecordingRecovery.recoverPending() }) ?? []
    }

    func stop() async throws -> RecordingOutcome {
        try await perform { try self.finish() }
    }

    private func perform<T: Sendable>(_ operation: @escaping @Sendable () throws -> T) async throws -> T {
        try await withCheckedThrowingContinuation { continuation in
            control.async {
                continuation.resume(with: Result(catching: operation))
            }
        }
    }

    private func begin(in folder: URL, encoding: WAVEncoding) throws {
        try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)

        do {
            let description = CATapDescription(stereoGlobalTapButExcludeProcesses: [])
            description.name = "EchoBar System Audio"
            description.isPrivate = true
            description.muteBehavior = .unmuted
            try check(AudioHardwareCreateProcessTap(description, &tap), "create tap")

            var format = AudioStreamBasicDescription()
            var address = AudioObjectPropertyAddress(
                mSelector: kAudioTapPropertyFormat,
                mScope: kAudioObjectPropertyScopeGlobal,
                mElement: kAudioObjectPropertyElementMain
            )
            var size = UInt32(MemoryLayout<AudioStreamBasicDescription>.size)
            try check(AudioObjectGetPropertyData(tap, &address, 0, nil, &size, &format), "read tap format")
            guard format.mFormatID == kAudioFormatLinearPCM, format.mSampleRate > 0,
                  format.mBytesPerFrame > 0, (1...2).contains(format.mChannelsPerFrame) else {
                throw RecorderError.unsupportedFormat
            }

            let composition: [String: Any] = [
                kAudioAggregateDeviceNameKey: "EchoBar Capture",
                kAudioAggregateDeviceUIDKey: UUID().uuidString,
                kAudioAggregateDeviceIsPrivateKey: true,
                kAudioAggregateDeviceTapListKey: [[
                    kAudioSubTapUIDKey: description.uuid.uuidString,
                    kAudioSubTapDriftCompensationKey: true
                ]]
            ]
            try check(AudioHardwareCreateAggregateDevice(composition as CFDictionary, &device), "create aggregate device")

            let spectrum = AudioSpectrum(format: format)
            let capture = try CaptureSession(folder: folder, format: format, encoding: encoding, spectrum: spectrum)
            session = capture
            try check(AudioDeviceCreateIOProcIDWithBlock(&callback, device, nil) { _, input, _, _, _ in
                capture.receive(input)
            }, "install I/O callback")
            try check(AudioDeviceStart(device, callback), "start device")
            running = true
            liveSpectrum.withLock { $0 = spectrum }
            let timer = DispatchSource.makeTimerSource(queue: control)
            timer.schedule(deadline: .now() + .seconds(2), repeating: .seconds(2), leeway: .milliseconds(250))
            timer.setEventHandler { [weak capture] in capture?.checkpoint() }
            checkpointTimer = timer
            timer.resume()
        } catch {
            tearDownHardware()
            session?.discard()
            session = nil
            throw error
        }
    }

    private func finish() throws -> RecordingOutcome {
        tearDownHardware()
        guard let capture = session else { throw RecorderError.noAudio }
        session = nil
        liveSpectrum.withLock { $0 = nil }
        return try capture.save()
    }

    private func tearDownHardware() {
        checkpointTimer?.cancel()
        checkpointTimer = nil
        if running {
            AudioDeviceStop(device, callback)
            running = false
        }
        if let callback {
            AudioDeviceDestroyIOProcID(device, callback)
            self.callback = nil
        }
        if device != kAudioObjectUnknown {
            AudioHardwareDestroyAggregateDevice(device)
            device = kAudioObjectUnknown
        }
        if tap != kAudioObjectUnknown {
            AudioHardwareDestroyProcessTap(tap)
            tap = kAudioObjectUnknown
        }
    }
}

private func check(_ status: OSStatus, _ operation: String) throws {
    if status != noErr { throw RecorderError.audio(operation, status) }
}

private final class CaptureSession: @unchecked Sendable {
    private let temporaryURL: URL
    private let folder: URL
    private let clientFormat: AudioStreamBasicDescription
    private let spectrum: AudioSpectrum?
    private var file: ExtAudioFileRef?
    private let recovery: RecordingRecovery
    private var checkpointHandle: FileHandle?
    // Only accessed by the I/O thread until the IOProc is stopped and destroyed.
    private var framesWritten: UInt64 = 0
    private var writeStatus: OSStatus = noErr

    init(folder: URL, format: AudioStreamBasicDescription, encoding: WAVEncoding, spectrum: AudioSpectrum?) throws {
        self.folder = folder
        self.spectrum = spectrum
        self.clientFormat = format
        let id = UUID()
        temporaryURL = folder.appendingPathComponent(".EchoBar-\(id.uuidString).partial.wav")
        recovery = try RecordingRecovery(file: temporaryURL, id: id)

        var wavFormat = encoding.fileFormat(for: format)
        do {
            try check(ExtAudioFileCreateWithURL(temporaryURL as CFURL, kAudioFileWAVEType, &wavFormat, nil, 0, &file), "create WAV")
            guard let file else { throw RecorderError.unsupportedFormat }
            checkpointHandle = try FileHandle(forUpdating: temporaryURL)
            try checkpointHandle?.synchronize()
            var inputFormat = format
            try check(ExtAudioFileSetProperty(file, kExtAudioFileProperty_ClientDataFormat,
                                              UInt32(MemoryLayout.size(ofValue: inputFormat)), &inputFormat), "configure WAV")
            // Preallocate the async writer before the real-time callback starts.
            try check(ExtAudioFileWriteAsync(file, 0, nil), "prime async writer")
        } catch {
            discard()
            throw error
        }
    }

    func receive(_ input: UnsafePointer<AudioBufferList>) {
        guard let file, writeStatus == noErr, input.pointee.mNumberBuffers > 0 else { return }
        let buffers = UnsafeMutableAudioBufferListPointer(UnsafeMutablePointer(mutating: input))
        let expected = clientFormat.mFormatFlags & kAudioFormatFlagIsNonInterleaved == 0
            ? 1 : Int(clientFormat.mChannelsPerFrame)
        guard buffers.count == expected else {
            writeStatus = kAudio_ParamError
            return
        }
        let first = buffers[0]
        let frames = first.mDataByteSize / clientFormat.mBytesPerFrame
        guard frames > 0 else { return }
        for buffer in buffers {
            guard buffer.mData != nil, buffer.mDataByteSize >= first.mDataByteSize else { return }
        }
        let status = ExtAudioFileWriteAsync(file, frames, input)
        if status == noErr { framesWritten += UInt64(frames) } else { writeStatus = status }

        spectrum?.append(buffers, frames: Int(frames))
    }

    func checkpoint() {
        try? checkpointHandle?.synchronize()
    }

    func save() throws -> RecordingOutcome {
        let closeStatus = close()
        guard framesWritten > 0 else {
            discard()
            if writeStatus != noErr { try check(writeStatus, "write WAV") }
            throw RecorderError.noAudio
        }
        guard closeStatus == noErr else {
            throw RecorderError.couldNotSave(temporaryURL, RecorderError.audio("finalize WAV", closeStatus))
        }

        do {
            try checkpointHandle?.synchronize()
        } catch {
            throw RecorderError.couldNotSave(temporaryURL, error)
        }
        let date = DateFormatter()
        date.locale = Locale(identifier: "en_US_POSIX")
        date.dateFormat = "yyyy-MM-dd HH.mm.ss"
        let stamp = date.string(from: .now)
        let base = "EchoBar \(stamp)"
        var destination = folder.appendingPathComponent(base + ".wav")
        var suffix = 2
        while FileManager.default.fileExists(atPath: destination.path) {
            destination = folder.appendingPathComponent("\(base) (\(suffix)).wav")
            suffix += 1
        }
        do {
            try FileManager.default.moveItem(at: temporaryURL, to: destination)
        } catch {
            throw RecorderError.couldNotSave(temporaryURL, error)
        }
        recovery.clear()
        let warning = writeStatus == noErr ? nil : L10n.text("partial")
        return RecordingOutcome(url: destination, warning: warning)
    }

    func discard() {
        _ = close()
        try? FileManager.default.removeItem(at: temporaryURL)
        recovery.clear()
    }

    private func close() -> OSStatus {
        guard let file else { return noErr }
        self.file = nil
        return ExtAudioFileDispose(file)
    }
}
