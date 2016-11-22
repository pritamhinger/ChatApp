//
//  ViewController.swift
//  TTV
//
//  Created by Pritam Hinger on 22/11/16.
//  Copyright © 2016 AppDevelapp. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signIn(_ sender: UIButton) {
        FIRAuth.auth()?.signInAnonymously(completion: { (user, error) in
            print(user)
            if let err = error{
                print(err.localizedDescription)
                return
            }
            
            self.performSegue(withIdentifier: "mainWindow", sender: nil)
        })
    }
}

