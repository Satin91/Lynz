//
//  ShootPlanView.swift
//  Lynz
//
//  Created by Артур Кулик on 31.08.2025.
//

import SwiftUI

struct ShootPlanState {
    var plan: Plan
    var editMode: Bool = false
    var isShowConfirmationDialog = false
}

enum ShootPlanIntent {
    case selectPlan(index: Int)
    case updateText(index: Int, text: String)
    case toggleEditingMode
    case tapActionButton
    case deleteItem(index: Int)           // Удаление отдельного элемента
    case deletePlan                      // Удаление всего события
    case confirmEventDelete               // Подтверждение удаления события
    case cancelEventDelete                // Отмена удаления события
    case showDialog(Bool)
}

final class ShootPlanViewStore: ViewStore<ShootPlanState, ShootPlanIntent> {
    
    override func reduce(state: inout ShootPlanState, intent: ShootPlanIntent) -> Effect<ShootPlanIntent> {
        switch intent {
        case .selectPlan(let index):
            state.plan.tasks[index].isActive.toggle()
            
        case .updateText(index: let index, text: let text):
            state.plan.tasks[index].name = text
            
        case .toggleEditingMode:
            state.editMode.toggle()
            
        case .tapActionButton:
            if state.editMode {
                return .action(.showDialog(true))  // Показываем диалог для удаления события
            } else {
                return .asyncTask {
                    // Save to local database
                    return .none
                }
            }
            
        case .deleteItem(let index):
            // Удаляем элемент сразу без диалога
            if index < state.plan.tasks.count {
                state.plan.tasks.remove(at: index)
            }
            
        case .deletePlan:
            // Показываем диалог для подтверждения удаления события
            return .action(.showDialog(true))
            
        case .confirmEventDelete:
            // Remove Event from
            popToRoot()
            return .action(.showDialog(false))
            
        case .cancelEventDelete:
            // Отменяем удаление события
            return .action(.showDialog(false))
            
        case .showDialog(let isShow):
            state.isShowConfirmationDialog = isShow
        }
        
        return .none
    }
}

struct ShootPlanView: View {
    @StateObject var store: ShootPlanViewStore
    private let navTitle = "Shoot Plan"
    
    
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
            .navigationTitle(navTitle) // На случай если в будущем будет переход из этого экрана
            .navigationBarTitleDisplayMode(.inline)
            .hideInlineNavigationTitle()
            .background(BackgroundGradient().ignoresSafeArea(.all))
            .confirmationDialog(
                "Are you sure you want to delete the plan for this day? ",
                isPresented: Binding(
                    get: { store.state.isShowConfirmationDialog },
                    set: { store.send(.showDialog($0)) }
                )
            ) {
                Button("Delete Event", role: .destructive) {
                    store.send(.confirmEventDelete)
                }
                Button("Cancel", role: .cancel) {
                    store.send(.cancelEventDelete)
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
            ForEach(Array(store.state.plan.tasks.enumerated()), id: \.element) { index, task in
                SelectableListItem(
                    role: store.state.plan.role,
                    task: task,
                    isEditing: store.state.editMode,
                    onTap: { store.send(.selectPlan(index: index)) },
                    onTapDelete: { store.send(.deleteItem(index: index)) },  // Удаление сразу
                    onTextChange: { store.send(.updateText(index: index, text: $0)) }
                )
            }
        }
    }
    
    var screenHeader: some View {
        VStack {
            ScreenHeaderView(title: "Shoot Plan") {
                HeaderButton(
                    color: store.state.plan.role.tint,
                    image: .pencil,
                    isActive: store.state.editMode,
                    action: {
                        withAnimation(.bouncy(duration: 0.3)) {
                            store.send(.toggleEditingMode)
                        }
                    }
                )
                HeaderButton(
                    color: store.state.plan.role.tint,
                    image: .plus,
                    action: { }
                )
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
            style: store.state.editMode ? .capsuleFill(.lzAccent) : .capsule(.lzWhite)
        ) {
            
            store.send(.tapActionButton)
        }
    }
}

#Preview {
    ShootPlanView(plan: .stub)
}
