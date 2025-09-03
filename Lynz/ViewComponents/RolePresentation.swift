//
//  RolePresentation.swift
//  Lynz
//
//  Created by Артур Кулик on 31.08.2025.
//

import SwiftUI

// MARK: - Role UI Properties

struct RoleUI {
    let role: Role
    
    init(_ role: Role) {
        self.role = role
    }
    
    /// Картинка для роли
    var image: ImageResource {
        switch role {
        case .photographer:
            return .photographer
        case .model:
            return .model
        }
    }
    
    /// Цвет для роли
    var color: Color {
        switch role {
        case .photographer:
            return .lzBlue
        case .model:
            return .lzYellow
        }
    }
    
    /// Список планов для роли
    var plans: [String] {
        switch role {
        case .photographer:
            return [
                "Prepare equipment",
                "Scout location", 
                "Set up lighting",
                "Check camera settings"
            ]
        case .model:
            return [
                "Apply makeup and style hair",
                "Select outfit for the shoot",
                "Practice poses",
                "Prepare accessories"
            ]
        }
    }
}

// MARK: - Role Extension

extension Role {
    /// Доступ к UI свойствам через точку
    var ui: RoleUI {
        return RoleUI(self)
    }
}
