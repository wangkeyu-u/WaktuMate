import Foundation

@MainActor
final class SettingsViewModel: ObservableObject {
    @Published var selectedZone: PrayerZone
    @Published var notificationsEnabled: Bool
    @Published var enabledPrayers: [PrayerName: Bool]
    @Published var reminderOffsetMinutes: Int
    @Published var uses24HourTime: Bool
    @Published var permissionMessage: String?
    @Published var personalProfile: FaithPersonalProfile
    @Published var practiceStats: FaithPracticeStats
    @Published var holidayRemindersEnabled: Bool
    @Published var holidayReminderDaysBefore: Int
    @Published var holidayMessage: String?

    let reminderOptions = [0, 5, 10, 15, 30]
    let holidayReminderOptions = [1, 2, 3, 5, 7]

    private let storage: StorageService
    private let notificationService: NotificationService
    private let calendarService: CalendarService

    init(
        storage: StorageService = .shared,
        notificationService: NotificationService = .shared,
        calendarService: CalendarService = .shared
    ) {
        self.storage = storage
        self.notificationService = notificationService
        self.calendarService = calendarService

        let settings = storage.loadNotificationSettings()
        selectedZone = storage.selectedZone()
        notificationsEnabled = settings.isEnabled
        enabledPrayers = settings.enabledPrayers
        reminderOffsetMinutes = settings.reminderOffsetMinutes
        uses24HourTime = settings.uses24HourTime
        let faith = storage.selectedFaithProfile().id
        personalProfile = storage.loadPersonalProfile(for: faith)
        practiceStats = storage.practiceStats(for: faith)
        holidayRemindersEnabled = storage.holidayRemindersEnabled()
        holidayReminderDaysBefore = storage.holidayReminderDaysBefore()
    }

    func reloadProfileScopedData(for faith: FaithTradition) {
        personalProfile = storage.loadPersonalProfile(for: faith)
        practiceStats = storage.practiceStats(for: faith)
        holidayRemindersEnabled = storage.holidayRemindersEnabled()
        holidayReminderDaysBefore = storage.holidayReminderDaysBefore()
    }

    func updateZone(_ zone: PrayerZone) {
        selectedZone = zone
        storage.saveSelectedZone(zone)
    }

    func setNotificationsEnabled(_ isEnabled: Bool) {
        if isEnabled {
            Task {
                let granted = await notificationService.requestPermission()
                notificationsEnabled = granted
                permissionMessage = granted ? "Notification permission granted." : "Notification permission was not granted."
                saveSettings()
            }
        } else {
            notificationsEnabled = false
            notificationService.cancelAllPrayerNotifications()
            saveSettings()
        }
    }

    func setPrayer(_ prayer: PrayerName, enabled: Bool) {
        enabledPrayers[prayer] = enabled
        saveSettings()
    }

    func setReminderOffset(_ minutes: Int) {
        reminderOffsetMinutes = minutes
        saveSettings()
    }

    func setUses24HourTime(_ uses24HourTime: Bool) {
        self.uses24HourTime = uses24HourTime
        saveSettings()
    }

    func clearLocalData() {
        storage.clearAllData()
        notificationService.cancelAllPrayerNotifications()

        let settings = NotificationSettings.default
        selectedZone = .defaultZone
        notificationsEnabled = settings.isEnabled
        enabledPrayers = settings.enabledPrayers
        reminderOffsetMinutes = settings.reminderOffsetMinutes
        uses24HourTime = settings.uses24HourTime
        permissionMessage = "Local data cleared."
        personalProfile = .empty
        practiceStats = storage.practiceStats(for: .islam)
        holidayRemindersEnabled = storage.holidayRemindersEnabled()
        holidayReminderDaysBefore = storage.holidayReminderDaysBefore()
    }

    func savePersonalProfile(for faith: FaithTradition) {
        storage.savePersonalProfile(personalProfile, for: faith)
        practiceStats = storage.practiceStats(for: faith)
    }

    func setHolidayRemindersEnabled(_ isEnabled: Bool, faith: FaithTradition, language: AppLanguage) {
        holidayRemindersEnabled = isEnabled
        storage.saveHolidayRemindersEnabled(isEnabled)

        if isEnabled {
            scheduleHolidayReminders(faith: faith, language: language)
        } else {
            notificationService.cancelHolidayNotifications(for: FaithHoliday.holidays(for: faith))
            holidayMessage = LocalizedText(
                english: "Holiday reminders disabled.",
                malay: "Peringatan perayaan dimatikan.",
                chinese: "节日提醒已关闭。"
            ).text(language)
        }
    }

    func setHolidayReminderDaysBefore(_ days: Int, faith: FaithTradition, language: AppLanguage) {
        holidayReminderDaysBefore = days
        storage.saveHolidayReminderDaysBefore(days)

        if holidayRemindersEnabled {
            scheduleHolidayReminders(faith: faith, language: language)
        }
    }

    func scheduleHolidayReminders(faith: FaithTradition, language: AppLanguage) {
        let holidays = FaithHoliday.upcoming(for: faith, limit: 8)
        Task {
            let count = await notificationService.scheduleHolidayNotifications(
                holidays: holidays,
                language: language,
                daysBefore: holidayReminderDaysBefore
            )
            holidayMessage = LocalizedText(
                english: "\(count) holiday reminder(s) scheduled.",
                malay: "\(count) peringatan perayaan dijadualkan.",
                chinese: "已安排 \(count) 个节日提醒。"
            ).text(language)
        }
    }

    func addHolidayToCalendar(_ holiday: FaithHoliday, language: AppLanguage) {
        Task {
            _ = await calendarService.addHolidayToCalendar(holiday, language: language)
            holidayMessage = calendarService.message
        }
    }

    private func saveSettings() {
        let settings = NotificationSettings(
            isEnabled: notificationsEnabled,
            enabledPrayers: enabledPrayers,
            reminderOffsetMinutes: reminderOffsetMinutes,
            uses24HourTime: uses24HourTime
        )
        storage.saveNotificationSettings(settings)
    }
}
