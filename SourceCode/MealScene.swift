import UIKit

class MealScene: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Public properties (instance variables)
    
    var m: DataModelManager!
    // Passed-in object, if necessary
    var item: Meal!
    
    // MARK: - Outlets (user interface)
    @IBOutlet weak var mealName: UILabel!
    @IBOutlet weak var imageContent: UIImageView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mealName.text = item.name
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
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "toFoodList" {
            let vc = segue.destination as! FoodList
            vc.m = m
            vc.mealItem = item
            vc.foodItems = item.foodConsumed?.sortedArray(using: [NSSortDescriptor(key: "descr", ascending: true)]) as? [FoodConsumed]
        
         }

    }
    
}
