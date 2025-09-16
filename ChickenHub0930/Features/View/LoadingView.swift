import SwiftUI

struct LoadingView: View {
    @StateObject private var viewModel = LoadingViewModel()
    @AppStorage("didFinishOnboarding") private var didFinishOnboarding = false

    var body: some View {
        Group {
            if viewModel.showNextView {
                if didFinishOnboarding {
                    RootView()
                } else {
                    OnboardingView()
                }
            } else {
                ZStack {
                    Image(.bgLoading)
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()

                    VStack {
                        Spacer()

                        VStack(spacing: 0) {
                            Image(.whiteChicken)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 218)
                            
                            Image(.logoText)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 331)
                                .offset(y: -90)
                        }
                        .shadow(color: .white.opacity(0.8), radius: 12, y: 8)

                        Spacer()

                        LoadingRing(progress: viewModel.progress)
                            .frame(width: 48, height: 48)
                            .padding(.bottom, 32)

                        Rectangle().fill(Color.clear).frame(height: 18)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 24)
                }
                .onAppear { viewModel.start() }
            }
        }
    }
}

#Preview {
    LoadingView()
}
