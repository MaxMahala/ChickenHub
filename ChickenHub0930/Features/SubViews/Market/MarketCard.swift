import SwiftUI

struct MarketCard: View {
    let item: MarketItem
    let eggs: Double
    var onBuy: () -> Void

    private var canAfford: Bool { eggs >= Double(item.price) }
    private var owned: Int { min(Int(eggs), item.price) }
    private var progress: CGFloat {
        guard item.price > 0 else { return 1 }
        return CGFloat(min(eggs / Double(item.price), 1.0))
    }

    var body: some View {
        Button {
            onBuy()
        } label: {
            VStack(spacing: 8) {
                Image(item.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 125, height: 115)
                
                Text(item.title)
                    .font(.chicken(12, .regular))
                    .foregroundColor(.white)
                
                if let subtitle = item.subtitle {
                    Text(subtitle)
                        .frame(width: 125)
                        .font(.chicken(8, .regular))
                        .foregroundColor(.white.opacity(0.95))
                        .multilineTextAlignment(.center)
                        .frame(height: 28)
                        .padding(.horizontal, 6)
                } else {
                    Spacer(minLength: 0).frame(height: 28)
                }
                
                PriceChip(current: owned, total: item.price, fill: progress, canAfford: canAfford)
            }
            .padding(10)
        }
    }
}
