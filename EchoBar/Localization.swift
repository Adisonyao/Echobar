import Foundation

enum AppLanguage: String, CaseIterable {
    case system
    case english = "en"
    case simplifiedChinese = "zh-Hans"
    case traditionalChinese = "zh-Hant"
    case japanese = "ja"
    case korean = "ko"
    case arabic = "ar"
    case french = "fr"
    case russian = "ru"
    case spanish = "es"
    case german = "de"
    case portuguese = "pt-BR"
    case italian = "it"
    case hindi = "hi"

    static let preferenceKey = "appLanguage"

    var displayName: String {
        switch self {
        case .system: L10n.text("system")
        case .english: "English"
        case .simplifiedChinese: "简体中文"
        case .traditionalChinese: "繁體中文"
        case .japanese: "日本語"
        case .korean: "한국어"
        case .arabic: "العربية"
        case .french: "Français"
        case .russian: "Русский"
        case .spanish: "Español"
        case .german: "Deutsch"
        case .portuguese: "Português (Brasil)"
        case .italian: "Italiano"
        case .hindi: "हिन्दी"
        }
    }

    var resolved: Self {
        guard self == .system else { return self }
        let supported = Self.allCases.filter { $0 != .system }.map(\.rawValue)
        let best = Bundle.preferredLocalizations(from: supported, forPreferences: Locale.preferredLanguages).first
        return best.flatMap(Self.init(rawValue:)) ?? .english
    }
}

enum L10n {
    private static let bundles: [AppLanguage: Bundle] = Dictionary(uniqueKeysWithValues:
        AppLanguage.allCases.compactMap { language in
            guard let url = Bundle.main.url(forResource: language.rawValue, withExtension: "lproj"),
                  let bundle = Bundle(url: url) else { return nil }
            return (language, bundle)
        }
    )

    static var language: AppLanguage {
        UserDefaults.standard.string(forKey: AppLanguage.preferenceKey)
            .flatMap(AppLanguage.init(rawValue:)) ?? .system
    }

    static var locale: Locale { Locale(identifier: language.resolved.rawValue) }

    static func text(_ key: String, _ arguments: CVarArg...) -> String {
        let bundle = bundles[language.resolved] ?? bundles[.english] ?? .main
        let value = bundle.localizedString(forKey: key, value: nil, table: nil)
        return arguments.isEmpty ? value : String(format: value, locale: locale, arguments: arguments)
    }
}
