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

    @IBOutlet weak var usernameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signIn(_ sender: UIButton) {
        if (usernameTextField.text?.characters.count)! <= 0{
            return;
        }
        
        FIRAuth.auth()?.signInAnonymously(completion: { (user, error) in
            print(user)
            if let err = error{
                print(err.localizedDescription)
                return
            }
            
            self.performSegue(withIdentifier: "mainWindow", sender: nil)
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        let navVC = segue.destination as! UINavigationController
        let chatRoomsVC = navVC.viewControllers.first as! ChatRoomsTableViewController
        chatRoomsVC.senderName = usernameTextField.text
    }
}

