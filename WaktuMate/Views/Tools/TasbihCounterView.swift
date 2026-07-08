import SwiftUI

struct TasbihCounterView: View {
    @EnvironmentObject private var appState: AppStateViewModel
    @StateObject private var viewModel = TasbihViewModel()

    var body: some View {
        VStack(spacing: 22) {
            VStack(spacing: 4) {
                Text(appState.text("Tasbih Counter", "Kaunter Tasbih", "念珠计数"))
                    .font(.title2.bold())
                Text(appState.text("Today's total", "Jumlah hari ini", "今日总数") + ": \(viewModel.todayTotal)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.wmMint, Color.wmPrimary.opacity(0.32)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 210, height: 210)

                VStack(spacing: 8) {
                    Text("\(viewModel.count)")
                        .font(.system(size: 64, weight: .bold, design: .rounded))
                        .monospacedDigit()
                    Text("/ \(viewModel.target)")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                }
            }

            Button {
                viewModel.increment()
            } label: {
                Text(appState.text("Tap to Count", "Tekan untuk Kira", "点击计数"))
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.wmPrimary, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .foregroundStyle(.white)
            }
            .buttonStyle(.smoothPress)
            .sensoryFeedback(.success, trigger: viewModel.hapticTrigger)

            Picker("Target", selection: Binding(
                get: { viewModel.target },
                set: { viewModel.setTarget($0) }
            )) {
                ForEach(viewModel.targets, id: \.self) { target in
                    Text("\(target)").tag(target)
                }
            }
            .pickerStyle(.segmented)

            Button(role: .destructive) {
                viewModel.reset()
            } label: {
                Label(appState.text("Reset Count", "Tetapkan Semula", "重置计数"), systemImage: "arrow.counterclockwise")
                    .font(.subheadline.weight(.semibold))
            }
            .buttonStyle(.smoothPress)
        }
        .wmCard()
    }
}

#Preview {
    TasbihCounterView()
        .padding()
}
