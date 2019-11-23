import UIKit

class FoodScene: UIViewController {
    
    // MARK: - Public properties (instance variables)
    
    var m: DataModelManager!
    // Passed-in object, if necessary
    var item: FoodConsumed!
    
    // MARK: - Outlets (user interface)
    @IBOutlet weak var foodName: UILabel!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Food Item"
        foodName.text = item.descr
    }
    
    // MARK: - Navigation
    
}


