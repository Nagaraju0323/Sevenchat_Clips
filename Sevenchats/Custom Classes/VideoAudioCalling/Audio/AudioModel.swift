//
//  AudioModel.swift
//  Sevenchats
//
//  Created by mac-00020 on 05/11/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//

import Foundation

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
