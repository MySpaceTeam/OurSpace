//
//  Location.swift
//  OurSpace
//
//  Created by Robert Quinones on 12/4/18.
//  Copyright © 2018 Tommy Tran. All rights reserved.
//

import Foundation
import CoreLocation

// Class of a Location

// Codable - Swift feature that allows you to encode/decode objects easily
class Location: Codable {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter
    }()
    
    var coordinates: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    // Positions
    let latitude: Double
    let longitude: Double
    // When the location was logged
    let date: Date
    // Human readable version of the date
    let dateString: String
    // Human readable address
    let description: String
    
    init(_ location: CLLocationCoordinate2D, date: Date, descriptionString: String) {
        latitude =  location.latitude
        longitude =  location.longitude
        self.date = date
        dateString = Location.dateFormatter.string(from: date)
        description = descriptionString
    }
    
    convenience init(visit: CLVisit, descriptionString: String) {
        self.init(visit.coordinate, date: visit.arrivalDate, descriptionString: descriptionString)
    }
}
