import SwiftUI

struct MainView: View {
    @EnvironmentObject var coordinator: NavigationCoordinator
    @AppStorage("isFirstLaunch") private var isFirstLaunch = false
    @StateObject private var rewardVM = DailyRewardViewModel { amount, kind in
        print("Award +\(amount) from \(kind)")
    }

    var body: some View {
        ZStack {
            Image(.bgFirstHabits)
                .resizable()
                .scaledToFill()
                .frame(maxHeight: rewardVM.isShortDevice() ? 680 : .infinity)
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    Spacer(minLength: 50)
                    
                    HStack(alignment: .top, spacing: 12) {
                        WelcomeCard()
                        VStack(spacing: 18) {
                            GearButton {
                                Haptics.shared.success()
                                coordinator.push(.settings)
                            }
                            ProgressBadge(text: rewardVM.allProgressText)
                        }
                    }
                    .padding(.horizontal, 18)
                    .padding(.top, 40)
                    
                    HStack(spacing: 12) {
                        CategoryTile(title: "DUMBBELL", image: .dumbbell, color: .blue) {
                            coordinator.push(.tasks(kind: .dumbbell))
                        }
                        CategoryTile(title: "BOOK", image: .book, color: AppTheme.carrot) {
                            coordinator.push(.tasks(kind: .book))
                        }
                        CategoryTile(title: "WATER", image: .waterDroplet, color: AppTheme.purple) {
                            coordinator.push(.tasks(kind: .water))
                        }
                    }
                    .padding(.horizontal, 18)
                    
                    Button {
                        coordinator.push(.farm)
                        Haptics.shared.success()
                    } label: {
                        Image(.farmPreview)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 260)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .overlay(RoundedRectangle(cornerRadius: 16).stroke(.white.opacity(0.9), lineWidth: 6))
                            .shadow(color: AppTheme.whiteShadow, radius: 12, y: 8)
                            .padding(.horizontal, 18)
                    }
                    
                    DailyRewardButton {
                        rewardVM.showReward = true
                        Haptics.shared.success()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    Spacer(minLength: 100)
                }
            }
        }
        .overlay {
            if rewardVM.showReward {
                DailyRewardOverlay(vm: rewardVM, isPresented: $rewardVM.showReward)
                    .transition(.scale.combined(with: .opacity))
                    .animation(.spring(response: 0.35, dampingFraction: 0.85), value: rewardVM.showReward)
            }
        }
        .onAppear {
            isFirstLaunch = true
            rewardVM.refresh()
            if rewardVM.showSheet {
                rewardVM.showReward = true
            }
        }
    }
}

#Preview { MainView() }




