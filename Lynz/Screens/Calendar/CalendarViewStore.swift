//
//  AllowTrackingViewStore.swift
//  Lynz
//
//  Created by Артур Кулик on 03.09.2025.
//

import Foundation

struct CalendarState {
    var plans: [Plan] = []
}

enum CalendarIntent {
    case tapCalendar(day: CalendarDay)
    case loadPlans
}

final class CalendarViewStore: ViewStore<CalendarState, CalendarIntent> {
    private let localDataInteractor = Executor.localDataInteractor
    
    override func reduce(state: inout CalendarState, intent: CalendarIntent) -> Effect<CalendarIntent> {
        
        switch intent {
        case .tapCalendar(let day):
            if let plan = day.plan {
                return .navigate(.push(.shootPlan(plan)))
            } else {
                return .navigate(.push(.role(day)))
            }
            
        case .loadPlans:
            do {
                let plans = try localDataInteractor.getAllPlans()
                state.plans = plans
            } catch {
                print("ERROR OF LOAD PLANS \(error.localizedDescription)")
            }
        }
        
        return .none
    }
}
