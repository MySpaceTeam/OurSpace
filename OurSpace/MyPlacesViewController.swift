//
//  MyPlacesViewController.swift
//  OurSpace
//
//  Created by Robert Quinones on 12/8/18.
//  Copyright © 2018 Tommy Tran. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import UserNotifications

class MyPlacesViewController: UITableViewController, CLLocationManagerDelegate {
    
    // Used to get User Location
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // If User Defaults Stores Array of Places, return, else empty array of favorite places
        if( PlaceUtility.fetch() != nil ) {
            PlaceStore.shared.set(PlaceUtility.fetch()!)
        }
    }
    
    // Reload List on Appear
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
}

// MARK: DataSource
extension MyPlacesViewController {
    
    // Number of Rows Equal to Number of Places Stored
    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PlaceStore.shared.favorite_places.count
    }
    
    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Set Reusable Cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceCell", for: indexPath)
        
        // Get Place
        let place = PlaceStore.shared.favorite_places[indexPath.row]
        
        // Number of total lines for textLabel and subtitle Label
        cell.textLabel?.numberOfLines = 3
        cell.detailTextLabel?.numberOfLines = 3
    
        // Cell Label and Subtitle Label
        cell.textLabel?.text = place.name
        cell.detailTextLabel?.text = "Address: \(place.address ?? "")\nPhone Number: \(place.phone ?? "")"
        
        return cell
    }
    
    // Select - Open in Google Maps if available
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if( UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!) ) {
            // Google Maps is installed on the phone
            // Get Place of Row Clicked
            let place = PlaceStore.shared.favorite_places[indexPath.row]
            
            // Get User Location - Same as MapViewController
            if CLLocationManager.locationServicesEnabled() {
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                locationManager.requestAlwaysAuthorization()
                locationManager.requestWhenInUseAuthorization()
                locationManager.startUpdatingLocation()
                
                // Get Current Location Value
                guard let locValue: CLLocationCoordinate2D = locationManager.location?.coordinate else { return }
                
                // Replace spaces with +'s to adhere to GMS standards
                let placeName : String = place.name!.replacingOccurrences(of: " ", with: "+")
                
                // URL - Starting Location = User's Current Location, Ending Location - FavoritePlace
                let url = URL(string: "comgooglemaps://?saddr=\(locValue.latitude),\(locValue.longitude)&daddr=\(placeName)&directionsmode=driving")!
                
                // Open Google Maps App
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        } else {
            
            // Pop Up Alert stating that Google Maps cannot be opened on the phone
            let alert = UIAlertController(title: "Unable to open Google Maps", message: "Please install Google Maps from the App Store in order to use this feature.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
        }

    }
    
    // Remove Row by swiping
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // Create Contextual Action
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (action, sourceView, completionHandler) in
            
            // Remove the place from the array
            PlaceStore.shared.remove(at: indexPath.row)
            
            // Reload table view
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            // Save new array in User Defaults
            PlaceUtility.save(PlaceStore.shared.favorite_places)
            
            // Show Action was performed
            completionHandler(true)
        }
        
        // Show delete trash can, background is red color
        deleteAction.image = UIImage(named: "delete.png")
        deleteAction.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
