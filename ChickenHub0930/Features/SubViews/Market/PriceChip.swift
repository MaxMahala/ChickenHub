import SwiftUI

struct PriceChip: View {
    let current: Int
    let total: Int
    let fill: CGFloat
    let canAfford: Bool
    
    var body: some View {
        ZStack {
            Text("\(current)/\(total)")
                .font(.chicken(12, .regular))
                .foregroundColor(.white)
                .padding(.horizontal, 8)
        }
        .frame(width: 100, height: 24)
        .background {
            Image(.bgButton)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 24)
                .opacity(canAfford ? 1.0 : 0.4)
                .disabled(!canAfford)
        }
    }
}
