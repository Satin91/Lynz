import Foundation
import CoreData

@objc(PlanEntity)
public class PlanEntity: NSManagedObject {
    @NSManaged public var id: UUID?
    @NSManaged public var role: String?
    @NSManaged public var date: Date?
    @NSManaged public var tasks: NSSet?
}

// MARK: - Generated accessors for tasks
extension PlanEntity {
    @objc(addTasksObject:)
    @NSManaged public func addToTasks(_ value: TaskCategoryEntity)
    
    @objc(removeTasksObject:)
    @NSManaged public func removeFromTasks(_ value: TaskCategoryEntity)
    
    @objc(addTasks:)
    @NSManaged public func addToTasks(_ values: NSSet)
    
    @objc(removeTasks:)
    @NSManaged public func removeFromTasks(_ values: NSSet)
}

// MARK: - Fetch Request
extension PlanEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<PlanEntity> {
        return NSFetchRequest<PlanEntity>(entityName: "PlanEntity")
    }
}
