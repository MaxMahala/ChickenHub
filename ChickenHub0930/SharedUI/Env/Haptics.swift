import SwiftUI

final class Haptics {
    static let shared = Haptics()

    private let ud = UserDefaults.standard
    private let key = "set.haptics"

    private init() {
        if ud.object(forKey: key) == nil { ud.set(true, forKey: key) }
    }

    var isEnabled: Bool { ud.bool(forKey: key) }
    func setEnabled(_ on: Bool) { ud.set(on, forKey: key) }

    func selection() {
        guard isEnabled else { return }
        let g = UISelectionFeedbackGenerator()
        g.prepare(); g.selectionChanged()
    }

    func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .light) {
        guard isEnabled else { return }
        let g = UIImpactFeedbackGenerator(style: style)
        g.prepare(); g.impactOccurred()
    }

    func success() {
        guard isEnabled else { return }
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }

    func warning() {
        guard isEnabled else { return }
        UINotificationFeedbackGenerator().notificationOccurred(.warning)
    }

    func error() {
        guard isEnabled else { return }
        UINotificationFeedbackGenerator().notificationOccurred(.error)
    }
}
