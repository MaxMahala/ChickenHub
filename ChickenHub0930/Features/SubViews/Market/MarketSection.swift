import SwiftUI

struct MarketSection: View {
    let title: String
    let items: [MarketItem]
    let eggs: Double
    var onBuy: (MarketItem) -> Void

    let cols = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.chicken(24, .regular))
                .foregroundColor(.white)
            
            LazyVGrid(columns: cols, spacing: 12) {
                ForEach(items) { item in
                    MarketCard(item: item, eggs: eggs) {
                        Haptics.shared.success()
                        onBuy(item)
                    }
                }
            }
        }
    }
}
