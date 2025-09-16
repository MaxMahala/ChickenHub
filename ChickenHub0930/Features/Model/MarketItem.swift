import SwiftUI

struct MarketItem: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let image: String
    let price: Int
    let placeable: PlaceKind?
    let subtitle: String?
}
