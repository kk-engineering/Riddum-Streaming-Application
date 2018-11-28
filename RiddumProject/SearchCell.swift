//
//  SearchCell.swift
//  RiddumProject
//
//  Created by Med Kaikai on 2017-11-18.
//  Copyright © 2017 MedKaikai. All rights reserved.
//

import UIKit
import Firebase

//protocol SearchCellDelegate: class {
//    func didTapSaveTrack(_ cell: SearchCell)
//    func didTapUnsaveTrack(_ cell: SearchCell)
//    func didTapAddTrackToLibrary(_ cell: SearchCell)
//    func didTapRemoveTrackFromLibrary(_ cell: SearchCell)
//}

class SearchCell: UITableViewCell {
    
   // weak var delegate: SearchCellDelegate?

    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var trackLabel: UILabel!
    
    
    @IBOutlet weak var trackImageView: UIImageView!
    
//    @IBOutlet weak var heartOutlineTrackBtn: UIButton!
//    @IBOutlet weak var heartFilledTrackBtn: UIButton!
//
//    @IBOutlet weak var addTrackToLibraryBtn: UIButton!
//    @IBOutlet weak var removeTrackFromLibraryBtn: UIButton!
//
//    var isSaved = false
//
//    @IBAction func saveTrackPressed(_ sender: Any) {
//        delegate?.didTapSaveTrack(self)
//
//        heartOutlineTrackBtn?.isHidden = true
//        heartFilledTrackBtn?.isHidden = false
//
//        //It works but is not saving the track selected in the cell
//
//    }
//
//    @IBAction func unSaveTrackPressed(_ sender: Any) {
//        delegate?.didTapUnsaveTrack(self)
//
//        heartFilledTrackBtn.isHidden = true
//        heartOutlineTrackBtn.isHidden = false
//    }
//
//    @IBAction func addTrackToLibraryPressed(_ sender: Any) {
//        delegate?.didTapAddTrackToLibrary(self)
//
//        addTrackToLibraryBtn?.isHidden = true
//        removeTrackFromLibraryBtn?.isHidden = false
//    }
//
//    @IBAction func removeTrackToLibraryPressed(_ sender: Any) {
//        delegate?.didTapRemoveTrackFromLibrary(self)
//
//        removeTrackFromLibraryBtn.isHidden = true
//        addTrackToLibraryBtn.isHidden = false
//    }
}
