import SwiftUI

struct GameOverOverlay: View {
    let win: Bool
    let eggs: Int
    var again: () -> Void
    var home: () -> Void

    var body: some View {
        VStack(spacing: 18) {
            Spacer()
            
            Text(win ? "WIN" : "GAME OVER")
                .font(.chicken(40, .regular))
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.35), radius: 10, y: 6)

            Text("\(eggs)")
                .font(.chicken(64, .regular))
                .foregroundColor(AppTheme.carrot)

            Spacer()
            
            Button {
                again()
            } label: {
                Text("Again")
                    .font(.chicken(20, .regular))
                    .foregroundColor(.white)
            }
            .padding(.vertical, 12)
            .frame(maxWidth: 220)
            .background {
                Image(.bgButton)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 56)
            }

            Button(action: home) {
                Text("Home")
                    .font(.chicken(20, .regular))
                    .foregroundColor(.white)
            }
            .padding(.vertical, 12)
            .frame(maxWidth: 220)
            .background {
                Image(.bgButton)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 56)
            }
            
            Spacer()
        }
        .padding(.bottom, 30)
    }
}
