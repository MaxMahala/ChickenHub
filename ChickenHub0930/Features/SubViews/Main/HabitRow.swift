import SwiftUI

struct HabitRow: View {
    let item: HabitItem
    var onToggle: () -> Void

    var body: some View {
        Button(action: onToggle) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.title)
                        .font(.chicken(18, .regular))
                        .foregroundColor(.white)

                    Text(item.subtitle)
                        .font(.chicken(12, .regular))
                        .foregroundColor(.white.opacity(0.9))
                    
                    CheckSquare(isOn: item.isSelected)
                        .padding(.top, 20)
                }

                Spacer(minLength: 10)

                Image(item.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 70, height: 70)
                    .padding(.trailing, 8)
            }
            .padding(12)
            .background(
                BluredBackRounded(radius: 8)
                .allowsHitTesting(false)
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.white.opacity(0.10))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.white.opacity(0.95), lineWidth: 3)
                        )
                }
                .cornerRadius(8)
            )
        }
        .buttonStyle(.plain)
    }
}
