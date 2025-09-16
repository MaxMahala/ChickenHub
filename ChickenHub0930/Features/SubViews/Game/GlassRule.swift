import SwiftUI

struct GlassRule: View {
    let text: String
    init(_ text: String) { self.text = text }
    var body: some View {
        Text(text)
            .font(.chicken(14, .regular))
            .foregroundColor(.white)
            .padding(.vertical, 10)
            .padding(.horizontal, 12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 60)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(.ultraThinMaterial)
                    .blur(radius: 5)
                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(.white.opacity(0.95), lineWidth: 2))
            )
            .padding(.horizontal)
    }
}
