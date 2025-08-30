//
//  CalendarView.swift
//  Lynz
//
//  Created by Артур Кулик on 30.08.2025.
//

import SwiftUI

struct CalendarView: View {
    var body: some View {
        content
    }
    
    var content: some View {
        DatePickerView()
            .background(Color.gray.ignoresSafeArea(.all))
    }
}

#Preview {
    CalendarView()
}
