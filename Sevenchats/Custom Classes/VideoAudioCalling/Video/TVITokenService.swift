////
////  TVITokenService.swift
////  Sevenchats
////
////  Created by mac-00020 on 23/10/19.
////  Copyright © 2019 mac-0005. All rights reserved.
////
//
//import Foundation
//import Alamofire
//
//class TVITokenService  : NSObject{
//    
//    static let shared = TVITokenService()
//    var videoAccessToken = ""
//    
//    func bindVoIPToken() {
//        if CUserDefaults.object(forKey: UserDefaultUserID) == nil {
//            return
//        }
//        //let token = CUserDefaults.value(forKey: UserDefaultNotificationToken) as? String
//        let token = CUserDefaults.value(forKey: UserDefaultVoIPNotificationToken) as? String
//        guard let address = token else {
//            return
//        }
//        let userId = appDelegate.loginUser?.user_id ?? 0
//        if userId == 0 {
//            return
//        }
//        /*let userName = (appDelegate.loginUser?.first_name ?? "") + "_" +  (appDelegate.loginUser?.last_name ?? "")
//        let identity = (appDelegate.loginUser?.user_id ?? 0).description + "_" + userName
//        */
//        let identity = "User" + (appDelegate.loginUser?.user_id ?? 0).description
//        
//        let bcakendUserBindingUrlToGetPush = APIBinding + "?identity=\(identity)&address=\(address)&type=apn&push_type=0"
//        let finalUrl = TwilloBaseURL + bcakendUserBindingUrlToGetPush
//        
//        ServiceManager.callPostApi(finalUrl, methodType: .GET, isLoaderRequired: true, paramters: nil, successModel: BindingSucess.self, failuerModel: FailureModel.self) { [weak self] (model, failuerModel) in
//            guard let _ = self else {return}
//            if let code = model?.meta?.code, code == 0 {
//                DispatchQueue.main.async {
//                    let bindingId = model?.data?.bindingId ?? ""
//                    UserDefaults.standard.setValue(bindingId, forKey: CBindingId)
//                    UserDefaults.standard.synchronize()
//                    self?.bindAPNSToken()
//                }
//                print("SuccessFully Registered & Bind For Voip Push")
//            } else {
//                print("binding?identity : Failed")
//            }
//        }
//    }
//    
//    func bindAPNSToken() {
//        let token = CUserDefaults.value(forKey: UserDefaultAPNsPNotificationToken) as? String
//        guard let address = token else {
//            return
//        }
//        let userId = appDelegate.loginUser?.user_id ?? 0
//        if userId == 0 {
//            return
//        }
//        let identity = "User" + (appDelegate.loginUser?.user_id ?? 0).description
//        
//        let bcakendUserBindingUrlToGetPush = APIBinding + "?identity=\(identity)&address=\(address)&type=apn&push_type=1"
//        let finalUrl = TwilloBaseURL + bcakendUserBindingUrlToGetPush
//        
//        ServiceManager.callPostApi(finalUrl, methodType: .GET, isLoaderRequired: true, paramters: nil, successModel: BindingSucess.self, failuerModel: FailureModel.self) { [weak self] (model, failuerModel) in
//            guard let _ = self else {return}
//            if let code = model?.meta?.code, code == 0 {
//                DispatchQueue.main.async {
//                    let bindingId = model?.data?.bindingId ?? ""
//                    UserDefaults.standard.setValue(bindingId, forKey: CBindingId)
//                    UserDefaults.standard.synchronize()
//                }
//                print("SuccessFully binding bindAPNSToken")
//            }else{
//                print("API -> bindAPNSToken : Failed")
//            }
//        }
//    }
//    func deleteUserBindingAPI() {
//           
//        let bindingId = CUserDefaults.value(forKey: CBindingId) as? String
//        guard let _bindingId = bindingId else {
//            return
//        }
//        
//        let bcakendUserBindingUrlToGetPush = APIDeleteBinding + "?binding_id=\(_bindingId)"
//           let finalUrl = TwilloBaseURL + bcakendUserBindingUrlToGetPush
//           
//           ServiceManager.callPostApi(finalUrl, methodType: .GET, isLoaderRequired: true, paramters: nil, successModel: BindingSucess.self, failuerModel: FailureModel.self) { [weak self] (model, failuerModel) in
//               guard let _ = self else {return}
//               if let code = model?.meta?.code, code == 0 {
//                   print("SuccessFully : delete-binding?binding_id")
//               }else{
//                   print("delete-binding?binding_id : Failed")
//               }
//           }
//    }
//    
//    func getOneToOneVideoCallToken() {
//        
//        let identity = "User" + (appDelegate.loginUser?.user_id ?? 0).description
//        let roomName = "UserRoom" + (appDelegate.loginUser?.user_id ?? 0).description
//        let bcakendTokenUrlEndPoint = APITwilioVideo + "?identity=\(identity)&room_name=\(roomName)"
//        let finalUrl = TwilloBaseURL + bcakendTokenUrlEndPoint
//        ServiceManager.callPostApi(finalUrl, methodType: .GET, isLoaderRequired: false, paramters: nil, successModel: SuccessModel.self, failuerModel: FailureModel.self) { [weak self] (model, failuerModel) in
//            guard let self = self else {return}
//            if let token = model?.data?.token {
//                self.videoAccessToken = token
//            }
//        }
//    }
//    
//    func disconnectCallAPI(receiverIdentity:String) {
//        
//        let notificationId = "123"
//        let notificationType = CallNotificationType.RejectVideoNotification.rawValue
//        let bcakendUserBindingUrlToGetPush = APIRejectCall +  "?identity=\(receiverIdentity)&notification_id=\(notificationId)&notification_type=\(notificationType)"
//        let finalUrl = TwilloBaseURL + bcakendUserBindingUrlToGetPush
//        
//        print(finalUrl)
//        
//        ServiceManager.callPostApi(finalUrl, methodType: .GET, isLoaderRequired: true, paramters: nil, successModel: SuccessModel.self, failuerModel: FailureModel.self) {  [weak self] (model, failuerModel) in
//            guard let _ = self else { return }
//            if let code = model?.meta?.code, code == 1  {
//            }
//        }
//    }
//    
//    func disconnectGroupCall(){
//        
//    }
//}
