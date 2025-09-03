//
//  CalendarView.swift
//  Lynz
//
//  Created by Артур Кулик on 30.08.2025.
//

import SwiftUI


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
