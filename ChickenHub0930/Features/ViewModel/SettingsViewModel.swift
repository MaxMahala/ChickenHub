import Foundation
import Combine
import StoreKit

final class SettingsViewModel: ObservableObject {
    @Published var soundOn: Bool { didSet { save() } }
    @Published var hapticsOn: Bool { didSet { save() } }
    
    let privacyURL = URL(string: Constants.privacy)!
    
    init() {
        let ud = UserDefaults.standard
        soundOn   = ud.object(forKey: "set.sound")   as? Bool ?? true
        hapticsOn = ud.object(forKey: "set.haptics") as? Bool ?? true
    }
    
    private func save() {
        let ud = UserDefaults.standard
        ud.set(soundOn,   forKey: "set.sound")
        ud.set(hapticsOn, forKey: "set.haptics")
        Haptics.shared.success()
    }
    
    func rateApp() {
        guard let scene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene else { return }
        SKStoreReviewController.requestReview(in: scene)
    }
}
