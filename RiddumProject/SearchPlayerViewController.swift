//
//  SearchPlayerViewController.swift
//  RiddumProject
//
//  Created by Med Kaikai on 2017-07-23.
//  Copyright © 2017 MedKaikai. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import Firebase

class SearchPlayerViewController: UIViewController {
    
    var track : NSDictionary?
    
    // UI Outlets.
    @IBOutlet weak var trackLabel: UILabel!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var uploadLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        retrieveCoverArt()
        retrieveMetadata()
        
        // If the searchController has been used the title from the array of filteredTracks is used for the textLabel, otherwise the title from the tracksArray is used.
        if searchController .isActive && searchController.searchBar.text != "" {
            track = filteredTracks[counter]
        } else {
            track = tracksArray[counter]
        }
        
        trackLabel.text = track?["title"] as? String
    }    


    // Retrieves cover art of track.
    func retrieveCoverArt() {
        
        if searchController .isActive && searchController.searchBar.text != "" {
            track = filteredTracks[counter]
        } else {
            track = tracksArray[counter]
        }
        
        let currentTrackImage = track?["image_url"] as? String
        
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
                self.coverImage.image = imageData
            }).resume()
        })
    }
    
    // Retrieves metadata of track.
    func retrieveMetadata() {
        
        if searchController .isActive && searchController.searchBar.text != "" {
            track = filteredTracks[counter]
        } else {
            track = tracksArray[counter]
        }
        
        let currentTrack = track?["url"] as? String
        
        let currentTrackUrl = FIRStorage.storage().reference(forURL: currentTrack!)
        currentTrackUrl.metadata { (metadata, error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
                
            else {
                print(metadata!)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EEE, dd MMM yyyy"
                let trackCreated = metadata!.timeCreated
                let newDate = dateFormatter.string(from: trackCreated!)
                self.uploadLabel.text = ("Added: \(newDate)")
            }
        }
    }
    
    // playerFilled globally set to 'false' in FeedViewController. It represents a track being loaded in the player.
    // timeControlStatus represents the status of the player.
    
    // Action for play button.
    @IBAction func play(_ sender: Any) {
        if playerFilled == true && player.timeControlStatus == .paused {
            player.play()
        }
    }
    
    // Action for pause button.
    @IBAction func pause(_ sender: Any) {
        if playerFilled == true && player.timeControlStatus == .playing {
            player.pause()
        }
    }
    
    // Previous & Next buttons return to trackData array for playback.
    
    // Action for previous button.
    // Counter goes to previous object in trackData array.
    @IBAction func prev(_ sender: Any) {
        if playerFilled == true && counter != 0 {
            playThis(thisTrack: trackData[counter-1].url)
            counter -= 1
            trackLabel.text = trackData[counter].title
        } else {
            print("ERROR")
        }
    }
    
    // Action for next button.
    // Counter goes to next object in trackData array.
    @IBAction func next(_ sender: Any) {
        if playerFilled == true && counter < trackData.count-1 {
            playThis(thisTrack: trackData[counter+1].url)
            counter += 1
            trackLabel.text = trackData[counter].title
        } else {
            print("ERROR")
        }
    }
    
    // Action for slider control.
    @IBAction func slider(_ sender: UISlider) {
        if playerFilled == true {
            player.volume = sender.value
        }
    }
    
    // Retrieves url of current track.
    // Contents of url passed into AVPlayer for audio playback.
    func playThis(thisTrack: String) {
        let currentTrack = thisTrack
        
        let currentTrackUrl = FIRStorage.storage().reference(forURL: currentTrack)
        currentTrackUrl.downloadURL { (url, error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            } else {
                player = AVPlayer(url: url! as URL)
                player.play()
            }
        }
    }
}
