import UIKit
import CoreData

class FoodList: ListBaseCD {
    
    // MARK: - Private internal instance variables
    
    // Configure the desired entity type in the frc
    private var frc: NSFetchedResultsController<FoodConsumed>!
    
    // MARK: - Public properties (instance variables)
    
    var m: DataModelManager!

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure nav items
        title = "Meal Food Items"
        
        // Configure the frc for the desired entity type, sort is case-insensitive
        frc = m.ds_frcForEntityNamed("FoodConsumed", withPredicateFormat: nil, predicateObject: nil, sortDescriptors: [NSSortDescriptor(key: "descr", ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)))], andSectionNameKeyPath: nil)
        
        // This controller will be the frc delegate
        frc.delegate = self;
        
        // Perform fetch, and if there's an error, log it
        do {
            try frc.performFetch()
        } catch let error {
            print(error.localizedDescription)
        }
        
    }
    
    // MARK: - Actions (user interface)
    @IBAction func addItemHere(_ sender: UIBarButtonItem) {
        
        if let newItem = m.foodConsumed_CreateItem() {
            
            newItem.descr = StoreInitializer.randomString(StoreInitializer.randomInteger(between: 5, and: 15))
            newItem.brandOwner = "Toronto"
            //            newItem.quantity = Int32(StoreInitializer.randomInteger(between: 10, and: 500))
            m.ds_save()
        }
    }
    
    // MARK: - Table view building
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.frc.sections?.count ?? 0
    }
    
    // What is the section title?
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        // Get a reference to the section object in the frc
        // And make sure there is a section name
        if let s = self.frc.sections?[section], s.name.count > 0 {
            return "Your custom section prompt \(s.name)"
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.frc.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultFood", for: indexPath)
        
        let item = frc.object(at: indexPath)
        cell.textLabel!.text = item.descr
        cell.detailTextLabel?.text = item.brandOwner
        
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let item = frc.object(at: indexPath)
            m.foodConsumed_DeleteItem(item: item)
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toFoodScene" {
            let vc = segue.destination as! FoodScene
            let indexPath = tableView.indexPath(for: sender as! UITableViewCell)
            let selectedData = frc.object(at: indexPath!)
            vc.item = selectedData
            vc.m = m
            // Set the delegate, if configured
            //vc.delegate = self
        }
    }
    
}
