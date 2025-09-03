//
//  ShootPlanView.swift
//  Lynz
//
//  Created by Артур Кулик on 31.08.2025.
//

import SwiftUI


struct ShootPlanView: View {
    @StateObject var store: ShootPlanViewStore
    @FocusState private var focusedIndex: Int?
    private let navigationTitle = "Shoot Plan"
    
    
    //MARK: - UI
    private var radioButtonColor: Color {
        switch store.state.plan.role {
        case .photographer: Color.lzBlue.opacity(store.state.editMode ? 0.4 : 1)
        case .model: Color.lzYellow.opacity(store.state.editMode ? 0.3 : 1)
        }
    }
    
    private var radioButtonStrokeWidth: CGFloat {
        switch store.state.plan.role {
        case .photographer: 1
        case .model: 1.4
        }
    }
    
    init(plan: Plan) {
        _store = StateObject(wrappedValue: ShootPlanViewStore(initialState: .init(plan: plan)))
    }
    
    var body: some View {
        content
            .navigationTitle(navigationTitle) // На случай если в будущем будет переход из этого экрана для названия BackButton
            .navigationBarTitleDisplayMode(.inline)
            .hideInlineNavigationTitle()
            .background(BackgroundGradient().ignoresSafeArea(.all))
            .confirmationDialog(
                "Are you sure you want to delete the plan for this day? ",
                isPresented: Binding(
                    get: { store.state.isShowConfirmationDialog },
                    set: { _ in /*store.send(.showDialog($0))*/ }
                )
            ) {
                Button("Delete Plan", role: .destructive) {
                    store.send(.confirmPlanDelete)
                }
                Button("Cancel", role: .cancel) {
                    store.send(.cancelPlanDelete)
                }
            }
    }
    
    var content: some View {
        ZStack {
            ScrollView {
                VStack {
                    screenHeader
                        .padding(.top, .medium)
                    planList
                }
                .frame(maxHeight: .infinity, alignment: .top)
                .padding(.horizontal, .mediumExt)
            }
            actionButton
                .frame(maxHeight: .infinity, alignment: .bottom)
                .padding(.bottom, .huge)
                .padding(.horizontal, .mediumExt)
                .ignoresSafeArea(edges: .bottom)
        }
    }
    
    var planList: some View {
        LazyVStack {
            ForEach(Array(store.state.plan.tasks.enumerated()), id: \.offset) { index, task in
                SelectableListItem(
                    role: store.state.plan.role,
                    task: task,
                    isEditing: store.state.editMode,
                    onTap: { store.send(.selectPlan(index: index)) },
                    onTapDelete: { store.send(.deleteItem(index: index)) },
                    onTextChange: { store.send(.updateText(index: index, text: $0)) }
                )
                .focused($focusedIndex, equals: index) // Фокус для только что созданной задачи
                .onChange(of: store.state.focusedIndex) { newValue in
                    focusedIndex = newValue
                }
            }
        }

    }
    
    var screenHeader: some View {
        VStack {
            ScreenHeaderView(title: "Shoot Plan") {
                MainCircleButton(
                    color: .lzWhite,
                    activeColor: store.state.plan.role.tint,
                    image: .pencil,
                    isActive: store.state.editMode,
                    action: {
                        withAnimation(.bouncy(duration: 0.3)) {
                            store.send(.toggleEditingMode)
                        }
                    }
                )
                MainCircleButton(
                    color: .lzWhite,
                    image: .plus,
                    isDisabled: store.state.editMode,
                    action: { store.send(.addTask) }
                )
                .disabled(store.state.editMode)
            }
            EventRoleDescription(
                roleName: store.state.plan.role.name.uppercased(),
                date: store.state.plan.date
            )
            
        }
    }
    
    var actionButton: some View {
        MainButtonView(
            title: store.state.editMode ? "Delete Plan" : "Done",
            style: store.state.editMode ? .capsuleFill(.lzRaspberry) : .capsule(.lzWhite)
        ) {
            store.send(.tapActionButton)
        }
    }
}

#Preview {
    ShootPlanView(plan: .stub)
}
