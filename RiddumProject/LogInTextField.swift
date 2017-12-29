//
//  LogInTextField.swift
//  RiddumProject
//
//  Created by Med Kaikai on 2017-07-29.
//  Copyright © 2017 MedKaikai. All rights reserved.
//

import UIKit

@IBDesignable
class LogInTextField: UITextField {

    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.borderStyle = UITextBorderStyle.roundedRect
        self.layer.borderColor = UIColor(white: 206 / 255, alpha: 1).cgColor
        self.layer.borderWidth = 1
    }

//    override func textRect(forBounds bounds: CGRect) -> CGRect {
//        return bounds.insetBy(dx: 8, dy: 7)
//    }
//    
//    override func editingRect(forBounds bounds: CGRect) -> CGRect {
//        return textRect(forBounds: bounds)
//    }
}
