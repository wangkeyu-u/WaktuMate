import SwiftUI

struct PrayerCheckRow: View {
    let prayer: PrayerName
    let isCompleted: Bool
    let language: AppLanguage
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Image(systemName: prayer.systemImage)
                    .foregroundStyle(isCompleted ? .white : Color.wmPrimary)
                    .frame(width: 36, height: 36)
                    .background(isCompleted ? Color.wmPrimary : Color.wmMint, in: Circle())

                Text(prayer.localizedName(language))
                    .font(.body.weight(.semibold))
                    .foregroundStyle(.primary)
                    .fixedSize(horizontal: false, vertical: true)
                    .layoutPriority(1)

                Spacer()

                Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(isCompleted ? Color.wmPrimary : .secondary)
            }
            .padding(12)
            .background(Color(.tertiarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    PrayerCheckRow(prayer: .subuh, isCompleted: true, language: .english) {}
        .padding()
}
