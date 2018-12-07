//
//  PlacesTableViewController.swift
//  OurSpace
//
//  Created by Robert Quinones on 12/4/18.
//  Copyright © 2018 Tommy Tran. All rights reserved.
//

import UIKit
import UserNotifications

// This is the first Tab of the App - The List that shows our Places

class PlacesTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1 - Register a method to be called when your notofication arrives
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(newLocationAdded(_:)),
            name: .newLocationSaved,
            object: nil)
    }
    
    // 2 - Receive the notification as a parameter
    @objc func newLocationAdded(_ notification: Notification) {
        // 3 - Reload our list view
        tableView.reloadData()
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LocationsStorage.shared.locations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceCell", for: indexPath)
        let location = LocationsStorage.shared.locations[indexPath.row]
        cell.textLabel?.numberOfLines = 3
        cell.textLabel?.text = location.description
        cell.detailTextLabel?.text = location.dateString
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
}
