//
//  OneToOneVideoCallVC.swift
//  Sevenchats
//
//  Created by mac-00020 on 22/10/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//

import Foundation
import UIKit
import SwiftySound
import TwilioVideo
import CallKit

class OneToOneVideoCallVC: UIViewController {

    //MARK: - IBOutlet/Object/Variable Declaration
    //@IBOutlet weak var txt: UITextField!
    
    @IBOutlet weak var vwCalling: UIView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblCallingTo: UILabel!
    
    @IBOutlet weak var collGroupVideoCallingView: CallLayoutCollView!
    @IBOutlet weak var previewView: VideoView!
    @IBOutlet weak var btnMuteVideo: UIButton!
    @IBOutlet weak var btnFlipCamera: UIButton!
    
    var videoCall : TVIVideoHelper!
    var memberId : [Int] = []
    var id : Int = 0
    var isSender = true
    var roomType : RoomType = .UserRoom
    
    var timerForCalling : Timer?
    
    let callObserver = CXCallObserver()
    
    //var imgUserProfile : String = ""
    //var strCallingTo : String = "Test User "
    var isPopToViewcontroller = false
    
    var fullName = ""
    var userImage = ""
    
    //MARK: - View life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        self.setupView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.imgProfile.roundView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.isNavigationBarHidden = true
        
    }
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    //MARK: - Memory management methods
    deinit {
        
        appDelegate.videoCallHelper = nil
        self.stopRinging()
        //UIApplication.shared.isIdleTimerDisabled = false
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
        print("### deinit -> OneToOneVideoCallVC")
    }
}

//MARK: - SetupUI
extension OneToOneVideoCallVC {
    
    fileprivate func setupView() {
        
        self.btnMuteVideo.isHidden = true
        self.vwCalling.isHidden = false
        self.setupProfileImage()
        
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .denied || AVCaptureDevice.authorizationStatus(for: .audio) == .denied {
            let settingsAppURL = URL(string: UIApplication.openSettingsURLString)!
            let alert = UIAlertController(
                title: nil,
                message: CCameraOrAudioPermission,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: CBtnCancel, style: .cancel, handler: { (_) in
                self.navigationController?.popViewController(animated: true)
            }))
            alert.addAction(UIAlertAction(title: CBtnCancel, style: .cancel, handler: { (_) in
                self.navigationController?.popViewController(animated: true)
            }))
            alert.addAction(UIAlertAction(title: CNavSettings, style: .default, handler: { (alert) -> Void in
                UIApplication.shared.open(settingsAppURL, options: [:], completionHandler: nil)
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        if appDelegate.videoCallHelper != nil {
            videoCall = appDelegate.videoCallHelper!
        } else {
            if roomType == .UserRoom {
                videoCall = TVIVideoHelper(roomInfo: MDLRoomInfo(info: UserRoom(id: self.id, name: self.fullName,image: self.userImage), isSender: self.isSender))
            }else{
                let userName = (appDelegate.loginUser?.first_name ?? "") + " " + (appDelegate.loginUser?.last_name ?? "")
                videoCall = TVIVideoHelper(roomInfo: MDLRoomInfo(info: GroupRoom(id: self.id, memberId: memberId, groupName: self.fullName, name: userName,image: self.userImage), isSender: self.isSender))
            }
        }
        videoCall.setUpView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.startVideoCapturing()
        }
        if isSender {
            self.videoCall.performStartCallAction(uuid: UUID(), roomName: self.fullName)
        }
        //MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: "\(CMessagePleaseWait)...")
        callObserver.setDelegate(self, queue: nil)
        
        callBackHandler()
    }
    
    @objc func appMovedToForeground() {
        print("App moved to ForeGround!")
        if let currentDevice = videoCall.camera?.device{
            videoCall.camera?.startCapture(device: currentDevice) { (device, format, error) in
            }
        }
    }
    
    func startVideoCapturing(){
        
        let frontCamera = CameraSource.captureDevice(position: .front)
        let backCamera = CameraSource.captureDevice(position: .back)
        
        if (frontCamera != nil || backCamera != nil) {
            // Preview our local camera track in the local video preview view.
            
            // Add renderer to video track for local preview
            self.videoCall.localVideoTrack?.addRenderer(self.previewView)
            logMessage(messageText: "Video track created")
            
            self.videoCall.camera!.startCapture(device: frontCamera != nil ? frontCamera! : backCamera!) { (captureDevice, videoFormat, error) in
                if let error = error {
                    self.logMessage(messageText: "Capture failed with error.\ncode = \((error as NSError).code) error = \(error.localizedDescription)")
                } else {
                    self.previewView.shouldMirror = (captureDevice.position == .front)
                    self.previewView.contentMode = .scaleAspectFill
                }
            }
        }
    }
    
    func setupProfileImage() {
        
        self.imgProfile.roundView()
        self.imgProfile.loadImageFromUrl(userImage, true)
        if self.isSender{
            callingStart()
        }else{
            connectingToStart()
        }
    }
    
    func ringingStart(){
        lblCallingTo.text =  CRinging + " " + fullName
        playRingTone()
    }
    
    func callingStart(){
        lblCallingTo.text =  CCallingTo + " " + fullName
    }
    
    func connectingToStart(){
        lblCallingTo.text =  CConnectingTo + " " + fullName
    }
    
    func updatePreviewView(){
        
        self.previewView.translatesAutoresizingMaskIntoConstraints = true
        self.previewView.removeConstraints(self.previewView.constraints)
        
        let vwHeight = self.view.bounds.height
        let vwWidth = self.view.bounds.width
        
        let previewWidth : CGFloat = (vwWidth / 2) - 20
        let previewHeight : CGFloat = previewWidth + 40
        
        self.previewView.frame = CGRect(
            x: 10,
            y: (vwHeight - previewHeight - (btnMuteVideo.bounds.height + 30)),
            width: previewWidth,
            height: previewHeight
        )
        
        self.previewView.layer.cornerRadius = 8
        self.previewView.clipsToBounds = true
        UIView.animate(withDuration: 0.3) {
            self.previewView.setNeedsLayout()
        }
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(OneToOneVideoCallVC.draggedView(_:)))
        //let gesture = UIPanGestureRecognizer(target: self, action: #selector(wasDragged)))
        self.previewView.addGestureRecognizer(gesture)
        self.previewView.isUserInteractionEnabled = true
        
        self.previewView.setNeedsLayout()
    }
    
    func setupRemoteVideoView() {
        
        //Reload collection view on same screen
        self.collGroupVideoCallingView.isHidden = false
        self.collGroupVideoCallingView.arrParticipaint = self.videoCall.arrParticipaint
        
        self.collGroupVideoCallingView.reloadData()
        
        self.btnMuteVideo.isHidden = false
        self.vwCalling.isHidden = true
        self.stopRinging()
    }
    
    func disconnectParticipant(){
        let arrParticipaint = self.videoCall.arrParticipaint.compactMap({$0.remoteView})
        if arrParticipaint.isEmpty{
            /*self.videoCall.room?.disconnect()
            self.navigationController?.popViewController(animated: true)*/
            self.disconnectCall()
            return
        }
        self.setupRemoteVideoView()
    }
    
    func playRingTone(){
        /*do {
            try AVAudioSession.sharedInstance().overrideOutputAudioPort(AVAudioSession.PortOverride.none)
        } catch let error {
            print("Override failed: \(error)")
        }*/
        Sound.enabled = true
        Sound.category = .playAndRecord
        Sound.play(file:RingToneName, fileExtension:RingToneExt, numberOfLoops: 10)
    }
    
    func stopRinging(){
        Sound.stopAll()
    }
}

//MARK: - UIGestureRecognizerDelegate
extension OneToOneVideoCallVC : UIGestureRecognizerDelegate {
    
   @objc func draggedView(_ sender:UIPanGestureRecognizer){
        //self.view.bringSubviewToFront(viewDrag)
        guard let senderView = sender.view else { return }
        
        let translation = sender.translation(in: self.view)
        
        let x = senderView.frame.origin.x + translation.x
        let y = senderView.frame.origin.y + translation.y
        
        let centerX = senderView.center.x + translation.x
        let centerY = senderView.center.y + translation.y
        print("X : \(centerX) -- Y : \(centerY)")
        let sWidht = senderView.bounds.width
        let sHeight = senderView.bounds.height
        
        let vWidht = self.view.bounds.width
        let vHeight = self.view.bounds.height
        
        if x > ((vWidht - sWidht) - 10) || x < 10{
            return
        }
        if y > (vHeight - sHeight - (btnMuteVideo.bounds.height + 30)) || y < 30{
            return
        }
        senderView.center = CGPoint(x: centerX, y: centerY)
        
        sender.setTranslation(CGPoint.zero, in: self.view)
    }
}

extension OneToOneVideoCallVC: CXCallObserverDelegate {

    func callObserver(_ callObserver: CXCallObserver, callChanged call: CXCall) {
        if call.hasConnected == true {
            //self.onDisconnectCall(UIButton())
            print("callObserver : call hasConnected")
        }
        if call.hasEnded == true {
            self.onDisconnectCall(UIButton())
            print("callObserver :  call ended")
        }
    }
}

//MARK: - Call Back Handler
extension OneToOneVideoCallVC {
   
    func callBackHandler(){
        
        videoCall.didConnectedToRom = { [weak self] (totalParticipaint) in
            guard let self = self else {return}
            DispatchQueue.main.async {
                MILoader.shared.hideLoader()
                if self.isSender && totalParticipaint > 0 && self.roomType == .UserRoom {
                    self.disconnectCall()
                    return
                }
                if totalParticipaint > 0 {
                    self.updatePreviewView()
                } else if self.isSender{
                    self.videoCall.requestForPushToConnectWithFriend()
                } else {
                    self.updatePreviewView()
                    if self.roomType == .GroupRoom {
                        self.monitorTimer()
                    }
                }
            }
        }
        
        videoCall.didFailedToConnectWithRom = { [weak self] in
            guard let _ = self else {return}
            DispatchQueue.main.async {
                MILoader.shared.hideLoader()
                self?.disconnectCall()
            }
        }
        
        videoCall.didUpdateVideoView = { [weak self] in
            guard let _ = self else {return}
            DispatchQueue.main.async {
                self?.setupRemoteVideoView()
            }
        }
        
        videoCall.didDisconnectParticlipaint = { [weak self] in
            guard let _ = self else {return}
            DispatchQueue.main.async {
                self?.updateTimer()
                self?.disconnectParticipant()
            }
        }
        
        videoCall.participantDidConnect = { [weak self] in
            guard let _ = self else {return}
            DispatchQueue.main.async {
                self?.updatePreviewView()
            }
        }
        
        videoCall.roomDidDisconnected = { [weak self] in
            guard let _ = self else {return}
            DispatchQueue.main.async {
                self?.disconnectCall()
            }
        }
        
        videoCall.didSentRequestForConnect = { [weak self] in
            guard let _ = self else {return}
            DispatchQueue.main.async {
                print("didSentRequestForConnect")
                self?.monitorTimer()
                self?.ringingStart()
            }
        }
        
        videoCall?.didMuteCall = { [weak self] (isEnable) in
            guard let _ = self else { return }
            self?.muteAudio(isMuted: isEnable)
        }
        
    }
    
    func monitorTimer(){
        /*timerForCalling = Timer(timeInterval: 10, repeats: false, block: { [weak self](_) in
            guard let self = self else {return}
            self.updateTimer()
        })*/
        timerForCalling = Timer.scheduledTimer(timeInterval: TimeInterval(30), target: self,   selector:#selector(updateTimer), userInfo: nil, repeats: false)
    }
    @objc func updateTimer(){
        
        if self.videoCall == nil || timerForCalling == nil{
            timerForCalling?.invalidate()
            timerForCalling = nil
            return
        }
        
        if self.videoCall.room != nil && self.videoCall.arrParticipaint.isEmpty {
            timerForCalling?.invalidate()
            timerForCalling = nil
            self.onDisconnectCall(UIButton())
        }
        timerForCalling?.invalidate()
        timerForCalling = nil
    }
    
    func muteAudio(isMuted: Bool) {
    
        if (isMuted) {
            self.btnMuteVideo.setImage(UIImage(named: "ic_CallUnMute"), for: .normal)
        } else {
            self.btnMuteVideo.setImage(UIImage(named: "ic_CallMute"), for: .normal)
        }
    }
}

//MARK: - IBAction / Selector
extension OneToOneVideoCallVC {
    
    func disconnectCall(){
        
        timerForCalling?.invalidate()
        timerForCalling = nil
        
        self.updateTimer()
        DispatchQueue.main.async {
            if !self.isPopToViewcontroller && self.videoCall.roomInfo.info.roomType == .GroupRoom {
                self.videoCall.room?.disconnect()
                self.videoCall.room = nil
                self.isPopToViewcontroller = true
                if let controller = self.getViewControllerFromNavigation(GroupChatDetailsViewController.self){
                    self.navigationController?.popToViewController(controller, animated: true)
                } else {
                    self.navigationController?.popViewController(animated: true)
                }
                
            } else if !self.isPopToViewcontroller {
                self.videoCall.room?.disconnect()
                self.videoCall.room = nil
                self.navigationController?.popViewController(animated: true)
                self.isPopToViewcontroller = true
            }
        }
    }
    
    @IBAction func onBackButton(_ sender: UIButton) {
        self.stopRinging()
        self.onDisconnectCall(UIButton())
        //self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onDisconnectCall(_ sender: UIButton) {
        self.stopRinging()
        if self.videoCall.room != nil{
            self.videoCall.disconnectCallAPI()
        }
        disconnectCall()
    }
    
    @IBAction func onFlipCamera(_ sender: UIButton) {
        var newDevice: AVCaptureDevice?
        
        if let camera = self.videoCall.camera, let captureDevice = camera.device {
            
            if captureDevice.position == .front {
                newDevice = CameraSource.captureDevice(position: .back)
            } else {
                newDevice = CameraSource.captureDevice(position: .front)
            }
            
            if let newDevice = newDevice {
                camera.selectCaptureDevice(newDevice) { [weak self] (captureDevice, videoFormat, error) in
                    guard let self = self else { return }
                    if let error = error {
                        self.logMessage(messageText: "Error selecting capture device.\ncode = \((error as NSError).code) error = \(error.localizedDescription)")
                    } else {
                        self.previewView.shouldMirror = (captureDevice.position == .front)
                    }
                }
            }
        }
    }
    
    @IBAction func onMuteCallPressed(sender: UIButton) {
        if let room = self.videoCall.room, let uuid = room.uuid, let localAudioTrack = self.videoCall.localAudioTrack {
            let isMuted = localAudioTrack.isEnabled
            let muteAction = CXSetMutedCallAction(call: uuid, muted: isMuted)
            let transaction = CXTransaction(action: muteAction)

            self.videoCall.callKitCallController.request(transaction)  { error in
                DispatchQueue.main.async {
                    if let error = error {
                        self.logMessage(messageText: "SetMutedCallAction transaction request failed: \(error.localizedDescription)")
                        return
                    }
                    self.logMessage(messageText: "SetMutedCallAction transaction request successful")
                }
            }
        }
        
        /*self.videoCall.localAudioTrack?.isEnabled.toggle()
        self.videoCall?.toggleAudioRoute(isEnable: (self.videoCall.localAudioTrack?.isEnabled ?? false))
        
        if (self.videoCall.localAudioTrack != nil) {
            //self.videoCall.localAudioTrack?.isEnabled.toggle()
            // Update the button title
            if (self.videoCall.localAudioTrack?.isEnabled ?? false) {
                self.btnMuteVideo.setImage(UIImage(named: "ic_CallUnMute"), for: .normal)
            } else {
                self.btnMuteVideo.setImage(UIImage(named: "ic_CallMute"), for: .normal)
            }
        }*/
    }
}
