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
    
    var artist: String!
    var imageUrl: String!
    var projectTitle: String!
    

    
    init(project_artist: String, project_image_url: String, project_title: String) {
        self.artist = project_artist
        self.imageUrl = project_image_url
        self.projectTitle = project_title
        

    }
    
    init(snapshot: FIRDataSnapshot) {
        
        let snapshotValue = snapshot.value as! [String : AnyObject]
        
        artist = snapshotValue["project_artist"] as? String
        imageUrl = snapshotValue["project_image_url"] as? String
        projectTitle = snapshotValue["project_title"] as? String
        

    }
}
