//
//  ShootPlanView.swift
//  Lynz
//
//  Created by Артур Кулик on 31.08.2025.
//

import SwiftUI

struct ShootPlanState {
    var event: Event
    var editMode: Bool = false
    var isShowConfirmationDialog = false
}

enum ShootPlanIntent {
    case selectPlan(index: Int)
    case updateText(index: Int, text: String)
    case toggleEditingMode
    case tapActionButton
    case confirmDelete(Bool)
    case showDialog(Bool)
}

final class ShootPlanViewStore: ViewStore<ShootPlanState, ShootPlanIntent> {
    
    override func reduce(state: inout ShootPlanState, intent: ShootPlanIntent) -> Effect<ShootPlanIntent> {
        switch intent {
        case .selectPlan(let index):
            state.event.planCategories[index].isActive.toggle()
        case .updateText(index: let index, text: let text):
            state.event.planCategories[index].name = text
        case .toggleEditingMode:
            state.editMode.toggle()
        case .tapActionButton:
            if state.editMode {
                return .action(.showDialog(true))
            } else {
                
                return .asyncTask {
                    // Save to local database
                    return .none
                }
            }
        case .confirmDelete(let isAccept):
            if isAccept {
                
            }
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
        switch store.state.event.role {
        case .photographer: Color.lzBlue.opacity(store.state.editMode ? 0.4 : 1)
        case .model: Color.lzYellow.opacity(store.state.editMode ? 0.3 : 1)
        }
    }
    
    private var radioButtonStrokeWidth: CGFloat {
        switch store.state.event.role {
        case .photographer: 1
        case .model: 1.4
        }
    }
    
    init(event: Event) {
        _store = StateObject(wrappedValue: ShootPlanViewStore(initialState: .init(event: event)))
    }
    
    var body: some View {
        content
            .navigationTitle(navTitle) // На случай если в будущем будет переход из этого экрана
            .navigationBarTitleDisplayMode(.inline)
            .hideInlineNavigationTitle()
            .background(BackgroundGradient().ignoresSafeArea(.all))
            .confirmationDialog(
                "Are you sure you want to delete the plan for this day?",
                isPresented: Binding(
                    get: { store.state.isShowConfirmationDialog },
                    set: { store.send(.showDialog($0)) }
                )
            ) {
                Button("Delete", role: .destructive) {
                    store.send(.confirmDelete(true))
                }
                Button("Cancel", role: .cancel) {
                    store.send(.showDialog(false))
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
        VStack {
            ForEach(Array(store.state.event.planCategories.enumerated()), id: \.offset) { index, category in
                
                SelectableListItem(
                    role: store.state.event.role,
                    category: category,
                    isEditing: store.state.editMode,
                    onTap: { store.send(.selectPlan(index: index)) },
                    onTextChange: { store.send(.updateText(index: index, text: $0)) }
                )
                .id(index)
            }
        }
    }
    
    var screenHeader: some View {
        VStack {
            ScreenHeaderView(title: "Shoot Plan") {
                HeaderButton(
                    color: store.state.event.role.tint,
                    image: .pencil,
                    isActive: store.state.editMode,
                    action: {
                        withAnimation(.bouncy(duration: 0.3)) {
                            store.send(.toggleEditingMode)
                        }
                    }
                )
                HeaderButton(
                    color: store.state.event.role.tint,
                    image: .plus,
                    action: { }
                )
            }
            EventRoleDescription(
                roleName: store.state.event.role.name.uppercased(),
                date: store.state.event.date
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
    ShootPlanView(event: .stub)
}
