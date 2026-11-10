import Accelerate
import AudioToolbox
import Foundation
import os

/// Rolling PCM history and FFT run independently of the WAV writer.
final class AudioSpectrum: @unchecked Sendable {
    static let bandCount = 7
    static let silence = [Float](repeating: 0, count: bandCount)

    private struct History {
        var channels: [[Float]]
        var next = 0
        var pending = false
    }

    private let history: OSAllocatedUnfairLock<History>
    private let output = OSAllocatedUnfairLock(initialState: silence)
    private let analyzer: SpectrumFFT
    private let timer: DispatchSourceTimer
    // Accessed only by the serial analysis queue after initialization.
    private var snapshot: [[Float]]
    private var smoothed = silence
    private let length: Int
    private let channelCount: Int

    init?(format: AudioStreamBasicDescription) {
        guard format.mFormatFlags & kAudioFormatFlagIsFloat != 0,
              format.mFormatFlags & kAudioFormatFlagIsBigEndian == 0,
              format.mBitsPerChannel == 32 else { return nil }

        let channels = Int(format.mChannelsPerFrame)
        let planar = format.mFormatFlags & kAudioFormatFlagIsNonInterleaved != 0
        guard format.mBytesPerFrame == UInt32((planar ? 1 : channels) * MemoryLayout<Float>.stride),
              let analyzer = SpectrumFFT(sampleRate: format.mSampleRate) else { return nil }

        self.analyzer = analyzer
        length = analyzer.length
        channelCount = channels
        snapshot = (0..<channels).map { _ in [Float](repeating: 0, count: analyzer.length) }
        history = OSAllocatedUnfairLock(initialState: History(
            channels: (0..<channels).map { _ in [Float](repeating: 0, count: analyzer.length) }
        ))
        timer = DispatchSource.makeTimerSource(queue: DispatchQueue(label: "app.echobar.spectrum", qos: .userInitiated))
        timer.schedule(deadline: .now(), repeating: .milliseconds(33), leeway: .milliseconds(4))
        timer.setEventHandler { [weak self] in self?.analyze() }
        timer.resume()
    }

    deinit { timer.cancel() }

    var levels: [Float] { output.withLock { $0 } }

    /// Called from Core Audio. Skip this display update if the worker is taking a snapshot.
    func append(_ buffers: UnsafeMutableAudioBufferListPointer, frames: Int) {
        let interleaved = buffers.count == 1
        _ = history.withLockIfAvailable { history in
            for channel in 0..<channelCount {
                let buffer = buffers[interleaved ? 0 : channel]
                guard let samples = buffer.mData?.assumingMemoryBound(to: Float.self) else { continue }
                let stride = interleaved ? channelCount : 1
                let offset = interleaved ? channel : 0
                var next = history.next
                history.channels[channel].withUnsafeMutableBufferPointer { destination in
                    for frame in 0..<frames {
                        destination[next] = samples[frame * stride + offset]
                        next = (next + 1) & (length - 1)
                    }
                }
            }
            history.next = (history.next + frames) & (length - 1)
            history.pending = true
        }
    }

    private func analyze() {
        let fresh = history.withLock { history in
            guard history.pending else { return false }
            let tail = length - history.next
            for channel in 0..<channelCount {
                history.channels[channel].withUnsafeBufferPointer { source in
                    snapshot[channel].withUnsafeMutableBufferPointer { destination in
                        guard let source = source.baseAddress, let destination = destination.baseAddress else { return }
                        destination.update(from: source + history.next, count: tail)
                        (destination + tail).update(from: source, count: history.next)
                    }
                }
            }
            history.pending = false
            return true
        }

        let current = fresh ? analyzer.measure(snapshot) : Self.silence
        for index in smoothed.indices {
            let response: Float = current[index] > smoothed[index] ? 0.75 : 0.23
            smoothed[index] += (current[index] - smoothed[index]) * response
        }
        output.withLock { $0 = smoothed }
    }
}

final class SpectrumFFT {
    let length: Int
    private let order: vDSP_Length
    private let setup: FFTSetup
    private let window: [Float]
    private let bands: [Range<Int>]
    private var real: [Float]
    private var imaginary: [Float]

    init?(sampleRate: Double) {
        guard sampleRate.isFinite, sampleRate >= 8_000 else { return nil }
        order = vDSP_Length(min(15, max(12, Int(ceil(log2(sampleRate / 12))))))
        length = 1 << Int(order)
        guard let setup = vDSP_create_fftsetup(order, FFTRadix(kFFTRadix2)) else { return nil }
        self.setup = setup

        var window = [Float](repeating: 0, count: length)
        vDSP_hann_window(&window, vDSP_Length(length), Int32(vDSP_HANN_DENORM))
        self.window = window
        real = [Float](repeating: 0, count: length / 2)
        imaginary = real

        let binWidth = sampleRate / Double(length)
        let upperFrequency = min(16_000, sampleRate * 0.48)
        var lowerBin = max(1, Int(45 / binWidth))
        var ranges: [Range<Int>] = []
        for index in 1...AudioSpectrum.bandCount {
            let fraction = Double(index) / Double(AudioSpectrum.bandCount)
            let edge = 45 * pow(upperFrequency / 45, fraction)
            let upperBin = max(lowerBin + 1, Int((edge / binWidth).rounded()))
            ranges.append(lowerBin..<upperBin)
            lowerBin = upperBin
        }
        bands = ranges
    }

    deinit { vDSP_destroy_fftsetup(setup) }

    func measure(_ channels: [[Float]]) -> [Float] {
        var peakPower = AudioSpectrum.silence
        let count = vDSP_Length(length / 2)

        for channel in channels {
            channel.withUnsafeBufferPointer { samples in
                window.withUnsafeBufferPointer { weights in
                    // The real FFT takes even and odd samples in separate buffers.
                    vDSP_vmul(samples.baseAddress!, 2, weights.baseAddress!, 2, &real, 1, count)
                    vDSP_vmul(samples.baseAddress! + 1, 2, weights.baseAddress! + 1, 2, &imaginary, 1, count)
                }
            }
            real.withUnsafeMutableBufferPointer { real in
                imaginary.withUnsafeMutableBufferPointer { imaginary in
                    var complex = DSPSplitComplex(realp: real.baseAddress!, imagp: imaginary.baseAddress!)
                    vDSP_fft_zrip(setup, &complex, 1, order, FFTDirection(FFT_FORWARD))
                    for (index, bins) in bands.enumerated() {
                        for bin in bins {
                            let power = real[bin] * real[bin] + imaginary[bin] * imaginary[bin]
                            if power.isFinite { peakPower[index] = max(peakPower[index], power) }
                        }
                    }
                }
            }
        }

        // The Hann window halves coherent gain and the real FFT doubles it.
        // A fixed dBFS scale keeps the bars proportional to playback level.
        let gain = 2 / Float(length)
        return peakPower.map { power in
            let decibels = 10 * log10(max(1e-12, power * gain * gain))
            return min(1, max(0, (decibels + 62) / 54))
        }
    }
}
