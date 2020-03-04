//
//  PlacesClient.swift
//  Magic Place Search
//
//  Created by Sean Williams on 03/03/2020.
//  Copyright © 2020 Sean Williams. All rights reserved.
//

import Alamofire
import Foundation


class PlacesClient {
    
    
    enum Endpoints {
        
        static let basefindPlace = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?"
        
        case nearbySearch
        
        var stringValue: String {
            switch self {
            case .nearbySearch: return Endpoints.basefindPlace
            
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
        
    }
}
