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
import FirebaseDatabase

final class ChatRoomViewController: JSQMessagesViewController {

    
    lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setOutGoingBubble()
    lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setInComingBubble()
    
    var messages = [JSQMessage]()
    
    var chatRoomRef:FIRDatabaseReference?
    private lazy var messageRef: FIRDatabaseReference = self.chatRoomRef!.child("messages")
    private var newMessageRefHandle: FIRDatabaseHandle?
    
    var chatRoom:ChatRoom?{
        didSet{
            title = chatRoom?.roomName
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.senderId = FIRAuth.auth()?.currentUser?.uid
        
        if let chatRoom = chatRoom{
            title = chatRoom.roomName
        }
        
        observeMessages()
        
        collectionView.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.row]
        if message.senderId == senderId {
            return outgoingBubbleImageView
        }
        
        return incomingBubbleImageView
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item];
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        let message = messages[indexPath.row]
        if message.senderId == senderId{
            cell.textView.textColor = UIColor.white
        }
        else{
            cell.textView.textColor  = UIColor.black
        }
        
        return cell
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        let nodeRef = messageRef.childByAutoId()
        let messageItem = [
            "senderId": senderId!,
            "senderName": senderDisplayName!,
            "text": text!]
        nodeRef.setValue(messageItem)
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        finishSendingMessage()
    }
    
    private func observeMessages(){
        messageRef = (chatRoomRef?.child("messages"))!
        let messageQuery = messageRef.queryLimited(toLast: 25)
        newMessageRefHandle = messageQuery.observe(.childAdded, with: { (snapshot)  -> Void in
            let messageData = snapshot.value as! Dictionary<String, String>
            if let id = messageData["senderId"] as String!, let messageText = messageData["text"] as String!, let name = messageData["senderName"] as String!, messageText.characters.count > 0{
                self.addMessage(withId: id, name: name, text: messageText)
                self.finishReceivingMessage()
            }
            else{
                print("Houston..!! We have a problem here..!!")
            }
        })
    }
    
    private func addMessage(withId id: String, name: String, text:String){
        if let message = JSQMessage(senderId: id, displayName: name, text: text){
            messages.append(message)
        }
    }
    
    private func setOutGoingBubble() -> JSQMessagesBubbleImage{
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        return (bubbleFactory?.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue()))!
    }
    
    private func setInComingBubble() -> JSQMessagesBubbleImage{
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        return bubbleFactory!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
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
