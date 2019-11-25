import UIKit

class FoodScene: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Public properties (instance variables)
    
    var mealItem: Meal!
    var foodItem: FoodConsumed!
    var nutrients: [Nutrients]!
    
    // MARK: - Outlets (user interface)
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var foodIngredients: UITextView!
    @IBOutlet weak var mealName: UILabel!
    @IBOutlet weak var mealLoc: UILabel!
    @IBOutlet weak var foodDesc: UILabel!
    @IBOutlet weak var foodBrandName: UILabel!
    @IBOutlet weak var foodServingSize: UILabel!
    @IBOutlet weak var foodQuantity: UILabel!
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Food Item"
        
        mealName.text = "Name: \(mealItem.name!)"
        mealLoc.text = "Location: \(mealItem.locName!)"
        
        foodDesc.text = "Name: \(foodItem.descr!)"
        foodBrandName.text = "Description: \(foodItem.brandOwner!)"
        foodServingSize.text = "Serving Size: \(foodItem.servingSize)"
        foodQuantity.text = "Quantity: \(foodItem.quantity) (g)"
        
        foodIngredients.text = foodItem.ingredients
        
        tableview.delegate = self
        tableview.dataSource = self
    }
    
    // Number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Number of rows in a section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nutrients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "macronutrients", for: indexPath)
        let item = nutrients[indexPath.row]
        cell.textLabel!.text = item.nutrient
        cell.detailTextLabel?.text = item.value! == -1 ? "unknown" : String(format: "%.2f", (Double(foodItem.quantity)/foodItem.servingSize)*item.value!)
        return cell
    }
    
}


