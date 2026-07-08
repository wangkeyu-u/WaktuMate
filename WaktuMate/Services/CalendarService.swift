import EventKit
import Foundation

final class CalendarService {
    static let shared = CalendarService()

    var message: String?

    private let eventStore = EKEventStore()

    @MainActor
    func addHolidayToCalendar(_ holiday: FaithHoliday, language: AppLanguage) async -> Bool {
        guard let date = holiday.dateValue else {
            message = "Invalid holiday date."
            return false
        }

        let granted = await requestCalendarAccess()
        guard granted else {
            message = LocalizedText(
                english: "Calendar access was not granted.",
                malay: "Akses kalendar tidak diberikan.",
                chinese: "未获得日历访问权限。"
            ).text(language)
            return false
        }

        let event = EKEvent(eventStore: eventStore)
        event.title = holiday.name.text(language)
        event.notes = holiday.notes.text(language)
        event.startDate = date
        event.endDate = AppDateFormatting.malaysiaCalendar.date(byAdding: .day, value: 1, to: date) ?? date
        event.isAllDay = true
        event.calendar = eventStore.defaultCalendarForNewEvents
        event.addAlarm(EKAlarm(relativeOffset: TimeInterval(-holiday.reminderDefaultDaysBefore * 24 * 60 * 60)))

        do {
            try eventStore.save(event, span: .thisEvent)
            message = LocalizedText(
                english: "Added to Apple Calendar.",
                malay: "Ditambah ke Apple Calendar.",
                chinese: "已加入 Apple 日历。"
            ).text(language)
            return true
        } catch {
            message = error.localizedDescription
            return false
        }
    }

    @MainActor
    private func requestCalendarAccess() async -> Bool {
        if #available(iOS 17.0, *) {
            do {
                return try await eventStore.requestFullAccessToEvents()
            } catch {
                return false
            }
        } else {
            return await withCheckedContinuation { continuation in
                eventStore.requestAccess(to: .event) { granted, _ in
                    continuation.resume(returning: granted)
                }
            }
        }
    }
}
