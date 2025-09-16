import SwiftUI

struct TaskCard: View {
   let title: String
   let tasks: [String]
   var body: some View {
       VStack(alignment: .leading, spacing: 12) {
           Text(title).font(.chicken(24, .regular)).foregroundColor(.black)
               .frame(maxWidth: .infinity, alignment: .center)

           Divider().overlay(AppTheme.carrot)

           ForEach(tasks, id: \.self) { t in
               HStack {
                   Text("•  \(t)").font(.chicken(16, .regular)).foregroundColor(.black)
                   Spacer()
                   RoundedRectangle(cornerRadius: 3).fill(Color.gray.opacity(0.35)).frame(width: 52, height: 16)
               }
               .padding(.vertical, 4)
               Divider().opacity(0.25)
           }

           HStack {
               Image(systemName: "trash").font(.system(size: 22, weight: .bold)).foregroundColor(.indigo)
               Spacer()
               Image(systemName: "plus").font(.system(size: 26, weight: .bold)).foregroundColor(.indigo)
           }
           .padding(.top, 8)
       }
       .padding(16)
       .background(
           RoundedRectangle(cornerRadius: 22)
               .fill(Color.white)
               .overlay(RoundedRectangle(cornerRadius: 22).stroke(AppTheme.carrot, lineWidth: 3))
               .shadow(color: .black.opacity(0.15), radius: 12, y: 8)
       )
       .padding(.horizontal, 22)
   }
}
