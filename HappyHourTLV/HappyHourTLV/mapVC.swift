//
//  mapVC.swift
//  HappyHourTLV
//
//  Created by Lee Wolf on 23/08/2022.
//

import UIKit
import MapKit
import CoreLocation

class MyAnnotation: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    let title: String?
    let subtitle: String?
    let type: String
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String, type: String) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.type = type
    }
}

class mapVC: UIViewController {

    @IBOutlet weak var map: MKMapView!
    var coordinate2D: CLLocationCoordinate2D?
    var barName: String = "kiryat ono"
    var barAddress: String = "kiryat ono rabin 24"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(barAddress) {
            placemarks, error in
            let placemark = placemarks?.first
            let lat = placemark?.location?.coordinate.latitude
            let lon = placemark?.location?.coordinate.longitude
            self.coordinate2D = CLLocationCoordinate2D(latitude: lat ?? 31.970669, longitude: lon ?? 34.771442)
            
            let region = MKCoordinateRegion(center: self.coordinate2D ?? CLLocationCoordinate2D(), latitudinalMeters: 1000, longitudinalMeters: 1000)
            self.map.setRegion(region, animated: true)
            
            let barLoc = MyAnnotation(coordinate: self.coordinate2D ?? CLLocationCoordinate2D(), title: self.barName, subtitle: self.barAddress, type: "1")
            self.map.addAnnotation(barLoc)
        }
    }

    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
