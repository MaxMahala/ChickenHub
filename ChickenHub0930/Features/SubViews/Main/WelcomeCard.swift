import SwiftUI

struct WelcomeCard: View {
   var body: some View {
       VStack(alignment: .leading, spacing: 6) {
           Text("WELCOME")
               .font(.chicken(24, .regular))
               .foregroundColor(.white)
           Text("Complete daily habits to\ncollect eggs and grow your farm.")
               .font(.chicken(16, .regular))
               .foregroundColor(.white.opacity(0.95))
       }
       .padding(12)
       .frame(maxWidth: .infinity)
       .background(BluredBackRounded(radius: 25))
       .overlay {
           RoundedRectangle(cornerRadius: 10)
               .stroke(.white, lineWidth: 6)
       }
       .cornerRadius(10)
   }
}
