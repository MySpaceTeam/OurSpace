//
//  PlaceUtility.swift
//  OurSpace
//
//  Created by Robert Quinones on 12/9/18.
//  Copyright © 2018 Tommy Tran. All rights reserved.
//
// Help us archive, fetch, and save favorite places

import Foundation

class PlaceUtility {
    
    private static let key = "favorite_places"
    
    // Archive
    private static func archive(_ favorite_places: [FavoritePlace]) -> NSData {
        var returnData: NSData?
        
        do {
            returnData = try NSKeyedArchiver.archivedData(withRootObject: favorite_places, requiringSecureCoding: false ) as NSData
        } catch {
            print(error.localizedDescription)
        }
        
        return returnData!
    }
    
    // Fetch - Returns the Favorite Places Array
    static func fetch() -> [FavoritePlace]? {
        guard let unarchivedData = UserDefaults.standard.object(forKey: key) as? Data else { return nil }
        
        var returnData: [FavoritePlace]?
        
        do {
            returnData = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(unarchivedData) as? [FavoritePlace]
            
        } catch {
            print(error.localizedDescription)
        }
        
        return returnData
    }
    
    // Save
    static func save(_ favorite_places: [FavoritePlace]) {
        
        // Archive the Data
        let archivedTasks = archive(favorite_places)
        
        // Set up object for key - matches key in fetch method
        UserDefaults.standard.set(archivedTasks, forKey: key)
        
        // Write UserDefaults to disk immediately
        UserDefaults.standard.synchronize()
    }
}
