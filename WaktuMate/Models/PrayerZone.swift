import Foundation

struct PrayerZone: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let state: String

    var displayName: String {
        "\(id) - \(name)"
    }

    static let commonZones: [PrayerZone] = [
        PrayerZone(id: "JHR01", name: "Pulau Aur dan Pulau Pemanggil", state: "Johor"),
        PrayerZone(id: "JHR02", name: "Johor Bahru, Kota Tinggi, Mersing, Kulai", state: "Johor"),
        PrayerZone(id: "JHR03", name: "Kluang, Pontian", state: "Johor"),
        PrayerZone(id: "JHR04", name: "Batu Pahat, Muar, Segamat, Gemas Johor, Tangkak", state: "Johor"),
        PrayerZone(id: "KDH01", name: "Kota Setar, Kubang Pasu, Pokok Sena", state: "Kedah"),
        PrayerZone(id: "KDH02", name: "Kuala Muda, Yan, Pendang", state: "Kedah"),
        PrayerZone(id: "KDH03", name: "Padang Terap, Sik", state: "Kedah"),
        PrayerZone(id: "KDH04", name: "Baling", state: "Kedah"),
        PrayerZone(id: "KDH05", name: "Bandar Baharu, Kulim", state: "Kedah"),
        PrayerZone(id: "KDH06", name: "Langkawi", state: "Kedah"),
        PrayerZone(id: "KDH07", name: "Puncak Gunung Jerai", state: "Kedah"),
        PrayerZone(id: "KTN01", name: "Bachok, Kota Bharu, Machang, Pasir Mas, Pasir Puteh, Tanah Merah, Tumpat, Kuala Krai, Mukim Chiku", state: "Kelantan"),
        PrayerZone(id: "KTN02", name: "Gua Musang, Jeli, Jajahan Kecil Lojing", state: "Kelantan"),
        PrayerZone(id: "MLK01", name: "Seluruh Negeri Melaka", state: "Melaka"),
        PrayerZone(id: "NGS01", name: "Tampin, Jempol", state: "Negeri Sembilan"),
        PrayerZone(id: "NGS02", name: "Jelebu, Kuala Pilah, Rembau", state: "Negeri Sembilan"),
        PrayerZone(id: "NGS03", name: "Port Dickson, Seremban", state: "Negeri Sembilan"),
        PrayerZone(id: "PHG01", name: "Pulau Tioman", state: "Pahang"),
        PrayerZone(id: "PHG02", name: "Kuantan, Pekan, Muadzam Shah", state: "Pahang"),
        PrayerZone(id: "PHG03", name: "Jerantut, Temerloh, Maran, Bera, Chenor, Jengka", state: "Pahang"),
        PrayerZone(id: "PHG04", name: "Bentong, Lipis, Raub", state: "Pahang"),
        PrayerZone(id: "PHG05", name: "Genting Sempah, Janda Baik, Bukit Tinggi", state: "Pahang"),
        PrayerZone(id: "PHG06", name: "Cameron Highlands, Genting Highlands, Bukit Fraser", state: "Pahang"),
        PrayerZone(id: "PHG07", name: "Zon Khas Daerah Rompin", state: "Pahang"),
        PrayerZone(id: "PRK01", name: "Tapah, Slim River, Tanjung Malim", state: "Perak"),
        PrayerZone(id: "PRK02", name: "Kuala Kangsar, Sungai Siput, Ipoh, Batu Gajah, Kampar", state: "Perak"),
        PrayerZone(id: "PRK03", name: "Lenggong, Pengkalan Hulu, Grik", state: "Perak"),
        PrayerZone(id: "PRK04", name: "Temengor, Belum", state: "Perak"),
        PrayerZone(id: "PRK05", name: "Kg Gajah, Teluk Intan, Bagan Datuk, Seri Iskandar, Beruas, Parit, Lumut, Sitiawan, Pulau Pangkor", state: "Perak"),
        PrayerZone(id: "PRK06", name: "Selama, Taiping, Bagan Serai, Parit Buntar", state: "Perak"),
        PrayerZone(id: "PRK07", name: "Bukit Larut", state: "Perak"),
        PrayerZone(id: "PLS01", name: "Seluruh Negeri Perlis", state: "Perlis"),
        PrayerZone(id: "PNG01", name: "Seluruh Negeri Pulau Pinang", state: "Pulau Pinang"),
        PrayerZone(id: "SBH01", name: "Bahagian Sandakan Timur, Bukit Garam, Semawang, Temanggong, Tambisan, Bandar Sandakan, Sukau", state: "Sabah"),
        PrayerZone(id: "SBH02", name: "Beluran, Telupid, Pinangah, Terusan, Kuamut, Bahagian Sandakan Barat", state: "Sabah"),
        PrayerZone(id: "SBH03", name: "Lahad Datu, Silabukan, Kunak, Sahabat, Semporna, Tungku, Bahagian Tawau Timur", state: "Sabah"),
        PrayerZone(id: "SBH04", name: "Bandar Tawau, Balong, Merotai, Kalabakan, Bahagian Tawau Barat", state: "Sabah"),
        PrayerZone(id: "SBH05", name: "Kudat, Kota Marudu, Pitas, Pulau Banggi, Bahagian Kudat", state: "Sabah"),
        PrayerZone(id: "SBH06", name: "Gunung Kinabalu", state: "Sabah"),
        PrayerZone(id: "SBH07", name: "Kota Kinabalu, Ranau, Kota Belud, Tuaran, Penampang, Papar, Putatan, Bahagian Pantai Barat", state: "Sabah"),
        PrayerZone(id: "SBH08", name: "Pensiangan, Keningau, Tambunan, Nabawan, Bahagian Pendalaman Atas", state: "Sabah"),
        PrayerZone(id: "SBH09", name: "Beaufort, Kuala Penyu, Sipitang, Tenom, Long Pasia, Membakut, Weston, Bahagian Pendalaman Bawah", state: "Sabah"),
        PrayerZone(id: "SWK01", name: "Limbang, Lawas, Sundar, Trusan", state: "Sarawak"),
        PrayerZone(id: "SWK02", name: "Miri, Niah, Bekenu, Sibuti, Marudi", state: "Sarawak"),
        PrayerZone(id: "SWK03", name: "Pandan, Belaga, Suai, Tatau, Sebauh, Bintulu", state: "Sarawak"),
        PrayerZone(id: "SWK04", name: "Sibu, Mukah, Dalat, Song, Igan, Oya, Balingian, Kanowit, Kapit", state: "Sarawak"),
        PrayerZone(id: "SWK05", name: "Sarikei, Matu, Julau, Rajang, Daro, Bintangor, Belawai", state: "Sarawak"),
        PrayerZone(id: "SWK06", name: "Lubok Antu, Sri Aman, Roban, Debak, Kabong, Lingga, Engkelili, Betong, Spaoh, Pusa, Saratok", state: "Sarawak"),
        PrayerZone(id: "SWK07", name: "Serian, Simunjan, Samarahan, Sebuyau, Meludam", state: "Sarawak"),
        PrayerZone(id: "SWK08", name: "Kuching, Bau, Lundu, Sematan", state: "Sarawak"),
        PrayerZone(id: "SWK09", name: "Zon Khas Kampung Patarikan", state: "Sarawak"),
        PrayerZone(id: "SGR01", name: "Gombak, Petaling, Sepang, Hulu Langat, Hulu Selangor, Shah Alam", state: "Selangor"),
        PrayerZone(id: "SGR02", name: "Kuala Selangor, Sabak Bernam", state: "Selangor"),
        PrayerZone(id: "SGR03", name: "Klang, Kuala Langat", state: "Selangor"),
        PrayerZone(id: "TRG01", name: "Kuala Terengganu, Marang, Kuala Nerus", state: "Terengganu"),
        PrayerZone(id: "TRG02", name: "Besut, Setiu", state: "Terengganu"),
        PrayerZone(id: "TRG03", name: "Hulu Terengganu", state: "Terengganu"),
        PrayerZone(id: "TRG04", name: "Dungun, Kemaman", state: "Terengganu"),
        PrayerZone(id: "WLY01", name: "Kuala Lumpur, Putrajaya", state: "Wilayah Persekutuan"),
        PrayerZone(id: "WLY02", name: "Labuan", state: "Wilayah Persekutuan")
    ]

    static let defaultZone = PrayerZone(id: "WLY01", name: "Kuala Lumpur, Putrajaya", state: "Wilayah Persekutuan")

    static var states: [String] {
        Array(Set(commonZones.map(\.state))).sorted()
    }

    static func zones(in state: String) -> [PrayerZone] {
        commonZones.filter { $0.state == state }
    }

    static func zone(for id: String) -> PrayerZone {
        commonZones.first { $0.id.caseInsensitiveCompare(id) == .orderedSame } ?? defaultZone
    }
}
