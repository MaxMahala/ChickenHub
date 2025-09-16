import SwiftUI
import Combine

final class FirstHabitsViewModel: ObservableObject {
    @Published var items: [HabitItem] = [
        .init(id: "exercise",
              title: "Morning Exercise",
              subtitle: "Get the Active Chicken",
              imageName: "Chicken-1"),
        .init(id: "reading",
              title: "Reading",
              subtitle: "Meet the Wise Chicken",
              imageName: "Chicken-2"),
        .init(id: "water",
              title: "Drinking Water",
              subtitle: "Welcome the Fresh Chicken",
              imageName: "Chicken-3")
    ]

    var selectedCount: Int { items.filter(\.isSelected).count }
    var canStart: Bool { selectedCount >= 3 }

    func toggle(_ item: HabitItem) {
        guard let idx = items.firstIndex(of: item) else { return }
        items[idx].isSelected.toggle()
    }

    func saveSelection() {
        Haptics.shared.success()
        let ids = items.filter(\.isSelected).map(\.id)
        UserDefaults.standard.set(ids, forKey: "initialHabitIDs")
    }
    
    func isShortDevice() -> Bool {
        UIScreen.main.bounds.height < 700
    }
}
