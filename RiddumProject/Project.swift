//
//  Project.swift
//  RiddumProject
//
//  Created by Med Kaikai on 2017-10-29.
//  Copyright © 2017 MedKaikai. All rights reserved.
//

import UIKit
import Firebase

struct Project {
    
    var name: String!
    var imageUrl: String!
    
    init(name: String, image_url: String) {
        self.name = name
        self.imageUrl = image_url
    }
    
    init(snapshot: FIRDataSnapshot) {
        
        let snapshotValue = snapshot.value as! [String : AnyObject]
        
        name = snapshotValue["name"] as! String
        imageUrl = snapshotValue["image_url"] as! String
    }
}
