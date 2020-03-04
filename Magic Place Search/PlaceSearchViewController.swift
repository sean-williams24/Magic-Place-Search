//
//  PlaceSearchViewController.swift
//  Magic Place Search
//
//  Created by Sean Williams on 03/03/2020.
//  Copyright © 2020 Sean Williams. All rights reserved.
//

import Alamofire
import SwiftyJSON
import UIKit

class PlaceSearchViewController: UIViewController {
    
    // MARK: - Outlets
    
    let apiKey = "AIzaSyC8RiT2xTPcuMLY4xA_mnxpf-8-sgpCbVw"
    let paidApiKey = "AIzaSyB5V9Bfv5eUU_66A85Yb8WpftWshEJutQY"
    let basePlaceSearchURL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?"
    let radius = "&radius=20000"
    let type = "&type=cafe"
    let keyword = "&keyword=surf"
    var location = ""
    var places: [Place] = []
    
    // MARK: - Properties
    
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let lat = 34.052235
        let lon = -118.243683
        location = "location=\(lat),\(lon)"
        
        let url = basePlaceSearchURL + location + radius + type + keyword + "&key=" + paidApiKey
        
        AF.request(url).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                for (_, subjson):(String, JSON) in json["results"] {
                    if let resultDict = subjson.dictionaryObject {
                        if let place = Place(result: resultDict) {
                            self.places.append(place)
                            debugPrint(place.name)
                            debugPrint(place.rating)
                            debugPrint(place.openingHours)
                        }
                    }
                }
                
            case .failure(let error):
                print(error)
            }

        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    
    // MARK: - Location Methods
    
    
    
    // MARK: - Private Methods
    
    
    
    // MARK: - Navigation
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    
    // MARK: - Action Methods
    
    
}


// MARK: - Extensions





