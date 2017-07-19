 //
//  UsersViewController.swift
//  RiddumProject
//
//  Created by Med Kaikai on 2017-04-10.
//  Copyright © 2017 MedKaikai. All rights reserved.
//

import UIKit
import Firebase
import AVKit
import AVFoundation
 
var player = AVPlayer()
var uploadDate = [String]()
var counter = 0
var trackName = [String]()
var playerFilled = false
 
var trackData: [Track] = []

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        retrieveTracks()      
    }
    
    func retrieveTracks() {
        let ref = FIRDatabase.database().reference()
        
        trackData.removeAll()

        ref.child("tracks").observe(.value, with: { (snapshot) in
            
            for item in snapshot.children.allObjects {
                let songsItem = Track(snapshot: item as! FIRDataSnapshot)
                trackData.append(songsItem)
            }
            self.tableView.reloadData()
        })
        ref.removeAllObservers()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "trackCell", for: indexPath) as! TrackCell
        
        cell.nameLabel.text = trackData[indexPath.row].title
        
        let currentTrackImage = trackData[indexPath.row].image_url
        let currentTrackImageUrl = FIRStorage.storage().reference(forURL: currentTrackImage!)
        
        currentTrackImageUrl.downloadURL(completion: { (urll, err) in
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
                cell.userImage.image = imageData
            }).resume()
        })
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trackData.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let currentTrack = trackData[indexPath.row].url
        
        let currentTrackUrl = FIRStorage.storage().reference(forURL: currentTrack!)
        currentTrackUrl.downloadURL { (url, error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            } else {
                player = AVPlayer(url: url! as URL)
                player.play()
            }
        }
        
        counter = indexPath.row
        playerFilled = true
        
        self.tableView.reloadData()
        
        // present player view controller when row is selected
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "playerVC")
        
        self.present(vc, animated: true, completion: nil)
        
    }
 
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // initialize tab bar item
        tabBarItem = UITabBarItem(title: "Feed", image: UIImage(named: "airpods"), tag: 1)
    }

}
 
// extension UIImageView {
//    
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
//        }
//        task.resume()
//
//    }
// }
