import UIKit
import CoreData

protocol SearchDelegate: class {
    func selectTaskDidCancel(_ controller: UIViewController)
    func selectTask(_ controller: UIViewController, didSelect item: FDCFood)
}

class FoodSearch: ListBaseCD {
    
    // MARK: - Public properties (instance variables)
    var m: DataModelManager!
    var foods = [FDCFood]()
    weak var delegate: SearchDelegate?
    
    var foodItemName: String!
    var foodBrandName: String?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Searching..."
        
        // Listen for a notification that new data is available for the list
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: Notification.Name("FDCSearchWasSuccessful"), object: nil)
        
        let searchBody = FDCSearchBody(generalSearchInput: foodItemName, brandOwner: foodBrandName)
        m.sendFDCSearchRequest(searchBody)
        
    }
    
    // Code that runs when the notification happens
    @objc func reloadTableView() {
        foods = m.foodsGetData()
        title = "Food Item Search Results (\(self.foods.count))"
        tableView.reloadData()
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        delegate?.selectTaskDidCancel(self)
    }
    
    // MARK: - Table view building
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foods.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "foodSearch", for: indexPath)
        cell.textLabel!.text = foods[indexPath.row].description
        cell.detailTextLabel?.text = foods[indexPath.row].brandOwner
        
        return cell
    }
    
    // Responds to a row selection event
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Work with the selected item
        if let selectedCell = tableView.cellForRow(at: indexPath) {
            // Show a check mark
            selectedCell.accessoryType = .checkmark
            // Fetch the data for the selected item
            let data = foods[indexPath.row]
            // Call back into the delegate
            delegate?.selectTask(self, didSelect: data)
        }
    }
    
}
