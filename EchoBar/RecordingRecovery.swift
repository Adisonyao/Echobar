import AudioToolbox
import Darwin
import Foundation

/// A locked journal survives process termination and also tracks custom save folders.
final class RecordingRecovery {
    private let entry: URL
    private let lock: FileHandle

    static var directory: URL {
        URL.applicationSupportDirectory.appendingPathComponent("EchoBar/Recovery", isDirectory: true)
    }

    init(file: URL, id: UUID) throws {
        try FileManager.default.createDirectory(at: Self.directory, withIntermediateDirectories: true,
                                                attributes: [.posixPermissions: 0o700])
        entry = Self.directory.appendingPathComponent(id.uuidString + ".json")
        let descriptor = Darwin.open(entry.path, O_RDWR | O_CREAT | O_EXCL | O_NOFOLLOW, 0o600)
        guard descriptor >= 0 else { throw Self.ioError() }
        lock = FileHandle(fileDescriptor: descriptor, closeOnDealloc: true)
        do {
            guard flock(descriptor, LOCK_EX | LOCK_NB) == 0 else { throw Self.ioError() }
            try lock.write(contentsOf: JSONEncoder().encode(file.path))
            try lock.synchronize()
        } catch {
            clear()
            throw error
        }
    }

    func clear() {
        try? FileManager.default.removeItem(at: entry)
    }

    static func recoverPending() -> [URL] {
        guard let entries = try? FileManager.default.contentsOfDirectory(
            at: directory, includingPropertiesForKeys: nil
        ) else { return [] }

        return entries.compactMap { entry in
            guard entry.pathExtension == "json",
                  let id = UUID(uuidString: entry.deletingPathExtension().lastPathComponent) else { return nil }
            let descriptor = Darwin.open(entry.path, O_RDWR | O_NOFOLLOW)
            guard descriptor >= 0 else { return nil }
            let lock = FileHandle(fileDescriptor: descriptor, closeOnDealloc: true)
            guard flock(descriptor, LOCK_EX | LOCK_NB) == 0,
                  let data = try? lock.read(upToCount: 32_768),
                  let path = try? JSONDecoder().decode(String.self, from: data),
                  path.hasPrefix("/") else { return nil }

            let file = URL(fileURLWithPath: path)
            guard file.lastPathComponent == ".EchoBar-\(id.uuidString).partial.wav" else { return nil }
            let folder = file.deletingLastPathComponent()
            let destination = folder.appendingPathComponent("EchoBar-Recovered-\(id.uuidString).wav")
            guard FileManager.default.fileExists(atPath: file.path) else {
                // Keep entries for unavailable folders, such as an unplugged external disk.
                if (try? FileManager.default.contentsOfDirectory(atPath: folder.path)) != nil {
                    try? FileManager.default.removeItem(at: entry)
                }
                return nil
            }
            do {
                guard try repairHeaderIfNeeded(file), containsAudio(file) else { return nil }
                try FileManager.default.moveItem(at: file, to: destination)
                try FileManager.default.removeItem(at: entry)
                return destination
            } catch {
                return nil
            }
        }
    }

    /// Core Audio may defer RIFF lengths until dispose, even after writing PCM.
    /// These app-created WAVs put their data chunk last. Recover whole frames
    /// only, and leave files with an unknown structure untouched.
    private static func repairHeaderIfNeeded(_ url: URL) throws -> Bool {
        let descriptor = Darwin.open(url.path, O_RDWR | O_NOFOLLOW | O_NONBLOCK)
        guard descriptor >= 0 else { throw ioError() }
        let file = FileHandle(fileDescriptor: descriptor, closeOnDealloc: true)
        var metadata = stat()
        guard fstat(descriptor, &metadata) == 0, metadata.st_mode & S_IFMT == S_IFREG,
              let header = try file.read(upToCount: 65_536), header.count >= 12,
              header.prefix(4) == Data("RIFF".utf8), header[8..<12] == Data("WAVE".utf8) else { return false }
        let fileLength = UInt64(metadata.st_size)

        func read<T: FixedWidthInteger>(_ type: T.Type, at offset: Int) -> T {
            header.withUnsafeBytes { T(littleEndian: $0.loadUnaligned(fromByteOffset: offset, as: type)) }
        }

        var blockAlignment: UInt64 = 0
        var cursor = 12
        while cursor + 8 <= header.count {
            let name = header[cursor..<(cursor + 4)]
            let declaredSize = read(UInt32.self, at: cursor + 4)
            let payload = cursor + 8
            if name == Data("fmt ".utf8), declaredSize >= 16, payload + 16 <= header.count {
                guard read(UInt16.self, at: payload) == 1 else { return false }
                blockAlignment = UInt64(read(UInt16.self, at: payload + 12))
            }
            if name == Data("data".utf8) {
                guard blockAlignment > 0, fileLength >= UInt64(payload) + blockAlignment else { return false }
                let declaredEnd = UInt64(payload) + UInt64(declaredSize) + UInt64(declaredSize & 1)
                if declaredSize > 0, UInt64(read(UInt32.self, at: 4)) + 8 == fileLength,
                   declaredEnd == fileLength { return true }
                let pcmBytes = (fileLength - UInt64(payload)) / blockAlignment * blockAlignment
                let padding = pcmBytes & 1
                let finalLength = UInt64(payload) + pcmBytes + padding
                guard pcmBytes > 0, finalLength - 8 <= UInt64(UInt32.max) else { return false }

                func writeLength(_ length: UInt64, at offset: UInt64) throws {
                    var value = UInt32(length).littleEndian
                    try file.seek(toOffset: offset)
                    try file.write(contentsOf: withUnsafeBytes(of: &value) { Data($0) })
                }
                try file.truncate(atOffset: finalLength)
                if padding != 0 {
                    try file.seek(toOffset: finalLength - 1)
                    try file.write(contentsOf: Data([0]))
                }
                try writeLength(pcmBytes, at: UInt64(cursor + 4))
                try writeLength(finalLength - 8, at: 4)
                try file.synchronize()
                return true
            }
            cursor = payload + Int(declaredSize) + Int(declaredSize & 1)
        }
        return false
    }

    private static func containsAudio(_ url: URL) -> Bool {
        var file: ExtAudioFileRef?
        guard ExtAudioFileOpenURL(url as CFURL, &file) == noErr, let file else { return false }
        defer { ExtAudioFileDispose(file) }
        var frames: Int64 = 0
        var size = UInt32(MemoryLayout.size(ofValue: frames))
        return ExtAudioFileGetProperty(file, kExtAudioFileProperty_FileLengthFrames, &size, &frames) == noErr && frames > 0
    }

    private static func ioError() -> POSIXError {
        POSIXError(POSIXErrorCode(rawValue: errno) ?? .EIO)
    }
}
