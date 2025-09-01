import Foundation
import CoreData

@objc(TaskCategoryEntity)
public class TaskCategoryEntity: NSManagedObject {
    @NSManaged public var name: String
    @NSManaged public var isActive: Bool
    @NSManaged public var plan: PlanEntity?
}

// MARK: - Fetch Request
extension TaskCategoryEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskCategoryEntity> {
        return NSFetchRequest<TaskCategoryEntity>(entityName: "TaskCategoryEntity")
    }
}
