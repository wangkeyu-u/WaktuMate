import Foundation

enum PrayerName: String, CaseIterable, Codable, Identifiable {
    case subuh = "Subuh"
    case zohor = "Zohor"
    case asar = "Asar"
    case maghrib = "Maghrib"
    case isyak = "Isyak"

    var id: String { rawValue }

    var systemImage: String {
        switch self {
        case .subuh:
            return "sunrise.fill"
        case .zohor:
            return "sun.max.fill"
        case .asar:
            return "sun.haze.fill"
        case .maghrib:
            return "sunset.fill"
        case .isyak:
            return "moon.stars.fill"
        }
    }

    func localizedName(_ language: AppLanguage) -> String {
        switch self {
        case .subuh:
            return LocalizedText(english: "Subuh", malay: "Subuh", chinese: "晨礼").text(language)
        case .zohor:
            return LocalizedText(english: "Zohor", malay: "Zohor", chinese: "晌礼").text(language)
        case .asar:
            return LocalizedText(english: "Asar", malay: "Asar", chinese: "晡礼").text(language)
        case .maghrib:
            return LocalizedText(english: "Maghrib", malay: "Maghrib", chinese: "昏礼").text(language)
        case .isyak:
            return LocalizedText(english: "Isyak", malay: "Isyak", chinese: "宵礼").text(language)
        }
    }
}

extension Dictionary where Key == PrayerName, Value == Bool {
    static func prayerDefaults(_ value: Bool) -> [PrayerName: Bool] {
        Dictionary(uniqueKeysWithValues: PrayerName.allCases.map { ($0, value) })
    }

    static func fromStringKeys(_ values: [String: Bool], defaultValue: Bool) -> [PrayerName: Bool] {
        var result = prayerDefaults(defaultValue)

        for (key, value) in values {
            if let prayer = PrayerName(rawValue: key) {
                result[prayer] = value
            }
        }

        return result
    }

    var stringKeyed: [String: Bool] {
        var result: [String: Bool] = [:]

        for (key, value) in self {
            result[key.rawValue] = value
        }

        return result
    }
}
