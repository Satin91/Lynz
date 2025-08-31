//
//  EventRoleDescription.swift
//  Lynz
//
//  Created by Артур Кулик on 31.08.2025.
//

import SwiftUI

struct EventRoleDescription: View {
    var roleName: String? = nil
    let date: Date
    
    
    var body: some View {
        HStack {
            Text(date.dayMonthYearDots)
            Spacer()
            if let roleName {
                Text(roleName.uppercased())
            }
        }
        .font(.lzAccent)
        .foregroundStyle(.lzWhite)
        .opacity(0.3)
    }
}

#Preview {
    EventRoleDescription(roleName: "asd", date: Date())
        .background(Color.gray)
}
