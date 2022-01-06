////
////  AudioCallHelper.swift
////  Sevenchats
////
////  Created by mac-00020 on 05/11/19.
////  Copyright © 2019 mac-0005. All rights reserved.
////
//
//import Foundation
//import AVFoundation
//import Alamofire
//import TwilioVoice
//import CallKit
//import PushKit
//
//class AudioCallHelper  : NSObject{
//    
//    var audioCall : AudioCall!
//    
//    var voipRegistry: PKPushRegistry?
//    var incomingPushCompletionCallback: (()->Swift.Void?)? = nil
//    var callInvite: TVOCallInvite?
//    var call: TVOCall?
//    var audioDevice: TVODefaultAudioDevice? = TVODefaultAudioDevice()
//    var callKitProvider: CXProvider? = nil
//    var callKitCallController: CXCallController? = nil
//    var userInitiatedDisconnect: Bool = false
//    var payload : PKPushPayload?
//    
//    var endCallFromReceiver : (() -> Void)?
//    var callDidDisconnected : (() -> Void)?
//    var didGetToken : (() -> Void)?
//    var didConnected : (() -> Void)?
//    var didStartRinging : (() -> Void)?
//    var didUpdateIsSpeakerphoneEnabled : ((Bool) -> Void)?
//    var didUpdateMuteStatus : ((Bool) -> Void)?
//    
//    //var strFullName = ""
//    var receiveCallUUID :UUID?
//    
//    weak var incomeAudioCall : IncomeAudioCallVC?
//    
//    fileprivate var callKitCompletionCallback: ((Bool)->Swift.Void?)? = nil
//    var avAudioSession: AVAudioSession {
//        return AVAudioSession.sharedInstance()
//    }
//    
//    private(set) var isSpeakerphoneEnabled: Bool = false {
//        didSet {
//            self.didUpdateIsSpeakerphoneEnabled?(isSpeakerphoneEnabled)
//        }
//    }
//    
//    override init() {
//        super.init()
//    }
//    
//    convenience init(audio : AudioCall, payload : PKPushPayload? = nil) {
//        self.init()
//        self.payload = payload
//        self.audioCall = audio
//        
//        if let _audioDevice = self.audioDevice{
//            TwilioVoice.audioDevice = _audioDevice
//        }
//        
//        let configuration = CXProviderConfiguration(localizedName: "")
//        configuration.maximumCallGroups = 1
//        configuration.maximumCallsPerCallGroup = 1
//        /*if let callKitIcon = UIImage(named: "") {
//            configuration.iconTemplateImageData = callKitIcon.pngData()
//        }*/
//        callKitProvider = CXProvider(configuration: configuration)
//        callKitCallController = CXCallController()
//        
//        callKitProvider?.setDelegate(self, queue: nil)
//        
//        
//        //toggleAudioRoute(toSpeaker: false)
//        UIApplication.shared.isIdleTimerDisabled = true
//        NotificationCenter.default.addObserver(forName: AVAudioSession.routeChangeNotification, object: avAudioSession, queue: nil) { [weak self] _ in
//            //assert(!Thread.isMainThread)
//            guard let _ = self else { return }
//            DispatchQueue.main.async {
//                self?.updateIsSpeakerphoneEnabled()
//            }
//        }
//        
//        /// Disable speaker mode
//        //self.toggleAudioRoute(isEnable: false)
//    }
//    
//    deinit {
//        self.removeNotification()
//        print("### deinit -> AudioCallHelper")
//    }
//    
//    func setUpView() {
//        
//        if self.audioCall.isSender {
//            audioTokenRegister()
//        }else {
//            self.receiveAudioCallNotification()
//        }
//    }
//    
//    func removeNotification() {
//        
//        // CallKit has an odd API contract where the developer must call invalidate or the CXProvider is leaked.
//        callKitProvider?.invalidate()
//        
//        NotificationCenter.default.removeObserver(self)
//    }
//    
//    private func updateIsSpeakerphoneEnabled() {
//        let value = avAudioSession.currentRoute.outputs.contains { [weak self] (portDescription: AVAudioSessionPortDescription) -> Bool in
//            guard let _ = self else { return false}
//            return portDescription.portType == .builtInSpeaker
//        }
//        DispatchQueue.main.async {
//            print("updateIsSpeakerphoneEnabled : \(value)")
//            self.isSpeakerphoneEnabled = value
//        }
//    }
//    
//    func receiveAudioCallNotification(){
//        guard let _payload = self.payload else { return }
//        TwilioVoice.handleNotification(_payload.dictionaryPayload, delegate: self, delegateQueue: DispatchQueue.main)
//    }
//    
//    func audioTokenRegister(){
//        
//        /// Get audio token from the server and then setup CallKit to perform audio call
//        AudioTokenService.shared.callGetAudioTokenAPI(identity: self.audioCall.identity, isForRegister: false)
//        AudioTokenService.shared.didAudioTokenGenerated = { [weak self] in
//            guard let self = self else { return }
//            if self.audioCall.isSender {
//                self.didGetToken?()
//                self.makeCall()
//            }
//        }
//        
//        AudioTokenService.shared.failedToGenerateVoiceToken = { [weak self] in
//            guard let self = self else { return }
//            self.endCall()
//        }
//    }
//    
//    func checkRecordPermission(completion: @escaping (_ permissionGranted: Bool) -> Void) {
//        let permissionStatus: AVAudioSession.RecordPermission = AVAudioSession.sharedInstance().recordPermission
//        
//        switch permissionStatus {
//        case AVAudioSession.RecordPermission.granted:
//            // Record permission already granted.
//            completion(true)
//            break
//        case AVAudioSession.RecordPermission.denied:
//            // Record permission denied.
//            completion(false)
//            break
//        case AVAudioSession.RecordPermission.undetermined:
//            // Requesting record permission.
//            // Optional: pop up app dialog to let the users know if they want to request.
//            AVAudioSession.sharedInstance().requestRecordPermission({ (granted) in
//                completion(granted)
//            })
//            break
//        default:
//            completion(false)
//            break
//        }
//    }
//    
//    /// Enable/Disable phone speacker
//    /// - Parameter isEnable: true or false
//    func toggleAudioRoute(isEnable : Bool) {
//        
//        audioDevice?.block = { [weak self] in
//            guard let self = self else { return }
//            kTVODefaultAVAudioSessionConfigurationBlock()
//            do {
//                if (isEnable) {
//                    print("AVAudioSession -> .None")
//                    try self.avAudioSession.overrideOutputAudioPort(.speaker)
//                } else {
//                    print("AVAudioSession -> .speaker")
//                    try self.avAudioSession.overrideOutputAudioPort(.none)
//                }
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
//        audioDevice?.block()
//    }
//    
//    /// This method is called after on accept audio call
//    fileprivate func moveToIncomingAudioCallScreen() {
//        
//        appDelegate.sideMenuController.rootViewController = UINavigationController.init(rootViewController: CStoryboardHome.instantiateViewController(withIdentifier: "HomeViewController"))
//        appDelegate.hideSidemenu()
//        let viewController = appDelegate.getTopMostViewController()
//        if let incomingCall = CStoryboardAudioVideo.instantiateViewController(withIdentifier: "IncomeAudioCallVC") as? IncomeAudioCallVC {
//            self.incomeAudioCall = incomingCall
//            self.incomeAudioCall?.roomType = self.audioCall.roomType
//            self.incomeAudioCall?.fullName = self.audioCall.fullName
//            self.incomeAudioCall?.userImage = self.audioCall.image
//            self.incomeAudioCall?.mobile = self.audioCall.mobile
//            self.incomeAudioCall?.countryCode = self.audioCall.countryCode
//            //self.incomeAudioCall?.isMuteCall = self.call?.isMuted ?? false
//            if #available(iOS 13.0, *){
//                incomingCall.isModalInPresentation = true
//                incomingCall.modalPresentationStyle = .fullScreen
//            }
//            viewController.present(incomingCall, animated: true, completion: nil)
//        }
//    }
//}
//
////MARK: Perform Voice Call
//extension AudioCallHelper  {
//    
//    func endCall(){
//        
//        if let call = self.call, call.state == .connected || self.audioCall.roomType == .GroupRoom {
//            AudioTokenService.shared.rejectGroupCallbyCallerAPI(identity: self.audioCall.identity)
//        }
//        
//        if (self.call != nil && self.call?.state != .disconnected) {
//            self.userInitiatedDisconnect = true
//            self.performEndCallAction(uuid: self.call!.uuid)
//        }else {
//            self.callDidDisconnected?()
//        }
//        
//        // The Client is no longer in a conference, allow the Participant's device to idle.
//        UIApplication.shared.isIdleTimerDisabled = false
//    }
//    
//    /// For Caller
//    func makeCall() {
//        
//        let uuid = UUID()
//        self.performStartCallAction(uuid: uuid)
//    }
//    
//    func performVoiceCall(uuid: UUID, client: String?, completionHandler: @escaping (Bool) -> Swift.Void) {
//        
//        let voiceToken = AudioTokenService.shared.audioAccessToken
//        var params : [String:String] = [:]
//        
//        if self.audioCall.roomType == .UserRoom{
//            
//            // One to one audio call
//            params = [
//                "To" : self.audioCall.toIdentity,
//                "From": self.audioCall.identity,
//                "name" : "",
//                "channel_type" : "1To1",
//                "mobile" : appDelegate.loginUser?.mobile ?? "",
//                "country_code" : appDelegate.loginUser?.country_code ?? "",
//                "channel_name" : (appDelegate.loginUser?.first_name ?? "") + " " + (appDelegate.loginUser?.last_name ?? ""),
//                "channel_image" : appDelegate.loginUser?.profile_img ?? ""
//            ]
//
//        }else {
//
//            // Conference audio call
//            params = [
//                "To" : self.audioCall.toIdentity,
//                "From": self.audioCall.identity,
//                "name" : self.audioCall.identity,
//                "channel_type" : "Group",
//                "channel_name" : self.audioCall.fullName,
//                "channel_image" : self.audioCall.image
//            ]
//        }
//        
//        print("Make-Call : \(params.json)")
//        
//        let connectOptions: TVOConnectOptions = TVOConnectOptions(accessToken: voiceToken) { [weak self] (builder) in
//            guard let _ = self else { return }
//            builder.params = params
//            builder.uuid = uuid
//        }
//        
//        call = TwilioVoice.connect(with: connectOptions, delegate: self)
//        
//        self.callKitCompletionCallback = completionHandler
//    }
//    
//    func performAnswerVoiceCall(uuid: UUID, completionHandler: @escaping (Bool) -> Swift.Void) {
//        let acceptOptions: TVOAcceptOptions = TVOAcceptOptions(callInvite: self.callInvite!) { [weak self] (builder) in
//            guard let self = self else { return }
//            builder.uuid = self.callInvite?.uuid
//        }
//        call = self.callInvite?.accept(with: acceptOptions, delegate: self)
//        self.callInvite = nil
//        self.callKitCompletionCallback = completionHandler
//        
//        self.moveToIncomingAudioCallScreen()
//    }
//    
//    func performEndCallAction(uuid: UUID) {
//        
//        // The Client is no longer in a conference, allow the Participant's device to idle.
//        UIApplication.shared.isIdleTimerDisabled = false
//        
//        self.disconnectORRejectCall()
//        if !self.audioCall.isSender {
//             AudioTokenService.shared.rejectGroupCallbyReceiverAPI(identity: self.audioCall.toIdentity)
//        }
//        let endCallAction = CXEndCallAction(call: uuid)
//        let transaction = CXTransaction(action: endCallAction)
//        
//        callKitCallController?.request(transaction) { [weak self] error in
//            guard let _ = self else { return }
//            
//            if let error = error {
//                print("EndCallAction transaction request failed: \(error.localizedDescription).")
//            } else {
//                self?.endCallFromReceiver?()
//                print("EndCallAction transaction request successful")
//            }
//            self?.callDisconnected()
//        }
//    }
//    
//    func performMuteCallAction() {
//        
//        guard let uuid = self.receiveCallUUID else { return }
//        let isMute = self.call?.isMuted ?? false
//        let muteCallAction = CXSetMutedCallAction(call: uuid, muted: isMute)
//        let transaction = CXTransaction(action: muteCallAction)
//        
//        callKitCallController?.request(transaction) { [weak self] error in
//            guard let _ = self else { return }
//            if let error = error {
//                print("CXSetMutedCallAction transaction request failed: \(error.localizedDescription).")
//            } else {
//                print("CXSetMutedCallAction transaction request successful")
//                self?.didUpdateMuteStatus?(isMute)
//            }
//        }
//    }
//    
//    func performStartCallAction(uuid: UUID) {
//        var name = ""
//        if self.audioCall.roomType == .UserRoom{
//            name = CCallFrom + " " + self.audioCall.fullName
//        } else {
//            name = CGroupCallFrom + " " + self.audioCall.fullName
//        }
//        let callHandle = CXHandle(type: .generic, value: name)
//        let startCallAction = CXStartCallAction(call: uuid, handle: callHandle)
//        let transaction = CXTransaction(action: startCallAction)
//        /* do{
//            try AVAudioSession.sharedInstance().setActive(true)
//        } catch {
//            print("Speaker error : \(error)")
//        }*/
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            self.callKitCallController?.request(transaction)  { [weak self] error in
//                guard let self = self else { return }
//                if let error = error {
//                    print("StartCallAction transaction request failed: \(error.localizedDescription)")
//                    return
//                }
//                
//                print("StartCallAction transaction request successful")
//                
//                let callUpdate = CXCallUpdate()
//                callUpdate.remoteHandle = callHandle
//                callUpdate.supportsDTMF = true
//                callUpdate.supportsHolding = true
//                callUpdate.supportsGrouping = true
//                callUpdate.supportsUngrouping = false
//                callUpdate.hasVideo = false
//                
//                self.callKitProvider?.reportCall(with: uuid, updated: callUpdate)
//            }
//        }
//    }
//    
//    func reportIncomingCall(uuid: UUID) {
//
//        var name = ""
//        if self.audioCall.roomType == .UserRoom{
//            name = CCallFrom + " " + self.audioCall.fullName
//        } else {
//            name = CGroupCallFrom + " " + self.audioCall.fullName
//        }
//        let callHandle = CXHandle(type: .generic, value: name)
//        let callUpdate = CXCallUpdate()
//        callUpdate.remoteHandle = callHandle
//        callUpdate.supportsDTMF = false
//        callUpdate.supportsHolding = false
//        callUpdate.supportsGrouping = false
//        callUpdate.supportsUngrouping = false
//        callUpdate.hasVideo = false
//       /*do {
//           try AVAudioSession.sharedInstance().setActive(true)
//       } catch {
//           print("Speaker error : \(error)")
//       }*/
//        callKitProvider?.reportNewIncomingCall(with: uuid, update: callUpdate) { [weak self ] error in
//            guard let _ = self else { return }
//            if let error = error {
//                print("Failed to report incoming call successfully: \(error.localizedDescription).")
//            } else {
//                print("Incoming call successfully reported.")
//            }
//        }
//    }
//}
//
////MARK:- TVONotificationDelegate
//extension AudioCallHelper : TVONotificationDelegate {
//    
//    func cancelledCallInviteReceived(_ cancelledCallInvite: TVOCancelledCallInvite, error: Error) {
//        
//        NSLog("cancelledCallInviteCanceled:error:, error: \(error.localizedDescription)")
//        
//        if (self.callInvite == nil ||
//            self.callInvite!.callSid != cancelledCallInvite.callSid) {
//            NSLog("No matching pending CallInvite. Ignoring the Cancelled CallInvite")
//        }
//        
//        performEndCallAction(uuid: self.callInvite!.uuid)
//
//        self.callInvite = nil
//    }
//    
//    func cancelledCallInviteReceived(_ cancelledCallInvite: TVOCancelledCallInvite) {
//        
//        print("cancelledCallInviteCanceled:")
//        
//        if (self.callInvite == nil ||
//            self.callInvite!.callSid != cancelledCallInvite.callSid) {
//            print("No matching pending CallInvite. Ignoring the Cancelled CallInvite")
//            return
//        }
//        
//        performEndCallAction(uuid: self.callInvite!.uuid)
//        
//        self.callInvite = nil
//    }
//    
//    func callInviteReceived(_ callInvite: TVOCallInvite) {
//        
//        print("callInviteReceived:")
//        
//        if (self.callInvite != nil) {
//            print("A CallInvite is already in progress. Ignoring the incoming CallInvite from " + (callInvite.from ?? "N/A"))
//            
//            return;
//        } else if (self.call != nil) {
//            print("Already an active call.");
//            print("  >> Ignoring call from " + (callInvite.from ?? "N/A"))
//            
//            return;
//        }
//        
//        print("Custom Parameter : \(callInvite.customParameters?.json ?? "N/A")")
//        
//        if let parameter = callInvite.customParameters {
//            self.audioCall.roomType = RoomType(rawValue: parameter["channel_type"] ?? "1To1") ?? .UserRoom
//            self.audioCall.image = parameter["channel_image"] ?? ""
//            self.audioCall.fullName = parameter["channel_name"] ?? ""
//            self.audioCall.mobile = parameter["mobile"] ?? ""
//            self.audioCall.countryCode = parameter["country_code"] ?? ""
//    
//        } else {
//            guard let _payload = self.payload else { return }
//            
//            var fromName = _payload.dictionaryPayload["twi_from"] as? String ?? "client:"
//            fromName = fromName.replacingOccurrences(of: "client:", with: "")
//            var arrName = fromName.components(separatedBy: "_")
//            
//            var strName = "unknown"
//            if arrName.count > 1{
//                arrName.remove(at: 0)
//                strName = arrName.joined(separator: " ")
//            }
//            self.audioCall.fullName = strName
//            self.audioCall.roomType = .GroupRoom
//        }
//        
//        
//        receiveCallUUID = callInvite.uuid
//        self.callInvite = callInvite
//        reportIncomingCall(uuid: callInvite.uuid)
//    }
//}
//
////MARK:- TVOCallDelegate
//extension AudioCallHelper : TVOCallDelegate{
//    
//    fileprivate func disconnectORRejectCall(){
//    
//        if (self.callInvite != nil) {
//            print("self.callInvite!.reject()")
//            self.callInvite?.reject()
//            self.callInvite = nil
//        } else if (self.call != nil) {
//            print("self.call?.disconnect()")
//            self.call?.disconnect()
//        }
//    }
//    
//    func callDisconnected() {
//        
//        DispatchQueue.main.async {
//            self.disconnectORRejectCall()
//            self.call = nil
//            self.callKitCompletionCallback = nil
//            self.receiveCallUUID = nil
//            self.userInitiatedDisconnect = false
//            self.callDidDisconnected?()
//            self.audioDevice = nil
//            appDelegate.audioCallHelper = nil
//            
//            self.incomeAudioCall?.dismiss(animated: true, completion: nil)
//        }
//    }
//    
//    func callDidStartRinging(_ call: TVOCall) {
//        print("callDidStartRinging:")
//        self.didStartRinging?()
//    }
//    
//    func callDidConnect(_ call: TVOCall) {
//        print("callDidConnect:")
//        if let complitionBloc = self.callKitCompletionCallback {
//            complitionBloc(true)
//        }
//        self.didConnected?()
//    }
//
//    func call(_ call: TVOCall, isReconnectingWithError error: Error) {
//        print("call:isReconnectingWithError: \(error.localizedDescription)")
//    }
//    
//    func callDidReconnect(_ call: TVOCall) {
//        print("callDidReconnect:")
//    }
//    
//    func call(_ call: TVOCall, didFailToConnectWithError error: Error) {
//        print("didFailToConnectWithError : \(error.localizedDescription)")
//        print("call.uuid : \(call.uuid)")
//        performEndCallAction(uuid: call.uuid)
//    }
//    
//    func call(_ call: TVOCall, didDisconnectWithError error: Error?) {
//       
//        print("didDisconnectWithError : \(error?.localizedDescription ?? "N/A")")
//        
//        if let error = error {
//            NSLog("Call failed: \(error.localizedDescription)")
//        } else {
//            NSLog("Call disconnected")
//        }
//        
//        if !self.userInitiatedDisconnect {
//            var reason = CXCallEndedReason.remoteEnded
//            if error != nil {
//                reason = .failed
//            }
//            if let uuid = self.call?.uuid {
//                self.callKitProvider?.reportCall(with: uuid, endedAt:  Date(), reason: reason)
//            }
//        }
//        
//        callDisconnected()
//    }
//}
//
//// MARK:- CXProviderDelegate
//extension AudioCallHelper : CXProviderDelegate {
//    
//    func providerDidBegin(_ provider: CXProvider) {
//        print("providerDidBegin : provider: CXProvider")
//    }
//    
//    
//    func providerDidReset(_ provider: CXProvider) {
//        print("providerDidReset: provider: CXProvider")
//        audioDevice?.isEnabled = true
//    }
//    
//    func provider(_ provider: CXProvider, didActivate audioSession: AVAudioSession) {
//        print("didActivate audioSession: AVAudioSession")
//        audioDevice?.isEnabled = true
//    }
//    
//    func provider(_ provider: CXProvider, didDeactivate audioSession: AVAudioSession) {
//        print("didDeactivate audioSession: AVAudioSession")
//        /*do {
//            try AVAudioSession.sharedInstance().setActive(true)
//        } catch {
//            print("Speaker error : \(error)")
//        }*/
//    }
//    
//    func provider(_ provider: CXProvider, timedOutPerforming action: CXAction) {
//        print("timedOutPerforming CXAction")
//    }
//    
//    func provider(_ provider: CXProvider, perform action: CXStartCallAction) {
//        
//        print("perform action: CXStartCallAction")
//        audioDevice?.isEnabled = false
//        audioDevice?.block();
//        
//        provider.reportOutgoingCall(with: action.callUUID, startedConnectingAt: nil)
//        
//        self.performVoiceCall(uuid: action.callUUID, client: "") { [weak self] (success) in
//            guard let _ = self else { return }
//            print("provider(_ provider: CXProvider, perform action: CXStartCallAction)")
//            if (success) {
//                provider.reportOutgoingCall(with: action.callUUID, connectedAt: Date())
//                action.fulfill()
//            } else {
//                action.fail()
//            }
//        }
//    }
//    
//    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
//        print("perform action: CXAnswerCallAction")
//        
//        assert(action.callUUID == self.callInvite?.uuid)
//        
//        audioDevice?.isEnabled = true
//        audioDevice?.block();
//        
//        self.performAnswerVoiceCall(uuid: action.callUUID) { [weak self] (success) in
//            
//            guard let _ = self else { return }
//            if (success) {
//                action.fulfill()
//            } else {
//                action.fail()
//            }
//        }
//        
//        action.fulfill()
//    }
//    
//    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
//        
//        print("perform action: CXEndCallAction")
//        
//        if let uuid = self.callInvite?.uuid{
//            self.performEndCallAction(uuid: uuid)
//        } else {
//            self.disconnectORRejectCall()
//        }
//        audioDevice?.isEnabled = true
//        action.fulfill()
//    }
//    
//    func provider(_ provider: CXProvider, perform action: CXSetHeldCallAction) {
//        print("perform action: CXSetHeldCallAction")
//        if (self.call?.state == .connected) {
//            self.call?.isOnHold = action.isOnHold
//            action.fulfill()
//        } else {
//            action.fail()
//        }
//    }
//    
//    func provider(_ provider: CXProvider, perform action: CXSetMutedCallAction) {
//        
//        print("perform action: CXSetMutedCallAction")
//        DispatchQueue.main.async {
//            if (self.call?.state == .connected) {
//                self.call?.isMuted.toggle()
//                action.fulfill()
//                self.didUpdateMuteStatus?(self.call?.isMuted ?? false)
//            } else {
//                action.fail()
//            }
//        }
//    }
//}
