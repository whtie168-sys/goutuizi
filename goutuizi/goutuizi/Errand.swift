import Foundation

/// 一条跑腿任务
struct Errand: Codable, Equatable {
    var id = UUID()
    var title: String
    var address: String
    var fee: Double
    var isDone = false
    var createdAt = Date()
}
