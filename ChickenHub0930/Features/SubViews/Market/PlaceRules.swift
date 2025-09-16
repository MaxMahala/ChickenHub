import Foundation

struct PlaceRules {
    static let coopX: ClosedRange<CGFloat> = 0.10...0.90
    static let coopY: ClosedRange<CGFloat> = 0.68...0.86
    static let decX : ClosedRange<CGFloat> = 0.06...0.94
    static let decY : ClosedRange<CGFloat> = 0.84...0.96

    static let coopMinDist: CGFloat = 0.16
    static let decMinDist : CGFloat = 0.12

    static let coopScale: ClosedRange<CGFloat> = 1.08...1.28
    static let decScale : ClosedRange<CGFloat> = 0.90...1.10
}
