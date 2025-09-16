import SwiftUI
import Combine

final class FarmViewModel: ObservableObject {
    @Published var eggs: Double = 0 {
        didSet { recomputeFromEggs() }
    }
    @Published var level: Int = 1
    @Published var progress: Double = 0
    @Published var chickens: [FarmChicken] = []
    
    @Published var showGrowthBubble = false
    @Published var bubbleText: String = "0%"
    @Published var bubbleAnchorID: UUID?
    @Published var pulsingChickenID: UUID?
    
    @Published var selectedTool: Tool = .none
    @Published var showShop = false
    @Published var placed: [PlacedThing] = []
    @Published var showMarket: Bool = false
    @Published var timedPrompt: TimedPrompt?
    
    private var waterTimer: AnyCancellable?
    private let eggsPerLevel = 10
    private var bag = Set<AnyCancellable>()
    private let saveKey = "farm.save.v1"
    
    private let store: HabitStore?
    
    var coops: [MarketItem] = [
        .init(title: "Basic Coop",   image: "coop1", price: 50,  placeable: .coop, subtitle: nil),
        MarketItem(title: "Upgraded Coop", image: "coop2", price: 150, placeable: .coop, subtitle: "+2 additional points per day"),
        .init(title: "Luxury Coop",  image: "coop3",  price: 300, placeable: .coop, subtitle: "+5 additional points per day")
    ]
    var boosters: [MarketItem] = [
        .init(title: "Large Grain",  image: "seed",  price: 30,  placeable: nil, subtitle: nil),
        .init(title: "Super Drop",   image: "water",   price: 40,  placeable: nil, subtitle: "+5 additional points per day"),
        .init(title: "Golden Feed",  image: "feed",  price: 100, placeable: nil, subtitle: nil)
    ]
    
    var decorations: [MarketItem] = [
        .init(title: "Large Grain", image: "dec1", price: 15,  placeable: .decoration, subtitle: nil),
        .init(title: "Super Drop", image: "dec2",    price: 20,  placeable: .decoration, subtitle: nil),
        .init(title: "Golden Feed", image: "dec3",  price: 25,  placeable: .decoration, subtitle: nil),
        .init(title: "Large Grain", image: "dec4",  price: 25,  placeable: .decoration, subtitle: nil),
        .init(title: "Super Drop", image: "dec5",  price: 25,  placeable: .decoration, subtitle: nil),
        .init(title: "Golden Feed", image: "dec6",  price: 25,  placeable: .decoration, subtitle: nil)
    ]
    
    init(store: HabitStore? = nil,
         chickens: [FarmChicken] = [
            .init(imageName: "Chicken-1", pos: CGPoint(x: 0.50, y: 1.00), scale: 1.0),
            .init(imageName: "Chicken-2", pos: CGPoint(x: 0.78, y: 0.90), scale: 1.0),
            .init(imageName: "Chicken-3", pos: CGPoint(x: 0.22, y: 0.80), scale: 1.0)
         ]) {
             self.store = store
             
             if !load() {
                 self.chickens = chickens
                 recomputeFromEggs()
             }
             
             Publishers.CombineLatest3($eggs, $chickens, $level)
                 .debounce(for: .milliseconds(150), scheduler: DispatchQueue.main)
                 .sink { [weak self] _, _, _ in self?.persist() }
                 .store(in: &bag)
             
             store?.$tasks
                 .sink { _ in }
                 .store(in: &bag)
         }
    
    private func recomputeFromEggs() {
        let total = max(0, eggs)
        let intTotal = Int(total.rounded(.down))
        let newLevel = max(1, intTotal / eggsPerLevel + 1)
        let remainder = total - Double(intTotal / eggsPerLevel * eggsPerLevel)
        let newProgress = remainder / Double(eggsPerLevel)
        
        if newLevel != level { level = newLevel }
        if abs(newProgress - progress) > .ulpOfOne { progress = newProgress }
    }
    
    func openMiniGame() { FX.tap(); pulse(anyID); }
    func waterAction()  { FX.tap(); selectedTool = .water;  eggs += 0.1; }
    func feedGrain()    { FX.tap(); selectedTool = .grain;  eggs += 0.1; }
    func openShop()     { FX.tap(); pulse(anyID); }
    
    func tapChicken(_ id: UUID) {
        pulse(id)
        guard selectedTool != .none,
              let idx = chickens.firstIndex(where: { $0.id == id }) else { return }
        
        let delta: CGFloat = (selectedTool == .water) ? 0.06 : 0.08
        let maxScale: CGFloat = 2.40
        
        withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
            chickens[idx].scale = min(chickens[idx].scale + delta, maxScale)
        }
        
        bubbleAnchorID = id
        bubbleText = "0.1%"
        showBubble()
        
        selectedTool = .none
        Haptics.shared.success()
    }
    
    private func showBubble() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.9)) {
            showGrowthBubble = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) { [weak self] in
            withAnimation(.easeOut(duration: 0.22)) { self?.showGrowthBubble = false }
        }
    }
    
    func pulse(_ id: UUID?) {
        guard let id else { return }
        pulsingChickenID = id
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { [weak self] in
            withAnimation(.easeOut(duration: 0.2)) { self?.pulsingChickenID = nil }
        }
    }
    
    private var anyID: UUID? { chickens.first?.id }
    
    @discardableResult
    func buy(_ item: MarketItem) -> Bool {
        guard eggs >= Double(item.price) else {
            Haptics.shared.warning()
            bubbleText = "Not enough eggs"
            bubbleAnchorID = anyID
            showBubble()
            return false
        }
        eggs -= Double(item.price)
        Haptics.shared.success()
        FX.success()

        if let kind = item.placeable {
            let startPos: CGPoint
            let scale: CGFloat
            switch kind {
            case .coop:
                startPos = CGPoint(x: 0.86, y: 0.82)
                scale = 1.20
            case .decoration:
                startPos = CGPoint(x: 0.15, y: 0.88)
                scale = 1.00
            }

            placed.append(PlacedThing(
                imageName: item.image,
                posX: startPos.x, posY: startPos.y,
                scale: scale,
                kind: kind
            ))
        }
        return true
    }

    private func persist() {
        let save = FarmSave(
            eggs: eggs,
            level: level,
            progress: progress,
            chickens: chickens.map { $0.saveModel },
            placed: placed
        )
        do {
            let data = try JSONEncoder().encode(save)
            UserDefaults.standard.set(data, forKey: saveKey)
        } catch {
            #if DEBUG
                print("Farm persist error:", error)
            #endif
        }
    }
    
    private func load() -> Bool {
        guard let data = UserDefaults.standard.data(forKey: saveKey) else { return false }
        do {
            let save = try JSONDecoder().decode(FarmSave.self, from: data)
            self.eggs = save.eggs
            self.level = save.level
            self.progress = save.progress
            self.chickens = save.chickens.map { $0.runtime }
            self.placed = save.placed
            return true
        } catch { return false }
    }
    
    func stopPromptTimer() {
        waterTimer?.cancel()
        waterTimer = nil
    }
    
    private func randomPlacement(for kind: PlaceKind) -> (point: CGPoint, scale: CGFloat) {
        let xRange = (kind == .coop) ? PlaceRules.coopX : PlaceRules.decX
        let yRange = (kind == .coop) ? PlaceRules.coopY : PlaceRules.decY
        let minDist = (kind == .coop) ? PlaceRules.coopMinDist : PlaceRules.decMinDist
        let scaleRange = (kind == .coop) ? PlaceRules.coopScale : PlaceRules.decScale

        var anchors: [CGPoint] = placed.map { CGPoint(x: $0.posX, y: $0.posY) }
        anchors.append(contentsOf: chickens.map(\.pos))

        var bestP = CGPoint(x: (xRange.lowerBound + xRange.upperBound)/2,
                            y: (yRange.lowerBound + yRange.upperBound)/2)
        var bestScore: CGFloat = -1

        for _ in 0..<40 {
            let p = CGPoint(x: .random(in: xRange), y: .random(in: yRange))
            let score = anchors.map { hypot($0.x - p.x, $0.y - p.y) }.min() ?? .greatestFiniteMagnitude
            if score >= minDist {
                return (p, .random(in: scaleRange))
            }
            if score > bestScore {
                bestScore = score
                bestP = p
            }
        }
        return (bestP, .random(in: scaleRange))
    }
    
    private func blackChickenID() -> UUID? {
        chickens.first {
            $0.imageName.lowercased().contains("black")
            || $0.imageName.contains("2")          // e.g. "Chicken-2"
        }?.id
    }

    func startPromptTimer(immediate: Bool = true) {
        waterTimer?.cancel()

        if immediate {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
                self?.spawnWaterPrompt()
            }
        }

        waterTimer = Timer.publish(every: 120, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in self?.spawnWaterPrompt() }
    }

    private func spawnWaterPrompt() {
        let targetID = blackChickenID() ?? chickens.first?.id ?? chickens.randomElement()?.id
        guard let targetID else { return }

        timedPrompt = TimedPrompt(id: targetID, kind: .water)

        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) { [weak self] in
            if self?.timedPrompt?.id == targetID {
                withAnimation(.easeOut(duration: 0.2)) {
                    self?.timedPrompt = nil
                }
            }
        }
    }
}
