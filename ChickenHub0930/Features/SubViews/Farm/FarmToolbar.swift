import SwiftUI

struct FarmToolbar: View {
    var left: () -> Void
    var game: () -> Void
    var water: () -> Void
    var grain: () -> Void
    var shop: () -> Void
    var waterSelected: Bool = false
    var grainSelected: Bool = false
    
    var body: some View {
        HStack {
            Button { left() } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 22, weight: .black))
                    .foregroundColor(.white)
                    .frame(width: 62, height: 62)
                    .background(
                        Image(.circleBack).resizable().scaledToFit().frame(width: 68, height: 68)
                    )
                    .shadow(color: AppTheme.whiteShadow, radius: 10, y: 6)
            }
            .buttonStyle(.plain)

            Spacer(minLength: 8)
            
            ToolbarIcon(image: .game, action: game)
            ToolbarIcon(image: .waterDroplet, isSelected: waterSelected, action: water)
            ToolbarIcon(image: .threeWheatGrains, isSelected: grainSelected, action: grain)
            ToolbarIcon(image: .market, action: shop)
            Spacer(minLength: 8)
        }
        .padding(.horizontal, 18)
    }
}
