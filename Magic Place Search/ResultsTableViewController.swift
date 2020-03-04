//
//  ResultsTableViewController.swift
//  Magic Place Search
//
//  Created by Sean Williams on 04/03/2020.
//  Copyright © 2020 Sean Williams. All rights reserved.
//

import UIKit

class ResultsTableViewController: UITableViewController {
    
    var places: [Place] = []


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return places.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 3
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "placeCell", for: indexPath) as! PlaceTableViewCell
        let place = places[indexPath.section]
        
        cell.titleLabel.text = place.name.uppercased()
        cell.ratingLabel.text = "\(place.rating) / 5"
        
        if let openingHours = place.openingHours {
            if let openNow = openingHours["open_now"] {
                if openNow {
                    cell.openingHoursLabel.text = "Open Now"
                    cell.openingHoursLabel.textColor = .green
                } else {
                    cell.openingHoursLabel.text = "Currently Closed"
                    cell.openingHoursLabel.textColor = .red
                }
            }
        } else {
            cell.openingHoursLabel.isHidden = true
        }

        return cell
    }
}
