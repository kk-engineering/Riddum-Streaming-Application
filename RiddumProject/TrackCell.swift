//
//  UserCell.swift
//  RiddumProject
//
//  Created by Med Kaikai on 2017-04-10.
//  Copyright © 2017 MedKaikai. All rights reserved.
//

import UIKit
import Firebase

protocol CellDelegate: class {
    func didTapSaveTrack(_ cell: TrackCell)
    func didTapUnsaveTrack(_ cell: TrackCell)
    func didTapAddTrackToLibrary(_ cell: TrackCell)
    func didTapRemoveTrackFromLibrary(_ cell: TrackCell)
}

class TrackCell: UITableViewCell {
    
    weak var delegate: CellDelegate?

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var trackName: UILabel!
    
    @IBOutlet weak var heartOutlineTrackBtn: UIButton!
    @IBOutlet weak var heartFilledTrackBtn: UIButton!
    
    @IBOutlet weak var addTrackToLibraryBtn: UIButton!
    @IBOutlet weak var removeTrackFromLibraryBtn: UIButton!
    var isSaved = false
    
    @IBAction func saveTrackPressed(_ sender: Any) {
        delegate?.didTapSaveTrack(self)
        

        
        heartOutlineTrackBtn?.isHidden = true
        heartFilledTrackBtn?.isHidden = false
        
        //It works but is not saving the track selected in the cell
        
    }
    
    @IBAction func unSaveTrackPressed(_ sender: Any) {
        delegate?.didTapUnsaveTrack(self)
        
        heartFilledTrackBtn.isHidden = true
        heartOutlineTrackBtn.isHidden = false
    }
    
    @IBAction func addTrackToLibraryPressed(_ sender: Any) {
        delegate?.didTapAddTrackToLibrary(self)
        
        addTrackToLibraryBtn?.isHidden = true
        removeTrackFromLibraryBtn?.isHidden = false
    }
    
    @IBAction func removeTrackToLibraryPressed(_ sender: Any) {
        delegate?.didTapRemoveTrackFromLibrary(self)
        
        removeTrackFromLibraryBtn.isHidden = true
        addTrackToLibraryBtn.isHidden = false
    }
    
    var userID: String!
}
