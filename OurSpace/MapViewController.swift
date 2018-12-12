//
//  MapViewController.swift
//  OurSpace
//
//  Created by Robert Quinones on 12/4/18.
//  Copyright © 2018 Tommy Tran. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import UserNotifications


// Google Maps Implementation
class MapViewController: UIViewController, UITabBarControllerDelegate, CLLocationManagerDelegate {

    // Global MapView
    var  mapView: GMSMapView?
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Add a New Place";

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
            
            // Get Current Location Value
            guard let locValue: CLLocationCoordinate2D = locationManager.location?.coordinate else { return }
            
            // Show Current Location on Map
            let camera = GMSCameraPosition.camera(withLatitude: locValue.latitude, longitude: locValue.longitude, zoom: 15.0)
            // Map View
            mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
            mapView?.isMyLocationEnabled = true;
            
            // Set Map View as our App's View
            self.view = mapView
            
            // Load in all the markers
            for( place ) in PlaceStore.shared.favorite_places {
                let currentLocation = CLLocationCoordinate2DMake(place.latitude!, place.longitude!)
                let marker = GMSMarker(position: currentLocation)
                marker.title = place.name
                marker.snippet = place.address
                marker.map = mapView
            }

        }

    }
    
    func tabBar(_ tabBarController: UITabBar, didSelect viewController: UITabBarItem) {
        print("HERE!")
        // Remove all markers on map just in case
        mapView?.clear()
        
        // Get Current Location Value
        guard let locValue: CLLocationCoordinate2D = locationManager.location?.coordinate else { return }
        
        // Show Current Location on Map
        let camera = GMSCameraPosition.camera(withLatitude: locValue.latitude, longitude: locValue.longitude, zoom: 15.0)
        // Map View
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView?.isMyLocationEnabled = true;
        
        // Set Map View as our App's View
        view = mapView
        
        // Load in all the markers
        for( place ) in PlaceStore.shared.favorite_places {
            let currentLocation = CLLocationCoordinate2DMake(place.latitude!, place.longitude!)
            let marker = GMSMarker(position: currentLocation)
            marker.title = place.name
            marker.snippet = place.address
            marker.map = mapView
        }
    }
    
    // Refresh your map
    @IBAction func refreshButtonPressed(_ sender: Any) {
        // Remove all markers on map just in case
        mapView?.clear()

        // Get Current Location Value
        guard let locValue: CLLocationCoordinate2D = locationManager.location?.coordinate else { return }

        // Show Current Location on Map
        let camera = GMSCameraPosition.camera(withLatitude: locValue.latitude, longitude: locValue.longitude, zoom: 15.0)
        // Map View
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView?.isMyLocationEnabled = true;

        // Set Map View as our App's View
        view = mapView

        // Load in all the markers
        for( place ) in PlaceStore.shared.favorite_places {
            let currentLocation = CLLocationCoordinate2DMake(place.latitude!, place.longitude!)
            let marker = GMSMarker(position: currentLocation)
            marker.title = place.name
            marker.snippet = place.address
            marker.map = mapView
        }
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
        present(autocompleteController, animated: true, completion: nil)
    }
    
    
}

// Google Maps UI Auto Complete
extension MapViewController: GMSAutocompleteViewControllerDelegate {

    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        // Save off  a New Place
        let newPlace: FavoritePlace = FavoritePlace(
            place.placeID,
            place.name,
            String(place.formattedAddress ?? "N/A"),
            String(place.phoneNumber ?? "N/A"),
            place.coordinate.longitude,
            place.coordinate.latitude
        )
        
        // See if Place is already a Favorite
        if( PlaceStore.shared.contains( newPlace.id! ) ) {
            
            // Dismiss Google Maps Search Bar
            dismiss(animated: true, completion: nil)

            // Pop Up Alert stating that Favorite Place Already Exists, add a different one
            let alert = UIAlertController(title: "Already a Favorite Place", message: "\(place.name) is already a favorite. Try adding a different place!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
            
        } else {

            // Save the new place to PlaceStore for UI
            PlaceStore.shared.add(newPlace)
            
            // Save to User Defaults
            PlaceUtility.save(PlaceStore.shared.favorite_places)
            
            // Close the autocomplete widget.
            dismiss(animated: true, completion: nil)
            
            // Get User's Location
            let currentLocation = CLLocationCoordinate2DMake(place.coordinate.latitude, place.coordinate.longitude)
            
            // Animate to new Location
            CATransaction.begin()
            CATransaction.setValue(1, forKey: kCATransactionAnimationDuration)
            
            mapView?.animate(to: GMSCameraPosition.camera(withTarget: currentLocation, zoom: 15.0))
            
            CATransaction.commit()
            
            // Ser new marker
            let marker = GMSMarker(position: currentLocation)
            marker.title = place.name
            marker.snippet = "has been added to your favorites!"
            marker.map = mapView
            
            // Auto Show the Marker
            mapView?.selectedMarker = marker
        }
    }

    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }

    // Cancel Button on Search was hit
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }

    // Show the network activity indicator.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }

    // Hide the network activity indicator.
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }

}
