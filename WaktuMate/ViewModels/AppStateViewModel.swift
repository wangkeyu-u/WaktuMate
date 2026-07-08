import Foundation

@MainActor
final class AppStateViewModel: ObservableObject {
    @Published private(set) var selectedFaithProfile: FaithProfile
    @Published private(set) var hasCompletedOnboarding: Bool
    @Published private(set) var hasSelectedInitialLanguage: Bool
    @Published private(set) var language: AppLanguage

    private let storage: StorageService

    init(storage: StorageService = .shared) {
        self.storage = storage
        selectedFaithProfile = storage.selectedFaithProfile()
        hasCompletedOnboarding = storage.hasCompletedOnboarding()
        hasSelectedInitialLanguage = storage.hasSelectedInitialLanguage() || storage.hasCompletedOnboarding()
        language = storage.selectedLanguage()
        storage.markAppOpened()
    }

    func completeLanguageSelection(with language: AppLanguage) {
        self.language = language
        hasSelectedInitialLanguage = true
        storage.saveSelectedLanguage(language)
        storage.saveHasSelectedInitialLanguage(true)
    }

    func completeOnboarding(with profile: FaithProfile) {
        selectedFaithProfile = profile
        hasCompletedOnboarding = true
        hasSelectedInitialLanguage = true
        storage.saveSelectedFaithProfile(profile)
        storage.saveHasCompletedOnboarding(true)
        storage.saveHasSelectedInitialLanguage(true)
    }

    func updateFaithProfile(_ profile: FaithProfile) {
        selectedFaithProfile = profile
        storage.saveSelectedFaithProfile(profile)
    }

    func updateLanguage(_ language: AppLanguage) {
        self.language = language
        storage.saveSelectedLanguage(language)
    }

    func text(_ english: String, _ malay: String, _ chinese: String) -> String {
        String.localized(english, malay, chinese, language: language)
    }
}
