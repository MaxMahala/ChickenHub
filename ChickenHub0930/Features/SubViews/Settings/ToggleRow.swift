import SwiftUI

struct ToggleRow: View {
    let title: String
    @Binding var isOn: Bool
    var body: some View {
        VStack(spacing: 6) {
            Text(title.uppercased())
                .font(.chicken(20, .regular))
                .foregroundColor(.white)
            Toggle("", isOn: $isOn)
                .toggleStyle(CheckToggleStyle())
        }
    }
}
