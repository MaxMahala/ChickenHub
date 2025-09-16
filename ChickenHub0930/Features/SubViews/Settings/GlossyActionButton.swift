import SwiftUI

struct GlossyActionButton: View {
    let title: String
    var action: () -> Void
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.chicken(22, .regular))
                .foregroundColor(.white)
                .padding(.vertical, 14)
                .frame(maxWidth: 260)
        }
        .background {
            Image(.bgButton)
                .resizable()
                .scaledToFit()
                .frame(height: 56)
        }
        .shadow(color: AppTheme.whiteShadow, radius: 12, y: 8)
    }
}
