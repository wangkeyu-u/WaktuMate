import SwiftUI

extension Color {
    static let wmPrimary = Color(red: 0.0, green: 0.55, blue: 0.42)
    static let wmPrimaryDark = Color(red: 0.0, green: 0.38, blue: 0.34)
    static let wmMint = Color(red: 0.78, green: 0.96, blue: 0.88)
    static let wmGold = Color(red: 0.93, green: 0.70, blue: 0.28)
    static let wmBackground = Color(.systemGroupedBackground)
    static let wmCard = Color(.secondarySystemGroupedBackground)
}

struct CardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(16)
            .background(Color.wmCard.opacity(0.96), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(Color(.separator).opacity(0.18), lineWidth: 1)
            }
    }
}

extension View {
    func wmCard() -> some View {
        modifier(CardModifier())
    }

    func smoothScroll() -> some View {
        self
            .scrollIndicators(.hidden)
            .scrollDismissesKeyboard(.interactively)
    }

    func wmNavigationBar() -> some View {
        self
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.wmBackground.opacity(0.96), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
    }

    func wmTabSafeScroll() -> some View {
        self
            .padding(.bottom, 96)
            .safeAreaInset(edge: .bottom, spacing: 0) {
                Color.clear
                    .frame(height: 24)
            }
    }
}

struct FaithBackgroundView: View {
    let profile: FaithProfile

    var body: some View {
        ZStack {
            Image(profile.backgroundAssetName)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            LinearGradient(
                colors: [
                    Color.wmBackground.opacity(0.48),
                    Color.wmBackground.opacity(0.76),
                    Color.wmBackground.opacity(0.95)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        }
        .background(Color.wmBackground)
    }
}

struct SmoothPressButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.975 : 1)
            .opacity(configuration.isPressed ? 0.86 : 1)
            .animation(.spring(response: 0.22, dampingFraction: 0.82), value: configuration.isPressed)
    }
}

extension ButtonStyle where Self == SmoothPressButtonStyle {
    static var smoothPress: SmoothPressButtonStyle {
        SmoothPressButtonStyle()
    }
}
