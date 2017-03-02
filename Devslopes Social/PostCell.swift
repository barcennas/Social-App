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
    @IBOutlet weak var likeImage : UIImageView!
    
    var post : Post!
    var likesRef : FIRDatabaseReference!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        tap.numberOfTapsRequired = 1
        self.likeImage.addGestureRecognizer(tap)
        likeImage.isUserInteractionEnabled = true
        
    }

    func configureCell(post : Post, img : UIImage? = nil){
        self.post = post
        likesRef = DataService.ds.REF_USER_CURRENT.child("likes").child(post.postId)
        
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
        
        likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull{ //NULL because is firebase Data Nil is for swift
                self.likeImage.image = #imageLiteral(resourceName: "empty-heart")
             }else{
                self.likeImage.image = #imageLiteral(resourceName: "filled-heart")
             }
        })
    }
    
    func likeTapped(sender: UITapGestureRecognizer){
        if likeImage.image == #imageLiteral(resourceName: "filled-heart") {
            likeImage.image = #imageLiteral(resourceName: "empty-heart")
            post.adjustLikes(addLike: false)
            likesRef.removeValue()
            
        }else{
            likeImage.image = #imageLiteral(resourceName: "filled-heart")
            post.adjustLikes(addLike: true)
            likesRef.setValue(true)
        }
    }
    
    

}
