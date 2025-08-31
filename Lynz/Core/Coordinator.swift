//
//  Coordinator.swift
//  MVI_REDUX
//
//  Created by Артур Кулик on 15.08.2025.
//

import SwiftUI

enum Page: Hashable {
    case root
    case calendar
    case allowTrackingView
    case role(CalendarDay)
    case shootPlan(_ event: Event)
    
    static func == (lhs: Page, rhs: Page) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .root:
            hasher.combine(UUID())
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
    
    func popToRoot() {
        path.removeLast(path.count - 1)
    }
    
    @ViewBuilder func build(page: Page) -> some View {
        switch page {
        case .root:
            TabBarView()
        case .calendar:
            CalendarView()
        case .allowTrackingView:
            AllowTrackingView()
        case .role(let day):
            RoleView(day: day)
        case .shootPlan(let event):
            ShootPlanView(event: event)
        }
    }
}
