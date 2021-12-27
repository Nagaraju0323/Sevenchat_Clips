//
//  TVIParticipant.swift
//  Sevenchats
//
//  Created by mac-00020 on 21/10/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//

import Foundation
import TwilioVideo

class AppParticipant{
    
    var identity : String!
    var remoteParticipant: RemoteParticipant!
    var remoteView : VideoView?
    init() {
    }
}


enum RoomType : String {
    case UserRoom = "UserRoom"
    case GroupRoom = "GroupRoom"
}

enum CallNotificationType : String{
    case None = ""
    //case RejectNotification = "RejectNotification"
    case RejectVideoNotification = "RejectVideoNotification"
    case RejectAudioNotification = "RejectAudioNotification"
    case RejectGroupVideoNotification = "RejectGroupVideoNotification"
    case VideoNotification = "VideoNotification"
    //case AudioNotification = "AudioNotification"
    case CustomNotification = "custom-notification"
    
    
    case IncomingAudioCallRejected = "IncomingAudioCallRejected"
}

protocol AppRoom {
    var memberId : [Int] {get set}
    var id : Int {get set}
    var roomType : RoomType {get}
    var roomName : String {get}
    
    var groupName : String {get set}
    var fullName : String {get set}
    var image : String {get set}
}

class UserRoom : AppRoom {
    var memberId : [Int] = []
    var id: Int
    var roomType: RoomType = .UserRoom
    var roomName: String {
        return roomType.rawValue + id.description
    }
    var identity : String{
        return "User" + id.description
    }
    var groupName : String = ""
    var fullName : String = ""
    var image : String = ""
    
    init(id : Int, name: String, image: String) {
        self.id = id
        self.memberId = [id]
        self.fullName = name
        self.image = image
    }
}

class GroupRoom : AppRoom {
    
    var memberId : [Int] = []
    var id: Int
    var roomType: RoomType = .GroupRoom
    var roomName: String {
        return roomType.rawValue + id.description
    }
    var fullName : String = ""
    var groupName : String = ""
    var image : String = ""
    /*var identity : String{
        return "Group" + id.description
    }*/
    var memberIdentity : String{
        let identity = memberId.map({"User" + $0.description})
        return identity.joined(separator: ",")
    }
    init(id : Int,memberId : [Int], groupName:String, name: String, image: String) {
        self.id = id
        self.memberId = memberId
        self.fullName = name
        self.groupName = groupName
        self.image = image
    }
}

class MDLRoomInfo {
    
    var info : AppRoom
    var myIdentity : String{
        return "User" + (appDelegate.loginUser?.user_id ?? 0).description
        /*if info.roomType == .UserRoom{
            return "User" + (appDelegate.loginUser?.user_id ?? 0).description
        }
        return info.identity*/
    }
    
    var isSender = true
    
    init(info : AppRoom, isSender : Bool) {
        self.info = info
        self.isSender = isSender
    }
}


class CallCountDownTimer {
    
    private var startTime: Date?

    var elapsedTime: TimeInterval {
        if let startTime = self.startTime {
            return -startTime.timeIntervalSinceNow
        } else {
            return 0
        }
    }
    
    var elapsedTimeAsString: String {
        return String(format: "%02d:%02d",
            Int(elapsedTime / 60), Int(elapsedTime.truncatingRemainder(dividingBy: 60)))
    }
    
    var isRunning: Bool {
        return startTime != nil
    }
    
    func start() {
        startTime = Date()
    }
    
    func stop() {
        startTime = nil
    }
    
}
