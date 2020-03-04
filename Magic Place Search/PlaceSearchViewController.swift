//
//  PlaceSearchViewController.swift
//  Magic Place Search
//
//  Created by Sean Williams on 03/03/2020.
//  Copyright © 2020 Sean Williams. All rights reserved.
//

import Alamofire
import MapKit
import SwiftyJSON
import UIKit

class PlaceSearchViewController: UIViewController, CLLocationManagerDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var latTextfield: UITextField!
    @IBOutlet weak var lonTextfield: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var currentLocationButton: UIButton!
    @IBOutlet weak var mapSearchButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    
    // MARK: - Properties
    
    let LA = "location=\(34.052235),\(-118.243683)"
    var locationManager: CLLocationManager!
    var userLocation: CLLocation!

    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchButton.layer.cornerRadius = 25
        searchButton.layer.borderWidth = 1
        currentLocationButton.layer.cornerRadius = 25
        currentLocationButton.layer.borderWidth = 1
        mapSearchButton.layer.cornerRadius = 25
        mapSearchButton.layer.borderWidth = 1
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
    }
    
    
    // MARK: - Location Methods
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        userLocation = location
        mapView.setCenter(userLocation.coordinate, animated: true)

        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .denied, .restricted:
            showAlert(title: "Location not authorized", message: "You won't be able to search using your location. You can turn this back on in the Apple Settings app.")
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        
        case .notDetermined:
            print("Not determined")
            
        @unknown default:
              break
        }
    }
    
    
    // MARK: - Private Methods
    
    func handleSearchCompletion(places: [Place]?) {
        guard places != nil else {
            showAlert(title: "Hmm?", message: "Apologies, we couldn't find any places. Try searching a different location or expanding your search criteria.")
            return
        }
        
        let vc = self.storyboard?.instantiateViewController(identifier: "ResultsVC") as! ResultsTableViewController
        if let places = places {
            vc.places = places
        }
        self.show(vc, sender: self)
    }
    
    
    func showAlert(title: String, message: String?) {
        DispatchQueue.main.async {
            let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(ac, animated: true)
        }
    }
    

    // MARK: - Action Methods
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        guard latTextfield.text != "", lonTextfield.text != "" else {
            showAlert(title: "Oh no!", message: "That didn't seem to work, make sure you're using the correct format for latitude and longitude.")
            return
        }
        
        view.endEditing(true)
        let lat = latTextfield.text!
        let lon = lonTextfield.text!        
        
        let coordinate = CLLocationCoordinate2D(latitude: Double(lat)!, longitude: Double(lon)!)
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 4000, longitudinalMeters: 4000)
        mapView.setRegion(region, animated: true)
        
        PlacesClient.nearbyPlaceSearch(lat: Double(lat)!, lon: Double(lon)!, completion: handleSearchCompletion(places:))
        
    }
    
    
    @IBAction func useCurrentLocationTapped(_ sender: Any) {
        guard CLLocationManager.authorizationStatus() == .authorizedWhenInUse else {
            showAlert(title: "Location Services Disabled", message: "Please turn on location services in Apple's Settings app to enable this feature")
            return
        }
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
        
        let lat = userLocation.coordinate.latitude
        let lon = userLocation.coordinate.longitude
    
        PlacesClient.nearbyPlaceSearch(lat: lat, lon: lon, completion: handleSearchCompletion(places:))

    }
    
    
    
    @IBAction func mapSearchTapped(_ sender: Any) {
        
        let lat = mapView.centerCoordinate.latitude
        let lon = mapView.centerCoordinate.longitude
        
        let mapRect = mapView.visibleMapRect
        let westMapPoint = MKMapPoint(x: mapRect.minX, y: mapRect.midY)
        let eastMapPoint = MKMapPoint(x: mapRect.maxX, y: mapRect.midY)
        let distance = westMapPoint.distance(to: eastMapPoint)
        
        PlacesClient.nearbyPlaceSearch(lat: lat, lon: lon, radius: distance, completion: handleSearchCompletion(places:))
    }
}


