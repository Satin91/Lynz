import Foundation
import CoreData
import Combine

@MainActor
class DataRepository: ObservableObject {
    private let coreDataService: CoreDataService
    private let entityMapper: EntityMapper
    
    init(coreDataService: CoreDataService, entityMapper: EntityMapper) {
        self.coreDataService = coreDataService
        self.entityMapper = entityMapper
    }
    
    // MARK: - CRUD Operations
    
    func save<T: Codable & Identifiable>(_ item: T) throws {
        let entity = try entityMapper.createEntity(from: item)
        try coreDataService.save(entity)
    }
    
    func delete<T: Codable & Identifiable>(_ item: T) throws {
        let entity = try entityMapper.findEntity(for: item)
        try coreDataService.delete(entity)
    }
    
    func update<T: Codable & Identifiable>(_ item: T) throws {
        let entity = try entityMapper.findEntity(for: item)
        try entityMapper.updateEntity(entity, with: item)
        try coreDataService.update(entity)
    }
    
    func fetch<T: Codable & Identifiable>(_ type: T.Type, predicate: NSPredicate? = nil) throws -> [T] {
        let fetchRequest = entityMapper.createFetchRequest(for: type)
        fetchRequest.predicate = predicate
        let entities = try coreDataService.fetch(fetchRequest)
        return try entities.compactMap { try entityMapper.createModel(from: $0, as: type) }
    }
    
    func fetch<T: Codable & Identifiable>(_ type: T.Type, sortDescriptors: [NSSortDescriptor]? = nil) throws -> [T] {
        let fetchRequest = entityMapper.createFetchRequest(for: type)
        fetchRequest.sortDescriptors = sortDescriptors
        let entities = try coreDataService.fetch(fetchRequest)
        return try entities.compactMap { try entityMapper.createModel(from: $0, as: type) }
    }
    
    func fetch<T: Codable & Identifiable>(_ type: T.Type, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) throws -> [T] {
        let fetchRequest = entityMapper.createFetchRequest(for: type)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortDescriptors
        let entities = try coreDataService.fetch(fetchRequest)
        return try entities.compactMap { try entityMapper.createModel(from: $0, as: type) }
    }
}

// MARK: - Entity Mapper
class EntityMapper {
    private let coreDataService: CoreDataService
    
    init(coreDataService: CoreDataService) {
        self.coreDataService = coreDataService
    }
    
    func createEntity<T: Codable & Identifiable>(from item: T) throws -> NSManagedObject {
        if let plan = item as? Plan {
            return try createPlanEntity(from: plan)
        }
        
        // Fallback для других типов
        return try createGenericEntity(from: item)
    }
    
    func findEntity<T: Codable & Identifiable>(for item: T) throws -> NSManagedObject {
        if let plan = item as? Plan {
            return try findPlanEntity(for: plan)
        }
        
        // Fallback для других типов
        return try findGenericEntity(for: item)
    }
    
    func updateEntity<T: Codable & Identifiable>(_ entity: NSManagedObject, with item: T) throws {
        if let plan = item as? Plan {
            try updatePlanEntity(entity, with: plan)
        } else {
            try updateGenericEntity(entity, with: item)
        }
    }
    
    func createModel<T: Codable & Identifiable>(from entity: NSManagedObject, as type: T.Type) throws -> T? {
        if type == Plan.self {
            return try createPlan(from: entity) as? T
        }
        
        // Fallback для других типов
        return try createGenericModel(from: entity, as: type)
    }
    
    func createFetchRequest<T: Codable & Identifiable>(for type: T.Type) -> NSFetchRequest<NSManagedObject> {
        if type == Plan.self {
            // Приводим к базовому типу NSManagedObject
            return PlanEntity.fetchRequest() as! NSFetchRequest<NSManagedObject>
        }
        
        // Fallback для других типов
        return coreDataService.createFetchRequest(for: NSManagedObject.self)
    }
    
    // MARK: - Plan-specific Methods
    
    private func createPlanEntity(from plan: Plan) throws -> PlanEntity {
        let planEntity = coreDataService.createEntity(for: PlanEntity.self)
        
        // Копируем свойства напрямую
        planEntity.id = plan.id
        planEntity.role = plan.role.rawValue
        planEntity.date = plan.date
        
        // Создаем задачи
        for task in plan.tasks {
            let taskEntity = coreDataService.createEntity(for: TaskCategoryEntity.self)
            taskEntity.name = task.name
            taskEntity.isActive = task.isActive
            planEntity.addToTasks(taskEntity)
        }
        
        return planEntity
    }
    
    private func findPlanEntity(for plan: Plan) throws -> PlanEntity {
        let fetchRequest = PlanEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", plan.id as CVarArg)
        
        let results = try coreDataService.fetch(fetchRequest)
        guard let entity = results.first else {
            throw RepositoryError.entityNotFound
        }
        
        return entity
    }
    
    private func updatePlanEntity(_ entity: NSManagedObject, with plan: Plan) throws {
        guard let planEntity = entity as? PlanEntity else {
            throw RepositoryError.invalidEntityType
        }
        
        planEntity.role = plan.role.rawValue
        planEntity.date = plan.date
        
        // Обновляем задачи
        planEntity.removeFromTasks(planEntity.tasks!)
        for task in plan.tasks {
            let taskEntity = coreDataService.createEntity(for: TaskCategoryEntity.self)
            taskEntity.name = task.name
            taskEntity.isActive = task.isActive
            planEntity.addToTasks(taskEntity)
        }
    }
    
    private func createPlan(from entity: NSManagedObject) throws -> Plan? {
        guard let planEntity = entity as? PlanEntity,
              let id = planEntity.id,
              let roleString = planEntity.role,
              let role = Role(rawValue: roleString),
              let date = planEntity.date,
              let tasksSet = planEntity.tasks as? Set<TaskCategoryEntity> else {
            return nil
        }
        
        let tasks = tasksSet.compactMap { taskEntity in
            
            return TaskCategory(name: taskEntity.name, isActive: taskEntity.isActive)
        }
        
        return Plan(role: role, date: date, planCategories: tasks)
    }
    
    // MARK: - Generic Fallback Methods
    
    private func createGenericEntity<T: Codable & Identifiable>(from item: T) throws -> NSManagedObject {
        let entity = coreDataService.createEntity(for: NSManagedObject.self)
        
        // Используем reflection для автоматического маппинга
        let mirror = Mirror(reflecting: item)
        
        for child in mirror.children {
            guard let label = child.label else { continue }
            
            // Пропускаем computed properties и id
            if label == "id" { continue }
            
            // Копируем простые свойства
            entity.setValue(child.value, forKey: label)
        }
        
        return entity
    }
    
    private func findGenericEntity<T: Codable & Identifiable>(for item: T) throws -> NSManagedObject {
        let fetchRequest = coreDataService.createFetchRequest(for: NSManagedObject.self)
        
        // Ищем по ID
        if let id = Mirror(reflecting: item).children.first(where: { $0.label == "id" })?.value {
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as! CVarArg)
        }
        
        let results = try coreDataService.fetch(fetchRequest)
        guard let entity = results.first else {
            throw RepositoryError.entityNotFound
        }
        
        return entity
    }
    
    private func updateGenericEntity<T: Codable & Identifiable>(_ entity: NSManagedObject, with item: T) throws {
        let mirror = Mirror(reflecting: item)
        
        for child in mirror.children {
            guard let label = child.label else { continue }
            
            // Пропускаем computed properties и id
            if label == "id" { continue }
            
            // Обновляем свойства
            entity.setValue(child.value, forKey: label)
        }
    }
    
    private func createGenericModel<T: Codable & Identifiable>(from entity: NSManagedObject, as type: T.Type) throws -> T? {
        // Базовая реализация для других типов
        // Здесь можно добавить более сложную логику маппинга
        return nil
    }
}

// MARK: - Repository Errors
enum RepositoryError: Error, LocalizedError {
    case entityNotFound
    case mappingFailed
    case invalidEntityType
    
    var errorDescription: String? {
        switch self {
        case .entityNotFound:
            return "Entity not found"
        case .mappingFailed:
            return "Failed to map entity to model"
        case .invalidEntityType:
            return "Invalid entity type"
        }
    }
}
