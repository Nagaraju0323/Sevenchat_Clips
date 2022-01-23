//
//  AudioModel.swift
//  Sevenchats
//
//  Created by mac-00020 on 05/11/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//

import Foundation
import UIKit
//import CocoaMQTT
import AVKit
import TrueTime

let CPUBLISHMESSAGETYPE             = 1
let CPUBLISHREADTYPE                = 2
let CPUBLISHBLOCKUSER               = 3
let CPUBLISHFRIENDUNFRIENDUSER      = 4
let CPUBLISHONLINEOFFLIEN           = 5
let CPUBLISHDELETECREATEGROUP       = 6
let CPUBLISHDELETEMESSAGE           = 7

let CMQTTUSERTOPIC = "mchat/"
let CMQTTUSERONLINEOFFLINETOPIC = "mchat/on-off"
let CMQTTUSERNAME = ""
let CMQTTPASSWORD = ""
let CMQTTHOST = "test.sevenchats.com"
let cMQTTPort = UInt16(1882)

var ClientID  = "ios-" + (Date().millisecondsSince1970.description + ProcessInfo().processIdentifier.description) + "-\(appDelegate.loginUser?.user_id ?? Int64(0.0))"  //ios-RANDOMNUMBER(10)-USERID

enum MessageType : Int {
    case text = 1
    case image = 2
    case video = 3
    case audio = 4
    case location = 6
}

enum ChatType : Int {
    case user = 1
    case group = 2
}

enum MessageDeliveredStatus : Int {
    case local = 1
    case sent = 2
    case read = 3
}



struct Members{
    var id : Int
    var firstName : String?
    var lastName : String?
    
    var identity : String{
        var userName = (firstName ?? "") + "_" +  (lastName ?? "")
        userName = userName.replacingOccurrences(of: " ", with: "")
        return id.description + "_" + userName
        //return  "User" + id.description
    }
}

var myAudioIdentity : String {
    var userName = (appDelegate.loginUser?.first_name ?? "") + "_" +  (appDelegate.loginUser?.last_name ?? "")
    userName = userName.replacingOccurrences(of: " ", with: "")
    return (appDelegate.loginUser?.user_id ?? 0).description + "_" + userName
}

class AudioCall {
    
    var members: [Members]
    
    var identity : String{
        return myAudioIdentity
        
        //return "User" + (appDelegate.loginUser?.user_id ?? 0).description
        
        /*let userName = (appDelegate.loginUser?.first_name ?? "") + "_" +  (appDelegate.loginUser?.last_name ?? "")
        return (appDelegate.loginUser?.user_id ?? 0).description + "_" + userName*/
    }
    var toIdentity: String {
        //let identity = memberId.map({"User" + $0.description})
        let identity = members.map({$0.identity})
        return identity.joined(separator: ",")
    }
//    var roomType: RoomType = .UserRoom
    var fullName : String = ""
    var image : String = ""
    var mobile : String = ""
    var countryCode : String = ""
    var isSender = true
    
    init(members : [Members], name: String, image: String, isSender:Bool) {
        self.members = members
    
        self.fullName = name
        self.image = image
        self.isSender = isSender
    }
//    init(members : [Members], roomType: RoomType, name: String, image: String, isSender:Bool) {
//        self.members = members
//        self.roomType = roomType
//        self.fullName = name
//        self.image = image
//        self.isSender = isSender
//    }
}
