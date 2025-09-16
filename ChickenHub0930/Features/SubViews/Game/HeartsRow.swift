import SwiftUI

struct HeartsRow: View {
    let hearts: Int
    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<3, id: \.self) { i in
                Image(systemName: (i < hearts) ? "heart.fill" : "heart")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.red.opacity(i < hearts ? 0.95 : 0.55))
                    .shadow(color: .black.opacity(0.25), radius: 2, y: 1)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .cornerRadius(10)
        .shadow(color: Color.white, radius: 30)
        .padding(.top)
        .zIndex(1)
    }
}

