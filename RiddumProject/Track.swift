//
//  Track.swift
//  RiddumProject
//
//  Created by Med Kaikai on 2017-07-14.
//  Copyright © 2017 MedKaikai. All rights reserved.
//

import UIKit
import Firebase

var timagesArray = [UIImage?]()

struct Track {
    
    var title: String!
    var artist: String!
    var imageUrl: String!
    var url: String!
    var seconds: Double!
        
    init(title: String, artist: String, image_url: String, url: String) {
        self.title = title
        self.artist = artist
        self.imageUrl = image_url
        self.url = url
    }
    
    init(snapshot: FIRDataSnapshot) {
        
        let snapshotValue = snapshot.value as! [String : AnyObject]
        
        title = snapshotValue["title"] as? String
        artist = snapshotValue["artist"] as? String
        imageUrl = snapshotValue["image_url"] as? String
        url = snapshotValue["url"] as? String
        
//        // Downloads track cover art from url and appends to cell.
//        
//        //var currentTrackImage: String?
//        if let currentTrackImage = imageUrl {
//            print("good")
//            let currentTrackImageUrl = FIRStorage.storage().reference(forURL: currentTrackImage)
//            
//            currentTrackImageUrl.downloadURL(completion: { (urll, err) in
//                if err != nil {
//                    print(err!.localizedDescription)
//                    return
//                }
//                
//                URLSession.shared.dataTask(with: urll!, completionHandler: { (data, response, err) in
//                    if err != nil {
//                        print(err!)
//                        return
//                    }
//                    
//                    let imageData = UIImage(data: data!)
//                    //cell.userImage.image = imageData
//                    timagesArray.append(imageData!)
//                }).resume()
//            })
//        
//        } else {
//            print("empty")
//        }
    }
    
    
}
//extension UIImageView {
//    func downloadImage(from imgURL: String!) {
//        let url = URLRequest(url: URL(string: imgURL)!)
//
//        let task = URLSession.shared.dataTask(with: url) {
//            (data, response, error) in
//
//            if error != nil {
//                print(error!)
//                return
//            }
//
//            DispatchQueue.main.async {
//                self.image = UIImage(data: data!)
//            }
//
//        }
//
//        task.resume()
//    }
//
//}
