//
//  PermissionInteractor.swift
//  Lynz
//
//  Created by Артур Кулик on 02.09.2025.
//

import Foundation
import AppTrackingTransparency
import UserNotifications

class PermissionInteractor {
    
    private let attService: ATTService
    private let notificationService: NotificationService
    
    init(attService: ATTService, notificationService: NotificationService) {
        self.attService = attService
        self.notificationService = notificationService
    }
    
    func requestATTPermissions() async -> ATTrackingManager.AuthorizationStatus {
        return await attService.requestPermissions()
    }
    
    func requestNotificationPermissions() async -> UNAuthorizationStatus {
        return await notificationService.requestPermissions()
    }
}
