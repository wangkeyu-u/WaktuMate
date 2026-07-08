import SwiftUI

struct LanguageOnboardingView: View {
    @EnvironmentObject private var appState: AppStateViewModel
    @State private var selectedLanguage = AppLanguage.preferredDefault

    var body: some View {
        ZStack {
            FaithBackgroundView(profile: FaithProfile.profile(for: .general))

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 12) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("WaktuMate Malaysia")
                                .font(.largeTitle.bold())
                                .fixedSize(horizontal: false, vertical: true)

                            Text("Choose your language")
                                .font(.title3.weight(.semibold))
                                .foregroundStyle(Color.wmPrimary)

                            Text("Pilih bahasa / 选择语言")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    VStack(spacing: 12) {
                        ForEach(AppLanguage.allCases) { language in
                            languageCard(language)
                        }
                    }

                    continueButton
                }
                .padding(.horizontal, 16)
                .padding(.top, 24)
                .padding(.bottom, 24)
            }
            .smoothScroll()
        }
        .onAppear {
            selectedLanguage = appState.language
        }
    }

    private var continueButton: some View {
        Button {
            appState.completeLanguageSelection(with: selectedLanguage)
        } label: {
            Text(LocalizedText(
                english: "Continue",
                malay: "Teruskan",
                chinese: "继续"
            ).text(selectedLanguage))
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.wmPrimary, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                .foregroundStyle(.white)
        }
        .buttonStyle(.smoothPress)
    }

    private func languageCard(_ language: AppLanguage) -> some View {
        Button {
            selectedLanguage = language
        } label: {
            HStack(alignment: .top, spacing: 14) {
                Image(systemName: language == selectedLanguage ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(language == selectedLanguage ? Color.wmPrimary : .secondary)
                    .frame(width: 28)

                VStack(alignment: .leading, spacing: 5) {
                    Text(language.displayName)
                        .font(.headline)
                        .foregroundStyle(.primary)
                        .fixedSize(horizontal: false, vertical: true)

                    Text(language.interfaceDescription)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .layoutPriority(1)

                Spacer(minLength: 0)
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                language == selectedLanguage ? Color.wmMint.opacity(0.78) : Color.wmCard.opacity(0.96),
                in: RoundedRectangle(cornerRadius: 16, style: .continuous)
            )
            .overlay {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(language == selectedLanguage ? Color.wmPrimary.opacity(0.55) : Color(.separator).opacity(0.18), lineWidth: 1)
            }
        }
        .buttonStyle(.smoothPress)
    }
}

struct FaithOnboardingView: View {
    @EnvironmentObject private var appState: AppStateViewModel
    @State private var selectedProfile = FaithProfile.default

    var body: some View {
        ZStack {
            FaithBackgroundView(profile: selectedProfile)

            ScrollView {
                LazyVStack(alignment: .leading, spacing: 22) {
                    header

                    LazyVStack(spacing: 12) {
                        ForEach(FaithProfile.all) { profile in
                            faithCard(profile)
                        }
                    }

                    continueButton
                }
                .padding(.horizontal, 16)
                .padding(.top, 24)
                .padding(.bottom, 24)
            }
            .smoothScroll()
        }
        .onAppear {
            selectedProfile = appState.selectedFaithProfile
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(appState.text("Choose Your Version", "Pilih Versi Anda", "选择你的版本"))
                .font(.largeTitle.bold())
                .fixedSize(horizontal: false, vertical: true)

            Text(appState.text(
                "Pick the faith profile that fits your daily practice. You can change this later in Settings.",
                "Pilih profil agama yang sesuai dengan amalan harian anda. Anda boleh menukarnya kemudian di Tetapan.",
                "选择适合你日常习惯的信仰版本。之后也可以在设置里更改。"
            ))
                .font(.body)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func faithCard(_ profile: FaithProfile) -> some View {
        Button {
            selectedProfile = profile
        } label: {
            HStack(spacing: 14) {
                Image(systemName: profile.symbolName)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(profile == selectedProfile ? .white : Color.wmPrimary)
                    .frame(width: 42, height: 42)
                    .background(profile == selectedProfile ? Color.wmPrimary : Color.wmMint, in: Circle())

                VStack(alignment: .leading, spacing: 4) {
                    Text(profile.localizedDisplayName(appState.language))
                        .font(.headline)
                        .foregroundStyle(.primary)
                        .fixedSize(horizontal: false, vertical: true)
                    Text(profile.localizedSubtitle(appState.language))
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .layoutPriority(1)

                Spacer(minLength: 12)

                Image(systemName: profile == selectedProfile ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(profile == selectedProfile ? Color.wmPrimary : .secondary)
            }
            .padding(14)
                .background(
                    profile == selectedProfile ? Color.wmMint.opacity(0.78) : Color.wmCard.opacity(0.96),
                    in: RoundedRectangle(cornerRadius: 16, style: .continuous)
                )
                .overlay {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(profile == selectedProfile ? Color.wmPrimary.opacity(0.55) : Color(.separator).opacity(0.18), lineWidth: 1)
                }
        }
        .buttonStyle(.smoothPress)
    }

    private var continueButton: some View {
        Button {
            appState.completeOnboarding(with: selectedProfile)
        } label: {
            Text(appState.text(
                "Continue with \(selectedProfile.localizedDisplayName(appState.language))",
                "Teruskan dengan \(selectedProfile.localizedDisplayName(appState.language))",
                "继续使用\(selectedProfile.localizedDisplayName(appState.language))"
            ))
                .font(.headline)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.84)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.wmPrimary, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                .foregroundStyle(.white)
        }
        .buttonStyle(.smoothPress)
    }
}

#Preview {
    FaithOnboardingView()
        .environmentObject(AppStateViewModel())
}
