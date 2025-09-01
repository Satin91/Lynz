import Foundation

// MARK: - Local Data Interactor
class LocalDataInteractor {
    
    // MARK: - Properties
    private let repository: LocalDataRepository
    
    init(repository: LocalDataRepository = LocalDataRepository()) {
        self.repository = repository
    }
    
    // MARK: - Plan Operations
    
    /// Сохраняет план
    func savePlan(_ plan: Plan) throws {
        try repository.savePlan(plan)
    }
    
    /// Получает все планы
    func getAllPlans() throws -> [Plan] {
        try repository.getAllPlans()
    }
    
    /// Удаляет план
    func deletePlan(withId id: UUID) throws {
        try repository.deletePlan(withId: id)
    }
    
    /// Удаляет все планы
    func deleteAllPlans() throws {
        try repository.deleteAllPlans()
    }
}
