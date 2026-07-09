import SwiftUI

struct ToolsView: View {
    @EnvironmentObject private var appState: AppStateViewModel
    @Environment(\.openURL) private var openURL
    @StateObject private var locationService = LocationService()

    var body: some View {
        NavigationStack {
            ZStack {
                FaithBackgroundView(profile: appState.selectedFaithProfile)

                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 16) {
                        header
                        quickActionDock

                        NearbyPlaceNavigationView(
                            profile: appState.selectedFaithProfile,
                            locationService: locationService
                        )

                        if appState.selectedFaithProfile.supportsQibla {
                            QiblaCompassView(locationService: locationService)
                        }

                        PracticeTimerView(profile: appState.selectedFaithProfile)

                        if appState.selectedFaithProfile.id == .islam {
                            TasbihCounterView()
                        }

                        ReferenceLibraryView(profile: appState.selectedFaithProfile)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, AppLayout.tabPageTopPadding)
                    .padding(.bottom, AppLayout.tabPageBottomPadding)
                }
                .smoothScroll()
                .wmTabSafeScroll()
            }
            .navigationTitle(appState.text("Tools", "Alat", "工具"))
            .wmNavigationBar()
            .onDisappear {
                locationService.stopCompass()
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top, spacing: 14) {
                Image(systemName: appState.selectedFaithProfile.symbolName)
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 58, height: 58)
                    .background(
                        LinearGradient(
                            colors: [.wmPrimaryDark, .wmPrimary],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        in: RoundedRectangle(cornerRadius: 20, style: .continuous)
                    )

                VStack(alignment: .leading, spacing: 5) {
                    Text(appState.selectedFaithProfile.localizedDisplayName(appState.language))
                        .font(.title2.bold())
                        .fixedSize(horizontal: false, vertical: true)
                    Text(appState.selectedFaithProfile.localizedPracticeTitle(appState.language))
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Color.wmPrimary)
                    Text(appState.text(
                        "Pick a tool, then get out of the way.",
                        "Pilih alat, kemudian teruskan amalan.",
                        "选好工具，少打扰、多完成。"
                    ))
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                }
                .layoutPriority(1)
            }

            HStack(spacing: 8) {
                toolCapabilityPill(appState.selectedFaithProfile.localizedPlaceTitle(appState.language), systemImage: "map.fill")
                toolCapabilityPill(appState.text("Timer", "Pemasa", "定时"), systemImage: "timer")
                if appState.selectedFaithProfile.supportsQibla {
                    toolCapabilityPill(appState.text("Qibla", "Kiblat", "朝向"), systemImage: "safari.fill")
                }
            }
            .font(.caption.weight(.semibold))
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(Color.white.opacity(0.18), lineWidth: 1)
        }
    }

    private var quickActionDock: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 12) {
                ToolShortcutButton(
                    title: appState.text("Use Location", "Guna Lokasi", "使用定位"),
                    subtitle: appState.text("Prepare nearby tools", "Sediakan alat berdekatan", "准备附近工具"),
                    systemImage: "location.fill",
                    tint: .wmPrimary
                ) {
                    locationService.requestLocation()
                }

                ToolShortcutButton(
                    title: appState.text("Open Maps", "Buka Maps", "打开地图"),
                    subtitle: appState.selectedFaithProfile.localizedPlaceTitle(appState.language),
                    systemImage: "arrow.triangle.turn.up.right.diamond.fill",
                    tint: .wmGold
                ) {
                    openGoogleMaps()
                }

                if appState.selectedFaithProfile.supportsQibla {
                    ToolShortcutButton(
                        title: appState.text("Start Compass", "Mula Kompas", "启动指南针"),
                        subtitle: appState.text("Live bearing", "Arah langsung", "实时朝向"),
                        systemImage: "location.north.line.fill",
                        tint: .wmPrimaryDark
                    ) {
                        locationService.startCompass()
                    }
                }
            }
            .padding(.horizontal, 1)
        }
        .scrollIndicators(.hidden)
    }

    private func toolCapabilityPill(_ title: String, systemImage: String) -> some View {
        Label(title, systemImage: systemImage)
            .lineLimit(1)
            .padding(.horizontal, 9)
            .padding(.vertical, 6)
            .background(Color(.tertiarySystemGroupedBackground).opacity(0.82), in: Capsule())
    }

    private func openGoogleMaps() {
        let query = appState.selectedFaithProfile.placeSearchQuery
        guard let appURL = locationService.googleMapsURL(for: query),
              let fallbackURL = locationService.googleMapsWebURL(for: query) else {
            return
        }

        openURL(appURL) { accepted in
            if !accepted {
                openURL(fallbackURL)
            }
        }
    }
}

private struct ToolShortcutButton: View {
    let title: String
    let subtitle: String
    let systemImage: String
    let tint: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 10) {
                Image(systemName: systemImage)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: 36, height: 36)
                    .background(tint, in: RoundedRectangle(cornerRadius: 12, style: .continuous))

                VStack(alignment: .leading, spacing: 3) {
                    Text(title)
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(.primary)
                        .lineLimit(1)

                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .padding(14)
            .frame(width: 158, alignment: .leading)
            .background(Color.wmCard.opacity(0.94), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(tint.opacity(0.2), lineWidth: 1)
            }
        }
        .buttonStyle(.smoothPress)
    }
}

#Preview {
    ToolsView()
        .environmentObject(AppStateViewModel())
}
