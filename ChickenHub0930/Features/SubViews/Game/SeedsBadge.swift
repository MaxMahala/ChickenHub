import SwiftUI

struct SeedsBadge: View {
    let seeds: Int
    var body: some View {
        HStack(spacing: 8) {
            Image(.seed).resizable()
                .scaledToFit()
                .frame(width: 18, height: 18)
            Text("\(seeds)")
                .font(.chicken(16, .regular))
                .foregroundColor(.white)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .frame(width: 100, height: 50)
        .background {
            BluredBackRounded(radius: 14)
                .blur(radius: 1)
        }
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(.white, lineWidth: 4))
        .cornerRadius(10)
    }
}
