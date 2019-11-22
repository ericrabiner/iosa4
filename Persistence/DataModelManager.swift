//
//  DataModelManager.swift
//  Purpose - Manages data model tasks for all modules in the app
//

import CoreData

class DataModelManager {
    
    // MARK: - Private internal instance variables
    
    private var cdStack: CDStack!
    
    // MARK: - Public properties (instance variables)
    
    var ds_context: NSManagedObjectContext!
    var ds_model: NSManagedObjectModel!
    
    // MARK: - Lifecycle
    
    init() {
        
        // Initialize the Core Data stack
        cdStack = CDStack(model: self)
        ds_context = cdStack.persistentContainer.viewContext
        ds_model = cdStack.persistentContainer.managedObjectModel
    }
    
    // MARK: - Public methods
    
    func ds_frcForEntityNamed<T>(_ entityName: String, withPredicateFormat predicate: String?, predicateObject: [AnyObject]?, sortDescriptors: [NSSortDescriptor]?, andSectionNameKeyPath sectionName: String?) -> NSFetchedResultsController<T> {
        
        return cdStack.createFetchedResultsControllerForEntityNamed(entityName, withPredicateFormat: predicate, predicateObject: predicateObject, sortDescriptors: sortDescriptors, andSectionNameKeyPath: sectionName)
    }
    
    // Save changes, if any
    func ds_save() {
        cdStack.save()
    }
    
    // Entity-specific methods (fetch, add, etc.) are located in extension source code files
    
}
