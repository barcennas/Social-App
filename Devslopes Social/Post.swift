//
//  Post.swift
//  Devslopes Social
//
//  Created by Abraham Barcenas M on 2/22/17.
//  Copyright © 2017 barcennas. All rights reserved.
//

import Foundation

class Post {
    private var _caption : String!
    private var _imageURL : String!
    private var _likes : Int!
    private var _postId : String!
    
    var caption : String {
        return _caption
    }
    
    var imageURL : String{
        return _imageURL
    }
    
    var likes : Int{
        return _likes
    }
    
    var postId : String{
        return _postId
    }
    
    init(caption: String, imageURL: String, likes: Int) {
        self._caption = caption
        self._imageURL = imageURL
        self._likes = likes
    }
    
    init(postId: String, postData: [String : Any]) {
        self._postId = postId
        
        if let caption = postData["caption"] as? String{
            self._caption = caption
        }
        
        if let imageUrl = postData["imageUrl"] as? String{
            self._imageURL = imageUrl
        }
        
        if let likes = postData["likes"] as? Int{
            self._likes = likes
        }
    }
    
}
