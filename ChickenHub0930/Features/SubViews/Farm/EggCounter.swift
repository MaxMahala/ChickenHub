import SwiftUI

struct EggCounter: View {
    let eggs: Int
    @State private var bump = false
    
    var body: some View {
        Text("\(max(eggs, 0))")
            .font(.chicken(18, .regular))
            .foregroundColor(.white)
            .padding(12)
            .frame(width: 128, height: 72)
            .background(BluredBackRounded(radius: 25))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.white, lineWidth: 6)
            )
            .cornerRadius(10)
            .scaleEffect(bump ? 1.06 : 1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.65), value: bump)
            .onChange(of: eggs) { _, _ in
                bump.toggle()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.22) { bump.toggle() }
            }
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("Eggs")
            .accessibilityValue("\(max(eggs, 0))")
    }
}
