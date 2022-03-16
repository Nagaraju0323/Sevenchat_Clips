//
//  SocketIO.swift
//  Sevenchats
//
//  Created by APPLE on 07/12/21.
//  Copyright © 2021 mac-00020. All rights reserved.
//

/********************************************************
 * Author : Chandrika.R                                 *
 * Model  : SocketIO & Notification                     *
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
    let manager : SocketManager = SocketManager(socketURL: URL(string:BASEURLSOCKETNOTF)!, config: [.log(true), .compress])
    private var socketIOClient: SocketIOClient?
    
    override init() {
        super.init()
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
                let userInfo = [ "JobID" : "\(jobID)"]
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
        guard let userId = appDelegate.loginUser?.user_id.description else { return}
        socketIOClient?.on(userId) { data, ack in
            var dict = [String:Any]()
            if let notifications = data as? [[String:AnyObject]]{
                for notifi in notifications{
                    let content = notifi["content"] as? String
                    let contentConvert = content?.replace(string: "\\", replacement: "")
                    let dictNot =  self.convertToDictionaryToConent(from: contentConvert ?? "")
                    let  senderName = dictNot["senderName"] as? String ?? ""
                    self.scheduleNotification(notificationType: notifi["subject"] as? String ?? "",senderName:senderName)
                    dict["subject"] = notifi["subject"] as? String
                    dict["sender"] = notifi["sender"] as? String
                }
            }
        }
    }
    
    
    func scheduleNotification(notificationType:String,senderName:String){
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = senderName
        content.body = notificationType
        content.sound = .default
        content.userInfo = ["value": "Data with local notification"]
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
