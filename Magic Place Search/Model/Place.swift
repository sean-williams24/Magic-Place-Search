//
//  Place.swift
//  Magic Place Search
//
//  Created by Sean Williams on 03/03/2020.
//  Copyright © 2020 Sean Williams. All rights reserved.
//

import Foundation

struct Place {
    let name: String
    let rating: Double
    let openingHours: [String: Bool]?
    
    
    init?(result: [String: Any]) {
        self.name = result["name"] as! String
        self.rating = result["rating"] as! Double
        self.openingHours = result["opening_hours"] as? [String: Bool]
    }
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case rating = "rating"
        case openingHours = "opening_hours"
    }
}

struct OpeningHours {
    let openNow: Bool
    
    enum CodingKeys: String, CodingKey {
        case openNow = "open_now"
    }
}
