import Foundation
import CoreData
import Combine

class CoreDataService: ObservableObject {
    private let persistentContainer: NSPersistentContainer
    private var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    init() {
        persistentContainer = NSPersistentContainer(name: "LynzDataModel")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data failed to load: \(error.localizedDescription)")
            }
        }
        
        // Автоматическое слияние изменений
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    // MARK: - CRUD Operations
    
    func save<T: NSManagedObject>(_ entity: T) throws {
        context.insert(entity)
        try context.save()
    }
    
    func delete<T: NSManagedObject>(_ entity: T) throws {
        context.delete(entity)
        try context.save()
    }
    
    func update<T: NSManagedObject>(_ entity: T) throws {
        try context.save()
    }
    
    func fetch<T: NSManagedObject>(_ request: NSFetchRequest<T>) throws -> [T] {
        return try context.fetch(request)
    }
    
    func saveContext() throws {
        if context.hasChanges {
            try context.save()
        }
    }
    
    func rollback() {
        context.rollback()
    }
    
    // MARK: - Utility Methods
    
    func createFetchRequest<T: NSManagedObject>(for entityType: T.Type) -> NSFetchRequest<T> {
        return NSFetchRequest<T>(entityName: String(describing: entityType))
    }
    
    func createEntity<T: NSManagedObject>(for entityType: T.Type) -> T {
        return T(context: context)
    }
}
