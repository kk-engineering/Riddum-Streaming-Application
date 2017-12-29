//
//  NewSearchViewController.swift
//  RiddumProject
//
//  Created by Med Kaikai on 2017-10-23.
//  Copyright © 2017 MedKaikai. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import Firebase

var artistData: [Artist] = []
var projectData: [Project] = []

class NewSearchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    @IBOutlet weak var artistCollectionView: UICollectionView!
    
    @IBOutlet weak var projectCollectionView: UICollectionView!
    
    // Reference to Firebase Database.
    var ref = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        artistCollectionView.delegate = self
        artistCollectionView.dataSource = self
        
        projectCollectionView.delegate = self
        projectCollectionView.dataSource = self
        
        retrieveArtists()
        retrieveProjects()
    }
    
    // Retrieves tracks from Firebase Database and appends this data to tracksArray. Rows are then inserted into the searchTableView.
    func retrieveArtists() {
        let ref = FIRDatabase.database().reference()
        
        artistData.removeAll()
        
        ref.child("artists").observe(.value, with: { (snapshot) in
            
            for item in snapshot.children.allObjects {
                let artistItem = Artist(snapshot: item as! FIRDataSnapshot)
                artistData.append(artistItem)
            }
            //self.tableView.reloadData()
            self.artistCollectionView.reloadData()

        })
        ref.removeAllObservers()
    }
    
    func retrieveProjects() {
        let ref = FIRDatabase.database().reference()
        
        projectData.removeAll()
        
        ref.child("projects").observe(.value, with: { (snapshot) in
            
            for item in snapshot.children.allObjects {
                let projectItem = Project(snapshot: item as! FIRDataSnapshot)
                projectData.append(projectItem)
            }
            //self.tableView.reloadData()
            self.projectCollectionView.reloadData()

        })
        ref.removeAllObservers()
        
    }
    

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
//        var returnValue = Int()
//
//        if section == 0 {
//            returnValue = artistData.count
//        } else if section == 1 {
//            returnValue = projectData.count
//        }
//        return returnValue
        
        if section == 0 {
            return artistData.count
        } else {
            return projectData.count
        }
        
      //return (section == 0) ? list.count : list2.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "artistSearchCell", for: indexPath) as! ArtistSearchCell
        
            cell.artistName.text = artistData[indexPath.row].name

            // Retrieves image of artist.
            let currentTrackImage = artistData[indexPath.row].imageUrl

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
                    cell.artistImage.image = imageData
                }).resume()
            })
        
            return cell
        } else  {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "projectSearchCell", for: indexPath) as! ProjectSearchCell
            
            cell.projectName.text = projectData[indexPath.row].name
            
            // Retrieves image of artist.
            let currentProjectImage = projectData[indexPath.row].imageUrl
            
            let currentProjectImageUrl = FIRStorage.storage().reference(forURL: currentProjectImage!)
            currentProjectImageUrl.downloadURL(completion: { (urll, err) in
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
                    cell.projectImage.image = imageData
                }).resume()
            })
            return cell
        }
    }
}
