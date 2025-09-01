//
//  Plan.swift
//  Lynz
//
//  Created by Артур Кулик on 01.09.2025.
//

import Foundation

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



// MARK: - Mock Data for Testing
extension Plan {
    /// Моковые данные для тестирования календаря
    static var mockEvents: [Plan] {
        let calendar = Calendar.current
        let today = Date()
        
        // События на сегодня
        let todayEvent1 = Plan(
            role: .photographer,
            date: today,
            planCategories: Role.photographer.defaultPlansCategories
        )
        
        let todayEvent2 = Plan(
            role: .model,
            date: today,
            planCategories: Role.model.defaultPlansCategories
        )
        
        // События на завтра
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: today) ?? today
        let tomorrowEvent = Plan(
            role: .photographer,
            date: tomorrow,
            planCategories: Role.photographer.defaultPlansCategories
        )
        
        // События на послезавтра
        let dayAfterTomorrow = calendar.date(byAdding: .day, value: 2, to: today) ?? today
        let dayAfterTomorrowEvent = Plan(
            role: .model,
            date: dayAfterTomorrow,
            planCategories: Role.model.defaultPlansCategories
        )
        
        // События на прошлую неделю
        let lastWeek = calendar.date(byAdding: .day, value: -7, to: today) ?? today
        let lastWeekEvent = Plan(
            role: .photographer,
            date: lastWeek,
            planCategories: Role.photographer.defaultPlansCategories
        )
        
        // События на следующую неделю
        let nextWeek = calendar.date(byAdding: .day, value: 7, to: today) ?? today
        let nextWeekEvent = Plan(
            role: .model,
            date: nextWeek,
            planCategories: Role.model.defaultPlansCategories
        )
        
        // События на разные дни текущего месяца
        let currentMonthDay15 = calendar.date(bySetting: .day, value: 15, of: today) ?? today
        let currentMonthEvent = Plan(
            role: .photographer,
            date: currentMonthDay15,
            planCategories: Role.photographer.defaultPlansCategories
        )
        
        let currentMonthDay20 = calendar.date(bySetting: .day, value: 20, of: today) ?? today
        let currentMonthEvent2 = Plan(
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
    static func randomEvent(for date: Date) -> Plan {
        let randomRole: Role = Bool.random() ? .photographer : .model
        let planCategories = randomRole.defaultPlansCategories
        
        return Plan(
            role: randomRole,
            date: date,
            planCategories: planCategories
        )
    }
    
    /// Создает несколько случайных событий для указанного месяца
    static func randomEventsForMonth(_ date: Date, count: Int = 5) -> [Plan] {
        let calendar = Calendar.current
        guard let monthInterval = calendar.dateInterval(of: .month, for: date) else {
            return []
        }
        
        var events: [Plan] = []
        let randomDays = (1...28).shuffled().prefix(count)
        
        for day in randomDays {
            if let eventDate = calendar.date(bySetting: .day, value: day, of: date) {
                events.append(randomEvent(for: eventDate))
            }
        }
        
        return events
    }
}
