import SwiftUI

struct TextOutline: ViewModifier {
    var color: Color = .black
    var width: CGFloat = 1.2
    func body(content: Content) -> some View {
        content
            .shadow(color: color, radius: 0, x:  width, y:  width)
            .shadow(color: color, radius: 0, x: -width, y:  width)
            .shadow(color: color, radius: 0, x:  width, y: -width)
            .shadow(color: color, radius: 0, x: -width, y: -width)
    }
}
