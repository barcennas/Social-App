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

class SignInVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            }
        })
    }

}

