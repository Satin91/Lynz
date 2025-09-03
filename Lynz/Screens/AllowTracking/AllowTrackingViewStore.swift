//
//  AllowTrackingViewStore.swift
//  Lynz
//
//  Created by Артур Кулик on 03.09.2025.
//

import Foundation


struct AllowTrackingState {
    var isUserAgreedPermissions: Bool = false
}

enum AllowTrackingIntent {
    case showPermissions
    case toRootView
}

class AllowTrackingViewStore: ViewStore<AllowTrackingState, AllowTrackingIntent> {
    
    override func reduce(state: inout AllowTrackingState, intent: AllowTrackingIntent) -> Effect<AllowTrackingIntent> {
        
        switch intent {
        case .showPermissions:
            return .asyncTask {
                let status = await Executor.attService.requestPermissions()
                try! await Task.sleep(nanoseconds: 500_000_000) // чтобы была небольшая задержка для скрытия alert'a
                return .intent(.toRootView)
            }
            
        case .toRootView:
            // AppState так же как и Coordinator может переехать во ViewStore
            AppState.shared.setOnboardingShown(isShown: true)
            AppState.shared.setAppViewState(.main)
        }
        return .none
    }
}
