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
    
    // MARK: - Outlets (user interface)
    @IBOutlet weak var foodItemName: UITextField!
    @IBOutlet weak var foodBrandName: UITextField!
    @IBOutlet weak var errorMessage: UILabel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        errorMessage.text?.removeAll()
        foodItemName.delegate = self
        foodBrandName.delegate = self
        super.viewDidLoad()
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
        
        if foodBrandName.text!.isEmpty {
            errorMessage.text = "Location name cannot be blank."
            return
        }
        
        // If we are here, the data passed the validation tests
        
        // Tell the user what we're doing
        errorMessage.text = "Attempting to save..."
        
        let newItem = FoodConsumed(context: m.ds_context)
        newItem.descr = foodItemName.text
        newItem.brandOwner = foodBrandName.text
        newItem.meal = mealItem
        m.ds_save()
  
        // Call into the delegate
        delegate?.addTaskDidSave(self)
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
