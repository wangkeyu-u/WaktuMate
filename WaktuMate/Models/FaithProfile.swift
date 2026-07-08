import Foundation

enum FaithTradition: String, CaseIterable, Codable, Identifiable {
    case islam
    case christianity
    case buddhism
    case hinduism
    case taoism
    case sikhism
    case general

    var id: String { rawValue }
}

struct FaithReferenceResource: Identifiable, Codable, Hashable {
    var id: String { title }

    let title: String
    let subtitle: String
    let url: URL
}

struct FaithProfile: Identifiable, Codable, Hashable {
    let id: FaithTradition
    let displayName: String
    let subtitle: String
    let symbolName: String
    let placeTitle: String
    let placeSearchQuery: String
    let primaryPracticeTitle: String
    let primaryPracticeSubtitle: String
    let supportsPrayerTimes: Bool
    let supportsQibla: Bool
    let references: [FaithReferenceResource]

    var backgroundAssetName: String {
        switch id {
        case .islam:
            return "FaithBackgroundIslam"
        case .christianity:
            return "FaithBackgroundChristianity"
        case .buddhism:
            return "FaithBackgroundBuddhism"
        case .hinduism:
            return "FaithBackgroundHinduism"
        case .taoism:
            return "FaithBackgroundTaoism"
        case .sikhism:
            return "FaithBackgroundSikhism"
        case .general:
            return "FaithBackgroundGeneral"
        }
    }

    func localizedDisplayName(_ language: AppLanguage) -> String {
        switch id {
        case .islam:
            return LocalizedText(english: "Islam", malay: "Islam", chinese: "伊斯兰教").text(language)
        case .christianity:
            return LocalizedText(english: "Christianity", malay: "Kristian", chinese: "基督宗教").text(language)
        case .buddhism:
            return LocalizedText(english: "Buddhism", malay: "Buddha", chinese: "佛教").text(language)
        case .hinduism:
            return LocalizedText(english: "Hinduism", malay: "Hindu", chinese: "印度教").text(language)
        case .taoism:
            return LocalizedText(english: "Taoism", malay: "Tao", chinese: "道教").text(language)
        case .sikhism:
            return LocalizedText(english: "Sikhism", malay: "Sikh", chinese: "锡克教").text(language)
        case .general:
            return LocalizedText(english: "General", malay: "Umum", chinese: "通用").text(language)
        }
    }

    func localizedSubtitle(_ language: AppLanguage) -> String {
        switch id {
        case .islam:
            return LocalizedText(english: "Prayer times, mosque navigation, Qibla, zikr, and reminders.", malay: "Waktu solat, masjid berdekatan, kiblat, zikir dan peringatan.", chinese: "礼拜时间、清真寺导航、朝向、念珠计数和提醒。").text(language)
        case .christianity:
            return LocalizedText(english: "Scripture references, nearby churches, and reflection timers.", malay: "Rujukan kitab, gereja berdekatan dan pemasa renungan.", chinese: "经文参考、附近教堂和默想定时器。").text(language)
        case .buddhism:
            return LocalizedText(english: "Meditation timers, nearby temples, and sutta references.", malay: "Pemasa meditasi, kuil berdekatan dan rujukan sutta.", chinese: "禅修定时、附近寺院和经典参考。").text(language)
        case .hinduism:
            return LocalizedText(english: "Nearby temples, scripture references, and practice timers.", malay: "Kuil berdekatan, rujukan kitab dan pemasa amalan.", chinese: "附近印度庙、经典参考和修持定时。").text(language)
        case .taoism:
            return LocalizedText(english: "Nearby temples, quiet timers, and Taoist classic references.", malay: "Tokong berdekatan, pemasa tenang dan rujukan klasik Tao.", chinese: "附近道观、静修定时和道家经典参考。").text(language)
        case .sikhism:
            return LocalizedText(english: "Nearby gurdwaras, scripture references, and practice timers.", malay: "Gurdwara berdekatan, rujukan kitab dan pemasa amalan.", chinese: "附近谒师所、经典参考和修持定时。").text(language)
        case .general:
            return LocalizedText(english: "Neutral timers, compass tools, places, and study links.", malay: "Pemasa neutral, kompas, tempat dan pautan rujukan.", chinese: "通用定时、指南针、地点和学习链接。").text(language)
        }
    }

    func localizedPracticeTitle(_ language: AppLanguage) -> String {
        switch id {
        case .islam:
            return LocalizedText(english: "Daily Salah", malay: "Solat Harian", chinese: "每日礼拜").text(language)
        case .christianity:
            return LocalizedText(english: "Prayer & Reflection", malay: "Doa & Renungan", chinese: "祷告与默想").text(language)
        case .buddhism:
            return LocalizedText(english: "Meditation", malay: "Meditasi", chinese: "禅修").text(language)
        case .hinduism:
            return LocalizedText(english: "Puja & Reflection", malay: "Puja & Renungan", chinese: "礼拜与静思").text(language)
        case .taoism:
            return LocalizedText(english: "Quiet Practice", malay: "Amalan Tenang", chinese: "静修").text(language)
        case .sikhism:
            return LocalizedText(english: "Paath & Simran", malay: "Paath & Simran", chinese: "诵读与念修").text(language)
        case .general:
            return LocalizedText(english: "Personal Practice", malay: "Amalan Peribadi", chinese: "个人练习").text(language)
        }
    }

    func localizedPlaceTitle(_ language: AppLanguage) -> String {
        switch id {
        case .islam:
            return LocalizedText(english: "Nearby Mosques", malay: "Masjid Berdekatan", chinese: "附近清真寺").text(language)
        case .christianity:
            return LocalizedText(english: "Nearby Churches", malay: "Gereja Berdekatan", chinese: "附近教堂").text(language)
        case .buddhism:
            return LocalizedText(english: "Nearby Temples", malay: "Kuil Buddha Berdekatan", chinese: "附近佛寺").text(language)
        case .hinduism:
            return LocalizedText(english: "Nearby Hindu Temples", malay: "Kuil Hindu Berdekatan", chinese: "附近印度庙").text(language)
        case .taoism:
            return LocalizedText(english: "Nearby Taoist Temples", malay: "Tokong Tao Berdekatan", chinese: "附近道观").text(language)
        case .sikhism:
            return LocalizedText(english: "Nearby Gurdwaras", malay: "Gurdwara Berdekatan", chinese: "附近谒师所").text(language)
        case .general:
            return LocalizedText(english: "Nearby Places of Worship", malay: "Tempat Ibadat Berdekatan", chinese: "附近宗教场所").text(language)
        }
    }

    func attributes(_ language: AppLanguage) -> [String] {
        switch id {
        case .islam:
            return [
                LocalizedText(english: "Five daily prayers", malay: "Lima solat harian", chinese: "每日五次礼拜").text(language),
                LocalizedText(english: "Qibla direction", malay: "Arah kiblat", chinese: "朝向麦加").text(language),
                LocalizedText(english: "Ramadan and Eid reminders", malay: "Peringatan Ramadan dan Raya", chinese: "斋月与开斋节提醒").text(language)
            ]
        case .christianity:
            return [
                LocalizedText(english: "Prayer and reflection", malay: "Doa dan renungan", chinese: "祷告与默想").text(language),
                LocalizedText(english: "Church visits", malay: "Lawatan gereja", chinese: "教堂聚会").text(language),
                LocalizedText(english: "Christmas, Easter and Good Friday", malay: "Krismas, Easter dan Jumaat Agung", chinese: "圣诞节、复活节和受难日").text(language)
            ]
        case .buddhism:
            return [
                LocalizedText(english: "Meditation sessions", malay: "Sesi meditasi", chinese: "禅修时段").text(language),
                LocalizedText(english: "Temple and study references", malay: "Kuil dan rujukan pembelajaran", chinese: "寺院与经典学习").text(language),
                LocalizedText(english: "Wesak reminders", malay: "Peringatan Wesak", chinese: "卫塞节提醒").text(language)
            ]
        case .hinduism:
            return [
                LocalizedText(english: "Temple visits and puja", malay: "Lawatan kuil dan puja", chinese: "庙宇参拜与礼拜").text(language),
                LocalizedText(english: "Deepavali and Thaipusam", malay: "Deepavali dan Thaipusam", chinese: "屠妖节与大宝森节").text(language),
                LocalizedText(english: "Scripture references", malay: "Rujukan kitab", chinese: "经典参考").text(language)
            ]
        case .taoism:
            return [
                LocalizedText(english: "Temple and ancestor observances", malay: "Tokong dan peringatan leluhur", chinese: "道观与祭祖习俗").text(language),
                LocalizedText(english: "Quiet practice timer", malay: "Pemasa amalan tenang", chinese: "静修定时").text(language),
                LocalizedText(english: "Lunar calendar reminders", malay: "Peringatan kalendar lunar", chinese: "农历节日提醒").text(language)
            ]
        case .sikhism:
            return [
                LocalizedText(english: "Paath and simran", malay: "Paath dan simran", chinese: "诵读与念修").text(language),
                LocalizedText(english: "Gurdwara visits", malay: "Lawatan gurdwara", chinese: "谒师所参访").text(language),
                LocalizedText(english: "Vaisakhi and Gurpurab", malay: "Vaisakhi dan Gurpurab", chinese: "瓦萨奇节与古尔普拉布").text(language)
            ]
        case .general:
            return [
                LocalizedText(english: "Personal reminders", malay: "Peringatan peribadi", chinese: "个人提醒").text(language),
                LocalizedText(english: "Study and quiet time", malay: "Belajar dan masa tenang", chinese: "学习与静心").text(language),
                LocalizedText(english: "Nearby places", malay: "Tempat berdekatan", chinese: "附近地点").text(language)
            ]
        }
    }

    func personalQuestionPrompts(_ language: AppLanguage) -> [String] {
        switch id {
        case .islam:
            return [
                LocalizedText(english: "Which mosque or surau do you usually visit?", malay: "Masjid atau surau mana yang biasa anda kunjungi?", chinese: "你平时常去哪个清真寺或祈祷室？").text(language),
                LocalizedText(english: "Which prayer do you most want help remembering?", malay: "Solat mana yang paling anda mahu dibantu ingat?", chinese: "你最想加强哪一次礼拜提醒？").text(language)
            ]
        case .christianity:
            return [
                LocalizedText(english: "Which church or fellowship do you attend?", malay: "Gereja atau persekutuan mana yang anda hadiri?", chinese: "你参加哪间教堂或团契？").text(language),
                LocalizedText(english: "What time do you prefer for prayer or devotion?", malay: "Bila masa pilihan anda untuk doa atau renungan?", chinese: "你偏好什么时间祷告或灵修？").text(language)
            ]
        case .buddhism:
            return [
                LocalizedText(english: "Which temple or meditation group do you visit?", malay: "Kuil atau kumpulan meditasi mana yang anda kunjungi?", chinese: "你常去哪个寺院或禅修团体？").text(language),
                LocalizedText(english: "How long is your usual meditation session?", malay: "Berapa lama sesi meditasi biasa anda?", chinese: "你平常禅修多久？").text(language)
            ]
        case .hinduism:
            return [
                LocalizedText(english: "Which temple do you usually visit?", malay: "Kuil mana yang biasa anda kunjungi?", chinese: "你平时常去哪间印度庙？").text(language),
                LocalizedText(english: "Which festival reminders are most important?", malay: "Peringatan perayaan mana yang paling penting?", chinese: "哪些节日提醒对你最重要？").text(language)
            ]
        case .taoism:
            return [
                LocalizedText(english: "Which temple or family observance matters most?", malay: "Tokong atau adat keluarga mana yang paling penting?", chinese: "哪个道观或家庭习俗对你最重要？").text(language),
                LocalizedText(english: "Which lunar reminders should be early?", malay: "Peringatan lunar mana perlu diberi awal?", chinese: "哪些农历提醒需要提前？").text(language)
            ]
        case .sikhism:
            return [
                LocalizedText(english: "Which gurdwara do you usually visit?", malay: "Gurdwara mana yang biasa anda kunjungi?", chinese: "你平时常去哪间谒师所？").text(language),
                LocalizedText(english: "What is your regular paath or simran goal?", malay: "Apakah matlamat paath atau simran anda?", chinese: "你的诵读或念修目标是什么？").text(language)
            ]
        case .general:
            return [
                LocalizedText(english: "What daily habit do you want to build?", malay: "Tabiat harian apa yang mahu anda bina?", chinese: "你想建立什么日常习惯？").text(language),
                LocalizedText(english: "When should WaktuMate remind you?", malay: "Bila WaktuMate patut mengingatkan anda?", chinese: "你希望 WaktuMate 什么时候提醒你？").text(language)
            ]
        }
    }

    static let all: [FaithProfile] = [
        FaithProfile(
            id: .islam,
            displayName: "Islam",
            subtitle: "Prayer times, mosque navigation, Qibla, zikr, and reminders.",
            symbolName: "moon.stars.fill",
            placeTitle: "Nearby Mosques",
            placeSearchQuery: "mosque",
            primaryPracticeTitle: "Daily Salah",
            primaryPracticeSubtitle: "Prayer times, tracker, Qibla, and Tasbih tools are enabled.",
            supportsPrayerTimes: true,
            supportsQibla: true,
            references: [
                FaithReferenceResource(title: "Quran.com", subtitle: "Quran reading and translations", url: URL(string: "https://quran.com")!),
                FaithReferenceResource(title: "Sunnah.com", subtitle: "Hadith reference library", url: URL(string: "https://sunnah.com")!),
                FaithReferenceResource(title: "JAKIM e-Solat", subtitle: "Malaysia official prayer-time source", url: URL(string: "https://www.e-solat.gov.my")!)
            ]
        ),
        FaithProfile(
            id: .christianity,
            displayName: "Christianity",
            subtitle: "Scripture references, nearby churches, and reflection timers.",
            symbolName: "cross.fill",
            placeTitle: "Nearby Churches",
            placeSearchQuery: "church",
            primaryPracticeTitle: "Prayer & Reflection",
            primaryPracticeSubtitle: "Use the timer, nearby places, and reference library.",
            supportsPrayerTimes: false,
            supportsQibla: false,
            references: [
                FaithReferenceResource(title: "Bible Gateway", subtitle: "Bible reading and translations", url: URL(string: "https://www.biblegateway.com")!),
                FaithReferenceResource(title: "YouVersion", subtitle: "Bible app and reading plans", url: URL(string: "https://www.youversion.com/the-bible-app/")!)
            ]
        ),
        FaithProfile(
            id: .buddhism,
            displayName: "Buddhism",
            subtitle: "Meditation timers, nearby temples, and sutta references.",
            symbolName: "circle.hexagongrid.fill",
            placeTitle: "Nearby Temples",
            placeSearchQuery: "buddhist temple",
            primaryPracticeTitle: "Meditation",
            primaryPracticeSubtitle: "Use the timer and reference library for quiet practice.",
            supportsPrayerTimes: false,
            supportsQibla: false,
            references: [
                FaithReferenceResource(title: "SuttaCentral", subtitle: "Early Buddhist texts and translations", url: URL(string: "https://suttacentral.net")!),
                FaithReferenceResource(title: "84000", subtitle: "Translated Buddhist texts", url: URL(string: "https://84000.co")!)
            ]
        ),
        FaithProfile(
            id: .hinduism,
            displayName: "Hinduism",
            subtitle: "Nearby temples, scripture references, and practice timers.",
            symbolName: "sparkles",
            placeTitle: "Nearby Hindu Temples",
            placeSearchQuery: "hindu temple",
            primaryPracticeTitle: "Puja & Reflection",
            primaryPracticeSubtitle: "Use nearby places, timers, and references.",
            supportsPrayerTimes: false,
            supportsQibla: false,
            references: [
                FaithReferenceResource(title: "Bhagavad Gita", subtitle: "Gita text and commentary", url: URL(string: "https://www.holy-bhagavad-gita.org")!),
                FaithReferenceResource(title: "Vedabase", subtitle: "Vedic literature references", url: URL(string: "https://vedabase.io")!)
            ]
        ),
        FaithProfile(
            id: .taoism,
            displayName: "Taoism",
            subtitle: "Nearby temples, quiet timers, and Taoist classic references.",
            symbolName: "circle.lefthalf.filled",
            placeTitle: "Nearby Taoist Temples",
            placeSearchQuery: "taoist temple",
            primaryPracticeTitle: "Quiet Practice",
            primaryPracticeSubtitle: "Use the timer, compass, and reference library.",
            supportsPrayerTimes: false,
            supportsQibla: false,
            references: [
                FaithReferenceResource(title: "Chinese Text Project", subtitle: "Dao De Jing and classical texts", url: URL(string: "https://ctext.org/dao-de-jing")!),
                FaithReferenceResource(title: "Tao Te Ching", subtitle: "English reference collection", url: URL(string: "https://terebess.hu/english/tao/_index.html")!)
            ]
        ),
        FaithProfile(
            id: .sikhism,
            displayName: "Sikhism",
            subtitle: "Nearby gurdwaras, scripture references, and practice timers.",
            symbolName: "book.closed.fill",
            placeTitle: "Nearby Gurdwaras",
            placeSearchQuery: "gurdwara",
            primaryPracticeTitle: "Paath & Simran",
            primaryPracticeSubtitle: "Use references, timers, and nearby place search.",
            supportsPrayerTimes: false,
            supportsQibla: false,
            references: [
                FaithReferenceResource(title: "SikhiToTheMax", subtitle: "Gurbani search and display", url: URL(string: "https://www.sikhitothemax.org")!),
                FaithReferenceResource(title: "Sri Granth", subtitle: "Sri Guru Granth Sahib reference", url: URL(string: "https://www.srigranth.org")!)
            ]
        ),
        FaithProfile(
            id: .general,
            displayName: "General",
            subtitle: "Neutral timers, compass tools, places, and study links.",
            symbolName: "globe.asia.australia.fill",
            placeTitle: "Nearby Places of Worship",
            placeSearchQuery: "place of worship",
            primaryPracticeTitle: "Personal Practice",
            primaryPracticeSubtitle: "A neutral set of timer, compass, navigation, and reference tools.",
            supportsPrayerTimes: false,
            supportsQibla: false,
            references: [
                FaithReferenceResource(title: "Britannica Religion", subtitle: "General religion reference", url: URL(string: "https://www.britannica.com/topic/religion")!)
            ]
        )
    ]

    static let `default` = all[0]

    static func profile(for id: FaithTradition) -> FaithProfile {
        all.first { $0.id == id } ?? .default
    }

    static func profile(for rawValue: String) -> FaithProfile {
        guard let id = FaithTradition(rawValue: rawValue) else {
            return .default
        }

        return profile(for: id)
    }
}
