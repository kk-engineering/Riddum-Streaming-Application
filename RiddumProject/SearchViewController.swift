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

var artistsArray = [NSDictionary?]()
var projectsArray = [NSDictionary?]()

var filteredTracks = [NSDictionary?]()

var filteredArtists = [NSDictionary?]()
var filteredProjects = [NSDictionary?]()

var timeData: [Time] = []

class SearchViewController: UITableViewController, UISearchResultsUpdating {
    
    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "searchPlayerVC")

    
    var categories = ["Artist", "Tracks", "Projects"]
    
    var timee: Int?
    
    @IBOutlet var searchTableView: UITableView!
    
    let imageView = UIImageView(image: UIImage(named: "playHeader"))

    
    // Reference to Firebase Database.
    var ref = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        if #available(iOS 11.0, *) {
//            navigationController?.navigationBar.prefersLargeTitles = true
//            navigationItem.largeTitleDisplayMode = .automatic
//            navigationItem.searchController = UISearchController(searchResultsController: nil)
//            navigationItem.hidesSearchBarWhenScrolling = false
//
//        } else {
//            setupSearchController()
//        }
      
        setupNavBar()
        setupSearch()
        //setupSearchController()

        setUpGesture()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationItem.searchController?.isActive = false
        //showImage(false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showImage(true)
        
        retrieveTracksForSearch()
        getArtistsForSearch()
        getProjectsForSearch()
    }
    
    // Creates search controller and appends search bar to tableView's header.
    func setupSearchController() {
//        searchController.searchResultsUpdater = self
//        searchController.dimsBackgroundDuringPresentation = false
//        definesPresentationContext = true
//        tableView.tableHeaderView = searchController.searchBar
    }
    
    func setupNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.searchController = searchController
        navigationItem.largeTitleDisplayMode = .automatic
        navigationItem.hidesSearchBarWhenScrolling = false
        
        navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Avenir", size: 34)!]
        
        title = "Search"
        
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Avenir", size: 34)!]
        navigationBar.addSubview(imageView)
        imageView.layer.cornerRadius = Const.ImageSizeForLargeState / 2
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.rightAnchor.constraint(equalTo: navigationBar.rightAnchor, constant: -Const.ImageRightMargin),
            imageView.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: -Const.ImageBottomMarginForLargeState),
            imageView.heightAnchor.constraint(equalToConstant: Const.ImageSizeForLargeState),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
        ])
    }
    
    func moveAndResizeImage(for height: CGFloat) {
        let coeff: CGFloat = {
            let delta = height - Const.NavBarHeightSmallState
            let heightDifferenceBetweenStates = (Const.NavBarHeightLargeState - Const.NavBarHeightSmallState)
            return delta / heightDifferenceBetweenStates
        }()
        
        let factor = Const.ImageSizeForSmallState / Const.ImageSizeForLargeState
        
        let scale: CGFloat = {
            let sizeAddendumFactor = coeff * (1.0 - factor)
            return min(1.0, sizeAddendumFactor + factor)
        }()
        
        let sizeDiff = Const.ImageSizeForLargeState * (1.0 - factor)
        
        let yTranslation: CGFloat = {
            let maxYTranslation = Const.ImageBottomMarginForLargeState - Const.ImageBottomMarginForSmallState + sizeDiff
            return max(0, min(maxYTranslation, (maxYTranslation - coeff * (Const.ImageBottomMarginForSmallState + sizeDiff))))
        }()
        
        let xTranslation = max(0, sizeDiff - coeff * sizeDiff)
        
        imageView.transform = CGAffineTransform.identity
            .scaledBy(x: scale, y: scale)
            .translatedBy(x: xTranslation, y: yTranslation)
    }
    
    private func showImage(_ show: Bool) {
        UIView.animate(withDuration: 0.2) {
            self.imageView.alpha = show ? 1.0 : 0.0
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let height = navigationController?.navigationBar.frame.height else { return }
        moveAndResizeImage(for: height)
    }
    
    func setUpGesture() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        //let tappedImage = tapGestureRecognizer.view as! UIImageView
        
        self.present(vc, animated: true, completion: nil)
    }
    
    func setupSearch() {
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
    }
    
    // Retrieves tracks from Firebase Database and appends this data to tracksArray. Rows are then inserted into the searchTableView.
    func retrieveTracksForSearch() {
        tracksArray.removeAll()
        
        ref.child("tracks").queryOrdered(byChild: "title").observe(.childAdded, with: { (snapshot) in
            
            tracksArray.append(snapshot.value as? NSDictionary)
            
            //self.searchTableView.insertRows(at: [IndexPath(row: tracksArray.count-1, section:0)], with: UITableViewRowAnimation.automatic)
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func getProjectsForSearch() {
        projectsArray.removeAll()
        
        ref.child("projects").queryOrdered(byChild: "project_title").observe(.childAdded, with: { (snapshot) in
            
            projectsArray.append(snapshot.value as? NSDictionary)
            print("Searchhhhhh: \(projectsArray)")
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func getArtistsForSearch() {
        artistsArray.removeAll()
        
        ref.child("artists").queryOrdered(byChild: "name").observe(.childAdded, with: { (snapshot) in
            
            artistsArray.append(snapshot.value as? NSDictionary)
            
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
            let trackArtist = track!["artist"] as? String
            
            return trackTitle!.lowercased().contains(searchText.lowercased()) || trackArtist!.lowercased().contains(searchText.lowercased())
        }
        
        filteredArtists = artistsArray.filter{ artist in
            let artistName = artist!["name"] as? String

            return artistName!.lowercased().contains(searchText.lowercased())
        }
        
        filteredProjects = projectsArray.filter{ project in
            let projectName = project!["project_title"] as? String
            
            return projectName!.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
    
//    func didTapSaveTrack(_ cell: SearchCell) {
//        let indexPath = self.tableView.indexPath(for: cell)
//
//        let track : NSDictionary?
//
//        track = filteredTracks[(indexPath?.row)!]
//
//        let selectedTrackURL = track?["url"] as? String
//        let selectedTrackTitle = track?["title"] as? String
//        let selectedTrackImage = track?["image_url"] as? String
//        let selectedTrackArtist = track?["artist"] as? String
//
//        let uid = FIRAuth.auth()!.currentUser!.uid
//        let ref = FIRDatabase.database().reference()
//        let key = ref.child("users").childByAutoId().key
//
//        //let selectedTrack = trackData[indexPath?.row]
//
//        ref.child("users").child(uid).child("page").child("tracks").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
//
//            let tracksSavedURL = ["page/tracks/\(key)/url" : selectedTrackURL!]
//            let tracksSavedTitle = ["page/tracks/\(key)/title" : selectedTrackTitle!]
//            let tracksSavedImage = ["page/tracks/\(key)/image_url" : selectedTrackImage!]
//            let tracksSavedArtist = ["page/tracks/\(key)/artist" : selectedTrackArtist!]
//
//            ref.child("users").child(uid).updateChildValues(tracksSavedURL)
//            ref.child("users").child(uid).updateChildValues(tracksSavedTitle)
//            ref.child("users").child(uid).updateChildValues(tracksSavedImage)
//            ref.child("users").child(uid).updateChildValues(tracksSavedArtist)
//
//            print("save")
//            print(projectData)
//            //print("track: \(selectedTrack!)")
//
//        })
//        ref.removeAllObservers()
//
//        //MAY NEED TO JUST PUT THIS CODE IN THE TRACK CELL FUNCTION AS I DONT NEED THE INDEXPATH
//    }
//
//    func didTapUnsaveTrack(_ cell: SearchCell) {
//        let indexPath = self.tableView.indexPath(for: cell)
//
//        let track : NSDictionary?
//
//        track = filteredTracks[(indexPath?.row)!]
//
//        let selectedTrack = track?["url"] as? String
//
//        let uid = FIRAuth.auth()!.currentUser!.uid
//        let ref = FIRDatabase.database().reference()
//
//        ref.child("users").child(uid).child("page").child("tracks").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
//            if let tracksSaved = snapshot.value as? [String : AnyObject] {
//                for (ke, value) in tracksSaved {
//                    if let url = value["url"] as? String {
//                        if url == selectedTrack {
//                            //if value as! String == selectedTrack! {
//                            //self.isSaved = true
//
//                            ref.child("users").child(uid).child("page/tracks/\(ke)").removeValue()
//
//                            print("unsave")
//                        }
//                    }
//                }
//            }
//        })
//        ref.removeAllObservers()
//    }
//
//    func didTapAddTrackToLibrary(_ cell: SearchCell) {
//        print("Add Button Pressed")
//
//        let indexPath = self.tableView.indexPath(for: cell)
//
//        let track : NSDictionary?
//
//        track = filteredTracks[(indexPath?.row)!]
//
//        let selectedTrackURL = track?["url"] as? String
//        let selectedTrackTitle = track?["title"] as? String
//        let selectedTrackImage = track?["image_url"] as? String
//        let selectedTrackArtist = track?["artist"] as? String
//
//        let uid = FIRAuth.auth()!.currentUser!.uid
//        let ref = FIRDatabase.database().reference()
//        let key = ref.child("users").childByAutoId().key
//
//        //let selectedTrack = trackData[indexPath?.row]
//
//        ref.child("users").child(uid).child("tracks").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
//
//            let tracksSavedURL = ["tracks/\(key)/url" : selectedTrackURL!]
//            let tracksSavedTitle = ["tracks/\(key)/title" : selectedTrackTitle!]
//            let tracksSavedImage = ["tracks/\(key)/image_url" : selectedTrackImage!]
//            let tracksSavedArtist = ["tracks/\(key)/artist" : selectedTrackArtist!]
//
//            ref.child("users").child(uid).updateChildValues(tracksSavedURL)
//            ref.child("users").child(uid).updateChildValues(tracksSavedTitle)
//            ref.child("users").child(uid).updateChildValues(tracksSavedImage)
//            ref.child("users").child(uid).updateChildValues(tracksSavedArtist)
//
//            print("save")
//            print(projectData)
//            //print("track: \(selectedTrack!)")
//
//        })
//        ref.removeAllObservers()
//    }
//
//    func didTapRemoveTrackFromLibrary(_ cell: SearchCell) {
//        print("Remove Button Pressed")
//
//        let indexPath = self.tableView.indexPath(for: cell)
//
//        let track : NSDictionary?
//
//        track = filteredTracks[(indexPath?.row)!]
//
//        //let selectedTrackURL = track?["url"] as? String
//
//        let selectedTrack = track?["url"] as? String
//
//        let uid = FIRAuth.auth()!.currentUser!.uid
//        let ref = FIRDatabase.database().reference()
//
//        ref.child("users").child(uid).child("tracks").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
//            if let tracksSaved = snapshot.value as? [String : AnyObject] {
//                for (ke, value) in tracksSaved {
//                    if let url = value["url"] as? String {
//                        if url == selectedTrack {
//                            //if value as! String == selectedTrack! {
//                            //self.isSaved = true
//
//                            ref.child("users").child(uid).child("tracks/\(ke)").removeValue()
//
//                            print("unsave")
//                        }
//                    }
//                }
//            }
//        })
//        ref.removeAllObservers()
//    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view:UIView, forSection: Int) {
        let title = UILabel()
        title.font = UIFont(name: "Avenir", size: 20)!
        
        let headerTitle = view as! UITableViewHeaderFooterView
        headerTitle.textLabel!.font = title.font
        headerTitle.textLabel!.font = UIFont.boldSystemFont(ofSize: headerTitle.textLabel!.font.pointSize)
        headerTitle.contentView.backgroundColor = UIColor.white  
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        //return 3
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return categories[section]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController .isActive && searchController.searchBar.text != "" {
            if section == 0 {
                return filteredArtists.count
            } else if section == 1 {
                return filteredTracks.count
            } else {
                return filteredProjects.count
            }
        }
        //return tracksArray.count
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! ArtistCell
            
            let artist : NSDictionary?
            
            if searchController .isActive && searchController.searchBar.text != "" {
                artist = filteredArtists[indexPath.row]
            } else {
                //track = tracksArray[indexPath.row]
                return cell
            }
            
            cell.artistLabel?.text = artist?["name"] as? String
            
            // Retrieves url of cover art image of current track
            let currentArtistImage = artist?["image_url"] as? String
            let currentArtistImageUrl = FIRStorage.storage().reference(forURL: currentArtistImage!)
            
            // Downloads track cover art from url and appends to cell.
            currentArtistImageUrl.downloadURL(completion: { (urll, err) in
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
                    cell.artistImageView.image = imageData
                }).resume()
            })
            
            return cell
            
            
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell2", for: indexPath) as! SearchCell
        
            let track : NSDictionary?
        
            // If the searchController is being used the title from the array of filteredTracks is used and presented in the cell as the textLabel, otherwise the title from the tracksArray is used.
            if searchController .isActive && searchController.searchBar.text != "" {
                track = filteredTracks[indexPath.row]
            } else {
                //track = tracksArray[indexPath.row]
                return cell
            }
        
            cell.trackLabel?.text = track?["title"] as? String
            cell.artistLabel?.text = track?["artist"] as? String
            
            // Retrieves url of cover art image of current track
            let currentTrackImage = track?["image_url"] as? String
            let currentTrackImageUrl = FIRStorage.storage().reference(forURL: currentTrackImage!)
            
            // Downloads track cover art from url and appends to cell.
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
                    cell.trackImageView.image = imageData
                }).resume()
            })
        
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell3", for: indexPath) as! SearchProjectCell

            let project : NSDictionary?
            
            if searchController .isActive && searchController.searchBar.text != "" {
                project = filteredProjects[indexPath.row]
            } else {
                //track = tracksArray[indexPath.row]
                return cell
            }
            
            cell.artistLabel?.text = project?["project_artist"] as? String
            cell.projectLabel?.text = project?["project_title"] as? String
            
            // Retrieves url of cover art image of current track
            let currentProjectImage = project?["project_image_url"] as? String
            let currentProjectImageUrl = FIRStorage.storage().reference(forURL: currentProjectImage!)
            
            // Downloads track cover art from url and appends to cell.
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
                    cell.projectImageView.image = imageData
                }).resume()
            })
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let track : NSDictionary?
        
        if searchController .isActive && searchController.searchBar.text != "" {
            track = filteredTracks[indexPath.row]            
        }
        else {
            //track = tracksArray[indexPath.row]
            return
        }

        let currentTrack = track?["url"] as? String
        
        // Downloads track from url for playback via AVPlayer.
        let currentTrackUrl = FIRStorage.storage().reference(forURL: currentTrack!)
        currentTrackUrl.downloadURL { (url, error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            } else {
                let playerItem:AVPlayerItem = AVPlayerItem(url: url!)
                player = AVPlayer(playerItem: playerItem)
                //player = AVPlayer(url: url! as URL)
                player?.play()
                
//                let duration : CMTime = playerItem.asset.duration
//                let seconds : Float64 = CMTimeGetSeconds(duration)
//
//                timeData.append(Time(seconds: seconds))
//
//                let currentTime = timeData[indexPath.row].seconds
//                print("Current Time: \(currentTime)")
                
                let duration : CMTime = playerItem.asset.duration
                //let duration = playerItem.asset.duration
                
                //Use for slider max value
                let seconds : Float64 = CMTimeGetSeconds(duration)
                
                //Use for time stamp
                let secondsText:Int = Int(seconds) % 60
                
                print("00:\(secondsText)")
                print("secs: \(seconds)")
                print("yes")
                
                //I dont even need a time variable, just send seconds & seconds text
                
                let spVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "searchPlayerVC") as! SearchPlayerViewController
                
                spVC.getSeconds = seconds
                
                self.navigationController?.pushViewController(spVC, animated: true)
                
                //Still need to find out how to view minutes & seconds
                
                //This works so need to push the duration to the SearchPlayer - may be able to append to an object - and the field to the track object perhaps e.g. Duration
            }
        }
        
        counter = indexPath.row
        playerFilled = true
        
        self.tableView.reloadData()
        
        // Present Player View Controller when row is selected.
        
        //self.present(vc, animated: true, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        tabBarItem = UITabBarItem(title: "Search", image: UIImage(named: "search"), tag: 2)
    }
}
