import Foundation
import Combine

final class LoadingViewModel: ObservableObject {
    @Published var showNextView = false
    @Published var ringRotate = false
    @Published var progress: CGFloat = 0

    private var timer: AnyCancellable?

    private let tick: TimeInterval = 0.03
    private let duration: TimeInterval = 3.0

    func start() {
        ringRotate = true

        timer = Timer.publish(every: tick, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self else { return }
                progress = min(progress + CGFloat(tick / duration), 1.0)
                if progress >= 1.0 {
                    timer?.cancel()
                    DispatchQueue.main.async { self.showNextView = true }
                }
            }
    }

    deinit { timer?.cancel() }
}
