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
//    init(role: Event) {
//        self.role = role
//    }
}

enum ShootPlanIntent {
    case selectPlan(index: Int)
    case toggleEditingMode
    case tapActionButton
}

final class ShootPlanViewStore: ViewStore<ShootPlanState, ShootPlanIntent> {
    
    override func reduce(state: inout ShootPlanState, intent: ShootPlanIntent) -> Effect<ShootPlanIntent> {
        switch intent {
        case .selectPlan(let index):
            state.event.planCategories[index].isActive.toggle()
        case .toggleEditingMode:
            state.editMode.toggle()
        case .tapActionButton:
            if state.editMode {
                state.isShowConfirmationDialog.toggle()
            } else {
                return .asyncTask {
                    // Save to local database
                    return .none
                }
            }
        }
        
        return .none
    }
}

struct ShootPlanView: View {
    @StateObject var store: ShootPlanViewStore
    private let navTitle = "Shoot Plan"
//    @State var editMode: Bool = false
    
    
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
            .confirmationDialog("", isPresented: .constant(false)) {
                
            }
    }
    
    
    var content: some View {
        VStack {
            screenHeader
                .padding(.top, .medium)
            planList
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .padding(.horizontal, .mediumExt)
    }
    
    var planList: some View {
        VStack {
            ForEach(Array(store.state.event.planCategories.enumerated()), id: \.offset) { index, category in
                SelectableListItem(
                    text: category.name,
                    radioButtonColor: radioButtonColor,
                    radioButtonStrokeWidth: radioButtonStrokeWidth,
                    isEditing: store.state.editMode,
                    isSelected: category.isActive
                ) {
                    store.send(.selectPlan(index: index))
                }
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
                        withAnimation(.bouncy(duration: 0.2)) {
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
            style: store.state.editMode ? .roundedFill(.lzAccent) : .capsule(.lzWhite)
        ) {
            
        }
    }
}

#Preview {
    ShootPlanView(event: .stub)
}
