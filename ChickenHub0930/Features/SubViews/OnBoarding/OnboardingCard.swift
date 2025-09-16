import SwiftUI

struct OnboardingCard: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack(spacing: 14) {
            Text(title.uppercased())
                .font(.chicken(20, .regular))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .lineSpacing(3)

            Text(subtitle)
                .font(.chicken(14, .regular))
                .foregroundColor(.white.opacity(0.95))
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 18)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(AppTheme.carrot.opacity(0.96))
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(Color.white.opacity(0.85), lineWidth: 2)
                )
                .shadow(color: AppTheme.whiteShadow, radius: 16, y: 10)
        )
    }
}
