import SwiftUI

struct MainTabView: View {
    @EnvironmentObject private var appState: AppStateViewModel

    var body: some View {
        TabView {
            if appState.selectedFaithProfile.supportsPrayerTimes {
                TodayView()
                    .tabItem {
                        Label(appState.text("Today", "Hari Ini", "今日"), systemImage: "clock.badge.checkmark")
                    }

                TrackerView()
                    .tabItem {
                        Label(appState.text("Tracker", "Jejak", "打卡"), systemImage: "checklist.checked")
                    }
            } else {
                FaithHomeView()
                    .tabItem {
                        Label(appState.text("Home", "Utama", "主页"), systemImage: appState.selectedFaithProfile.symbolName)
                    }
            }

            ToolsView()
                .tabItem {
                    Label(appState.text("Tools", "Alat", "工具"), systemImage: "circle.grid.2x2")
                }

            SettingsView()
                .tabItem {
                    Label(appState.text("Settings", "Tetapan", "设置"), systemImage: "gearshape")
                }
        }
        .tint(.wmPrimary)
        .toolbarBackground(Color.wmBackground.opacity(0.96), for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
    }
}
