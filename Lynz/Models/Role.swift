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
    
    var defaultPlansCategories: [PlanCategory] {
        return plansCategoriesString.map { PlanCategory(name: $0, isActive: false) }
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

/// Модель события с ролью
struct Event: Codable, Hashable {
    let id: UUID
    let role: Role
    let date: Date
    let planCategories: [PlanCategory]
    
    init(role: Role, date: Date, planCategories: [PlanCategory] = []) {
        self.id = UUID()
        self.role = role
        self.date = date
        self.planCategories = planCategories
    }
}

struct PlanCategory: Codable, Hashable {
    var name: String
    var isActive: Bool
}

///// Категории планов для события
//enum PlanCategory: String, CaseIterable, Codable {
//    case applyMakeupAndStyleHair
//    case selectOutfitForShoot
//    case prepareEquipment
//    case scoutLocation
//
//    var name: String {
//        switch self {
//        case .applyMakeupAndStyleHair:
//            return "Apply makeup and style hair"
//        case .selectOutfitForShoot:
//            return "Select outfit for the shoot"
//        case .prepareEquipment:
//            return "Prepare equipment"
//        case .scoutLocation:
//            return "plan.scout_location"
//        }
//    }
//}
