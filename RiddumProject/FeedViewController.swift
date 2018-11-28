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

var player:AVPlayer?
var playerItem:AVPlayerItem?

var uploadDate = [String]()
var counter = 0
var trackName = [String]()
var playerFilled = false

var trackData: [Track] = []
var projectData: [Project] = []
var tracklistData: [Tracklist] = []

var tracklistArray = [NSDictionary?]()

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CellDelegate, ProjectCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let imageView = UIImageView(image: UIImage(named: "playHeader"))
    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "playerVC2")
    
    var trackCell = TrackCell()
    //let trackDetailsVC = TrackMenuDetailsViewController()
    
    //var trackMenuDetailsViewController: TrackMenuDetailsViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        //trackMenuDetailsViewController?.menuDelegate = self
        
        setupNavBar()
        setUpGesture()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //showImage(false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showImage(true)
        
        retrieveTracks()
        getProjects()
        getTracklist()
    }
    
    func setupNavBar() {
        
//        navigationController?.navigationBar.prefersLargeTitles = true
//        navigationItem.largeTitleDisplayMode = .automatic
//
//        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Avenir", size: 34)!]
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        title = "Listen"
        
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let height = navigationController?.navigationBar.frame.height else { return }
        moveAndResizeImage(for: height)
    }
    
    func setUpGesture() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        //let tappedImage = tapGestureRecognizer.view as! UIImageView
        
        self.present(vc, animated: true, completion: nil)
    }
    
    // Retrieve tracks from Firebase Database and stores data in Track object.
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
    
    func getProjects() {
        let ref = FIRDatabase.database().reference()
        
        projectData.removeAll()
        
        ref.child("projects").observe(.value, with: { (snapshot) in
            
            for item in snapshot.children {
                let projectItem = Project(snapshot: item as! FIRDataSnapshot)
                projectData.append(projectItem)
                let projectsSnap = item as! FIRDataSnapshot
                
                for tracklist in projectsSnap.children {
                    let trackListSnap = tracklist as! FIRDataSnapshot
                //    let trackListItem = Tracklist(snapshot: tracklist as? FIRDataSnapshot)
                  //  tracklistData.append(trackListItem)
                                            
                        projectsArray.append(snapshot.value as? NSDictionary)
                 
                    for track in trackListSnap.children {
                        let tracksItem = Tracklist(snapshot: track as! FIRDataSnapshot)
                        print("traaaaackssssss")
                        print(tracksItem)
                        tracklistData.append(tracksItem)
                        
                        //This works - For Showing the TrackList in its view I will need to do a if e.g. if the project title = the project title of the tracklist in the view etc.
                    }
                }
            }
            self.tableView.reloadData()
        })
        ref.removeAllObservers()
    }
    
    func getTracklist() {
        let ref = FIRDatabase.database().reference()
        
        tracklistArray.removeAll()
        
        ref.child("projects").observe(.childAdded, with: { (snapshot) in
            
            tracklistArray.append(snapshot.value as? NSDictionary)
            print("NEEWWWW ARRAYYYYY")
            print(tracklistArray)
        })
    }
    
    var isSaved = false
    
    func didTapSaveTrack(_ cell: TrackCell) {
        let indexPath = self.tableView.indexPath(for: cell)
        
        let selectedTrackURL = trackData[(indexPath?.row)!].url
        let selectedTrackTitle = trackData[(indexPath?.row)!].title
        let selectedTrackImage = trackData[(indexPath?.row)!].imageUrl
        let selectedTrackArtist = trackData[(indexPath?.row)!].artist
        
        let uid = FIRAuth.auth()!.currentUser!.uid
        let ref = FIRDatabase.database().reference()
        let key = ref.child("users").childByAutoId().key
        
        //let selectedTrack = trackData[indexPath?.row]

        ref.child("users").child(uid).child("page").child("tracks").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in

                let tracksSavedURL = ["page/tracks/\(key)/url" : selectedTrackURL!]
                let tracksSavedTitle = ["page/tracks/\(key)/title" : selectedTrackTitle!]
                let tracksSavedImage = ["page/tracks/\(key)/image_url" : selectedTrackImage!]
                let tracksSavedArtist = ["page/tracks/\(key)/artist" : selectedTrackArtist!]
                
                ref.child("users").child(uid).updateChildValues(tracksSavedURL)
                ref.child("users").child(uid).updateChildValues(tracksSavedTitle)
                ref.child("users").child(uid).updateChildValues(tracksSavedImage)
                ref.child("users").child(uid).updateChildValues(tracksSavedArtist)
            
                print("save")
                print(projectData)
                //print("track: \(selectedTrack!)")
            
        })
        ref.removeAllObservers()
        
        //MAY NEED TO JUST PUT THIS CODE IN THE TRACK CELL FUNCTION AS I DONT NEED THE INDEXPATH
    }
    
    func didTapUnsaveTrack(_ cell: TrackCell) {
        let indexPath = self.tableView.indexPath(for: cell)
        
        let selectedTrack = trackData[(indexPath?.row)!].url
        
        let uid = FIRAuth.auth()!.currentUser!.uid
        let ref = FIRDatabase.database().reference()
        
        ref.child("users").child(uid).child("page").child("tracks").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            if let tracksSaved = snapshot.value as? [String : AnyObject] {
                for (ke, value) in tracksSaved {
                    if let url = value["url"] as? String {
                        if url == selectedTrack {
                        //if value as! String == selectedTrack! {
                            //self.isSaved = true
                            
                            ref.child("users").child(uid).child("page/tracks/\(ke)").removeValue()
                            
                            print("unsave")
                        }
                    }
                }
            }
        })
        ref.removeAllObservers()
    }
    
    func didTapAddTrackToLibrary(_ cell: TrackCell) {
        print("Add Button Pressed")
        
        let indexPath = self.tableView.indexPath(for: cell)
        
        let selectedTrackURL = trackData[(indexPath?.row)!].url
        let selectedTrackTitle = trackData[(indexPath?.row)!].title
        let selectedTrackImage = trackData[(indexPath?.row)!].imageUrl
        let selectedTrackArtist = trackData[(indexPath?.row)!].artist
        
        let uid = FIRAuth.auth()!.currentUser!.uid
        let ref = FIRDatabase.database().reference()
        let key = ref.child("users").childByAutoId().key
        
        //let selectedTrack = trackData[indexPath?.row]
        
        ref.child("users").child(uid).child("tracks").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            
            let tracksSavedURL = ["tracks/\(key)/url" : selectedTrackURL!]
            let tracksSavedTitle = ["tracks/\(key)/title" : selectedTrackTitle!]
            let tracksSavedImage = ["tracks/\(key)/image_url" : selectedTrackImage!]
            let tracksSavedArtist = ["tracks/\(key)/artist" : selectedTrackArtist!]
            
            ref.child("users").child(uid).updateChildValues(tracksSavedURL)
            ref.child("users").child(uid).updateChildValues(tracksSavedTitle)
            ref.child("users").child(uid).updateChildValues(tracksSavedImage)
            ref.child("users").child(uid).updateChildValues(tracksSavedArtist)
            
            print("save")
            print(projectData)
            //print("track: \(selectedTrack!)")
            
        })
        ref.removeAllObservers()
    }
    
    func didTapRemoveTrackFromLibrary(_ cell: TrackCell) {
        print("Remove Button Pressed")
        
        let indexPath = self.tableView.indexPath(for: cell)
        
        
        let selectedTrack = trackData[(indexPath?.row)!].url
        
        let uid = FIRAuth.auth()!.currentUser!.uid
        let ref = FIRDatabase.database().reference()
        
        ref.child("users").child(uid).child("tracks").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            if let tracksSaved = snapshot.value as? [String : AnyObject] {
                for (ke, value) in tracksSaved {
                    if let url = value["url"] as? String {
                        if url == selectedTrack {
                            //if value as! String == selectedTrack! {
                            //self.isSaved = true
                            
                            ref.child("users").child(uid).child("tracks/\(ke)").removeValue()
                            
                            print("unsave")
                        }
                    }
                }
            }
        })
        ref.removeAllObservers()
    }
    
    
    func didTapSaveProject(_ cell: ProjectCell) {

        
        let indexPath = self.tableView.indexPath(for: cell)
        
        let selectedProjectTitle = projectData[(indexPath?.row)!].projectTitle
        let selectedProjectImage = projectData[(indexPath?.row)!].imageUrl
        let selectedProjectArtist = projectData[(indexPath?.row)!].artist
        
        let selectedProjectTracklistTitle = tracklistData[(indexPath?.row)!].trackTitle
        let selectedProjectTracklistUrl = tracklistData[(indexPath?.row)!].trackURL

        let uid = FIRAuth.auth()!.currentUser!.uid
        let ref = FIRDatabase.database().reference()
        let key = ref.child("users").childByAutoId().key

        //let selectedTrack = trackData[indexPath?.row]

        ref.child("users").child(uid).child("page").child("projects").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in


            let projectSavedTitle = ["page/projects/\(key)/title" : selectedProjectTitle!]
            let projectSavedImage = ["page/projects/\(key)/image_url" : selectedProjectImage!]
            let projectSavedArtist = ["page/projects/\(key)/artist" : selectedProjectArtist!]
            
            let projectSavedTracklistTitle = ["page/projects/\(key)/artist" : selectedProjectTracklistTitle!]
            let projectSavedTracklistUrl = ["page/projects/\(key)/artist" : selectedProjectTracklistUrl!]
            
            ref.child("users").child(uid).updateChildValues(projectSavedTitle)
            ref.child("users").child(uid).updateChildValues(projectSavedImage)
            ref.child("users").child(uid).updateChildValues(projectSavedArtist)
            
            ref.child("users").child(uid).updateChildValues(projectSavedTracklistTitle)
            ref.child("users").child(uid).updateChildValues(projectSavedTracklistUrl)
            
            print("save")
            //print("track: \(selectedTrack!)")

        })
        ref.removeAllObservers()
    }
    
    func didTapUnsaveProject(_ cell: ProjectCell) {

    }
    
    // POP UP MENU BUTTONS
    

    
    func didTapAddProjectToLibrary() {
        
    }
    
    func didTapRemoveProjectToLibrary() {
        
    }
    
    //
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return (trackData.count + projectData.count)
        //return 2
        
        if section == 0 {
            return trackData.count
        } else {
            return projectData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "trackCell", for: indexPath) as! TrackCell
            cell.delegate = self
            
            let trackArtistLabel = "\(trackData[indexPath.row].artist!) #Track"
            let string_to_color = "#Track"
            
            let range = (trackArtistLabel as NSString).range(of: string_to_color)
            
            let attributedString = NSMutableAttributedString.init(string: trackArtistLabel)
            attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 74 / 255.0, green: 144 / 255.0, blue: 226 / 255.0, alpha: 1.0), range: range)
            
            cell.nameLabel.attributedText = attributedString
            cell.trackName.text = trackData[indexPath.row].title
        
            // Retrieves url of cover art image of current track
            let currentTrackImage = trackData[indexPath.row].imageUrl
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
                    cell.userImage.image = imageData
                }).resume()
            })
            return cell
        } else {
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "projectCell", for: indexPath) as! ProjectCell
            cell2.delegate = self
            
            let projectArtistLabel = "\(projectData[indexPath.row].artist!) #Project"
            let string_to_color = "#Project"
            
            let range = (projectArtistLabel as NSString).range(of: string_to_color)
            
            let attributedString = NSMutableAttributedString.init(string: projectArtistLabel)
            attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 74 / 255.0, green: 144 / 255.0, blue: 226 / 255.0, alpha: 1.0), range: range)
            
            cell2.artistLabel.attributedText = attributedString
            cell2.projectLabel.text = projectData[indexPath.row].projectTitle
            
            print("TrackList To Project!!!!!!")
            print("Title: \(tracklistData[indexPath.row].trackTitle)")
            
            // Retrieves url of cover art image of current track
            let currentProjectImage = projectData[indexPath.row].imageUrl
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
                    cell2.projectImage.image = imageData
                }).resume()
            })
            return cell2
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Retrieves the url of the current track from trackData array.
        let currentTrack = trackData[indexPath.row].url
        
        // Downloads track from url for playback via AVPlayer.
        let currentTrackUrl = FIRStorage.storage().reference(forURL: currentTrack!)
        currentTrackUrl.downloadURL { (url, error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            } else {
                player = AVPlayer(url: url! as URL)
                player?.automaticallyWaitsToMinimizeStalling = false
                player?.play()
            }
        }
        
        counter = indexPath.row
        playerFilled = true
        
        self.tableView.reloadData()
        
        // Present Player View Controller when row is selected.

        self.present(vc, animated: true, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Initialize tab bar item.
        tabBarItem = UITabBarItem(title: "Feed", image: UIImage(named: "airpods"), tag: 1)
    }
}
