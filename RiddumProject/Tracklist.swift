//
//  Tracklist.swift
//  RiddumProject
//
//  Created by Med Kaikai on 28/02/2018.
//  Copyright © 2018 MedKaikai. All rights reserved.
//

import UIKit
import Firebase

struct Tracklist {
    
    var trackTitle: String!
    var trackURL: String!
    
    init(title: String, url: String) {

        
        self.trackTitle = title
        self.trackURL = url
    }
    
    init(snapshot: FIRDataSnapshot) {
        
        let snapshotValue = snapshot.value as! [String : AnyObject]
        
        trackTitle = snapshotValue["title"] as? String
        trackURL = snapshotValue["url"] as? String
    }
}
