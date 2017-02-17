//
//  RoundButton.swift
//  Devslopes Social
//
//  Created by Abraham Barcenas M on 2/16/17.
//  Copyright © 2017 barcennas. All rights reserved.
//

import UIKit

class RoundButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        //In this ponint the width and height of the button hasen't been rendered, so it doesn't get the value
        
        //Gives the shadow to the button
        layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.6).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        
        imageView?.contentMode = .scaleAspectFit
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //In this ponint the width and height of the button has been rendered, so it gets the value
        
        layer.cornerRadius = self.frame.width / 2
    }

}
