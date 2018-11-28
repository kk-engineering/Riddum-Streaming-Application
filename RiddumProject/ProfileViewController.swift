//
//  ProfileViewController.swift
//  RiddumProject
//
//  Created by Med Kaikai on 2017-09-23.
//  Copyright © 2017 MedKaikai. All rights reserved.
//

import UIKit
import Firebase
import AVKit
import AVFoundation

var userPageArray = [NSDictionary?]()
var userTracksSavedToPage: [Track] = []
var userProjectsSavedToPage: [Project] = []
var userTracksSavedToLibrary: [Track] = []
var userProjectsSavedToLibrary: [Project] = []

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let imageView = UIImageView(image: UIImage(named: "playHeader"))
    //let vc2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "searchPlayerVC") as! SearchPlayerViewController

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    //Need connection to get username an add to text
    //Need a LogOut Function
    //Check if Correct uid if not Logout
    
    var currentTableView: Int!
    var imageTest: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tableView.backgroundColor = UIColor.darkGray
        currentTableView = 0
        
        setUpNavBar()
        setUpGesture()

        setUpSegmentedControl()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //showImage(false)
        getTracksSavedToPage()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showImage(true)
        
        setupProfile()

        getProjectsSavedToPage()
        getTracksSavedToLibrary()
        getProjectsSavedToLibrary()
        getTracksSavedToPage()
        //self.tableView.reloadData()
        
    }
    
    func setUpNavBar() {
        
        //        navigationController?.navigationBar.prefersLargeTitles = true
        //        navigationItem.largeTitleDisplayMode = .automatic
        //
        //        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Avenir", size: 34)!]
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        //title = "Listen"
        
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
        
        if currentTableView == 0 {
            let profilePageVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "profilePagePlayerVC") as! ProfilePagePlayerViewController
            self.present(profilePageVC, animated: true, completion: nil)
            
        } else if currentTableView == 1 {
            let profileTrackVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "profileTrackPlayerVC") as! ProfileTrackPlayerViewController
            
            
            self.present(profileTrackVC, animated: true, completion: nil)
        }
        else {
            return
        }
        

    }
    
    func setupProfile() {
        let ref = FIRDatabase.database().reference()
        
        if let uid = FIRAuth.auth()?.currentUser?.uid {
            ref.child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                if let dict = snapshot.value as? [String : AnyObject] {
                    self.title = dict["username"] as? String
                }
            })
        }
    }
    
    func setUpSegmentedControl() {
        segmentedControl.backgroundColor = .clear
        segmentedControl.tintColor = .clear
        
        segmentedControl.setTitleTextAttributes([
            NSForegroundColorAttributeName: UIColor.lightGray,
            NSFontAttributeName: UIFont(name: "Avenir", size: 16)!], for: .normal)
        
        segmentedControl.setTitleTextAttributes([
            NSForegroundColorAttributeName: UIColor.black,
            NSFontAttributeName: UIFont(name: "Avenir", size: 16)!], for: .selected)
    }
    
    func getTracksSavedToPage() {
        let ref = FIRDatabase.database().reference()
        let uid = FIRAuth.auth()!.currentUser!.uid
        
        //userPageArray.removeAll()
        userTracksSavedToPage.removeAll()
        
        //ref.child("users").child(uid).child("tracks")
        ref.child("users").child(uid).child("page").child("tracks").observe(.value, with: { (snapshot) in
            for item in snapshot.children.allObjects {
                let songsItem = Track(snapshot: item as! FIRDataSnapshot)
                userTracksSavedToPage.append(songsItem)
            }
            self.tableView.reloadData()
            //userPageArray.append(snapshot.value as? NSDictionary)
            
        })
        ref.removeAllObservers()
    }
    
    func getProjectsSavedToPage() {
        
    }
    
    func getTracksSavedToLibrary() {
        let ref = FIRDatabase.database().reference()
        let uid = FIRAuth.auth()!.currentUser!.uid
        
        //userPageArray.removeAll()
        userTracksSavedToLibrary.removeAll()
        
        //ref.child("users").child(uid).child("tracks")
        ref.child("users").child(uid).child("tracks").observe(.value, with: { (snapshot) in
            for item in snapshot.children.allObjects {
                let songsItem = Track(snapshot: item as! FIRDataSnapshot)
                userTracksSavedToLibrary.append(songsItem)
            }
            self.tableView.reloadData()
            //userPageArray.append(snapshot.value as? NSDictionary)
            
        })
        
        //let imageTest = 
        ref.removeAllObservers()
    }
    
    func getProjectsSavedToLibrary() {
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if currentTableView == 0 {
            return userTracksSavedToPage.count
        } else if currentTableView == 1 {
            return userTracksSavedToLibrary.count
        } else {
            return 2
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if currentTableView == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "profilePageTrackCell") as! ProfilePageCell
            
            cell.trackName?.text = userTracksSavedToPage[indexPath.row].title
            cell.nameLabel?.text = userTracksSavedToPage[indexPath.row].artist
            //cell.userImage?.image = timagesArray[indexPath.row]
            
            if let image = userTracksSavedToPage[indexPath.row].imageUrl {
                cell.userImage.downloadImage(from: image)
            } else {
                print("No Image Available")
            }
            


            return cell
        } else if currentTableView == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileTrackCell") as! ProfileTrackCell

            
            cell.trackLabel?.text = userTracksSavedToLibrary[indexPath.row].title
            cell.artistLabel?.text = userTracksSavedToLibrary[indexPath.row].artist
            
            if let image = userTracksSavedToLibrary[indexPath.row].imageUrl {
                cell.trackImageView.downloadImage(from: image)
            } else {
                print("No Image Available")
            }

            
            
            
            return cell
//        } else if currentTableView == 2 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "profileProjectCell")
//            cell?.textLabel?.text = "projects"
//            cell?.textLabel?.textColor = UIColor.white
//            cell?.textLabel?.backgroundColor = UIColor.darkGray
//            cell?.contentView.backgroundColor = UIColor.darkGray
//
//
//
//
//            return cell!
//        } else if currentTableView == 3 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "profilePlaylistCell")
//            cell?.textLabel?.text = "playlists"
//            cell?.textLabel?.textColor = UIColor.white
//            cell?.textLabel?.backgroundColor = UIColor.darkGray
//            cell?.contentView.backgroundColor = UIColor.darkGray
//
//
//
//
//            return cell!
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileRecentCell")

            
            
            
            
            
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        var track: Track?
//        let currentTrack = track?.url
        
       // let selectedVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "searchPlayerVC") as! SearchPlayerViewController
        
        
        if currentTableView == 0 {
            let currentTrack = userTracksSavedToPage[indexPath.row].url
            
            // Downloads track from url for playback via AVPlayer.
            let currentTrackUrl = FIRStorage.storage().reference(forURL: (currentTrack)!)
            currentTrackUrl.downloadURL { (url, error) in
                if error != nil {
                    print(error!.localizedDescription)
                    return
                } else {
                    let playerItem:AVPlayerItem = AVPlayerItem(url: url!)
                    player = AVPlayer(playerItem: playerItem)
                    //player = AVPlayer(url: url! as URL)
                    player?.play()
                    
                }
            }
            
            let selectedVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "profilePagePlayerVC") as! ProfilePagePlayerViewController
            
            // Present Player View Controller when row is selected.
            self.present(selectedVC, animated: true, completion: nil)
            
        } else if currentTableView == 1 {
            let currentTrack = userTracksSavedToLibrary[indexPath.row].url

            // Downloads track from url for playback via AVPlayer.
            let currentTrackUrl = FIRStorage.storage().reference(forURL: (currentTrack)!)
            currentTrackUrl.downloadURL { (url, error) in
                if error != nil {
                    print(error!.localizedDescription)
                    return
                } else {
                    let playerItem:AVPlayerItem = AVPlayerItem(url: url!)
                    player = AVPlayer(playerItem: playerItem)
                    //player = AVPlayer(url: url! as URL)
                    player?.play()
                    
                }
            }
            
            let selectedVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "profileTrackPlayerVC") as! ProfileTrackPlayerViewController
            
            // Present Player View Controller when row is selected.
            self.present(selectedVC, animated: true, completion: nil)
            
        }
        else {
            // recents player vc
            return
        }
        

        
        counter = indexPath.row
        playerFilled = true
        
        self.tableView.reloadData()
        
        // Present Player View Controller when row is selected.
        //self.present(selectedVC, animated: true, completion: nil)

    }

    @IBAction func librarySwitchAction(_ sender: UISegmentedControl) {
        currentTableView = sender.selectedSegmentIndex
        tableView.reloadData()
    }
}

extension UIImageView {
    func downloadImage(from imgURL: String!) {
        let url = URLRequest(url: URL(string: imgURL)!)
        
        let task = URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
            }
            
        }
        
        task.resume()
    }
    
}








