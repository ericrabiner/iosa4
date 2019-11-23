//
//  DataModelManager.swift
//  Purpose - Properties and methods for a specific entity in the app's data model
//

import CoreData

extension DataModelManager {
    
    // Count all (nil predicate) or some (non-nil configured predicate)
    func foodConsumed_Count(withPredicate: NSPredicate) -> Int {
        
        let fetchRequest: NSFetchRequest<FoodConsumed> = FoodConsumed.fetchRequest()
        fetchRequest.predicate = withPredicate
        
        do {
            let count = try ds_context.count(for: fetchRequest)
            return count
        } catch let error {
            print(error.localizedDescription)
        }
        return 0
    }
    
    // Fetch all
    func foodConsumed_GetAll() -> [FoodConsumed]? {
        return foodConsumed_GetSome(withPredicate: nil)
    }
    
    // Fetch some
    func foodConsumed_GetSome(withPredicate: NSPredicate?) -> [FoodConsumed]? {
        
        let fetchRequest: NSFetchRequest<FoodConsumed> = FoodConsumed.fetchRequest()
        fetchRequest.predicate = withPredicate
        
        // Optional, configure one or more sort descriptors here
        //fetchRequest.sortDescriptors?.append(NSSortDescriptor(key: "name", ascending: true))
        //fetchRequest.sortDescriptors?.append(NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:))))
        
        do {
            let results = try ds_context.fetch(fetchRequest)
            return results
        } catch let error {
            print(error.localizedDescription)
        }
        return nil
    }
    
    // Fetch one, by its unique object identifier
    func foodConsumed_GetByObjectId(_ objectId: NSManagedObjectID) -> FoodConsumed? {
        
        let fetchRequest: NSFetchRequest<FoodConsumed> = FoodConsumed.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "self == %@", objectId)
        
        do {
            let results = try ds_context.fetch(fetchRequest)
            if results.count == 1 {
                return results[0]
            } else {
                return nil
            }
        } catch let error {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    // Fetch one, by another attribute that has unique values (e.g. "name")
    func foodConsumed_GetByName(_ name: String) -> FoodConsumed? {
        
        let fetchRequest: NSFetchRequest<FoodConsumed> = FoodConsumed.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name ==[c] %@", name)
        
        do {
            let results = try ds_context.fetch(fetchRequest)
            if results.count == 1 {
                return results[0]
            } else {
                return nil
            }
        } catch let error {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    // Create new
    func foodConsumed_CreateItem() -> FoodConsumed? {
        
        guard let newItem = NSEntityDescription.insertNewObject(forEntityName: "FoodConsumed", into: ds_context) as? FoodConsumed else {
            print("Cannot create a new item")
            return nil
        }
        return newItem
    }
    
    // Delete item
    func foodConsumed_DeleteItem(item: FoodConsumed) {
        ds_context.delete(item)
        ds_save()
    }
    
    // Delete all
    func foodConsumed_DeleteAll() {
        if let result = foodConsumed_GetAll() {
            for obj in result {
                ds_context.delete(obj)
            }
            ds_save()
        }
    }
    
}
