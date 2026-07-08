import SwiftUI
import UIKit

@main
struct WaktuMateApp: App {
    @StateObject private var appState = AppStateViewModel()

    init() {
        let navigationAppearance = UINavigationBarAppearance()
        navigationAppearance.configureWithOpaqueBackground()
        navigationAppearance.backgroundColor = UIColor.systemGroupedBackground
        UINavigationBar.appearance().standardAppearance = navigationAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationAppearance
        UINavigationBar.appearance().compactAppearance = navigationAppearance

        let tabAppearance = UITabBarAppearance()
        tabAppearance.configureWithOpaqueBackground()
        tabAppearance.backgroundColor = UIColor.systemGroupedBackground
        UITabBar.appearance().standardAppearance = tabAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabAppearance
    }

    var body: some Scene {
        WindowGroup {
            Group {
                if !appState.hasSelectedInitialLanguage {
                    LanguageOnboardingView()
                } else if !appState.hasCompletedOnboarding {
                    FaithOnboardingView()
                } else {
                    MainTabView()
                }
            }
            .environmentObject(appState)
        }
    }
}
