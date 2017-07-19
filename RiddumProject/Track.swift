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
    var image_url: String!
    var url: String!
    var likes: Int!
    
    var likedBy: [String] = [String]()
    
    init(title: String, artist: String, image_url: String, url: String) {
        self.title = title
        self.artist = artist
        self.image_url = image_url
        self.url = url
    }
    
    init(snapshot: FIRDataSnapshot) {
        
        let snapshotValue = snapshot.value as! [String : AnyObject]
        
        title = snapshotValue["title"] as! String
        artist = snapshotValue["artist"] as! String
        image_url = snapshotValue["image_url"] as! String
        url = snapshotValue["url"] as! String
        
        
    }
    
}
