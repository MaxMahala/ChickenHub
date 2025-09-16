import Foundation

struct HabitItem: Identifiable, Hashable {
    let id: String
    let title: String
    let subtitle: String
    let imageName: String
    var isSelected: Bool = false
}
