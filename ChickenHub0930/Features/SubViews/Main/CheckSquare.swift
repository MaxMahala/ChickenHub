import SwiftUI

struct CheckSquare: View {
   let isOn: Bool

   var body: some View {
       ZStack {
           RoundedRectangle(cornerRadius: 4, style: .continuous)
               .fill(isOn ? Color.green.opacity(0.9) : Color.white.opacity(0.18))

           if isOn {
               Image(systemName: "checkmark")
                   .font(.system(size: 12, weight: .bold))
                   .foregroundColor(.white)
           }
       }
       .frame(width: 50, height: 20)
       .overlay(
           RoundedRectangle(cornerRadius: 3)
               .stroke(Color.white.opacity(0.85), lineWidth: 1.5)
       )
       .animation(.easeInOut(duration: 0.15), value: isOn)
   }
}
