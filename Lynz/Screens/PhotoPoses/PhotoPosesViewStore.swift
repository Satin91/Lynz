//
//  AllowTrackingViewStore.swift
//  Lynz
//
//  Created by Артур Кулик on 03.09.2025.
//

import Foundation

struct PosesState {
    
}

enum PosesIntent {
    case tapPose(category: Pose)
    case tapSettings
}

final class PosesViewStore: ViewStore<PosesState, PosesIntent> {
    
    override func reduce(state: inout PosesState, intent: PosesIntent) -> Effect<PosesIntent> {
        switch intent {
        case .tapPose(let category):
            return .navigate(.push(.poseLibrary(pose: category)))
        case .tapSettings:
            return .navigate(.fullScreenCover(.settings))
        }
    }
}
