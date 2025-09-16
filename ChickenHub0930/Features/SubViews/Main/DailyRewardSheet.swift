import SwiftUI

struct DailyRewardOverlay: View {
    @ObservedObject var vm: DailyRewardViewModel
    @Binding var isPresented: Bool

    private var nextCard: RewardCard? {
        vm.cards.first(where: { $0.canClaim })
            ?? vm.cards.first
    }

    var body: some View {
        ZStack {
            Color.black.opacity(0.55)
                .ignoresSafeArea()
                .onTapGesture { isPresented = false }

            if let card = nextCard {
                ZStack(alignment: .topTrailing) {
                    VStack(spacing: 18) {
                        Text("DAILY REWARD")
                            .font(.chicken(24, .regular))
                            .foregroundColor(.black)

                        OrangeDivider()

                        VStack(spacing: 8) {
                            Image(.threeWheatGrainsIcon3DCartoonStyleGolden1)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 120)
                            Text("x\(card.todayAmount)")
                                .font(.chicken(22, .regular))
                                .foregroundColor(.black)
                        }
                        .padding(.top, 4)

                        Button {
                            if card.canClaim { vm.claim(card.kind) }
                            if vm.allClaimed { isPresented = false }
                            Haptics.shared.success()
                        } label: {
                            Text(card.canClaim ? "CLAIM" : "DONE")
                                .font(.chicken(18, .regular))
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                                .frame(maxWidth: 220)
                        }
                        .background {
                            Image(.bgButton)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 56)
                        }
                        .padding(.top, 6)
                        .padding(.bottom, 6)
                    }
                    .padding(18)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(AppTheme.carrot, lineWidth: 4)
                            )
                            .shadow(color: .black.opacity(0.2), radius: 18, y: 10)
                    )

                    Button { isPresented = false } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.black)
                            .padding(10)
                    }
                    .padding(.top, 6)
                    .padding(.trailing, 6)
                }
                .frame(maxWidth: 320)
                .padding(.horizontal, 24)
            }
        }
    }
}

private struct OrangeDivider: View {
    var body: some View {
        HStack(spacing: 10) {
            Diamond().fill(AppTheme.carrot).frame(width: 10, height: 10)
            Rectangle()
                .fill(AppTheme.carrot)
                .frame(height: 4)
                .cornerRadius(2)
            Diamond().fill(AppTheme.carrot).frame(width: 10, height: 10)
        }
    }
}

private struct Diamond: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let c = CGPoint(x: rect.midX, y: rect.midY)
        p.move(to: CGPoint(x: c.x, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.maxX, y: c.y))
        p.addLine(to: CGPoint(x: c.x, y: rect.maxY))
        p.addLine(to: CGPoint(x: rect.minX, y: c.y))
        p.closeSubpath()
        return p
    }
}
