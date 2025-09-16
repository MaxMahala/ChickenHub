import SwiftUI

enum ChickenWeight { case regular }

extension Font {
    static func chicken(_ size: CGFloat, _ weight: ChickenWeight = .regular) -> Font {
        let name: String = {
            switch weight {
            case .regular: return "PermanentMarker-Regular"
            }
        }()
        return .custom(name, size: size)
    }
}
