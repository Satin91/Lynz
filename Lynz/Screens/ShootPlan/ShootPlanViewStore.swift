//
//  AllowTrackingViewStore.swift
//  Lynz
//
//  Created by Артур Кулик on 03.09.2025.
//

import Foundation


struct ShootPlanState {
    var plan: Plan
    var editMode: Bool = false
    var isShowConfirmationDialog = false
    var focusedIndex: Int? = nil
}

enum ShootPlanIntent {
    case selectPlan(index: Int)
    case updateText(index: Int, text: String)
    case toggleEditingMode
    case tapActionButton
    case addTask
    case savePlan
    case deleteItem(index: Int)
    case showDialog(Bool)
    case confirmPlanDelete
    case cancelPlanDelete
    case endTaskCreate
}

final class ShootPlanViewStore: ViewStore<ShootPlanState, ShootPlanIntent> {
    private let localDataInteractor = Executor.localDataInteractor
    
    override func reduce(state: inout ShootPlanState, intent: ShootPlanIntent) -> Effect<ShootPlanIntent> {
        switch intent {
        case .selectPlan(let index):
            state.plan.tasks[index].isActive.toggle()
            
        case .updateText(index: let index, text: let text):
            state.plan.tasks[index].name = text
            
        case .toggleEditingMode:
            state.editMode.toggle()
            state.focusedIndex = nil
            if !state.editMode { hideKeyboard() }
            return .intent(.endTaskCreate)
            
        case .tapActionButton:
            if state.editMode {
                return .intent(.showDialog(true))  // Показываем диалог для удаления события
            } else {
                return .intent(.savePlan)
            }
            
        case .addTask:
            let newTask = TaskCategory(name: "New Task", isActive: false)
            state.plan.tasks.append(newTask)
            state.focusedIndex = state.plan.tasks.count - 1
            
        case .endTaskCreate:
            state.focusedIndex = nil
            
        case .savePlan:
            let plan = state.plan
            do {
                try self.localDataInteractor.savePlan(plan)
                return .navigate(.popToRoot)
            } catch {
                print("DEBUG: error of save plan\(error.localizedDescription)")
            }
            
        case .deleteItem(let index):
            // Удаляем элемент сразу без диалога
            if index < state.plan.tasks.count {
                state.plan.tasks.remove(at: index)
            }
            
        case .confirmPlanDelete:
            do {
                try localDataInteractor.deletePlan(withId: state.plan.id)
                state.isShowConfirmationDialog = false
                
            } catch {
                print("DEBUG: cant do this operation \(error.localizedDescription)")
                state.isShowConfirmationDialog = false
            }
            return .navigate(.popToRoot)
            
        case .cancelPlanDelete:
            // Отменяем удаление события
            return .intent(.showDialog(false))
            
        case .showDialog(let isShow):
            state.isShowConfirmationDialog = isShow
        }
        
        
        return .none
    }
    
    private func hideKeyboard() {
        resignFirstResponder() // Глобальная функция,
    }
}
