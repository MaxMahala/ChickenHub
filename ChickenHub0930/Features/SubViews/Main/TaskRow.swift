import SwiftUI

struct TaskRow: View {
    @State var isSelected: Bool = false
    let title: String
    let done: Bool
    let toggle: () -> Void
    let action: () -> Void

    var body: some View {
        Button {
            isSelected.toggle()
            action()
        } label: {
            HStack {
                Text("•  \(title)")
                    .font(.chicken(16, .regular))
                    .foregroundColor(.black)
                Spacer()
                Button(action: toggle) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(done ? Color.green : Color.gray.opacity(0.35))
                        if done {
                            Image(systemName: "checkmark")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                    .frame(width: 52, height: 18)
                }
                .buttonStyle(.plain)
            }
            .padding(.vertical, 5)
            .background(isSelected ? AppTheme.carrot : Color.clear)
            .padding(.vertical, 4)
        }
    }
}
