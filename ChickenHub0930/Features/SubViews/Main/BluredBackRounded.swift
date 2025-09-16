import SwiftUI

struct BluredBackRounded: View {
    let radius: CGFloat
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: radius)
                .fill(.ultraThinMaterial)
                .opacity(0.4)
            
            Color.black.opacity(0.5)
        }
    }
}
