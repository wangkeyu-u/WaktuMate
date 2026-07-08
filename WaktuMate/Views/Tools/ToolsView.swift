import SwiftUI

struct ToolsView: View {
    @EnvironmentObject private var appState: AppStateViewModel
    @StateObject private var locationService = LocationService()

    var body: some View {
        NavigationStack {
            ZStack {
                FaithBackgroundView(profile: appState.selectedFaithProfile)

                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 16) {
                        header

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
                    .padding(.top, 18)
                    .padding(.bottom, 96)
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
        VStack(alignment: .leading, spacing: 8) {
            Text(appState.selectedFaithProfile.localizedDisplayName(appState.language))
                .font(.title.bold())
                .fixedSize(horizontal: false, vertical: true)
            Text(appState.text(
                "Tools adapted for \(appState.selectedFaithProfile.localizedPracticeTitle(appState.language)).",
                "Alat disesuaikan untuk \(appState.selectedFaithProfile.localizedPracticeTitle(appState.language)).",
                "工具已根据\(appState.selectedFaithProfile.localizedPracticeTitle(appState.language))调整。"
            ))
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    ToolsView()
        .environmentObject(AppStateViewModel())
}
