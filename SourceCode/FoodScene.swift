import UIKit

class FoodScene: ListBaseCD {
    
    // MARK: - Public properties (instance variables)
    
    var m: DataModelManager!
    // Passed-in object, if necessary
    var foodItem: FoodConsumed!
    
    // MARK: - Outlets (user interface)
    @IBOutlet weak var tableview: UITableView!
    
    var nutrients: [Nutrients]!
    
    
    var mealItem: Meal!
    
    
    var allData: [AllData]!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Food Item"
        //tableview.delegate = self
        //tableview.dataSource = self
        
    }
    
    // Number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.allData.count
    }
    
    // What is the section title?
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.allData![section].sectionName
    }
    
    // Number of rows in a section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.allData![section].data as AnyObject).count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "macronutrients", for: indexPath)
        let item = nutrients[indexPath.row]
        cell.textLabel!.text = item.nutrient
        cell.detailTextLabel?.text = item.value! == -1 ? "unknown" : String(format: "%.2f", (Double(foodItem.quantity)/foodItem.servingSize)*item.value!)
        return cell
    }
 
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "macronutrients", for: indexPath)
//        let item = nutrients[indexPath.row]
//        cell.textLabel!.text = item.nutrient
//        cell.detailTextLabel?.text = item.value! == -1 ? "unknown" : String(format: "%.2f", (Double(foodItem.quantity)/foodItem.servingSize)*item.value!)
//        return cell
//    }
    
}


