import SwiftUI

struct TodayView: View {
    @EnvironmentObject private var appState: AppStateViewModel
    @StateObject private var viewModel = TodayViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                FaithBackgroundView(profile: appState.selectedFaithProfile)

                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 16) {
                        header

                        if let errorMessage = viewModel.errorMessage {
                            Label(errorMessage, systemImage: "wifi.exclamationmark")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                                .padding(12)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                        }

                        NextPrayerCard(
                            title: appState.text("Next Prayer", "Solat Seterusnya", "下一次礼拜"),
                            remainingTitle: appState.text("Time remaining", "Masa berbaki", "剩余时间"),
                            prayerName: viewModel.nextPrayerName?.localizedName(appState.language) ?? appState.text("Loading", "Memuatkan", "加载中"),
                            timeText: viewModel.nextPrayerTimeText,
                            countdownText: viewModel.countdownText
                        )

                        VStack(alignment: .leading, spacing: 12) {
                            Text(appState.text("Today's Prayer Times", "Waktu Solat Hari Ini", "今日礼拜时间"))
                                .font(.headline)

                            if viewModel.isLoading && viewModel.todayPrayerTime == nil {
                                ProgressView()
                                    .frame(maxWidth: .infinity, minHeight: 120)
                            } else if let prayerTime = viewModel.todayPrayerTime {
                                ForEach(prayerTime.displayRows) { row in
                                    PrayerTimeRow(
                                        row: row,
                                        isNext: row.prayer == viewModel.nextPrayerName,
                                        uses24HourTime: viewModel.uses24HourTime,
                                        language: appState.language
                                    )
                                }
                            } else {
                                ContentUnavailableView(
                                    appState.text("No Prayer Times", "Tiada Waktu Solat", "没有礼拜时间"),
                                    systemImage: "calendar.badge.exclamationmark",
                                    description: Text(appState.text("Tap refresh to try loading again.", "Tekan segar semula untuk cuba lagi.", "点击刷新重试。"))
                                )
                                .frame(minHeight: 180)
                            }
                        }
                        .wmCard()
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 18)
                    .padding(.bottom, 96)
                }
                .smoothScroll()
                .wmTabSafeScroll()
            }
            .navigationTitle(appState.text("Today", "Hari Ini", "今日"))
            .wmNavigationBar()
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.refresh()
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                    .disabled(viewModel.isLoading)
                }
            }
            .task {
                await viewModel.loadTodayPrayerTimes()
            }
            .onAppear {
                viewModel.syncSelectedZoneIfNeeded()
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top, spacing: 10) {
                Image(systemName: "mappin.and.ellipse")
                    .foregroundStyle(Color.wmPrimary)

                VStack(alignment: .leading, spacing: 3) {
                    Text(viewModel.selectedZone.displayName)
                        .font(.subheadline.weight(.semibold))
                    Text(viewModel.currentDateText)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                    if let hijri = viewModel.todayPrayerTime?.hijri {
                        Text(appState.text("Hijri", "Hijri", "回历") + " \(hijri)")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .layoutPriority(1)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    TodayView()
}
