import SwiftUI

struct PrayerTimeRow: View {
    let row: PrayerDisplayRow
    let isNext: Bool
    let isPassed: Bool
    let isLast: Bool
    let uses24HourTime: Bool
    let language: AppLanguage

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            timelineMarker

            VStack(alignment: .leading, spacing: 6) {
                HStack(alignment: .firstTextBaseline) {
                    Text(localizedTitle)
                        .font(.body.weight(.semibold))
                        .fixedSize(horizontal: false, vertical: true)

                    Spacer(minLength: 8)

                    Text(AppDateFormatting.displayTime(row.time, uses24HourTime: uses24HourTime))
                        .font(.headline.monospacedDigit())
                        .foregroundStyle(isNext ? Color.wmPrimary : .primary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.88)
                }

                HStack(spacing: 6) {
                    if row.prayer == nil {
                        statusPill(
                            LocalizedText(english: "Display only", malay: "Paparan sahaja", chinese: "仅显示").text(language),
                            color: .secondary
                        )
                    }

                    if isNext {
                        statusPill(
                            LocalizedText(english: "Upcoming", malay: "Akan datang", chinese: "即将到来").text(language),
                            color: .wmPrimary
                        )
                    } else if isPassed && row.prayer != nil {
                        statusPill(
                            LocalizedText(english: "Time passed", malay: "Waktu berlalu", chinese: "时间已过").text(language),
                            color: .secondary
                        )
                    }
                }
            }
            .layoutPriority(1)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, isNext ? 10 : 0)
        .background(isNext ? Color.wmMint.opacity(0.62) : Color.clear, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private var timelineMarker: some View {
        VStack(spacing: 6) {
            ZStack {
                Circle()
                    .fill(markerBackground)
                    .frame(width: 34, height: 34)

                Image(systemName: isPassed && row.prayer != nil ? "checkmark" : row.systemImage)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(markerForeground)
            }

            if !isLast {
                Rectangle()
                    .fill(Color(.separator).opacity(0.32))
                    .frame(width: 2, height: 26)
            }
        }
    }

    private var markerBackground: Color {
        if isNext {
            return .wmPrimary
        }

        if isPassed && row.prayer != nil {
            return .wmMint
        }

        return Color(.tertiarySystemGroupedBackground)
    }

    private var markerForeground: Color {
        if isNext {
            return .white
        }

        if isPassed && row.prayer != nil {
            return .wmPrimaryDark
        }

        return .secondary
    }

    private func statusPill(_ text: String, color: Color) -> some View {
        Text(text)
            .font(.caption2.weight(.semibold))
            .padding(.horizontal, 7)
            .padding(.vertical, 3)
            .background(color.opacity(0.12), in: Capsule())
            .foregroundStyle(color)
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
        isPassed: false,
        isLast: false,
        uses24HourTime: false,
        language: .english
    )
    .padding()
}
