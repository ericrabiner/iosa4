//
//  MealAdd.swift
//  FoodDiary
//
//  Created by eric on 2019-11-22.
//  Copyright © 2019 SICT. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

protocol AddMealDelegate: AnyObject {
    func addTaskDidCancel(_ controller: UIViewController)
    func addTaskDidSave(_ controller: UIViewController)
}

class MealAdd: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {
    
    // MARK: - Instance variables
    weak var delegate: AddMealDelegate?
    var m: DataModelManager!

    var locationManager = CLLocationManager()
    var location: CLLocation?
    var locationRequests: Int = 0
    var geocoder = CLGeocoder()
    var placemark: CLPlacemark?
    var placemarkText = "(location not available)"
    
    // MARK: - Outlets (user interface)
    @IBOutlet weak var mealName: UITextField!
    @IBOutlet weak var mealLocName: UITextField!
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var mealNotes: UITextField!
    @IBOutlet weak var imageContent: UIImageView!
    @IBOutlet weak var mealLat: UILabel!
    @IBOutlet weak var mealLong: UILabel!
    @IBOutlet weak var mealAddr: UITextView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        errorMessage.text?.removeAll()
        mealName.delegate = self
        mealLocName.delegate = self
        mealNotes.delegate = self
        super.viewDidLoad()
    }
    
    // Make the first/desired text field active and show the keyboard
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mealName.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        mealName.resignFirstResponder()
        mealLocName.resignFirstResponder()
        mealNotes.resignFirstResponder()
        return true
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
            newItem.photo = imageContent.image!.pngData()
            newItem.notes = mealNotes.text
            newItem.date = Date()
            newItem.locLat = Float(location?.coordinate.latitude ?? 0)
            newItem.locLong = Float(location?.coordinate.longitude ?? 0)
            m.ds_save()
        }
        
        // Call into the delegate
        delegate?.addTaskDidSave(self)
    }
    @IBAction func imageButtonPressed(_ sender: Any) {
        
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
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveLocationPressed(_ sender: Any) {
        mealLat.text = "Latitude: Loading..."
        mealLong.text = "Longitude: Loading..."
        mealAddr.text = "Address: Loading..."
        getLocation()
    }
    
    private func getLocation() {
        
        // These two statements setup and configure the location manager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 10.0
        
        // Determine whether the app can use location services
        let authStatus = CLLocationManager.authorizationStatus()
        
        // If the app user has never been asked before, then ask
        if authStatus == .notDetermined || authStatus == .denied || authStatus == .restricted {
            locationManager.requestWhenInUseAuthorization()
            return
        }
        
        // If the app user has previously denied location services, do this
        if authStatus == .denied || authStatus == .restricted {
            showLocationServicesDeniedAlert()
            return
        }
        
        // If we are here, it means that we can use location services
        // This statement starts updating its location
        locationManager.startUpdatingLocation()
    }
    
    // MARK: - Delegate methods
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        // When location services is requested for the first time,
        // the app user is asked for permission to use location services
        // After the permission is determined, this method is called by the location manager
        
        // If the permission is granted, we want to start updating the location
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }
    
    // Respond to a previously-denied request to use location services
    private func showLocationServicesDeniedAlert() {
        let alert = UIAlertController(title: "Location Services Disabled", message: "Please enable location services for this app in the Settings app.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("\nUnable to use location services: \(error)")
    }
    
    // This is called repeatedly by the iOS runtime,
    // as the location changes and/or the accuracy improves
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // Here is how you can configure an arbitrary limit to the number of updates
        if locationRequests > 1 { locationManager.stopUpdatingLocation() }
        
        // Save the new location to the class instance variable
        location = locations.last!
        
        // Info to the programmer
        print("\nUpdate successful: \(location!)")
        print("\nLatitude \(location?.coordinate.latitude ?? 0)\nLongitude \(location?.coordinate.longitude ?? 0)")
        
        mealLat.text = "Latitude: \(String(format: "%.2f", location?.coordinate.latitude ?? 0))"
        mealLong.text = "Longitude: \(String(format: "%.2f", location?.coordinate.longitude ?? 0))"
        
        // Do the reverse geocode task
        // It takes a function as an argument to completionHandler
        geocoder.reverseGeocodeLocation(location!, completionHandler: { placemarks, error in
            
            // We're looking for a happy response, if so, continue
            if error == nil, let p = placemarks, !p.isEmpty {
                
                // "placemarks" is an array of CLPlacemark objects
                // For most geocoding requests, the array has only one value,
                // so we will use the last (most recent) value
                
                // Format and save the text from the placemark into the class instance variable
                self.placemarkText = self.makePlacemarkText(from: p.last!)
                
                // Info to the display
                self.mealAddr.text = "Address: \(self.placemarkText)"
                
                // Info to the programmer
                print("\n\(self.placemarkText)")
            }
        })
        
        locationRequests += 1
    }
    
    private func makePlacemarkText(from placemark: CLPlacemark) -> String {
        
        var s = ""
        
        if let subThoroughfare = placemark.subThoroughfare {
            s.append(subThoroughfare)
        }
        
        if let thoroughfare = placemark.thoroughfare {
            s.append(" \(thoroughfare)")
        }
        
        if let locality = placemark.locality {
            s.append(", \(locality)")
        }
        
        if let administrativeArea = placemark.administrativeArea {
            s.append(" \(administrativeArea)")
        }
        
        if let postalCode = placemark.postalCode {
            s.append(", \(postalCode)")
        }
        
        if let country = placemark.country {
            s.append(" \(country)")
        }
        
        return s
    }
    
    
}
