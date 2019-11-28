//
//  MealAdd.swift
//  FoodDiary
//
//  Created by eric on 2019-11-22.
//  Copyright © 2019 SICT. All rights reserved.
//

import UIKit

protocol AddFoodDelegate: AnyObject {
    func addTaskDidCancel(_ controller: UIViewController)
    func addTaskDidSave(_ controller: UIViewController)
}

class FoodAdd: UIViewController, UITextFieldDelegate, SearchDelegate {
    
    // MARK: - Instance variables
    weak var delegate: AddFoodDelegate?
    var m: DataModelManager!
    var mealItem: Meal!
    var food: FDCFood?
    var fdcId: Int?
    
    // MARK: - Outlets (user interface)
    @IBOutlet weak var foodItemName: UITextField!
    @IBOutlet weak var foodBrandName: UITextField!
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var foodQuantity: UISegmentedControl!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        errorMessage.text?.removeAll()
        foodItemName.delegate = self
        foodBrandName.delegate = self

        // Listen for a notification that new data is available for the list
        NotificationCenter.default.addObserver(self, selector: #selector(APIFinished), name: Notification.Name("FDCSearchWithIdWasSuccessful"), object: nil)
  
    }
    
    // Code that runs when the notification happens
    @objc func APIFinished() {
        food = m.foodGetData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        foodItemName.resignFirstResponder()
        foodBrandName.resignFirstResponder()
        return true
    }
    
    // Make the first/desired text field active and show the keyboard
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        foodItemName.becomeFirstResponder()
    }
    
    // MARK: - Delegate methods
    
    func selectTaskDidCancel(_ controller: UIViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Use the correct type for the "item"
    func selectTask(_ controller: UIViewController, didSelect item: FDCFood) {
        foodItemName.text = item.description
        foodBrandName.text = item.brandOwner
        self.fdcId = item.fdcId
        m.getFDCWithId(self.fdcId!)
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Actions (user interface)
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // Call into the delegate
        delegate?.addTaskDidCancel(self)
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        view.endEditing(false)
        errorMessage.text?.removeAll()
        
        // Validate the data before saving
        
        if foodItemName.text!.isEmpty {
            errorMessage.text = "Name cannot be blank."
            return
        }
        
        // If we are here, the data passed the validation tests
        
        // Tell the user what we're doing
        errorMessage.text = "Attempting to save..."
        
        let newItem = FoodConsumed(context: m.ds_context)
        newItem.meal = mealItem
        newItem.descr = foodItemName.text
        newItem.brandOwner = foodBrandName.text
        newItem.fdcId = Int32(self.fdcId ?? 0)
        
        switch(foodQuantity.selectedSegmentIndex) {
        case 0:
            newItem.quantity = Int16(25)
            break
        case 1:
            newItem.quantity = Int16(50)
            break
        case 2:
            newItem.quantity = Int16(100)
            break
        case 3:
            newItem.quantity = Int16(125)
            break
        case 4:
            newItem.quantity = Int16(250)
            break
        case 5:
            newItem.quantity = Int16(500)
            break
        default:
            break
        }
        
        newItem.ncals = food?.labelNutrients?.calories?.value ?? -1
        newItem.ncarbs = food?.labelNutrients?.carbohydrates?.value ?? -1
        newItem.nfat = food?.labelNutrients?.fat?.value ?? -1
        newItem.nsodium = food?.labelNutrients?.sodium?.value ?? -1
        newItem.nprotein = food?.labelNutrients?.protein?.value ?? -1
        newItem.servingSize = food?.servingSize ?? 1
        newItem.ingredients = food?.ingredients
        
        m.ds_save()
  
        // Call into the delegate
        delegate?.addTaskDidSave(self)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if foodItemName.text == "" {
            errorMessage.text = "Food item name cannot be blank."
            return false
        }
        else {
            return true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSearchedFood" {
            let nav = segue.destination as! UINavigationController
            let vc = nav.viewControllers[0] as! FoodSearch
            vc.m = m
            vc.delegate = self
            vc.foodItemName = foodItemName.text!
            vc.foodBrandName = foodBrandName.text ?? ""
        }
    }

}
