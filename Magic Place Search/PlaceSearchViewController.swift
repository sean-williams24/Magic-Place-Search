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
    @IBOutlet weak var mapView: MKMapView!
    
    
    // MARK: - Properties
    

    var places: [Place] = []
    let LA = "location=\(34.052235),\(-118.243683)"
    var locationManager: CLLocationManager!

    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    
    // MARK: - Location Methods
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let userLocation = locations.first else { return }
        let lat = userLocation.coordinate.latitude
        let lon = userLocation.coordinate.longitude
        
        locationManager.stopUpdatingLocation()
        places = []
        
        PlacesClient.nearbyPlaceSearch(lat: lat, lon: lon) { places in
            let vc = self.storyboard?.instantiateViewController(identifier: "ResultsVC") as! ResultsTableViewController
            if let places = places {
                vc.places = places
            }
            self.present(vc, animated: true)
        }

    }
    
    
    // MARK: - Private Methods
    
    
    
    // MARK: - Navigation
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
    
    
    // MARK: - Action Methods
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        guard let lat = latTextfield.text, let lon = lonTextfield.text else {
            print("Incorrect lat and lon")
            // show alert
            
            return
        }
        
//        places = []
//        location = "location=\(lat),\(lon)"
//        let url = basePlaceSearchURL + LA + radius + type + keyword + "&key=" + Auth.key
        let url = ""
        AF.request(url).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                for (key, subjson):(String, JSON) in json["results"] {
                    if let resultDict = subjson.dictionaryObject {
                        if let place = Place(result: resultDict) {
                            self.places.append(place)
                        }
                    }
                    
                    if Int(key) == json["results"].count - 1 {
                        let vc = self.storyboard?.instantiateViewController(identifier: "ResultsVC") as! ResultsTableViewController
                        vc.places = self.places
                        self.present(vc, animated: true)
                    }
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    @IBAction func useCurrentLocationTapped(_ sender: Any) {

        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
        
    }
    
    
    
    @IBAction func mapSearchTapped(_ sender: Any) {
    }
    
}


// MARK: - Extensions





