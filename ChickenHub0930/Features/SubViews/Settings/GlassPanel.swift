import SwiftUI

struct GlassPanel<Content: View>: View {
   var cornerRadius: CGFloat = 18
   @ViewBuilder var content: Content
   var body: some View {
       content
           .background(
               RoundedRectangle(cornerRadius: cornerRadius)
                   .fill(Color.black.opacity(0.4))
                   .blur(radius: 25)
                   .overlay(
                       RoundedRectangle(cornerRadius: cornerRadius)
                           .stroke(Color.white.opacity(0.95), lineWidth: 2)
                   )
           )
   }
}
