import SwiftUI

struct NearbyPlaceNavigationView: View {
    @EnvironmentObject private var appState: AppStateViewModel
    let profile: FaithProfile
    @ObservedObject var locationService: LocationService
    @Environment(\.openURL) private var openURL

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 12) {
                toolIcon("map.fill")
                VStack(alignment: .leading, spacing: 3) {
                    Text(profile.localizedPlaceTitle(appState.language))
                        .font(.headline)
                        .fixedSize(horizontal: false, vertical: true)
                    Text(appState.text(
                        "Open Google Maps around your current location.",
                        "Buka Google Maps berdasarkan lokasi semasa anda.",
                        "使用当前位置打开 Google Maps。"
                    ))
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .layoutPriority(1)
            }

            if let coordinate = locationService.location?.coordinate {
                Text(String(format: "Location ready: %.4f, %.4f", coordinate.latitude, coordinate.longitude))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            } else if let message = locationService.message {
                Text(message)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            ViewThatFits(in: .horizontal) {
                HStack(spacing: 10) {
                    requestLocationButton
                    openMapsButton
                }

                VStack(spacing: 10) {
                    requestLocationButton
                    openMapsButton
                }
            }
        }
        .wmCard()
    }

    private var requestLocationButton: some View {
        Button {
            locationService.requestLocation()
        } label: {
            Label(appState.text("Use Location", "Guna Lokasi", "使用定位"), systemImage: "location.fill")
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.bordered)
        .tint(.wmPrimary)
    }

    private var openMapsButton: some View {
        Button {
            openGoogleMaps()
        } label: {
            Label(appState.text("Open Maps", "Buka Maps", "打开地图"), systemImage: "arrow.triangle.turn.up.right.diamond.fill")
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .tint(.wmPrimary)
    }

    private func openGoogleMaps() {
        let query = profile.placeSearchQuery
        guard let appURL = locationService.googleMapsURL(for: query),
              let fallbackURL = locationService.googleMapsWebURL(for: query) else {
            return
        }

        openURL(appURL) { accepted in
            if !accepted {
                openURL(fallbackURL)
            }
        }
    }
}

struct QiblaCompassView: View {
    @EnvironmentObject private var appState: AppStateViewModel
    @ObservedObject var locationService: LocationService

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(spacing: 12) {
                toolIcon("safari.fill")
                VStack(alignment: .leading, spacing: 3) {
                    Text(appState.text("Qibla Compass", "Kompas Kiblat", "朝向指南针"))
                        .font(.headline)
                        .fixedSize(horizontal: false, vertical: true)
                    Text(appState.text(
                        "Uses your heading and location to point toward Makkah.",
                        "Menggunakan arah dan lokasi anda untuk menunjukkan kiblat.",
                        "使用当前位置和手机朝向指向麦加。"
                    ))
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .layoutPriority(1)
            }

            ZStack {
                Circle()
                    .stroke(Color.wmMint, lineWidth: 14)
                Circle()
                    .fill(Color.wmPrimary.opacity(0.08))
                    .padding(22)

                compassNeedle
                    .rotationEffect(.degrees(locationService.qiblaOffsetDegrees ?? 0))

                VStack(spacing: 2) {
                    Text(appState.text("Qibla", "Kiblat", "朝向"))
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                    Text(degreeText(locationService.qiblaBearingDegrees))
                        .font(.title3.bold())
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 210)

            if let heading = locationService.currentHeadingDegrees {
                Text(appState.text("Current heading", "Arah semasa", "当前方向") + ": \(degreeText(heading))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            } else if let message = locationService.message {
                Text(message)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Button {
                locationService.startCompass()
            } label: {
                Label(appState.text("Start Compass", "Mula Kompas", "启动指南针"), systemImage: "location.north.line.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(.wmPrimary)
        }
        .wmCard()
    }

    private var compassNeedle: some View {
        VStack(spacing: 0) {
            Image(systemName: "arrowtriangle.up.fill")
                .font(.system(size: 44))
                .foregroundStyle(Color.wmPrimary)
            Rectangle()
                .fill(Color.wmPrimary.opacity(0.35))
                .frame(width: 5, height: 48)
        }
        .offset(y: -18)
    }

    private func degreeText(_ value: Double?) -> String {
        guard let value else {
            return "--"
        }

        return "\(Int(value.rounded())) deg"
    }
}

struct PracticeTimerView: View {
    @EnvironmentObject private var appState: AppStateViewModel
    @StateObject private var viewModel: PracticeTimerViewModel
    let profile: FaithProfile

    init(profile: FaithProfile) {
        self.profile = profile
        _viewModel = StateObject(wrappedValue: PracticeTimerViewModel(faith: profile.id))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                toolIcon("timer")
                VStack(alignment: .leading, spacing: 3) {
                    Text(appState.text("Practice Timer", "Pemasa Amalan", "练习定时"))
                        .font(.headline)
                        .fixedSize(horizontal: false, vertical: true)
                    Text(appState.text(
                        "A quiet timer for \(profile.localizedPracticeTitle(appState.language)).",
                        "Pemasa tenang untuk \(profile.localizedPracticeTitle(appState.language)).",
                        "适合\(profile.localizedPracticeTitle(appState.language))的安静定时器。"
                    ))
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .layoutPriority(1)
            }

            ViewThatFits(in: .horizontal) {
                HStack(alignment: .center, spacing: 18) {
                    timerDial
                    timerControls
                }

                VStack(spacing: 16) {
                    timerDial
                    timerControls
                }
            }
        }
        .wmCard()
    }

    private var timerDial: some View {
        ZStack {
            Circle()
                .stroke(Color.wmMint, lineWidth: 10)
            Circle()
                .trim(from: 0, to: viewModel.progress)
                .stroke(Color.wmPrimary, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                .rotationEffect(.degrees(-90))
            Text(viewModel.timeText)
                .font(.system(size: 30, weight: .bold, design: .monospaced))
                .minimumScaleFactor(0.78)
                .lineLimit(1)
        }
        .frame(width: 128, height: 128)
    }

    private var timerControls: some View {
        VStack(spacing: 12) {
            Picker("Timer length", selection: $viewModel.selectedMinutes) {
                ForEach(viewModel.minuteOptions, id: \.self) { minutes in
                    Text("\(minutes)m").tag(minutes)
                }
            }
            .pickerStyle(.menu)

            ViewThatFits(in: .horizontal) {
                HStack {
                    timerToggleButton
                    timerResetButton
                }

                VStack(spacing: 10) {
                    timerToggleButton
                    timerResetButton
                }
            }
        }
        .frame(maxWidth: .infinity)
    }

    private var timerToggleButton: some View {
        Button {
            viewModel.toggle()
        } label: {
            Label(
                viewModel.isRunning ? appState.text("Pause", "Jeda", "暂停") : appState.text("Start", "Mula", "开始"),
                systemImage: viewModel.isRunning ? "pause.fill" : "play.fill"
            )
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .tint(.wmPrimary)
    }

    private var timerResetButton: some View {
        Button {
            viewModel.reset()
        } label: {
            Label(appState.text("Reset", "Tetap Semula", "重置"), systemImage: "arrow.counterclockwise")
                .labelStyle(.iconOnly)
                .frame(width: 42)
        }
        .buttonStyle(.bordered)
        .tint(.wmPrimary)
    }
}

struct ReferenceLibraryView: View {
    @EnvironmentObject private var appState: AppStateViewModel
    let profile: FaithProfile
    @Environment(\.openURL) private var openURL

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 12) {
                toolIcon("books.vertical.fill")
                VStack(alignment: .leading, spacing: 3) {
                    Text(appState.text("Reference Library", "Perpustakaan Rujukan", "参考资料库"))
                        .font(.headline)
                        .fixedSize(horizontal: false, vertical: true)
                    Text(appState.text(
                        "Study links for the selected profile.",
                        "Pautan pembelajaran untuk profil pilihan.",
                        "根据当前版本显示参考链接。"
                    ))
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .layoutPriority(1)
            }

            ForEach(profile.references) { reference in
                Button {
                    openURL(reference.url)
                } label: {
                    HStack(spacing: 12) {
                        VStack(alignment: .leading, spacing: 3) {
                            Text(reference.title)
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(.primary)
                                .fixedSize(horizontal: false, vertical: true)
                            Text(reference.subtitle)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .layoutPriority(1)

                        Spacer()

                        Image(systemName: "arrow.up.right")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(Color.wmPrimary)
                    }
                    .padding(12)
                    .background(Color(.tertiarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
                .buttonStyle(.smoothPress)
            }
        }
        .wmCard()
    }
}

@ViewBuilder
private func toolIcon(_ systemName: String) -> some View {
    Image(systemName: systemName)
        .font(.system(size: 18, weight: .semibold))
        .foregroundStyle(Color.wmPrimary)
        .frame(width: 38, height: 38)
        .background(Color.wmMint, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
}
