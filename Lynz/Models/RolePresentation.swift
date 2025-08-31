//
//  RolePresentation.swift
//  Lynz
//
//  Created by Артур Кулик on 31.08.2025.
//

import SwiftUI

// MARK: - Configuration-based Presentation

/// Конфигурация UI для роли
struct RoleUIConfig {
    let image: ImageResource
    let themeColor: Color
    let accentColor: Color?
    
    init(image: ImageResource, themeColor: Color, accentColor: Color? = nil) {
        self.image = image
        self.themeColor = themeColor
        self.accentColor = accentColor
    }
}

/// Презентационная модель для отображения роли в UI
struct RolePresentation {
    let role: Role
    
    // MARK: - Configuration Dictionary
    private static let configurations: [Role: RoleUIConfig] = [
        .photographer: RoleUIConfig(
            image: .photographer,
            themeColor: .lzBlue,
            accentColor: .lzWhite
        ),
        .model: RoleUIConfig(
            image: .model,
            themeColor: .lzYellow,
            accentColor: .lzBlack
        )
    ]
    
    init(_ role: Role) {
        self.role = role
    }
    
    // MARK: - Computed Properties (No Switch!)
    
    /// Конфигурация UI для роли
    private var config: RoleUIConfig {
        return Self.configurations[role] ?? RoleUIConfig(
            image: .photographer, // fallback
            themeColor: .gray
        )
    }
    
    /// Изображение для роли
    var image: ImageResource {
        return config.image
    }
    
    /// Цвет темы для роли
    var themeColor: Color {
        return config.themeColor
    }
    
    /// Акцентный цвет (для текста, иконок)
    var accentColor: Color {
        return config.accentColor ?? .primary
    }
    
    /// Отображаемое имя
    var displayName: String {
        return role.name
    }
    
    /// Текст для кнопки выбора роли
    var selectionText: String {
        return "I'm a " + role.name.capitalized
    }
}

// MARK: - Convenience Extensions

extension Role {
    /// Создает презентационную модель
    var presentation: RolePresentation {
        return RolePresentation(self)
    }
}

extension Array where Element == Role {
    /// Создает массив презентационных моделей
    var presentations: [RolePresentation] {
        return map { $0.presentation }
    }
}

