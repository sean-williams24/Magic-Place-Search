//
//  PlacesClient.swift
//  Magic Place Search
//
//  Created by Sean Williams on 03/03/2020.
//  Copyright © 2020 Sean Williams. All rights reserved.
//

import Alamofire
import Foundation
import SwiftyJSON

class PlacesClient {
    
    static let basePlaceSearchURL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?"
    static let parameters = "&type=cafe&keyword=food"
    
    class func nearbyPlaceSearch(lat: Double, lon: Double, radius: Double = 1000, completion: @escaping ([Place]?) -> Void) {
        var places: [Place] = []
        let location = "location=\(lat),\(lon)"
        let url = PlacesClient.basePlaceSearchURL + location + "&radius=\(radius)" + parameters + "&key=" + Auth.key
        
        AF.request(url).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)

                if json["status"] == "ZERO_RESULTS" {
                    completion(nil)
                }
                
                for (key, subjson):(String, JSON) in json["results"] {
                    if let resultDict = subjson.dictionaryObject {
                        if let place = Place(result: resultDict) {
                            places.append(place)
                        }
                    }
                    
                    if Int(key) == json["results"].count - 1 {
                        completion(places)
                    }
                }
                
            case .failure(let error):
                print(error)
                completion(nil)
            }
        }
    }
}
