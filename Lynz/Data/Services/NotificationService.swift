//
//  NotificationService.swift
//  Lynz
//
//  Created by Артур Кулик on 02.09.2025.
//

import Foundation
import UserNotifications

class NotificationService {
    
    func requestPermissions() async -> UNAuthorizationStatus {
        let center = UNUserNotificationCenter.current()
        let granted = try? await center.requestAuthorization(options: [.alert, .badge, .sound])
        return granted == true ? .authorized : .denied
    }
    
    func callPermissionInteractor(_ interactor: PermissionInteractor) {
        Task {
            await interactor.requestNotificationPermissions()
        }
    }
}
