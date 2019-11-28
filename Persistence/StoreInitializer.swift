//
//  StoreInitializer.swift
//  Purpose - Initializes the data store with starter data
//

import CoreData

class StoreInitializer {
    
    class func addStarterData(context: NSManagedObjectContext) {
        
        
        guard let entityMeal = NSEntityDescription.entity(forEntityName: "Meal", in: context) else {
            fatalError("Can't create entity named Meal")
        }
        
        guard let entityFoodConsumed = NSEntityDescription.entity(forEntityName: "FoodConsumed", in: context) else {
            fatalError("Can't create entity named Meal")
        }
        
        // Add new objects to the context
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        let currentDate = Date()
        let obj1 = Meal(entity: entityMeal, insertInto: context)
        obj1.name = "Breakfast"
        obj1.locName = "Home"
        obj1.fullDate = currentDate
        obj1.date = formatter.string(from: currentDate)
        obj1.locLat = 43.651890
        obj1.locLong = -79.381706
        obj1.notes = "Yum"
        
        let food1 = FoodConsumed(entity: entityFoodConsumed, insertInto: context)
        food1.brandOwner = "Local Farm"
        food1.descr = "Eggs"
        food1.ncals = 120
        food1.nfat = 5
        food1.ncarbs = 10
        food1.nsodium = 10
        food1.nprotein = 15
        food1.ingredients = "It's an egg."
        food1.quantity = 50
        food1.servingSize = 50
        
        obj1.addToFoodConsumed(food1)

        
    }
    
}
