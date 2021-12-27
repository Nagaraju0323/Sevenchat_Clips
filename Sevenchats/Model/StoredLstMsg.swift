//
//  StoredLstMsg.swift
//  Sevenchats
//
//  Created by APPLE on 29/10/21.
//  Copyright © 2021 mac-00020. All rights reserved.
//

import Foundation



//MARK: - MDLProductCategory
public class MDLChatLastMSG :Encodable{
    
    public var  topic: String!
    public var timestamp : String!
    public var sender : String!
    public var message : String!
    public var type : String!
    
    init(topic:String,timestamp:String,sender:String,message:String,type:String) {
        self.topic = topic
        self.timestamp = timestamp
        self.sender = sender
        self.message = message
        self.type = type
        
    }
}
