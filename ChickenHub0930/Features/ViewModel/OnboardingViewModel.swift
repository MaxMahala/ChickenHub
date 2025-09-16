import Foundation

final class OnboardingViewModel: ObservableObject {
    @Published var index: Int = 0

    let pages: [OnboardingPage] = [
        .init(
            title: "Plan your day with\nchicken energy",
            subtitle: "Create tasks, track habits, and keep your day under control.",
            backgroundImage: "onb1"
        ),
        .init(
            title: "Play and grow your farm",
            subtitle: "Earn eggs for every completed task to develop your farm.",
            backgroundImage: "onb2"
        ),
        .init(
            title: "Play and grow your farm",
            subtitle: "Earn eggs for every completed task to develop your farm.",
            backgroundImage: "onb3"
        )
    ]

    var isLast: Bool { index == pages.count - 1 }

    func next() {
        if !isLast { index += 1 }
    }
}
