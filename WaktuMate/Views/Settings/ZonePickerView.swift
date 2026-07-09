import CoreLocation
import SwiftUI

struct ZonePickerView: View {
    @EnvironmentObject private var appState: AppStateViewModel
    @Binding var selectedZone: PrayerZone
    @StateObject private var locationService = LocationService()
    @State private var isDetectingZone = false
    @State private var pendingLocationDetection = false
    @State private var detectionMessage: String?

    private let prayerTimeService = PrayerTimeService()

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            NavigationLink {
                ZoneSelectionView(selectedZone: $selectedZone)
            } label: {
                HStack(alignment: .top, spacing: 12) {
                    zoneBadge(selectedZone.id)

                    VStack(alignment: .leading, spacing: 5) {
                        Text(selectedZone.state)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.primary)
                        Text(selectedZone.name)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .layoutPriority(1)

                    Image(systemName: "chevron.right")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.tertiary)
                }
                .padding(14)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.tertiarySystemGroupedBackground).opacity(0.78), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
            }
            .buttonStyle(.smoothPress)

            Button {
                detectCurrentZone()
            } label: {
                HStack(spacing: 10) {
                    if isDetectingZone {
                        ProgressView()
                            .controlSize(.small)
                    } else {
                        Image(systemName: "location.magnifyingglass")
                    }

                    Text(appState.text("Detect from Location", "Kesan melalui Lokasi", "用当前位置识别"))
                        .font(.subheadline.weight(.semibold))

                    Spacer(minLength: 0)
                }
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .tint(.wmPrimary)
            .disabled(isDetectingZone)

            if let message = detectionMessage ?? locationService.message {
                Text(message)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Text(appState.text(
                "\(PrayerZone.commonZones.count) Malaysia prayer zones included.",
                "\(PrayerZone.commonZones.count) zon waktu solat Malaysia disertakan.",
                "已内置 \(PrayerZone.commonZones.count) 个马来西亚礼拜区。"
            ))
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .onReceive(locationService.$location.compactMap { $0 }) { location in
            guard pendingLocationDetection else {
                return
            }

            pendingLocationDetection = false
            detectZone(from: location)
        }
    }

    private func zoneBadge(_ text: String) -> some View {
        Text(text)
            .font(.caption.weight(.bold).monospaced())
            .foregroundStyle(Color.wmPrimaryDark)
            .padding(.horizontal, 10)
            .padding(.vertical, 7)
            .background(Color.wmMint, in: Capsule())
    }

    private func detectCurrentZone() {
        detectionMessage = appState.text(
            "Getting your location...",
            "Mendapatkan lokasi anda...",
            "正在获取当前位置..."
        )

        if let location = locationService.location {
            detectZone(from: location)
            return
        }

        pendingLocationDetection = true
        locationService.requestLocation()
    }

    private func detectZone(from location: CLLocation) {
        isDetectingZone = true
        detectionMessage = appState.text(
            "Matching your location to a JAKIM zone...",
            "Memadankan lokasi anda dengan zon JAKIM...",
            "正在匹配 JAKIM 礼拜区..."
        )

        Task {
            do {
                let zone = try await prayerTimeService.detectPrayerZone(
                    latitude: location.coordinate.latitude,
                    longitude: location.coordinate.longitude
                )

                await MainActor.run {
                    selectedZone = zone
                    isDetectingZone = false
                    detectionMessage = appState.text(
                        "Matched \(zone.displayName).",
                        "Dipadankan dengan \(zone.displayName).",
                        "已匹配 \(zone.displayName)。"
                    )
                }
            } catch {
                await MainActor.run {
                    isDetectingZone = false
                    detectionMessage = error.localizedDescription
                }
            }
        }
    }
}

private struct ZoneSelectionView: View {
    @EnvironmentObject private var appState: AppStateViewModel
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedZone: PrayerZone
    @State private var searchText = ""

    private var filteredZones: [PrayerZone] {
        let trimmedSearch = searchText.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedSearch.isEmpty else {
            return PrayerZone.commonZones
        }

        return PrayerZone.commonZones.filter { zone in
            zone.id.localizedCaseInsensitiveContains(trimmedSearch)
            || zone.name.localizedCaseInsensitiveContains(trimmedSearch)
            || zone.state.localizedCaseInsensitiveContains(trimmedSearch)
        }
    }

    private var visibleStates: [String] {
        Array(Set(filteredZones.map(\.state))).sorted()
    }

    var body: some View {
        List {
            ForEach(visibleStates, id: \.self) { state in
                Section(state) {
                    ForEach(filteredZones.filter { $0.state == state }) { zone in
                        Button {
                            selectedZone = zone
                            dismiss()
                        } label: {
                            HStack(alignment: .top, spacing: 12) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(zone.id)
                                        .font(.caption.weight(.bold).monospaced())
                                        .foregroundStyle(Color.wmPrimary)

                                    Text(zone.name)
                                        .font(.subheadline)
                                        .foregroundStyle(.primary)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                                .layoutPriority(1)

                                if selectedZone.id == zone.id {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(Color.wmPrimary)
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle(appState.text("Malaysia Zone", "Zon Malaysia", "马来西亚地区"))
        .navigationBarTitleDisplayMode(.inline)
        .searchable(
            text: $searchText,
            prompt: appState.text("Search state, district, or code", "Cari negeri, daerah, atau kod", "搜索州、地区或代码")
        )
    }
}

#Preview {
    NavigationStack {
        ZonePickerView(selectedZone: .constant(.defaultZone))
            .padding()
            .environmentObject(AppStateViewModel())
    }
}
