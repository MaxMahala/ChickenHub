import SwiftUI

struct TopBar: View {
    let title: String
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 22, weight: .black))
                    .foregroundColor(.white)
                    .frame(width: 62, height: 62)
                    .background(
                        Image(.circleBack)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 68, height: 68)
                    )
                    .shadow(color: AppTheme.whiteShadow, radius: 10, y: 6)
            }
            .buttonStyle(.plain)

            Spacer()
            ProgressBadge(text: "0/10")
            Spacer()
            GearButton { }
        }
        .padding(.horizontal, 18)
    }
}
