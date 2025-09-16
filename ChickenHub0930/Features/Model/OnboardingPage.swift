import Foundation

struct OnboardingPage: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let subtitle: String
    let backgroundImage: String
}
