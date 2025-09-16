import Combine
import SwiftUI

final class RunnerGameViewModel: ObservableObject {
    @Published var state: StateGame = .intro
    @Published var items: [Item] = []
    @Published var playerLane: Int = 1
    @Published var hearts: Int = 3
    @Published var seeds: Int = 0
    @Published var foxY: CGFloat = 0

    var eggsAwarded: Int { seeds / 10 }
    var isIntro: Bool { if case .intro   = state { return true } else { return false } }
    var isPlaying: Bool { if case .playing = state { return true } else { return false } }
    
    private let lanes = 3
    private let targetEggs: Int
    private let playerYOffsetRatio: CGFloat = 0.78
    private let tickHz: Double = 60
    private let fallSpeed: CGFloat = 180
    private let foxSpeed: CGFloat = 40
    private var foxStartY: CGFloat {  UIScreen.main.bounds.height + 60 }

    private var gameLoop: AnyCancellable?
    private var spawner: AnyCancellable?

    private var onFinish: ((Int) -> Void)?

    init(targetEggs: Int, onFinish: ((Int) -> Void)?) {
        self.targetEggs = targetEggs
        self.onFinish = onFinish
    }

    func onDisappear() {
        stopAll()
    }

    func start() {
        FX.tap()
        Haptics.shared.selection()
        state = .playing
        items.removeAll()
        seeds = 0
        hearts = 3
        playerLane = 1
        foxY = UIScreen.main.bounds.height + 60

        let dt = 1.0 / tickHz
        gameLoop = Timer.publish(every: dt, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in self?.tick(dt: dt) }

        spawner = Timer.publish(every: 0.85, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in self?.spawnWave() }
    }

    func restart() {
        start()
    }

    private func resetFox() {
        foxY = foxStartY
    }
    
    func onFinishInternal() {
        onFinish?(eggsAwarded)
    }

    func stopAll() {
        gameLoop?.cancel(); gameLoop = nil
        spawner?.cancel();  spawner  = nil
    }

    func move(_ dir: Int) {
        guard case .playing = state else { return }
        let next = min(max(playerLane + dir, 0), lanes - 1)
        guard next != playerLane else { return }
        
        playerLane = next
        Haptics.shared.selection()
        resetFox()
    }

    private func tick(dt: Double) {
        guard case .playing = state else { return }

        let speed = fallSpeed + CGFloat(min(seeds, 150))
        for i in items.indices {
            items[i].y += CGFloat(dt) * speed
        }
        items.removeAll { $0.y > UIScreen.main.bounds.height + 60 }

        handleCollisions()

        foxY -= CGFloat(dt) * foxSpeed
        if foxY < playerY(height: UIScreen.main.bounds.height) + 20 {
            loseHeart(resetFox: true)
        }

        if eggsAwarded >= targetEggs {
            win()
        }
    }

    private func handleCollisions() {
        guard case .playing = state else { return }
        let playerY = self.playerY(height: UIScreen.main.bounds.height)
        let touchBand: CGFloat = 56

        var hitIndex: Int?
        for (i, it) in items.enumerated() where it.lane == playerLane {
            if abs(it.y - playerY) < touchBand {
                hitIndex = i
                break
            }
        }
        guard let idx = hitIndex else { return }

        let it = items[idx]
        items.remove(at: idx)

        switch it.kind {
        case .seed:
            seeds += 1
            FX.tap()
            Haptics.shared.selection()
        case .bush:
            loseHeart(resetFox: false)
        }
    }

    private func loseHeart(resetFox: Bool) {
        guard case .playing = state else { return }
        hearts = max(0, hearts - 1)
        Haptics.shared.impact(.medium)
        FX.delete()

        if resetFox {
            foxY = UIScreen.main.bounds.height + 80
        }

        items.removeAll { $0.lane == playerLane && abs($0.y - playerY(height: UIScreen.main.bounds.height)) < 90 }

        if hearts == 0 {
            gameOver(win: false)
        }
    }

    private func win() {
        FX.success()
        Haptics.shared.success()
        gameOver(win: true)
    }

    private func gameOver(win: Bool) {
        stopAll()
        state = .gameOver(win: win)
        if win {
            onFinishInternal()
        }
    }

    private func spawnWave() {
        guard case .playing = state else { return }
        let lane = Int.random(in: 0..<lanes)
        let kind: ItemKind = Bool.random(probability: 0.7) ? .seed : .bush
        let startY: CGFloat = -40
        items.append(Item(kind: kind, lane: lane, y: startY))

        if foxY > UIScreen.main.bounds.height {
            foxY = UIScreen.main.bounds.height + 30
        }
    }

    func xForLane(_ lane: Int, width: CGFloat) -> CGFloat {
        let w = width
        let left = w * 0.21
        let right = w * 0.79
        let xs = [left, (left + right) / 2, right]
        return xs[min(max(lane, 0), 2)]
    }
    
    func playerX(width: CGFloat) -> CGFloat {
        xForLane(playerLane, width: width)
    }
    
    func playerY(height: CGFloat) -> CGFloat {
        height * playerYOffsetRatio
    }
}
