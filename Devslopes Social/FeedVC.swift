//
//  FeedVC.swift
//  Devslopes Social
//
//  Created by Abraham Barcenas M on 2/18/17.
//  Copyright © 2017 barcennas. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet var addImage: CircularImageView!

    var posts : [Post] = []
    var imagePicker : UIImagePickerController!
    static var imageCache : NSCache<NSString, UIImage> = NSCache()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshot {
                    if let postDict = snap.value as? [String : Any]{
                        let postId = snap.key
                        let post = Post(postId: postId, postData: postDict)
                        self.posts.append(post)
                    }
                }
            }
            self.tableView.reloadData()
        })

        
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell{
            
            if let image = FeedVC.imageCache.object(forKey: post.imageURL as NSString){
                cell.configureCell(post: post, img: image)
            }else{
                cell.configureCell(post: post)
            }
            return cell
        }
        return PostCell()
    }
    
    @IBAction func signOutButtonPressed(_ sender: Any) {
        KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        do {
           try FIRAuth.auth()?.signOut()
            dismiss(animated: true, completion: nil)
        }catch {
            print("Error while logging out - \(error)")
        }
    }
    
    
    @IBAction func addImageTapped(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage{
            addImage.image = image
        }else{
            print("Invalid Image Selected")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
}
