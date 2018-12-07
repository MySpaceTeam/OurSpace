//
//  LocationStorage.swift
//  OurSpace
//
//  Created by Robert Quinones on 12/4/18.
//  Copyright © 2018 Tommy Tran. All rights reserved.
//

import Foundation
import CoreLocation

// A Singleton
// Saves locations in our App's Documents folder

class LocationsStorage {
    static let shared = LocationsStorage()
    
    // Helps access all logged locations
    private(set) var locations: [Location]
    
    // Helps read and write from the disk
    private let fileManager: FileManager
    private let documentsURL: URL
    
    init() {
        let fileManager = FileManager.default
        documentsURL = try! fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        self.fileManager = fileManager
        
        let jsonDecoder = JSONDecoder()
        
        // 1 - GET URLs for all files in the App's Documents Folder
        let locationFilesURLs = try! fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
        
        locations = locationFilesURLs.compactMap { url -> Location? in
            
            // 2 - Skip the .DS_Store File
            guard !url.absoluteString.contains(".DS_Store") else {
                return nil
            }
            
            // 3 - Read the data from the file
            guard let data = try? Data(contentsOf: url) else {
                return nil
            }
            
            // 4 - Decode the raw data into Location objects using Codable
            return try? jsonDecoder.decode(Location.self, from: data)
            
            // 5 - Sort Locations by Date
            }.sorted(by: { $0.date < $1.date })
        
    }
    
    // Persisting Location Data
    func saveLocationOnDisk(_ location: Location) {
        // 1 - Create JSONEnconder.
        let encoder = JSONEncoder()
        let timestamp = location.date.timeIntervalSince1970
        
        // 2 - Get the URL to file; for the file name, you use a date timestamp.
        let fileURL = documentsURL.appendingPathComponent("\(timestamp)")
        
        // 3 - Convery the location object to raw data.
        let data = try! encoder.encode(location)
        
        // 4 - Write data to the file.
        try! data.write(to: fileURL)
        
        // 5 - Add the saved location to the local array.
        locations.append(location)
    }
    
    // Here, we create a Location object from clLocation, the current date and the location
    // description from geoCoder. Save the location as we did before ( saveLocationOnDisk )
    func saveCLLocationToDisk(_ clLocation: CLLocation) {
        let currentDate = Date()
        AppDelegate.geoCoder.reverseGeocodeLocation(clLocation) { placemarks, _ in
            if let place = placemarks?.first {
                let location = Location(clLocation.coordinate, date: currentDate, descriptionString: "\(place)")
                self.saveLocationOnDisk(location)
                
                // Show Notification on App that place has been added
                NotificationCenter.default.post(name: .newLocationSaved, object: self, userInfo: ["location": location])
            }
        }
    }
    
}

// Used for Internal Notification when a location is saved
extension Notification.Name {
    static let newLocationSaved = Notification.Name("newLocationSaved")
}
