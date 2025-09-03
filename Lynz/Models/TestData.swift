import Foundation

// Простые тестовые данные для проверки
struct TestData {
    static func createTestPlan() -> Plan {
        let tasks = [
            TaskCategory(name: "Test Task 1", isActive: true),
            TaskCategory(name: "Test Task 2", isActive: false)
        ]
        return Plan(role: .photographer, date: Date(), tasks: tasks)
    }
    
    static func createTestPlans() -> [Plan] {
        let calendar = Calendar.current
        let today = Date()
        
        var plans: [Plan] = []
        
        // План на сегодня
        let todayPlan = Plan(
            role: .photographer,
            date: today,
            tasks: [
                TaskCategory(name: "Charge batteries", isActive: true),
                TaskCategory(name: "Check camera", isActive: false)
            ]
        )
        plans.append(todayPlan)
        
        // План на завтра
        if let tomorrow = calendar.date(byAdding: .day, value: 1, to: today) {
            let tomorrowPlan = Plan(
                role: .model,
                date: tomorrow,
                tasks: [
                    TaskCategory(name: "Prepare outfit", isActive: true),
                    TaskCategory(name: "Apply makeup", isActive: false)
                ]
            )
            plans.append(tomorrowPlan)
        }
        
        return plans
    }
}
