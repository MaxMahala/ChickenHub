import SwiftUI

struct SwitchingBackground: View {
    let images: [String]
    @Binding var index: Int

    private func isShortDevice() -> Bool {
        UIScreen.main.bounds.height < 700
    }
    
    var body: some View {
        Image(images[index])
            .resizable()
            .scaledToFill()
            .frame(maxHeight: isShortDevice() ? 670 : .infinity)
            .id(index)
            .transition(.opacity)
            .animation(.easeInOut(duration: 0.35), value: index)
            .ignoresSafeArea()
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 24)
                    .onEnded { value in
                        if value.translation.width < -60, index < images.count - 1 { index += 1 }
                        if value.translation.width >  60, index > 0                   { index -= 1 }
                    }
            )
    }
}
