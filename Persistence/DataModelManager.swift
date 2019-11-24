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
    
    var foods = [FDCFood]()
    
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
    
    func foodGetData() -> [FDCFood] {
        return foods
    }
    
    // below is get with fcdid
    //https://api.nal.usda.gov/fdc/v1/356446?api_key=4rgfn7lFClJjkb5lP6OPRfbeU1U7o8wpbnX25qNB
    
    
    func sendFDCSearchRequest(_ postData: FDCSearchBody) {
 
        let request = WebApiRequest()
        request.httpMethod = "POST"
        request.urlBase = "https://api.nal.usda.gov/fdc/v1/search?api_key=4rgfn7lFClJjkb5lP6OPRfbeU1U7o8wpbnX25qNB"
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(DateFormatter.iso8601Full)
        request.httpBody = try! encoder.encode(postData)
        // Send the request, and write a completion method to pass to the request
        request.sendRequest(toUrlPath: "") { (result: FDCSearchRespose) in
            self.foods = result.foods
            NotificationCenter.default.post(name: Notification.Name("FDCSearchWasSuccessful"), object: nil)
        }
    }
}
