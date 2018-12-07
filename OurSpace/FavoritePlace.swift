//
//  Place.swift
//  OurSpace
//
//  Created by Robert Quinones on 12/6/18.
//  Copyright © 2018 Tommy Tran. All rights reserved.
//

import Foundation


class FavoritePlace: NSObject, NSCoding {
        
    // Object Variables
    var id: String?
    var name: String?
    var address: String?
    var phone: String?
    var longitude: Double?
    var latitude: Double?
    
    // UserDefaults Keys
    private let idKey = "id"
    private let nameKey = "name"
    private let addressKey = "address"
    private let phoneKey = "phone"
    private let longitudeKey = "longitude"
    private let latitudeKey = "latitude"

    
    init(_ id: String, _ name: String, _ address: String, _ phone: String, _ longitude: Double, _ latitude: Double) {
        self.id = id
        self.name = name
        self.address = address
        self.phone = phone
        self.longitude = longitude
        self.latitude = latitude
    }
    
    // Development Print
    func printMe() {
        print( "id: \(String(describing: self.id)), name:\(String(describing: self.name)), address:\(String(describing: self.address)), phone: \(String(describing: self.phone)), longitude: \(String(describing: self.longitude)), latitude: \(String(describing: self.latitude))" )
    }
    
    
    // Encode Place Variables
    func encode(with aCoder: NSCoder) {
        aCoder.encode( self.id, forKey: idKey)
        aCoder.encode( self.name, forKey: nameKey)
        aCoder.encode( self.address, forKey: addressKey)
        aCoder.encode( self.phone, forKey: phoneKey)
        aCoder.encode( self.longitude, forKey: longitudeKey)
        aCoder.encode( self.latitude, forKey: latitudeKey)

    }
    
    // Decode Place Variables
    required init?(coder aDecoder: NSCoder) {
        guard let id = aDecoder.decodeObject(forKey: idKey) as? String,
            let name = aDecoder.decodeObject(forKey: nameKey) as? String,
            let address = aDecoder.decodeObject(forKey: addressKey) as? String,
            let phone = aDecoder.decodeObject(forKey: phoneKey) as? String,
            let longitude = aDecoder.decodeObject(forKey: longitudeKey) as? Double,
            let latitude = aDecoder.decodeObject(forKey: latitudeKey) as? Double
            else { return }

        // If successfully reads data from disk, set to object members
        self.id = id
        self.name = name
        self.address = address
        self.phone = phone
        self.longitude = longitude
        self.latitude = latitude
    }
}
