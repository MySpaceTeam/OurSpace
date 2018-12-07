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
class MapViewController: UIViewController, CLLocationManagerDelegate {

    // Global MapView
    var mapView: GMSMapView?
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

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
            view = mapView

        }

        self.navigationItem.title = "Add a New Place";

    }
    
    // When implemented a weird bug was done where the map kept refreshing
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        // Get Current Location Value
////        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
//
//        // Show Current Location on Map
////        let camera = GMSCameraPosition.camera(withLatitude: locValue.latitude, longitude: locValue.longitude, zoom: 15.0)
////        // Map View
////        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
////        mapView?.isMyLocationEnabled = true;
////
////        // Set Map View as our App's View
////        view = mapView
//    }
//
    @IBAction func searchButtonPressed(_ sender: UIBarButtonItem) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self

        present(autocompleteController, animated: true, completion: nil)
    }
}

// Google Maps UI Auto Complete
extension MapViewController: GMSAutocompleteViewControllerDelegate {

    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {

        // Save a new favorite place
        let newPlace: FavoritePlace = FavoritePlace(
            place.placeID,
            place.name,
            place.formattedAddress!,
            place.phoneNumber!,
            place.coordinate.longitude,
            place.coordinate.latitude
        )

        // Console Log new Place
        newPlace.printMe()
        
        // Close the autocomplete widget.
        dismiss(animated: true, completion: nil)

        let currentLocation = CLLocationCoordinate2DMake(place.coordinate.latitude, place.coordinate.longitude)

        CATransaction.begin()
        CATransaction.setValue(2, forKey: kCATransactionAnimationDuration)

        mapView?.animate(to: GMSCameraPosition.camera(withTarget: currentLocation, zoom: 15.0))

        CATransaction.commit()


        let marker = GMSMarker(position: currentLocation)
        marker.title = "\(place.name)"
        marker.snippet = "has been added to your favorites!"
        marker.map = mapView

        // Auto Show the Marker
        mapView?.selectedMarker = marker
    }

    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }

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
