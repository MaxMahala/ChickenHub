import Foundation
import Combine

final class HabitStore: ObservableObject {
    static let shared = HabitStore()
    @Published private(set) var tasks: [RewardKind: [HabitTask]] = [:]

    private let ud = UserDefaults.standard
    private let cal = Calendar.current
    private var cancellables = Set<AnyCancellable>()

    private var todayKey: String {
        let comps = cal.dateComponents([.year, .month, .day], from: Date())
        return "\(comps.year!)-\(comps.month!)-\(comps.day!)"
    }
    private func key(_ kind: RewardKind) -> String { "hb.\(todayKey).\(kind.rawValue)" }

    init() {
        loadToday()
    }

    func loadToday() {
        var dict: [RewardKind:[HabitTask]] = [:]
        for k in RewardKind.allCases {
            dict[k] = load(for: k)
        }
        tasks = dict
    }

    private func load(for kind: RewardKind) -> [HabitTask] {
        if let data = ud.data(forKey: key(kind)),
           let arr = try? JSONDecoder().decode([HabitTask].self, from: data) {
            return arr
        }
        return defaults(for: kind)
    }

    private func save(_ kind: RewardKind) {
        guard let arr = tasks[kind],
              let data = try? JSONEncoder().encode(arr) else { return }
        ud.set(data, forKey: key(kind))
    }

    func toggle(_ kind: RewardKind, id: UUID) {
        guard var arr = tasks[kind], let i = arr.firstIndex(where: {$0.id == id}) else { return }
        arr[i].done.toggle()
        tasks[kind] = arr
        save(kind)
        objectWillChange.send()
    }

    func add(_ kind: RewardKind, title: String) {
        guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        var arr = tasks[kind] ?? []
        arr.append(HabitTask(title: title))
        tasks[kind] = arr
        save(kind)
        objectWillChange.send()
    }

    func remove(_ kind: RewardKind, at offsets: IndexSet) {
        guard var arr = tasks[kind] else { return }
        arr.remove(atOffsets: offsets)
        tasks[kind] = arr
        save(kind)
        objectWillChange.send()
    }

    func completedCount(_ kind: RewardKind) -> Int { tasks[kind]?.filter{$0.done}.count ?? 0 }
    func totalCount(_ kind: RewardKind) -> Int { tasks[kind]?.count ?? 0 }
    func completedAll() -> Int { RewardKind.allCases.reduce(0) { $0 + completedCount($1) } }

    private func defaults(for kind: RewardKind) -> [HabitTask] {
        switch kind {
        case .dumbbell:
            return [
                "Morning stretching — 10 min",
                "20 squats challenge",
                "Go for a 15-minute walk",
                "5 push-ups before breakfast",
                "Evening yoga session"
            ].map { HabitTask(title: $0) }
        case .book:
            return [
                "Read 5 pages of a book",
                "Listen to an educational podcast",
                "Write 2 sentences in your diary",
                "Learn 5 new words",
                "Spend 10 minutes on a hobby"
            ].map { HabitTask(title: $0) }
        case .water:
            return [
                "Drink 1 glass right after waking up",
                "Drink 2 liters today",
                "Have herbal tea instead of coffee",
                "Eat a fruit with high water content",
                "Replace soda with water once"
            ].map { HabitTask(title: $0) }
        }
    }
}
