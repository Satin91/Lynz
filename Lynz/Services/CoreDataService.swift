//
//  LocalDataInteractor.swift
//  Lynz
//
//  Created by Артур Кулик on 31.08.2025.
//

import Foundation
import CoreData

// Core data полностью создаётся программно
class CoreDataService {
    
    // MARK: - Properties
    static let shared = CoreDataService()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        // Создаем модель программно
        let model = NSManagedObjectModel()
        
        let entityDescription = NSEntityDescription()
        entityDescription.name = "ManagedObject"
        entityDescription.managedObjectClassName = "NSManagedObject"
        
        // Добавляем атрибуты
        let idAttribute = NSAttributeDescription()
        idAttribute.name = "id"
        idAttribute.attributeType = .stringAttributeType
        idAttribute.isOptional = false
        
        let dataAttribute = NSAttributeDescription()
        dataAttribute.name = "data"
        dataAttribute.attributeType = .binaryDataAttributeType
        dataAttribute.isOptional = false
        
        let typeAttribute = NSAttributeDescription()
        typeAttribute.name = "type"
        typeAttribute.attributeType = .stringAttributeType
        typeAttribute.isOptional = false
        
        let createdAtAttribute = NSAttributeDescription()
        createdAtAttribute.name = "createdAt"
        createdAtAttribute.attributeType = .dateAttributeType
        createdAtAttribute.isOptional = false
        
        let updatedAtAttribute = NSAttributeDescription()
        updatedAtAttribute.name = "updatedAt"
        updatedAtAttribute.attributeType = .dateAttributeType
        updatedAtAttribute.isOptional = false
        
        // Добавляем атрибуты к энтити
        entityDescription.properties = [idAttribute, dataAttribute, typeAttribute, createdAtAttribute, updatedAtAttribute]
        
        // Добавляем сущность к модели
        model.entities = [entityDescription]
        
        // Создаем контейнер с готовой моделью
        let container = NSPersistentContainer(name: "LynzDataModel", managedObjectModel: model)
        
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    //MARK: - Create
    func create<T: Codable>(_ object: T, withId id: String, type: String) throws {
        let entity = NSEntityDescription.entity(forEntityName: "ManagedObject", in: context)!
        let managedObject = NSManagedObject(entity: entity, insertInto: context)
        
        do {
            let data = try JSONEncoder().encode(object)
            let now = Date()
            
            managedObject.setValue(id, forKey: "id")
            managedObject.setValue(data, forKey: "data")
            managedObject.setValue(type, forKey: "type")
            managedObject.setValue(now, forKey: "createdAt")
            managedObject.setValue(now, forKey: "updatedAt")
            
            try context.save()
        } catch {
            context.rollback()
            throw error
        }
    }
    
    //MARK: - Read
    func fetch<T: Codable>(_ type: T.Type, withId id: String) throws -> T? {
        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "ManagedObject")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        fetchRequest.fetchLimit = 1
        
        let results = try context.fetch(fetchRequest)
        
        guard let managedObject = results.first,
              let data = managedObject.value(forKey: "data") as? Data else {
            return nil
        }
        
        return try JSONDecoder().decode(type, from: data)
    }
    
    func fetchAll<T: Codable>(_ type: T.Type, ofType entityType: String? = nil) throws -> [T] {
        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "ManagedObject")
        
        if let entityType = entityType {
            fetchRequest.predicate = NSPredicate(format: "type == %@", entityType)
        }
        
        let results = try context.fetch(fetchRequest)
        
        return try results.compactMap { managedObject in
            guard let data = managedObject.value(forKey: "data") as? Data else {
                return nil
            }
            return try JSONDecoder().decode(type, from: data)
        }
    }
    
    //MARK: - Update
    func update<T: Codable>(_ object: T, withId id: String) throws {
        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "ManagedObject")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        fetchRequest.fetchLimit = 1
        
        let results = try context.fetch(fetchRequest)
        
        guard let managedObject = results.first else {
            throw CoreDataError.objectNotFound
        }
        
        do {
            let data = try JSONEncoder().encode(object)
            managedObject.setValue(data, forKey: "data")
            managedObject.setValue(Date(), forKey: "updatedAt")
            
            try context.save()
        } catch {
            context.rollback()
            throw error
        }
    }
    
    //MARK: - Delete
    func delete(withId id: String) throws {
        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "ManagedObject")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        fetchRequest.fetchLimit = 1
        
        let results = try context.fetch(fetchRequest)
        
        guard let managedObject = results.first else {
            throw CoreDataError.objectNotFound
        }
        
        context.delete(managedObject)
        try context.save()
    }
    
    func deleteAll(ofType entityType: String? = nil) throws {
        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "ManagedObject")
        
        if let entityType = entityType {
            fetchRequest.predicate = NSPredicate(format: "type == %@", entityType)
        }
        
        let results = try context.fetch(fetchRequest)
        
        for managedObject in results {
            context.delete(managedObject)
        }
        
        try context.save()
    }
    
    // MARK: - Save Context
    func saveContext() throws {
        if context.hasChanges {
            try context.save()
        }
    }
}

// MARK: - Core Data Errors
enum CoreDataError: Error, LocalizedError {
    case objectNotFound
    case encodingError
    case decodingError
    case saveError
    
    var errorDescription: String? {
        switch self {
        case .objectNotFound:
            return "Objct not found in Core Data"
        case .encodingError:
            return "Object encoding error"
        case .decodingError:
            return "Object decoding Error"
        case .saveError:
            return "Save to Core Data error"
        }
    }
}
