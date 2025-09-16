import SwiftUI

struct AboutUsView: View {
    @EnvironmentObject var coordinator: NavigationCoordinator

    var body: some View {
        ZStack {
            Image(.bgSettings)
                .resizable()
                .scaledToFill()
                .frame(width: 700)
                .ignoresSafeArea()

            Color.black.opacity(0.5)
                .ignoresSafeArea()
            
            VStack(spacing: 18) {
                HStack {
                    Spacer()

                    BackCircle { coordinator.goBack() }
                    
                    Spacer()

                    Text("About Us")
                        .font(.chicken(32, .regular))
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(.horizontal, 18)
                .padding(.top, 6)

                GlassPanel {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Welcome")
                            .font(.chicken(22, .regular))
                            .foregroundColor(.white)

                        ScrollView(showsIndicators: false) {
                            Text(aboutCopy)
                                .font(.chicken(14, .regular))
                                .foregroundColor(.white.opacity(0.96))
                                .multilineTextAlignment(.leading)
                                .lineSpacing(4)
                                .padding(.bottom, 4)
                        }
                        .frame(width: 300)
                    }
                    .padding(14)
                }

                Spacer()
            }
            .padding(.horizontal, 18)
        }
        .navigationBarBackButtonHidden(true)
    }

    private let aboutCopy =
    """
    The place where your daily habits grow into something fun and rewarding!

    We’ve combined a simple productivity tool with a cozy farm game, so every healthy habit you complete helps your chickens grow stronger and happier.

    Here at ChickenHub, we believe that building good habits should feel like a game, not a chore. That’s why each task you finish earns points you can use to improve your farm, unlock boosters, and make your chicken coop the best it can be.

    No stress, no rush — just small daily steps, cheerful chickens, and a farm that reflects your progress. Whether you’re lifting dumbbells, reading books, or drinking more water, you’re not just improving yourself — you’re also making your virtual farm thrive.

    So, take care of yourself, feed your chickens, and enjoy the journey!
    """
}
