//
//  PostCell.swift
//  Devslopes Social
//
//  Created by Abraham Barcenas M on 2/19/17.
//  Copyright © 2017 barcennas. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UITableViewCell {
    
    @IBOutlet weak var profileImage : UIImageView!
    @IBOutlet weak var userNameLbl : UILabel!
    @IBOutlet weak var postImage : UIImageView!
    @IBOutlet weak var caption : UITextView!
    @IBOutlet weak var numberLikesLbl : UILabel!
    
    var post : Post!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(post : Post, img : UIImage? = nil){
        self.post = post
        self.caption.text = post.caption
        self.numberLikesLbl.text = "\(post.likes)"
        
        if img != nil {
            self.postImage.image = img
        }else{
            let ref = FIRStorage.storage().reference(forURL: post.imageURL)
            ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                if error != nil {
                    print("AB: Unable to Download Image from Firebase Storage")
                }else{
                    print("AB: image added")
                    if let imageData = data{
                        if let image = UIImage(data: imageData){
                            self.postImage.image = image
                            FeedVC.imageCache.setObject(image, forKey: post.imageURL as NSString)
                        }
                    }
                }
            })
        }
    }
    
    

}
