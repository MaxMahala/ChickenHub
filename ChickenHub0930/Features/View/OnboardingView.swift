import SwiftUI
import AppTrackingTransparency
import AdSupport

struct OnboardingView: View {
    @StateObject private var vm = OnboardingViewModel()
    @AppStorage("didFinishOnboarding") private var didFinishOnboarding = false
    @AppStorage("didAskATT") private var didAskATT = false 

    var body: some View {
        ZStack {
            ZStack(alignment: .bottom) {
                SwitchingBackground(
                    images: vm.pages.map(\.backgroundImage),
                    index: $vm.index
                )
                BottomBlurShade(height: 200)
                    .offset(y: 10)
                    .ignoresSafeArea()
            }

            VStack {
                Spacer().frame(height: 60)

                HStack {
                    Spacer()
                    Button {
                        Haptics.shared.success()
                        finishOnboarding()
                    } label: {
                        HStack(spacing: 6) {
                            Text("Skip").font(.chicken(14, .regular)).foregroundColor(.white)
                            Image(systemName: "chevron.right")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding(.trailing, 30)

                Spacer()

                VStack(spacing: 12) {
                    OnboardingCard(
                        title: vm.pages[vm.index].title,
                        subtitle: vm.pages[vm.index].subtitle
                    )
                    .padding(.horizontal, 18)

                    Button {
                        Haptics.shared.success()
                        if vm.isLast {
                            finishOnboarding()
                        } else {
                            vm.next()
                        }
                    } label: {
                        Text(vm.isLast ? "Start" : "Next")
                            .font(.chicken(18, .regular))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                    }
                    .background {
                        Image(.bgButton)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 52)
                    }
                    .padding(.vertical)
                }
            }
        }
        .ignoresSafeArea()
    }
}

private extension OnboardingView {
    func finishOnboarding() {
        requestTrackingIfNeeded {
            didFinishOnboarding = true
        }
    }

    func requestTrackingIfNeeded(completion: @escaping () -> Void) {
        guard #available(iOS 14.5, *),
              ATTrackingManager.trackingAuthorizationStatus == .notDetermined,
              !didAskATT else {
            completion()
            return
        }

        didAskATT = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            ATTrackingManager.requestTrackingAuthorization { _ in
                DispatchQueue.main.async {
                    completion()
                }
            }
        }
    }
}
