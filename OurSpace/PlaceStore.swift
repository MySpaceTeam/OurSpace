//
//  PlaceStore.swift
//  OurSpace
//
//  Created by Robert Quinones on 12/8/18.
//  Copyright © 2018 Tommy Tran. All rights reserved.
//
// Handles all saved favorite places

import Foundation

class PlaceStore {
    // Static singleton between views
    static let shared = PlaceStore()
    
    private(set) var favorite_places = [FavoritePlace]()
    
    // Add places
    func add(_ new_place: FavoritePlace) {
        self.favorite_places.append(new_place)
    }
    
    // Remove Places
    func remove(at index: Int) {
        self.favorite_places.remove(at: index)
    }
    
    // Set
    func set(_ places: [FavoritePlace]) {
        self.favorite_places = places
    }
    
    // Contains
    func contains(_ placeID: String) -> Bool {
        
        for place in self.favorite_places {
            if( place.id == placeID ) {
                return true
            }
        }
        
        return false
    }
}
