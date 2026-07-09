import SwiftUI

struct FaithHomeView: View {
    @EnvironmentObject private var appState: AppStateViewModel

    var body: some View {
        NavigationStack {
            ZStack {
                FaithBackgroundView(profile: appState.selectedFaithProfile)

                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 16) {
                        heroCard
                        ReferenceLibraryView(profile: appState.selectedFaithProfile)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, AppLayout.tabPageTopPadding)
                    .padding(.bottom, AppLayout.tabPageBottomPadding)
                }
                .smoothScroll()
                .wmTabSafeScroll()
            }
            .navigationTitle(appState.text("Home", "Utama", "主页"))
            .wmNavigationBar()
        }
    }

    private var heroCard: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(appState.selectedFaithProfile.localizedDisplayName(appState.language))
                        .font(.largeTitle.bold())
                        .fixedSize(horizontal: false, vertical: true)
                    Text(appState.selectedFaithProfile.localizedPracticeTitle(appState.language))
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(Color.wmPrimary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .layoutPriority(1)

                Spacer()

                Image(systemName: appState.selectedFaithProfile.symbolName)
                    .font(.system(size: 32, weight: .semibold))
                    .foregroundStyle(Color.wmPrimary)
                    .frame(width: 58, height: 58)
                    .background(Color.wmMint, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
            }

            Text(appState.selectedFaithProfile.localizedSubtitle(appState.language))
                .font(.body)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            Text(appState.text(
                "Open Tools for nearby places, compass, timer, and reading references.",
                "Buka Alat untuk tempat berdekatan, kompas, pemasa dan rujukan bacaan.",
                "打开工具页使用附近地点、指南针、定时器和参考资料。"
            ))
                .font(.footnote.weight(.medium))
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .wmCard()
    }
}

#Preview {
    FaithHomeView()
        .environmentObject(AppStateViewModel())
}
