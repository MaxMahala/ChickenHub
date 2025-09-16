import SwiftUI

struct GearButton: View {
   var action: () -> Void
   var body: some View {
       Button(action: action) {
           Image(systemName: "gearshape.fill")
               .foregroundColor(.white)
               .font(.system(size: 22, weight: .bold))
               .frame(width: 62, height: 62)
               .background(
                   Image(.circleBack)
                       .resizable()
                       .scaledToFit()
                       .frame(width: 68, height: 68)
               )
               .shadow(color: AppTheme.whiteShadow, radius: 10, y: 6)
       }
   }
}
