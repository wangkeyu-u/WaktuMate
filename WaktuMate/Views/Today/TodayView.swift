import SwiftUI

struct TodayView: View {
    @EnvironmentObject private var appState: AppStateViewModel
    @StateObject private var viewModel = TodayViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                FaithBackgroundView(profile: appState.selectedFaithProfile)

                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 18) {
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

                        todayRhythmStrip
                        prayerTimelineSection
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, AppLayout.tabPageTopPadding)
                    .padding(.bottom, AppLayout.tabPageBottomPadding)
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
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top, spacing: 14) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(appState.text("Today in", "Hari ini di", "今日地区"))
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .textCase(.uppercase)

                    Text(viewModel.selectedZone.state)
                        .font(.title2.bold())
                        .fixedSize(horizontal: false, vertical: true)

                    Text(viewModel.selectedZone.name)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .layoutPriority(1)

                Image(systemName: appState.selectedFaithProfile.symbolName)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(Color.wmPrimary)
                    .frame(width: 52, height: 52)
                    .background(Color.wmMint, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
            }

            ViewThatFits(in: .horizontal) {
                HStack(spacing: 8) {
                    infoChip(viewModel.currentDateText, systemImage: "calendar")
                    if let hijri = viewModel.todayPrayerTime?.hijri {
                        infoChip(appState.text("Hijri", "Hijri", "回历") + " \(hijri)", systemImage: "moonphase.waxing.crescent")
                    }
                }

                VStack(alignment: .leading, spacing: 8) {
                    infoChip(viewModel.currentDateText, systemImage: "calendar")
                    if let hijri = viewModel.todayPrayerTime?.hijri {
                        infoChip(appState.text("Hijri", "Hijri", "回历") + " \(hijri)", systemImage: "moonphase.waxing.crescent")
                    }
                }
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(Color.white.opacity(0.18), lineWidth: 1)
        }
    }

    private var todayRhythmStrip: some View {
        ViewThatFits(in: .horizontal) {
            HStack(spacing: 10) {
                TodayStatusTile(
                    title: appState.text("Completed", "Selesai", "已过"),
                    value: "\(viewModel.completedPrayerCount)/\(viewModel.totalPrayerCount)",
                    systemImage: "checkmark.seal.fill",
                    tint: .wmPrimary
                )
                TodayStatusTile(
                    title: appState.text("Prayer Window", "Julat Solat", "今日时段"),
                    value: viewModel.dayWindowText,
                    systemImage: "clock.fill",
                    tint: .wmGold
                )
                TodayStatusTile(
                    title: appState.text("Source", "Sumber", "来源"),
                    value: viewModel.isUsingFallbackData ? appState.text("Offline", "Luar talian", "离线") : appState.text("Live", "Langsung", "在线"),
                    systemImage: viewModel.isUsingFallbackData ? "tray.and.arrow.down.fill" : "antenna.radiowaves.left.and.right",
                    tint: viewModel.isUsingFallbackData ? Color(.secondaryLabel) : .wmPrimaryDark
                )
            }

            VStack(spacing: 10) {
                TodayStatusTile(
                    title: appState.text("Completed", "Selesai", "已过"),
                    value: "\(viewModel.completedPrayerCount)/\(viewModel.totalPrayerCount)",
                    systemImage: "checkmark.seal.fill",
                    tint: .wmPrimary
                )
                TodayStatusTile(
                    title: appState.text("Prayer Window", "Julat Solat", "今日时段"),
                    value: viewModel.dayWindowText,
                    systemImage: "clock.fill",
                    tint: .wmGold
                )
                TodayStatusTile(
                    title: appState.text("Source", "Sumber", "来源"),
                    value: viewModel.isUsingFallbackData ? appState.text("Offline", "Luar talian", "离线") : appState.text("Live", "Langsung", "在线"),
                    systemImage: viewModel.isUsingFallbackData ? "tray.and.arrow.down.fill" : "antenna.radiowaves.left.and.right",
                    tint: viewModel.isUsingFallbackData ? Color(.secondaryLabel) : .wmPrimaryDark
                )
            }
        }
    }

    private var prayerTimelineSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .firstTextBaseline) {
                Text(appState.text("Prayer Timeline", "Garis Masa Solat", "礼拜时间轴"))
                    .font(.headline)

                Spacer()

                Text(viewModel.selectedZone.id)
                    .font(.caption.weight(.bold).monospaced())
                    .foregroundStyle(Color.wmPrimary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.wmMint, in: Capsule())
            }

            if viewModel.isLoading && viewModel.todayPrayerTime == nil {
                ProgressView()
                    .frame(maxWidth: .infinity, minHeight: 150)
            } else if let prayerTime = viewModel.todayPrayerTime {
                ForEach(Array(prayerTime.displayRows.enumerated()), id: \.element.id) { index, row in
                    PrayerTimeRow(
                        row: row,
                        isNext: row.prayer == viewModel.nextPrayerName,
                        isPassed: viewModel.hasPassed(row),
                        isLast: index == prayerTime.displayRows.count - 1,
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
        .padding(16)
        .background(Color.wmCard.opacity(0.95), in: RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay(alignment: .leading) {
            RoundedRectangle(cornerRadius: 2, style: .continuous)
                .fill(Color.wmPrimary)
                .frame(width: 4)
                .padding(.vertical, 18)
        }
        .overlay {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(Color(.separator).opacity(0.14), lineWidth: 1)
        }
    }

    private func infoChip(_ text: String, systemImage: String) -> some View {
        Label(text, systemImage: systemImage)
            .font(.caption.weight(.semibold))
            .foregroundStyle(.secondary)
            .padding(.horizontal, 10)
            .padding(.vertical, 7)
            .background(Color(.tertiarySystemGroupedBackground).opacity(0.82), in: Capsule())
    }
}

private struct TodayStatusTile: View {
    let title: String
    let value: String
    let systemImage: String
    let tint: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: systemImage)
                .font(.system(size: 15, weight: .bold))
                .foregroundStyle(tint)
                .frame(width: 30, height: 30)
                .background(tint.opacity(0.13), in: RoundedRectangle(cornerRadius: 10, style: .continuous))

            Text(value)
                .font(.subheadline.weight(.bold))
                .lineLimit(1)
                .minimumScaleFactor(0.76)

            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(13)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

#Preview {
    TodayView()
}
