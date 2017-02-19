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

class FeedVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
}
