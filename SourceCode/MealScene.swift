import UIKit
import MapKit

class MealScene: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource, ShowMapDelegate {
    
//    var totalCals: Double = 0.0
//    var totalCarbs: Double = 0.0
//    var totalFat: Double = 0.0
//    var totalProtein: Double = 0.0
//    var totalSodium: Double = 0.0
    var nutrients: [Nutrients] = []
    
    // MARK: - Public properties (instance variables)
    
    var m: DataModelManager!
    // Passed-in object, if necessary
    var item: Meal!
    
    // MARK: - Outlets (user interface)
    @IBOutlet weak var mealName: UILabel!
    @IBOutlet weak var imageContent: UIImageView!
    @IBOutlet weak var mealDate: UILabel!
    @IBOutlet weak var mealTime: UILabel!
    @IBOutlet weak var mealNotes: UILabel!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var mealLoc: UILabel!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mealName.text = "Name: \(item.name!)"
        mealLoc.text = "Location: \(item.locName!)"
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        mealDate.text = "Date: \(formatter.string(from: item.fullDate!))"
        formatter.dateFormat = "hh:mm a"
        mealTime.text = "Time: \(formatter.string(from: item.fullDate!))"
        mealNotes.text = "Notes: \(item.notes!)"
        
        if let imgData = item.photo {
            
            imageContent.image = UIImage(data: imgData)
            
            //let originalImage = UIImage(data: imgData)
            //imageContent.image = UIImage(cgImage: originalImage as! CGImage, scale: CGFloat(signOf: 100, magnitudeOf: 100), orientation: UIImage.Orientation.up)
            
            //imageContent.image = UIImage(data: imgData, scale: CGFloat(signOf: 100, magnitudeOf: 100), orientation: UIImage.Orientation.up)
            //UIImage(cgImage: <#T##CGImage#>, scale: <#T##CGFloat#>, orientation: UIImage.Orientation)
            
        }
        tableview.delegate = self
        tableview.dataSource = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        var totalCals: Double = 0.0
        var totalCarbs: Double = 0.0
        var totalFat: Double = 0.0
        var totalProtein: Double = 0.0
        var totalSodium: Double = 0.0
        
        if let foodItems = item.foodConsumed {
            for case let foodItem as FoodConsumed in foodItems {
                //let foodItem: FoodConsumed
                totalCals += foodItem.ncals == -1 ? 0 : (Double(foodItem.quantity)/foodItem.servingSize)*foodItem.ncals
                totalCarbs += foodItem.ncarbs == -1 ? 0 : (Double(foodItem.quantity)/foodItem.servingSize)*foodItem.ncarbs
                totalFat += foodItem.nfat == -1 ? 0 : (Double(foodItem.quantity)/foodItem.servingSize)*foodItem.nfat
                totalProtein += foodItem.nprotein == -1 ? 0 : (Double(foodItem.quantity)/foodItem.servingSize)*foodItem.nprotein
                totalSodium += foodItem.nsodium == -1 ? 0 : (Double(foodItem.quantity)/foodItem.servingSize)*foodItem.nsodium
            }
        }
        nutrients = [Nutrients(nutrient: "Calories", value: totalCals), Nutrients(nutrient: "Carbohydrates", value: totalCarbs), Nutrients(nutrient: "Fat", value: totalFat), Nutrients(nutrient: "Protein", value: totalProtein), Nutrients(nutrient: "Sodium", value: totalSodium)]
        
        tableview.reloadData()
        
    }
    
    // MARK: - Actions (user interface)
    @IBAction func mapClicked(_ sender: UIButton) {
        print("map clicked")
    }
    @IBAction func listClicked(_ sender: UIButton) {
        print("list clicked")
    }
    @IBAction func updateImagePressed(_ sender: UIButton) {
        // Create the image picker controller
        let c = UIImagePickerController()
        // Determine what we can use...
        // Prefer the camera, but can use the photo library
        c.sourceType = UIImagePickerController.isSourceTypeAvailable(.camera) ? .camera : .photoLibrary
        c.delegate = self
        c.allowsEditing = false
        // Show the controller
        present(c, animated: true, completion: nil)
    }
    
    // Cancel
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Save
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Attempt to get the image from the "info" object
        if let image = info[.originalImage] as? UIImage {
            // If successful, save the image
            imageContent.image = image
            item.photo = image.pngData()
            m.ds_save()
        }
        dismiss(animated: true, completion: nil)
    }
    
    func showMapDone(_ controller: UIViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Number of sections
    func numberOfSections(in tableview: UITableView) -> Int {
        return 1
    }
    
    // Number of rows in a section
    func tableView(_ tableview: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableview: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "macronutrientstotal", for: indexPath)
        let item = nutrients[indexPath.row]
        cell.textLabel!.text = item.nutrient
        cell.detailTextLabel?.text = String(format: "%.2f", item.value!)
        return cell
    }

    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "toFoodList" {
            let vc = segue.destination as! FoodList
            vc.m = m
            vc.mealItem = item
            vc.foodItems = item.foodConsumed?.sortedArray(using: [NSSortDescriptor(key: "descr", ascending: true)]) as? [FoodConsumed]
         }
        
        if segue.identifier == "toMealMap" {
            let nav = segue.destination as! UINavigationController
            let vc = nav.viewControllers[0] as! MealMap
            vc.m = m
            vc.mealItem = item
            vc.delegate = self
            vc.userLocationTitle = "My Location"
            vc.userLocationSubtitle = ""
            
            if item.locLong != 0 && item.locLat != 0 {
                let location = CLLocation(latitude: CLLocationDegrees(item!.locLat), longitude: CLLocationDegrees(item!.locLong))
                let ma1 = MapAnnotation(coordinate: location.coordinate, title: item.name, subtitle: item.locName)
                vc.mapAnnotations = [ma1]
            }

        }

    }
    
}
