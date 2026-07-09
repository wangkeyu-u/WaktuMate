import SwiftUI

struct TrackerView: View {
    @EnvironmentObject private var appState: AppStateViewModel
    @StateObject private var viewModel = TrackerViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                FaithBackgroundView(profile: appState.selectedFaithProfile)

                ScrollView {
                    LazyVStack(spacing: 16) {
                        progressCard

                        VStack(alignment: .leading, spacing: 12) {
                            Text(appState.text("Daily Prayers", "Solat Harian", "每日礼拜"))
                                .font(.headline)

                            ForEach(PrayerName.allCases) { prayer in
                                PrayerCheckRow(
                                    prayer: prayer,
                                    isCompleted: viewModel.todayRecord.completed[prayer] ?? false,
                                    language: appState.language
                                ) {
                                    viewModel.togglePrayer(prayer)
                                }
                            }
                        }
                        .wmCard()

                        WeeklyStatsCard(
                            weeklyCompletionRate: viewModel.weeklyCompletionRate,
                            currentStreak: viewModel.currentStreak
                        )
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, AppLayout.tabPageTopPadding)
                    .padding(.bottom, AppLayout.tabPageBottomPadding)
                }
                .smoothScroll()
                .wmTabSafeScroll()
            }
            .navigationTitle(appState.text("Tracker", "Jejak", "打卡"))
            .wmNavigationBar()
            .onAppear {
                viewModel.loadTodayRecord()
            }
        }
    }

    private var progressCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            ViewThatFits(in: .horizontal) {
                HStack(alignment: .top, spacing: 16) {
                    progressText
                    Spacer(minLength: 12)
                    progressRing
                }

                VStack(alignment: .leading, spacing: 14) {
                    progressText
                    progressRing
                }
            }

            ProgressView(value: Double(viewModel.completedCount), total: Double(PrayerName.allCases.count))
                .tint(.wmPrimary)
        }
        .wmCard()
    }

    private var progressText: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(appState.text("Today Progress", "Kemajuan Hari Ini", "今日进度"))
                .font(.headline)
                .fixedSize(horizontal: false, vertical: true)
            Text(appState.text(
                "\(viewModel.completedCount)/\(PrayerName.allCases.count) Completed",
                "\(viewModel.completedCount)/\(PrayerName.allCases.count) Selesai",
                "已完成 \(viewModel.completedCount)/\(PrayerName.allCases.count)"
            ))
                .font(.title.bold())
                .minimumScaleFactor(0.82)
                .fixedSize(horizontal: false, vertical: true)
        }
        .layoutPriority(1)
    }

    private var progressRing: some View {
        ZStack {
            Circle()
                .stroke(Color.wmMint, lineWidth: 8)
            Circle()
                .trim(from: 0, to: CGFloat(Double(viewModel.completedCount) / Double(PrayerName.allCases.count)))
                .stroke(Color.wmPrimary, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                .rotationEffect(.degrees(-90))
            Text("\(Int(Double(viewModel.completedCount) / Double(PrayerName.allCases.count) * 100))%")
                .font(.caption.bold())
        }
        .frame(width: 62, height: 62)
    }
}

#Preview {
    TrackerView()
}
