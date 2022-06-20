//
//
//  SocketIO.swift
//  Sevenchats
//
//  Created by APPLE on 07/12/21.
//  Copyright © 2021 mac-00020. All rights reserved.
//

/********************************************************
 * Author : Nagaraju K and Chandrika R                   *
 * Model  : SocketIO & Notification                      *
 * Description: Create SocketIO,Popup for Notifcations   *
 ********************************************************/

import UIKit
import Foundation
import SocketIO
import UserNotifications

//ws://dev.sevenchats.com:1923

class SocketIOManager: NSObject {
    class func shared() -> SocketIOManager { // change class to final to prevent override
        guard let uwShared = sharedInstance else {
            sharedInstance = SocketIOManager()
            return sharedInstance!
        }
        return uwShared
    }
    
    private static var sharedInstance : SocketIOManager?
    let manager : SocketManager = SocketManager(socketURL: URL(string:BASEURLSOCKETNOTF)!, config: [.forceWebsockets(true),.forceNew(true),.log(true), .compress])
    private var socketIOClient: SocketIOClient?
    
    override init() {
        super.init()
        socketIOClient?.on(clientEvent: .reconnect) {data, ack in
                debugPrint("socket reconnecting")
            }
        socketIOClient = manager.defaultSocket
        registerForRemoteNotifictionViaSocket()
        createListererForUpComingJob()
        
    }
    
    //MARK:- Create Scoket Connection
    func establishConnection() {
        socketIOClient?.connect()
        socketIOClient?.on(clientEvent: .connect, callback: { (data, ack) in
        })
    }
    
    func disConnectSocket() {
        socketIOClient?.disconnect()
    }
    
    func createListererForUpComingJob() {
        guard let userId = appDelegate.loginUser?.user_id.description else { return}
        self.socketIOClient?.on(userId, callback: { (data, ack) in
            if let notification = data.first as? Dictionary<AnyHashable , Any>, let jobID = notification["jobId"] {
                _ = [ "JobID" : "\(jobID)"]
            }
        })
    }
    
    func removeListenerForUpcomingJob() {
        guard let userId = appDelegate.loginUser?.user_id.description else { return}
        self.socketIOClient?.off(userId)
    }
    
    
    
    //MARK:- Check Socket Status
    func checkSocketStatus() -> Bool {
        let status = socketIOClient?.status
        return status == .connected ? true : false
    }
    
    func registerForRemoteNotifictionViaSocket() {
        
      //  guard let userId = appDelegate.loginUser?.user_id.description else { return}
        socketIOClient?.onAny { event in
             print("Got event: \(event.event), with items: \(event.items)")
            
            let eventNotificationInfo = event.items ?? []
            guard let userID = appDelegate.loginUser?.user_id else { return }
            if event.event == userID.description{
            for evntinfo in eventNotificationInfo{
                var dict = [String:Any]()
                var postInfoConent = [String:Any]()
                let eventConvertObj = evntinfo as? [String:Any] ?? [:]
                let content = eventConvertObj["content"] as? String
                let contentConvert = content?.replace(string: "\\", replacement: "")
                let dictNot =  self.convertToDictionaryToConent(from: contentConvert ?? "")
                var postInfo = dictNot["postInfo"] as? [String:Any] ?? [:]
                let  senderName = dictNot["senderName"] as? String ?? ""
                postInfoConent["content"] = content
                self.scheduleNotification(notificationType: eventConvertObj["subject"] as? String ?? "",senderName:senderName,postInfo:postInfoConent)
                dict["subject"] = eventConvertObj["subject"] as? String
                dict["sender"] = eventConvertObj["sender"] as? String
                print("this is onAny observer")
                NotificationCenter.default.post(name: Notification.Name("LoadMsgData"), object: nil,userInfo: nil)
            }
        }
        }
        socketIOClient?.connect()
        
        guard let userId = appDelegate.loginUser?.user_id.description else { return}
        socketIOClient?.on(userId) { data, ack in
            var dict = [String:Any]()
            var postInfoConent = [String:Any]()
            if let notifications = data as? [[String:AnyObject]]{
                for notify in notifications{
                    let content = notify["content"] as? String
                    let contentConvert = content?.replace(string: "\\", replacement: "")
                    let dictNot =  self.convertToDictionaryToConent(from: contentConvert ?? "")
                    let  senderName = dictNot["senderName"] as? String ?? ""
                    postInfoConent["content"] = content
                    self.scheduleNotification(notificationType: notify["subject"] as? String ?? "",senderName:senderName,postInfo:postInfoConent)
                    dict["subject"] = notify["subject"] as? String
                    dict["sender"] = notify["sender"] as? String
                   print("this is calling observer")
                    NotificationCenter.default.post(name: Notification.Name("LoadMsgData"), object: nil,userInfo: nil)
                }
            }
        }
    }
    
    
    
    func scheduleNotification(notificationType:String,senderName:String,postInfo:[String:Any]){
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = senderName
        content.body = notificationType
        content.sound = .default
        content.badge = NSNumber(value: UIApplication.shared.applicationIconBadgeNumber + 1)
        content.userInfo = postInfo
        let fireDate = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute, .second], from: Date().addingTimeInterval(1))
        let trigger = UNCalendarNotificationTrigger(dateMatching: fireDate, repeats: false)
        let request = UNNotificationRequest(identifier: "reminder", content: content, trigger: trigger)
        center.add(request) { (error) in
            if error != nil {
                print("Error = \(error?.localizedDescription ?? "error local notification")")
            }
        }
    }
    
    
    func convertToDictionarywithtry(from text: String) -> [String: String]? {
        guard let data = text.data(using: .utf8) else { return nil }
        let anyResult = try? JSONSerialization.jsonObject(with: data, options: [])
        return anyResult as? [String: String]
    }
    
    func convertToDictionary(from text: String) -> [String: Any] {
        //  print("text from the valies\(text)")
        guard let data = text.data(using: .utf8) else { return [:] }
        let anyResult: Any? = try? JSONSerialization.jsonObject(with: data, options:[])
        return anyResult as? [String: Any] ?? [:]
    }
    
    func convertToDictionaryToConent(from text: String) -> [String: Any] {
        //  print("text from the valies\(text)")
        guard let data = text.data(using: .utf8) else { return [:] }
        let anyResult: Any? = try? JSONSerialization.jsonObject(with: data, options:[])
        return anyResult as? [String: Any] ?? [:]
    }
    
}
