//
//  Coordinator.swift
//  MVI_REDUX
//
//  Created by Артур Кулик on 15.08.2025.
//

import SwiftUI

enum Page: Hashable, Identifiable {
    
    case root
    case calendar
    case allowTrackingView
    case role(CalendarDay)
    case shootPlan(_ plan: Plan)
    case poseLibrary(pose: PoseCategory)
    case settings
    
    var id: String {
        switch self {
        case .root:
            return "root"
        case .calendar:
            return "calendar"
        case .allowTrackingView:
            return "allowTrackingView"
        case .role(let day):
            return "role_\(day.id)"
        case .shootPlan(let plan):
            return "shootPlan_\(plan.id)"
        case .poseLibrary(let pose):
            return "poseLibrary_\(pose.id)"
        case .settings:
            return "settings"
        }
    }
    
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
        case .poseLibrary:
            hasher.combine(UUID())
        case .shootPlan(_):
            hasher.combine(UUID())
        case .settings:
            hasher.combine(UUID())
        }
    }
}

final class Coordinator: ObservableObject {
    @Published var path = NavigationPath()
    @Published var presentedPage: Page? = nil
    static let shared = Coordinator()

    func push(page: Page) {
        path.append(page)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    func fullScreenCover(page: Page) {
        presentedPage = page
    }
    
    func dismissFullScreenCover() {
        presentedPage = nil
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
            ShootPlanView(plan: event)
        case .poseLibrary(pose: let pose):
            PoseLibraryView(pose: pose)
        case .settings:
            SettingsView()
        }
    }
}
