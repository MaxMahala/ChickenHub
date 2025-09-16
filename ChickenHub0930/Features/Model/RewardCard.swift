import Foundation

struct RewardCard: Identifiable {
    let id = UUID()
    let kind: RewardKind
    var canClaim: Bool
    var streak: Int
    var todayAmount: Int
}
