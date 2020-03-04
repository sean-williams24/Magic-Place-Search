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
    
    @IBOutlet weak var latTextfield: UITextField!
    @IBOutlet weak var lonTextfield: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    
    // MARK: - Properties
    
    let basePlaceSearchURL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?"
    let radius = "&radius=20000"
    let type = "&type=cafe"
    let keyword = "&keyword=surf"
    var location = ""
    var places: [Place] = []
    let LA = "location=\(34.052235),\(-118.243683)"

    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

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
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        guard let lat = latTextfield.text, let lon = lonTextfield.text else {
            print("Incorrect lat and lon")
            // show alert
            
            return
        }
        places = []
        
        location = "location=\(lat),\(lon)"
        
        let url = basePlaceSearchURL + location + radius + type + keyword + "&key=" + Auth.key

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
    
}


// MARK: - Extensions





