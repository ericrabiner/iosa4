import UIKit
import CoreData

class FoodList: ListBaseCD, AddFoodDelegate {
    
    // MARK: - Public properties (instance variables)
    var m: DataModelManager!
    var mealItem: Meal!
    var foodItems: [FoodConsumed]!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Meal Food Items"
        foodItems = mealItem.foodConsumed?.sortedArray(using: [NSSortDescriptor(key: "descr", ascending: true)]) as? [FoodConsumed]
    }
    
    func addTaskDidCancel(_ controller: UIViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func addTaskDidSave(_ controller: UIViewController) {
        foodItems = mealItem.foodConsumed?.sortedArray(using: [NSSortDescriptor(key: "descr", ascending: true)]) as? [FoodConsumed]
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Table view building
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultFood", for: indexPath)
        
        let item = foodItems[indexPath.row]
        cell.textLabel!.text = item.descr
        cell.detailTextLabel?.text = item.brandOwner
        
        return cell
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toFoodScene" {
            let vc = segue.destination as! FoodScene
            let indexPath = tableView.indexPath(for: sender as! UITableViewCell)
            let selectedData = foodItems![(indexPath?.row)!]
            vc.foodItem = selectedData
            vc.m = m
        }
        
        if segue.identifier == "toFoodAdd" {
            let nav = segue.destination as! UINavigationController
            let vc = nav.viewControllers[0] as! FoodAdd
            vc.mealItem = mealItem
            vc.m = m
            vc.delegate = self
            
        }
    }
    
}
