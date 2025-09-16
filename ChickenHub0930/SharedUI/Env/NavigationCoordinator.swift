import SwiftUI

final class NavigationCoordinator: ObservableObject {
    @Published var route: Route = .firstHabits
    @Published var historyContext: HistoryKind = .firstHabits

    private var history: [Route] = [.firstHabits]

    func setRoute(_ r: Route) {
        switch r {
        case .main, .settings:
            history = [r]
            route = r
        default:
            push(r)
        }
    }

    func push(_ r: Route) {
        history.append(r)
        route = r
    }

    func openFarm() {
        historyContext = .farm
        push(.farm)
    }

    func openGame() {
        historyContext = .game
        push(.game)
    }

    func goBack() {
        guard history.count > 1 else { goHome(); return }
        _ = history.popLast()
        if let last = history.last {
            route = last
        } else {
            goHome()
        }
    }

    func goHome() {
        history = [.main]
        route = .main
    }
}

