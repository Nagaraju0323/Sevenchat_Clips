////
////  ChatSocketIO.swift
////  Sevenchats
////
////  Created by APPLE on 03/09/21.
////  Copyright © 2021 mac-00020. All rights reserved.
////
//
import Foundation
import UIKit
import AVKit
import TrueTime
import StompClientLib


// MQTTDelegate Methods
 protocol SocketDelegate: class {
     func didRefreshMessages()
//    @objc optional func didChangedOnlineOfflineStatus(_ message: [String : Any]?)
//    @objc optional func blockUnblockFriendUnfriendStatus(_ message: [String : Any]?)
//    @objc optional func didDeletedGroup(_ message: [String : Any]?)
//    @objc optional func didRecivedMsgData(_ message:[String:Any]?)

}




var msgJsonData : ((String) -> Void)?

class ChatSocketIo: NSObject {

    weak var socketDelegate: SocketDelegate?
//    weak var mqttDelegate: MQTTDelegate?
    var timeClient: TrueTimeClient?
    weak var stompClientLibDelegte:StompClientLibDelegate?

    var socketClient = StompClientLib()
    var dictload = [String:Any]()
    var namemsg = ""

    private static var chatSocketIo:ChatSocketIo = {
        let chatSocketIo = ChatSocketIo()
        return chatSocketIo
    }()
    static func shared() ->ChatSocketIo {
        return chatSocketIo
    }

    public override init() {
        super.init()
        self.stompClientLibDelegte = self
    }
    func SocketInitilized(){
        guard !socketClient.isConnected() else { return }
        let url = URL(string: SocketIoUrl)
        socketClient.openSocketWithURLRequest(request: NSURLRequest(url: url!) , delegate: self)
        print(":::::::::::SocketInitilized:::::::::::")
    }

    func createTopicTouser(userTopic:String){
        print(":::::::::::SocketInitilizedcreateTopicTouser:::::::::::")
        print("topicname\(userTopic)")
        socketClient.subscribe(destination: userTopic)
    }

    func reconeectSocket(){
        let url = URL(string: SocketIoUrl)
        socketClient.reconnect(request: NSURLRequest(url: url! as URL) , delegate: self as StompClientLibDelegate, time: 4.0)
    }
    
    func disconnectSocket(){
        socketClient.disconnect()
    }
    

    func reconnect() {
        let url = URL(string: SocketIoUrl)
        socketClient.reconnect(request: NSURLRequest(url: url! as URL),  delegate: self, connectionHeaders: [:], time: 4, exponentialBackoff: false)
        stompClientLibDelegte = self
    }
    var apiTask : URLSessionTask?
    
    //Download VidoeFile
    func downloadAudioVideoAndStoreInDocumentDirectorySocket(_ messageData: TblMessages?) {
        // If url not found
        var urlToDownload = ""
        if (messageData?.message?.isBlank)! || messageData?.message == nil {
            MIToastAlert.shared.showToastAlert(position: .bottom, message: CMessageMediaNotExist)
//            if self.mqttDelegate != nil {
//                self.mqttDelegate?.didRefreshMessage?()
//            }
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
                    if self.socketDelegate != nil {
                        self.socketDelegate?.didRefreshMessages()
                    }
                }
            }
        }
    }
    
    func retrieveTheAnswer(completion: (_ answer:String) -> ()) {
        completion(namemsg)
    }
    
}

extension ChatSocketIo: StompClientLibDelegate{
  
    func serverDidSendError(client: StompClientLib!, withErrorMessage description: String, detailedErrorMessage message: String?) {
        print(":::::::::::serverDidSendError:::::::::::")
    }

    func serverDidSendPing() {
        print(":::::::::::serverDidSendPing:::::::::::")
    }

    func stompClient(client: StompClientLib!, didReceiveMessageWithJSONBody jsonBody: AnyObject?, akaStringBody stringBody: String?, withHeader header: [String : String]?, withDestination destination: String) {

        print("JSON BODY : \(String(describing: jsonBody))")
        let sender = jsonBody?["sender"] as? String
        let content = jsonBody?["content"] as? String
        let topic = jsonBody?["topic"] as? String
        let timestamp = jsonBody?["timestamp"] as? String
        var chatTypemode = ""
        var dict = [String: String]()
        dict["sender"] = sender?.description
        dict["content"] = content?.description
        dict["topic"] = topic?.description
        dict["timestamp"] = timestamp?.description
       
        do {
            let dict = try convertToDictionary(from: content ?? "")
            let chatMode =  dict["chat"]
            if chatMode == "group"{
                chatTypemode = "group"
            }else{
                chatTypemode = "user"
            }
            
        }catch let error {
            print("erro\(error)")
        }
  
        if chatTypemode == "user"{
            if sender == appDelegate.loginUser?.user_id.description{
                if sender == appDelegate.loginUser?.user_id.description{
                    sendingMessageNotfication(dictMsg:dict)
                }
            }else {
                MsgrecviedNotification(dictMsg: dict)
                NotificationCenter.default.post(name: Notification.Name("MsgrecviedNotification"), object: nil,userInfo: dict)
            }
          }else{
            if sender == appDelegate.loginUser?.user_id.description{
                sendingMessageNotficationGrp(dictMsg: dict)
//                NotificationCenter.default.post(name: Notification.Name("MsgSentNotificationGrp"), object: nil,userInfo: dict)
            }else {
                recivedMessageNotficationGrp(dictMsg: dict)
                NotificationCenter.default.post(name: Notification.Name("MsgrecviedNotificationGrp"), object: nil,userInfo: dict)
            }
        }
    }
    
    func stompClientDidDisconnect(client: StompClientLib!) {
        print(":::::::::::stompClientDidDisconnect:::::::::::")
     }

    func stompClientDidConnect(client: StompClientLib!) {
        print(":::::::::::stompClientDidConnect:::::::::::")
     }

     func serverDidSendReceipt(client: StompClientLib!, withReceiptId receiptId: String) {
        print(":::::::::::serverDidSendReceipt:::::::::::")
     }
    
    func convertToDictionary(from text: String) throws -> [String: String] {
        guard let data = text.data(using: .utf8) else { return [:] }
        let anyResult: Any = try JSONSerialization.jsonObject(with: data, options: [])
        return anyResult as? [String: String] ?? [:]
    }
    
    
    /********************************************************
     * Author : Chandrika .R                                *
     * Model  :sending Messages                             *
     * option                                               *
     ********************************************************/
    func sendingMessageNotfication(dictMsg:[String:Any]){
        
        var txtmessage = ""
        var msgType:String?
        var image_path:String?
        var userName:String?
        var userProfile:String?
        let content = dictMsg["content"] as? String ?? ""
        let sender = dictMsg["sender"] as? String ?? ""
        let timestamp = dictMsg["timestamp"] as? String ?? ""
        let topic = dictMsg["topic"] as? String ?? ""
        do {
            let dict = try convertToDictionary(from: content)
            let msgText  = dict["message"] ?? ""
            userName  = dict["name"] ?? ""
            userProfile  = dict["profile_image"] ?? ""
            
            
            msgType = dict["type"] ?? ""
            if msgType == "image" || msgType == "audio" || msgType == "video"{
                do {
                    image_path = dict["message"]
                    txtmessage = image_path ?? ""
                }catch {
                    print(error)
                }
            } else {
                txtmessage = msgText
            }
        } catch {
            print(error)
        }

        if msgType == "text"{
            ChatSocketIo.shared().messagePaylaod(arrUser: ["\(sender)"], channelId:topic , message: txtmessage, messageType: .text, chatType: .user, groupID: nil, latitude: 0.0, longitude: 0.0, address: "", forwardedMsgId: "", cloleFile: nil, sender: sender , isSelected: false,senderName:userName ?? "",SenderProfImg:userProfile ?? "")
        }else if msgType == "image"{
            ChatSocketIo.shared().messagePaylaod(arrUser: ["\(sender)"], channelId:topic , message: txtmessage, messageType: .image, chatType: .user, groupID: nil, latitude: 0.0, longitude: 0.0, address: "", forwardedMsgId: "", cloleFile: nil, sender: sender , isSelected: false,senderName:userName ?? "",SenderProfImg:userProfile ?? "")
        }else if msgType == "video"{
            ChatSocketIo.shared().messagePaylaod(arrUser: ["\(sender)"], channelId:topic , message: txtmessage, messageType: .video, chatType: .user, groupID: nil, latitude: 0.0, longitude: 0.0, address: "", forwardedMsgId: "", cloleFile: nil, sender: sender , isSelected: false,senderName:userName ?? "",SenderProfImg:userProfile ?? "")
        }else if msgType == "audio"{
            ChatSocketIo.shared().messagePaylaod(arrUser: ["\(sender)"], channelId:topic , message: txtmessage, messageType: .audio, chatType: .user, groupID: nil, latitude: 0.0, longitude: 0.0, address: "", forwardedMsgId: "", cloleFile: nil, sender: sender , isSelected: false,senderName:userName ?? "",SenderProfImg:userProfile ?? "")
        }
    }
    
    /********************************************************
     * Author :  Chandrika R                               *
     * Model  :reciving Messages                           *
     * option                                              *
     ********************************************************/
    
    func MsgrecviedNotification(dictMsg:[String:Any]){
        var txtmessage = ""
        var msgType:String?
        var image_path:String?
        var userName:String?
        var userProfile:String?
        let content = dictMsg["content"] as? String ?? ""
        let sender = dictMsg["sender"] as? String ?? ""
        let timestamp = dictMsg["timestamp"] as? String ?? ""
        let topic = dictMsg["topic"] as? String ?? ""
        do {
            let dict = try convertToDictionary(from: content)
            let msgText  = dict["message"] ?? ""
            userName  = dict["name"] ?? ""
            userProfile  = dict["profile_image"] ?? ""
           
            msgType = dict["type"] ?? ""
            if msgType == "image" || msgType == "audio" || msgType == "video"{
                do {
                    image_path = dict["message"]
                    txtmessage = image_path ?? ""
                }catch {
                    print(error)
                }
            } else {
                txtmessage = msgText
            }
        } catch {
            print(error)
        }

        if msgType == "text"{
            ChatSocketIo.shared().messagePaylaod(arrUser: ["\(sender)"], channelId:topic , message: txtmessage, messageType: .text, chatType: .user, groupID: nil, latitude: 0.0, longitude: 0.0, address: "", forwardedMsgId: "", cloleFile: nil, sender: sender , isSelected: false,senderName:userName ?? "",SenderProfImg:userProfile ?? "")
        }else if msgType == "image"{
            ChatSocketIo.shared().messagePaylaod(arrUser: ["\(sender)"], channelId:topic , message: txtmessage, messageType: .image, chatType: .user, groupID: nil, latitude: 0.0, longitude: 0.0, address: "", forwardedMsgId: "", cloleFile: nil, sender: sender , isSelected: false,senderName:userName ?? "",SenderProfImg:userProfile ?? "")
        }else if msgType == "video"{
            ChatSocketIo.shared().messagePaylaod(arrUser: ["\(sender)"], channelId:topic , message: txtmessage, messageType: .video, chatType: .user, groupID: nil, latitude: 0.0, longitude: 0.0, address: "", forwardedMsgId: "", cloleFile: nil, sender: sender , isSelected: false,senderName:userName ?? "",SenderProfImg:userProfile ?? "")
        }else if msgType == "audio"{
            ChatSocketIo.shared().messagePaylaod(arrUser: ["\(sender)"], channelId:topic , message: txtmessage, messageType: .audio, chatType: .user, groupID: nil, latitude: 0.0, longitude: 0.0, address: "", forwardedMsgId: "", cloleFile: nil, sender: sender , isSelected: false,senderName:userName ?? "",SenderProfImg:userProfile ?? "")
        }
    }
  
    /********************************************************
     * Author :  Chandrika R                                *
     * Model  : sending messageGroup                        *
     * option                                               *
     ********************************************************/
    func sendingMessageNotficationGrp(dictMsg:[String:Any]){
        var txtmessage:String?
        var msgType:String?
        var image_path:String?
        var userName:String?
        var userProfile:String?
//      let userInfo : [String:String] = dictMsg.userInfo as! [String:String]
        let content = dictMsg["content"] as? String ?? ""
        let sender = dictMsg["sender"] as? String ?? ""
        let topic = dictMsg["topic"] as? String ?? ""
        do {
            let dict = try convertToDictionary(from: content)
            if dict["chat"] ?? "" == "group" {
            let msgText  = dict["message"] ?? ""
                userName  = dict["name"] ?? ""
                userProfile  = dict["profile_image"] ?? ""
                msgType = dict["type"] ?? ""
                if msgType == "image" || msgType == "audio" || msgType == "video"{
                do {
//                    let txtMsgfrom = msgText.replace(string: "\\", replacement: "")
//                    let dict = try? convertToDictionary(from: txtMsgfrom)
                    image_path = dict["message"]
                    txtmessage = image_path
                    
                }catch {
                print(error)
                }
               } else {
                txtmessage = msgText
               }
            }
          } catch {
            print(error)
        }
        if msgType == "text"{
            ChatSocketIo.shared().messagePaylaod(arrUser: ["\(sender )"], channelId:topic , message: txtmessage, messageType: .text, chatType: .group, groupID: topic, latitude: 0.0, longitude: 0.0, address: "", forwardedMsgId: "", cloleFile: nil, sender: sender , isSelected: true,senderName:userName ?? "",SenderProfImg:userProfile ?? "")
        }else if msgType == "image"{
            ChatSocketIo.shared().messagePaylaod(arrUser: ["\(sender )"], channelId:topic , message: txtmessage, messageType: .image, chatType: .group, groupID: topic, latitude: 0.0, longitude: 0.0, address: "", forwardedMsgId: "", cloleFile: nil, sender: sender , isSelected: true,senderName:userName ?? "",SenderProfImg:userProfile ?? "")
        }else if msgType == "video"{
            
            ChatSocketIo.shared().messagePaylaod(arrUser: ["\(sender )"], channelId:topic , message: txtmessage, messageType: .video, chatType: .group, groupID: topic, latitude: 0.0, longitude: 0.0, address: "", forwardedMsgId: "", cloleFile: nil, sender: sender , isSelected: true,senderName:userName ?? "",SenderProfImg:userProfile ?? "")

        }else if msgType == "audio"{
            ChatSocketIo.shared().messagePaylaod(arrUser: ["\(sender )"], channelId:topic , message: txtmessage, messageType: .audio, chatType: .group, groupID: topic, latitude: 0.0, longitude: 0.0, address: "", forwardedMsgId: "", cloleFile: nil, sender: sender , isSelected: true,senderName:userName ?? "",SenderProfImg:userProfile ?? "")
        }
    }

    func recivedMessageNotficationGrp(dictMsg:[String:Any]){
      
        var txtmessage:String?
        var msgType:String?
        var image_path:String?
        var userName:String?
        var userProfile:String?
        
        let content = dictMsg["content"] as? String ?? ""
        let sender = dictMsg["sender"] as? String ?? ""
        let topic = dictMsg["topic"] as? String ?? ""
        do {
            let dict = try convertToDictionary(from: content)
            let chatType = dict["message"] ?? ""
            userName  = dict["name"] ?? ""
            userProfile  = dict["profile_image"] ?? ""
            
            if dict["chat"] ?? "" == "group" {
            let msgText  = dict["message"] ?? ""
                msgType = dict["type"] ?? ""
                if msgType == "image"{
                do {
                    image_path = dict["message"]
                    txtmessage = image_path
                }catch {
                    print(error)
                }
                }else if msgType == "audio"{
                    image_path = dict["message"]
                    txtmessage = image_path
                    
                }else if msgType == "video"{
                    image_path = dict["message"]
                    txtmessage = image_path
                } else {
                txtmessage = msgText
              }
           }
        } catch {
            print(error)
        }
        
        if msgType == "text"{
            ChatSocketIo.shared().messagePaylaod(arrUser: ["\(sender )"], channelId:topic , message: txtmessage, messageType: .text, chatType: .group, groupID: topic, latitude: 0.0, longitude: 0.0, address: "", forwardedMsgId: "", cloleFile: nil, sender: sender , isSelected: true,senderName:userName ?? "",SenderProfImg:userProfile ?? "")
        }else if msgType == "image"{
            ChatSocketIo.shared().messagePaylaod(arrUser: ["\(sender )"], channelId:topic , message: txtmessage, messageType: .image, chatType: .group, groupID: topic, latitude: 0.0, longitude: 0.0, address: "", forwardedMsgId: "", cloleFile: nil, sender: sender , isSelected: true,senderName:userName ?? "", SenderProfImg:userProfile ?? "")
        }else if msgType == "video"{
            
            ChatSocketIo.shared().messagePaylaod(arrUser: ["\(sender )"], channelId:topic , message: txtmessage, messageType: .video, chatType: .group, groupID: topic, latitude: 0.0, longitude: 0.0, address: "", forwardedMsgId: "", cloleFile: nil, sender: sender , isSelected: true,senderName:userName ?? "", SenderProfImg:userProfile ?? "")
            
        }else if msgType == "audio"{
            ChatSocketIo.shared().messagePaylaod(arrUser: ["\(sender )"], channelId:topic , message: txtmessage, messageType: .audio, chatType: .group, groupID: topic, latitude: 0.0, longitude: 0.0, address: "", forwardedMsgId: "", cloleFile: nil, sender: sender , isSelected: true,senderName:userName ?? "", SenderProfImg:userProfile ?? "")
        }
    }
}


extension ChatSocketIo {
    // To Store new message to core data.
    func messagePaylaod(arrUser: [String?], channelId: String?, message: String?, messageType: MessageType?, chatType: ChatType?,  groupID: String?, latitude:Double = 0.0, longitude:Double = 0.0, address: String = "", forwardedMsgId: String = "", cloleFile:MDLCloneMedia? = nil,sender:String,isSelected:Bool,senderName:String,SenderProfImg:String){

        var dicPayload = [String : Any]()
            dicPayload[CSender_Id] = sender
        dicPayload[CMessage] = message
        dicPayload[CMsg_type] = messageType?.rawValue
        dicPayload[CChat_type] = chatType?.rawValue
        dicPayload[CMessage_id] = (UIDevice.current.identifierForVendor?.uuidString)!.replacingOccurrences(of: "-", with: "") + "\(Int(Date().timeIntervalSince1970 * 1000))"
        dicPayload[CChannel_id] = channelId
        dicPayload[CFullName] = senderName
        dicPayload[CProfileImage] = SenderProfImg
        dicPayload[CUsers] = arrUser.compactMap({$0}).joined(separator: ",")
        dicPayload[CPublishType] = CPUBLISHMESSAGETYPE

        dicPayload[CLatitude] = latitude
        dicPayload[CLongitude] = longitude
        dicPayload[CAddress] = address
        dicPayload["forwarded_msg_id"] = forwardedMsgId

        if let time = timeClient, time.referenceTime?.now() != nil {
            dicPayload[CCreated_at] = ((time.referenceTime?.now().timeIntervalSince1970 ?? 0) * 1000).toInt
        }else {
            dicPayload[CCreated_at] = DateFormatter.shared().currentGMTTimestampInMilliseconds()?.toInt
        }
        dicPayload[CGroupId] = groupID != nil ? groupID?.toInt : 0
        dicPayload[CThumb_Url] = ""
        dicPayload[CThumb_Name] = ""
        dicPayload[CMedia_Name] = ""
        dicPayload["localMediaUrl"] = message
        
        self.saveMessageToLocal(messageInfo: dicPayload, msgDeliveredStatus: 1, localPayload: true,lastMsg:1,isfrom:1)
    }
    
    
    func messagePaylaodLast(arrUser: [String?], channelId: String?, message: String?, messageType: MessageType?, chatType: ChatType?,  groupID: String?, latitude:Double = 0.0, longitude:Double = 0.0, address: String = "", forwardedMsgId: String = "", cloleFile:MDLCloneMedia? = nil,sender:String,isSelected:Bool, createat:String,timestampDate:String,senderName:String,SenderProfImg:String){

        var dicPayload = [String : Any]()
        dicPayload[CSender_Id] = sender
        dicPayload[CMessage] = message
        dicPayload[CMsg_type] = messageType?.rawValue
        dicPayload[CChat_type] = chatType?.rawValue
        dicPayload[CMessage_id] = (UIDevice.current.identifierForVendor?.uuidString)!.replacingOccurrences(of: "-", with: "") + "\(Int(Date().timeIntervalSince1970 * 1000))"
        dicPayload[CChannel_id] = channelId
        dicPayload[CFullName] = senderName
//        dicPayload[CFullName] = (appDelegate.loginUser?.first_name)! + " " + (appDelegate.loginUser?.last_name)!
        
        dicPayload[CProfileImage] = SenderProfImg
        dicPayload[CUsers] = arrUser.compactMap({$0}).joined(separator: ",")
        dicPayload[CPublishType] = CPUBLISHMESSAGETYPE

        dicPayload[CLatitude] = latitude
        dicPayload[CLongitude] = longitude
        dicPayload[CAddress] = address
        dicPayload["forwarded_msg_id"] = forwardedMsgId
        dicPayload[CCreated_at] = createat
        dicPayload["msgdateTimestamp"] = timestampDate
        dicPayload[CGroupId] = groupID != nil ? groupID?.toInt : 0
        dicPayload[CThumb_Url] = ""
        dicPayload[CThumb_Name] = ""
        dicPayload[CMedia_Name] = ""
        dicPayload["localMediaUrl"] = message
        self.saveMessageToLocal(messageInfo: dicPayload, msgDeliveredStatus: 1, localPayload: true,lastMsg:2, isfrom: 2)
    }
    
    
    
    func saveMessageToLocal(messageInfo:[String : Any], msgDeliveredStatus: Int?, localPayload: Bool,lastMsg:Int?,isfrom:Int?) {
//        print("messageinfor\(messageInfo)")

        if (messageInfo.valueForInt(key: CChat_type) == 1) // Check block/Unblock/Friend status for user chat only
            || messageInfo.valueForInt(key: CChat_type) == 2
        {
//            print("messageinfor\(messageInfo)")
            let objMessageInfo = TblMessages.findOrCreate(dictionary: [CMessage_id:messageInfo.valueForString(key: CMessage_id)]) as! TblMessages
            objMessageInfo.status_id = 0
            objMessageInfo.profile_image = messageInfo.valueForString(key: CProfileImage)
            objMessageInfo.message = messageInfo.valueForString(key: CMessage)
            objMessageInfo.full_name = messageInfo.valueForString(key: CFullName)
            objMessageInfo.msg_type = Int16(messageInfo.valueForString(key: CMsg_type))!
            objMessageInfo.sender_id = Int64(messageInfo.valueForString(key: CSender_Id))!
            objMessageInfo.recv_id = Int64(messageInfo.valueForString(key: CRecv_id)) ?? 0
            objMessageInfo.chat_type = Int16(messageInfo.valueForString(key: CChat_type) ) ?? 0
            objMessageInfo.users = messageInfo.valueForString(key: CUsers)
            objMessageInfo.message_Delivered = Int16("\(msgDeliveredStatus ?? 1)")!
            objMessageInfo.group_id = messageInfo.valueForString(key: CGroupId)
            objMessageInfo.latitude = Double(messageInfo.valueForDouble(key: CLatitude) ?? 0.0)
            objMessageInfo.longitude = Double(messageInfo.valueForDouble(key: CLongitude) ?? 0.0)
            objMessageInfo.address = messageInfo.valueForString(key: CAddress)
            objMessageInfo.forwarded_msg_id = messageInfo.valueForString(key: "forwarded_msg_id")
            objMessageInfo.localMediaUrl = messageInfo.valueForString(key: "localMediaUrl")

            objMessageInfo.media_name = messageInfo.valueForString(key: "media_name")
            if !messageInfo.valueForString(key: "thumb_url").isEmpty {
                objMessageInfo.thumb_url = messageInfo.valueForString(key: "thumb_url")
                objMessageInfo.thumb_name = messageInfo.valueForString(key: "thumb_name")
            }

            if !objMessageInfo.media_name.isEmptyOrNil() && msgDeliveredStatus == 2 {
                objMessageInfo.localMediaUrl = objMessageInfo.media_name
            }

            if objMessageInfo.localMediaUrl == "" {
                objMessageInfo.localMediaUrl = nil
            }
            //...Media Related Properties
            if objMessageInfo.msg_type != 1 {

                // If sending media from current device then media url will be local url...
                if !objMessageInfo.forwarded_msg_id.isEmptyOrNil() && msgDeliveredStatus == 1 {
                    objMessageInfo.isMediaUploadedOnServer = true
                    CoreData.saveContext()
//                    self.publishUnsentMessages(objMessageInfo)

                } else if objMessageInfo.localMediaUrl == nil && localPayload {
                    objMessageInfo.localMediaUrl = messageInfo.valueForString(key: CMessage)
                }

                // Video Thumb URL
                if !messageInfo.valueForString(key: CThumb_Url).isBlank {
                    objMessageInfo.thumb_url = messageInfo.valueForString(key: CThumb_Url)
                    objMessageInfo.thumb_name = messageInfo.valueForString(key: CThumb_Name)
                }
            }

            // Create channel id for OTO chat..
            if objMessageInfo.chat_type == 1 {

                objMessageInfo.channel_id = messageInfo.valueForString(key: CChannel_id)
            }else {
                // channel id for Group chat..
                objMessageInfo.channel_id = messageInfo.valueForString(key: CChannel_id)
            }

            print("channel ========= ",objMessageInfo.channel_id ?? "")

            //...Convert Timestamp in Local
            objMessageInfo.message_actual_timestamp = DateFormatter.shared().ConvertGMTMillisecondsTimestampToLocalTimestampChat(timestamp: messageInfo.valueForDouble(key: CCreated_at) ?? 0.0) ?? 0.0
            objMessageInfo.created_at = objMessageInfo.message_actual_timestamp
            
            
            if isfrom == 2{
//                objMessageInfo.msg_time = Double(Int(objMessageInfo.created_at / 1000))
                print(Double(String(objMessageInfo.created_at)) ?? 0.0)
                objMessageInfo.msg_time = Double(String(objMessageInfo.created_at)) ?? 0.0
            }else {
                objMessageInfo.msg_time = objMessageInfo.created_at / 1000
            }
            
            objMessageInfo.msgdateTimestamp = messageInfo.valueForString(key: "msgdateTimestamp")
            let formate = "dd MMM, yyyy"
            objMessageInfo.msgdate = DateFormatter.dateStringFrom(timestamp: objMessageInfo.msg_time, withFormate: formate)
            let formatter = DateFormatter()
            formatter.dateFormat = formate
            formatter.calendar = Calendar(identifier: .gregorian)
            formatter.locale = DateFormatter.shared().locale
            formatter.timeZone = NSTimeZone.local
            let date = formatter.date(from: objMessageInfo.msgdate!)
            let temTimestamp = date?.timeIntervalSince1970
            
            if lastMsg == 2{
//                objMessageInfo.msgdate = "\(messageInfo.valueForInt(key: CCreated_at) ?? 0)"
              
                objMessageInfo.msgdate = "\(temTimestamp ?? 0.0)"
                
            }else {
                objMessageInfo.msgdate = "\(temTimestamp ?? 0.0)"
            }
//            print("objecMessainfo\(objMessageInfo)")
//            objMessageInfo.msgdate = "\(temTimestamp ?? 0.0)"

            CoreData.saveContext()
        }
    }
    
}

extension Dictionary{
    func convertToDictionary(from text: String) throws -> [String: String] {
        guard let data = text.data(using: .utf8) else { return [:] }
        let anyResult: Any = try JSONSerialization.jsonObject(with: data, options: [])
        return anyResult as? [String: String] ?? [:]
    }
}

