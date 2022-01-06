////
////  IncomingVideoCallVC.swift
////  Sevenchats
////
////  Created by mac-00020 on 25/10/19.
////  Copyright © 2019 mac-0005. All rights reserved.
////
//
//import Foundation
////import SwiftySound
//import UIKit
//import Alamofire
//
//class IncomingVideoCallVC: UIViewController {
//
//    private var gradientLayer : CAGradientLayer? = nil
//
//    //MARK: - IBOutlet/Object/Variable Declaration
//    @IBOutlet weak var imgUser: UIImageView!
//    @IBOutlet weak var lblUserName: UILabel!
//    @IBOutlet weak var lblMobile: UILabel!
//    @IBOutlet weak var vwBlur: VisualEffectView!{
//        didSet{
//            //vwBlur.tint(UIColor.black.withAlphaComponent(0.7), blurRadius: 12.0)
//            vwBlur.tint(UIColor.black.withAlphaComponent(0.7), blurRadius: 12.0)
//            //vwBlur.tint(UIColor.clear, blurRadius: 0.0)
//        }
//    }
//    var notification: AudioVideoNotification?
//
//    var timerForCalling : Timer?
//
//    //MARK: - View life cycle methods
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        //Sound.play(file:RingToneName, fileExtension:RingToneExt, numberOfLoops: 10)
//
//        VoIPNotificationHandler.shared().removeVideoCallingNotification()
//        self.setupView()
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//    }
//
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        self.imgUser.roundView()
//        if gradientLayer == nil {
//            gradientLayer = CAGradientLayer(
//                start: .customPoint(customePoint: CGPoint(x: 0.5, y: 0.3)),
//                end: .customPoint(customePoint: CGPoint(x: 0.7, y: 0.5)),
//                colors: [
//                    UIColor(hex: "64939d").cgColor, UIColor(hex: "4d755d").cgColor],
//                type: .axial
//            )
//            gradientLayer?.frame = self.view.bounds
//            self.view.layer.insertSublayer(gradientLayer!, at: 0)
//        }
//    }
//
//    //MARK: - Memory management methods
//    deinit {
//        //Sound.stopAll()
//        print("### deinit -> IncomingVideoCallVC")
//    }
//}
//
////MARK: - SetupUI
//extension IncomingVideoCallVC {
//
//    fileprivate func setupView() {
//
//        imgUser.roundView()
//
//        guard let _notification = self.notification else { return }
//
//        if _notification.userData.roomType == .GroupRoom{
//            self.imgUser.loadImageFromUrl(_notification.userData.userImage, true)
//             let firstString = CVideoCallFrom + " "
//             let secondString =  _notification.userData.fullName + " " + CIn + " "
//             let ThirdStrign = _notification.userData.groupName
//
//            self.lblUserName.text = firstString + secondString + ThirdStrign
////            self.lblUserName.text = CVideoCallFrom + " " + _notification.userData.fullName + " " + CIn + " " + _notification.userData.groupName
//            self.monitorTimer()
//        } else {
//            self.imgUser.loadImageFromUrl(_notification.userData.callerUserImage, true)
//            self.lblUserName.text = CVideoCallFrom  + " " + _notification.userData.fullName
//            self.lblMobile.text = _notification.userData.countryCode + " " + _notification.userData.mobile
//        }
//    }
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
//    func monitorTimer(){
//        timerForCalling = Timer.scheduledTimer(timeInterval: TimeInterval(CallingTime), target: self,   selector:#selector(updateTimer), userInfo: nil, repeats: false)
//    }
//    @objc func updateTimer(){
//        if timerForCalling != nil{
//            timerForCalling?.invalidate()
//            timerForCalling = nil
//            self.dismiss(animated: true)
//        }
//    }
//}
//
////MARK: - IBAction / Selector
//extension IncomingVideoCallVC {
//
//    @IBAction func onAcceptCall(_ sender: UIButton) {
//        //Sound.stopAll()
//        guard let _notification = self.notification else { return }
//        self.dismiss(animated: true) {
//            DispatchQueue.main.async {
//                if _notification.userData.roomType == .UserRoom{
//                    self.moveOnOTOVideoScreen()
//                }else {
//                    self.moveGroupVideoScreen()
//                }
//            }
//        }
//    }
//
//    @IBAction func onRejectCall(_ sender: UIButton) {
//        //Sound.stopAll()
//        guard let _notification = self.notification else {
//            self.dismiss(animated: true)
//            return
//        }
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
//                if let code = model?.meta?.code, code == 0 {
//                }
//            }
//
//            /*TVITokenService.shared.disconnectCallAPI(
//                receiverIdentity: ""
//            )*/
//        }
//        self.dismiss(animated: true)
//    }
//}
//
//
//extension CAGradientLayer {
//
//    enum Point {
//        case topLeft
//        case centerLeft
//        case bottomLeft
//        case topCenter
//        case center
//        case bottomCenter
//        case topRight
//        case centerRight
//        case bottomRight
//        case customPoint(customePoint : CGPoint)
//
//        var point: CGPoint {
//            switch self {
//            case .topLeft:
//                return CGPoint(x: 0, y: 0)
//            case .centerLeft:
//                return CGPoint(x: 0, y: 0.5)
//            case .bottomLeft:
//                return CGPoint(x: 0, y: 1.0)
//            case .topCenter:
//                return CGPoint(x: 0.5, y: 0)
//            case .center:
//                return CGPoint(x: 0.5, y: 0.5)
//            case .bottomCenter:
//                return CGPoint(x: 0.5, y: 1.0)
//            case .topRight:
//                return CGPoint(x: 1.0, y: 0.0)
//            case .centerRight:
//                return CGPoint(x: 1.0, y: 0.5)
//            case .bottomRight:
//                return CGPoint(x: 1.0, y: 1.0)
//            case .customPoint(let customePoint):
//                return customePoint
//            }
//        }
//    }
//
//    convenience init(start: Point, end: Point, colors: [CGColor], type: CAGradientLayerType) {
//        self.init()
//        self.startPoint = start.point
//        self.endPoint = end.point
//        self.colors = colors
//        self.locations = (0..<colors.count).map(NSNumber.init)
//        self.type = type
//    }
//}
//
