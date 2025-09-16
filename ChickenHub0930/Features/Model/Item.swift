import Foundation

struct Item: Identifiable {
    let id = UUID()
    let kind: ItemKind
    let lane: Int
    var y: CGFloat
}
