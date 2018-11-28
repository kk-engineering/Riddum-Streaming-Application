//
//  ArtistCell.swift
//  RiddumProject
//
//  Created by Med Kaikai on 04/02/2018.
//  Copyright © 2018 MedKaikai. All rights reserved.
//

import UIKit

class ArtistCell: UITableViewCell {

    
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var artistImageView: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        artistImageView.layer.cornerRadius = self.artistImageView.frame.width / 2
        artistImageView.clipsToBounds = true
    }
}
