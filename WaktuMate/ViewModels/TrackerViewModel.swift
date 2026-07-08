import Foundation

@MainActor
final class TrackerViewModel: ObservableObject {
    @Published var todayRecord: DailyPrayerRecord
    @Published var weeklyCompletionRate: Double = 0
    @Published var currentStreak: Int = 0

    private let storage: StorageService

    init(storage: StorageService = .shared) {
        self.storage = storage
        self.todayRecord = storage.loadRecord(for: AppDateFormatting.dateKey())
        calculateStats()
    }

    var completedCount: Int {
        todayRecord.completedCount
    }

    func loadTodayRecord() {
        todayRecord = storage.loadRecord(for: AppDateFormatting.dateKey())
        calculateStats()
    }

    func togglePrayer(_ prayer: PrayerName) {
        todayRecord.toggle(prayer)
        storage.saveRecord(todayRecord)
        calculateStats()
    }

    private func calculateStats() {
        let records = storage.loadAllRecords()
        weeklyCompletionRate = calculateWeeklyCompletionRate(records: records)
        currentStreak = calculateCurrentStreak(records: records)
    }

    private func calculateWeeklyCompletionRate(records: [String: DailyPrayerRecord]) -> Double {
        let calendar = AppDateFormatting.malaysiaCalendar
        let today = Date()
        let dates = (0..<7).compactMap { offset in
            calendar.date(byAdding: .day, value: -offset, to: today)
        }

        let completed = dates.reduce(0) { total, date in
            let key = AppDateFormatting.dateKey(for: date)
            return total + (records[key]?.completedCount ?? (key == todayRecord.date ? todayRecord.completedCount : 0))
        }

        return Double(completed) / Double(PrayerName.allCases.count * dates.count)
    }

    private func calculateCurrentStreak(records: [String: DailyPrayerRecord]) -> Int {
        let calendar = AppDateFormatting.malaysiaCalendar
        var streak = 0
        var cursor = Date()

        while true {
            let key = AppDateFormatting.dateKey(for: cursor)
            let record = key == todayRecord.date ? todayRecord : records[key]

            guard record?.isComplete == true else {
                break
            }

            streak += 1

            guard let previousDay = calendar.date(byAdding: .day, value: -1, to: cursor) else {
                break
            }

            cursor = previousDay
        }

        return streak
    }
}
