import AppKit
import SwiftUI

struct RecorderView: View {
    @ObservedObject var model: RecorderModel
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let recordRed = Color(red: 1, green: 0.29, blue: 0.35)
    // A 24-point button with this inset lines up with the title-bar controls.
    private let headerInset: CGFloat = 4

    var body: some View {
        ZStack {
            if model.showingSettings {
                settingsPane.transition(pageTransition(offset: 18))
            } else {
                recordingPane.transition(pageTransition(offset: -18))
            }
        }
        .frame(width: 246, height: 206)
        .environment(\.layoutDirection, .leftToRight)
        .clipped()
        .overlay(alignment: .top) {
            header.alignmentGuide(.top) { dimensions in dimensions[.bottom] }
        }
        .animation(reduceMotion ? nil : .spring(response: 0.32, dampingFraction: 0.86), value: model.showingSettings)
        .onExitCommand {
            if model.showingSettings { model.showingSettings = false }
        }
        .alert(L10n.text("app"), isPresented: Binding(get: { model.errorMessage != nil }, set: {
            if !$0 { model.errorMessage = nil }
        })) {
            Button(L10n.text("ok"), role: .cancel) { model.errorMessage = nil }
        } message: {
            Text(model.errorMessage ?? "")
        }
    }

    private var header: some View {
        ZStack {
            Text(model.showingSettings ? L10n.text("settings") : L10n.text("app"))
                .font(.system(size: 12, weight: .semibold))
                .lineLimit(1)
                .minimumScaleFactor(0.7)
                .frame(maxWidth: 76)
                .foregroundStyle(.secondary)
                .contentTransition(.opacity)

            HStack(spacing: 3) {
                Spacer()
                headerButton(
                    model.pinned ? "pin.fill" : "pin",
                    title: model.pinned ? L10n.text("unpin") : L10n.text("pin"),
                    selected: model.pinned,
                    highlight: Color(nsColor: .systemYellow)
                ) {
                    model.pinned.toggle()
                }
                headerButton("folder", title: L10n.text("folder.open"), action: model.showFolder)
                headerButton(
                    model.showingSettings ? "gearshape.fill" : "gearshape",
                    title: model.showingSettings ? L10n.text("back") : L10n.text("settings"),
                    selected: model.showingSettings
                ) {
                    model.showingSettings.toggle()
                }
            }
            .padding([.top, .trailing], headerInset)
            .frame(maxHeight: .infinity, alignment: .top)
        }
        .frame(height: 32)
    }

    private func headerButton(_ symbol: String, title: String, selected: Bool = false,
                              highlight: Color = .accentColor,
                              action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: symbol)
                .font(.system(size: 13, weight: .medium))
                .contentTransition(.symbolEffect(.replace))
                .foregroundStyle(selected ? highlight : Color.secondary)
                .frame(width: 24, height: 24)
                .background(selected ? highlight.opacity(0.15) : .clear,
                            in: RoundedRectangle(cornerRadius: 7))
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .help(title)
        .accessibilityLabel(title)
        .accessibilityAddTraits(selected ? .isSelected : [])
    }

    private var recordingPane: some View {
        VStack(spacing: 0) {
            TimelineView(.animation(minimumInterval: reduceMotion ? 0.12 : 1.0 / 30, paused: !model.isRecording)) { _ in
                let time = timecode
                VStack(spacing: 6) {
                    Text(time)
                        .font(.system(size: 35, weight: .medium, design: .monospaced))
                        .monospacedDigit()
                        .tracking(-2)
                        .lineLimit(1)
                        .minimumScaleFactor(0.65)
                        .padding(.horizontal, 12)
                        .foregroundStyle(.primary)
                        .accessibilityLabel(L10n.text("time", time))
                    SpectrumBars(
                        levels: model.isRecording ? model.frequencyLevels : AudioSpectrum.silence,
                        active: model.isRecording,
                        tint: recordRed,
                        reduceMotion: reduceMotion
                    )
                }
            }

            recordButton
                .padding(.top, 9)

            statusLine
                .padding(.top, 8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var settingsPane: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                settingsSection("language") {
                    Picker(L10n.text("language"), selection: $model.language) {
                        ForEach(AppLanguage.allCases, id: \.self) { language in
                            Text(language.displayName).tag(language)
                        }
                    }
                    .labelsHidden()
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                Divider()
                settingsSection("folder.label") {
                    Text((model.folder.path as NSString).abbreviatingWithTildeInPath)
                        .font(.callout.monospaced())
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                        .truncationMode(.middle)
                        .textSelection(.enabled)
                        .help(model.folder.path)
                    ViewThatFits(in: .horizontal) {
                        HStack { folderActions }
                        VStack(alignment: .leading) { folderActions }
                    }
                }
                Divider()
                settingsSection("format") {
                    Text(L10n.text("rate"))
                    Picker(L10n.text("rate"), selection: $model.sampleRate) {
                        ForEach(WAVEncoding.SampleRate.allCases, id: \.self) { rate in
                            Text(rate.title).tag(rate)
                        }
                    }
                    .labelsHidden()

                    Text(L10n.text("depth"))
                    Picker(L10n.text("depth"), selection: $model.bitDepth) {
                        ForEach(WAVEncoding.BitDepth.allCases, id: \.self) { depth in
                            Text(depth.title).tag(depth)
                        }
                    }
                    .labelsHidden()

                    Text(L10n.text("size", model.wavEncoding.estimatedMegabytesPerHour.formatted(.number.locale(L10n.locale))))
                        .foregroundStyle(.secondary)
                        .help(L10n.text(model.sampleRate == .source ? "size.source" : "size.stereo"))
                    if model.isRecording || model.isBusy {
                        Text(L10n.text("next"))
                            .foregroundStyle(.secondary)
                    }
                }
                Divider()
                settingsSection("window") {
                    Toggle(isOn: $model.quitWhenWindowCloses) {
                        Text(L10n.text("quit"))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .toggleStyle(.switch)
                }
            }
            .font(.callout)
            .controlSize(.small)
            .padding(14)
        }
        .environment(\.layoutDirection, model.language.resolved == .arabic ? .rightToLeft : .leftToRight)
    }

    @ViewBuilder
    private var folderActions: some View {
        Button(L10n.text("folder.change"), action: model.chooseFolder)
        if !model.usesDefaultFolder {
            Button(L10n.text("folder.reset"), action: model.resetFolder)
        }
    }

    private func settingsSection<Content: View>(
        _ title: String, @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 7) {
            Text(L10n.text(title))
                .font(.callout.weight(.semibold))
                .accessibilityAddTraits(.isHeader)
            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var recordButton: some View {
        Button(action: model.toggle) {
            recordSurface
        }
        .buttonStyle(.plain)
        .frame(width: 78, height: 78)
        .disabled(model.isBusy)
        .help(model.buttonTitle + "（⌘R）")
        .accessibilityLabel(model.isBusy ? statusTitle : model.buttonTitle)
    }

    @ViewBuilder
    private var recordSurface: some View {
        let shape = Circle()
        let face = recordGlyph
            .frame(width: 74, height: 74)
            .background(recordRed.opacity(0.13), in: shape)
            .contentShape(shape)

        if #available(macOS 26, *) {
            face.glassEffect(.regular.tint(recordRed.opacity(0.15)).interactive(), in: shape)
        } else {
            face.background(.regularMaterial, in: shape)
        }
    }

    private var recordGlyph: some View {
        ZStack {
            if model.isBusy {
                ProgressView().controlSize(.regular)
            } else {
                RoundedRectangle(cornerRadius: model.isRecording ? 6 : 18, style: .continuous)
                    .fill(recordRed)
                    .frame(width: model.isRecording ? 24 : 34, height: model.isRecording ? 24 : 34)
            }
        }
        .animation(reduceMotion ? nil : .spring(response: 0.32, dampingFraction: 0.78), value: model.phase)
    }

    private var statusLine: some View {
        Group {
            if model.phase == .saved {
                Button(action: model.revealLatest) {
                    Label(statusTitle, systemImage: "arrow.up.right")
                }
                .buttonStyle(.plain)
                .foregroundStyle(model.warning == nil ? Color(nsColor: .systemGreen) : .secondary)
                .help(L10n.text("folder.reveal"))
            } else {
                Text(statusTitle)
                    .foregroundStyle(model.isRecording ? recordRed : .secondary)
            }
        }
        .font(.system(size: 11, weight: .medium))
        .lineLimit(2)
        .minimumScaleFactor(0.8)
        .multilineTextAlignment(.center)
        .frame(width: 224, height: 24)
    }

    private var statusTitle: String {
        switch model.phase {
        case .ready: L10n.text("ready")
        case .starting: L10n.text("preparing")
        case .recording: L10n.text("recording")
        case .saving: L10n.text("saving")
        case .saved: model.warning ?? L10n.text("saved")
        case .failed: L10n.text("retry")
        }
    }

    private var timecode: String {
        let seconds = Int(max(0, model.elapsed))
        if seconds >= 3600 {
            return String(format: "%02d:%02d:%02d", seconds / 3600, (seconds / 60) % 60, seconds % 60)
        }
        return String(format: "%02d:%02d", seconds / 60, seconds % 60)
    }

    private func pageTransition(offset: CGFloat) -> AnyTransition {
        reduceMotion ? .identity : .opacity.combined(with: .offset(x: offset))
    }
}

private struct SpectrumBars: View {
    let levels: [Float]
    let active: Bool
    let tint: Color
    let reduceMotion: Bool

    var body: some View {
        HStack(spacing: 8) {
            ForEach(levels.indices, id: \.self) { index in
                let level = Double(levels[index])
                Capsule()
                    .fill(active && level > 0.015 ? tint.opacity(0.32 + level * 0.68) : Color.secondary.opacity(0.27))
                    .frame(width: 5, height: 3 + 27 * level)
            }
        }
        .frame(height: 30)
        .animation(reduceMotion ? nil : .easeOut(duration: 0.07), value: levels)
        .accessibilityLabel(L10n.text("spectrum"))
    }
}
