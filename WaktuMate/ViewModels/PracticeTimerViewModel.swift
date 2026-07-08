import Foundation

@MainActor
final class PracticeTimerViewModel: ObservableObject {
    @Published var selectedMinutes = 5 {
        didSet {
            if !isRunning {
                remainingSeconds = selectedMinutes * 60
            }
        }
    }
    @Published var remainingSeconds = 5 * 60
    @Published var isRunning = false

    let minuteOptions = [1, 5, 10, 15, 30]

    private var timer: Timer?
    private let faith: FaithTradition
    private let storage: StorageService

    init(faith: FaithTradition, storage: StorageService = .shared) {
        self.faith = faith
        self.storage = storage
    }

    deinit {
        timer?.invalidate()
    }
    var timeText: String {
        let minutes = remainingSeconds / 60
        let seconds = remainingSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    var progress: Double {
        let total = max(1, selectedMinutes * 60)
        return 1 - (Double(remainingSeconds) / Double(total))
    }

    func toggle() {
        isRunning ? pause() : start()
    }

    func start() {
        guard remainingSeconds > 0 else {
            reset()
            return
        }

        isRunning = true
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.tick()
            }
        }
    }

    func pause() {
        isRunning = false
        timer?.invalidate()
    }

    func reset() {
        pause()
        remainingSeconds = selectedMinutes * 60
    }

    private func tick() {
        guard remainingSeconds > 0 else {
            reset()
            return
        }

        remainingSeconds -= 1

        if remainingSeconds == 0 {
            storage.addPracticeTimerMinutes(selectedMinutes, for: faith)
            pause()
        }
    }
}
