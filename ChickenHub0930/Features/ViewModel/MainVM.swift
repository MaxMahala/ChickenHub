import SwiftUI

final class MainVM: ObservableObject {
    @Published var progress: Int = 0
    @Published var store = HabitStore.shared

    let dailyGoal: Int = 10

    var allProgressText: String {
        "\(store.completedAll())/10"
    }
    
    func tapped(_ kind: RewardKind) {
        print("Open \(kind)")
    }

    func addProgress(_ delta: Int = 1) {
        progress = min(progress + delta, dailyGoal)
    }
    
    func isShortDevice() -> Bool {
        UIScreen.main.bounds.height < 700
    }
}
