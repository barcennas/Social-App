//
//  FancyField.swift
//  Devslopes Social
//
//  Created by Abraham Barcenas M on 2/16/17.
//  Copyright © 2017 barcennas. All rights reserved.
//

import UIKit

class FancyField: UITextField {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        //Draws the new border of the textField
        layer.borderColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.2).cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 3.0
        
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        //Returns a new Rectangle inside the main rectangle, to separate the placeholder from the left frame of the main rectanle
        return bounds.insetBy(dx: 10, dy: 5)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        //Returns a new Rectangle inside the main rectangle, to separate the text from the left frame of the main rectanle while editing
        return bounds.insetBy(dx: 10, dy: 5)
    }
}
