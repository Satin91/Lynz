//
//  CalendarView.swift
//  Lynz
//
//  Created by Артур Кулик on 30.08.2025.
//

import SwiftUI

struct CalendarState {
    
}

enum CalendarIntent {
    case tapCalendar(day: CalendarDay)
}

final class CalendarViewStore: ViewStore<CalendarState, CalendarIntent> {
    
    
    override func reduce(state: inout CalendarState, intent: CalendarIntent) -> Effect<CalendarIntent> {
        
        switch intent {
        case .tapCalendar(let day):
            push(.role(day))
        }
        
        return .none
    }
}

struct CalendarView: View {
    
//    @EnvironmentObject var coordinator: Coordinator
    
    @StateObject var store = CalendarViewStore(initialState: .init())
    
    var body: some View {
        content
            .preferredColorScheme(.dark)
    }
    
    var content: some View {
        DatePickerView() { day in
            store.send(.tapCalendar(day: day))
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .background(Color.gray)
        
    }
}



#Preview {
    CalendarView()
}
