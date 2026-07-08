import SwiftUI

struct PrayerTimeRow: View {
    let row: PrayerDisplayRow
    let isNext: Bool
    let uses24HourTime: Bool
    let language: AppLanguage

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: row.systemImage)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(isNext ? Color.wmPrimary : .secondary)
                .frame(width: 34, height: 34)
                .background((isNext ? Color.wmMint : Color(.tertiarySystemGroupedBackground)), in: Circle())

            VStack(alignment: .leading, spacing: 3) {
                Text(localizedTitle)
                    .font(.body.weight(.semibold))
                    .fixedSize(horizontal: false, vertical: true)

                if row.prayer == nil {
                    Text(LocalizedText(english: "Display only", malay: "Paparan sahaja", chinese: "仅显示").text(language))
                        .font(.caption2.weight(.medium))
                        .padding(.horizontal, 7)
                        .padding(.vertical, 3)
                        .background(Color(.tertiarySystemGroupedBackground), in: Capsule())
                        .foregroundStyle(.secondary)
                }

                if isNext {
                    Text(LocalizedText(english: "Upcoming", malay: "Akan datang", chinese: "即将到来").text(language))
                        .font(.caption)
                        .foregroundStyle(Color.wmPrimary)
                }
            }
            .layoutPriority(1)

            Spacer()

            Text(AppDateFormatting.displayTime(row.time, uses24HourTime: uses24HourTime))
                .font(.headline.monospacedDigit())
                .foregroundStyle(isNext ? Color.wmPrimary : .primary)
                .lineLimit(1)
                .minimumScaleFactor(0.88)
        }
        .padding(12)
        .background(isNext ? Color.wmMint.opacity(0.62) : Color.clear, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private var localizedTitle: String {
        if let prayer = row.prayer {
            return prayer.localizedName(language)
        }

        switch language {
        case .english:
            return row.title
        case .malay:
            return row.title
        case .chinese:
            return "日出"
        }
    }
}

#Preview {
    PrayerTimeRow(
        row: PrayerDisplayRow(id: "asar", title: "Asar", time: "16:32", systemImage: "sun.haze.fill", prayer: .asar),
        isNext: true,
        uses24HourTime: false,
        language: .english
    )
    .padding()
}
