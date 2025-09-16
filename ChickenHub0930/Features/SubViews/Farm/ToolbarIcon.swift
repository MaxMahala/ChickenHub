import SwiftUI

struct ToolbarIcon: View {
    let image: ImageResource
    var isSelected: Bool = false
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Image(.bgGreenButton)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 62, height: 62)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? Color.white.opacity(0.95) : .clear, lineWidth: 2)
                    )
                Image(image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 34)
            }
        }
        .buttonStyle(.plain)
    }
}
