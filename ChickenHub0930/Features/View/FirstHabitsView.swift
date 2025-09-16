import SwiftUI

struct FirstHabitsView: View {
    @EnvironmentObject var coordinator: NavigationCoordinator
    @StateObject private var vm = FirstHabitsViewModel()
    @AppStorage("didPickInitialHabits") private var didPickInitialHabits = false
    @AppStorage("isLoggedIn") private var isFirstLaunch = false
    
    var body: some View {
        ZStack {
            Image(.bgFirstHabits)
                .resizable()
                .scaledToFill()
                .frame(maxHeight: vm.isShortDevice() ? 680 : .infinity)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                HeaderCard()
                    .padding(.top, 40)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        ForEach(vm.items) { item in
                            HabitRow(
                                item: item,
                                onToggle: {
                                    Haptics.shared.success()
                                    vm.toggle(item)
                                }
                            )
                        }
                        .padding(.horizontal, 30)
                        
                        Text("You can change or add more habits later.")
                            .font(.chicken(12, .regular))
                            .foregroundColor(.white)
                            .outlined(color: .black, width: 0.5)
                            .padding(.top, 6)
                    }
                    .padding(.horizontal, 18)
                    .padding(.top, 12)
                    .padding(.bottom, 140)
                }
            }

            if vm.canStart {
                VStack {
                    Spacer()

                    Button {
                        Haptics.shared.success()
                        vm.saveSelection()
                        didPickInitialHabits = true
                        coordinator.push(.main)
                        isFirstLaunch = true
                    } label: {
                        Text("Start")
                            .font(.chicken(18, .regular))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                    }
                    .background {
                        Image(.bgButton)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 210, height: 56)
                    }
                    .padding(.bottom, 25)
                }
                .ignoresSafeArea(edges: .bottom)
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .animation(.spring(response: 0.35, dampingFraction: 0.85), value: vm.canStart)
            }
        }
        .padding(.vertical, 30)
        .navigationBarHidden(true)
    }
}

#Preview {
    FirstHabitsView()
}
