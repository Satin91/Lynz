//
//  AllowTrackingViewStore.swift
//  Lynz
//
//  Created by Артур Кулик on 03.09.2025.
//

import Foundation


struct RoleState {
    var day: CalendarDay
    
}

enum RoleIntent {
    case tapRole(role: Role)
}

final class RoleViewStore: ViewStore<RoleState, RoleIntent> {
    
    override func reduce(state: inout RoleState, intent: RoleIntent) -> Effect<RoleIntent> {
        
        switch intent {
        case .tapRole(let role):
            let newEvent = Plan(role: role, date: state.day.date, planCategories: role.defaultPlansCategories)
            return .navigate(.push(.shootPlan(newEvent)))
        }
    }
}
