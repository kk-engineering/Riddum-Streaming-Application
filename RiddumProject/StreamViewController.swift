//
//  StreamViewController.swift
//  RiddumProject
//
//  Created by Mohamed Kaikai on 2017-04-22.
//  Copyright © 2017 MedKaikai. All rights reserved.
//

import UIKit
import Firebase
import AVKit
import AVFoundation

class StreamViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var posts = [Post]()
    var player = AVPlayer()
    var counter = 0
    var trackInfo = [Post]()
    let track:[String] = ["01. Shutdown", "02. Good Times", "03. Way Too Much", "04. Ace Hood Flow", "05. It Aint Safe", "06. Nasty", "07. Red Eye To Paris", "08. My Crew", "09. Back Then", "10. Same Shit Different Day", "11. Simple Life", "12. Castles", "13. Lukey World", "14. Ojuelegba", "15. Thats Not Me", "16. Frisco", "17. Supposed to Do", "18. Top Boy", "19. Westwood Freestyle"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        loadTracks()
    }

    //New Code
    func loadTracks() {
        

        let trackURL = FIRStorage.storage().reference(forURL: "gs://riddum-streaming-app.appspot.com/").child("tracks/\(track[counter]).mp3")
        
        
        trackURL.downloadURL(completion: { (url, error) in
            
            if error != nil {
                print(error!.localizedDescription)
                return
            } else {
                
                // Create an AVPlayer, passing it the HTTP Live Streaming URL.
                self.player = AVPlayer(url: url! as URL)
                self.player.play()
                
            }
        })
        

        
        
        
        //Get Metadata
        trackURL.metadata { (metadata, error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            } else {
                print(metadata!)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EEE, dd MMM yyyy"
                let trackCreated = metadata!.timeCreated
                print(dateFormatter.string(from: trackCreated!))
                
            }
        }
        self.collectionView.reloadData()
        
        
    }
    
    
    
    func fetchPosts() {
        
        let ref = FIRDatabase.database().reference()
        
            ref.child("posts").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snap) in
                
                let postsSnap = snap.value as! [String : AnyObject]
                
                for (_, post) in postsSnap {
                    if let userID = post["userID"] as? String {
                        let posst = Post()
                        if let author = post["author"] as? String, let likes = post["likes"] as? Int, let pathToImage = post["pathToImage"] as? String, let postID = post["postID"] as? String {
                            
                            posst.author = author
                            posst.likes = likes
                            posst.pathToImage = pathToImage
                            posst.postID = postID
                            posst.userID = userID
                            if let people = post["LikedBy"] as? [String : AnyObject] {
                                for (_,person) in people {
                                    posst.likedBy.append(person as! String) 
                                }
                            }
                            
                            self.posts.append(posst)
                        }
                    }
                }
                
                
                
                self.collectionView.reloadData()
            })
            ref.removeAllObservers()
    }
    


    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.track.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as! PostCell
        
        
//        cell.postImage.downloadImage(from: self.posts[indexPath.row].pathToImage)
//        cell.authorLabel.text = self.posts[indexPath.row].author
//        cell.likesLabel.text = "\(self.posts[indexPath.row].likes!) Likes"
//        cell.postID = self.posts[indexPath.row].postID
//        
//        for person in self.posts[indexPath.row].likedBy {
//            if person == FIRAuth.auth()!.currentUser?.uid {
//                cell.likeButton.isHidden = true
//                cell.unlikeButton.isHidden = false
//                break
//            }
//        }
//        
//        return cell
        ////////////////////////
        
        let storage = FIRStorage.storage()
        let storageRef = storage.reference()
        
        let coverArt = storageRef.child("tracks/cover.jpg")
        
        coverArt.downloadURL(completion: { (urll, err) in
            if err != nil {
                print(err!.localizedDescription)
                return
            }
            
            URLSession.shared.dataTask(with: urll!, completionHandler: { (data, response, err) in
                
                if err != nil {
                    print(err!)
                    return
                }
                
                let imageData = UIImage(data: data!)
                cell.postImage.image = imageData
                
            }).resume()
            
        })

        cell.trackLabel.text = self.track[indexPath.row]
        //cell.likesLabel.text = "\(self.posts[indexPath.row].likes!) Likes"
//        cell.likeButton.isHidden = true
//        cell.unlikeButton.isHidden = false
        
        return cell
        
        
        
        
        
        
        //Need to implement this to cell.
        //Then implement the play, pause, prev, next, functions.
        //Using example from audioapp, 'thisSong' in that code is 'counter' in my code. 
        //Copy code above and put into loadTracks function.
        //The array returned from that function will be the labels for the cell called as indexpath.row and the player.play() will be present
        
        
        
        
        //A Post cell for each track
        //Play function will be activated on press of collection view cell
        //Feed will draw data from the root directory (tracks - will be ALL tracks of type mp3)
        //Only need play function to connect to content from the feed (tracks folder - function will loop through it - can do albums after if time)
        //Need to create an album view controller (as above)
        //User upon login will follow Riddum and their feed will be populated with content form that account. 
        //Able to like and unlike Riddums post.
        
        //Like/unlike, post cell, logged in getting kept. Users feed, upload feature, follow and unfollow getting removed.
        //Modify and improve like/unlike feature as much as possible.
        //Modify and improve Sign Up View controller as much as possible.
        //Modify and improve PostCell.swift with music features
        
    }
    
    
    
    
}
