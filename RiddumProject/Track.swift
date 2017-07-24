//
//  Track.swift
//  RiddumProject
//
//  Created by Med Kaikai on 2017-07-14.
//  Copyright © 2017 MedKaikai. All rights reserved.
//

import UIKit
import Firebase

struct Track {
    
    var title: String!
    var artist: String!
    var imageUrl: String!
    var url: String!
        
    init(title: String, artist: String, image_url: String, url: String) {
        self.title = title
        self.artist = artist
        self.imageUrl = image_url
        self.url = url
    }
    
    init(snapshot: FIRDataSnapshot) {
        
        let snapshotValue = snapshot.value as! [String : AnyObject]
        
        title = snapshotValue["title"] as! String
        artist = snapshotValue["artist"] as! String
        imageUrl = snapshotValue["image_url"] as! String
        url = snapshotValue["url"] as! String
    }
}
