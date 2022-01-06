////
////  TVIHelper.swift
////  Sevenchats
////
////  Created by mac-00020 on 21/10/19.
////  Copyright © 2019 mac-0005. All rights reserved.
////
//
//import Foundation
//import TwilioVideo
//import Alamofire
//import CallKit
//
//let CallingTime = 45 // Seconds
//let RingToneName = "whatsapp"
//let RingToneExt = "caf" // caf // waw
//
//class TVIVideoHelper  : NSObject {
//    
//    //static let shared = TVIHelper()
//    
//    var localVideoTrack: LocalVideoTrack?
//    var localAudioTrack: LocalAudioTrack?
//    //var localDataTrack = LocalDataTrack()
//    
//    var room: Room?
//    var camera: CameraSource?
//    
//    /// Remote users participaint 
//    var arrParticipaint : [AppParticipant] = []
//    
//    /// Logged user participant object
//    var selfParticipant : AppParticipant = AppParticipant()
//    
//    var roomInfo : MDLRoomInfo!
//    var accessToken : String = ""
//    
//    var notification: AudioVideoNotification?
//    
//    var audioDevice: DefaultAudioDevice? = DefaultAudioDevice()
//    
//    // CallKit components
//    var callKitProvider: CXProvider!
//    var callKitCallController: CXCallController!
//    var callKitCompletionHandler: ((Bool)->Swift.Void?)? = nil
//    
//    var didUpdateVideoView : (() -> Void)?
//    var roomDidDisconnected : (() -> Void)?
//    var didConnectedToRom : ((Int) -> Void)?
//    var participantDidConnect : (() -> Void)?
//    var didDisconnectParticlipaint : (() -> Void)?
//    var didFailedToConnectWithRom : (() -> Void)?
//    var didSentRequestForConnect : (() -> Void)?
//    
//    var didMuteCall : ((Bool) -> Void)?
//    var callUUID : UUID?
//    deinit {
//        removeNotification()
//        
//        // We are done with camera
//        if let camera = self.camera {
//            camera.stopCapture()
//            self.camera = nil
//        }
//        print("Deinit -> TVIVideoHelper")
//    }
//    
//    override init() {
//        super.init()
//        
//        let configuration = CXProviderConfiguration(localizedName: "")
//        configuration.maximumCallGroups = 1
//        configuration.maximumCallsPerCallGroup = 1
//        configuration.supportsVideo = true
//        configuration.supportedHandleTypes = [.generic]
//       
//        callKitProvider = CXProvider(configuration: configuration)
//        callKitProvider.setDelegate(self, queue: nil)
//        
//        callKitCallController = CXCallController()
//        if let _audioDevice = self.audioDevice {
//            TwilioVideoSDK.audioDevice = _audioDevice
//        }
//        
//    }
//    
//    convenience init(roomInfo : MDLRoomInfo) {
//        self.init()
//        self.roomInfo = roomInfo
//    }
//    
//    func setUpView() {
//        self.startPreview()
//        self.getOneToOneVideoCallToken()
//    }
//    
//    func removeNotification() {
//        
//        // CallKit has an odd API contract where the developer must call invalidate or the CXProvider is leaked.
//        callKitProvider.invalidate()
//        
//        NotificationCenter.default.removeObserver(self)
//    }
//    
//    fileprivate func prepareLocalMedia() {
//        // We will share local audio and video when we connect to the Room.
//        // Create an audio track.
//        
//        if (localAudioTrack == nil) {
//            localAudioTrack = LocalAudioTrack()
//            //LocalAudioTrack.init(options: nil, enabled: true, name: "Microphone")
//            
//            if (localAudioTrack == nil) {
//                print("Failed to create audio track")
//            }
//        }
//    }
//    
//    fileprivate func startPreview() {
//        if PlatformUtils.isSimulator {
//            return
//        }
//        
//        self.camera = CameraSource(delegate: self)
//        self.localVideoTrack = LocalVideoTrack.init(source: self.camera!, enabled: true, name: "Camera")
//    }
//    
//    func connectToVideoCallingRoom() {
//        
//        // Prepare local media which we will share with Room Participants.
//        self.prepareLocalMedia()
//        
//        if self.accessToken.isEmpty { return }
//        
//        // Preparing the connect options with the access token that we fetched (or hardcoded).
//        let connectOptions = ConnectOptions(token: self.accessToken) { (builder) in
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
//            /*if let dataTrack = self.localDataTrack {
//                builder.dataTracks = [ dataTrack ]
//            }*/
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
//            builder.roomName = self.roomInfo.info.roomName
//
//            // The CallKit UUID to assoicate with this Room.
//            builder.uuid = self.callUUID
//            
//            // Sometimes a Participant might not interact with their device for a long time in a conference.
//            UIApplication.shared.isIdleTimerDisabled = true
//        }
//        
//        // Connect to the Room using the options we provided.
//        self.room = TwilioVideoSDK.connect(options: connectOptions, delegate: self)
//        
//    }
//    
//    func flipCamera(){
//        
//        var cameraPosition = AVCaptureDevice.Position.front
//        if self.camera?.device?.position == AVCaptureDevice.Position.front {
//            cameraPosition = .back
//        }
//        guard let frontOrBackCamera = CameraSource.captureDevice(position: cameraPosition ) else {
//            return
//        }
//        self.camera?.startCapture(device: frontOrBackCamera)
//    }
//    
//    func sendFakeAudioInterruptionNotificationToStartAudioResources() {
//        var userInfo = Dictionary<AnyHashable, Any>()
//        let interrupttioEndedRaw = AVAudioSession.InterruptionType.ended.rawValue
//        userInfo[AVAudioSessionInterruptionTypeKey] = interrupttioEndedRaw
//        NotificationCenter.default.post(name: AVAudioSession.interruptionNotification, object: self, userInfo: userInfo)
//    }
//}
//
////MARK: - Add/Delete Participant
//extension TVIVideoHelper {
//    
//    func disconnectRoom(){
//        
//        // The Client is no longer in a conference, allow the Participant's device to idle.
//        UIApplication.shared.isIdleTimerDisabled = false
//        self.performEndCallAction()
//        self.room?.disconnect()
//        self.roomDidDisconnected?()
//    }
//    
//    func addParticipant( participant : RemoteParticipant){
//        let arrTmp = self.arrParticipaint.filter({$0.remoteParticipant.identity == participant.identity})
//        if arrTmp.isEmpty{
//            let obj = AppParticipant()
//            obj.identity = participant.identity
//            obj.remoteParticipant = participant
//            self.arrParticipaint.append(obj)
//            participant.delegate = self
//            self.didUpdateVideoView?()
//        }
//    }
//    
//    func removeParticipant(identity : String) {
//        self.arrParticipaint = self.arrParticipaint.filter({$0.remoteParticipant.identity != identity})
//        
//        if self.arrParticipaint.isEmpty {
//            self.disconnectRoom()
//            self.didUpdateVideoView?()
//        }
//    }
//    
//    func addRenderView(videoTrack: RemoteVideoTrack, identity:String){
//        let vwRemote = VideoView.init(frame: CGRect.zero, delegate:self)
//        if  vwRemote != nil, let obj = getParticipantFromIdentity(identity: identity) {
//            obj.remoteView = vwRemote
//            videoTrack.addRenderer(vwRemote!)
//            self.didUpdateVideoView?()
//        }
//    }
//    
//    func getParticipantFromIdentity(identity : String) -> AppParticipant?{
//        let arrTmp = self.arrParticipaint.filter({$0.identity == identity})
//        return arrTmp.first
//    }
//}
//
////MARK: - RoomDelegate
//extension TVIVideoHelper : RoomDelegate {
//    
//    func roomDidConnect(room: Room) {
//        
//        
//        self.room = room
//        for participant in room.remoteParticipants {
//            self.addParticipant(participant: participant)
//        }
//                
//        // Stop the audio unit by setting isEnabled to `false`.
//        self.audioDevice?.isEnabled = true;
//
//        // Configure the AVAudioSession by executign the audio device's `block`.
//        self.audioDevice?.block()
//        logMessage(messageText: "Did Connect to Room")
//        self.callKitCompletionHandler?(true)
//        
//        self.didConnectedToRom?(room.remoteParticipants.count)
//    }
//    
//    func participantDidConnect(room: Room, participant: RemoteParticipant) {
//        self.addParticipant(participant: participant)
//        self.participantDidConnect?()
//        logMessage(messageText: "Participant \(participant.identity) connected with \(participant.remoteAudioTracks.count) audio and \(participant.remoteVideoTracks.count) video tracks")
//    }
//    
//    func participantDidDisconnect(room: Room, participant: RemoteParticipant) {
//        
//        self.removeParticipant(identity: participant.identity)
//        self.didDisconnectParticlipaint?()
//        /*
//         self.setupRemoteVideoView()
//        */
//    }
//    
//    func roomDidDisconnect(room: Room, error: Error?) {
//        
//        logMessage(messageText: "Disconnected from room \(room.name), error = \(String(describing: error))")
//        self.room = nil
//        self.callKitCompletionHandler = nil
//
//        //self.showRoomUI(inRoom: false)
//    }
//    
//    func roomDidFailToConnect(room: Room, error: Error) {
//        self.audioDevice?.isEnabled = false
//        self.didFailedToConnectWithRom?()
//        logMessage(messageText: "Failed to connect to room with error : \(error.localizedDescription)")
//        self.room = nil
//        self.callKitCompletionHandler?(false)
//        //self.showRoomUI(inRoom: false)
//    }
//    
//    func roomIsReconnecting(room: Room, error: Error) {
//        logMessage(messageText: "Reconnecting to room \(room.name), error = \(String(describing: error))")
//    }
//    func roomDidReconnect(room: Room) {
//        
//    }
//}
//
////MARK:- RemoteParticipantDelegate
//extension TVIVideoHelper : RemoteParticipantDelegate {
//
//    func didSubscribeToVideoTrack(videoTrack: RemoteVideoTrack, publication: RemoteVideoTrackPublication, participant: RemoteParticipant) {
//        self.selfParticipant.remoteParticipant = participant
//        if let vwRemote = VideoView.init(frame: CGRect.zero, delegate:self){
//            self.selfParticipant.remoteView = vwRemote
//            videoTrack.addRenderer(vwRemote)
//        }
//        
//        self.didUpdateVideoView?()
//        
//        self.addRenderView(videoTrack: videoTrack, identity: participant.identity)
//        logMessage(messageText: "Subscribed to \(publication.trackName) video track for Participant \(participant.identity)")
//    }
//    
//    func didUnsubscribeFromVideoTrack(videoTrack: RemoteVideoTrack, publication: RemoteVideoTrackPublication, participant: RemoteParticipant) {
//        self.removeParticipant(identity: participant.identity)
//    }
//    
//}
//
////MARK:- VideoViewDelegate
//extension TVIVideoHelper : VideoViewDelegate {
//    func videoViewOrientationDidChange(view: VideoView, dimensions orientation: VideoOrientation) {
//        
//    }
//}
//
////MARK:- Extra Delegate Methods For RemoteParticipantDelegate
//extension TVIVideoHelper {
//    
//    func remoteParticipantDidPublishVideoTrack(participant: RemoteParticipant, publication: RemoteVideoTrackPublication) {
//        // Remote Participant has offered to share the video Track.
//        logMessage(messageText: "Participant \(participant.identity) published \(publication.trackName) video track")
//    }
//    
//    func remoteParticipantDidUnpublishVideoTrack(participant: RemoteParticipant, publication: RemoteVideoTrackPublication) {
//        // Remote Participant has stopped sharing the video Track.
//        logMessage(messageText: "Participant \(participant.identity) unpublished \(publication.trackName) video track")
//    }
//    func remoteParticipantDidPublishAudioTrack(participant: RemoteParticipant, publication: RemoteAudioTrackPublication) {
//        // Remote Participant has offered to share the audio Track.
//        logMessage(messageText: "Participant \(participant.identity) published \(publication.trackName) audio track")
//    }
//    
//    func remoteParticipantDidUnpublishAudioTrack(participant: RemoteParticipant, publication: RemoteAudioTrackPublication) {
//        // Remote Participant has stopped sharing the audio Track.
//        
//        logMessage(messageText: "❌❌❌ Participant \(participant.identity) unpublished \(publication.trackName) audio track")
//    }
//    
//    func didSubscribeToAudioTrack(audioTrack: RemoteAudioTrack, publication: RemoteAudioTrackPublication, participant: RemoteParticipant) {
//        print("audioTrack.isEnabled -> \(audioTrack.isEnabled)")
//        logMessage(messageText: "Subscribed to \(publication.trackName) audio track for Participant \(participant.identity)")
//    }
//    
//    func didUnsubscribeFromAudioTrack(audioTrack: RemoteAudioTrack, publication: RemoteAudioTrackPublication, participant: RemoteParticipant) {
//        // We are unsubscribed from the remote Participant's audio Track. We will no longer receive the
//        // remote Participant's audio.
//        logMessage(messageText: "❌❌❌ Unsubscribed from \(publication.trackName) audio track for Participant \(participant.identity)")
//    }
//    
//    func remoteParticipantDidEnableVideoTrack(participant: RemoteParticipant, publication: RemoteVideoTrackPublication) {
//        logMessage(messageText: "Participant \(participant.identity) enabled \(publication.trackName) video track")
//    }
//    
//    func remoteParticipantDidDisableVideoTrack(participant: RemoteParticipant, publication: RemoteVideoTrackPublication) {
//        logMessage(messageText: "Participant \(participant.identity) disabled \(publication.trackName) video track")
//    }
//    
//    func remoteParticipantDidEnableAudioTrack(participant: RemoteParticipant, publication: RemoteAudioTrackPublication) {
//        logMessage(messageText: "Participant \(participant.identity) enabled \(publication.trackName) audio track")
//        self.didUpdateVideoView?()
//    }
//    
//    func remoteParticipantDidDisableAudioTrack(participant: RemoteParticipant, publication: RemoteAudioTrackPublication) {
//        logMessage(messageText: "Participant \(participant.identity) disabled \(publication.trackName) audio track")
//        self.didUpdateVideoView?()
//    }
//    func didFailToSubscribeToAudioTrack(publication: RemoteAudioTrackPublication, error: Error, participant: RemoteParticipant) {
//        logMessage(messageText: "❌❌❌ FailedToSubscribe \(publication.trackName) audio track, error = \(String(describing: error))")
//    }
//    func didFailToSubscribeToVideoTrack(publication: RemoteVideoTrackPublication, error: Error, participant: RemoteParticipant) {
//        logMessage(messageText: "❌❌❌ FailedToSubscribe \(publication.trackName) video track, error = \(String(describing: error))")
//    }
//    
//}
//
//// MARK: CameraSourceDelegate
//extension TVIVideoHelper : CameraSourceDelegate {
//    func cameraSourceDidFail(source: CameraSource, error: Error) {
//        logMessage(messageText: "Camera source failed with error: \(error.localizedDescription)")
//    }
//}
//
////MARK:- API CALLING FUNCTIONS
//extension TVIVideoHelper {
//    
//    /// Get video call token from server.
//    func getOneToOneVideoCallToken() {
//        
//        let roomName = self.roomInfo.info.roomName
//        let myIdentity = self.roomInfo.myIdentity
//        
//        //let roomName = self.roomInfo.roomName
//        let bcakendTokenUrlEndPoint = APIVideoToken + "?identity=\(myIdentity)&room_name=\(roomName)"
//        let finalUrl = TwilloBaseURL + bcakendTokenUrlEndPoint
//        
//        ServiceManager.callPostApi(finalUrl, methodType: .GET, isLoaderRequired: false, paramters: nil, successModel: SuccessModel.self, failuerModel: FailureModel.self) { [weak self] (model, failuerModel) in
//            guard let _ = self else {return}
//            if let token = model?.data?.token {
//                self?.accessToken = token
//                self?.connectToVideoCallingRoom()
//            }
//        }
//    }
//    
//    /// Send custom notification to reciver
//    /// Send request to reciever for accept/reject call
//    func requestForPushToConnectWithFriend() {
//        print(appDelegate.loginUser?.country_code ?? "")
//        print(appDelegate.loginUser?.mobile ?? "")
//        
//        if self.roomInfo.info.roomType == .UserRoom { // One to One video call
//            
//            let senderId = Int(appDelegate.loginUser?.user_id ?? 0).description
//            let receiverId = self.roomInfo.info.id.description
//            let notification_id = "123"
//            let myIdentity = self.roomInfo.myIdentity
//            let receiverIdentity = (self.roomInfo.info as! UserRoom).identity
//            let roomName = self.roomInfo.info.roomName
//            let notificationType = CallNotificationType.VideoNotification.rawValue
//            let countryCode = appDelegate.loginUser?.country_code ?? ""
//            let mobile = appDelegate.loginUser?.mobile ?? ""
//            
//            let finalUrl = TwilloBaseURL + APICustomeNotification
//            let bodyParm : [String : Any] = [
//                "identity" : receiverIdentity,
//                "room_name" : roomName,
//                "from_identity" :myIdentity,
//                "notification_id" : notification_id,
//                "notification_type" : notificationType,
//                "user_data" : [
//                    "sender_id" : senderId,
//                    "receiver_id" : receiverId,
//                    "channel_type" : "1To1", // (1To1 || Group)
//                    "fullName" : ((appDelegate.loginUser?.first_name ?? "") + " " + (appDelegate.loginUser?.last_name ?? "")),
//                    "userImage" : self.roomInfo.info.image,
//                    "country_code" : countryCode,
//                    "mobile" : mobile,
//                    "callerUserImage" : (appDelegate.loginUser?.profile_img ?? "" )
//                ].json
//            ]
//            
//            print(finalUrl)
//            print(bodyParm)
//            
//            ServiceManager.callPostApi(finalUrl, methodType: .POST, isLoaderRequired: false, paramters: bodyParm , encoding: URLEncoding.queryString, successModel: SuccessModel.self, failuerModel: FailureModel.self) { [weak self] (model, failuerModel) in
//                guard let self = self else { return }
//                print(model?.meta?.code ?? -5000)
//                if let code = model?.meta?.code, code == 0 {
//                    self.didSentRequestForConnect?()
//                }
//            }
//            
//        } else {  // Group video call
//            
//            let senderId = (appDelegate.loginUser?.user_id ?? 0).description
//            let receiverId = self.roomInfo.info.id
//            let notification_id = "123"
//            let myIdentity = self.roomInfo.myIdentity
//            let receiverIdentity = (self.roomInfo.info as! GroupRoom).memberIdentity
//            let roomName = self.roomInfo.info.roomName
//            let notificationType = CallNotificationType.VideoNotification.rawValue
//            
//            var members = (self.roomInfo.info as! GroupRoom).memberId
//            members.append((Int(appDelegate.loginUser?.user_id ?? 0)))
//            let memberIds = members.map({$0.description}).joined(separator: ",")
//            
//            let finalUrl = TwilloBaseURL + APICustomeNotification
//            print(finalUrl)
//            let bodyParm : [String : Any] = [
//                "identity" : receiverIdentity,
//                "room_name" : roomName,
//                "from_identity" :myIdentity,
//                "notification_id" : notification_id,
//                "notification_type" : notificationType,
//                "user_data" : [
//                    "sender_id" : senderId,
//                    "receiver_id" : receiverId,
//                    "channel_type" : "Group", // (1To1 || Group)
//                    "fullName" : self.roomInfo.info.fullName,
//                    "groupName" : self.roomInfo.info.groupName,
//                    "userImage" : self.roomInfo.info.image,
//                    "callerUserImage" : appDelegate.loginUser?.profile_img ?? "",
//                    "memberIds" : memberIds
//                ].json
//            ]
//            print(bodyParm)
//            ServiceManager.callPostApi(finalUrl, methodType: .POST, isLoaderRequired: false, paramters: bodyParm, encoding: URLEncoding.queryString, successModel: SuccessModel.self, failuerModel: FailureModel.self) { [weak self] (model, failuerModel) in
//                guard let self = self else { return }
//                print(model?.meta?.code ?? -5000)
//                if let code = model?.meta?.code, code == 0 {
//                    self.didSentRequestForConnect?()
//                }
//            }
//        }
//    }
//    
//    func disconnectGroupCall(isDisconnectAllMenber:Bool) {
//        
//        let myId = (appDelegate.loginUser?.user_id ?? 0).description
//        var members = (self.roomInfo.info as! GroupRoom).memberId.map({$0.description})
//        
//        /// Remove user id of logged user from the `memberIds` parameter.
//        /// From the receiver side, thay will check If there no more member in this parameter then the group will be disconnect.
//        members.remove(object: myId)
//        
//        let senderId = self.roomInfo.info.id
//        let receiverId = "0"
//        let notification_id = "123"
//        let myIdentity = self.roomInfo.myIdentity
//        let receiverIdentity = (self.roomInfo.info as! GroupRoom).memberIdentity
//        let roomName = self.roomInfo.info.roomName
//        let notificationType = CallNotificationType.RejectGroupVideoNotification.rawValue
//        
//        var memberIds : String = "0"
//        
//        /// Remove logged user id and then pass existing user id to all member.
//        if !isDisconnectAllMenber {
//            memberIds = members.map({$0.description}).joined(separator: ",")
//        }
//        
//        
//        let finalUrl = TwilloBaseURL + APICustomeNotification
//        print(finalUrl)
//        let bodyParm : [String : Any] = [
//            "identity" : receiverIdentity,
//            "room_name" : roomName,
//            "from_identity" :myIdentity,
//            "notification_id" : notification_id,
//            "notification_type" : notificationType,
//            "user_data" : [
//                "sender_id" : senderId,
//                "receiver_id" : receiverId,
//                "channel_type" : "Group", // (1To1 || Group)
//                "fullName" : self.roomInfo.info.fullName,
//                "userImage" : self.roomInfo.info.image,
//                "memberIds" : memberIds /// All members user id who are connect with this group
//            ].json
//        ]
//        print(bodyParm)
//        ServiceManager.callPostApi(finalUrl, methodType: .POST, isLoaderRequired: false, paramters: bodyParm, encoding: URLEncoding.queryString, successModel: SuccessModel.self, failuerModel: FailureModel.self) { [weak self] (model, failuerModel) in
//            guard let self = self else { return }
//            print(model?.meta?.code ?? -5000)
//            if let code = model?.meta?.code, code == 0 {
//                self.didSentRequestForConnect?()
//            }
//        }
//    }
//    
//    func disconnectCallAPI() {
//        
//        if self.roomInfo.info.roomType == .UserRoom {
//            if self.arrParticipaint.isEmpty {
//                TVITokenService.shared.disconnectCallAPI(
//                    receiverIdentity: (self.roomInfo.info as! UserRoom).identity
//                )
//            }
//        }else{
//            if roomInfo.isSender {
//                if self.arrParticipaint.isEmpty{
//                    self.disconnectGroupCall(isDisconnectAllMenber: true)
//                }else {
//                    self.disconnectGroupCall(isDisconnectAllMenber: false)
//                }
//            }
//        }
//        self.disconnectRoom()
//    }
//}
//
//
//extension NSObject {
//    func logMessage(messageText: String) {
//        print(messageText)
//    }
//}
