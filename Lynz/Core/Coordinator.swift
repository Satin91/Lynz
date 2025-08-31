//
//  Coordinator.swift
//  MVI_REDUX
//
//  Created by Артур Кулик on 15.08.2025.
//

import SwiftUI

enum Page: Hashable {
    case calendar
    case allowTrackingView
    case role(CalendarDay)
    case shootPlan(_ role: Role)
    
    static func == (lhs: Page, rhs: Page) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .calendar:
            hasher.combine(UUID())
        case .allowTrackingView:
            hasher.combine(UUID())
        case .role:
            hasher.combine(UUID())
        case .shootPlan(_):
            hasher.combine(UUID())
        }
    }
}

final class Coordinator: ObservableObject {
    @Published var path = NavigationPath()
    static let shared = Coordinator()
    

    func push(page: Page) {
        path.append(page)
    }
    
    func pop() {
        path.removeLast()
    }
    
    @ViewBuilder func build(page: Page) -> some View {
        switch page {
        case .calendar:
            CalendarView()
        case .allowTrackingView:
            AllowTrackingView()
        case .role(let day):
            RoleView(day: day)
        case .shootPlan(let role):
            ShootPlanView(role: role)
        }
    }
}
