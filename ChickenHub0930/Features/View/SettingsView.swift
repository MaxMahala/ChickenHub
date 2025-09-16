import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var coordinator: NavigationCoordinator
    @Environment(\.openURL) private var openURL
    @StateObject private var vm = SettingsViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                Image(.bgSettings)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 700)
                    .ignoresSafeArea()
                
                Color.black.opacity(0.5)
                    .ignoresSafeArea()

                VStack(spacing: 22) {
                    HStack {
                        Spacer()

                        BackCircle {
                            Haptics.shared.success()
                            coordinator.goBack()
                        }
                        
                        Spacer()

                        Text("Settings")
                            .font(.chicken(32, .regular))
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(.horizontal, 18)
                    .padding(.top, 6)

                    HStack(spacing: 28) {
                        ToggleRow(title: "Sound", isOn: $vm.soundOn)
                        ToggleRow(title: "Vibration", isOn: $vm.hapticsOn)
                    }
                    .padding(.top, 30)

                    VStack(spacing: 14) {
                        GlossyActionButton(title: "About Us") {
                            Haptics.shared.success()
                            coordinator.push(.aboutUs)
                        }

                        GlossyActionButton(title: "Privacy") {
                            Haptics.shared.success()
                            openURL(vm.privacyURL)
                        }

                        GlossyActionButton(title: "Rate Us") {
                            Haptics.shared.success()
                            vm.rateApp()
                        }
                    }
                    .padding(.top, 30)

                    Spacer()
                }
                .padding(.top, 40)
            }
            .onChange(of: vm.soundOn) { newValue in
                BackgroundMusic.shared.applySetting(isOn: newValue)
            }
            .onChange(of: vm.hapticsOn) { isOn in
                Haptics.shared.setEnabled(isOn)
                if isOn { Haptics.shared.selection() } 
            }
        }
    }
}

#Preview {
    SettingsView()
}
 
