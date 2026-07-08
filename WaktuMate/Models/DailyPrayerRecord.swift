import Foundation

struct DailyPrayerRecord: Codable, Identifiable, Equatable {
    var id: String { date }

    let date: String
    var completed: [PrayerName: Bool]

    init(date: String, completed: [PrayerName: Bool] = .prayerDefaults(false)) {
        self.date = date
        self.completed = completed
    }

    var completedCount: Int {
        completed.values.filter { $0 }.count
    }

    var isComplete: Bool {
        completedCount == PrayerName.allCases.count
    }

    mutating func toggle(_ prayer: PrayerName) {
        completed[prayer] = !(completed[prayer] ?? false)
    }

    enum CodingKeys: String, CodingKey {
        case date
        case completed
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        date = try container.decode(String.self, forKey: .date)
        let values = try container.decode([String: Bool].self, forKey: .completed)
        completed = .fromStringKeys(values, defaultValue: false)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(date, forKey: .date)
        try container.encode(completed.stringKeyed, forKey: .completed)
    }
}
