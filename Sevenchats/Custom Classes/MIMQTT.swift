//
//  MIMQTT.swift
//  Sevenchats
//
//  Created by mac-0005 on 18/01/19.
//  Copyright © 2018 mac. All rights reserved.
//

//import UIKit
//import CocoaMQTT
//import AVKit
//import TrueTime
//
//let CPUBLISHMESSAGETYPE             = 1
//let CPUBLISHREADTYPE                = 2
//let CPUBLISHBLOCKUSER               = 3
//let CPUBLISHFRIENDUNFRIENDUSER      = 4
//let CPUBLISHONLINEOFFLIEN           = 5
//let CPUBLISHDELETECREATEGROUP       = 6
//let CPUBLISHDELETEMESSAGE           = 7
//
//let CMQTTUSERTOPIC = "mchat/"
//let CMQTTUSERONLINEOFFLINETOPIC = "mchat/on-off"
//let CMQTTUSERNAME = ""
//let CMQTTPASSWORD = ""
//
//// LIVE
////let CMQTTHOST = "mqtt.sevenchats.com"
////let cMQTTPort = UInt16(80)
//
//// LOCAL
////let CMQTTHOST =  "tcp://0.tcp.ngrok.io"
////let cMQTTPort = UInt16(13105)
//
//let CMQTTHOST =  "test.sevenchats.com"
//let cMQTTPort = UInt16(1882)
//
//var ClientID  = "ios-" + (Date().millisecondsSince1970.description + ProcessInfo().processIdentifier.description) + "-\(appDelegate.loginUser?.user_id ?? Int64(0.0))"  //ios-RANDOMNUMBER(10)-USERID
//
//enum MessageType : Int {
//    case text = 1
//    case image = 2
//    case video = 3
//    case audio = 4
//    case location = 6
//}
//
//enum ChatType : Int {
//    case user = 1
//    case group = 2
//}
//
//enum MessageDeliveredStatus : Int {
//    case local = 1
//    case sent = 2
//    case read = 3
//}
//
//
//// MQTTDelegate Methods
//@objc protocol MQTTDelegate: class {
//    @objc optional func didReceiveMessage(_ message: [String : Any]?)
//    @objc optional func didRefreshMessage()
//    @objc optional func didChangedOnlineOfflineStatus(_ message: [String : Any]?)
//    @objc optional func blockUnblockFriendUnfriendStatus(_ message: [String : Any]?)
//    @objc optional func didDeletedGroup(_ message: [String : Any]?)
//}
//
//
//class MIMQTT: NSObject {
//    weak var mqttDelegate: MQTTDelegate?
//
//    var objMQTTClient : CocoaMQTT?
//    var timeClient: TrueTimeClient?
//
//    private override init() {
//        super.init()
//    }
//
//    private static var mqtt: MIMQTT = {
//        let mqtt = MIMQTT()
//        return mqtt
//    }()
//
//    static func shared() ->MIMQTT {
//        return mqtt
//    }
//
//    func updateClientId (){
//        let random = Date().millisecondsSince1970.description + ProcessInfo().processIdentifier.description
//        ClientID  = "ios-" + random + "-\(appDelegate.loginUser?.user_id ?? Int64(0.0))"  //ios-RANDOMNUMBER-USERID
//        objMQTTClient?.clientID = ClientID
//    }
//}
//
//// MARK:- ------- MQTT Configuration
//// MARK:-
//
//extension MIMQTT {
//
//    // MQTT initialization..
//    func MQTTInitialSetup() {
//        if appDelegate.loginUser == nil {
//            return
//        }
//        if objMQTTClient == nil {
//            print(ClientID)
//            objMQTTClient = CocoaMQTT(clientID: ClientID, host:CMQTTHOST, port:cMQTTPort)
//        }
//
//        objMQTTClient?.username = CMQTTUSERNAME
//        objMQTTClient?.password = CMQTTPASSWORD
//        objMQTTClient?.willMessage = CocoaMQTTWill(topic: "/will", message: "dieout")
//        objMQTTClient?.keepAlive = 60
//        objMQTTClient?.delegate = self
//        _ = objMQTTClient?.connect()
//
//        // Update uploading status for retry button for media messages..
//        self.updateMediaUploadingStatusForRetry()
//
//        NotificationCenter.default.addObserver(self, selector: #selector(self.timeChangedNotification), name: NSNotification.Name.NSSystemClockDidChange, object: nil)
//    }
//
//    @objc func timeChangedNotification(notification:NSNotification) {
//        print("Device time has been changed...")
//        self.deviceActualTime()
//    }
//
//    // Publish message here...
//    func MQTTPublishWithTopic(_ payload:[String : Any], _ topic : String?) {
//
//        // mchat/userId
//        let jsonData = try? JSONSerialization.data(withJSONObject: payload, options: [])
//        let jsonString = String(data: jsonData!, encoding: .utf8)
//        objMQTTClient?.publish(topic!, withString: jsonString!)
//    }
//
//    // Subscribe topic here..
//    func MQTTSubscribeWithTopic(_ id:Any?, topicPrefix : String?) {
//        print("\(topicPrefix ?? "")\(id ?? "")")
//
//        objMQTTClient?.subscribe("\(topicPrefix ?? "")\(id ?? "")")
//    }
//
//    // Unsubscribe topic here..
//    func MQTTUnsubscribeWithTopic(_ id:Any?, topicPrefix : String?) {
//        objMQTTClient?.unsubscribe("\(topicPrefix ?? "")\(id ?? "")")
//    }
//}
//
//// MARK:- ------- CocoaMQTTDelegate
//// MARK:-
//
//extension MIMQTT: CocoaMQTTDelegate {
//
//    // DID CONNECT HERE.....
//    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
//        print("DId CONNECTED ====== ")
//        self.MQTTSubscribeWithTopic(appDelegate.loginUser?.user_id, topicPrefix: CMQTTUSERTOPIC)
//        self.MQTTSubscribeWithTopic(nil, topicPrefix: CMQTTUSERONLINEOFFLINETOPIC)
//        self.syncUnsentTextMessageToServer()
//    }
//
//    func mqttDidPing(_ mqtt: CocoaMQTT) {
//        print("mqttDidPing ======= ")
//    }
//
//    func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
//        print("mqttDidReceivePong ======== ")
//    }
//
//    // DID DISCONECT HERE.....
//    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
//        //print("mqttDidDisconnect ======== ")
//
//        GCDMainThread.asyncAfter(deadline: .now() + 1) {
//            // Reconnect if user loged in...
//            if appDelegate.loginUser?.user_id != nil && UIApplication.shared.applicationState == .active {
//                if MIMQTT.shared().objMQTTClient != nil {
//                    if !(MIMQTT.shared().objMQTTClient?.connect())! {
//                        _ = MIMQTT.shared().objMQTTClient?.connect()
//                    }
//                }
//            }
//        }
//    }
//
//    // DID PUBLISH MESSAGE HERE.....
//    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
//        print("DID PUBLISH MESSAGE ==== ")
//    }
//
//    // DID PUBLISH ACK HERE...
//    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
//        //print("DID PUBLISH ACK ==== ")
//    }
//
//    // DID RECEIVED MESSGE HERE.....
//    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16) {
//        print("Message received in topic \(message.topic) with payload \(message.string!)")
//
//        // Convert Json into dictionay here.....
//        let messageInfo = self.convertToDictionary(text: message.string!)
//
//        if messageInfo?.valueForInt(key: CPublishType) == CPUBLISHREADTYPE {
//            // READ MESSAGE
//            self.updateMessageInLocalForReadACK(messageInfo!)
//        }else if messageInfo?.valueForInt(key: CPublishType) == CPUBLISHBLOCKUSER {
//            // BLOCK USER
//            self.updateStatusForBlockUnblockFriendUnfriend(messageInfo!)
//        }else if messageInfo?.valueForInt(key: CPublishType) == CPUBLISHFRIENDUNFRIENDUSER {
//            // Friend/Unfriend user...
//            self.updateStatusForBlockUnblockFriendUnfriend(messageInfo!)
//        }else if messageInfo?.valueForInt(key: CPublishType) == CPUBLISHONLINEOFFLIEN {
//            // Online/Offline user...
//            self.updateUserOnlineOfflineStatus(messageInfo!)
//        }else if messageInfo?.valueForInt(key: CPublishType) == CPUBLISHDELETECREATEGROUP {
//            // DELETE/CREATE GROUP
//            self.updateforDeletedGroup(messageInfo!)
//        }else if messageInfo?.valueForInt(key: CPublishType) == CPUBLISHDELETEMESSAGE {
//            // DELETE MESSAGE FROM ADMIN SIDE
//            self.updateMessageDeleteStatus(messageInfo!)
//        }else {
//            // Store message in local...
//            self.saveMessageToLocal(messageInfo: messageInfo!, msgDeliveredStatus: 2, localPayload: false)
//        }
//
//
//    }
//
//    // DID SUBSCRIBE TOPIC HERE...
//    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopic topics: [String]) {
//         print("DID SUBSCRIBE TOPIC  ==== ")
//    }
//
//    // DID UNSUBSCRIBE TOPIC HERE...
//    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) {
//        print("DID UNSUBSCRIBE TOPIC ==== ")
//    }
//}
//
//// MARK:- ------- Helper Functions
//// MARK:-
//extension MIMQTT {
//    func deviceActualTime() {
//        // At an opportune time (e.g. app start):
//
//        if timeClient == nil {
//            timeClient = TrueTimeClient.sharedInstance
//            timeClient?.start()
//        }
//
//        // To block waiting for fetch, use the following:
//        timeClient?.fetchIfNeeded { result in
//            switch result {
//            case let .success(referenceTime):
//                let now = referenceTime.now()
//                let timeDifference = (Date().timeIntervalSince1970 * 1000) - (now.timeIntervalSince1970 * 1000)
//                CUserDefaults.setValue(timeDifference, forKey: UserDefaultTimeDifference)
//                self.updateMessageTimeAccordingToDevice()
//            case let .failure(error):
//                print("Error! \(error)")
//            }
//        }
//    }
//
//    func convertToDictionary(text: String) -> [String: Any]? {
//        if let data = text.data(using: .utf8) {
//            do {
//                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
//        return nil
//    }
//}
//
//// MARK:- ------- Message Publish functions
//// MARK:-
//extension MIMQTT {
//
//    func messagePaylaod(arrUser: [String?], channelId: String?, message: String?, messageType: MessageType?, chatType: ChatType?,  groupID: String?, latitude:Double = 0.0, longitude:Double = 0.0, address: String = "", forwardedMsgId: String = "", cloleFile:MDLCloneMedia? = nil) {
//
//        var dicPayload = [String : Any]()
//        dicPayload[CSender_Id] = appDelegate.loginUser?.user_id
//        dicPayload[CMessage] = message
//        dicPayload[CMsg_type] = messageType?.rawValue
//        dicPayload[CChat_type] = chatType?.rawValue
//        dicPayload[CMessage_id] = (UIDevice.current.identifierForVendor?.uuidString)!.replacingOccurrences(of: "-", with: "") + "\(Int(Date().timeIntervalSince1970 * 1000))"
//        dicPayload[CChannel_id] = channelId
//        dicPayload[CFullName] = (appDelegate.loginUser?.first_name)! + " " + (appDelegate.loginUser?.last_name)!
//        dicPayload[CProfileImage] = appDelegate.loginUser?.profile_img
//        dicPayload[CUsers] = arrUser.compactMap({$0}).joined(separator: ",")
//        dicPayload[CPublishType] = CPUBLISHMESSAGETYPE
//
//        dicPayload[CLatitude] = latitude
//        dicPayload[CLongitude] = longitude
//        dicPayload[CAddress] = address
//        dicPayload["forwarded_msg_id"] = forwardedMsgId
//
//        if let time = timeClient, time.referenceTime?.now() != nil {
//            dicPayload[CCreated_at] = ((time.referenceTime?.now().timeIntervalSince1970 ?? 0) * 1000).toInt
//        }else {
//            dicPayload[CCreated_at] = DateFormatter.shared().currentGMTTimestampInMilliseconds()?.toInt
//        }
//
//        dicPayload[CGroupId] = groupID != nil ? groupID?.toInt : 0
//        dicPayload[CThumb_Url] = ""
//        dicPayload[CThumb_Name] = ""
//        dicPayload[CMedia_Name] = ""
//
//        if let _cloleFile = cloleFile {
//            dicPayload["localMediaUrl"] = _cloleFile.localMediaUrl
//            dicPayload["media_name"] = _cloleFile.image
//
//            if !_cloleFile.thumbUrl.isEmpty {
//                dicPayload["thumb_url"] = _cloleFile.thumbUrl
//                dicPayload["thumb_name"] = _cloleFile.thumbName
//            }
//        }
//
//        print(dicPayload)
//        if chatType == .user {
//            // FOR OTO CHAT Reciver id is always front user...
//            if let index = arrUser.firstIndex(where: { $0 != "\(appDelegate.loginUser?.user_id ?? 0)"}) {
//                dicPayload[CRecv_id] = arrUser[index]?.toInt ?? 0
//            }
//
//            // Publish Text message directly
//            if messageType == .text {
//                for userId in arrUser {
//                    MIMQTT.shared().MQTTPublishWithTopic(dicPayload, CMQTTUSERTOPIC + "\(userId ?? "0")")
//                }
//            }
//        } else {
//            // FOR Group CHAT
//            for userId in arrUser {
//                dicPayload[CRecv_id] = userId?.toInt
//
//                // Publish Text message directly
//                if messageType == .text {
//                    MIMQTT.shared().MQTTPublishWithTopic(dicPayload, CMQTTUSERTOPIC + "\(userId ?? "0")")
//                }
//            }
//        }
//
//        self.saveMessageToLocal(messageInfo: dicPayload, msgDeliveredStatus: 1, localPayload: true)
//    }
//
//    // Publish for Group Delete/Create status
//    func messagePayloadForGroupCreateAndDelete(arrUser: [String?], status: Int, groupId: String?, isSend: Int?) {
//        var dicPayload = [String : Any]()
//        dicPayload[CGroupId] = groupId != nil ? groupId?.toInt : 0
//        dicPayload[CJsonStatus] = status
//        dicPayload[CIs_send] = isSend
//        dicPayload[CPublishType] = CPUBLISHDELETECREATEGROUP
//
//        // Publish to all user..
//        for userId in arrUser {
//            dicPayload[CUserId] = userId
//            dicPayload[CChannel_id] = CMQTTUSERTOPIC + "\(userId ?? "0")"
//            MIMQTT.shared().MQTTPublishWithTopic(dicPayload, CMQTTUSERTOPIC + "\(userId ?? "0")")
//        }
//    }
//
//    // Publish for message read Acknowledgement
//    func sendMessageReadAcknowledgement(messageInfo: [String : Any], groupID: Int?) {
//
//        if Int64(messageInfo.valueForString(key: CSender_Id)) != appDelegate.loginUser?.user_id {
//            var dicPayload = [String : Any]()
//            dicPayload[CMessage_id] = messageInfo.valueForString(key: CMessage_id)
//            dicPayload[CUserId] = appDelegate.loginUser?.user_id
//            dicPayload[CPublishType] = CPUBLISHREADTYPE
//            dicPayload[CGroupId] = groupID != nil ? groupID : 0
//
//            if let time = timeClient, time.referenceTime?.now() != nil {
//                dicPayload[CCreated_at] = ((time.referenceTime?.now().timeIntervalSince1970 ?? 0) * 1000).toInt
//            }else {
//                dicPayload[CCreated_at] = DateFormatter.shared().currentGMTTimestampInMilliseconds()?.toInt
//            }
//            dicPayload[CChannel_id] = CMQTTUSERTOPIC + messageInfo.valueForString(key: CSender_Id)
//            MIMQTT.shared().MQTTPublishWithTopic(dicPayload, CMQTTUSERTOPIC + messageInfo.valueForString(key: CSender_Id))
//        }
//
//    }
//
//    // Publish for Unsent message///
//    fileprivate func publishUnsentMessages(_ message: TblMessages?) {
//
//        if let messageInfo = message {
//            var payload = messageInfo.dictionaryWithValues(forKeys: Array((messageInfo.entity.attributesByName.keys)))
//            let arrUsers = (messageInfo.users! as NSString).components(separatedBy: ",")
//
//            // Remove unwated keys from MQTT payload..
//            payload.removeValue(forKey: "isMediaUploadedOnServer")
//            payload.removeValue(forKey: "isMediaDownloading")
//            payload.removeValue(forKey: "localMediaUrl")
//            payload.removeValue(forKey: "message_Delivered")
//            payload.removeValue(forKey: "isMediaUploadingRunning")
//            payload.removeValue(forKey: "read_users")
//            payload.removeValue(forKey: "msgdate")
//            payload.removeValue(forKey: "msg_time")
//
//            /*if messageInfo.msg_type != 6 {
//                payload.removeValue(forKey: "latitude")
//                payload.removeValue(forKey: "longitude")
//                payload.removeValue(forKey: "address")
//            }*/
//
//            let groupId = payload[CGroup_Id] as? String ?? "0"
//            let latitude = payload[CLatitude] as? Double ?? 0.0
//            let longitude = payload[CLongitude] as? Double ?? 0.0
//            let address = payload[CAddress] as? String ?? ""
//            let thumeURL = payload[CThumb_Url] as? String ?? ""
//            let thumeName = payload[CThumb_Name] as? String ?? ""
//
//            payload[CLatitude] = latitude
//            payload[CLongitude] = longitude
//            payload[CAddress] = address
//            payload[CThumb_Url] = thumeURL
//            payload[CThumb_Name] = thumeName
//            payload[CGroup_Id] = groupId.toInt ?? 0
//
//
//            let createdAt = payload[CCreated_at] as? Double
//            payload[CCreated_at] = Int(createdAt ?? 0)
//            if messageInfo.chat_type == 1 {
//
//                // FOR OTO CHAT
//                if let index = arrUsers.firstIndex(where: { $0 != "\(appDelegate.loginUser?.user_id ?? 0)"}) {
//                    payload[CRecv_id] = arrUsers[index].toInt
//                }
//                for userId in arrUsers {
//                    // publish message here...
//                    payload[CChannel_id] = CMQTTUSERTOPIC + "\(userId)"
//                    //print(payload)
//                    MIMQTT.shared().MQTTPublishWithTopic(payload, CMQTTUSERTOPIC + "\(userId)")
//                }
//            }else {
//                // FOR Group CHAT
//                for userId in arrUsers {
//                    // publish message here...
//                    payload[CRecv_id] = userId.toInt
//                    MIMQTT.shared().MQTTPublishWithTopic(payload, CMQTTUSERTOPIC + "\(userId)")
//                }
//            }
//        }
//    }
//
//    // To sync unsent Text message from local...
//    func syncUnsentTextMessageToServer() {
//        // Get Text Messages which is not uploaded yet...
//        if let arrMSG = TblMessages.fetch(predicate: NSPredicate(format: "\(CMessage_Delivered) == 1 && \(CMsg_type) == 1")) as? [TblMessages] {
//            for messageInfo in arrMSG {
//                self.publishUnsentMessages(messageInfo)
//            }
//        }
//
//
//        // Get media which is sent but not publish yet...
//        if let arrMSG = TblMessages.fetch(predicate: NSPredicate(format: "isMediaUploadedOnServer == true && \(CMessage_Delivered) == 1 && \(CMsg_type) != 1")) as? [TblMessages] {
//            for messageInfo in arrMSG {
//                self.publishUnsentMessages(messageInfo)
//            }
//        }
//
//    }
//
//    // To sync unsent Media message from local...
//    func syncUnsentMediaToServer(_ channelID: String?) {
//
//        // Get media which is not uploaded yet...
//        if let arrMSG = TblMessages.fetch(predicate: NSPredicate(format: "isMediaUploadingRunning == null && \(CMessage_Delivered) == 1 && \(CMsg_type) != 1 && \(CChannel_id) == %@", channelID!)) as? [TblMessages] {
//            for messageInfo in arrMSG {
//                messageInfo.isMediaUploadingRunning = 1
//                CoreData.saveContext()
//                self.uploadMediaOnServer(messageInfo)
//            }
//        }
//    }
//
//    // To update isMediaUploadingRunning status for retry Button..
//    fileprivate func updateMediaUploadingStatusForRetry() {
//        if let arrMSG = TblMessages.fetch(predicate: NSPredicate(format: "isMediaUploadingRunning == 2 && (isMediaUploadedOnServer == null || isMediaUploadedOnServer == false) && \(CMessage_Delivered) == 1 && \(CMsg_type) != 1")) as? [TblMessages] {
//            for messageInfo in arrMSG {
//                messageInfo.isMediaUploadingRunning = 1
//                CoreData.saveContext()
//            }
//        }
//
//        // Update Downloading status
//        if let arrMSG = TblMessages.fetch(predicate: NSPredicate(format: "isMediaDownloading == true && \(CMsg_type) != 1")) as? [TblMessages] {
//            for messageInfo in arrMSG {
//                messageInfo.isMediaDownloading = false
//                CoreData.saveContext()
//            }
//        }
//
//    }
//
//    // Delete Messages from local (Only those messages will not uploaed on server...)
//    func deleteMessageFromLocal(_ message: TblMessages?) {
//        TblMessages.deleteObjects(predicate: NSPredicate(format: "self == %@", message!))
//        CoreData.saveContext()
//        if self.mqttDelegate != nil {
//            self.mqttDelegate?.didRefreshMessage?()
//        }
//    }
//
//    // To update message delete status..
//    fileprivate func updateMessageDeleteStatus(_ messageInfo:[String : Any]) {
//
//        if let arrMessage = TblMessages.fetch(predicate: NSPredicate(format: "\(CMessage_id) == %@",messageInfo.valueForString(key: CMessage_id))) as? [TblMessages] {
//
//            let deleteStatus = messageInfo.valueForInt(key: CJsonStatus)
//            for msgInfo in arrMessage {
//
//                // Remove Media from document directory if deleted message type is Audio/Video
//                if msgInfo.msg_type == 3 || msgInfo.msg_type == 4 {
//
//                    if let localMediaURL = msgInfo.localMediaUrl {
//                        let mediaPath = CTopMostViewController.applicationDocumentsDirectory()! + "/" + localMediaURL
//                        if FileManager.default.fileExists(atPath: mediaPath) {
//                            try! FileManager.default.removeItem(atPath: mediaPath)
//                        }
//                    }
//                }
//
//                if deleteStatus == 1 {
//                    // This message is Deleted For sender only
//                    self.deleteMessageFromLocal(msgInfo)
//                }else {
//                    // This message is Deleted For all user
//                    msgInfo.status_id = Int16(deleteStatus ?? 0)
//                    msgInfo.msg_type = 1
//                    CoreData.saveContext()
//                    if self.mqttDelegate != nil {
//                        self.mqttDelegate?.didRefreshMessage?()
//                    }
//                }
//            }
//        }
//    }
//
//    // To Delete Delivered messages.
//    func deleteDeliveredMessage(_ messageInfo: TblMessages, isSender: Bool) {
//
//        var payload = [String:Any]()
//        payload[CPublishType] = CPUBLISHDELETEMESSAGE
//        payload[CMessage_id] = messageInfo.message_id
//        payload[CUserId] = appDelegate.loginUser?.user_id
//        payload[CGroupId] = messageInfo.chat_type == 2 ? messageInfo.group_id : 0
//
//        let arrUsers = (messageInfo.users! as NSString).components(separatedBy: ",")
//        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//
//        alertController.addAction(UIAlertAction(title: CBtnDeleteForMe, style: .destructive, handler: { (alert) in
//            payload[CJsonStatus] = 1
//            payload[CIs_sender] = 1
//            payload[CChannel_id] = CMQTTUSERTOPIC + "\(appDelegate.loginUser?.user_id ?? 0)"
//            MIMQTT.shared().MQTTPublishWithTopic(payload, CMQTTUSERTOPIC + "\(appDelegate.loginUser?.user_id ?? 0)")
//        }))
//
//        if isSender {
//            alertController.addAction(UIAlertAction(title: CBtnDeleteForEveryone, style: .destructive, handler: { (alert) in
//                payload[CJsonStatus] = 2
//
//                for userId in arrUsers {
//                    payload[CIs_sender] = userId == "\(appDelegate.loginUser?.user_id ?? 0)" ? 1 : 0
//                    // publish message here...
//                    payload[CChannel_id] = CMQTTUSERTOPIC + "\(userId)"
//                    MIMQTT.shared().MQTTPublishWithTopic(payload, CMQTTUSERTOPIC + "\(userId)")
//                }
//            }))
//        }
//
//        alertController.addAction(UIAlertAction(title: CBtnCancel, style: .cancel, handler: nil))
//        CTopMostViewController.present(alertController, animated: true, completion: nil)
//    }
//}
//
//// MARK:- ------- Api Functions
//// MARK:-
//extension MIMQTT {
//
//    func uploadMediaApi(_ messageInfo: TblMessages, mediaData: Data, videoThumb: UIImage?) {
//        let msgType = messageInfo.msg_type
//        let chatType = messageInfo.chat_type
//
//        var thumbData = Data()
//        if videoThumb != nil {
//            thumbData = (videoThumb?.jpegData(compressionQuality: 0.9))!
//        }
//
//        if mediaData.count != 0 {
//
//            APIRequest.shared().chatMediaUpload(msgType: Int(msgType), chatType: Int(chatType), mediaData: mediaData, videoThumbData: thumbData) { (response, error) in
//
//                if response != nil && error == nil {
//                    if let mediaData = response![CJsonData] as? [String : Any] {
//                        messageInfo.media_name = mediaData.valueForString(key: "image")
//                        messageInfo.message = mediaData.valueForString(key: "url")
//                        messageInfo.isMediaUploadedOnServer = true
//
//                        // Video Thumb..
//                        if !mediaData.valueForString(key: CThumb_Url).isBlank {
//                            messageInfo.thumb_url = mediaData.valueForString(key: CThumb_Url)
//                            messageInfo.thumb_name = mediaData.valueForString(key: CThumb_Name)
//                        }
//
//                        CoreData.saveContext()
//                        self.publishUnsentMessages(messageInfo)
//                    }else {
//                        // Media uploading failed.
//                        messageInfo.isMediaUploadingRunning = 1
//                        CoreData.saveContext()
//                    }
//                }else {
//                    // Media uploading failed.
//                    messageInfo.isMediaUploadingRunning = 1
//                    CoreData.saveContext()
//                }
//
//                // Refresh Respective Viewcontroller for uploading status..
//                if self.mqttDelegate != nil {
//                    self.mqttDelegate?.didRefreshMessage?()
//                }
//
//            }
//        }
//    }
//
//    func uploadMediaOnServer(_ mediaInfo: TblMessages?) {
//        if let messageInfo = mediaInfo {
//
//            // For uploading notifications...
//            messageInfo.isMediaUploadingRunning = 2
//            CoreData.saveContext()
//            self.mqttDelegate?.didRefreshMessage?()
//
//            var mediaData = Data()
//
//            switch messageInfo.msg_type {
//            case 2:
//                // IMAGE
//                print("UPLOAD IMAGE HERE========")
//                if messageInfo.localMediaUrl != nil {
//                    let imgPath = CTopMostViewController.applicationDocumentsDirectory()! + messageInfo.localMediaUrl!
//                    if FileManager.default.fileExists(atPath: imgPath) {
//                        let image = UIImage(contentsOfFile: imgPath)
//                        mediaData = (image?.jpegData(compressionQuality: 0.9))!
//                        self.uploadMediaApi(messageInfo, mediaData: mediaData, videoThumb: nil)
//                    }else {
//                        self.showAlertWhenMediaDoesNotExistWhileUploading(messageInfo)
//                    }
//                }
//
//                break
//            case 3:
//                // VIDEO
//                print("UPLOAD VIDEO HERE========")
//                if messageInfo.localMediaUrl != nil {
//                    let videoPath = CTopMostViewController.applicationDocumentsDirectory()! + "/" + (messageInfo.localMediaUrl)!
//                    if FileManager.default.fileExists(atPath: videoPath) {
//                        do {
//                            mediaData = try Data(contentsOf: URL(fileURLWithPath: videoPath))
//
//                            self.getVideoThumbNail(URL(fileURLWithPath: videoPath)) { (image) in
//                                self.uploadMediaApi(messageInfo, mediaData: mediaData, videoThumb: image)
//                            }
//
//                        }catch {
//                            print("Unable to load data: \(error)")
//                        }
//                    }else {
//                        self.showAlertWhenMediaDoesNotExistWhileUploading(messageInfo)
//                    }
//                }
//                break
//            case 4:
//                // AUDIO
//                print("UPLOAD AUDIO HERE========")
//                if messageInfo.localMediaUrl != nil {
//                    let audioPath = CTopMostViewController.applicationDocumentsDirectory()! + "/" + (messageInfo.localMediaUrl)!
//                    if FileManager.default.fileExists(atPath: audioPath) {
//                        do {
//                            mediaData = try Data(contentsOf: URL(fileURLWithPath: audioPath))
//                            self.uploadMediaApi(messageInfo, mediaData: mediaData, videoThumb: nil)
//                        }catch {
//                            print("Unable to load data: \(error)")
//                        }
//                    }else {
//                        self.showAlertWhenMediaDoesNotExistWhileUploading(messageInfo)
//
//                    }
//                }
//                break
//            case 6:
//                // Share Location
//                print("UPLOAD SHARE LOCATION IMAGE HERE========")
//                if messageInfo.localMediaUrl != nil {
//                    let audioPath = CTopMostViewController.applicationDocumentsDirectory()! + "/" + (messageInfo.localMediaUrl)!
//                    if FileManager.default.fileExists(atPath: audioPath) {
//                        do {
//                            mediaData = try Data(contentsOf: URL(fileURLWithPath: audioPath))
//                            self.uploadMediaApi(messageInfo, mediaData: mediaData, videoThumb: nil)
//                        }catch {
//                            print("Unable to load data: \(error)")
//                        }
//                    }else {
//                        self.showAlertWhenMediaDoesNotExistWhileUploading(messageInfo)
//
//                    }
//                }
//                break
//
//            default:
//                break
//            }
//        }
//    }
//
//    // While uploading if media not found in document directory then show alert to user..
//    func showAlertWhenMediaDoesNotExistWhileUploading(_ messageInfo: TblMessages?) {
//        MIToastAlert.shared.showToastAlert(position: .bottom, message: CMessageMediaNotExist)
//        // Media uploading failed.
//        messageInfo?.isMediaUploadingRunning = 1
//        CoreData.saveContext()
//        // Refresh Respective Viewcontroller for uploading status..
//        if self.mqttDelegate != nil {
//            self.mqttDelegate?.didRefreshMessage?()
//        }
//    }
//}
//
//// MARK:- ------- Media Related fucntions
//// MARK:-
//extension MIMQTT {
//
//    // To Create Video Thumnail image.
//    func getVideoThumbNail(_ sourceURL:URL?, completed: @escaping (_ thumImage:UIImage) -> Void) {
//
//        GCDBackgroundThread.async {
//            if sourceURL == nil {
//                print("url not found ====== ")
//                completed(UIImage(named: "tom.jpg")!)
//            }else {
//                let asset = AVAsset(url: sourceURL!)
//                let imageGenerator = AVAssetImageGenerator(asset: asset)
//                let time = CMTime(seconds: 1, preferredTimescale: 1)
//
//                do {
//                    let imageRef = try imageGenerator.copyCGImage(at: time, actualTime: nil)
//                    return completed(UIImage(cgImage: imageRef))
//                } catch {
//                    print(error)
//                    completed(UIImage(named: "tom.jpg")!)
//                }
//            }
//        }
//    }
//
//    // To download video and store in document directory.
//    func downloadAudioVideoAndStoreInDocumentDirectory(_ messageData: TblMessages?) {
//
//        // If url not found
//        if (messageData?.message?.isBlank)! || messageData?.message == nil {
//            MIToastAlert.shared.showToastAlert(position: .bottom, message: CMessageMediaNotExist)
//            if self.mqttDelegate != nil {
//                self.mqttDelegate?.didRefreshMessage?()
//            }
//            return
//        }
//
//        messageData?.isMediaDownloading = true
//        CoreData.saveContext()
//
//        //download the file in a seperate thread.
//        GCDBackgroundThread.async {
//
//            let urlToDownload = messageData?.message
//            let url = URL(string: urlToDownload ?? "")
//            var urlData = Data()
//            do {
//                urlData = try Data(contentsOf: url!)
//            }catch {
//                print("Unable to load data: \(error)")
//                messageData?.isMediaDownloading = false
//                CoreData.saveContext()
//
//                if self.mqttDelegate != nil {
//                    self.mqttDelegate?.didRefreshMessage?()
//                }
//            }
//
//            if urlData.count > 0 {
//                let documentsDirectory = CTopMostViewController.applicationDocumentsDirectory()
//
//                var mediaName = ""
//                var mediaPath = ""
//                if messageData?.msg_type == 3 {
//                    // Video
//                    mediaName = "\(CApplicationName ?? "")_\(messageData?.message_id ?? "").mp4"
//                }else {
//                    // Audio
//                    mediaName = "\(CApplicationName ?? "")_\(messageData?.message_id ?? "").caf"
//                }
//                mediaPath = documentsDirectory! + "/" + mediaName
//
//                GCDBackgroundThread.async {
//                    //saving is done on main thread
//                    let videoPathURL = URL(fileURLWithPath: mediaPath)
//                    try! urlData.write(to: videoPathURL, options: .atomicWrite)
//                    messageData?.localMediaUrl = mediaName
//                    messageData?.isMediaDownloading = false
//                    CoreData.saveContext()
//
//                    if self.mqttDelegate != nil {
//                        self.mqttDelegate?.didRefreshMessage?()
//                    }
//                }
//            }
//        }
//
//    }
//}
//
//// MARK:- ------- Friend Status related functions
//// MARK:-
//extension MIMQTT {
//
//    // To update user block/unblock/friend/unfriend status.
//    func updateStatusForBlockUnblockFriendUnfriend(_ messageInfo:[String : Any]) {
//        if self.mqttDelegate != nil {
//            self.mqttDelegate?.blockUnblockFriendUnfriendStatus?(messageInfo)
//        }
//
//        // Delete message from Local when user is resrticted
//        let arrMessage = TblMessages.fetch(predicate: NSPredicate(format: "\(CMessage_id) == %@", messageInfo.valueForString(key: CMessage_id)))
//        if arrMessage?.count ?? 0 > 0 {
//            if let messageInfo = arrMessage?.firstObject as? TblMessages {
//                self.deleteMessageFromLocal(messageInfo)
//            }
//        }
//    }
//
//    // To update user online/offline status in core data
//    func updateUserOnlineOfflineStatus(_ messageInfo:[String : Any]) {
//        if let arrUsers = TblChatUserList.fetch(predicate: NSPredicate(format: "\(CFriendId) == \(messageInfo.valueForInt(key: CUserId) ?? 0)")) as? [TblChatUserList] {
//            if arrUsers.count > 0 {
//                let chatuserInfo = arrUsers.first
//                chatuserInfo?.isOnline = messageInfo.valueForBool(key: CStatus)
//                CoreData.saveContext()
//                if self.mqttDelegate != nil {
//                    self.mqttDelegate?.didChangedOnlineOfflineStatus?(messageInfo)
//                }
//            }
//        }
//    }
//
//    // To update user for deleted group..
//    func updateforDeletedGroup(_ messageInfo:[String : Any]) {
//        if self.mqttDelegate != nil {
//            self.mqttDelegate?.didDeletedGroup?(messageInfo)
//        }
//    }
//
//}
//
//
//// MARK:- ------- Core Data Related fucntions
//// MARK:-
//extension MIMQTT {
//
//    // Update Message Time with local time...
//    func updateMessageTimeAccordingToDevice() {
//
//        if let arrMessages = TblMessages.fetchAllObjects() as? [TblMessages] {
//            for messageInfo in arrMessages {
//                self.resetMessageTime(messageInfo)
//            }
//
//            if self.mqttDelegate != nil {
//                self.mqttDelegate?.didRefreshMessage?()
//            }
//        }
//    }
//
//    // To Update message time if local time is not matching with server time.
//    func resetMessageTime(_ messageInfo: TblMessages) {
//
//        if let timeDifference = CUserDefaults.value(forKey: UserDefaultTimeDifference) as? Double {
//            let newTimeStamp = messageInfo.message_actual_timestamp + timeDifference
//            messageInfo.created_at = newTimeStamp
//            let formate = "dd MMM, yyyy"
//            messageInfo.msg_time = messageInfo.created_at / 1000
//            messageInfo.msgdate = DateFormatter.dateStringFrom(timestamp: messageInfo.msg_time, withFormate: formate)
//            let formatter = DateFormatter()
//            formatter.dateFormat = formate
//            formatter.calendar = Calendar(identifier: .gregorian)
//            formatter.locale = DateFormatter.shared().locale
//            formatter.timeZone = NSTimeZone.local
//            let date = formatter.date(from: messageInfo.msgdate!)
//            let temTimestamp = date?.timeIntervalSince1970
//            messageInfo.msgdate = "\(temTimestamp ?? 0.0)"
//            CoreData.saveContext()
//        }
//    }
//
//    // To update read message status in core data.
//    func updateMessageInLocalForReadACK(_ messageInfo:[String : Any]) {
//
//        let arrMessages = messageInfo.valueForString(key: CMessage_id).components(separatedBy: ",")
//        for messageID in arrMessages {
//
//            let arrMessage = TblMessages.fetch(predicate: NSPredicate(format: "\(CMessage_id) == %@", messageID))
//
//            if (arrMessage?.count)! > 0 {
//                if let objMessageInfo = arrMessage?.firstObject as? TblMessages {
//
//                    var arrReadUsers = [String]()
//
//                    // Get read users
//                    if objMessageInfo.read_users != nil {
//                        arrReadUsers = (objMessageInfo.read_users! as NSString).components(separatedBy: ",")
//                    }
//
//                    let readUser = messageInfo.valueForString(key: CUserId)
//
//                    // Check if user is not exist in current list
//                    if !arrReadUsers.contains(readUser) {
//                        arrReadUsers.append(readUser)
//
//                        let arrUsers = (objMessageInfo.users! as NSString).components(separatedBy: ",")
//                        objMessageInfo.read_users = (arrReadUsers as NSArray).componentsJoined(by: ",")
//
//                        // Check total read user (Not including sender user here..)
//                        if arrUsers.count - 1 == arrReadUsers.count {
//                            objMessageInfo.message_Delivered = 3
//                        }
//                    }
//
//                    CoreData.saveContext()
//
//                    // Pass data to respective viewControllers by using the delegate..
//                    if self.mqttDelegate != nil {
//                        self.mqttDelegate?.didReceiveMessage?(messageInfo)
//                    }
//                }
//            }
//        }
//
//
//    }
//
//    // To Store new message to core data.
//    func saveMessageToLocal(messageInfo:[String : Any], msgDeliveredStatus: Int?, localPayload: Bool) {
//
//        if (messageInfo.valueForInt(key: CChat_type) == 1) // Check block/Unblock/Friend status for user chat only
//            || messageInfo.valueForInt(key: CChat_type) == 2
//        {
//            let objMessageInfo = TblMessages.findOrCreate(dictionary: [CMessage_id:messageInfo.valueForString(key: CMessage_id)]) as! TblMessages
//            objMessageInfo.status_id = 0
//            objMessageInfo.profile_image = messageInfo.valueForString(key: CProfileImage)
//            objMessageInfo.message = messageInfo.valueForString(key: CMessage)
//            objMessageInfo.full_name = messageInfo.valueForString(key: CFullName)
//            objMessageInfo.msg_type = Int16(messageInfo.valueForString(key: CMsg_type))!
//            objMessageInfo.sender_id = Int64(messageInfo.valueForString(key: CSender_Id))!
//            objMessageInfo.recv_id = Int64(messageInfo.valueForString(key: CRecv_id))!
//            objMessageInfo.chat_type = Int16(messageInfo.valueForString(key: CChat_type))!
//            objMessageInfo.users = messageInfo.valueForString(key: CUsers)
//            objMessageInfo.message_Delivered = Int16("\(msgDeliveredStatus ?? 1)")!
//            objMessageInfo.publish_type = Int16(messageInfo.valueForString(key: CPublishType))!
//            objMessageInfo.group_id = messageInfo.valueForString(key: CGroupId)
//
//            objMessageInfo.latitude = Double(messageInfo.valueForDouble(key: CLatitude) ?? 0.0)
//            objMessageInfo.longitude = Double(messageInfo.valueForDouble(key: CLongitude) ?? 0.0)
//            objMessageInfo.address = messageInfo.valueForString(key: CAddress)
//            objMessageInfo.forwarded_msg_id = messageInfo.valueForString(key: "forwarded_msg_id")
//            objMessageInfo.localMediaUrl = messageInfo.valueForString(key: "localMediaUrl")
//
//            objMessageInfo.media_name = messageInfo.valueForString(key: "media_name")
//            if !messageInfo.valueForString(key: "thumb_url").isEmpty {
//                objMessageInfo.thumb_url = messageInfo.valueForString(key: "thumb_url")
//                objMessageInfo.thumb_name = messageInfo.valueForString(key: "thumb_name")
//            }
//
//            if !objMessageInfo.media_name.isEmptyOrNil() && msgDeliveredStatus == 2 {
//                objMessageInfo.localMediaUrl = objMessageInfo.media_name
//            }
//
//            if objMessageInfo.localMediaUrl == "" {
//                objMessageInfo.localMediaUrl = nil
//            }
//            //...Media Related Properties
//            if objMessageInfo.msg_type != 1 {
//
//                // If sending media from current device then media url will be local url...
//                if !objMessageInfo.forwarded_msg_id.isEmptyOrNil() && msgDeliveredStatus == 1 {
//                    objMessageInfo.isMediaUploadedOnServer = true
//                    CoreData.saveContext()
//                    self.publishUnsentMessages(objMessageInfo)
//
//                } else if objMessageInfo.localMediaUrl == nil && localPayload {
//                    objMessageInfo.localMediaUrl = messageInfo.valueForString(key: CMessage)
//                }
//
//                // Video Thumb URL
//                if !messageInfo.valueForString(key: CThumb_Url).isBlank {
//                    objMessageInfo.thumb_url = messageInfo.valueForString(key: CThumb_Url)
//                    objMessageInfo.thumb_name = messageInfo.valueForString(key: CThumb_Name)
//                }
//
//            }
//
//            // Create channel id for OTO chat..
//            if objMessageInfo.chat_type == 1 {
//                objMessageInfo.channel_id = objMessageInfo.sender_id == appDelegate.loginUser?.user_id ? CMQTTUSERTOPIC + "\(appDelegate.loginUser?.user_id ?? 0)/\(objMessageInfo.recv_id)" : CMQTTUSERTOPIC + "\(appDelegate.loginUser?.user_id ?? 0)/\(objMessageInfo.sender_id)"
//
//            }else {
//                // channel id for Group chat..
//                objMessageInfo.channel_id = messageInfo.valueForString(key: CChannel_id)
//            }
//
//            print("channel ========= ",objMessageInfo.channel_id ?? "")
//
//            //...Convert Timestamp in Local
//            objMessageInfo.message_actual_timestamp = DateFormatter.shared().ConvertGMTMillisecondsTimestampToLocalTimestamp(timestamp: messageInfo.valueForDouble(key: CCreated_at) ?? 0.0) ?? 0.0
//            objMessageInfo.created_at = objMessageInfo.message_actual_timestamp
//            objMessageInfo.msg_time = objMessageInfo.created_at / 1000
//            let formate = "dd MMM, yyyy"
//            objMessageInfo.msgdate = DateFormatter.dateStringFrom(timestamp: objMessageInfo.msg_time, withFormate: formate)
//            let formatter = DateFormatter()
//            formatter.dateFormat = formate
//            formatter.calendar = Calendar(identifier: .gregorian)
//            formatter.locale = DateFormatter.shared().locale
//            formatter.timeZone = NSTimeZone.local
//            let date = formatter.date(from: objMessageInfo.msgdate!)
//            let temTimestamp = date?.timeIntervalSince1970
//
//            objMessageInfo.msgdate = "\(temTimestamp ?? 0.0)"
//
//            CoreData.saveContext()
//
//            // To Update message time if local time is not matching with server time.
//            self.resetMessageTime(objMessageInfo)
//        }
//
//        // Pass data to respective viewControllers by using the delegate..
//        if self.mqttDelegate != nil {
//            self.mqttDelegate?.didReceiveMessage?(messageInfo)
//        }
//
//    }
//}
//
//
//
//


/*************************NEW CODE **************************/

//
//  MIMQTT.swift
//  Sevenchats
//
//  Created by mac-0005 on 18/01/19.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit
import CocoaMQTT
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

// LIVE
//let CMQTTHOST = "mqtt.sevenchats.com"
//let cMQTTPort = UInt16(80)

// LOCAL
//let CMQTTHOST =  "tcp://0.tcp.ngrok.io"
//let cMQTTPort = UInt16(13105)


//let CMQTTHOST = "122.166.120.59"
//let cMQTTPort = UInt16(1882)

//let CMQTTHOST = "122.166.172.74"
//let cMQTTPort = UInt16(1882)

//Live
//let CMQTTHOST = "192.168.1.19"

let CMQTTHOST = "test.sevenchats.com"
let cMQTTPort = UInt16(1882)


//let CMQTTHOST = "192.168.1.18"
//let cMQTTPort = UInt16(1882)

//let CMQTTHOST =  "192.168.1.59"
//let cMQTTPort = UInt16(1882)

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

// MQTTDelegate Methods
@objc protocol MQTTDelegate: class {
    @objc optional func didReceiveMessage(_ message: [String : Any]?)
    @objc optional func didRefreshMessage()
    @objc optional func didChangedOnlineOfflineStatus(_ message: [String : Any]?)
    @objc optional func blockUnblockFriendUnfriendStatus(_ message: [String : Any]?)
    @objc optional func didDeletedGroup(_ message: [String : Any]?)
}

class MIMQTT: NSObject {
    weak var mqttDelegate: MQTTDelegate?
    
    var objMQTTClient : CocoaMQTT?
    var timeClient: TrueTimeClient?
    
    private override init() {
        super.init()
    }
    
    private static var mqtt: MIMQTT = {
        let mqtt = MIMQTT()
        return mqtt
    }()
    
    static func shared() ->MIMQTT {
        return mqtt
    }
    
    func updateClientId (){
        let random = Date().millisecondsSince1970.description + ProcessInfo().processIdentifier.description
        ClientID  = "ios-" + random + "-\(appDelegate.loginUser?.user_id ?? Int64(0.0))"  //ios-RANDOMNUMBER-USERID
        objMQTTClient?.clientID = ClientID
    }
}

// MARK:- ------- MQTT Configuration
// MARK:-

extension MIMQTT {
    
    // MQTT initialization..
    func MQTTInitialSetup() {
        if appDelegate.loginUser == nil {
            return
        }
        if objMQTTClient == nil {
            print(ClientID)
            objMQTTClient = CocoaMQTT(clientID: ClientID, host:CMQTTHOST, port:cMQTTPort)
        }
        
        objMQTTClient?.username = CMQTTUSERNAME
        objMQTTClient?.password = CMQTTPASSWORD
        objMQTTClient?.willMessage = CocoaMQTTWill(topic: "/will", message: "dieout")
        objMQTTClient?.keepAlive = 60
        objMQTTClient?.delegate = self
        objMQTTClient?.enableSSL = false
        objMQTTClient?.allowUntrustCACertificate = false


        
        _ = objMQTTClient?.connect()
        
        // Update uploading status for retry button for media messages..
        self.updateMediaUploadingStatusForRetry()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.timeChangedNotification), name: NSNotification.Name.NSSystemClockDidChange, object: nil)
    }
    
    @objc func timeChangedNotification(notification:NSNotification) {
        print("Device time has been changed...")
        self.deviceActualTime()
    }
    
    // Publish message here...
    func MQTTPublishWithTopic(_ payload:[String : Any], _ topic : String?) {
        
        // mchat/userId
        let jsonData = try? JSONSerialization.data(withJSONObject: payload, options: [])
        let jsonString = String(data: jsonData!, encoding: .utf8)
        objMQTTClient?.publish(topic!, withString: jsonString!)
    }
    
    // Subscribe topic here..
    func MQTTSubscribeWithTopic(_ id:Any?, topicPrefix : String?) {
        print("\(topicPrefix ?? "")\(id ?? "")")
        
        objMQTTClient?.subscribe("\(topicPrefix ?? "")\(id ?? "")")
    }
    
    // Unsubscribe topic here..
    func MQTTUnsubscribeWithTopic(_ id:Any?, topicPrefix : String?) {
        objMQTTClient?.unsubscribe("\(topicPrefix ?? "")\(id ?? "")")
    }
}

// MARK:- ------- CocoaMQTTDelegate
// MARK:-

extension MIMQTT: CocoaMQTTDelegate {
    
    // DID CONNECT HERE.....
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        print("DId CONNECTED ====== ")
        self.MQTTSubscribeWithTopic(appDelegate.loginUser?.user_id, topicPrefix: CMQTTUSERTOPIC)
        self.MQTTSubscribeWithTopic(nil, topicPrefix: CMQTTUSERONLINEOFFLINETOPIC)
        self.syncUnsentTextMessageToServer()
    }
    
    func mqttDidPing(_ mqtt: CocoaMQTT) {
        print("mqttDidPing ======= ")
    }
    
    func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
        print("mqttDidReceivePong ======== ")
    }
    
    // DID DISCONECT HERE.....
    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
        //print("mqttDidDisconnect ======== ")
        
        GCDMainThread.asyncAfter(deadline: .now() + 1) {
            // Reconnect if user loged in...
            if appDelegate.loginUser?.user_id != nil && UIApplication.shared.applicationState == .active {
                if MIMQTT.shared().objMQTTClient != nil {
                    if !(MIMQTT.shared().objMQTTClient?.connect())! {
                        _ = MIMQTT.shared().objMQTTClient?.connect()
                    }
                }
            }
        }
    }
    
    // DID PUBLISH MESSAGE HERE.....
    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
        print("DID PUBLISH MESSAGE ==== ")
        print("message",CocoaMQTTMessage.self)
    }
    
    // DID PUBLISH ACK HERE...
    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
        //print("DID PUBLISH ACK ==== ")
    }
    
    // DID RECEIVED MESSGE HERE.....
    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16) {
        print("Message received in topic \(message.topic) with payload \(message.string!)")
        
        // Convert Json into dictionay here.....
        let messageInfo = self.convertToDictionary(text: message.string!)
        
        if messageInfo?.valueForInt(key: CPublishType) == CPUBLISHREADTYPE {
            // READ MESSAGE
            self.updateMessageInLocalForReadACK(messageInfo!)
        }else if messageInfo?.valueForInt(key: CPublishType) == CPUBLISHBLOCKUSER {
            // BLOCK USER
            self.updateStatusForBlockUnblockFriendUnfriend(messageInfo!)
        }else if messageInfo?.valueForInt(key: CPublishType) == CPUBLISHFRIENDUNFRIENDUSER {
            // Friend/Unfriend user...
            self.updateStatusForBlockUnblockFriendUnfriend(messageInfo!)
        }else if messageInfo?.valueForInt(key: CPublishType) == CPUBLISHONLINEOFFLIEN {
            // Online/Offline user...
            self.updateUserOnlineOfflineStatus(messageInfo!)
        }else if messageInfo?.valueForInt(key: CPublishType) == CPUBLISHDELETECREATEGROUP {
            // DELETE/CREATE GROUP
            self.updateforDeletedGroup(messageInfo!)
        }else if messageInfo?.valueForInt(key: CPublishType) == CPUBLISHDELETEMESSAGE {
            // DELETE MESSAGE FROM ADMIN SIDE
            self.updateMessageDeleteStatus(messageInfo!)
        }else {
            // Store message in local...
//            self.saveMessageToLocal(messageInfo: messageInfo!, msgDeliveredStatus: 2, localPayload: false)
        }
        
        
    }
    
    // DID SUBSCRIBE TOPIC HERE...
    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopic topics: [String]) {
         print("DID SUBSCRIBE TOPIC  ==== ")
    }

    // DID UNSUBSCRIBE TOPIC HERE...
    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) {
        print("DID UNSUBSCRIBE TOPIC ==== ")
    }
}

// MARK:- ------- Helper Functions
// MARK:-
extension MIMQTT {
    func deviceActualTime() {
        // At an opportune time (e.g. app start):
        
        if timeClient == nil {
            timeClient = TrueTimeClient.sharedInstance
            timeClient?.start()
        }
        
        // To block waiting for fetch, use the following:
        timeClient?.fetchIfNeeded { result in
            switch result {
            case let .success(referenceTime):
                let now = referenceTime.now()
                let timeDifference = (Date().timeIntervalSince1970 * 1000) - (now.timeIntervalSince1970 * 1000)
                CUserDefaults.setValue(timeDifference, forKey: UserDefaultTimeDifference)
                self.updateMessageTimeAccordingToDevice()
            case let .failure(error):
                print("Error! \(error)")
            }
        }
    }
    
        func convertToDictionary(text: String) -> [String: Any]? {
            if let data = text.data(using: .utf8) {
                do {
                    return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                } catch {
                    print(error.localizedDescription)
                }
            }
            return nil
        }
}

// MARK:- ------- Message Publish functions
// MARK:-
extension MIMQTT {
    
//    func messagePaylaod(arrUser: [String?], channelId: String?, message: String?, messageType: MessageType?, chatType: ChatType?,  groupID: String?, latitude:Double = 0.0, longitude:Double = 0.0, address: String = "", forwardedMsgId: String = "", cloleFile:MDLCloneMedia? = nil) {
    func messagePaylaod(arrUser: [String?], channelId: String?, message: String?, messageType: MessageType?, chatType: ChatType?,  groupID: String?, latitude:Double = 0.0, longitude:Double = 0.0, address: String = "", forwardedMsgId: String = "", cloleFile:MDLCloneMedia? = nil,is_auto_delete:Int?){
        
        var dicPayload = [String : Any]()
        dicPayload[CSender_Id] = appDelegate.loginUser?.user_id
        dicPayload[CMessage] = message
        dicPayload[CMsg_type] = messageType?.rawValue
        dicPayload[CChat_type] = chatType?.rawValue
        dicPayload[CMessage_id] = (UIDevice.current.identifierForVendor?.uuidString)!.replacingOccurrences(of: "-", with: "") + "\(Int(Date().timeIntervalSince1970 * 1000))"
        dicPayload[CChannel_id] = channelId
        dicPayload[CFullName] = (appDelegate.loginUser?.first_name)! + " " + (appDelegate.loginUser?.last_name)!
        dicPayload[CProfileImage] = appDelegate.loginUser?.profile_img
        dicPayload[CUsers] = arrUser.compactMap({$0}).joined(separator: ",")
        dicPayload[CPublishType] = CPUBLISHMESSAGETYPE
        
        dicPayload[CLatitude] = latitude
        dicPayload[CLongitude] = longitude
        dicPayload[CAddress] = address
        dicPayload["forwarded_msg_id"] = forwardedMsgId
        let conertIsautoDele = String(is_auto_delete ?? 0)
        dicPayload[CisAutoDelete] = conertIsautoDele
      
        if let time = timeClient, time.referenceTime?.now() != nil {
            dicPayload[CCreated_at] = ((time.referenceTime?.now().timeIntervalSince1970 ?? 0) * 1000).toInt
        }else {
            dicPayload[CCreated_at] = DateFormatter.shared().currentGMTTimestampInMilliseconds()?.toInt
        }
        
        dicPayload[CGroupId] = groupID != nil ? groupID?.toInt : 0
        dicPayload[CThumb_Url] = ""
        dicPayload[CThumb_Name] = ""
        dicPayload[CMedia_Name] = ""
        
        if let _cloleFile = cloleFile {
            dicPayload["localMediaUrl"] = _cloleFile.localMediaUrl
            dicPayload["media_name"] = _cloleFile.image
            
            if !_cloleFile.thumbUrl.isEmpty {
                dicPayload["thumb_url"] = _cloleFile.thumbUrl
                dicPayload["thumb_name"] = _cloleFile.thumbName
            }
        }
        
//        print(dicPayload)
        if chatType == .user {
            // FOR OTO CHAT Reciver id is always front user...
            if let index = arrUser.firstIndex(where: { $0 != "\(appDelegate.loginUser?.user_id ?? 0)"}) {
                dicPayload[CRecv_id] = arrUser[index]?.toInt ?? 0
            }
            
            // Publish Text message directly
            if messageType == .text {
                for userId in arrUser {
                    MIMQTT.shared().MQTTPublishWithTopic(dicPayload, CMQTTUSERTOPIC + "\(userId ?? "0")")
                }
            }
        } else {
            // FOR Group CHAT
            for userId in arrUser {
                dicPayload[CRecv_id] = userId?.toInt
                
                // Publish Text message directly
                if messageType == .text {
                    
                    MIMQTT.shared().MQTTPublishWithTopic(dicPayload, CMQTTUSERTOPIC + "\(userId ?? "0")")
                }
            }
        }
        
//        self.saveMessageToLocal(messageInfo: dicPayload, msgDeliveredStatus: 1, localPayload: true)
    }
    
    // Publish for Group Delete/Create status
    func messagePayloadForGroupCreateAndDelete(arrUser: [String?], status: Int, groupId: String?, isSend: Int?) {
        var dicPayload = [String : Any]()
        dicPayload[CGroupId] = groupId != nil ? groupId?.toInt : 0
        dicPayload[CJsonStatus] = status
        dicPayload[CIs_send] = isSend
        dicPayload[CPublishType] = CPUBLISHDELETECREATEGROUP
        
        // Publish to all user..
        for userId in arrUser {
            dicPayload[CUserId] = userId
            dicPayload[CChannel_id] = CMQTTUSERTOPIC + "\(userId ?? "0")"
            MIMQTT.shared().MQTTPublishWithTopic(dicPayload, CMQTTUSERTOPIC + "\(userId ?? "0")")
        }
    }
    
    // Publish for message read Acknowledgement
    func sendMessageReadAcknowledgement(messageInfo: [String : Any], groupID: Int?) {
        
        if Int64(messageInfo.valueForString(key: CSender_Id)) != appDelegate.loginUser?.user_id {
            var dicPayload = [String : Any]()
            dicPayload[CMessage_id] = messageInfo.valueForString(key: CMessage_id)
            dicPayload[CUserId] = appDelegate.loginUser?.user_id
            dicPayload[CPublishType] = CPUBLISHREADTYPE
            dicPayload[CGroupId] = groupID != nil ? groupID : 0
            
            if let time = timeClient, time.referenceTime?.now() != nil {
                dicPayload[CCreated_at] = ((time.referenceTime?.now().timeIntervalSince1970 ?? 0) * 1000).toInt
            }else {
                dicPayload[CCreated_at] = DateFormatter.shared().currentGMTTimestampInMilliseconds()?.toInt
            }
            dicPayload[CChannel_id] = CMQTTUSERTOPIC + messageInfo.valueForString(key: CSender_Id)
            MIMQTT.shared().MQTTPublishWithTopic(dicPayload, CMQTTUSERTOPIC + messageInfo.valueForString(key: CSender_Id))
        }
        
    }
    
    // Publish for Unsent message///
    fileprivate func publishUnsentMessages(_ message: TblMessages?) {
        
        if let messageInfo = message {
            var payload = messageInfo.dictionaryWithValues(forKeys: Array((messageInfo.entity.attributesByName.keys)))
            let arrUsers = (messageInfo.users! as NSString).components(separatedBy: ",")
            
            // Remove unwated keys from MQTT payload..
            payload.removeValue(forKey: "isMediaUploadedOnServer")
            payload.removeValue(forKey: "isMediaDownloading")
            payload.removeValue(forKey: "localMediaUrl")
            payload.removeValue(forKey: "message_Delivered")
            payload.removeValue(forKey: "isMediaUploadingRunning")
            payload.removeValue(forKey: "read_users")
            payload.removeValue(forKey: "msgdate")
            payload.removeValue(forKey: "msg_time")
            
            /*if messageInfo.msg_type != 6 {
                payload.removeValue(forKey: "latitude")
                payload.removeValue(forKey: "longitude")
                payload.removeValue(forKey: "address")
            }*/
            
            let groupId = payload[CGroup_Id] as? String ?? "0"
            let latitude = payload[CLatitude] as? Double ?? 0.0
            let longitude = payload[CLongitude] as? Double ?? 0.0
            let address = payload[CAddress] as? String ?? ""
            let thumeURL = payload[CThumb_Url] as? String ?? ""
            let thumeName = payload[CThumb_Name] as? String ?? ""
            
            payload[CLatitude] = latitude
            payload[CLongitude] = longitude
            payload[CAddress] = address
            payload[CThumb_Url] = thumeURL
            payload[CThumb_Name] = thumeName
            payload[CGroup_Id] = groupId.toInt ?? 0
            
            
            let createdAt = payload[CCreated_at] as? Double
            payload[CCreated_at] = Int(createdAt ?? 0)
            if messageInfo.chat_type == 1 {
                
                // FOR OTO CHAT
                if let index = arrUsers.firstIndex(where: { $0 != "\(appDelegate.loginUser?.user_id ?? 0)"}) {
                    payload[CRecv_id] = arrUsers[index].toInt
                }
                for userId in arrUsers {
                    // publish message here...
                    payload[CChannel_id] = CMQTTUSERTOPIC + "\(userId)"
                    //print(payload)
                    MIMQTT.shared().MQTTPublishWithTopic(payload, CMQTTUSERTOPIC + "\(userId)")
                }
            }else {
                // FOR Group CHAT
                for userId in arrUsers {
                    // publish message here...
                    payload[CRecv_id] = userId.toInt
                    MIMQTT.shared().MQTTPublishWithTopic(payload, CMQTTUSERTOPIC + "\(userId)")
                }
            }
        }
    }
    
    // To sync unsent Text message from local...
    func syncUnsentTextMessageToServer() {
        // Get Text Messages which is not uploaded yet...
        if let arrMSG = TblMessages.fetch(predicate: NSPredicate(format: "\(CMessage_Delivered) == 1 && \(CMsg_type) == 1")) as? [TblMessages] {
            for messageInfo in arrMSG {
                self.publishUnsentMessages(messageInfo)
            }
        }
        
        
        // Get media which is sent but not publish yet...
        if let arrMSG = TblMessages.fetch(predicate: NSPredicate(format: "isMediaUploadedOnServer == true && \(CMessage_Delivered) == 1 && \(CMsg_type) != 1")) as? [TblMessages] {
            for messageInfo in arrMSG {
                self.publishUnsentMessages(messageInfo)
            }
        }
        
    }
    
    // To sync unsent Media message from local...
    func syncUnsentMediaToServer(_ channelID: String?) {
        
        // Get media which is not uploaded yet...
        if let arrMSG = TblMessages.fetch(predicate: NSPredicate(format: "isMediaUploadingRunning == null && \(CMessage_Delivered) == 1 && \(CMsg_type) != 1 && \(CChannel_id) == %@", channelID!)) as? [TblMessages] {
            for messageInfo in arrMSG {
                messageInfo.isMediaUploadingRunning = 1
                CoreData.saveContext()
                self.uploadMediaOnServer(messageInfo)
            }
        }
    }
    
    // To update isMediaUploadingRunning status for retry Button..
    fileprivate func updateMediaUploadingStatusForRetry() {
        if let arrMSG = TblMessages.fetch(predicate: NSPredicate(format: "isMediaUploadingRunning == 2 && (isMediaUploadedOnServer == null || isMediaUploadedOnServer == false) && \(CMessage_Delivered) == 1 && \(CMsg_type) != 1")) as? [TblMessages] {
            for messageInfo in arrMSG {
                messageInfo.isMediaUploadingRunning = 1
                CoreData.saveContext()
            }
        }
        
        // Update Downloading status
        if let arrMSG = TblMessages.fetch(predicate: NSPredicate(format: "isMediaDownloading == true && \(CMsg_type) != 1")) as? [TblMessages] {
            for messageInfo in arrMSG {
                messageInfo.isMediaDownloading = false
                CoreData.saveContext()
            }
        }
        
    }
    
    
    //Delete the all the Messages
    func deleteAllMessageFromLocal(_ messageInfo: TblMessages, isSender: Bool) {
     
        var payload = [String:Any]()
        payload[CPublishType] = CPUBLISHDELETEMESSAGE
        payload[CMessage_id] = messageInfo.message_id
        payload[CUserId] = appDelegate.loginUser?.user_id
        payload[CGroupId] = messageInfo.chat_type == 2 ? messageInfo.group_id : 0
        
        let arrUsers = (messageInfo.users! as NSString).components(separatedBy: ",")
        
        payload[CJsonStatus] = 1
        payload[CIs_sender] = 1
        payload[CChannel_id] = CMQTTUSERTOPIC + "\(appDelegate.loginUser?.user_id ?? 0)"
        MIMQTT.shared().MQTTPublishWithTopic(payload, CMQTTUSERTOPIC + "\(appDelegate.loginUser?.user_id ?? 0)")
    }
    
    
    // Delete Messages from local (Only those messages will not uploaed on server...)
    func deleteMessageFromLocal(_ message: TblMessages?) {
        TblMessages.deleteObjects(predicate: NSPredicate(format: "self == %@", message!))
        CoreData.saveContext()
        if self.mqttDelegate != nil {
            self.mqttDelegate?.didRefreshMessage?()
        }
    }
    //Delete Message from local(Delete particular Data from server)
    // To Delete Delivered messages.
    func autoDeleteDeliveredMessage(_ messageInfo: TblMessages, isSender: Bool,autodeleteTime:String) {
       
        var autodeletseconds:Double = 0.0
        if let autodeleteTimeConvert = Int(autodeleteTime){
            autodeletseconds = Double(autodeleteTimeConvert * 60)
            print("autodelteseconds",autodeletseconds)
        }
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + autodeletseconds) {
            var payload = [String:Any]()
            payload[CPublishType] = CPUBLISHDELETEMESSAGE
            payload[CMessage_id] = messageInfo.message_id
            payload[CUserId] = appDelegate.loginUser?.user_id
            payload[CGroupId] = messageInfo.chat_type == 2 ? messageInfo.group_id : 0
            let arrUsers = (messageInfo.users! as NSString).components(separatedBy: ",")
            if isSender {
                payload[CJsonStatus] = 2
                
                for userId in arrUsers {
                    payload[CIs_sender] = userId == "\(appDelegate.loginUser?.user_id ?? 0)" ? 1 : 0
                    // publish message here...
                    payload[CChannel_id] = CMQTTUSERTOPIC + "\(userId)"
                    MIMQTT.shared().MQTTPublishWithTopic(payload, CMQTTUSERTOPIC + "\(userId)")
                }
            }
        }
    }
    
    //To Delet message from local
    func deletedMessageFromLocal(_ message: TblMessages?) {
        let messageinfo = message?.message
        TblMessages.deleteObjects(predicate: NSPredicate(format: "self == %@", message!))
        CoreData.saveContext()
        if self.mqttDelegate != nil {
            self.mqttDelegate?.didRefreshMessage?()
        }
    }
    
    // To update message delete status..
    fileprivate func updateMessageDeleteStatus(_ messageInfo:[String : Any]) {

        if let arrMessage = TblMessages.fetch(predicate: NSPredicate(format: "\(CMessage_id) == %@",messageInfo.valueForString(key: CMessage_id))) as? [TblMessages] {
            
            let deleteStatus = messageInfo.valueForInt(key: CJsonStatus)
            for msgInfo in arrMessage {

                // Remove Media from document directory if deleted message type is Audio/Video
                if msgInfo.msg_type == 3 || msgInfo.msg_type == 4 {

                    if let localMediaURL = msgInfo.localMediaUrl {
                        let mediaPath = CTopMostViewController.applicationDocumentsDirectory()! + "/" + localMediaURL
                        if FileManager.default.fileExists(atPath: mediaPath) {
                            try! FileManager.default.removeItem(atPath: mediaPath)
                        }
                    }
                }
                if deleteStatus == 1 {
                    // This message is Deleted For sender only
                    self.deleteMessageFromLocal(msgInfo)
                }else {
                    // This message is Deleted For all user
                    msgInfo.status_id = Int16(deleteStatus ?? 0)
                    msgInfo.msg_type = 1
                    CoreData.saveContext()
                    if self.mqttDelegate != nil {
                        self.mqttDelegate?.didRefreshMessage?()
                    }
                }
            }
        }
    }
    
    func deleteSelectMessage(_ messageInfo: TblMessages, isSender: Bool) {
        var payload = [String:Any]()
        payload[CPublishType] = CPUBLISHDELETEMESSAGE
        payload[CMessage_id] = messageInfo.message_id
        payload[CUserId] = appDelegate.loginUser?.user_id
        payload[CGroupId] = messageInfo.chat_type == 2 ? messageInfo.group_id : 0
        
        payload[CJsonStatus] = 1
        payload[CIs_sender] = 1
        payload[CChannel_id] = CMQTTUSERTOPIC + "\(appDelegate.loginUser?.user_id ?? 0)"
        MIMQTT.shared().MQTTPublishWithTopic(payload, CMQTTUSERTOPIC + "\(appDelegate.loginUser?.user_id ?? 0)")
        
    }
    
    // To Delete Delivered messages.
    func deleteDeliveredMessage(_ messageInfo: TblMessages, isSender: Bool) {
        
        var payload = [String:Any]()
        payload[CPublishType] = CPUBLISHDELETEMESSAGE
        payload[CMessage_id] = messageInfo.message_id
        payload[CUserId] = appDelegate.loginUser?.user_id
        payload[CGroupId] = messageInfo.chat_type == 2 ? messageInfo.group_id : 0
        
        let arrUsers = (messageInfo.users! as NSString).components(separatedBy: ",")
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: CBtnDeleteForMe, style: .destructive, handler: { (alert) in
            payload[CJsonStatus] = 1
            payload[CIs_sender] = 1
            payload[CChannel_id] = CMQTTUSERTOPIC + "\(appDelegate.loginUser?.user_id ?? 0)"
            MIMQTT.shared().MQTTPublishWithTopic(payload, CMQTTUSERTOPIC + "\(appDelegate.loginUser?.user_id ?? 0)")
        }))
        
        if isSender {
            alertController.addAction(UIAlertAction(title: CBtnDeleteForEveryone, style: .destructive, handler: { (alert) in
                payload[CJsonStatus] = 2
                
                for userId in arrUsers {
                    payload[CIs_sender] = userId == "\(appDelegate.loginUser?.user_id ?? 0)" ? 1 : 0
                    // publish message here...
                    payload[CChannel_id] = CMQTTUSERTOPIC + "\(userId)"
                    MIMQTT.shared().MQTTPublishWithTopic(payload, CMQTTUSERTOPIC + "\(userId)")
                }
            }))
        }
        
        alertController.addAction(UIAlertAction(title: CBtnCancel, style: .cancel, handler: nil))
        CTopMostViewController.present(alertController, animated: true, completion: nil)
    }
}

// MARK:- ------- Api Functions
// MARK:-
extension MIMQTT {
    
    func uploadMediaApi(_ messageInfo: TblMessages, mediaData: Data, videoThumb: UIImage?) {
        let msgType = messageInfo.msg_type
        let chatType = messageInfo.chat_type
        
        var thumbData = Data()
        if videoThumb != nil {
            thumbData = (videoThumb?.jpegData(compressionQuality: 0.9))!
        }
        
        if mediaData.count != 0 {
            
//            APIRequest.shared().chatMediaUpload(msgType: Int(msgType), chatType: Int(chatType), mediaData: mediaData, videoThumbData: thumbData) { (response, error) in
//                
//                if response != nil && error == nil {
//                    if let mediaData = response![CJsonData] as? [String : Any] {
//                        messageInfo.media_name = mediaData.valueForString(key: "image")
//                        messageInfo.message = mediaData.valueForString(key: "url")
//                        messageInfo.isMediaUploadedOnServer = true
//                        
//                        // Video Thumb..
//                        if !mediaData.valueForString(key: CThumb_Url).isBlank {
//                            messageInfo.thumb_url = mediaData.valueForString(key: CThumb_Url)
//                            messageInfo.thumb_name = mediaData.valueForString(key: CThumb_Name)
//                        }
//                        
//                        CoreData.saveContext()
//                        self.publishUnsentMessages(messageInfo)
//                    }else {
//                        // Media uploading failed.
//                        messageInfo.isMediaUploadingRunning = 1
//                        CoreData.saveContext()
//                    }
//                }else {
//                    // Media uploading failed.
//                    messageInfo.isMediaUploadingRunning = 1
//                    CoreData.saveContext()
//                }
//                
//                // Refresh Respective Viewcontroller for uploading status..
//                if self.mqttDelegate != nil {
//                    self.mqttDelegate?.didRefreshMessage?()
//                }
//                
//            }
        }
    }
    
    func uploadMediaOnServer(_ mediaInfo: TblMessages?) {
        if let messageInfo = mediaInfo {
            
            // For uploading notifications...
            messageInfo.isMediaUploadingRunning = 2
            CoreData.saveContext()
            self.mqttDelegate?.didRefreshMessage?()
            
            var mediaData = Data()
            
            switch messageInfo.msg_type {
            case 2:
                // IMAGE
                print("UPLOAD IMAGE HERE========")
                if messageInfo.localMediaUrl != nil {
                    let imgPath = CTopMostViewController.applicationDocumentsDirectory()! + messageInfo.localMediaUrl!
                    if FileManager.default.fileExists(atPath: imgPath) {
                        let image = UIImage(contentsOfFile: imgPath)
                        mediaData = (image?.jpegData(compressionQuality: 0.9))!
                        self.uploadMediaApi(messageInfo, mediaData: mediaData, videoThumb: nil)
                    }else {
                        self.showAlertWhenMediaDoesNotExistWhileUploading(messageInfo)
                    }
                }
                
                break
            case 3:
                // VIDEO
                print("UPLOAD VIDEO HERE========")
                if messageInfo.localMediaUrl != nil {
                    let videoPath = CTopMostViewController.applicationDocumentsDirectory()! + "/" + (messageInfo.localMediaUrl)!
                    if FileManager.default.fileExists(atPath: videoPath) {
                        do {
                            mediaData = try Data(contentsOf: URL(fileURLWithPath: videoPath))
                            
                            self.getVideoThumbNail(URL(fileURLWithPath: videoPath)) { (image) in
                                self.uploadMediaApi(messageInfo, mediaData: mediaData, videoThumb: image)
                            }
                            
                        }catch {
                            print("Unable to load data: \(error)")
                        }
                    }else {
                        self.showAlertWhenMediaDoesNotExistWhileUploading(messageInfo)
                    }
                }
                break
            case 4:
                // AUDIO
                print("UPLOAD AUDIO HERE========")
                if messageInfo.localMediaUrl != nil {
                    let audioPath = CTopMostViewController.applicationDocumentsDirectory()! + "/" + (messageInfo.localMediaUrl)!
                    if FileManager.default.fileExists(atPath: audioPath) {
                        do {
                            mediaData = try Data(contentsOf: URL(fileURLWithPath: audioPath))
                            self.uploadMediaApi(messageInfo, mediaData: mediaData, videoThumb: nil)
                        }catch {
                            print("Unable to load data: \(error)")
                        }
                    }else {
                        self.showAlertWhenMediaDoesNotExistWhileUploading(messageInfo)
                        
                    }
                }
                break
            case 6:
                // Share Location
                print("UPLOAD SHARE LOCATION IMAGE HERE========")
                if messageInfo.localMediaUrl != nil {
                    let audioPath = CTopMostViewController.applicationDocumentsDirectory()! + "/" + (messageInfo.localMediaUrl)!
                    if FileManager.default.fileExists(atPath: audioPath) {
                        do {
                            mediaData = try Data(contentsOf: URL(fileURLWithPath: audioPath))
                            self.uploadMediaApi(messageInfo, mediaData: mediaData, videoThumb: nil)
                        }catch {
                            print("Unable to load data: \(error)")
                        }
                    }else {
                        self.showAlertWhenMediaDoesNotExistWhileUploading(messageInfo)
                        
                    }
                }
                break
                
            default:
                break
            }
        }
    }
    
    // While uploading if media not found in document directory then show alert to user..
    func showAlertWhenMediaDoesNotExistWhileUploading(_ messageInfo: TblMessages?) {
        MIToastAlert.shared.showToastAlert(position: .bottom, message: CMessageMediaNotExist)
        // Media uploading failed.
        messageInfo?.isMediaUploadingRunning = 1
        CoreData.saveContext()
        // Refresh Respective Viewcontroller for uploading status..
        if self.mqttDelegate != nil {
            self.mqttDelegate?.didRefreshMessage?()
        }
    }
}

// MARK:- ------- Media Related fucntions
// MARK:-
extension MIMQTT {
    
    // To Create Video Thumnail image.
    func getVideoThumbNail(_ sourceURL:URL?, completed: @escaping (_ thumImage:UIImage) -> Void) {
        
        GCDBackgroundThread.async {
            if sourceURL == nil {
                print("url not found ====== ")
                completed(UIImage(named: "tom.jpg")!)
            }else {
                let asset = AVAsset(url: sourceURL!)
                let imageGenerator = AVAssetImageGenerator(asset: asset)
                let time = CMTime(seconds: 1, preferredTimescale: 1)
                
                do {
                    let imageRef = try imageGenerator.copyCGImage(at: time, actualTime: nil)
                    return completed(UIImage(cgImage: imageRef))
                } catch {
                    print(error)
                    completed(UIImage(named: "tom.jpg")!)
                }
            }
        }
    }
    
    // To download video and store in document directory.
    func downloadAudioVideoAndStoreInDocumentDirectory(_ messageData: TblMessages?) {
        
        // If url not found
        if (messageData?.message?.isBlank)! || messageData?.message == nil {
            MIToastAlert.shared.showToastAlert(position: .bottom, message: CMessageMediaNotExist)
            if self.mqttDelegate != nil {
                self.mqttDelegate?.didRefreshMessage?()
            }
            return
        }
        
        messageData?.isMediaDownloading = true
        CoreData.saveContext()
        
        //download the file in a seperate thread.
        GCDBackgroundThread.sync {
            
            let urlToDownload = messageData?.message
            let url = URL(string: urlToDownload ?? "")
            var urlData = Data()
            do {
                urlData = try Data(contentsOf: url!)
            }catch {
                print("Unable to load data: \(error)")
                messageData?.isMediaDownloading = false
                CoreData.saveContext()
                
                if self.mqttDelegate != nil {
                    self.mqttDelegate?.didRefreshMessage?()
                }
            }
            
            if urlData.count > 0 {
                let documentsDirectory = CTopMostViewController.applicationDocumentsDirectory()
                
                var mediaName = ""
                var mediaPath = ""
                if messageData?.msg_type == 3 {
                    // Video
                    mediaName = "\(CApplicationName ?? "")_\(messageData?.message_id ?? "").mp4"
                }else {
                    // Audio
                    mediaName = "\(CApplicationName ?? "")_\(messageData?.message_id ?? "").caf"
                }
                mediaPath = documentsDirectory! + "/" + mediaName
                
                GCDBackgroundThread.async {
                    //saving is done on main thread
                    let videoPathURL = URL(fileURLWithPath: mediaPath)
                    try! urlData.write(to: videoPathURL, options: .atomicWrite)
                    messageData?.localMediaUrl = mediaName
                    messageData?.isMediaDownloading = false
                    CoreData.saveContext()
                    
                    if self.mqttDelegate != nil {
                        self.mqttDelegate?.didRefreshMessage?()
                    }
                }
            }
        }
        
    }
}

// MARK:- ------- Friend Status related functions
// MARK:-
extension MIMQTT {
    
    // To update user block/unblock/friend/unfriend status.
    func updateStatusForBlockUnblockFriendUnfriend(_ messageInfo:[String : Any]) {
        if self.mqttDelegate != nil {
            self.mqttDelegate?.blockUnblockFriendUnfriendStatus?(messageInfo)
        }
        
        // Delete message from Local when user is resrticted
        let arrMessage = TblMessages.fetch(predicate: NSPredicate(format: "\(CMessage_id) == %@", messageInfo.valueForString(key: CMessage_id)))
        if arrMessage?.count ?? 0 > 0 {
            if let messageInfo = arrMessage?.firstObject as? TblMessages {
                self.deleteMessageFromLocal(messageInfo)
            }
        }
    }
    
    // To update user online/offline status in core data
    func updateUserOnlineOfflineStatus(_ messageInfo:[String : Any]) {
        if let arrUsers = TblChatUserList.fetch(predicate: NSPredicate(format: "\(CFriendId) == \(messageInfo.valueForInt(key: CUserId) ?? 0)")) as? [TblChatUserList] {
            if arrUsers.count > 0 {
                let chatuserInfo = arrUsers.first
                chatuserInfo?.isOnline = messageInfo.valueForBool(key: CStatus)
                CoreData.saveContext()
                if self.mqttDelegate != nil {
                    self.mqttDelegate?.didChangedOnlineOfflineStatus?(messageInfo)
                }
            }
        }
    }
    
    // To update user for deleted group..
    func updateforDeletedGroup(_ messageInfo:[String : Any]) {
        if self.mqttDelegate != nil {
            self.mqttDelegate?.didDeletedGroup?(messageInfo)
        }
    }
    
}


// MARK:- ------- Core Data Related fucntions
// MARK:-
extension MIMQTT {
    
    // Update Message Time with local time...
    func updateMessageTimeAccordingToDevice() {
        
        if let arrMessages = TblMessages.fetchAllObjects() as? [TblMessages] {
            for messageInfo in arrMessages {
//                self.resetMessageTime(messageInfo)
            }
            
            if self.mqttDelegate != nil {
                self.mqttDelegate?.didRefreshMessage?()
            }
        }
    }
    
    // To Update message time if local time is not matching with server time.
    func resetMessageTime(_ messageInfo: TblMessages) {
        
        if let timeDifference = CUserDefaults.value(forKey: UserDefaultTimeDifference) as? Double {
            let newTimeStamp = messageInfo.message_actual_timestamp + timeDifference
            messageInfo.created_at = newTimeStamp
            let formate = "dd MMM, yyyy"
            messageInfo.msg_time = messageInfo.created_at / 1000
            messageInfo.msgdate = DateFormatter.dateStringFrom(timestamp: messageInfo.msg_time, withFormate: formate)
            let formatter = DateFormatter()
            formatter.dateFormat = formate
            formatter.calendar = Calendar(identifier: .gregorian)
            formatter.locale = DateFormatter.shared().locale
            formatter.timeZone = NSTimeZone.local
            let date = formatter.date(from: messageInfo.msgdate!)
            let temTimestamp = date?.timeIntervalSince1970
            messageInfo.msgdate = "\(temTimestamp ?? 0.0)"
            CoreData.saveContext()
        }
    }
    
    // To update read message status in core data.
    func updateMessageInLocalForReadACK(_ messageInfo:[String : Any]) {
        
        let arrMessages = messageInfo.valueForString(key: CMessage_id).components(separatedBy: ",")
        for messageID in arrMessages {
            
            let arrMessage = TblMessages.fetch(predicate: NSPredicate(format: "\(CMessage_id) == %@", messageID))
            
            if (arrMessage?.count)! > 0 {
                if let objMessageInfo = arrMessage?.firstObject as? TblMessages {
                    
                    var arrReadUsers = [String]()
                    
                    // Get read users
                    if objMessageInfo.read_users != nil {
                        arrReadUsers = (objMessageInfo.read_users! as NSString).components(separatedBy: ",")
                    }
                    
                    let readUser = messageInfo.valueForString(key: CUserId)
                    
                    // Check if user is not exist in current list
                    if !arrReadUsers.contains(readUser) {
                        arrReadUsers.append(readUser)
                        
                        let arrUsers = (objMessageInfo.users! as NSString).components(separatedBy: ",")
                        objMessageInfo.read_users = (arrReadUsers as NSArray).componentsJoined(by: ",")
                        
                        // Check total read user (Not including sender user here..)
                        if arrUsers.count - 1 == arrReadUsers.count {
                            objMessageInfo.message_Delivered = 3
                        }
                    }
                    
                    CoreData.saveContext()
                    
                    // Pass data to respective viewControllers by using the delegate..
                    if self.mqttDelegate != nil {
                        self.mqttDelegate?.didReceiveMessage?(messageInfo)
                    }
                }
            }
        }
        
        
    }
    
    // To Store new message to core data.
//    func saveMessageToLocal(messageInfo:[String : Any], msgDeliveredStatus: Int?, localPayload: Bool) {
//
//        if (messageInfo.valueForInt(key: CChat_type) == 1) // Check block/Unblock/Friend status for user chat only
//            || messageInfo.valueForInt(key: CChat_type) == 2
//        {
//            let objMessageInfo = TblMessages.findOrCreate(dictionary: [CMessage_id:messageInfo.valueForString(key: CMessage_id)]) as! TblMessages
//            objMessageInfo.status_id = 0
//            objMessageInfo.profile_image = messageInfo.valueForString(key: CProfileImage)
//            objMessageInfo.message = messageInfo.valueForString(key: CMessage)
//            objMessageInfo.full_name = messageInfo.valueForString(key: CFullName)
//            objMessageInfo.msg_type = Int16(messageInfo.valueForString(key: CMsg_type))!
//            objMessageInfo.sender_id = Int64(messageInfo.valueForString(key: CSender_Id))!
//            objMessageInfo.recv_id = Int64(messageInfo.valueForString(key: CRecv_id))!
//            objMessageInfo.chat_type = Int16(messageInfo.valueForString(key: CChat_type))!
//            objMessageInfo.users = messageInfo.valueForString(key: CUsers)
//            objMessageInfo.message_Delivered = Int16("\(msgDeliveredStatus ?? 1)")!
//            objMessageInfo.publish_type = Int16(messageInfo.valueForString(key: CPublishType))!
//            objMessageInfo.group_id = messageInfo.valueForString(key: CGroupId)
//            objMessageInfo.is_auto_delete = Int64(messageInfo.valueForString(key: CisAutoDelete)) ?? 0
//            objMessageInfo.latitude = Double(messageInfo.valueForDouble(key: CLatitude) ?? 0.0)
//            objMessageInfo.longitude = Double(messageInfo.valueForDouble(key: CLongitude) ?? 0.0)
//            objMessageInfo.address = messageInfo.valueForString(key: CAddress)
//            objMessageInfo.forwarded_msg_id = messageInfo.valueForString(key: "forwarded_msg_id")
//            objMessageInfo.localMediaUrl = messageInfo.valueForString(key: "localMediaUrl")
//
//            objMessageInfo.media_name = messageInfo.valueForString(key: "media_name")
//            if !messageInfo.valueForString(key: "thumb_url").isEmpty {
//                objMessageInfo.thumb_url = messageInfo.valueForString(key: "thumb_url")
//                objMessageInfo.thumb_name = messageInfo.valueForString(key: "thumb_name")
//            }
//
//            if !objMessageInfo.media_name.isEmptyOrNil() && msgDeliveredStatus == 2 {
//                objMessageInfo.localMediaUrl = objMessageInfo.media_name
//            }
//
//            if objMessageInfo.localMediaUrl == "" {
//                objMessageInfo.localMediaUrl = nil
//            }
//            //...Media Related Properties
//            if objMessageInfo.msg_type != 1 {
//
//                // If sending media from current device then media url will be local url...
//                if !objMessageInfo.forwarded_msg_id.isEmptyOrNil() && msgDeliveredStatus == 1 {
//                    objMessageInfo.isMediaUploadedOnServer = true
//                    CoreData.saveContext()
//                    self.publishUnsentMessages(objMessageInfo)
//
//                } else if objMessageInfo.localMediaUrl == nil && localPayload {
//                    objMessageInfo.localMediaUrl = messageInfo.valueForString(key: CMessage)
//                }
//
//                // Video Thumb URL
//                if !messageInfo.valueForString(key: CThumb_Url).isBlank {
//                    objMessageInfo.thumb_url = messageInfo.valueForString(key: CThumb_Url)
//                    objMessageInfo.thumb_name = messageInfo.valueForString(key: CThumb_Name)
//                }
//
//            }
//
//            // Create channel id for OTO chat..
//            if objMessageInfo.chat_type == 1 {
//                objMessageInfo.channel_id = objMessageInfo.sender_id == appDelegate.loginUser?.user_id ? CMQTTUSERTOPIC + "\(appDelegate.loginUser?.user_id ?? 0)/\(objMessageInfo.recv_id)" : CMQTTUSERTOPIC + "\(appDelegate.loginUser?.user_id ?? 0)/\(objMessageInfo.sender_id)"
//
//            }else {
//                // channel id for Group chat..
//                objMessageInfo.channel_id = messageInfo.valueForString(key: CChannel_id)
//            }
//
//            print("channel ========= ",objMessageInfo.channel_id ?? "")
//
//            //...Convert Timestamp in Local
//            objMessageInfo.message_actual_timestamp = DateFormatter.shared().ConvertGMTMillisecondsTimestampToLocalTimestamp(timestamp: messageInfo.valueForDouble(key: CCreated_at) ?? 0.0) ?? 0.0
//            objMessageInfo.created_at = objMessageInfo.message_actual_timestamp
//            objMessageInfo.msg_time = objMessageInfo.created_at / 1000
//            let formate = "dd MMM, yyyy"
//            objMessageInfo.msgdate = DateFormatter.dateStringFrom(timestamp: objMessageInfo.msg_time, withFormate: formate)
//            let formatter = DateFormatter()
//            formatter.dateFormat = formate
//            formatter.calendar = Calendar(identifier: .gregorian)
//            formatter.locale = DateFormatter.shared().locale
//            formatter.timeZone = NSTimeZone.local
//            let date = formatter.date(from: objMessageInfo.msgdate!)
//            let temTimestamp = date?.timeIntervalSince1970
//
//            objMessageInfo.msgdate = "\(temTimestamp ?? 0.0)"
//
//            CoreData.saveContext()
//
//            // To Update message time if local time is not matching with server time.
//            self.resetMessageTime(objMessageInfo)
//        }
//
//        // Pass data to respective viewControllers by using the delegate..
//        if self.mqttDelegate != nil {
//            self.mqttDelegate?.didReceiveMessage?(messageInfo)
//        }
//
//    }
}





