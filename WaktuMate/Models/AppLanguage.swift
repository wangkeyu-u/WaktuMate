import Foundation

enum AppLanguage: String, CaseIterable, Codable, Identifiable {
    case english
    case malay
    case chinese

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .english:
            return "English"
        case .malay:
            return "Bahasa Melayu"
        case .chinese:
            return "中文"
        }
    }

    var interfaceDescription: String {
        switch self {
        case .english:
            return "Use English throughout WaktuMate."
        case .malay:
            return "Gunakan Bahasa Melayu dalam WaktuMate."
        case .chinese:
            return "在 WaktuMate 中使用中文。"
        }
    }

    static var preferredDefault: AppLanguage {
        let preferredLanguage = Locale.preferredLanguages.first?.lowercased() ?? ""

        if preferredLanguage.hasPrefix("ms") {
            return .malay
        }

        if preferredLanguage.hasPrefix("zh") {
            return .chinese
        }

        return .english
    }
}

struct LocalizedText: Codable, Hashable {
    let english: String
    let malay: String
    let chinese: String

    func text(_ language: AppLanguage) -> String {
        switch language {
        case .english:
            return english
        case .malay:
            return malay
        case .chinese:
            return chinese
        }
    }
}

extension String {
    static func localized(_ english: String, _ malay: String, _ chinese: String, language: AppLanguage) -> String {
        LocalizedText(english: english, malay: malay, chinese: chinese).text(language)
    }
}
