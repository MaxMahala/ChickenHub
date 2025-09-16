import SwiftUI

struct RunnerGameView: View {
    @EnvironmentObject var coordinator: NavigationCoordinator
    @StateObject private var vm: RunnerGameViewModel

    init(targetEggs: Int = 10, onFinish: ((Int) -> Void)? = nil) {
        _vm = StateObject(wrappedValue: RunnerGameViewModel(targetEggs: targetEggs, onFinish: onFinish))
    }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                if case .gameOver(_) = vm.state {
                    Image(.winBackround)
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                } else {
                    Image(.gameBackground)
                        .resizable()
                        .scaledToFill()
                        .blur(radius: vm.isPlaying ? 2 : 0)
                        .overlay(vm.isPlaying ? Color.black.opacity(0.15)
                                             : Color.clear)
                        .animation(.easeInOut(duration: 0.25), value: vm.isPlaying)
                        .offset(x: -2)
                        .ignoresSafeArea()
                }
                
                if case .playing = vm.state {
                    LaneGuides()
                        .opacity(0.7)
                        .ignoresSafeArea()
                    
                    
                    ForEach(vm.items) { it in
                        Image(it.kind.asset)
                            .resizable()
                            .scaledToFit()
                            .frame(width: it.kind.size)
                            .position(x: vm.xForLane(it.lane, width: geo.size.width),
                                      y: it.y)
                            .transition(.opacity)
                    }
                    .zIndex(1)
                    
                    Image(.runner)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 72)
                        .position(x: vm.playerX(width: geo.size.width),
                                  y: vm.playerY(height: geo.size.height))
                        .shadow(color: .black.opacity(0.25), radius: 6, y: 4)
                        .animation(.easeOut(duration: 0.15), value: vm.playerLane)
                        .zIndex(1)
                    
                    Image(.fox)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80)
                        .position(x: vm.playerX(width: geo.size.width),
                                  y: vm.foxY)
                        .shadow(color: .black.opacity(0.25), radius: 6, y: 4)
                        .zIndex(1)
                }
                
                
                if vm.isIntro || vm.isPlaying {
                    VStack(alignment: .leading) {
                        HStack {
                            BackCircle {
                                Haptics.shared.selection()
                                coordinator.goBack()
                            }
                            Spacer()
                            SeedsBadge(seeds: vm.seeds)
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 6)
                        
                        HeartsRow(hearts: vm.hearts)
                        
                        Spacer()
                    }
                    .zIndex(1)
                }
                
                if vm.isIntro {
                    StartOverlay {
                        Haptics.shared.selection()
                        vm.start()
                    }
                    .zIndex(1)
                }

                if case let .gameOver(win) = vm.state {
                    GameOverOverlay(
                        win: win,
                        eggs: vm.seeds,
                        again: {
                            vm.restart()
                            Haptics.shared.selection()
                        },
                        home: {
                            coordinator.goHome()
                            Haptics.shared.selection()
                        }
                    )
                    .zIndex(1)
                }

                HStack(spacing: 0) {
                    Color.clear.contentShape(Rectangle())
                        .onTapGesture { vm.move(-1) }
                    Color.clear.contentShape(Rectangle())
                        .onTapGesture { vm.move(1) }
                }
                .gesture(
                    DragGesture(minimumDistance: 10).onEnded { g in
                        if g.translation.width < -10 { vm.move(-1) }
                        if g.translation.width >  10 { vm.move(1) }
                    }
                )
            }
            .onDisappear(perform: vm.onDisappear)
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    RunnerGameView()
}

