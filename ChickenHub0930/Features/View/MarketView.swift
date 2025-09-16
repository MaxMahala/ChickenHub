import SwiftUI

struct MarketView: View {
    @ObservedObject var farm: FarmViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                Image(.bgFarm).resizable().scaledToFill().ignoresSafeArea()
                
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
           
                ScrollView {
                    VStack(alignment: .leading, spacing: 22) {
                        topBar
                        MarketSection(title: "Coops", items: farm.coops, eggs: farm.eggs) { farm.buy($0) }
                        MarketSection(title: "Boosters", items: farm.boosters, eggs: farm.eggs) { farm.buy($0) }
                        MarketSection(title: "Decorations", items: farm.decorations, eggs: farm.eggs) { farm.buy($0) }
                        Color.clear.frame(height: 20)
                    }
                    .padding(18)
                    .padding(.vertical, 60)
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    private var topBar: some View {
        HStack {
            Button {
                Haptics.shared.success()
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20, weight: .black))
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
                    .background(Image(.circleBack).resizable().scaledToFit().frame(width: 68, height: 68))
            }
            Spacer()
            EggCounter(eggs: Int(farm.eggs))
        }
    }
}

#Preview {
    MarketView(farm: FarmViewModel())
}
