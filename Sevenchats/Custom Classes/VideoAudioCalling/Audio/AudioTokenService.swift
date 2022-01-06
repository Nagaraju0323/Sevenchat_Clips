////
////  AudioTokenService.swift
////  Sevenchats
////
////  Created by mac-00020 on 05/11/19.
////  Copyright © 2019 mac-0005. All rights reserved.
////
//
//import Foundation
//import Alamofire
//import TwilioVoice
//import PushKit
//
//class AudioTokenService  : NSObject{
//    
//    static let shared = AudioTokenService()
//    var audioAccessToken = ""
//    
//    var didAudioTokenGenerated : (() -> Void)?
//    var failedToGenerateVoiceToken : (() -> Void)?
//    
//    func callGetAudioTokenAPI(identity : String, isForRegister:Bool = false) {
//        if CUserDefaults.object(forKey: UserDefaultUserID) == nil {
//            return
//        }
//        //..../video-token?identity=User27&room_name=UserRoom26
//        let audioTokenAPI = TwilloBaseURL + APIVoiceToken + "?identity=\(identity)&os=1"
//        print(audioTokenAPI)
//        
//        ServiceManager.callPostApi(audioTokenAPI, methodType: .GET, isLoaderRequired: true, paramters: nil, successModel: SuccessModel.self, failuerModel: FailureModel.self) { [weak self] (model, failuerModel) in
//            guard let self = self else {
//                return
//            }
//            if let token = model?.data?.token {
//                print("Audio Token : " + token)
//                self.audioAccessToken = token
//                if isForRegister{
//                    self.registerTwilioVoice()
//                }else {
//                    self.didAudioTokenGenerated?()
//                }
//                
//                appDelegate.voipRegistry.delegate = nil
//                appDelegate.voipRegistry.delegate = appDelegate
//                appDelegate.voipRegistry.desiredPushTypes = Set([PKPushType.voIP])
//            }else {
//                self.failedToGenerateVoiceToken?()
//            }
//        }
//    }
//    
//    func rejectGroupCallbyCallerAPI(identity : String) {
//       
//        let rejectCallAPI = TwilloBaseURL + APIRejectCallByCaller + "?from=\(identity)"
//        print(rejectCallAPI)
//        
//        ServiceManager.callPostApi(rejectCallAPI, methodType: .GET, isLoaderRequired: true, paramters: nil, successModel: SuccessModel.self, failuerModel: FailureModel.self) { [weak self] (model, failuerModel) in
//            guard let _ = self else {
//                return
//            }
//            print("rejectGroupCallbyCallerAPI : √")
//        }
//    }
//    
//    func rejectGroupCallbyReceiverAPI(identity : String) {
//       
//        let rejectCallAPI = TwilloBaseURL + APIRejectCallByReceiver + "?from=\(identity)&to=\(myAudioIdentity)"
//        print(rejectCallAPI)
//        
//        ServiceManager.callPostApi(rejectCallAPI, methodType: .GET, isLoaderRequired: true, paramters: nil, successModel: SuccessModel.self, failuerModel: FailureModel.self) { [weak self] (model, failuerModel) in
//            guard let _ = self else {
//                return
//            }
//            print("rejectGroupCallbyReceiverAPI : √")
//        }
//    }
//    
//    func completeConferenceRoomAPI(roomName : String) {
//       
//        let rejectCallAPI = TwilloBaseURL + APICompleteConference + "?name=\(roomName)"
//        print(rejectCallAPI)
//        ServiceManager.callPostApi(rejectCallAPI, methodType: .GET, isLoaderRequired: true, paramters: nil, successModel: SuccessModel.self, failuerModel: FailureModel.self) { [weak self] (model, failuerModel) in
//            guard let _ = self else {
//                return
//            }
//            print("completeConferenceRoomAPI : √")
//        }
//    }
//    
//    func registerTwilioVoice() {
//        
//        let token = CUserDefaults.value(forKey: CachedDeviceToken) as? Data
//        guard let cachedDeviceToken = token else {
//            return
//        }
//        
//        //print("pushRegistry Token : " + cachedDeviceToken)
//        
//        TwilioVoice.register(withAccessToken: self.audioAccessToken, deviceToken: cachedDeviceToken) { [weak self] (error) in
//            guard let _ = self else {
//                return
//            }
//            if let error = error {
//                print("An error occurred while registering: \(error.localizedDescription)")
//                self?.failedToGenerateVoiceToken?()
//            } else {
//                print("Successfully registered in TwilioVoice for VoIP push notifications.")
//                self?.didAudioTokenGenerated?()
//            }
//        }
//    }
//    
//    func unregisterTwilioVoice(){
//        
//        let token = CUserDefaults.value(forKey: UserDefaultVoIPNotificationToken) as? String
//        guard let deviceToken = token else {
//            return
//        }
//        
//        guard !self.audioAccessToken.isEmpty else{
//            let audioTokenAPI = TwilloBaseURL + APIVoiceToken + "?identity=\(myAudioIdentity)&os=1"
//            print(audioTokenAPI)
//            
//            ServiceManager.callPostApi(audioTokenAPI, methodType: .GET, isLoaderRequired: true, paramters: nil, successModel: SuccessModel.self, failuerModel: FailureModel.self) { [weak self] (model, failuerModel) in
//                guard let self = self else {
//                    return
//                }
//                if let token = model?.data?.token {
//                    self.audioAccessToken = token
//                    self.unregisterTwilioVoice()
//                }
//            }
//            return
//        }
//        
//    
//        guard let cachedDeviceToken = CUserDefaults.value(forKey: CachedDeviceToken) as? Data else {
//            return
//        }
//        
//        print("pushRegistry Token : " + deviceToken)
//        TwilioVoice.unregister(withAccessToken: self.audioAccessToken, deviceToken: cachedDeviceToken) { [weak self] (error) in
//            guard let _ = self else {
//                return
//            }
//            if let error = error {
//                print("An error occurred while unregister: \(error.localizedDescription)")
//            } else {
//                print("Successfully unregistered in TwilioVoice for VoIP push notifications.")
//            }
//        }
//    }
//}
