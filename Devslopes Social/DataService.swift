//
//  DataService.swift
//  Devslopes Social
//
//  Created by Abraham Barcenas M on 2/21/17.
//  Copyright © 2017 barcennas. All rights reserved.
//

import Foundation
import Firebase
import SwiftKeychainWrapper

let DB_BASE = FIRDatabase.database().reference()
let STORAGE_BASE = FIRStorage.storage().reference()

class DataService {
    
    static let ds = DataService()
    
    //Database References
    private var _REF_BASE = DB_BASE
    private var _REF_POSTS = DB_BASE.child("posts")
    private var _REF_USERS = DB_BASE.child("users")
    
    //Storage References
    private var _REF_POST_IMAGES = STORAGE_BASE.child("post-images")
    
    var REF_BASE : FIRDatabaseReference {
        return _REF_BASE
    }
    
    var REF_POSTS : FIRDatabaseReference {
        return _REF_POSTS
    }
    
    var REF_USERS : FIRDatabaseReference {
        return _REF_USERS
    }
    
    var REF_USER_CURRENT : FIRDatabaseReference{
        if let uid = KeychainWrapper.standard.string(forKey: KEY_UID){
            let user = REF_USERS.child(uid)
            return user
        }
        print("Error while getting EF_USER_CURRENT")
        return FIRDatabaseReference()
    }
    
    var REF_POST_IMAGES : FIRStorageReference {
        return _REF_POST_IMAGES
    }
    
    func createFirebaseDBUser(uid: String, userData: [String : String]){
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    
}
