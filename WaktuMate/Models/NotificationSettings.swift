import Foundation

struct NotificationSettings: Codable, Equatable {
    var isEnabled: Bool
    var enabledPrayers: [PrayerName: Bool]
    var reminderOffsetMinutes: Int
    var uses24HourTime: Bool

    static let `default` = NotificationSettings(
        isEnabled: false,
        enabledPrayers: .prayerDefaults(true),
        reminderOffsetMinutes: 0,
        uses24HourTime: true
    )

    func isEnabled(for prayer: PrayerName) -> Bool {
        enabledPrayers[prayer] ?? true
    }

    enum CodingKeys: String, CodingKey {
        case isEnabled
        case enabledPrayers
        case reminderOffsetMinutes
        case uses24HourTime
    }

    init(
        isEnabled: Bool,
        enabledPrayers: [PrayerName: Bool],
        reminderOffsetMinutes: Int,
        uses24HourTime: Bool
    ) {
        self.isEnabled = isEnabled
        self.enabledPrayers = enabledPrayers
        self.reminderOffsetMinutes = reminderOffsetMinutes
        self.uses24HourTime = uses24HourTime
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        isEnabled = try container.decode(Bool.self, forKey: .isEnabled)
        let prayerValues = try container.decode([String: Bool].self, forKey: .enabledPrayers)
        enabledPrayers = .fromStringKeys(prayerValues, defaultValue: true)
        reminderOffsetMinutes = try container.decode(Int.self, forKey: .reminderOffsetMinutes)
        uses24HourTime = try container.decode(Bool.self, forKey: .uses24HourTime)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(isEnabled, forKey: .isEnabled)
        try container.encode(enabledPrayers.stringKeyed, forKey: .enabledPrayers)
        try container.encode(reminderOffsetMinutes, forKey: .reminderOffsetMinutes)
        try container.encode(uses24HourTime, forKey: .uses24HourTime)
    }
}
