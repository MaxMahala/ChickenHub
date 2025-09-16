import SwiftUI

final class DailyRewardViewModel: ObservableObject {
    @Published var cards: [RewardCard] = []
    @Published var showSheet: Bool = false
    @Published var progress: Int = 0
    @Published var store = HabitStore.shared
    @Published var showReward = false

    var awardEggs: ((Int, RewardKind) -> Void)?

    var allClaimed: Bool { mgr.allClaimedToday() }
    
    let dailyGoal: Int = 10

    var openDumbbell: (() -> Void)?
    var openBook: (() -> Void)?
    var openWater: (() -> Void)?

    var allProgressText: String {
        "\(store.completedAll())/10"
    }
    
    var progressText: String { "\(progress)/\(dailyGoal)" }

    private let mgr = DailyRewardManager()
    
    init(awardEggs: ((Int, RewardKind) -> Void)? = nil) {
        self.awardEggs = awardEggs
        refresh()
    }

    func tapped(_ kind: RewardKind) {
        switch kind {
        case .dumbbell: openDumbbell?()
        case .book:     openBook?()
        case .water:    openWater?()
        }
    }

    func addProgress(_ delta: Int = 1) {
        progress = min(progress + delta, dailyGoal)
    }
    
    func refresh() {
        cards = RewardKind.allCases.map { k in
            let can = mgr.canClaim(k)
            let streak = mgr.currentStreak(k)
            let previewAmount = k.baseAmount + min(max(streak, 1) - 1, 4)
            return RewardCard(kind: k, canClaim: can, streak: max(streak, 0), todayAmount: previewAmount)
        }
        showSheet = !mgr.allClaimedToday() && mgr.shouldPresentToday()
        if showSheet { mgr.markPresentedToday() }
    }

    func claim(_ kind: RewardKind) {
        guard mgr.canClaim(kind) else { return }
        let result = mgr.claim(kind)
        awardEggs?(result.amount, kind)
        refresh()
    }
    
    func isShortDevice() -> Bool {
        UIScreen.main.bounds.height < 700
    }
}
