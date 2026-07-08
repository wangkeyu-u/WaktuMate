import Foundation

@MainActor
final class TodayViewModel: ObservableObject {
    @Published var selectedZone: PrayerZone
    @Published var todayPrayerTime: PrayerTime?
    @Published var nextPrayerName: PrayerName?
    @Published var nextPrayerTime: Date?
    @Published var countdownText = "--:--:--"
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var uses24HourTime: Bool

    private var prayerTimes: [PrayerTime] = []
    private var timer: Timer?
    private let service: PrayerTimeService
    private let storage: StorageService
    private let notificationService: NotificationService

    init(
        service: PrayerTimeService = PrayerTimeService(),
        storage: StorageService = .shared,
        notificationService: NotificationService = .shared
    ) {
        self.service = service
        self.storage = storage
        self.notificationService = notificationService
        self.selectedZone = storage.selectedZone()
        self.uses24HourTime = storage.loadNotificationSettings().uses24HourTime
        startCountdownTimer()
    }

    deinit {
        timer?.invalidate()
    }

    var currentDateText: String {
        AppDateFormatting.longDateFormatter.string(from: Date())
    }

    var nextPrayerTimeText: String {
        guard let nextPrayerTime else {
            return "--:--"
        }

        let rawTime = AppDateFormatting.time24Formatter.string(from: nextPrayerTime)
        return AppDateFormatting.displayTime(rawTime, uses24HourTime: uses24HourTime)
    }

    func loadTodayPrayerTimes() async {
        isLoading = true
        errorMessage = nil
        uses24HourTime = storage.loadNotificationSettings().uses24HourTime
        selectedZone = storage.selectedZone()

        defer {
            isLoading = false
        }

        do {
            let calendar = AppDateFormatting.malaysiaCalendar
            let components = calendar.dateComponents([.year, .month], from: Date())
            let month = components.month ?? 1
            let year = components.year ?? 2026

            prayerTimes = try await service.fetchPrayerTimes(zone: selectedZone.id, month: month, year: year)
            if let fallbackMessage = service.lastFallbackMessage {
                errorMessage = fallbackMessage
            }

            let todayKey = AppDateFormatting.dateKey()
            todayPrayerTime = prayerTimes.first { $0.date == todayKey } ?? prayerTimes.first

            if todayPrayerTime?.date != todayKey {
                errorMessage = errorMessage ?? "Current date was not found. Showing available sample data."
            }

            calculateNextPrayer()
            await scheduleNotificationsIfPossible()
        } catch {
            todayPrayerTime = nil
            nextPrayerName = nil
            nextPrayerTime = nil
            countdownText = "--:--:--"
            errorMessage = error.localizedDescription
        }
    }

    func refresh() {
        Task {
            await loadTodayPrayerTimes()
        }
    }

    func syncSelectedZoneIfNeeded() {
        let storedZone = storage.selectedZone()
        let storedTimeFormat = storage.loadNotificationSettings().uses24HourTime

        if storedZone != selectedZone || storedTimeFormat != uses24HourTime {
            selectedZone = storedZone
            uses24HourTime = storedTimeFormat
            refresh()
        }
    }

    func calculateNextPrayer(referenceDate: Date = Date()) {
        guard let todayPrayerTime else {
            countdownText = "--:--:--"
            return
        }

        let calendar = AppDateFormatting.malaysiaCalendar

        if let upcoming = PrayerName.allCases.compactMap({ prayer -> (PrayerName, Date)? in
            guard let date = todayPrayerTime.dateTime(for: prayer, calendar: calendar) else {
                return nil
            }
            return (prayer, date)
        }).first(where: { $0.1 > referenceDate }) {
            nextPrayerName = upcoming.0
            nextPrayerTime = upcoming.1
            updateCountdown(referenceDate: referenceDate)
            return
        }

        if let tomorrow = calendar.date(byAdding: .day, value: 1, to: referenceDate),
           let tomorrowPrayerTime = prayerTimes.first(where: { $0.date == AppDateFormatting.dateKey(for: tomorrow) }),
           let subuh = tomorrowPrayerTime.dateTime(for: .subuh, calendar: calendar) {
            nextPrayerName = .subuh
            nextPrayerTime = subuh
            updateCountdown(referenceDate: referenceDate)
            return
        }

        if let subuh = todayPrayerTime.dateTime(for: .subuh, calendar: calendar),
           let nextSubuh = calendar.date(byAdding: .day, value: 1, to: subuh) {
            nextPrayerName = .subuh
            nextPrayerTime = nextSubuh
            updateCountdown(referenceDate: referenceDate)
        }
    }

    private func startCountdownTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.calculateNextPrayer()
            }
        }
    }

    private func updateCountdown(referenceDate: Date) {
        guard let nextPrayerTime else {
            countdownText = "--:--:--"
            return
        }

        let seconds = max(0, Int(nextPrayerTime.timeIntervalSince(referenceDate)))
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let remainingSeconds = seconds % 60
        countdownText = String(format: "%02dh %02dm %02ds", hours, minutes, remainingSeconds)
    }

    private func scheduleNotificationsIfPossible() async {
        guard let todayPrayerTime else {
            return
        }

        let settings = storage.loadNotificationSettings()
        await notificationService.schedulePrayerNotifications(for: todayPrayerTime, settings: settings)
    }
}
