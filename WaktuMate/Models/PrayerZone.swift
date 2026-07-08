import Foundation

struct PrayerZone: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let state: String

    var displayName: String {
        "\(id) - \(name)"
    }

    static let commonZones: [PrayerZone] = [
        PrayerZone(id: "WLY01", name: "Kuala Lumpur / Putrajaya", state: "Wilayah Persekutuan"),
        PrayerZone(id: "SGR01", name: "Gombak, Petaling, Sepang, Hulu Langat, Hulu Selangor, Shah Alam", state: "Selangor"),
        PrayerZone(id: "SGR02", name: "Sabak Bernam, Kuala Selangor", state: "Selangor"),
        PrayerZone(id: "JHR01", name: "Pulau Aur and Pulau Pemanggil", state: "Johor"),
        PrayerZone(id: "JHR02", name: "Johor Bahru, Kota Tinggi, Mersing", state: "Johor"),
        PrayerZone(id: "PNG01", name: "Pulau Pinang", state: "Pulau Pinang"),
        PrayerZone(id: "MLK01", name: "Melaka", state: "Melaka"),
        PrayerZone(id: "PRK01", name: "Tapah, Slim River, Tanjung Malim", state: "Perak"),
        PrayerZone(id: "SBH01", name: "Sandakan", state: "Sabah"),
        PrayerZone(id: "SWK01", name: "Limbang, Lawas", state: "Sarawak")
    ]

    static let defaultZone = commonZones[0]

    static func zone(for id: String) -> PrayerZone {
        commonZones.first { $0.id == id } ?? defaultZone
    }
}
