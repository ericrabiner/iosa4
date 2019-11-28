import UIKit
import MapKit

protocol ShowMapDelegate: class {
    func showMapDone(_ controller: UIViewController)
}

// Must adopt the MKMapViewDelegate protocol
class MealMap: UIViewController, MKMapViewDelegate {
    
    // MARK: - Instance variables
    var m: DataModelManager!
    var mealItem: Meal!
    weak var delegate: ShowMapDelegate?
    
    var locationManager = CLLocationManager()
    var location: CLLocation?
    var locationRequests: Int = 0
    var geocoder = CLGeocoder()
    var placemark: CLPlacemark?
    var placemarkText = "(location not available)"
    
    // User location titles
    var userLocationTitle: String?
    var userLocationSubtitle: String?
    
    // Map annotations (pins)
    var mapAnnotations = [MapAnnotation]()
    
    // MARK: - Outlets (user interface)
    @IBOutlet weak var locationMap: MKMapView!
    @IBOutlet weak var mealLat: UILabel!
    @IBOutlet weak var mealLong: UILabel!
    @IBOutlet weak var mealAddr: UITextView!
  
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        if mealItem.locLong != 0 && mealItem.locLat != 0 {
            mealLat.text = "Latitude: \(String(format: "%.2f", mealItem.locLat))"
            mealLong.text = "Latitude: \(String(format: "%.2f", mealItem.locLong))"
            mealAddr.text = "Address: Loading..."
            self.location = CLLocation(latitude: CLLocationDegrees(mealItem!.locLat), longitude: CLLocationDegrees(mealItem!.locLong))
    
            geocoder.reverseGeocodeLocation(location!, completionHandler: { placemarks, error in
                if error == nil, let p = placemarks, !p.isEmpty {
                    self.placemarkText = self.makePlacemarkText(from: p.last!)
                    self.mealAddr.text = "Address: \(self.placemarkText)"
                }
            })
            
            let region = MKCoordinateRegion.init(center: CLLocationCoordinate2D(latitude: CLLocationDegrees(mealItem!.locLat), longitude: CLLocationDegrees(mealItem!.locLong)), latitudinalMeters: 2000, longitudinalMeters: 2000)
            locationMap.setRegion(region, animated: true)
            locationMap.addAnnotations(mapAnnotations)
   
        }
        else {
            mealAddr.text = "Address: unavailable"
            mealLat.text = "Latitude: unavailable"
            mealLong.text = "Latitude: unavailable"
        }

        locationMap.delegate = self
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

    // MARK: - Actions (user interface)
    
    // This controller's scene has a nav bar button "Done"
    @IBAction func done(_ sender: UIBarButtonItem) {
        delegate?.showMapDone(self)
    }
    
}

// Defines a map annotation object
class MapAnnotation: NSObject, MKAnnotation {
    // Initializer
    init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
    // This property must be key-value observable, which the "`"@objc dynamic"`" attributes provide.
    @objc dynamic var coordinate = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    
    var title: String?
    var subtitle: String?
}
