import SwiftUI
import SwiftUI

struct FarmView: View {
    @EnvironmentObject var coordinator: NavigationCoordinator
    @StateObject private var vm = FarmViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image(.bgFarm)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                let screenH = UIScreen.main.bounds.height
                         let isShort = screenH < 700
                         let verticalPad: CGFloat = isShort ? 90 : 05
                
                GeometryReader { geo in
                    let H = geo.size.height
                    let isShort = H < 700
                    let headerH: CGFloat = isShort ? 62 : 72
                    let topReserve: CGFloat = isShort ? 90 : 120
                    let bottomReserve: CGFloat = isShort ? 90 : 120
                    let chickenBase: CGFloat = isShort ? 34 : 44
                    let decoBase: CGFloat = isShort ? 74 : 90
                    let coopBase: CGFloat = isShort ? 92 : 110
                    let toolbarBottomPad: CGFloat = isShort ? 2 : 8
                    
                    VStack {
                        HStack(spacing: 12) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("YOUR FARM")
                                    .font(.chicken(isShort ? 16 : 18, .regular))
                                Text("LEVEL \(vm.level)")
                                    .font(.chicken(isShort ? 11 : 12, .regular))
                                    .tracking(0.6)
                                    .foregroundColor(.white.opacity(0.96))
                                    .shadow(color: .black.opacity(0.35), radius: 2, y: 1)
                            }
                            .foregroundStyle(.white)
                            .padding(12)
                            .frame(height: headerH)
                            .background(BluredBackRounded(radius: 25))
                            .overlay {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.white, lineWidth: 6)
                            }
                            .cornerRadius(10)
                            
                            Spacer()
                            
                            EggCounter(eggs: Int(vm.eggs))
                                .scaleEffect(isShort ? 0.9 : 1.0)
                        }
                        .padding(.horizontal, 18)
                        .padding(.top, isShort ? 6 : 10)
                        
                        Spacer()
                    }
                    
                    let meadow = CGRect(
                        x: 0,
                        y: topReserve,
                        width: geo.size.width,
                        height: max(0, geo.size.height - topReserve - bottomReserve)
                    )
                    
                    ForEach(vm.placed.filter { $0.kind == .decoration }) { obj in
                        let p = CGPoint(
                            x: meadow.minX + obj.posX * meadow.width,
                            y: meadow.minY + obj.posY * meadow.height
                        )
                        Image(obj.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: decoBase * obj.scale)
                            .position(p)
                            .shadow(color: .black.opacity(0.25), radius: 8, y: 4)
                            .zIndex(10)
                    }
                    
                    ForEach(vm.chickens) { ch in
                        let p = CGPoint(
                            x: meadow.minX + ch.pos.x * meadow.width,
                            y: meadow.minY + ch.pos.y * meadow.height
                        )
                        let pulsing = vm.pulsingChickenID == ch.id
                        
                        Image(ch.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: chickenBase * ch.scale)
                            .position(p)
                            .shadow(color: AppTheme.whiteShadow, radius: 6, y: 4)
                            .scaleEffect(pulsing ? 1.12 : 1.0)
                            .animation(.spring(response: 0.25, dampingFraction: 0.6), value: pulsing)
                            .onTapGesture { vm.tapChicken(ch.id) }
                    }
                    
                    ForEach(vm.placed.filter { $0.kind == .coop }) { obj in
                        let p = CGPoint(
                            x: meadow.minX + obj.posX * meadow.width,
                            y: meadow.minY + obj.posY * meadow.height
                        )
                        Image(obj.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: coopBase * obj.scale)
                            .position(p)
                            .shadow(color: .black.opacity(0.15), radius: 8, y: 4)
                            .zIndex(0)
                    }
                    
                    if vm.showGrowthBubble,
                       let id = vm.bubbleAnchorID,
                       let ch = vm.chickens.first(where: { $0.id == id }) {
                        let anchor = CGPoint(
                            x: meadow.minX + ch.pos.x * meadow.width,
                            y: meadow.minY + ch.pos.y * meadow.height - 56
                        )
                        GrowingBubble(text: vm.bubbleText)
                            .position(anchor)
                            .transition(.opacity.combined(with: .scale))
                    }
                    
                    if let prompt = vm.timedPrompt, prompt.kind == .water,
                       let ch = vm.chickens.first(where: { $0.id == prompt.id }) {

                        let anchor = CGPoint(
                            x: meadow.minX + ch.pos.x * meadow.width,
                            y: meadow.minY + ch.pos.y * meadow.height
                        )

                        let chickenW = chickenBase * ch.scale

                        let hintSize = max(26, min(46, 0.60 * chickenW))

                        let dx = max(-230, min(-220,  -0.38 * chickenW))
                        let dy = max(-170, min(-34,  -0.95 * chickenW))

                        WaterHint(size: hintSize)
                            .position(x: anchor.x + dx, y: anchor.y + dy)
                            .transition(.scale.combined(with: .opacity))
                            .zIndex(50)
                            .allowsHitTesting(false)
                    }
                    
                    VStack {
                        Spacer()
                        FarmToolbar(
                            left:  {
                                Haptics.shared.success()
                                coordinator.goBack()
                            },
                            game:  {
                                vm.openMiniGame()
                                coordinator.push(.game)
                            },
                            water: { vm.waterAction() },
                            grain: { vm.feedGrain() },
                            shop:  {
                                vm.openShop()
                                vm.showMarket = true
                            },
                            waterSelected: vm.selectedTool == .water,
                            grainSelected: vm.selectedTool == .grain
                        )
                        .padding(.bottom, toolbarBottomPad)
                        .scaleEffect(isShort ? 0.95 : 1.0)
                    }
                }
                .padding(.vertical, verticalPad)
            }
            .onAppear { vm.startPromptTimer(immediate: true) }
            .onDisappear { vm.stopPromptTimer() }
            .navigationBarBackButtonHidden(true)
            .navigationDestination(isPresented: $vm.showMarket) {
                MarketView(farm: vm)
            }
        }
    }
}
