import Foundation
import UserNotifications

final class NotificationService {
    static let shared = NotificationService()

    private let center: UNUserNotificationCenter

    init(center: UNUserNotificationCenter = .current()) {
        self.center = center
    }

    func requestPermission() async -> Bool {
        do {
            return try await center.requestAuthorization(options: [.alert, .sound, .badge])
        } catch {
            return false
        }
    }

    func notificationStatus() async -> UNAuthorizationStatus {
        await center.notificationSettings().authorizationStatus
    }

    func cancelAllPrayerNotifications() {
        center.removePendingNotificationRequests(withIdentifiers: pendingPrayerIdentifiers())
    }

    func cancelHolidayNotifications(for holidays: [FaithHoliday]) {
        center.removePendingNotificationRequests(withIdentifiers: holidays.map(holidayIdentifier))
    }

    func schedulePrayerNotifications(for prayerTime: PrayerTime, settings: NotificationSettings) async {
        cancelAllPrayerNotifications()

        guard settings.isEnabled else {
            return
        }

        let calendar = AppDateFormatting.malaysiaCalendar

        for prayer in PrayerName.allCases where settings.isEnabled(for: prayer) {
            guard let prayerDate = prayerTime.dateTime(for: prayer, calendar: calendar),
                  let fireDate = calendar.date(byAdding: .minute, value: -settings.reminderOffsetMinutes, to: prayerDate),
                  fireDate > Date() else {
                continue
            }

            let content = UNMutableNotificationContent()
            content.title = "\(prayer.rawValue) Prayer Reminder"
            content.body = notificationBody(for: prayer, offset: settings.reminderOffsetMinutes)
            content.sound = .default

            let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: fireDate)
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            let request = UNNotificationRequest(
                identifier: identifier(for: prayer, date: prayerTime.date),
                content: content,
                trigger: trigger
            )

            try? await add(request)
        }
    }

    private func add(_ request: UNNotificationRequest) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            center.add(request) { error in
                if let error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            }
        }
    }

    func scheduleHolidayNotifications(
        holidays: [FaithHoliday],
        language: AppLanguage,
        daysBefore: Int
    ) async -> Int {
        let granted = await requestPermission()
        guard granted else {
            return 0
        }

        cancelHolidayNotifications(for: holidays)

        var scheduled = 0
        let calendar = AppDateFormatting.malaysiaCalendar

        for holiday in holidays {
            guard let holidayDate = holiday.dateValue,
                  let reminderDate = calendar.date(byAdding: .day, value: -daysBefore, to: holidayDate),
                  reminderDate > Date() else {
                continue
            }

            let content = UNMutableNotificationContent()
            content.title = holiday.name.text(language)
            content.body = holidayReminderBody(for: holiday, language: language, daysBefore: daysBefore)
            content.sound = .default

            var components = calendar.dateComponents([.year, .month, .day], from: reminderDate)
            components.hour = 9
            components.minute = 0

            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            let request = UNNotificationRequest(
                identifier: holidayIdentifier(holiday),
                content: content,
                trigger: trigger
            )

            if (try? await add(request)) != nil {
                scheduled += 1
            }
        }

        return scheduled
    }

    private func notificationBody(for prayer: PrayerName, offset: Int) -> String {
        if offset == 0 {
            return "It is time for \(prayer.rawValue)."
        } else {
            return "\(prayer.rawValue) starts in \(offset) minutes."
        }
    }

    private func pendingPrayerIdentifiers() -> [String] {
        let today = AppDateFormatting.dateKey()
        return PrayerName.allCases.map { identifier(for: $0, date: today) }
    }

    private func identifier(for prayer: PrayerName, date: String) -> String {
        "prayer_\(prayer.rawValue.lowercased())_\(date)"
    }

    private func holidayIdentifier(_ holiday: FaithHoliday) -> String {
        "holiday_\(holiday.faith.rawValue)_\(holiday.date)_\(holiday.name.english.replacingOccurrences(of: " ", with: "_").lowercased())"
    }

    private func holidayReminderBody(for holiday: FaithHoliday, language: AppLanguage, daysBefore: Int) -> String {
        switch language {
        case .english:
            return "\(holiday.name.english) is in \(daysBefore) day\(daysBefore == 1 ? "" : "s"). \(holiday.notes.english)"
        case .malay:
            return "\(holiday.name.malay) dalam \(daysBefore) hari. \(holiday.notes.malay)"
        case .chinese:
            return "\(holiday.name.chinese) 将在 \(daysBefore) 天后到来。\(holiday.notes.chinese)"
        }
    }
}
