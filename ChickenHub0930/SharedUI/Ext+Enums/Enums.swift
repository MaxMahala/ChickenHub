import SwiftUI

enum RewardKind: String, CaseIterable, Codable, Hashable {
    case dumbbell, book, water

    var title: String {
        switch self {
        case .dumbbell: return "Dumbbell"
        case .book:     return "Book"
        case .water:    return "Water"
        }
    }
    var imageName: String {
        switch self {
        case .dumbbell: return "rewardDumbbell"
        case .book:     return "rewardBook"
        case .water:    return "rewardWater"
        }
    }

    var baseAmount: Int {
        switch self {
        case .dumbbell: return 3
        case .book:     return 2
        case .water:    return 2
        }
    }
}

enum Route: Hashable {
    case firstHabits
    case main
    case farm
    case game
    case tasks(kind: RewardKind)
    case settings
    case aboutUs
}

enum HistoryKind: String, Codable {
    case firstHabits
    case main
    case farm
    case game
    case settings
}

enum FX {
    static func tap()     { Haptics.shared.selection() }
    static func success() { Haptics.shared.success() }
    static func reward()  { Haptics.shared.success() }
    static func delete()  { Haptics.shared.impact(.medium) }
}

enum Tool {
    case none
    case water
    case grain
}

enum PlaceKind: String, Codable {
    case coop
    case decoration
}

enum StateGame: Equatable {
    case intro
    case playing
    case gameOver(win: Bool)
}

enum ItemKind {
    case seed
    case bush
}
