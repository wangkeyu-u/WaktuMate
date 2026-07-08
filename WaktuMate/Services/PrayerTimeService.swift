import Foundation

protocol PrayerTimeServiceProtocol {
    func fetchPrayerTimes(zone: String, month: Int, year: Int) async throws -> [PrayerTime]
}

enum PrayerTimeServiceError: LocalizedError {
    case invalidURL
    case invalidResponse
    case httpStatus(Int)
    case emptyData
    case missingMockData

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The prayer time API URL could not be created."
        case .invalidResponse:
            return "The prayer time API returned an invalid response."
        case .httpStatus(let status):
            return "The prayer time API returned HTTP \(status)."
        case .emptyData:
            return "No prayer time data was found."
        case .missingMockData:
            return "Offline sample data is missing from the app bundle."
        }
    }
}

final class PrayerTimeService: PrayerTimeServiceProtocol {
    private let session: URLSession
    private let decoder = JSONDecoder()

    private(set) var lastFallbackMessage: String?

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetchPrayerTimes(zone: String, month: Int, year: Int) async throws -> [PrayerTime] {
        do {
            let prayerTimes = try await fetchRemotePrayerTimes(zone: zone, month: month, year: year)
            lastFallbackMessage = nil
            return prayerTimes
        } catch {
            let mockPrayerTimes = try loadMockPrayerTimes()
            lastFallbackMessage = "Unable to load prayer times. Showing offline sample data."
            return mockPrayerTimes
        }
    }

    private func fetchRemotePrayerTimes(zone: String, month: Int, year: Int) async throws -> [PrayerTime] {
        var components = URLComponents(string: "https://api.waktusolat.app/v2/solat/\(zone.lowercased())")
        components?.queryItems = [
            URLQueryItem(name: "year", value: String(year)),
            URLQueryItem(name: "month", value: String(month))
        ]

        guard let url = components?.url else {
            throw PrayerTimeServiceError.invalidURL
        }

        let (data, response) = try await session.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw PrayerTimeServiceError.invalidResponse
        }

        guard (200..<300).contains(httpResponse.statusCode) else {
            throw PrayerTimeServiceError.httpStatus(httpResponse.statusCode)
        }

        let apiResponse = try decoder.decode(WaktuSolatV2Response.self, from: data)
        let mapped = apiResponse.prayers.map { apiPrayer in
            apiPrayer.toPrayerTime(year: apiResponse.year, month: apiResponse.monthNumber)
        }

        guard !mapped.isEmpty else {
            throw PrayerTimeServiceError.emptyData
        }

        return mapped
    }

    private func loadMockPrayerTimes() throws -> [PrayerTime] {
        guard let url = Bundle.main.url(forResource: "MockPrayerTimes", withExtension: "json") else {
            throw PrayerTimeServiceError.missingMockData
        }

        let data = try Data(contentsOf: url)
        return try decoder.decode([PrayerTime].self, from: data)
    }
}

private struct WaktuSolatV2Response: Decodable {
    let zone: String
    let year: Int
    let month: String
    let monthNumber: Int
    let prayers: [WaktuSolatV2Prayer]

    enum CodingKeys: String, CodingKey {
        case zone
        case year
        case month
        case monthNumber = "month_number"
        case prayers
    }
}

private struct WaktuSolatV2Prayer: Decodable {
    let day: Int
    let hijri: String
    let fajr: Int
    let syuruk: Int
    let dhuhr: Int
    let asr: Int
    let maghrib: Int
    let isha: Int

    func toPrayerTime(year: Int, month: Int) -> PrayerTime {
        let calendar = AppDateFormatting.malaysiaCalendar
        let date = calendar.date(from: DateComponents(year: year, month: month, day: day)) ?? Date()

        return PrayerTime(
            date: AppDateFormatting.dateKeyFormatter.string(from: date),
            hijri: hijri,
            day: AppDateFormatting.weekdayFormatter.string(from: date),
            subuh: format(timestamp: fajr),
            syuruk: format(timestamp: syuruk),
            zohor: format(timestamp: dhuhr),
            asar: format(timestamp: asr),
            maghrib: format(timestamp: maghrib),
            isyak: format(timestamp: isha)
        )
    }

    private func format(timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        return AppDateFormatting.time24Formatter.string(from: date)
    }
}
