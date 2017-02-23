//
//  PostCell.swift
//  Devslopes Social
//
//  Created by Abraham Barcenas M on 2/19/17.
//  Copyright © 2017 barcennas. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {
    
    @IBOutlet weak var profileImage : UIImageView!
    @IBOutlet weak var userNameLbl : UILabel!
    @IBOutlet weak var postImage : UIImageView!
    @IBOutlet weak var caption : UITextView!
    @IBOutlet weak var numberLikesLbl : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(post : Post){
        self.caption.text = post.caption
        self.numberLikesLbl.text = "\(post.likes)"
        
        
    }

}
