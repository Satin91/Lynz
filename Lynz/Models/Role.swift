//
//  Role.swift
//  Lynz
//
//  Created by Артур Кулик on 31.08.2025.
//

import SwiftUI

// MARK: - Domain Models

// Модель упрощенная, при большой нагрузке, если потребуется много свойств, можно ввести структуру RoleAttributes и объявить его свойством Role
enum Role: String, CaseIterable, Codable, Hashable {
    case photographer
    case model
    
    /// Локализованное название роли
    var name: String {
        switch self {
        case .photographer:
            return "Photographer"
        case .model:
            return "Model"
        }
    }
    
    // Фото, которое используется в RoleVIew
    var defaultPhoto: ImageResource {
        switch self {
        case .photographer:
            return .photographer
        case .model:
            return .model
        }
    }
    
    var tint: Color {
        switch self {
        case .photographer:
            return .lzBlue
        case .model:
            return .lzYellow
        }
    }
    
    var defaultPlansCategories: [TaskCategory] {
        return plansCategoriesString.map { TaskCategory(name: $0, isActive: false) }
    }
}
 
extension Role {
    private var plansCategoriesString: [String] {
        switch self {
        case .photographer:
            return [
                "Charge the batteries",
                "Clear memory cards",
                "Prepare the camera and lenses",
                "Check tripod and lighting equipment",
                "Choose angles and plan shots",
                "Align concept with the model",
                "Gather pose references",
                "Bring spare batteries and cleaning supplies"
            ]
        case .model:
            return [
                "Select outfit for the shoot",
                "Apply makeup and style hair",
                "Moisturize skin before the shoot",
                "Review pose references",
                "Bring makeup for touch-ups",
                "Prepare comfortable shoes",
                "Get enough sleep before the shoot",
                "Stay hydrated for a fresh look"
            ]
        }
    }
}

struct Plan: Codable, Hashable {
    let id: UUID
    let role: Role
    let date: Date
    var tasks: [TaskCategory]
    
    init(role: Role, date: Date, planCategories: [TaskCategory]) {
        self.id = UUID()
        self.role = role
        self.date = date
        self.tasks = planCategories
    }
    
    static var stub = Plan(role: .model, date: Date(), planCategories: Role.photographer.defaultPlansCategories)
}


