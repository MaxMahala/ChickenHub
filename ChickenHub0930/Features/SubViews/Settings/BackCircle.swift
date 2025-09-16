import SwiftUI

struct BackCircle: View {
    var action: () -> Void
    var body: some View {
        Button(action: action) {
            Image(systemName: "chevron.left")
                .font(.system(size: 20, weight: .black))
                .foregroundColor(.white)
                .frame(width: 44, height: 44)
                .background(
                    Image(.circleBack)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 68, height: 68)
                )
                .shadow(color: AppTheme.whiteShadow, radius: 8, y: 5)
        }
        .buttonStyle(.plain)
    }
}
