//
//  ProjectCell.swift
//  RiddumProject
//
//  Created by Med Kaikai on 03/02/2018.
//  Copyright © 2018 MedKaikai. All rights reserved.
//

import UIKit
import Firebase

protocol ProjectCellDelegate: class {
    func didTapSaveProject(_ cell: ProjectCell)
    func didTapUnsaveProject(_ cell: ProjectCell)
}

class ProjectCell: UITableViewCell {
    
    weak var delegate: ProjectCellDelegate?

    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var projectLabel: UILabel!
    @IBOutlet weak var projectImage: UIImageView!
    
    @IBOutlet weak var heartOutlineProjectBtn: UIButton!
    @IBOutlet weak var heartFilledProjectBtn: UIButton!
    
    
    @IBAction func saveProjectPressed(_ sender: Any) {
        delegate?.didTapSaveProject(self)
        
        
        
        heartOutlineProjectBtn.isHidden = true
        heartFilledProjectBtn.isHidden = false
    }
    
    
    @IBAction func unsaveProjectPressed(_ sender: Any) {
        delegate?.didTapUnsaveProject(self)
        
        heartFilledProjectBtn.isHidden = true
        heartOutlineProjectBtn.isHidden = false
    }
    
}
