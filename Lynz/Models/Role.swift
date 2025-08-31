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
    var planCategories: [PlanCategory]
    
    init(role: Role, date: Date, planCategories: [PlanCategory]) {
        self.id = UUID()
        self.role = role
        self.date = date
        self.planCategories = planCategories
    }
    
    static var stub = Event(role: .model, date: Date(), planCategories: Role.photographer.defaultPlansCategories)
}

struct PlanCategory: Codable, Hashable {
    var name: String
    var isActive: Bool
}


// MARK: - Mock Data for Testing
extension Event {
    /// Моковые данные для тестирования календаря
    static var mockEvents: [Event] {
        let calendar = Calendar.current
        let today = Date()
        
        // События на сегодня
        let todayEvent1 = Event(
            role: .photographer,
            date: today,
            planCategories: Role.photographer.defaultPlansCategories
        )
        
        let todayEvent2 = Event(
            role: .model,
            date: today,
            planCategories: Role.model.defaultPlansCategories
        )
        
        // События на завтра
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: today) ?? today
        let tomorrowEvent = Event(
            role: .photographer,
            date: tomorrow,
            planCategories: Role.photographer.defaultPlansCategories
        )
        
        // События на послезавтра
        let dayAfterTomorrow = calendar.date(byAdding: .day, value: 2, to: today) ?? today
        let dayAfterTomorrowEvent = Event(
            role: .model,
            date: dayAfterTomorrow,
            planCategories: Role.model.defaultPlansCategories
        )
        
        // События на прошлую неделю
        let lastWeek = calendar.date(byAdding: .day, value: -7, to: today) ?? today
        let lastWeekEvent = Event(
            role: .photographer,
            date: lastWeek,
            planCategories: Role.photographer.defaultPlansCategories
        )
        
        // События на следующую неделю
        let nextWeek = calendar.date(byAdding: .day, value: 7, to: today) ?? today
        let nextWeekEvent = Event(
            role: .model,
            date: nextWeek,
            planCategories: Role.model.defaultPlansCategories
        )
        
        // События на разные дни текущего месяца
        let currentMonthDay15 = calendar.date(bySetting: .day, value: 15, of: today) ?? today
        let currentMonthEvent = Event(
            role: .photographer,
            date: currentMonthDay15,
            planCategories: Role.photographer.defaultPlansCategories
        )
        
        let currentMonthDay20 = calendar.date(bySetting: .day, value: 20, of: today) ?? today
        let currentMonthEvent2 = Event(
            role: .model,
            date: currentMonthDay20,
            planCategories: Role.model.defaultPlansCategories
        )
        
        return [
            todayEvent1,
            todayEvent2,
            tomorrowEvent,
            dayAfterTomorrowEvent,
            lastWeekEvent,
            nextWeekEvent,
            currentMonthEvent,
            currentMonthEvent2
        ]
    }
    
    /// Создает случайное событие для тестирования
    static func randomEvent(for date: Date) -> Event {
        let randomRole: Role = Bool.random() ? .photographer : .model
        let planCategories = randomRole.defaultPlansCategories
        
        return Event(
            role: randomRole,
            date: date,
            planCategories: planCategories
        )
    }
    
    /// Создает несколько случайных событий для указанного месяца
    static func randomEventsForMonth(_ date: Date, count: Int = 5) -> [Event] {
        let calendar = Calendar.current
        guard let monthInterval = calendar.dateInterval(of: .month, for: date) else {
            return []
        }
        
        var events: [Event] = []
        let randomDays = (1...28).shuffled().prefix(count)
        
        for day in randomDays {
            if let eventDate = calendar.date(bySetting: .day, value: day, of: date) {
                events.append(randomEvent(for: eventDate))
            }
        }
        
        return events
    }
}
