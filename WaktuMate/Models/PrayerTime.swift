import Foundation

struct PrayerTime: Codable, Identifiable, Equatable {
    var id: String { date }

    let date: String
    let hijri: String?
    let day: String?
    let subuh: String
    let syuruk: String
    let zohor: String
    let asar: String
    let maghrib: String
    let isyak: String

    var displayRows: [PrayerDisplayRow] {
        [
            PrayerDisplayRow(id: "subuh", title: "Subuh", time: subuh, systemImage: "sunrise.fill", prayer: .subuh),
            PrayerDisplayRow(id: "syuruk", title: "Syuruk", time: syuruk, systemImage: "sun.and.horizon.fill", prayer: nil),
            PrayerDisplayRow(id: "zohor", title: "Zohor", time: zohor, systemImage: "sun.max.fill", prayer: .zohor),
            PrayerDisplayRow(id: "asar", title: "Asar", time: asar, systemImage: "sun.haze.fill", prayer: .asar),
            PrayerDisplayRow(id: "maghrib", title: "Maghrib", time: maghrib, systemImage: "sunset.fill", prayer: .maghrib),
            PrayerDisplayRow(id: "isyak", title: "Isyak", time: isyak, systemImage: "moon.stars.fill", prayer: .isyak)
        ]
    }

    func timeString(for prayer: PrayerName) -> String {
        switch prayer {
        case .subuh:
            return subuh
        case .zohor:
            return zohor
        case .asar:
            return asar
        case .maghrib:
            return maghrib
        case .isyak:
            return isyak
        }
    }

    func dateTime(for prayer: PrayerName, calendar: Calendar = AppDateFormatting.malaysiaCalendar) -> Date? {
        dateTime(forTimeString: timeString(for: prayer), calendar: calendar)
    }

    func dateTime(forTimeString timeString: String, calendar: Calendar = AppDateFormatting.malaysiaCalendar) -> Date? {
        let dateParts = date.split(separator: "-").compactMap { Int($0) }
        let timeParts = timeString.split(separator: ":").compactMap { Int($0) }

        guard dateParts.count == 3, timeParts.count >= 2 else {
            return nil
        }

        var components = DateComponents()
        components.calendar = calendar
        components.timeZone = calendar.timeZone
        components.year = dateParts[0]
        components.month = dateParts[1]
        components.day = dateParts[2]
        components.hour = timeParts[0]
        components.minute = timeParts[1]

        return calendar.date(from: components)
    }
}

struct PrayerDisplayRow: Identifiable, Equatable {
    let id: String
    let title: String
    let time: String
    let systemImage: String
    let prayer: PrayerName?
}
