import SwiftUI
import Combine

final class TasksViewModel: ObservableObject {
    let kind: RewardKind
    let store: HabitStore
    private var bag = Set<AnyCancellable>()

    @Published var newTitle: String = ""
    @Published var items: [HabitTask] = []
    @Published var allCompleted: Int = 0
    @Published var selectedItem: HabitTask?

    var progressText: String { "\(allCompleted)/10" }

    init(kind: RewardKind, store: HabitStore = .shared) {
        self.kind = kind
        self.store = store

        store.$tasks
            .map { $0[kind] ?? [] }
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .assign(to: \.items, on: self)
            .store(in: &bag)

        store.$tasks
            .map { _ in store.completedAll() }
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .assign(to: \.allCompleted, on: self)
            .store(in: &bag)
    }

    func toggle(_ id: UUID) {
        store.toggle(kind, id: id)
    }

    func add() {
        store.add(kind, title: newTitle)
    }

    func removeLast() {
        guard !items.isEmpty else { return }
        store.remove(kind, at: IndexSet(integer: items.count - 1))
    }

    func remove(id: UUID) {
        guard let idx = items.firstIndex(where: { $0.id == id }) else { return }
        store.remove(kind, at: IndexSet(integer: idx))
    }
    
    func isShortDevice() -> Bool {
        UIScreen.main.bounds.height < 700
    }
}
