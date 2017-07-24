//
//  SearchViewController.swift
//  RiddumProject
//
//  Created by Med Kaikai on 2017-07-14.
//  Copyright © 2017 MedKaikai. All rights reserved.
//

import UIKit
import Firebase
import AVKit
import AVFoundation

let searchController = UISearchController(searchResultsController: nil)
var tracksArray = [NSDictionary?]()
var filteredTracks = [NSDictionary?]()

class SearchViewController: UITableViewController, UISearchResultsUpdating {
    
    @IBOutlet var searchTableView: UITableView!
    
    // Reference to Firebase Database.
    var ref = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchController()
        retrieveTracksForSearch()
    }
    
    // Creates search controller and appends search bar to tableView's header.
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }
    
    // Retrieves tracks from Firebase Database and appends this data to tracksArray. Rows are then inserted into the searchTableView.
    func retrieveTracksForSearch() {
        tracksArray.removeAll()
        
        ref.child("tracks").queryOrdered(byChild: "title").observe(.childAdded, with: { (snapshot) in
            
            tracksArray.append(snapshot.value as? NSDictionary)
            
            self.searchTableView.insertRows(at: [IndexPath(row: tracksArray.count-1, section:0)], with: UITableViewRowAnimation.automatic)
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContent(searchText: searchController.searchBar.text!)
    }
    
    // Filters all content of title in tracksArray with matches from data in searchText.
    func filterContent(searchText: String) {
        filteredTracks = tracksArray.filter{ track in
            let trackTitle = track!["title"] as? String
            
            return(trackTitle?.lowercased().contains(searchText.lowercased()))!
        }
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController .isActive && searchController.searchBar.text != "" {
            return filteredTracks.count
        }
        return tracksArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath)
        
        let track : NSDictionary?
        
        // If the searchController is being used the title from the array of filteredTracks is used and presented in the cell as the textLabel, otherwise the title from the tracksArray is used. 
        if searchController .isActive && searchController.searchBar.text != "" {
            track = filteredTracks[indexPath.row]
        } else {
            track = tracksArray[indexPath.row]
        }
        
        cell.textLabel?.text = track?["title"] as? String
        cell.detailTextLabel?.text = track?["artist"] as? String
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let track : NSDictionary?
        
        if searchController .isActive && searchController.searchBar.text != "" {
            track = filteredTracks[indexPath.row]            
        } else {
            track = tracksArray[indexPath.row]
        }

        let currentTrack = track?["url"] as? String
        
        // Downloads track from url for playback via AVPlayer.
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
        
        // Present Player View Controller when row is selected.
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "searchPlayerVC")
        
        self.present(vc, animated: true, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        tabBarItem = UITabBarItem(title: "Search", image: UIImage(named: "search"), tag: 2)
    }
}
