import SwiftUI

struct GrowingBubble: View {
    let text: String
    var body: some View {
        VStack(spacing: 4) {
            Text("GROWING UP")
                .font(.chicken(13, .regular))
                .foregroundColor(.white)
            HStack(spacing: 6) {
                Image(systemName: "circle.fill")
                    .font(.system(size: 6, weight: .bold))
                    .foregroundColor(.white.opacity(0.9))
                Text(text)
                    .font(.chicken(12, .regular))
                    .foregroundColor(.white)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(
            Capsule()
                .fill(LinearGradient(colors: [Color.blue.opacity(0.85), Color.blue.opacity(0.65)],
                                     startPoint: .top, endPoint: .bottom))
                .overlay(Capsule().stroke(.white.opacity(0.95), lineWidth: 2))
                .shadow(color: .black.opacity(0.2), radius: 8, y: 4)
        )
    }
}
