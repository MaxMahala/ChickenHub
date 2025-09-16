import SwiftUI

struct TasksView: View {
    let kind: RewardKind
    @EnvironmentObject var coordinator: NavigationCoordinator
    @StateObject private var kb = KeyboardObserver()
    @FocusState private var typing: Bool

    @StateObject private var vm: TasksViewModel

    init(kind: RewardKind) {
        self.kind = kind
        _vm = StateObject(wrappedValue: TasksViewModel(kind: kind))
    }

    var body: some View {
        ZStack {
            Image(.bgFirstHabits)
                .resizable()
                .scaledToFill()
                .frame(maxHeight: vm.isShortDevice() ? 680 : .infinity)
                .ignoresSafeArea()
                .onTapGesture { typing = false }

            VStack(spacing: 16) {
                Spacer(minLength: 20)

                HStack {
                    backButton
                    Spacer()
                    ProgressBadge(text: vm.progressText)
                    Spacer()
                    GearButton {
                        Haptics.shared.success()
                        coordinator.push(.settings)
                    }
                }
                .padding(.horizontal, 18)
                .padding(.top, 8)

                ScrollViewReader { proxy in
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 10) {
                            titleBar

                            Divider()
                                .frame(height: 3)
                                .overlay(AppTheme.carrot)

                            ForEach(vm.items) { t in
                                TaskRow(
                                    title: t.title,
                                    done: t.done,
                                    toggle: { vm.toggle(t.id) },
                                    action: {
                                        Haptics.shared.success()
                                        vm.selectedItem = t
                                    }
                                )
                                Divider().opacity(0.2)
                            }

                            HStack(spacing: 12) {
                                Button {
                                    Haptics.shared.success()
                                    if !vm.items.isEmpty {
                                        if let selectedItem = vm.selectedItem {
                                            vm.remove(id: selectedItem.id)
                                        }
                                    }
                                } label: {
                                    Image(systemName: "trash")
                                        .font(.system(size: 25, weight: .bold))
                                        .foregroundColor(.black)
                                }

                                Spacer()

                                HStack(spacing: 8) {
                                    TextField("New task…", text: $vm.newTitle)
                                        .textFieldStyle(.plain)
                                        .font(.chicken(16, .regular))
                                        .submitLabel(.done)
                                        .focused($typing)
                                        .onSubmit { vm.add() }
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 6)
                                        .background(Color.gray.opacity(0.12))
                                        .cornerRadius(8)
                                        .frame(maxWidth: 220)

                                    Button {
                                        Haptics.shared.success()
                                        vm.add()
                                    } label: {
                                        Image(systemName: "plus")
                                            .font(.system(size: 28, weight: .bold))
                                            .foregroundColor(.black)
                                    }
                                }
                            }
                            .padding(.top, 30)

                            Color.clear.frame(height: 1).id("bottom")
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 22)
                                .fill(Color.white)
                                .overlay(RoundedRectangle(cornerRadius: 22).stroke(AppTheme.carrot, lineWidth: 3))
                                .shadow(color: .black.opacity(0.15), radius: 12, y: 8)
                        )
                        .padding(.horizontal, 22)
                        .onChange(of: typing) { isTyping in
                            if isTyping {
                                withAnimation(.easeOut(duration: 0.25)) {
                                    proxy.scrollTo("bottom", anchor: .bottom)
                                }
                            }
                        }
                    }
                    .scrollDismissesKeyboard(.interactively)
                }

                Spacer()
            }
            .padding(.top, 24)
            .padding(.bottom, kb.height)
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") { typing = false }
                    .font(.chicken(16, .regular))
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    private var backButton: some View {
        Button {
            Haptics.shared.success()
            coordinator.goBack()
        } label: {
            Image(systemName: "chevron.left")
                .font(.system(size: 22, weight: .black))
                .foregroundColor(.white)
                .frame(width: 62, height: 62)
                .background(
                    Image(.circleBack).resizable().scaledToFit().frame(width: 68, height: 68)
                )
                .shadow(color: AppTheme.whiteShadow, radius: 10, y: 6)
        }
        .buttonStyle(.plain)
    }

    private var titleBar: some View {
        HStack {
            Text(kind.title.uppercased())
                .font(.chicken(24, .regular))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .center)
        }
    }
}
