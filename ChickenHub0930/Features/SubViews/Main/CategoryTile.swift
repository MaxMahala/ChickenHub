import SwiftUI

struct CategoryTile: View {
    @State private var isActive = false
    let title: String
    let image: ImageResource
    let color: Color
    var action: () -> Void

    var body: some View {
        Button {
            isActive.toggle()
            action()
            Haptics.shared.success()
        } label: {
            VStack(spacing: 8) {
                Image(image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 56)
                Text(title)
                    .font(.chicken(12, .regular))
                    .foregroundColor(color)
                    .padding(.vertical, 6)
                    .frame(maxWidth: .infinity)
            }
            .padding(10)
            .frame(maxWidth: .infinity)
            .frame(height: 132)
            .background(.white)
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(color, lineWidth: isActive ? 7 : 4)
            }
            .cornerRadius(10)
            .shadow(color: AppTheme.whiteShadow, radius: 10, y: 6)
        }
        .buttonStyle(.plain)
    }
}
