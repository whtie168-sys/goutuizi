import Foundation

/// 跑腿任务存储，基于 UserDefaults + JSON
final class ErrandStore {
    static let shared = ErrandStore()
    private let key = "goutuizi.errands"
    private(set) var errands: [Errand] = []

    private init() {
        if let data = UserDefaults.standard.data(forKey: key),
           let list = try? JSONDecoder().decode([Errand].self, from: data) {
            errands = list
        }
    }

    var pending: [Errand] { errands.filter { !$0.isDone } }
    var finished: [Errand] { errands.filter { $0.isDone } }
    var totalIncome: Double { finished.reduce(0) { $0 + $1.fee } }

    func upsert(_ errand: Errand) {
        if let i = errands.firstIndex(where: { $0.id == errand.id }) {
            errands[i] = errand
        } else {
            errands.insert(errand, at: 0)
        }
        save()
    }

    func toggle(_ id: UUID) {
        guard let i = errands.firstIndex(where: { $0.id == id }) else { return }
        errands[i].isDone.toggle()
        save()
    }

    func delete(_ id: UUID) {
        errands.removeAll { $0.id == id }
        save()
    }

    private func save() {
        if let data = try? JSONEncoder().encode(errands) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}
