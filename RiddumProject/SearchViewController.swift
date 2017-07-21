//
//  SearchViewController.swift
//  RiddumProject
//
//  Created by Med Kaikai on 2017-07-14.
//  Copyright © 2017 MedKaikai. All rights reserved.
//

import UIKit
import Firebase

class SearchViewController: UITableViewController, UISearchResultsUpdating {
    
    @IBOutlet var searchTableView: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    var tracksArray = [NSDictionary?]()
    var filteredTracks = [NSDictionary?]()
    
    var databaseRef = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchController()
        retrieveTracksForSearch()
    }
    
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }
    
    func retrieveTracksForSearch() {
        databaseRef.child("tracks").queryOrdered(byChild: "title").observe(.childAdded, with: { (snapshot) in
            
            self.tracksArray.append(snapshot.value as? NSDictionary)
            
            self.searchTableView.insertRows(at: [IndexPath(row: self.tracksArray.count-1, section:0)], with: UITableViewRowAnimation.automatic)
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContent(searchText: self.searchController.searchBar.text!)
    }
    
    func filterContent(searchText: String) {
        self.filteredTracks = self.tracksArray.filter{ track in
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
        return self.tracksArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath)
        
        let track : NSDictionary?
        
        if searchController .isActive && searchController.searchBar.text != "" {
            
            track = filteredTracks[indexPath.row]
            
        } else {
            track = self.tracksArray[indexPath.row]
        }
        
        cell.textLabel?.text = track?["title"] as? String
        cell.detailTextLabel?.text = track?["artist"] as? String
        
        return cell
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        tabBarItem = UITabBarItem(title: "Search", image: UIImage(named: "search"), tag: 2)
    }
}
