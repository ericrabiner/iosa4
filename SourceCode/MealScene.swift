import UIKit

class MealScene: UIViewController {
    
    // MARK: - Public properties (instance variables)
    
    var m: DataModelManager!
    // Passed-in object, if necessary
    var item: Meal!
    
    // MARK: - Outlets (user interface)
    @IBOutlet weak var mealName: UILabel!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mealName.text = item.name
    }
    
    // MARK: - Actions (user interface)
    @IBAction func mapClicked(_ sender: UIButton) {
        print("map clicked")
    }
    @IBAction func listClicked(_ sender: UIButton) {
        print("list clicked")
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "toFoodList" {
            let vc = segue.destination as! FoodList
            vc.m = m
            vc.meal = item
         }

    }
    
}
