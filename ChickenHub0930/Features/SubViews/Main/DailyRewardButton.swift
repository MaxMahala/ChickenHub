import SwiftUI

struct DailyRewardButton: View {
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Text("DAILY REWARD")
                .font(.chicken(16, .regular))
                .foregroundColor(.white)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
        }
        .background {
            Image(.bgButton)
                .resizable()
                .scaledToFit()
                .frame(height: 54)
        }
        .shadow(color: AppTheme.whiteShadow, radius: 12, y: 8)
    }
}
