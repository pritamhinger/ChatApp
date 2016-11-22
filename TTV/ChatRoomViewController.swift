//
//  ChatRoomViewController.swift
//  TTV
//
//  Created by Pritam Hinger on 22/11/16.
//  Copyright © 2016 AppDevelapp. All rights reserved.
//

import UIKit
import Firebase
import JSQMessagesViewController

final class ChatRoomViewController: JSQMessagesViewController {

    var chatRoomRef:FIRDatabaseReference?
    var chatRoom:ChatRoom?{
        didSet{
            title = chatRoom?.roomName
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
