import SwiftUI

struct BottomBlurShade: View {
   var height: CGFloat = 120

   var body: some View {
       ZStack {
           Rectangle().fill(.ultraThinMaterial).opacity(0.4)
           LinearGradient(
               colors: [Color.black.opacity(0.65), Color.black.opacity(0.30), .clear],
               startPoint: .bottom, endPoint: .top
           )
       }
       .frame(height: height)
       .ignoresSafeArea(edges: .bottom)
   }
}
