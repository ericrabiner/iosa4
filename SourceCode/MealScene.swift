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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        // Add "if" blocks to cover all the possible segues
        // One for each workflow (navigation) or task segue
        
        // A workflow segue is managed by the current nav controller
        // A task segue goes to a scene that's managed by a NEW nav controller
        // So there's a difference in how we get a reference to the next controller
        
        // Sample workflow segue code...
        
         if segue.identifier == "toFoodList" {
         
         // Your customized code goes here,
         // but here is some sample/starter code...
         
         // Get a reference to the next controller
         // Next controller is managed by the current nav controller
         let vc = segue.destination as! FoodList
         
         // Fetch and prepare the data to be passed on
         //let selectedData = item
         
         // Set other properties
         //vc.item = selectedData
         //vc.title = selectedData?.name
         // Pass on the data model manager, if necessary
         vc.m = m
         // Set the delegate, if configured
         //vc.delegate = self
         }
 
        
        // Sample task segue code...
        /*
        
         if segue.identifier == "toFoodList" {
         
         // Your customized code goes here,
         // but here is some sample/starter code...
         
         // Get a reference to the next controller
         // Next controller is embedded in a new navigation controller
         // so we must go through it
         let nav = segue.destination as! UINavigationController
         let vc = nav.viewControllers[0] as! FoodList
         
         // Fetch and prepare the data to be passed on
//         let indexPath = tableView.indexPath(for: sender as! UITableViewCell)
//         let selectedData = frc.object(at: indexPath!)
         
         // Set other properties
//         vc.item = selectedData
//         vc.title = selectedData.name
         // Pass on the data model manager, if necessary
         vc.m = m
         // Set the delegate, if configured
         //vc.delegate = self
         }
        */
        
    }
    
}
