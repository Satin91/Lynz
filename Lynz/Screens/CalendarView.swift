//
//  CalendarView.swift
//  Lynz
//
//  Created by Артур Кулик on 30.08.2025.
//

import SwiftUI

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

struct CalendarView: View {
    @StateObject var store = CalendarViewStore(initialState: .init())
    
    var body: some View {
        content
            .preferredColorScheme(.dark)
    }
    
    var content: some View {
        DatePickerView(plans: store.state.plans) { day in
            store.send(.tapCalendar(day: day))
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .background(BackgroundGradient().ignoresSafeArea(.all))
        .onAppear {
            store.send(.loadPlans)
        }
    }
}



#Preview {
    CalendarView()
}
