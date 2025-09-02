//
//  LocalDataRepository.swift
//  Lynz
//
//  Created by Артур Кулик on 31.08.2025.
//

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
    
    /// Сохраняет план в локальное хранилище, создаёт, если плана нет, обновляет если есть
    func savePlan(_ plan: Plan) throws {
        if try getPlan(withId: plan.id) != nil {
            try coreDataService.update(plan, withId: plan.id.uuidString)
        } else {
            try coreDataService.create(plan, withId: plan.id.uuidString, type: "Plan")
        }
    }
    
    
    func getAllPlans() throws -> [Plan] {
        return try coreDataService.fetchAll(Plan.self, ofType: "Plan")
    }
    
    func deletePlan(withId id: UUID) throws {
        // Получаем план перед удалением, чтобы знать его TaskCategory
        guard let plan = try getPlan(withId: id) else {
            throw RepositoryError.planNotFound
        }
        
        try coreDataService.delete(withId: id.uuidString)
        
        for task in plan.tasks {
            let taskId = "\(id.uuidString)_\(task.name)"
            try? coreDataService.delete(withId: taskId)
        }
    }
    
    
    private func getPlan(withId id: UUID) throws -> Plan? {
        return try coreDataService.fetch(Plan.self, withId: id.uuidString)
    }
    
    func deleteAllPlans() throws {
        try coreDataService.deleteAll(ofType: "Plan")
        try coreDataService.deleteAll(ofType: "TaskCategory")
    }
}

enum RepositoryError: Error, LocalizedError {
    case planNotFound
    
    var errorDescription: String? {
        switch self {
        case .planNotFound:
            return "Plan not found"
        }
    }
}
