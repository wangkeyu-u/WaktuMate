import SwiftUI

struct WeeklyStatsCard: View {
    @EnvironmentObject private var appState: AppStateViewModel
    let weeklyCompletionRate: Double
    let currentStreak: Int

    var body: some View {
        ViewThatFits(in: .horizontal) {
            HStack(spacing: 14) {
                weeklyCompletionBlock
                Divider()
                currentStreakBlock
            }

            VStack(alignment: .leading, spacing: 14) {
                weeklyCompletionBlock
                Divider()
                currentStreakBlock
            }
        }
        .wmCard()
    }

    private var weeklyCompletionBlock: some View {
        statBlock(
            localizedTitle: appState.text("Weekly Completion", "Selesai Mingguan", "本周完成率"),
            value: "\(Int((weeklyCompletionRate * 100).rounded()))%",
            systemImage: "chart.line.uptrend.xyaxis"
        )
    }

    private var currentStreakBlock: some View {
        statBlock(
            localizedTitle: appState.text("Current Streak", "Rentetan Semasa", "当前连续天数"),
            value: appState.text("\(currentStreak) days", "\(currentStreak) hari", "\(currentStreak) 天"),
            systemImage: "flame.fill"
        )
    }

    private func statBlock(localizedTitle: String, value: String, systemImage: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: systemImage)
                .font(.title3)
                .foregroundStyle(Color.wmGold)

            Text(value)
                .font(.title3.bold())
                .minimumScaleFactor(0.84)
                .lineLimit(1)

            Text(localizedTitle)
                .font(.caption)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    WeeklyStatsCard(weeklyCompletionRate: 0.71, currentStreak: 4)
        .environmentObject(AppStateViewModel())
        .padding()
}
