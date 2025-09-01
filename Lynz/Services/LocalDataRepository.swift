import Foundation
import CoreData

// MARK: - Local Data Repository
class LocalDataRepository {
    
    // MARK: - Properties
    private let coreDataService: CoreDataService
    
    init(coreDataService: CoreDataService = CoreDataService.shared) {
        self.coreDataService = coreDataService
    }
    
    // MARK: - Plan Operations
    
    /// Сохраняет план в локальное хранилище
    func savePlan(_ plan: Plan) throws {
        try coreDataService.create(plan, withId: plan.id.uuidString, type: "Plan")
    }
    
    /// Получает все планы
    func getAllPlans() throws -> [Plan] {
        return try coreDataService.fetchAll(Plan.self, ofType: "Plan")
    }
    
    /// Удаляет план по ID (вместе с его TaskCategory)
    func deletePlan(withId id: UUID) throws {
        // Получаем план перед удалением, чтобы знать его TaskCategory
        guard let plan = try getPlan(withId: id) else {
            throw RepositoryError.planNotFound
        }
        
        // Удаляем план
        try coreDataService.delete(withId: id.uuidString)
        
        // Удаляем все TaskCategory этого плана
        for task in plan.tasks {
            let taskId = "\(id.uuidString)_\(task.name)"
            try? coreDataService.delete(withId: taskId)
        }
    }
    
    /// Получает план по ID (внутренний метод для deletePlan)
    private func getPlan(withId id: UUID) throws -> Plan? {
        return try coreDataService.fetch(Plan.self, withId: id.uuidString)
    }
    
    /// Удаляет все планы
    func deleteAllPlans() throws {
        try coreDataService.deleteAll(ofType: "Plan")
        try coreDataService.deleteAll(ofType: "TaskCategory")
    }
}

// MARK: - Repository Errors
enum RepositoryError: Error, LocalizedError {
    case planNotFound
    
    var errorDescription: String? {
        switch self {
        case .planNotFound:
            return "План не найден"
        }
    }
}
