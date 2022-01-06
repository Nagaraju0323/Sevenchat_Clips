////
////  TVIVideoHelper+CallKit.swift
////  Sevenchats
////
////  Created by mac-00020 on 26/02/20.
////  Copyright © 2020 mac-0005. All rights reserved.
////
//
//import Foundation
//import TwilioVideo
//import CallKit
//import AVFoundation
//import Alamofire
//
//extension TVIVideoHelper {
//    
//    fileprivate func moveOnOTOVideoScreen() {
//        
//        appDelegate.sideMenuController.rootViewController = UINavigationController.init(rootViewController: CStoryboardChat.instantiateViewController(withIdentifier: "ChatListViewController"))
//        appDelegate.hideSidemenu()
//        GCDMainThread.asyncAfter(deadline: .now() + kScreenMovingTime, execute: {
//            if let oneToOneVideo = CStoryboardAudioVideo.instantiateViewController(withIdentifier: "OneToOneVideoCallVC") as? OneToOneVideoCallVC {
//                
//                if self.notification?.userData.roomType == .UserRoom{
//                    oneToOneVideo.id = (self.notification?.userData.receiverId ?? 0)
//                    oneToOneVideo.roomType = .UserRoom
//                    oneToOneVideo.fullName = self.notification?.userData.fullName ?? ""
//                }else{
//                    oneToOneVideo.id = self.notification?.userData.receiverId ?? 0
//                    oneToOneVideo.roomType = .GroupRoom
//                    oneToOneVideo.fullName = self.notification?.userData.groupName ?? ""
//                }
//                oneToOneVideo.isSender = false
//                oneToOneVideo.userImage = self.notification?.userData.userImage ?? ""
//                let viewController = appDelegate.getTopMostViewController()
//                viewController.navigationController?.pushViewController(oneToOneVideo, animated: true)
//            }
//        })
//    }
//    
//    fileprivate func moveGroupVideoScreen() {
//        
//        appDelegate.sideMenuController.rootViewController = UINavigationController.init(rootViewController: CStoryboardGroup.instantiateViewController(withIdentifier: "GroupsViewController"))
//        appDelegate.hideSidemenu()
//        GCDMainThread.asyncAfter(deadline: .now() + kScreenMovingTime, execute: {
//            if let oneToOneVideo = CStoryboardAudioVideo.instantiateViewController(withIdentifier: "OneToOneVideoCallVC") as? OneToOneVideoCallVC {
//                
//                if self.notification?.userData.roomType == .UserRoom{
//                    oneToOneVideo.id = (self.notification?.userData.receiverId ?? 0)
//                    oneToOneVideo.roomType = .UserRoom
//                }else{
//                    oneToOneVideo.id = self.notification?.userData.receiverId ?? 0
//                    oneToOneVideo.roomType = .GroupRoom
//                }
//                oneToOneVideo.isSender = false
//                oneToOneVideo.fullName = self.notification?.userData.fullName ?? ""
//                oneToOneVideo.userImage = self.notification?.userData.userImage ?? ""
//                let viewController = appDelegate.getTopMostViewController()
//                viewController.navigationController?.pushViewController(oneToOneVideo, animated: true)
//            }
//        })
//    }
//    
//    func onRejectIncomingVideoCall() {
//        guard let _notification = self.notification else {
//            return
//        }
//        if self.roomInfo.isSender {
//            if self.room != nil{
//                self.disconnectCallAPI()
//            }
//           return
//        }
//        
//        if _notification.userData.roomType == .UserRoom{
//            TVITokenService.shared.disconnectCallAPI(
//                receiverIdentity: _notification.fromIdentity ?? ""
//            )
//        }else{
//            
//            let myId = (appDelegate.loginUser?.user_id ?? 0).description
//            var members = _notification.userData.memberIds
//            members.remove(object: myId)
//            
//            //let senderId = _notification.userData.senderId ?? 0
//            //let receiverId = members.map({ "User" + $0})
//            let notification_id = _notification.notificationId ?? ""
//            //let myIdentity = _notification.fromIdentity ?? ""
//            
//            var receiverIdentity =  members.map({ "User" + $0})
//            receiverIdentity.append(_notification.fromIdentity ?? "")
//            
//            let roomName = _notification.roomName ?? ""
//            let notificationType = CallNotificationType.RejectGroupVideoNotification.rawValue
//            
//            
//            let memberIds = members.joined(separator: ",")
//            
//            let finalUrl = TwilloBaseURL + APICustomeNotification
//            print(finalUrl)
//            let bodyParm : [String : Any] = [
//                "identity" : receiverIdentity.joined(separator: ","),
//                "room_name" : roomName,
//                "from_identity" : "User" + myId,
//                "notification_id" : notification_id,
//                "notification_type" : notificationType,
//                "user_data" : [
//                    "sender_id" :  "User" + myId,
//                    "receiver_id" : "0",
//                    "channel_type" : "Group", // (1To1 || Group)
//                    "fullName" : _notification.userData.fullName,
//                    "userImage" : _notification.userData.userImage,
//                    "memberIds" : memberIds
//                ].json
//            ]
//            print(bodyParm)
//            ServiceManager.callPostApi(finalUrl, methodType: .POST, isLoaderRequired: false, paramters: bodyParm, encoding: URLEncoding.queryString, successModel: SuccessModel.self, failuerModel: FailureModel.self) { [weak self] (model, failuerModel) in
//                guard let _ = self else { return }
//                appDelegate.videoCallHelper = nil
//                if let code = model?.meta?.code, code == 0 {
//                }
//            }
//            
//            /*TVITokenService.shared.disconnectCallAPI(
//                receiverIdentity: ""
//            )*/
//        }
//    }
//}
//
//extension TVIVideoHelper : CXProviderDelegate {
//    
//    func providerDidReset(_ provider: CXProvider) {
//        logMessage(messageText: "providerDidReset:")
//
//        // AudioDevice is enabled by default
//        self.audioDevice?.isEnabled = true
//        
//        room?.disconnect()
//    }
//
//    func providerDidBegin(_ provider: CXProvider) {
//        logMessage(messageText: "providerDidBegin")
//    }
//
//    func provider(_ provider: CXProvider, didActivate audioSession: AVAudioSession) {
//        logMessage(messageText: "provider:didActivateAudioSession:")
//        
//        self.audioDevice?.isEnabled = true
//    }
//
//    func provider(_ provider: CXProvider, didDeactivate audioSession: AVAudioSession) {
//        logMessage(messageText: "provider:didDeactivateAudioSession:")
//    }
//
//    func provider(_ provider: CXProvider, timedOutPerforming action: CXAction) {
//        logMessage(messageText: "provider:timedOutPerformingAction:")
//    }
//
//    func provider(_ provider: CXProvider, perform action: CXStartCallAction) {
//        logMessage(messageText: "provider:performStartCallAction:")
//        self.callUUID = action.uuid
//        /*
//         * Configure the audio session, but do not start call audio here, since it must be done once
//         * the audio session has been activated by the system after having its priority elevated.
//         */
//        //self.configureAudioSession()
//        
//        // Stop the audio unit by setting isEnabled to `false`.
//        self.audioDevice?.isEnabled = false
//        
//        // Configure the AVAudioSession by executign the audio device's `block`.
//        self.audioDevice?.block()
//
//        callKitProvider.reportOutgoingCall(with: action.callUUID, startedConnectingAt: nil)
//        
//        performRoomConnect(uuid: action.callUUID, roomName: action.handle.value) { (success) in
//            if (success) {
//                provider.reportOutgoingCall(with: action.callUUID, connectedAt: Date())
//                action.fulfill()
//                
//            } else {
//                action.fail()
//            }
//        }
//    }
//    
//    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
//        logMessage(messageText: "provider:performAnswerCallAction:")
//
//        /*
//         * Configure the audio session, but do not start call audio here, since it must be done once
//         * the audio session has been activated by the system after having its priority elevated.
//         */
//
//        // Stop the audio unit by setting isEnabled to `false`.
//        self.audioDevice?.isEnabled = false
//        //self.configureAudioSession()
//        
//        // Configure the AVAudioSession by executign the audio device's `block`.
//        self.audioDevice?.block()
//
//        performRoomConnect(uuid: action.callUUID, roomName: self.room?.name ?? "") { (success) in
//            if (success) {
//                //action.fulfill(withDateConnected: Date())
//                action.fulfill()
//            } else {
//                action.fail()
//            }
//        }
//    }
//
//    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
//        NSLog("provider:performEndCallAction:")
//        audioDevice?.isEnabled = true
//        room?.disconnect()
//        performEndCallAction { (_) in
//            action.fulfill()
//            self.onRejectIncomingVideoCall()
//        }
//    }
//
//    func provider(_ provider: CXProvider, perform action: CXSetMutedCallAction) {
//        NSLog("provier:performSetMutedCallAction:")
//        
//        if let localAudioTrack = self.localAudioTrack {
//            localAudioTrack.isEnabled = !action.isMuted
//        }
//        self.didMuteCall?(!action.isMuted)
//        //muteAudio(isMuted: action.isMuted)
//        
//        action.fulfill()
//    }
//
//    func provider(_ provider: CXProvider, perform action: CXSetHeldCallAction) {
//        NSLog("provier:performSetHeldCallAction:")
//
//        let cxObserver = callKitCallController.callObserver
//        let calls = cxObserver.calls
//        
//        guard let call = calls.first(where:{$0.uuid == action.callUUID}) else {
//            action.fail()
//            return
//        }
//        
//        self.localAudioTrack?.isEnabled = !call.isOnHold
//        self.localVideoTrack?.isEnabled = !call.isOnHold
//        /*if call.isOnHold {
//            holdCall(onHold: false)
//        } else {
//            holdCall(onHold: true)
//        }*/
//        action.fulfill()
//    }
//}
//
//extension TVIVideoHelper {
//
//    func performStartCallAction(uuid: UUID, roomName: String?) {
//        
//        let callHandle = CXHandle(type: .generic, value: roomName ?? "")
//        let startCallAction = CXStartCallAction(call: uuid, handle: callHandle)
//        
//        startCallAction.isVideo = true
//        
//        let transaction = CXTransaction(action: startCallAction)
//        
//        callKitCallController.request(transaction)  { error in
//            if let error = error {
//                NSLog("StartCallAction transaction request failed: \(error.localizedDescription)")
//                return
//            }
//            NSLog("StartCallAction transaction request successful")
//        }
//    }
//
//    func reportIncomingCall(uuid: UUID, roomName: String?, completion: ((NSError?) -> Void)? = nil) {
//        let callHandle = CXHandle(type: .generic, value: roomName ?? "")
//
//        let callUpdate = CXCallUpdate()
//        callUpdate.remoteHandle = callHandle
//        callUpdate.supportsDTMF = false
//        callUpdate.supportsHolding = false
//        callUpdate.supportsGrouping = false
//        callUpdate.supportsUngrouping = false
//        callUpdate.hasVideo = true
//        self.callUUID = uuid
//        callKitProvider.reportNewIncomingCall(with: uuid, update: callUpdate) { error in
//            if error == nil {
//                //self.configureAudioSession()
//                NSLog("Incoming call successfully reported.")
//                completion?(nil)
//            } else {
//                NSLog("Failed to report incoming call successfully: \(String(describing: error?.localizedDescription)).")
//            }
//            completion?(error as NSError?)
//        }
//    }
//
//    func performEndCallAction(completion: ((NSError?) -> Void)? = nil) {
//        guard let _uuid = self.callUUID else { return }
//        let endCallAction = CXEndCallAction(call: _uuid)
//        let transaction = CXTransaction(action: endCallAction)
//        
//        callKitCallController.request(transaction) { error in
//            
//            if let error = error {
//                NSLog("EndCallAction transaction request failed: \(error.localizedDescription).")
//                completion?(nil)
//                return
//            }
//            completion?(error as NSError?)
//            NSLog("EndCallAction transaction request successful")
//        }
//    }
//
//    func performRoomConnect(uuid: UUID, roomName: String? , completionHandler: @escaping (Bool) -> Swift.Void) {
//        self.callUUID = uuid
//        
//        if (self.notification?.userData.roomType == .UserRoom) {
//            self.moveOnOTOVideoScreen()
//        }else if (self.notification?.userData.roomType == .GroupRoom) {
//            self.moveGroupVideoScreen()
//        }
//        //self.setUpView(uuid: uuid)
//        // Configure access token either from server or manually.
//        // If the default wasn't changed, try fetching from server.
//        /*if (accessToken == "TWILIO_ACCESS_TOKEN") {
//            do {
//                accessToken = try TokenUtils.fetchToken(url: tokenUrl)
//            } catch {
//                let message = "Failed to fetch access token"
//                logMessage(messageText: message)
//                return
//            }
//        }*/
//
//        // Prepare local media which we will share with Room Participants.
//        //self.prepareLocalMedia()
//
//        // Preparing the connect options with the access token that we fetched (or hardcoded).
//        /*let connectOptions = ConnectOptions(token: accessToken) { (builder) in
//
//            // Use the local media that we prepared earlier.
//            builder.audioTracks = self.localAudioTrack != nil ? [self.localAudioTrack!] : [LocalAudioTrack]()
//            builder.videoTracks = self.localVideoTrack != nil ? [self.localVideoTrack!] : [LocalVideoTrack]()
//
//            // Use the preferred audio codec
//            if let preferredAudioCodec = Settings.shared.audioCodec {
//                builder.preferredAudioCodecs = [preferredAudioCodec]
//            }
//            
//            // Use the preferred video codec
//            if let preferredVideoCodec = Settings.shared.videoCodec {
//                builder.preferredVideoCodecs = [preferredVideoCodec]
//            }
//            
//            // Use the preferred encoding parameters
//            if let encodingParameters = Settings.shared.getEncodingParameters() {
//                builder.encodingParameters = encodingParameters
//            }
//
//            // Use the preferred signaling region
//            if let signalingRegion = Settings.shared.signalingRegion {
//                builder.region = signalingRegion
//            }
//
//            // The name of the Room where the Client will attempt to connect to. Please note that if you pass an empty
//            // Room `name`, the Client will create one for you. You can get the name or sid from any connected Room.
//            builder.roomName = roomName
//
//            // The CallKit UUID to assoicate with this Room.
//            builder.uuid = uuid
//        }
//        
//        // Connect to the Room using the options we provided.
//        room = TwilioVideoSDK.connect(options: connectOptions, delegate: self)
//        
//        logMessage(messageText: "Attempting to connect to room \(String(describing: roomName))")
//        
//        //self.showRoomUI(inRoom: true)
//        */
//        self.callKitCompletionHandler = completionHandler
//    }
//}
