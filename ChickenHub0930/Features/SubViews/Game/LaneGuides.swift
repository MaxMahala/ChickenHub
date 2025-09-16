import SwiftUI

struct LaneGuides: View {
    var body: some View {
        GeometryReader { geo in
            let left = geo.size.width * 0.21
            let right = geo.size.width * 0.79
            let mid = (left + right) / 2
            Path { p in
                [left, mid, right].forEach { x in
                    p.move(to: CGPoint(x: x, y: 0))
                    p.addLine(to: CGPoint(x: x, y: geo.size.height))
                }
            }
            .stroke(style: StrokeStyle(lineWidth: 1, dash: [6, 6]))
            .foregroundStyle(.white)
            .ignoresSafeArea()
        }
    }
}
