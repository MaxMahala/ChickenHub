import SwiftUI

struct ProgressBadge: View {
    let text: String
    var body: some View {
        Text(text)
            .font(.chicken(16, .regular))
            .foregroundColor(.white)
            .padding(.horizontal, 25)
            .padding(.vertical, 14)
            .background(
                BluredBackRounded(radius: 10)
            )
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.white, lineWidth: 6)
            }
            .cornerRadius(10)
    }
}
