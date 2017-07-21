//
//  UserCell.swift
//  RiddumProject
//
//  Created by Med Kaikai on 2017-04-10.
//  Copyright © 2017 MedKaikai. All rights reserved.
//

import UIKit
import Firebase

class TrackCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var unlikeButton: UIButton!
    
    var userID: String!
}
