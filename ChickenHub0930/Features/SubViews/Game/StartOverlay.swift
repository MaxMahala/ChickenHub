import SwiftUI

struct StartOverlay: View {
    var start: () -> Void
    var body: some View {
        VStack(spacing: 14) {
            Spacer()
            
            GlassRule("Run forward, collecting seeds along the way.")
            GlassRule("Collect seeds and beware of obstacles.")
            GlassRule("For every 10 grains collected, you receive 1 point.")
            GlassRule("If the fox catches you, the game is over!")
            
            Spacer()
            
            Button {
                start()
            } label: {
                Text("Start")
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
        .padding(.horizontal, 22)
        .padding(.vertical, 18)
    }
}
