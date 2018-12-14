//
//  ProfleViewController.swift
//  OurSpace
//
//  Created by Tommy Tran on 12/13/18.
//  Copyright © 2018 Tommy Tran. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth

class ProfileViewController: UIViewController{
    
    @IBOutlet weak var profileEmail: UILabel!
    
    @IBOutlet weak var placeCount: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user = Auth.auth().currentUser
        if let user = user {
            // The user's ID, unique to the Firebase project.
            // Do NOT use this value to authenticate with your backend server,
            // if you have one. Use getTokenWithCompletion:completion: instead.
            let email = user.email
            profileEmail.text = email
            let count = String (PlaceStore.shared.favorite_places.count)
            placeCount.text! = count

            
            //let photoURL = user.photoURL
            
            
            
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        let count = String (PlaceStore.shared.favorite_places.count)
        placeCount.text! = count
    }
    
    
}
