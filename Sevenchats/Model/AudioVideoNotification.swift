//
//  AudioVideoNotification.swift
//  Sevenchats
//
//  Created by mac-00020 on 23/10/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//

import Foundation
import ObjectMapper

class AudioVideoNotification : NSObject {
    
    var twiMessageId : String?
    var aps : Aps?
    var identity : String?
   
    var fromIdentity : String?
    var roomName : String?
    var notificationId : String?
    var userData : NotificationUserData!
    
    fileprivate var _notificationType : String?
//    var notificationType : CallNotificationType!{
//        return CallNotificationType(rawValue: _notificationType ?? "") ?? .None
//    }
    
    
    
    init(fromDictionary dictionary: [String:Any]){
        
        if let _aps = dictionary["aps"] as? [String:Any]{
            aps = Aps(fromDictionary: _aps)
        }
        
        if let _userData = dictionary["user_data"] as? String, let json = _userData.toJson(){
            userData = NotificationUserData(fromDictionary: json)
        } else if let _userData = dictionary["user_data"] as? [String : Any]{
            userData = NotificationUserData(fromDictionary: _userData)
        }
        
        twiMessageId = dictionary["twi_message_id"] as? String ?? ""
        notificationId = dictionary["notification_id"]  as? String ?? ""
        identity = dictionary["identity"]  as? String ?? ""
        _notificationType = dictionary["notification_type"] as? String ?? ""
        fromIdentity = dictionary["from-identity"]  as? String ?? ""
        roomName = dictionary["room_name"]  as? String ?? ""
    }
    
}

class Aps : NSObject {
    var alert : Alert?
    init(fromDictionary dictionary: [String:Any]){
        if let _alert = dictionary["alert"] as? [String:Any]{
            alert = Alert(fromDictionary: _alert)
        }
    }
}

class NotificationUserData : NSObject {
    
    var senderId : Int?
    var receiverId : Int?
    fileprivate var channelType : String?
    var fullName : String = ""
    var userImage : String = ""
    var memberIds : [String] = []
    var groupName : String = ""
    var callerUserImage : String = ""
    var mobile : String = ""
    var countryCode  : String = ""
    
//    var roomType : RoomType {
//        if channelType == "1To1"{
//            return .UserRoom
//        }
//        return .GroupRoom
//    }
    
    init(fromDictionary dictionary: [String:Any]){
        
        channelType = dictionary["channel_type"]  as? String ?? ""
        groupName = dictionary["groupName"]  as? String ?? ""
        fullName = dictionary["fullName"]  as? String ?? ""
        userImage = dictionary["userImage"]  as? String ?? ""
        callerUserImage = dictionary["callerUserImage"]  as? String ?? ""
        senderId = dictionary["sender_id"] as? Int ?? 0
        
        mobile = dictionary["mobile"]  as? String ?? ""
        countryCode = dictionary["country_code"]  as? String ?? ""
        
        if senderId == 0{
            let id = dictionary["sender_id"] as? String ?? "0"
            senderId = id.toInt ?? 0
        }
        
        receiverId = dictionary["receiver_id"]  as? Int ?? 0
        if receiverId == 0{
            let id = dictionary["receiver_id"] as? String ?? "0"
            receiverId = id.toInt ?? 0
        }
        let members = dictionary["memberIds"] as? String ?? ""
        if !members.isEmpty{
            self.memberIds = members.components(separatedBy: ",")
        }
    }
}

class Alert : NSObject {
    
    var body : String?
    var title : String?
    
    init(fromDictionary dictionary: [String:Any]){
        body = dictionary["body"] as? String ?? ""
        title = dictionary["title"]  as? String ?? ""
    }
}
