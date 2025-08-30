//
//  TrackingPermissionService.swift
//  Lynz
//
//  Created by Артур Кулик on 29.08.2025.
//

import Foundation
import AppTrackingTransparency

/// Using AppTrackingTransparency
class ATTService {
    func requestPermissions() async -> ATTrackingManager.AuthorizationStatus {
        let authStatus = await ATTrackingManager.requestTrackingAuthorization()
        return authStatus
    }
}
