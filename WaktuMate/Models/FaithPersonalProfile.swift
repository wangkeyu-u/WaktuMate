import Foundation

struct FaithPersonalProfile: Codable, Equatable {
    var displayName: String
    var communityName: String
    var practiceGoal: String
    var preferredPracticeTime: String
    var notes: String

    static let empty = FaithPersonalProfile(
        displayName: "",
        communityName: "",
        practiceGoal: "",
        preferredPracticeTime: "",
        notes: ""
    )
}

struct FaithPracticeStats: Equatable {
    let activeDays: Int
    let trackerCompletedDays: Int
    let tasbihTotal: Int
    let timerMinutes: Int
}
