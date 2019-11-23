//
//  MealAdd.swift
//  FoodDiary
//
//  Created by eric on 2019-11-22.
//  Copyright © 2019 SICT. All rights reserved.
//

import UIKit

protocol AddMealDelegate: AnyObject {
    func addTaskDidCancel(_ controller: UIViewController)
    func addTaskDidSave(_ controller: UIViewController)
}

class MealAdd: UIViewController {
    
    // MARK: - Instance variables
    weak var delegate: AddMealDelegate?
    var m: DataModelManager!
    
    // MARK: - Outlets (user interface)
    @IBOutlet weak var mealName: UITextField!
    @IBOutlet weak var mealLocName: UITextField!
    @IBOutlet weak var errorMessage: UILabel!
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        errorMessage.text?.removeAll()
        super.viewDidLoad()
    }
    
    // Make the first/desired text field active and show the keyboard
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mealName.becomeFirstResponder()
    }
    
    // MARK: - Actions (user interface)
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // Call into the delegate
        print("Hi")
        delegate?.addTaskDidCancel(self)
        dump(delegate)
        print("ok")
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        view.endEditing(false)
        errorMessage.text?.removeAll()
        
        // Validate the data before saving
        
        if mealName.text!.isEmpty {
            errorMessage.text = "Name cannot be blank."
            return
        }
        
        if mealLocName.text!.isEmpty {
            errorMessage.text = "Location name cannot be blank."
            return
        }
        
        // If we are here, the data passed the validation tests
        
        // Tell the user what we're doing
        errorMessage.text = "Attempting to save..."
        
        // Make an object, configure and save
        if let newItem = m.meal_CreateItem() {
            
            newItem.name = mealName.text
            newItem.locName = mealLocName.text
            m.ds_save()
        }
        
        // Call into the delegate
        delegate?.addTaskDidSave(self)
    }

}
