import SwiftUI

struct WaterHint: View {
    var size: CGFloat = 44
    @State private var pulse = false
    var body: some View {
        Image(.waterDroplet)
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
            .shadow(color: .black.opacity(0.25), radius: 6, y: 3)
            .scaleEffect(pulse ? 1.08 : 0.92)
            .onAppear {
                withAnimation(.easeInOut(duration: 0.7).repeatForever(autoreverses: true)) {
                    pulse = true
                }
            }
    }
}
