//
//  AppState.swift
//  Lynz
//
//  Created by Артур Кулик on 30.08.2025.
//

import Foundation
import SwiftUI

/// Объект который хранит состояния приложения: тему, количество запусков и др.
class AppState: ObservableObject {
    
    static let shared = AppState()
    @Published private(set) var isOnboardingShown = false
    @Published private(set) var viewState: AppViewState = .onboarding
    
    enum AppViewState {
        case splash
        case onboarding
        case main
    }
    
    private init() { }
    
    func setOnboardingShown(isShown: Bool) {
        isOnboardingShown = isShown
    }
    
    func setAppViewState(_ state: AppViewState) {
        withAnimation(.easeInOut(duration: 0.2)) {
            self.viewState = state
        }
    }
}
