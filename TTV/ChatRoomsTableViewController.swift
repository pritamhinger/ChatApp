//
//  ChatRoomsTableViewController.swift
//  TTV
//
//  Created by Pritam Hinger on 22/11/16.
//  Copyright © 2016 AppDevelapp. All rights reserved.
//

import UIKit

enum Section: Int {
    case createNewChatRoomSection = 0
    case currentChatRoomSection
}

class ChatRoomsTableViewController: UITableViewController {
    
    var senderName:String?
    var newChatRoomNameTextField:UITextField?
    private var chatRoomsList:[ChatRoom] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        chatRoomsList.append(ChatRoom(id: "1", name: "Room 1"))
        chatRoomsList.append(ChatRoom(id: "2", name: "Room 2"))
        chatRoomsList.append(ChatRoom(id: "3", name: "Room 3"))
        self.tableView.reloadData()
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
