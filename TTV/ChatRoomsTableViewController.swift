//
//  ChatRoomsTableViewController.swift
//  TTV
//
//  Created by Pritam Hinger on 22/11/16.
//  Copyright © 2016 AppDevelapp. All rights reserved.
//

import UIKit
import FirebaseDatabase

enum Section: Int {
    case createNewChatRoomSection = 0
    case currentChatRoomSection
}

class ChatRoomsTableViewController: UITableViewController {
    
    var senderName:String?
    var newChatRoomNameTextField:UITextField?
    private var chatRoomsList:[ChatRoom] = []
    
    private lazy var chatRoomsRef: FIRDatabaseReference = FIRDatabase.database().reference().child("chatRooms")
    private var chatRoomsRefHandle: FIRDatabaseHandle?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Available Chat Rooms"
        observeChannels()
    }
    
    deinit {
        if let refHandle = chatRoomsRefHandle{
            chatRoomsRef.removeObserver(withHandle: refHandle)
        }
    }
    
    
    @IBAction func createChatRoom(_ sender: UIButton) {
        if let name = newChatRoomNameTextField?.text{
            let newChatRoomRef = chatRoomsRef.childByAutoId()
            let chatRoomNode = ["name":name];
            newChatRoomRef.setValue(chatRoomNode);
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let currentSection:Section = Section(rawValue: section){
            switch currentSection {
            case .createNewChatRoomSection:
                return 1;
            case .currentChatRoomSection:
                return chatRoomsList.count
            }
        }
        else{
            return 0
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = (indexPath as NSIndexPath).section == Section.createNewChatRoomSection.rawValue ? "NewChatRoom" : "ChatRoom"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)

        if indexPath.section == Section.createNewChatRoomSection.rawValue {
            if let newChatRoomCell = cell as? ChatRoomTableViewCell{
                newChatRoomNameTextField = newChatRoomCell.chatRoomTextField
            }
        }
        else if indexPath.section == Section.currentChatRoomSection.rawValue{
            cell.textLabel?.text = chatRoomsList[indexPath.row].roomName
        }

        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == Section.currentChatRoomSection.rawValue{
            let chatRoom = chatRoomsList[indexPath.row]
            self.performSegue(withIdentifier: "showChatRoom", sender: chatRoom)
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let chatRoom = sender as? ChatRoom{
            let chatVC = segue.destination as! ChatRoomViewController
            chatVC.senderDisplayName = senderName
            chatVC.chatRoom = chatRoom
            chatVC.chatRoomRef = chatRoomsRef.child(chatRoom.roomId!)
        }
    }
    
    // MARK: Firebase related methods
    private func observeChannels() {
        // Use the observe method to listen for new
        // channels being written to the Firebase DB
        chatRoomsRefHandle = chatRoomsRef.observe(.childAdded, with: { (snapshot) -> Void in // 1
            let channelData = snapshot.value as! Dictionary<String, AnyObject> // 2
            let id = snapshot.key
            if let name = channelData["name"] as! String!, name.characters.count > 0 { // 3
                self.chatRoomsList.append(ChatRoom(id: id, name: name))
                self.tableView.reloadData()
            } else {
                print("Error! Could not decode channel data")
            }
        })
    }

}
