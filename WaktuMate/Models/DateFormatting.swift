import Foundation

enum AppDateFormatting {
    static let malaysiaTimeZone = TimeZone(identifier: "Asia/Kuala_Lumpur") ?? .current

    static var malaysiaCalendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = malaysiaTimeZone
        return calendar
    }

    static let dateKeyFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = malaysiaCalendar
        formatter.timeZone = malaysiaTimeZone
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    static let weekdayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = malaysiaCalendar
        formatter.timeZone = malaysiaTimeZone
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "EEEE"
        return formatter
    }()

    static let longDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = malaysiaCalendar
        formatter.timeZone = malaysiaTimeZone
        formatter.locale = Locale(identifier: "en_MY")
        formatter.dateStyle = .full
        formatter.timeStyle = .none
        return formatter
    }()

    static let time24Formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = malaysiaCalendar
        formatter.timeZone = malaysiaTimeZone
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "HH:mm"
        return formatter
    }()

    static let time12Formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = malaysiaCalendar
        formatter.timeZone = malaysiaTimeZone
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "h:mm a"
        return formatter
    }()

    static func dateKey(for date: Date = Date()) -> String {
        dateKeyFormatter.string(from: date)
    }

    static func displayTime(_ value: String, uses24HourTime: Bool) -> String {
        guard !uses24HourTime, let date = time24Formatter.date(from: value) else {
            return value
        }

        return time12Formatter.string(from: date)
    }
}

extension Date {
    var appDateKey: String {
        AppDateFormatting.dateKey(for: self)
    }
}
