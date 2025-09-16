import SwiftUI

struct FarmChicken: Identifiable {
    let id = UUID()
    let imageName: String
    var pos: CGPoint
    var scale: CGFloat = 1.0
}
