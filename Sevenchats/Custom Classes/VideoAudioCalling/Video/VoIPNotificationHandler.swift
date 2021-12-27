//
//  VoIPNotificationHandler.swift
//  Sevenchats
//
//  Created by mac-00020 on 23/10/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//

import Foundation
import ObjectMapper
import UserNotifications
//import SwiftySound

class VoIPNotificationHandler: NSObject {
    
    // MARK:-
    // MARK:- Singletone class setup..
    let notificationCenter = UNUserNotificationCenter.current()
    weak var timer : Timer?
    var notificationCount = 0
    private override init() {
        super.init()
    }
    
    private static var voipPushNotification: VoIPNotificationHandler = {
        let voipPushNotification = VoIPNotificationHandler()
        return voipPushNotification
    }()
    
    static func shared() ->VoIPNotificationHandler {
        return voipPushNotification
    }
}

//MARK: - Action for Notification
extension VoIPNotificationHandler {
    
    /// This method is getting called when notification riched.
    /// It's also used for parse the notification payload and then action by notification type.
    /// - Parameter notification: Notification Payload
    
    
    func actionOnPushNotification(notification: [String : Any]) {
        
        let _notification = AudioVideoNotification(fromDictionary: notification)
        guard let messageId = _notification.twiMessageId, !messageId.isEmpty else {return}
        
        if _notification.notificationType.rawValue == CallNotificationType.IncomingAudioCallRejected.rawValue {
            /// Reject incoming audio call
            let viewController = appDelegate.getTopMostViewController()
            
            if let controller = viewController.getViewControllerFromNavigation(AudioCallVC.self){
                controller.onDisconnectCall(UIButton())
            }
            
        } else if _notification.notificationType.rawValue == CallNotificationType.RejectVideoNotification.rawValue {
            /// Reject incoming video call
            
            if !(appDelegate.videoCallHelper?.room?.remoteParticipants.isEmpty ?? true) {
                appDelegate.videoCallHelper?.performEndCallAction()
                return
            }
            let viewController = appDelegate.getTopMostViewController()
            
            if let controller = viewController.getViewControllerFromNavigation(OneToOneVideoCallVC.self){
                if !(controller.videoCall.room?.remoteParticipants.isEmpty ?? true) {
                    return
                }
                controller.videoCall.disconnectRoom()
            }
            
            if viewController.isKind(of: IncomingVideoCallVC.classForCoder()) {
                //Sound.stopAll()
                viewController.dismiss(animated: true, completion: nil)
            }
            appDelegate.videoCallHelper?.performEndCallAction()
            removeVideoCallingNotification()
            appDelegate.notificationPayload = nil
            stopTimer()
            return
        } else if _notification.notificationType.rawValue == CallNotificationType.RejectGroupVideoNotification.rawValue && _notification.userData.roomType == .GroupRoom {
            if !(appDelegate.videoCallHelper?.room?.remoteParticipants.isEmpty ?? true) {
                return
            }
            if _notification.userData.memberIds.count <= 1 {
                /// Reject incoming  group video call If there no more then 1 members in the group
                let viewController = appDelegate.getTopMostViewController()
                
                if let controller = viewController.getViewControllerFromNavigation(OneToOneVideoCallVC.self){
                    if !(controller.videoCall.room?.remoteParticipants.isEmpty ?? true) {
                        return
                    }
                    controller.videoCall.disconnectRoom()
                }
                
                if viewController.isKind(of: IncomingVideoCallVC.classForCoder()){
                    //Sound.stopAll()
                    viewController.dismiss(animated: true, completion: nil)
                }
                appDelegate.videoCallHelper?.performEndCallAction()
                removeVideoCallingNotification()
                appDelegate.notificationPayload = nil
                stopTimer()
            } else {
                
                let viewController = appDelegate.getTopMostViewController()
                if let controller = viewController as? IncomingVideoCallVC{
                    controller.notification?.userData.memberIds = _notification.userData.memberIds
                }
                
                if let controller = viewController as? OneToOneVideoCallVC{
                    //controller.notification?.userData.memberIds = _notification.userData.memberIds
                    (controller.videoCall?.roomInfo.info as? GroupRoom)?.memberId = _notification.userData.memberIds.compactMap({$0.toInt ?? 0})
                }
            }
        } else {
            
            self.handleVideoNotification(_notification: _notification,notificationJson: notification)
        }
    }
    
    func handleVideoNotification(_notification :AudioVideoNotification, notificationJson : [String:Any]) {
        
        let viewController = appDelegate.getTopMostViewController()
        if viewController.isKind(of: IncomeAudioCallVC.classForCoder()) || viewController.isKind(of: AudioCallVC.classForCoder()) {
            //scheduleNotification(notification: _notification, notificationJson: notificationJson)
            return
        }
        if viewController.isKind(of: OneToOneVideoCallVC.classForCoder()) || viewController.isKind(of: OneToOneVideoCallVC.classForCoder()) {
            //scheduleNotification(notification: _notification, notificationJson: notificationJson)
            return
        }
        
        if _notification.userData.roomType == .UserRoom {
            appDelegate.videoCallHelper = TVIVideoHelper(
                roomInfo: MDLRoomInfo(
                    info: UserRoom(
                        id: _notification.userData.receiverId ?? 0,
                        name: _notification.userData.fullName,
                        image: _notification.userData.userImage
                    ),
                    isSender: false
                )
            )
            appDelegate.videoCallHelper?.notification = _notification
            appDelegate.videoCallHelper?.reportIncomingCall(uuid: UUID(), roomName: _notification.userData.fullName)
        }else{
            let userName = (appDelegate.loginUser?.first_name ?? "") + " " + (appDelegate.loginUser?.last_name ?? "")
            appDelegate.videoCallHelper = TVIVideoHelper(
                roomInfo: MDLRoomInfo(
                    info: GroupRoom(
                        id: _notification.userData.receiverId ?? 0,
                        memberId: _notification.userData.memberIds.compactMap({$0.toInt ?? 0}),
                        groupName: _notification.userData.groupName ,
                        name: userName,
                        image: _notification.userData.userImage
                    ),
                    isSender: false
                )
            )
            appDelegate.videoCallHelper?.notification = _notification
            appDelegate.videoCallHelper?.reportIncomingCall(uuid: UUID(), roomName: _notification.userData.groupName)
        }
        /*let applicationState = UIApplication.shared.applicationState
        if applicationState == .active {
            haldernotificationInActiveMode(_notification)
        } else if applicationState == .background {
            let viewController = appDelegate.getTopMostViewController()
            if !viewController.isKind(of: OneToOneVideoCallVC.classForCoder()){
                startTimer(notification :  _notification, notificationJson: notification)
            }
        }else{
            self.scheduleNotification(notification :  _notification, notificationJson: notification)
        }*/
    }
    
    func haldernotificationInActiveMode(_ notification : AudioVideoNotification){
        
        let viewController = appDelegate.getTopMostViewController()
        switch notification.notificationType.rawValue {
            
        case CallNotificationType.VideoNotification.rawValue :
            moveToIncomingVideoCallScreen(notification)
            break
            
        case CallNotificationType.RejectVideoNotification.rawValue :
            
            self.removeVideoCallingNotification()
            
            if let controller = viewController.getViewControllerFromNavigation(OneToOneVideoCallVC.self){
                controller.videoCall.disconnectRoom()
            }
            break
            
        case CallNotificationType.CustomNotification.rawValue :
            break
            
        case CallNotificationType.None.rawValue :
            break
        default:
            break
        }
        
        appDelegate.notificationPayload = nil
        stopTimer()
    }
}

//MARK: - Redirecto to screen
extension VoIPNotificationHandler {
    
    fileprivate func moveOnOTOVideoScreen(_ notificationInfo: AudioVideoNotification) {
        
        appDelegate.sideMenuController.rootViewController = UINavigationController.init(rootViewController: CStoryboardChat.instantiateViewController(withIdentifier: "ChatListViewController"))
        appDelegate.hideSidemenu()
        GCDMainThread.asyncAfter(deadline: .now() + kScreenMovingTime, execute: {
            if let oneToOneVideo = CStoryboardAudioVideo.instantiateViewController(withIdentifier: "OneToOneVideoCallVC") as? OneToOneVideoCallVC {
                if notificationInfo.userData.roomType == .UserRoom{
                    oneToOneVideo.id = (notificationInfo.userData.receiverId ?? 0)
                    oneToOneVideo.roomType = .UserRoom
                }else{
                    oneToOneVideo.id = notificationInfo.userData.receiverId ?? 0
                    oneToOneVideo.roomType = .GroupRoom
                }
                oneToOneVideo.isSender = false
                oneToOneVideo.fullName = notificationInfo.userData.fullName
                oneToOneVideo.userImage = notificationInfo.userData.userImage
                let viewController = appDelegate.getTopMostViewController()
                viewController.navigationController?.pushViewController(oneToOneVideo, animated: true)
            }
        })
    }
    
    fileprivate func moveToIncomingVideoCallScreen(_ notificationInfo: AudioVideoNotification) {
        
        let viewController = appDelegate.getTopMostViewController()
        if viewController.isKind(of: IncomeAudioCallVC.classForCoder()) || viewController.isKind(of: AudioCallVC.classForCoder()) {
            return
        }
        if !viewController.isKind(of: OneToOneVideoCallVC.classForCoder()){
            GCDMainThread.asyncAfter(deadline: .now() + kScreenMovingTime, execute: {
                if let incomingCall = CStoryboardAudioVideo.instantiateViewController(withIdentifier: "IncomingVideoCallVC") as? IncomingVideoCallVC {
                    print(notificationInfo.twiMessageId ?? "N/A")
                    incomingCall.notification = notificationInfo
                    if #available(iOS 13.0, *){
                        incomingCall.isModalInPresentation = true
                        incomingCall.modalPresentationStyle = .fullScreen
                    }
                    viewController.present(incomingCall, animated: true, completion: nil)
                }
            })
        } else {
            self.stopTimer()
        }
    }
}

extension VoIPNotificationHandler {
    
    /// This methods is use to fire location notification on incoming video call
    /// - Parameter notification: Notification payload object
    /// - Parameter notificationJson: notification payload JSON
    func startTimer(notification :  AudioVideoNotification, notificationJson : [String:Any]) {
        
        self.scheduleNotification(notification : notification, notificationJson: notificationJson)
        
        let timeInterval = 5.0
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true, block: { (timer) in
            if self.notificationCount >= (CallingTime * 8 / 45){
                self.stopTimer()
                return
            }
            self.scheduleNotification(notification : notification, notificationJson: notificationJson)
            self.notificationCount += 1
        })
        
    }
    
    func stopTimer() {
        //shut down timer
        timer?.invalidate()
        timer = nil
        removeVideoCallingNotification()
    }
    
    func removeVideoCallingNotification(){
        //clear out any pending and delivered notifications
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["VideoCallNotification"])
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: ["VideoCallNotification"])
        notificationCount = 0
    }
    
    /// This methods is use to fire location notification on incoming video call
    /// - Parameter notification: Notification payload object
    /// - Parameter notificationJson: notification payload JSON
    func scheduleNotification(notification : AudioVideoNotification, notificationJson : [String:Any]) {
        
        let notificationPayload = notificationJson
        var title = ""
        var body = ""
        if notification.userData.roomType == .UserRoom{
            title = "Incoming video call"
            body = "Video call from " + notification.userData.fullName
        }else{
            title = "Incoming group video call"
            body = "Video call from " + notification.userData.fullName + " in " + notification.userData.fullName
        }
        
        let content = UNMutableNotificationContent()
        let categoryIdentifire = "local_AV_notification"
        
        content.title = title
        content.body = body
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: RingToneName + "." + RingToneExt))
        content.badge = 0
        content.categoryIdentifier = categoryIdentifire
        content.userInfo = notificationPayload
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1 , repeats: false)
        let identifier = "VideoCallNotification"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
        
        let snoozeAction = UNNotificationAction(identifier: "Snooze", title: "Snooze", options: [])
        let deleteAction = UNNotificationAction(identifier: "DeleteAction", title: "Delete", options: [.destructive])
        let category = UNNotificationCategory(identifier: categoryIdentifire, actions: [snoozeAction, deleteAction], intentIdentifiers: [], options: [])
        
        notificationCenter.setNotificationCategories([category])
    }
}

