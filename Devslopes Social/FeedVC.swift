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
    @IBOutlet weak var addImage: CircularImageView!
    @IBOutlet weak var captionTxt: FancyField!
    @IBOutlet weak var postButton: RoundButton!

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
                self.posts = []
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
    
    
    @IBAction func postButtonTapped(_ sender: Any) {
        guard let caption = captionTxt.text, !caption.isEmpty else {
            let alert = UIAlertController(title: "Caption Required", message: "In order to post something you need to add a caption to your image", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
            return
        }
        
        if addImage.image == #imageLiteral(resourceName: "add-image"){
            let alert = UIAlertController(title: "Image Required", message: "In order to post something you need to add an image", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }else{
            if let image = addImage.image{
                if let imageData = UIImageJPEGRepresentation(image, 0.6){
                    
                    let imageUID = NSUUID().uuidString
                    let metaData = FIRStorageMetadata()
                    metaData.contentType = "image/jpeg"
                    
                    DataService.ds.REF_POST_IMAGES.child(imageUID).put(imageData, metadata: metaData, completion: { (metadata, error) in
                        if error != nil {
                            print("AB: Unable to load image to Firebase Storage")
                        }else{
                            print("Image Uploaded to Firebase Storage")
                            if let downloadUrl = metadata?.downloadURL()?.absoluteString{
                                self.postToFirebase(imgUrl: downloadUrl)
                            }
                        }
                    })
                }
            }

        }
    }
    
    func postToFirebase(imgUrl : String){
        let post : [String : Any] = ["caption" : captionTxt.text!, "imageUrl" : imgUrl, "likes" : 0]
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
        //link post to the user
        //DataService.ds.createFirebaseDBUser(uid: <#T##String#>, userData: <#T##[String : String]#>)
        
        captionTxt.text = ""
        addImage.image = #imageLiteral(resourceName: "add-image")
        tableView.reloadData()
    }
    
    
}
