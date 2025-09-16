import Combine
import SwiftUI

final class KeyboardObserver: ObservableObject {
    @Published var height: CGFloat = 0
    private var bag = Set<AnyCancellable>()

    init() {
        let willChange = NotificationCenter.default.publisher(for: UIResponder.keyboardWillChangeFrameNotification)
        let willHide   = NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)

        Publishers.Merge(willChange, willHide)
            .sink { note in
                guard
                    let endFrame = note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
                    let duration = note.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
                else { return }

                let screenH = UIScreen.main.bounds.height
                let newHeight = max(0, screenH - endFrame.minY - 150)

                DispatchQueue.main.async {
                    withAnimation(.easeOut(duration: duration)) {
                        self.height = newHeight
                    }
                }
            }
            .store(in: &bag)
    }
}
