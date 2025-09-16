import SwiftUI

struct HeaderCard: View {
    var body: some View {
        VStack(spacing: 6) {
            Text("CHOOSE YOUR FIRST HABITS")
                .font(.chicken(20, .regular))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)

            Text("Pick 3 daily habits or goals. Each one will become your very own chicken.")
                .font(.chicken(13, .regular))
                .foregroundColor(.white.opacity(0.95))
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 14)
        .background(
            BluredBackRounded(radius: 18)
            
            .allowsHitTesting(false)
            .overlay {
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color.white.opacity(0.10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(Color.white.opacity(0.95), lineWidth: 6)
                    )
            }
            .cornerRadius(18)
        )
        .padding(.horizontal, 18)
        .padding(.top, 16)
    }
}
