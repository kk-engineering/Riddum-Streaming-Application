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
    
    
//    @IBAction func likePressed(_ sender: Any) {
//        self.likeButton.isEnabled = false
//        let ref = FIRDatabase.database().reference()
//        let likedByKey = ref.child("tracks").childByAutoId().key
//        
//        ref.child("tracks").observeSingleEvent(of: .value, with: { (snapshot) in
//            if let trackPost = snapshot.value as? [String : AnyObject] {
//                let updateLikes: [String : Any] = ["likedBy/\(likedByKey)" : FIRAuth.auth()!.currentUser!.uid]
//                ref.child("tracks").updateChildValues(updateLikes, withCompletionBlock: { (error, reff) in
//                    if error == nil {
//                        ref.child("tracks").observeSingleEvent(of: .value, with: { (snap) in
//                            if let trackPostProperties = snap.value as? [String : AnyObject] {
//                                if let likes = trackPostProperties["likedBy"] as? [String : AnyObject] {
//                                    let count = likes.count
//                                    self.likesLabel.text = "\(count) Likes"
//                                    
//                                    let update = ["likes" : count]
//                                    ref.child("tracks").updateChildValues(update)
//                                    
//                                    self.likeButton.isHidden = true
//                                    self.unlikeButton.isHidden = false
//                                    self.likeButton.isEnabled = true
//                                }
//                            }
//                        })
//                    }
//                })
//            }
//        })
//        ref.removeAllObservers()
//    }
//    
//    @IBAction func unlikePressed(_ sender: Any) {
//        self.unlikeButton.isEnabled = false
//        let ref = FIRDatabase.database().reference()
//        
//        ref.child("tracks").observeSingleEvent(of: .value, with: { (snapshot) in
//            if let trackPostProperties = snapshot.value as? [String : AnyObject] {
//                if let LikedBy = trackPostProperties["likedBy"] as? [String : AnyObject] {
//                    for (id, person) in LikedBy {
//                        if person as? String == FIRAuth.auth()!.currentUser!.uid {
//                            ref.child("tracks").child("likedBy").child(id).removeValue(completionBlock: { (error, reff) in
//                                if error == nil {
//                                    ref.child("tracks").observeSingleEvent(of: .value, with: { (snap) in
//                                        if let trackPostProp = snap.value as? [String : AnyObject] {
//                                            if let likes = trackPostProp["likedBy"] as? [String : AnyObject] {
//                                                let count = likes.count
//                                                self.likesLabel.text = "\(count) Likes"
//                                                ref.child("tracks").updateChildValues(["likes" : count])
//                                            } else {
//                                                self.likesLabel.text = "0 Likes"
//                                                ref.child("tracks").updateChildValues(["likes" : 0])
//                                            }
//                                        }
//                                    })
//                                }
//                            })
//                            
//                            
//                            self.likeButton.isHidden = true
//                            self.unlikeButton.isHidden = false
//                            self.unlikeButton.isEnabled = true
//                            break
//                        }
//                    }
//                }
//            }
//        })
//        ref.removeAllObservers()
//    }
}
