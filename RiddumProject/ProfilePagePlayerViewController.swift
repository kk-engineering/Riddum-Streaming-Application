//
//  ProfilePagePlayerViewController.swift
//  RiddumProject
//
//  Created by Med Kaikai on 10/03/2018.
//  Copyright © 2018 MedKaikai. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import Firebase

class ProfilePagePlayerViewController: UIViewController {
    
    let pullDuration: Float64 = 15
    
    var getSeconds = Double()
    
    var tapCloseButtonActionHandler : (() -> Void)?
    
    
    @IBOutlet weak var trackLabel: UILabel!
    
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var pullButton: UIButton!
    @IBOutlet weak var reloadButton: UIButton!
    @IBOutlet weak var loopButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        retrieveCoverArt()
        retrieveMetadata()
        
        trackLabel.text = userTracksSavedToPage[counter].title
        artistLabel.text = userTracksSavedToPage[counter].artist
    }
    
    
    // Retrieves cover art of track.
    func retrieveCoverArt() {
        let currentTrackImage = userTracksSavedToPage[counter].imageUrl
        
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
        let currentTrack = userTracksSavedToPage[counter].url
        
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
                // self.uploadLabel.text = ("Added: \(newDate)")
            }
        }
    }

    
    @IBAction func closeButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    // playerFilled globally set to 'false' in FeedViewController. It represents a track being loaded in the player.
    // timeControlStatus represents the status of the player.
    
    // Action for play button.

    
    @IBAction func play(_ sender: Any) {
        
        
        if playerFilled == true && player?.timeControlStatus == .paused {
            player?.play()
            
            playButton.isHidden = true
            pauseButton.isHidden = false
        }
    }
    
    
    // Action for pause button.
    
    @IBAction func pause(_ sender: Any) {
        if playerFilled == true && player?.timeControlStatus == .playing {
            player?.pause()
            
            pauseButton.isHidden = true
            playButton.isHidden = false
        }
    }
    
    
    // Action for previous button.
    // Counter goes to previous object in trackData array.

    
    //    @IBAction func prev(_ sender: Any) {
    
    
    
    @IBAction func prev(_ sender: Any) {
        if playerFilled == true && counter != 0 {
            playThis(thisTrack: userTracksSavedToPage[counter-1].url)
            counter -= 1
            trackLabel.text = userTracksSavedToPage[counter].title
            
            playButton.isHidden = true
            pauseButton.isHidden = false
        } else {
            print("ERROR")
        }
    }
    
    
    
    // Action for next button.
    // Counter goes to next object in trackData array.
    
    
    @IBAction func next(_ sender: Any) {
        if playerFilled == true && counter < userTracksSavedToPage.count-1 {
            playThis(thisTrack: userTracksSavedToPage[counter+1].url)
            counter += 1
            trackLabel.text = userTracksSavedToPage[counter].title
            
            playButton.isHidden = true
            pauseButton.isHidden = false
        } else {
            print("ERROR")
        }
    }
    
    
    
    @IBAction func pull(_ sender: Any) {
        if playerFilled == true {
            
            print("Pull It")
            let currentTime = CMTimeGetSeconds((player?.currentTime())!)
            
            var newTime = currentTime - pullDuration
            
            if newTime < 0 {
                newTime = 0
            }
            
            let time2: CMTime = CMTimeMake(Int64(newTime * 1000 as Float64), 1000)
            player?.seek(to: time2, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
            
        } else {
            print("ERROR")
        }
        
    }
    
    @IBAction func reload(_ sender: Any) {
        if playerFilled == true {
            print("Reload Dat")
            
            player?.seek(to: kCMTimeZero)
            player?.play()
            
        } else {
            print("ERROR")
        }
        
    }

    
    @IBAction func loop(_ sender: Any) {
        if playerFilled == true {
            print("The Loop")
            
            NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem, queue: .main) { _ in
                player?.seek(to: kCMTimeZero)
                player?.play()
            }
            
            
        } else {
            print("ERROR")
        }
        
    }
    
    
    //    // Action for slider control.
    //    @IBAction func slider(_ sender: UISlider) {
    //        if playerFilled == true {
    //            player?.volume = sender.value
    //        }
    //    }
    
    
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
                player?.play()
            }
        }
    }
}

