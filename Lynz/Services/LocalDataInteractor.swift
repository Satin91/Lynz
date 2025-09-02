import Foundation

class LocalDataInteractor {
    
    // MARK: - Properties
    private let repository: LocalDataRepository
    
    init(repository: LocalDataRepository = LocalDataRepository()) {
        self.repository = repository
    }
    
    func savePlan(_ plan: Plan) throws {
        try repository.savePlan(plan)
    }
    
    func getAllPlans() throws -> [Plan] {
        try repository.getAllPlans()
    }
    
    func deletePlan(withId id: UUID) throws {
        try repository.deletePlan(withId: id)
    }
    
    func deleteAllPlans() throws {
        try repository.deleteAllPlans()
    }
}
