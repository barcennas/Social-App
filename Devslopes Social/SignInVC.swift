//
//  ViewController.swift
//  Devslopes Social
//
//  Created by Abraham Barcenas M on 2/16/17.
//  Copyright © 2017 barcennas. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit
import SwiftKeychainWrapper

class SignInVC: UIViewController {

    
    @IBOutlet weak var emailTxt: FancyField!
    @IBOutlet weak var passwordTxt: FancyField!
    
    override func viewDidLoad() {
        //To early to perform segues
        super.viewDidLoad()
        
    }

    override func viewDidAppear(_ animated: Bool) {
        //can perform segues
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID){
            performSegue(withIdentifier: "feedSegue", sender: nil)
        }
    }
    
    @IBAction func signInButtonPressed(_ sender: Any) {
        
        if let email = emailTxt.text, let password = passwordTxt.text, !email.isEmpty, password.characters.count > 6{
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                if error == nil{
                    print("ABRAHAM : Email user authenticated with firebase")
                    if let user = user {
                        self.completeSignIn(id: user.uid)
                    }
                    
                }else{
                    FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                        if error != nil{
                            print("ABRAHAM : Fireabe Unable to create user with email")
                            let alert = UIAlertController(title: "Email in use", message: "It looks that an account is already linked with the email", preferredStyle: .alert)
                            let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
                            alert.addAction(okButton)
                            self.present(alert, animated: true, completion: nil)
                            
                        }else{
                            print("ABRAHAM : Firebase User successfully created")
                            if let user = user {
                                self.completeSignIn(id: user.uid)
                            }
                        }
                    })
                }
            })
        }else{
            let alert = UIAlertController(title: "Invalid input information", message: "Email must be valid and Password must be longer than 6 characters", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okButton)
            present(alert, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func facebookButtonTapped(_ sender: Any) {
        
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("ABRAHAM : Unable to Authenticate with Facebook - \(error)")
            }else if result?.isCancelled == true {
                print("ABRAHAM : User cancelled Facebook Authentication")
            }else{
                print("ABRAHAM : Authenticated with Facebook")
                //Save the granted facebook credential to Firebase Facebook Auth
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
        
    }
    
    func firebaseAuth(_ credential : FIRAuthCredential){
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("ABRAHAM : Unable to authenticate with Firebase - \(error)")
            }else{
                print("ABRAHAM : Succesfully authenticated with Firebase")
                if let user = user {
                    self.completeSignIn(id: user.uid)
                }
            }
        })
    }
    
    func completeSignIn(id: String){
        KeychainWrapper.standard.set(id, forKey: KEY_UID)
        performSegue(withIdentifier: "feedSegue", sender: nil)
    }

}

