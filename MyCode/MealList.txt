import UIKit
import CoreData
import func AVFoundation.AVMakeRect

class MealList: ListBaseCD, AddMealDelegate {
    
    // MARK: - Private internal instance variables
    private var frc: NSFetchedResultsController<Meal>!
    // Configure the thumbnail size
    private let thumbnailSize = CGSize(width: 50, height: 50)
    
    // MARK: - Public properties (instance variables)
    var m: DataModelManager!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Meals"
        tableView.rowHeight = 60.0
        
        // If desired, configure the table view edit capability
        navigationItem.leftBarButtonItem = editButtonItem
        
        // Configure the frc for the desired entity type, sort is case-insensitive
        frc = m.ds_frcForEntityNamed("Meal", withPredicateFormat: nil, predicateObject: nil, sortDescriptors: [NSSortDescriptor(key: "date", ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:))), NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)))], andSectionNameKeyPath: "date")
        
        // This controller will be the frc delegate
        frc.delegate = self;
        
        // Perform fetch, and if there's an error, log it
        do {
            try frc.performFetch()
        } catch let error {
            print(error.localizedDescription)
        }

    }
    
    func addTaskDidCancel(_ controller: UIViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func addTaskDidSave(_ controller: UIViewController) {
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Actions (user interface)
    
    // Disable the right bar button (the + "Add" button) during table edits
    override func setEditing(_ editing: Bool, animated: Bool) {
        // Must call super, then set the right bar button state
        super.setEditing(editing, animated: animated)
        navigationItem.rightBarButtonItem?.isEnabled = !isEditing
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
            return s.name
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.frc.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "default", for: indexPath)
        
        let item = frc.object(at: indexPath)
        cell.textLabel!.text = item.name
        cell.detailTextLabel?.text = item.locName
        
        // Show an image thumbnail
        if let image = item.photo {
            //cell.imageView?.image = UIImage(data: image)
            cell.imageView?.image = getThumbnail(image: UIImage(data: image)!, for: thumbnailSize)
        }
        else {
            cell.imageView?.image = getThumbnail(image: UIImage(named: "foodIcon")!, for: thumbnailSize)
            //cell.imageView?.image = UIImage(named: "foodIcon")
        }

        return cell
    }
    
    // Image thumbnail generator
    // All credit goes to the author, Mattt Thompson
    // https://nshipster.com/image-resizing/
    private func getThumbnail(image: UIImage, for size: CGSize) -> UIImage? {
        // Create a small container in which we can draw the thumbnail
        let rect = AVMakeRect(aspectRatio: image.size, insideRect: CGRect(origin: .zero, size: thumbnailSize))
        // Create an image renderer
        let renderer = UIGraphicsImageRenderer(size: size)
        // Create a new thumbnail image
        return renderer.image { (context) in
            //image.draw(in: CGRect(origin: .zero, size: size))
            image.draw(in: rect)
        }
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            // Delete the row from the data source
            let item = frc.object(at: indexPath)
            m.meal_DeleteItem(item: item)
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
         if segue.identifier == "toMealScene" {
            let vc = segue.destination as! MealScene
            let indexPath = tableView.indexPath(for: sender as! UITableViewCell)
            let selectedData = frc.object(at: indexPath!)
            vc.item = selectedData
            vc.title = "Meal"
            vc.m = m
         }

         if segue.identifier == "toMealAdd" {
            let nav = segue.destination as! UINavigationController
            let vc = nav.viewControllers[0] as! MealAdd
            vc.m = m
            vc.delegate = self
         }
        
    }
    
}
