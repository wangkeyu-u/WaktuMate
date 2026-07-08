import SwiftUI

struct NextPrayerCard: View {
    let title: String
    let remainingTitle: String
    let prayerName: String
    let timeText: String
    let countdownText: String

    var body: some View {
        let cardShape = RoundedRectangle(cornerRadius: 18, style: .continuous)

        VStack(alignment: .leading, spacing: 22) {
            HStack {
                Label(title, systemImage: "sparkle.magnifyingglass")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.86))
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
            }

            VStack(alignment: .leading, spacing: 8) {
                Text(prayerName)
                    .font(.system(size: 38, weight: .bold, design: .rounded))
                    .lineLimit(2)
                    .minimumScaleFactor(0.78)
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundStyle(.white)

                Text(timeText)
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.88))
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(remainingTitle)
                    .font(.caption.weight(.medium))
                    .textCase(.uppercase)
                    .foregroundStyle(.white.opacity(0.7))

                Text(countdownText)
                    .font(.system(size: 34, weight: .bold, design: .monospaced))
                    .minimumScaleFactor(0.72)
                    .lineLimit(1)
                    .foregroundStyle(.white)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            LinearGradient(
                colors: [.wmPrimaryDark, .wmPrimary, Color(red: 0.12, green: 0.68, blue: 0.58)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            in: cardShape
        )
        .overlay(alignment: .topTrailing) {
            Image(systemName: "moonphase.waxing.crescent")
                .font(.system(size: 92))
                .foregroundStyle(.white.opacity(0.10))
                .padding(12)
                .accessibilityHidden(true)
        }
        .clipShape(cardShape)
    }
}

#Preview {
    NextPrayerCard(title: "Next Prayer", remainingTitle: "Time remaining", prayerName: "Asar", timeText: "4:32 PM", countdownText: "02h 14m 33s")
        .padding()
}
