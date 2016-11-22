//
//  ChatRoom.swift
//  TTV
//
//  Created by Pritam Hinger on 22/11/16.
//  Copyright © 2016 AppDevelapp. All rights reserved.
//

import Foundation

class ChatRoom {
    public var roomName:String?
    public var roomId:String?
    
    init(id:String, name:String) {
        roomName = name;
        roomId = id;
    }
}
