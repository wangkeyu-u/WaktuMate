import Foundation

@MainActor
final class TasbihViewModel: ObservableObject {
    @Published var count: Int
    @Published var target: Int
    @Published var todayTotal: Int
    @Published var hapticTrigger = 0

    let targets = [33, 99, 100]

    private let storage: StorageService
    private let todayKey = AppDateFormatting.dateKey()

    init(storage: StorageService = .shared) {
        self.storage = storage
        self.count = storage.loadTasbihCount()
        self.target = storage.loadTasbihTarget()
        self.todayTotal = storage.loadTasbihDailyTotals()[todayKey] ?? 0
    }

    func increment() {
        count += 1
        todayTotal += 1
        persist()

        if count > 0, count % target == 0 {
            hapticTrigger += 1
        }
    }

    func reset() {
        count = 0
        storage.saveTasbihCount(count)
    }

    func setTarget(_ target: Int) {
        self.target = target
        storage.saveTasbihTarget(target)
    }

    private func persist() {
        storage.saveTasbihCount(count)

        var totals = storage.loadTasbihDailyTotals()
        totals[todayKey] = todayTotal
        storage.saveTasbihDailyTotals(totals)
    }
}
