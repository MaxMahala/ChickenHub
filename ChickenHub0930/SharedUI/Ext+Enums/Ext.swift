import SwiftUI

extension Text {
    func outlined(color: Color = .black, width: CGFloat = 1.2) -> some View {
        self.modifier(TextOutline(color: color, width: width))
    }
}

extension Color {
    init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double(rgb & 0xFF) / 255.0

        self.init(red: r, green: g, blue: b)
    }
}


extension FarmChicken {
    var saveModel: FarmChickenSave {
        .init(id: id,
              imageName: imageName,
              posX: pos.x.native, posY: pos.y.native,
              scale: scale.native)
    }
}

extension FarmChickenSave {
    var runtime: FarmChicken {
        .init(imageName: imageName,
              pos: CGPoint(x: posX.cg, y: posY.cg),
              scale: scale.cg)
    }
}

extension CGFloat {
    var native: Double { Double(self) }
}

extension Double {
    var cg: CGFloat { CGFloat(self) }
}

extension ItemKind {
    var asset: ImageResource {
        switch self {
        case .seed: return .seed
        case .bush: return .bush
        }
    }
    var size: CGFloat {
        switch self {
        case .seed: 34
        case .bush: 72
        }
    }
}

extension Bool {
    static func random(probability p: Double) -> Bool {
        Double.random(in: 0...1) < p
    }
}
