//
//  SecondTableViewCellClass.swift
//  RiddumProject
//
//  Created by Med Kaikai on 20/01/2018.
//  Copyright © 2018 MedKaikai. All rights reserved.
//

import UIKit

class SecondTableViewCellClass: UITableViewCell {

    
    
    @IBOutlet weak var secondCollectionViewOutlet: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
