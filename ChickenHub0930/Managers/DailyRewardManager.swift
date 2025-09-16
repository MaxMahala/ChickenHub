import Foundation

final class DailyRewardManager {
    static let shared = DailyRewardManager()
    private let ud = UserDefaults.standard
    private let cal = Calendar.current

    private func todayKey(_ date: Date = Date()) -> Int {
        let y = cal.component(.year, from: date)
        let d = cal.ordinality(of: .day, in: .year, for: date) ?? 0
        return y*1000 + d
    }

    private func lastClaimKey(_ kind: RewardKind) -> String { "dr.\(kind.rawValue).last" }
    private func streakKey(_ kind: RewardKind)    -> String { "dr.\(kind.rawValue).streak" }
    private var lastPresentedKey: String          { "dr.lastPresented" }

    func shouldPresentToday() -> Bool {
        let t = todayKey()
        return ud.integer(forKey: lastPresentedKey) != t
    }
    func markPresentedToday() {
        ud.set(todayKey(), forKey: lastPresentedKey)
    }

    func canClaim(_ kind: RewardKind) -> Bool {
        ud.integer(forKey: lastClaimKey(kind)) != todayKey()
    }

    func currentStreak(_ kind: RewardKind) -> Int {
        max(ud.integer(forKey: streakKey(kind)), 0)
    }

    @discardableResult
    func claim(_ kind: RewardKind, now: Date = Date()) -> (amount: Int, streak: Int) {
        let today = todayKey(now)
        let last  = ud.integer(forKey: lastClaimKey(kind))

        let yesterday = today - 1
        let newStreak: Int = (last == yesterday) ? currentStreak(kind) + 1 : 1
        ud.set(newStreak, forKey: streakKey(kind))

        ud.set(today, forKey: lastClaimKey(kind))

        let bonus = min(newStreak - 1, 4)
        let amount = kind.baseAmount + bonus
        return (amount, newStreak)
    }

    func allClaimedToday() -> Bool {
        RewardKind.allCases.allSatisfy { !canClaim($0) }
    }
}
