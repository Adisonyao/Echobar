import AppKit
import SwiftUI
import UserNotifications

@main
struct EchoBarApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var delegate
    @StateObject private var model = RecorderModel.shared

    var body: some Scene {
        Window(L10n.text("app"), id: "recorder") {
            RecorderView(model: model)
                .background(WindowConfiguration(pinned: model.pinned))
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
        .commands {
            CommandGroup(after: .newItem) {
                Button(model.buttonTitle) { model.toggle() }
                    .keyboardShortcut("r", modifiers: .command)
                    .disabled(model.isBusy)
                Button(L10n.text("folder.open")) { model.showFolder() }
                    .keyboardShortcut("o", modifiers: .command)
            }
            CommandGroup(replacing: .appSettings) {
                Button(L10n.text("settings")) { model.showingSettings = true }
                    .keyboardShortcut(",", modifiers: .command)
            }
        }
    }
}

final class AppDelegate: NSObject, NSApplicationDelegate, UNUserNotificationCenterDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        UNUserNotificationCenter.current().delegate = self
        Task { await RecorderModel.shared.recoverRecordings() }
        NSWorkspace.shared.notificationCenter.addObserver(
            self, selector: #selector(willSleep), name: NSWorkspace.willSleepNotification, object: nil
        )
    }

    @objc private func willSleep(_ notification: Notification) {
        Task { await RecorderModel.shared.prepareToQuit() }
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        RecorderModel.shared.quitWhenWindowCloses
    }

    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
        let model = RecorderModel.shared
        guard model.isBusy || model.isRecording else { return .terminateNow }
        Task { @MainActor in
            await model.prepareToQuit()
            sender.reply(toApplicationShouldTerminate: !model.hasError)
        }
        return .terminateLater
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        [.banner, .list]
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        guard let path = response.notification.request.content.userInfo["file"] as? String else { return }
        await MainActor.run { NSWorkspace.shared.activateFileViewerSelecting([URL(fileURLWithPath: path)]) }
    }
}

private struct WindowConfiguration: NSViewRepresentable {
    let pinned: Bool

    func makeNSView(context: Context) -> Configurator { Configurator() }
    func updateNSView(_ nsView: Configurator, context: Context) { nsView.pinned = pinned }

    final class Configurator: NSView {
        var pinned = false {
            didSet { updateWindowLevel() }
        }

        private func updateWindowLevel() {
            let level: NSWindow.Level = pinned ? .floating : .normal
            if let window, window.level != level { window.level = level }
        }

        override func viewDidMoveToWindow() {
            super.viewDidMoveToWindow()
            guard let window else { return }
            window.styleMask.insert(.fullSizeContentView)
            window.titleVisibility = .hidden
            window.titlebarAppearsTransparent = true
            window.titlebarSeparatorStyle = .none
            window.ignoresMouseEvents = false
            window.hasShadow = true
            window.isMovableByWindowBackground = true
            window.standardWindowButton(.zoomButton)?.isHidden = true
            updateWindowLevel()
        }
    }
}

@MainActor
final class RecorderModel: ObservableObject {
    static let shared = RecorderModel()
    enum Phase: Equatable { case ready, starting, recording, saving, saved, failed }
    @Published private(set) var phase: Phase = .ready
    @Published private(set) var started: ContinuousClock.Instant?
    @Published private(set) var duration = 0.0
    @Published private(set) var latest: URL?
    @Published var errorMessage: String?
    @Published private(set) var warning: String?
    @Published var showingSettings = false
    @Published var pinned: Bool {
        didSet { UserDefaults.standard.set(pinned, forKey: Self.pinnedKey) }
    }
    @Published var language: AppLanguage {
        didSet { UserDefaults.standard.set(language.rawValue, forKey: AppLanguage.preferenceKey) }
    }
    @Published var sampleRate: WAVEncoding.SampleRate {
        didSet { UserDefaults.standard.set(sampleRate.rawValue, forKey: Self.sampleRateKey) }
    }
    @Published var bitDepth: WAVEncoding.BitDepth {
        didSet { UserDefaults.standard.set(bitDepth.rawValue, forKey: Self.bitDepthKey) }
    }
    @Published var quitWhenWindowCloses: Bool {
        didSet { UserDefaults.standard.set(quitWhenWindowCloses, forKey: Self.quitWhenClosedKey) }
    }
    @Published private(set) var folder: URL
    private let recorder = SystemAudioRecorder()
    private var operation: Task<Void, Never>?
    private var activity: NSObjectProtocol?
    private static let folderKey = "recordingsFolderPath"
    private static let sampleRateKey = "wavSampleRate"
    private static let bitDepthKey = "wavBitDepth"
    private static let quitWhenClosedKey = "quitWhenWindowCloses"
    private static let pinnedKey = "windowPinned"
    private static let defaultFolder = FileManager.default.urls(for: .musicDirectory, in: .userDomainMask)[0]
        .appendingPathComponent("回聲錄音", isDirectory: true)

    private init() {
        let preferences = UserDefaults.standard
        language = L10n.language
        pinned = preferences.bool(forKey: Self.pinnedKey)
        sampleRate = WAVEncoding.SampleRate(rawValue: preferences.integer(forKey: Self.sampleRateKey)) ?? .source
        bitDepth = WAVEncoding.BitDepth(rawValue: preferences.integer(forKey: Self.bitDepthKey)) ?? .standard
        quitWhenWindowCloses = preferences.bool(forKey: Self.quitWhenClosedKey)
        folder = preferences.string(forKey: Self.folderKey)
            .map { URL(fileURLWithPath: $0, isDirectory: true) } ?? Self.defaultFolder
    }

    var isRecording: Bool { phase == .recording }
    var isBusy: Bool { phase == .starting || phase == .saving }
    var hasError: Bool { phase == .failed }
    var buttonTitle: String { isRecording ? L10n.text("stop") : L10n.text("start") }
    var wavEncoding: WAVEncoding { WAVEncoding(sampleRate: sampleRate, bitDepth: bitDepth) }

    func toggle() {
        guard !isBusy else { return }
        if isRecording {
            stop()
        } else {
            phase = .starting
            duration = 0
            warning = nil
            let destination = folder
            let encoding = wavEncoding
            activity = ProcessInfo.processInfo.beginActivity(options: .suddenTerminationDisabled,
                                                             reason: "Save the active recording")
            operation = Task {
                defer { operation = nil }
                do {
                    try await recorder.start(in: destination, encoding: encoding)
                    started = .now
                    phase = .recording
                } catch {
                    endRecordingActivity()
                    fail(error)
                }
            }
        }
    }

    private func stop() {
        duration = elapsed
        started = nil
        phase = .saving
        operation = Task {
            defer {
                operation = nil
                endRecordingActivity()
            }
            do {
                let result = try await recorder.stop()
                latest = result.url
                warning = result.warning
                phase = .saved
                Task { await notifySaved(result) }
            } catch {
                fail(error)
            }
        }
    }

    func prepareToQuit() async {
        await operation?.value
        if isRecording { stop() }
        await operation?.value
    }

    private func endRecordingActivity() {
        guard let activity else { return }
        ProcessInfo.processInfo.endActivity(activity)
        self.activity = nil
    }

    func recoverRecordings() async {
        let files = await recorder.recover()
        guard let recovered = files.last else { return }
        if phase == .ready {
            latest = recovered
            warning = L10n.text("recovered")
            phase = .saved
        }
        await notifySaved(RecordingOutcome(url: recovered, warning: L10n.text("recovered")))
    }

    var elapsed: Double {
        guard let started else { return duration }
        let components = started.duration(to: .now).components
        return Double(components.seconds) + Double(components.attoseconds) / 1e18
    }

    var frequencyLevels: [Float] { recorder.frequencyLevels }
    var usesDefaultFolder: Bool { folder == Self.defaultFolder }

    func chooseFolder() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.canCreateDirectories = true
        panel.directoryURL = folder
        panel.prompt = L10n.text("folder.choose")
        panel.message = L10n.text("folder.prompt")
        let completion: (NSApplication.ModalResponse) -> Void = { [weak self] response in
            guard response == .OK, let selected = panel.url else { return }
            guard FileManager.default.isWritableFile(atPath: selected.path) else {
                self?.errorMessage = L10n.text("folder.unwritable")
                return
            }
            self?.folder = selected.standardizedFileURL
            UserDefaults.standard.set(selected.standardizedFileURL.path, forKey: Self.folderKey)
        }
        if let window = NSApp.keyWindow ?? NSApp.mainWindow {
            panel.beginSheetModal(for: window, completionHandler: completion)
        } else {
            panel.begin(completionHandler: completion)
        }
    }

    func resetFolder() {
        folder = Self.defaultFolder
        UserDefaults.standard.removeObject(forKey: Self.folderKey)
    }

    func revealLatest() {
        if let latest { NSWorkspace.shared.activateFileViewerSelecting([latest]) }
    }

    func showFolder() {
        do {
            try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
            NSWorkspace.shared.open(folder)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func fail(_ error: Error) {
        started = nil
        errorMessage = error.localizedDescription
        phase = .failed
    }

    private func notifySaved(_ result: RecordingOutcome) async {
        let center = UNUserNotificationCenter.current()
        do {
            let settings = await center.notificationSettings()
            if settings.authorizationStatus == .notDetermined {
                guard try await center.requestAuthorization(options: [.alert]) else { return }
            } else if settings.authorizationStatus == .denied {
                return
            }
            let content = UNMutableNotificationContent()
            content.title = result.warning ?? L10n.text("saved")
            content.body = result.url.lastPathComponent
            content.userInfo = ["file": result.url.path]
            try await center.add(UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil))
        } catch {
            // The saved state and Finder shortcut are available even without notifications.
        }
    }
}
