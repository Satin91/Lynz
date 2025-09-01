import Foundation
import CoreData
import Combine

@MainActor
class LocalDataInteractor: ObservableObject {
    private let repository: DataRepository
    
    init(repository: DataRepository) {
        self.repository = repository
    }
    
    // MARK: - Plans Operations (Business Logic)
    
    func savePlan(_ plan: Plan) throws {
        try repository.save(plan)
    }
    
    func deletePlan(_ plan: Plan) throws {
        try repository.delete(plan)
    }
    
    func updatePlan(_ plan: Plan) throws {
        try repository.update(plan)
    }
    
    func fetchPlans(for date: Date? = nil) throws -> [Plan] {
        var predicate: NSPredicate?
        
        if let date = date {
            let calendar = Calendar.current
            let startOfDay = calendar.startOfDay(for: date)
            let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) ?? startOfDay
            
            predicate = NSPredicate(format: "date >= %@ AND date < %@", startOfDay as NSDate, endOfDay as NSDate)
        }
        
        let sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        return try repository.fetch(Plan.self, predicate: predicate, sortDescriptors: sortDescriptors)
    }
    
    func fetchPlans(for role: Role, in dateRange: DateInterval? = nil) throws -> [Plan] {
        var predicates: [NSPredicate] = []
        predicates.append(NSPredicate(format: "role == %@", role.rawValue))
        
        if let dateRange = dateRange {
            predicates.append(NSPredicate(format: "date >= %@ AND date <= %@", dateRange.start as NSDate, dateRange.end as NSDate))
        }
        
        let predicate = predicates.count > 1 ? NSCompoundPredicate(andPredicateWithSubpredicates: predicates) : predicates.first
        let sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        
        return try repository.fetch(Plan.self, predicate: predicate, sortDescriptors: sortDescriptors)
    }
    
    func searchPlans(query: String) throws -> [Plan] {
        let predicate: NSPredicate?
        
        if !query.isEmpty {
            predicate = NSPredicate(format: "role CONTAINS[cd] %@ OR ANY tasks.name CONTAINS[cd] %@", query, query)
        } else {
            predicate = nil
        }
        
        let sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        return try repository.fetch(Plan.self, predicate: predicate, sortDescriptors: sortDescriptors)
    }
    
    func getPlansCount(for role: Role, in dateRange: DateInterval? = nil) throws -> Int {
        let plans = try fetchPlans(for: role, in: dateRange)
        return plans.count
    }
    
    func getUpcomingPlans(limit: Int = 10) throws -> [Plan] {
        let predicate = NSPredicate(format: "date >= %@", Date() as NSDate)
        let sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        
        var plans = try repository.fetch(Plan.self, predicate: predicate, sortDescriptors: sortDescriptors)
        
        // Применяем лимит
        if plans.count > limit {
            plans = Array(plans.prefix(limit))
        }
        
        return plans
    }
    
    // MARK: - Generic Operations
    
    func save<T: Codable & Identifiable>(_ item: T) throws {
        try repository.save(item)
    }
    
    func delete<T: Codable & Identifiable>(_ item: T) throws {
        try repository.delete(item)
    }
    
    func update<T: Codable & Identifiable>(_ item: T) throws {
        try repository.update(item)
    }
    
    func fetch<T: Codable & Identifiable>(_ type: T.Type) throws -> [T] {
        return try repository.fetch(type, predicate: nil, sortDescriptors: nil)
    }
}
