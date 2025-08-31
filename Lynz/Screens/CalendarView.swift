//
//  CalendarView.swift
//  Lynz
//
//  Created by Артур Кулик on 30.08.2025.
//

import SwiftUI

struct CalendarView: View {
    
//    @EnvironmentObject var coordinator: Coordinator
    
    var body: some View {
        content
//            .navigationTitle("Calendar")
            .preferredColorScheme(.dark)
    }
    
    var content: some View {
        DatePickerView() { day in
            Coordinator.shared.push(page: .role(CalendarDay(day: 0, isCurrentMonth: true, date: Date()) ))
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .background(Color.gray)
        
    }
}



#Preview {
    CalendarView()
}
