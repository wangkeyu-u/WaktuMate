import SwiftUI

struct ZonePickerView: View {
    @Binding var selectedZone: PrayerZone

    var body: some View {
        Picker("Zone", selection: Binding(
            get: { selectedZone.id },
            set: { selectedZone = PrayerZone.zone(for: $0) }
        )) {
            ForEach(PrayerZone.commonZones) { zone in
                VStack(alignment: .leading) {
                    Text(zone.displayName)
                    Text(zone.state)
                }
                .tag(zone.id)
            }
        }
        .pickerStyle(.navigationLink)

        VStack(alignment: .leading, spacing: 4) {
            Text(selectedZone.name)
                .font(.subheadline.weight(.semibold))
            Text(selectedZone.state)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    ZonePickerView(selectedZone: .constant(.defaultZone))
        .padding()
}
