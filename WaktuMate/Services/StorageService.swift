import Foundation

final class StorageService {
    static let shared = StorageService()

    private enum Keys {
        static let selectedZoneID = "selectedZoneID"
        static let notificationSettings = "notificationSettings"
        static let prayerRecords = "prayerRecords"
        static let tasbihCount = "tasbihCount"
        static let tasbihTarget = "tasbihTarget"
        static let tasbihDailyTotals = "tasbihDailyTotals"
        static let selectedFaithProfileID = "selectedFaithProfileID"
        static let hasCompletedOnboarding = "hasCompletedOnboarding"
        static let selectedLanguage = "selectedLanguage"
        static let hasSelectedInitialLanguage = "hasSelectedInitialLanguage"
        static let appOpenDates = "appOpenDates"
        static let personalProfiles = "personalProfiles"
        static let practiceTimerMinutes = "practiceTimerMinutes"
        static let holidayRemindersEnabled = "holidayRemindersEnabled"
        static let holidayReminderDaysBefore = "holidayReminderDaysBefore"
    }

    private let defaults: UserDefaults
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func selectedZone() -> PrayerZone {
        let id = defaults.string(forKey: Keys.selectedZoneID) ?? PrayerZone.defaultZone.id
        return PrayerZone.zone(for: id)
    }

    func saveSelectedZone(_ zone: PrayerZone) {
        defaults.set(zone.id, forKey: Keys.selectedZoneID)
    }

    func selectedFaithProfile() -> FaithProfile {
        let id = defaults.string(forKey: Keys.selectedFaithProfileID) ?? FaithProfile.default.id.rawValue
        return FaithProfile.profile(for: id)
    }

    func saveSelectedFaithProfile(_ profile: FaithProfile) {
        defaults.set(profile.id.rawValue, forKey: Keys.selectedFaithProfileID)
    }

    func hasCompletedOnboarding() -> Bool {
        defaults.bool(forKey: Keys.hasCompletedOnboarding)
    }

    func saveHasCompletedOnboarding(_ isCompleted: Bool) {
        defaults.set(isCompleted, forKey: Keys.hasCompletedOnboarding)
    }

    func hasSelectedInitialLanguage() -> Bool {
        defaults.bool(forKey: Keys.hasSelectedInitialLanguage)
    }

    func saveHasSelectedInitialLanguage(_ isSelected: Bool) {
        defaults.set(isSelected, forKey: Keys.hasSelectedInitialLanguage)
    }

    func selectedLanguage() -> AppLanguage {
        let value = defaults.string(forKey: Keys.selectedLanguage) ?? AppLanguage.preferredDefault.rawValue
        return AppLanguage(rawValue: value) ?? .english
    }

    func saveSelectedLanguage(_ language: AppLanguage) {
        defaults.set(language.rawValue, forKey: Keys.selectedLanguage)
    }

    func markAppOpened(on date: Date = Date()) {
        var dates = appOpenDates()
        dates.insert(AppDateFormatting.dateKey(for: date))
        defaults.set(Array(dates), forKey: Keys.appOpenDates)
    }

    func appOpenDates() -> Set<String> {
        Set(defaults.stringArray(forKey: Keys.appOpenDates) ?? [])
    }

    func loadPersonalProfile(for faith: FaithTradition) -> FaithPersonalProfile {
        loadPersonalProfiles()[faith.rawValue] ?? .empty
    }

    func savePersonalProfile(_ profile: FaithPersonalProfile, for faith: FaithTradition) {
        var profiles = loadPersonalProfiles()
        profiles[faith.rawValue] = profile
        savePersonalProfiles(profiles)
    }

    func addPracticeTimerMinutes(_ minutes: Int, for faith: FaithTradition) {
        guard minutes > 0 else {
            return
        }

        var totals = loadPracticeTimerMinutes()
        totals[faith.rawValue, default: 0] += minutes
        defaults.set(totals, forKey: Keys.practiceTimerMinutes)
    }

    func practiceTimerMinutes(for faith: FaithTradition) -> Int {
        loadPracticeTimerMinutes()[faith.rawValue] ?? 0
    }

    func practiceStats(for faith: FaithTradition) -> FaithPracticeStats {
        let records = loadAllRecords()
        let trackerCompletedDays = records.values.filter { $0.isComplete }.count
        let tasbihTotal = loadTasbihDailyTotals().values.reduce(0, +)

        return FaithPracticeStats(
            activeDays: appOpenDates().count,
            trackerCompletedDays: trackerCompletedDays,
            tasbihTotal: faith == .islam ? tasbihTotal : 0,
            timerMinutes: practiceTimerMinutes(for: faith)
        )
    }

    func holidayRemindersEnabled() -> Bool {
        if defaults.object(forKey: Keys.holidayRemindersEnabled) == nil {
            return true
        }

        return defaults.bool(forKey: Keys.holidayRemindersEnabled)
    }

    func saveHolidayRemindersEnabled(_ isEnabled: Bool) {
        defaults.set(isEnabled, forKey: Keys.holidayRemindersEnabled)
    }

    func holidayReminderDaysBefore() -> Int {
        let value = defaults.integer(forKey: Keys.holidayReminderDaysBefore)
        return value == 0 ? 1 : value
    }

    func saveHolidayReminderDaysBefore(_ days: Int) {
        defaults.set(days, forKey: Keys.holidayReminderDaysBefore)
    }

    func loadNotificationSettings() -> NotificationSettings {
        guard let data = defaults.data(forKey: Keys.notificationSettings),
              let settings = try? decoder.decode(NotificationSettings.self, from: data) else {
            return .default
        }

        return settings
    }

    func saveNotificationSettings(_ settings: NotificationSettings) {
        guard let data = try? encoder.encode(settings) else {
            return
        }

        defaults.set(data, forKey: Keys.notificationSettings)
    }

    func loadRecord(for date: String) -> DailyPrayerRecord {
        loadAllRecords()[date] ?? DailyPrayerRecord(date: date)
    }

    func saveRecord(_ record: DailyPrayerRecord) {
        var records = loadAllRecords()
        records[record.date] = record
        saveRecords(records)
    }

    func loadAllRecords() -> [String: DailyPrayerRecord] {
        guard let data = defaults.data(forKey: Keys.prayerRecords),
              let records = try? decoder.decode([String: DailyPrayerRecord].self, from: data) else {
            return [:]
        }

        return records
    }

    func clearAllData() {
        [
            Keys.selectedZoneID,
            Keys.notificationSettings,
            Keys.prayerRecords,
            Keys.tasbihCount,
            Keys.tasbihTarget,
            Keys.tasbihDailyTotals,
            Keys.appOpenDates,
            Keys.personalProfiles,
            Keys.practiceTimerMinutes,
            Keys.holidayRemindersEnabled,
            Keys.holidayReminderDaysBefore
        ].forEach(defaults.removeObject)
    }

    func loadTasbihCount() -> Int {
        defaults.integer(forKey: Keys.tasbihCount)
    }

    func saveTasbihCount(_ count: Int) {
        defaults.set(count, forKey: Keys.tasbihCount)
    }

    func loadTasbihTarget() -> Int {
        let target = defaults.integer(forKey: Keys.tasbihTarget)
        return target == 0 ? 33 : target
    }

    func saveTasbihTarget(_ target: Int) {
        defaults.set(target, forKey: Keys.tasbihTarget)
    }

    func loadTasbihDailyTotals() -> [String: Int] {
        defaults.dictionary(forKey: Keys.tasbihDailyTotals) as? [String: Int] ?? [:]
    }

    func saveTasbihDailyTotals(_ totals: [String: Int]) {
        defaults.set(totals, forKey: Keys.tasbihDailyTotals)
    }

    private func saveRecords(_ records: [String: DailyPrayerRecord]) {
        guard let data = try? encoder.encode(records) else {
            return
        }

        defaults.set(data, forKey: Keys.prayerRecords)
    }

    private func loadPersonalProfiles() -> [String: FaithPersonalProfile] {
        guard let data = defaults.data(forKey: Keys.personalProfiles),
              let profiles = try? decoder.decode([String: FaithPersonalProfile].self, from: data) else {
            return [:]
        }

        return profiles
    }

    private func savePersonalProfiles(_ profiles: [String: FaithPersonalProfile]) {
        guard let data = try? encoder.encode(profiles) else {
            return
        }

        defaults.set(data, forKey: Keys.personalProfiles)
    }

    private func loadPracticeTimerMinutes() -> [String: Int] {
        defaults.dictionary(forKey: Keys.practiceTimerMinutes) as? [String: Int] ?? [:]
    }
}
