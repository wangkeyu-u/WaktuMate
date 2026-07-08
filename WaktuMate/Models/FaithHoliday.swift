import Foundation

struct FaithHoliday: Identifiable, Codable, Hashable {
    var id: String { "\(faith.rawValue)-\(date)-\(name.english)" }

    let faith: FaithTradition
    let name: LocalizedText
    let date: String
    let notes: LocalizedText
    let reminderDefaultDaysBefore: Int

    var dateValue: Date? {
        AppDateFormatting.dateKeyFormatter.date(from: date)
    }

    static let all: [FaithHoliday] = [
        FaithHoliday(
            faith: .islam,
            name: LocalizedText(english: "Awal Ramadan", malay: "Awal Ramadan", chinese: "斋月开始"),
            date: "2027-02-08",
            notes: LocalizedText(english: "Ramadan begins. Prepare fasting reminders and evening plans.", malay: "Ramadan bermula. Sediakan peringatan puasa dan rancangan petang.", chinese: "斋月开始。准备封斋提醒和傍晚安排。"),
            reminderDefaultDaysBefore: 1
        ),
        FaithHoliday(
            faith: .islam,
            name: LocalizedText(english: "Nuzul Al-Quran", malay: "Nuzul Al-Quran", chinese: "可兰经降示日"),
            date: "2027-02-24",
            notes: LocalizedText(english: "A day for Quran reflection and recitation.", malay: "Hari untuk tadabbur dan bacaan Al-Quran.", chinese: "适合诵读与思考《古兰经》的日子。"),
            reminderDefaultDaysBefore: 1
        ),
        FaithHoliday(
            faith: .islam,
            name: LocalizedText(english: "Hari Raya Aidilfitri", malay: "Hari Raya Aidilfitri", chinese: "开斋节"),
            date: "2027-03-10",
            notes: LocalizedText(english: "Eid celebration after Ramadan.", malay: "Sambutan Aidilfitri selepas Ramadan.", chinese: "斋月结束后的开斋节庆祝。"),
            reminderDefaultDaysBefore: 1
        ),
        FaithHoliday(
            faith: .islam,
            name: LocalizedText(english: "Hari Raya Aidiladha", malay: "Hari Raya Aidiladha", chinese: "哈芝节"),
            date: "2027-05-17",
            notes: LocalizedText(english: "Eid al-Adha observance.", malay: "Sambutan Aidiladha.", chinese: "古尔邦节/哈芝节。"),
            reminderDefaultDaysBefore: 2
        ),
        FaithHoliday(
            faith: .christianity,
            name: LocalizedText(english: "Christmas Day", malay: "Hari Krismas", chinese: "圣诞节"),
            date: "2026-12-25",
            notes: LocalizedText(english: "Christmas celebration and church services.", malay: "Sambutan Krismas dan ibadah gereja.", chinese: "圣诞庆祝和教堂礼拜。"),
            reminderDefaultDaysBefore: 3
        ),
        FaithHoliday(
            faith: .christianity,
            name: LocalizedText(english: "Good Friday", malay: "Jumaat Agung", chinese: "耶稣受难日"),
            date: "2027-03-26",
            notes: LocalizedText(english: "A solemn Christian observance.", malay: "Hari peringatan Kristian yang khusyuk.", chinese: "基督宗教的重要纪念日。"),
            reminderDefaultDaysBefore: 2
        ),
        FaithHoliday(
            faith: .christianity,
            name: LocalizedText(english: "Easter Sunday", malay: "Ahad Easter", chinese: "复活节"),
            date: "2027-03-28",
            notes: LocalizedText(english: "Easter Sunday celebration.", malay: "Sambutan Ahad Easter.", chinese: "复活节主日庆祝。"),
            reminderDefaultDaysBefore: 2
        ),
        FaithHoliday(
            faith: .buddhism,
            name: LocalizedText(english: "Wesak Day", malay: "Hari Wesak", chinese: "卫塞节"),
            date: "2027-05-20",
            notes: LocalizedText(english: "Buddhist observance for birth, enlightenment, and passing of the Buddha.", malay: "Hari peringatan Buddha untuk kelahiran, pencerahan dan kewafatan Buddha.", chinese: "纪念佛陀诞生、成道与涅槃的日子。"),
            reminderDefaultDaysBefore: 2
        ),
        FaithHoliday(
            faith: .hinduism,
            name: LocalizedText(english: "Thaipusam", malay: "Thaipusam", chinese: "大宝森节"),
            date: "2027-01-22",
            notes: LocalizedText(english: "Important Hindu observance in Malaysia.", malay: "Perayaan penting penganut Hindu di Malaysia.", chinese: "马来西亚印度教徒的重要节日。"),
            reminderDefaultDaysBefore: 2
        ),
        FaithHoliday(
            faith: .hinduism,
            name: LocalizedText(english: "Deepavali", malay: "Deepavali", chinese: "屠妖节"),
            date: "2026-11-08",
            notes: LocalizedText(english: "Festival of lights.", malay: "Pesta cahaya.", chinese: "光明节。"),
            reminderDefaultDaysBefore: 3
        ),
        FaithHoliday(
            faith: .taoism,
            name: LocalizedText(english: "Lunar New Year", malay: "Tahun Baharu Cina", chinese: "农历新年"),
            date: "2027-02-06",
            notes: LocalizedText(english: "Family, temple visits, and traditional observances.", malay: "Keluarga, lawatan kuil dan adat tradisi.", chinese: "团圆、拜庙和传统习俗。"),
            reminderDefaultDaysBefore: 5
        ),
        FaithHoliday(
            faith: .taoism,
            name: LocalizedText(english: "Qing Ming", malay: "Qing Ming", chinese: "清明节"),
            date: "2027-04-05",
            notes: LocalizedText(english: "Ancestral remembrance day.", malay: "Hari memperingati leluhur.", chinese: "祭祖与慎终追远的日子。"),
            reminderDefaultDaysBefore: 5
        ),
        FaithHoliday(
            faith: .sikhism,
            name: LocalizedText(english: "Vaisakhi", malay: "Vaisakhi", chinese: "瓦萨奇节"),
            date: "2027-04-14",
            notes: LocalizedText(english: "Sikh festival and community observance.", malay: "Perayaan Sikh dan acara komuniti.", chinese: "锡克教节日和社区活动。"),
            reminderDefaultDaysBefore: 3
        ),
        FaithHoliday(
            faith: .sikhism,
            name: LocalizedText(english: "Guru Nanak Gurpurab", malay: "Guru Nanak Gurpurab", chinese: "古鲁纳纳克诞辰"),
            date: "2026-11-24",
            notes: LocalizedText(english: "Commemoration of Guru Nanak.", malay: "Memperingati Guru Nanak.", chinese: "纪念古鲁纳纳克。"),
            reminderDefaultDaysBefore: 3
        )
    ]

    static func holidays(for faith: FaithTradition) -> [FaithHoliday] {
        all
            .filter { $0.faith == faith }
            .sorted { $0.date < $1.date }
    }

    static func upcoming(for faith: FaithTradition, from date: Date = Date(), limit: Int = 3) -> [FaithHoliday] {
        let start = AppDateFormatting.dateKey(for: date)
        return holidays(for: faith)
            .filter { $0.date >= start }
            .prefix(limit)
            .map { $0 }
    }
}
