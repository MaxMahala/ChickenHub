import Foundation

struct HabitTask: Identifiable, Codable, Equatable {
    var id = UUID()
    var title: String
    var done: Bool = false
}
