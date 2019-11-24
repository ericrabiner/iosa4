import UIKit
import MapKit

class MealScene: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ShowMapDelegate {
    
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
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mealName.text = item.name
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        mealDate.text = formatter.string(from: item.date!)
        formatter.dateFormat = "hh:mm a"
        mealTime.text = formatter.string(from: item.date!)
        mealNotes.text = item.notes
        if let imgData = item.photo {
            
            imageContent.image = UIImage(data: imgData)
            
            //let originalImage = UIImage(data: imgData)
            //imageContent.image = UIImage(cgImage: originalImage as! CGImage, scale: CGFloat(signOf: 100, magnitudeOf: 100), orientation: UIImage.Orientation.up)
            
            //imageContent.image = UIImage(data: imgData, scale: CGFloat(signOf: 100, magnitudeOf: 100), orientation: UIImage.Orientation.up)
            //UIImage(cgImage: <#T##CGImage#>, scale: <#T##CGFloat#>, orientation: UIImage.Orientation)
            
        }
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
