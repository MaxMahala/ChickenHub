import SwiftUI

struct RootView: View {
    @StateObject var coordinator = NavigationCoordinator()
    @AppStorage("isFirstLaunch") private var isFirstLaunch = false
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch coordinator.route {
                case .firstHabits:
                    if !isFirstLaunch {
                        FirstHabitsView()
                    } else {
                        MainView()
                    }
                case .main:
                    MainView()
                case .farm:
                    FarmView()
                case .game:
                    RunnerGameView()
                case .settings:
                    SettingsView()
                case .aboutUs:
                    AboutUsView()
                case .tasks(let kind):
                    TasksView(kind: kind)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onAppear {
            BackgroundMusic.shared.start()
             _ = Haptics.shared.isEnabled
        }
        .onChange(of: scenePhase) { phase in
            switch phase {
            case .active:
                BackgroundMusic.shared.resumeOrStart()
            case .inactive, .background:
                BackgroundMusic.shared.pause()
            @unknown default:
                break
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .environmentObject(coordinator)
    }
}

#Preview {
    RootView()
}
