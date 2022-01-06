////
////  AudioCallVC.swift
////  Sevenchats
////
////  Created by mac-00020 on 05/11/19.
////  Copyright © 2019 mac-0005. All rights reserved.
////
//
//import Foundation
//import UIKit
//import SwiftySound
//import AVFoundation
//
//class AudioCallVC: UIViewController {
//    
//    //MARK: - IBOutlet/Object/Variable Declaration
//    @IBOutlet weak var imgProfile: UIImageView!
//    @IBOutlet weak var lblCallingTo: UILabel!
//    @IBOutlet weak var lblMobile: UILabel!
//    @IBOutlet weak var lblCallingTime: UILabel!
//    @IBOutlet weak var btnMuteVideo: UIButton!
//    @IBOutlet weak var btnSpeckerVideo: UIButton!
//    
//    @IBOutlet weak var vwBlur: VisualEffectView!{
//        didSet{
//            //vwBlur.tint(UIColor.black.withAlphaComponent(0.7), blurRadius: 12.0)
//            vwBlur.tint(UIColor.black.withAlphaComponent(0.7), blurRadius: 12.0)
//            //vwBlur.tint(UIColor.clear, blurRadius: 0.0)
//        }
//    }
//    
//    private var gradientLayer : CAGradientLayer? = nil
//    
//    var audioCallHelper : AudioCallHelper?
//    var isSender = true
//    var fullName = ""
//    var userImage = ""
//    var member : Members!
//    var members : [Members] = []
//    var roomType : RoomType = .UserRoom
//    var isCallDisconnected = false
//    var timerForDisconnectRoom: Timer?
//    let callCountDown = CallCountDownTimer()
//    
//    //MARK: - View life cycle methods
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.setupView()
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.navigationController?.isNavigationBarHidden = true
//    }
//    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        self.imgProfile.roundView()
//        self.btnSpeckerVideo.roundView()
//        
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
//        callCountDown.stop()
//        stopTimerForGroup()
//        NotificationCenter.default.removeObserver(self)
//        audioCallHelper?.removeNotification()
//        audioCallHelper = nil
//        print("### deinit -> AudioCallVC")
//    }
//}
//
////MARK: - SetupUI
//extension AudioCallVC {
//    fileprivate func setupView() {
//        
//        self.title = self.fullName
//        self.connectiongTo()
//        var arrMember : [Members] = []
//        var roomType : RoomType = .UserRoom
//        
//        if self.roomType == .UserRoom {
//            self.imgProfile.loadImageFromUrl(userImage, true)
//            arrMember = [self.member]
//        }else{
//            roomType = .GroupRoom
//            arrMember = self.members
//        }
//        
//        let audio = AudioCall(
//            members: arrMember,
//            roomType: roomType,
//            name: self.fullName,
//            image:self.userImage,
//            isSender: self.isSender
//        )
//        
//        audioCallHelper = AudioCallHelper(audio: audio)
//        //audioCallHelper?.strFullName = self.fullName
//        checkAudioPermission()
//        
//        //updateSpeakerStatus()
//        updateMuteStatus()
//        
//        self.lblCallingTime.text = ""
//        
//        let notificationCenter = NotificationCenter.default
//        notificationCenter.addObserver(self, selector: #selector(appMovedToForground), name: UIApplication.didBecomeActiveNotification, object: nil)
//        
//        audioCallHelper?.callDidDisconnected = { [weak self] in
//            self?.isCallDisconnected = true
//            self?.disconnectCall()
//        }
//        
//        audioCallHelper?.didGetToken = { [weak self] in
//            self?.callingTo()
//        }
//        
//        audioCallHelper?.didStartRinging = { [weak self] in
//            self?.ringto()
//        }
//        
//        audioCallHelper?.didConnected = { [weak self] in
//            self?.connectedWith()
//        }
//        
//        audioCallHelper?.didUpdateIsSpeakerphoneEnabled = { [weak self] (isEnable) in
//            guard let _ = self else { return }
//            self?.updateSpeakerStatus(isEnable: isEnable)
//        }
//    }
//    
//    func startTimerForGroup() {
//        let timeInterval = 65
//        self.timerForDisconnectRoom = Timer.scheduledTimer(withTimeInterval: TimeInterval(timeInterval), repeats: false, block: {  [weak self] (timer) in
//            guard let _ = self else { return }
//            AudioTokenService.shared.completeConferenceRoomAPI(roomName: myAudioIdentity)
//            self?.stopTimerForGroup()
//        })
//    }
//    
//    func startCallingCountDown(){
//        Timer.scheduledTimer(timeInterval: 1.0, target: self,
//            selector: #selector(updateElapsedCallTime(_:)), userInfo: nil, repeats: true)
//        callCountDown.start()
//    }
//    
//    func stopTimerForGroup(){
//        stopRinging()
//        timerForDisconnectRoom?.invalidate()
//        timerForDisconnectRoom = nil
//    }
//    
//    func checkAudioPermission() {
//        audioCallHelper?.checkRecordPermission { [weak self] (permissionGranted) in
//            
//            guard let self = self else { return }
//            
//            if (!permissionGranted) {
//                let alertController: UIAlertController = UIAlertController(title: CVoiceQuickStart, message: CMicrophonePermissionNotGranted, preferredStyle: .alert)
//                
//                let continueWithMic: UIAlertAction = UIAlertAction(title: CContinueWithoutMicrophone, style: .default, handler: { (action) in
//                    //self.performStartCallAction(uuid: uuid, handle: handle)
//                    self.audioCallHelper?.setUpView()
//                })
//                alertController.addAction(continueWithMic)
//                
//                let goToSettings: UIAlertAction = UIAlertAction(title: CNavSettings,  style: .default, handler: { (action) in
//                    let settingURL = URL(string: UIApplication.openSettingsURLString)!
//                    UIApplication.shared.open(
//                        settingURL,
//                        options: [UIApplication.OpenExternalURLOptionsKey.universalLinksOnly: false],
//                        completionHandler: nil
//                    )
//                })
//                alertController.addAction(goToSettings)
//                
//                let cancel: UIAlertAction = UIAlertAction(title: CBtnCancel, style: .cancel, handler: { (action) in
//                    //self.toggleUIState(isEnabled: true, showCallControl: false)
//                    self.navigationController?.popViewController(animated: true)
//                })
//                alertController.addAction(cancel)
//                
//                self.present(alertController, animated: true, completion: nil)
//                
//            } else {
//                self.audioCallHelper?.setUpView()
//            }
//        }
//    }
//    
//    func updateSpeakerStatus(isEnable: Bool){
//        if (isEnable) {
//            self.btnSpeckerVideo.setImage(UIImage(named: "ic_speacker_enable"), for: .normal)
//        } else {
//            self.btnSpeckerVideo.setImage(UIImage(named: "ic_speacker_disable"), for: .normal)
//        }
//    }
//    
//    func updateMuteStatus(){
//        if (self.audioCallHelper?.call?.isMuted ?? false) {
//            self.btnMuteVideo.setImage(UIImage(named: "ic_CallMute"), for: .normal)
//        } else {
//            self.btnMuteVideo.setImage(UIImage(named: "ic_CallUnMute"), for: .normal)
//        }
//    }
//    
//    @objc func appMovedToForground() {
//        print("App moved to Forground!")
//        if isCallDisconnected{
//            self.disconnectCall()
//        }
//    }
//    
//    func connectiongTo() {
//        lblCallingTo.text = CConnecting
//    }
//    
//    func callingTo() {
//        lblCallingTo.text = CStartCalling
//    }
//    
//    func ringto() {
//        lblCallingTo.text = CRinging
//        playRingTone()
//    }
//    
//    func connectedWith() {
//        self.lblCallingTo.text = CConnectedWith + " " + self.fullName
//        stopRinging()
//        if self.roomType == .GroupRoom {
//            self.startTimerForGroup()
//        } else {
//            //self.lblMobile.text =
//            startCallingCountDown()
//        }
//    }
//    
//    @objc func updateElapsedCallTime(_ timer: Timer) {
//        if callCountDown.isRunning {
//            lblCallingTime.text = callCountDown.elapsedTimeAsString
//        } else {
//            timer.invalidate()
//        }
//    }
//    
//    func playRingTone(){
//        /*do {
//            try AVAudioSession.sharedInstance().overrideOutputAudioPort(AVAudioSession.PortOverride.none)
//        } catch let error {
//            print("Override failed: \(error)")
//        }*/
//        Sound.enabled = true
//        Sound.category = .playAndRecord
//        Sound.play(file:RingToneName, fileExtension:RingToneExt, numberOfLoops: 10)
//    }
//    
//    func stopRinging(){
//        Sound.stopAll()
//    }
//}
//
////MARK: - IBAction / Selector
//extension AudioCallVC {
//    
//    func disconnectCall(){
//        DispatchQueue.main.async {
//            self.callCountDown.stop()
//            if let controller = self.getViewControllerFromNavigation(GroupChatDetailsViewController.self){
//                self.navigationController?.popToViewController(controller, animated: true)
//            } else {
//                self.navigationController?.popViewController(animated: true)
//            }
//            //self.navigationController?.popViewController(animated: true)
//        }
//    }
//    
//    @IBAction func onDisconnectCall(_ sender: UIButton) {
//        stopRinging()
//        self.audioCallHelper?.endCall()
//    }
//    
//    @IBAction func onMutePressed(_ sender: UIButton) {
//        if let call = self.audioCallHelper?.call{
//            call.isMuted.toggle()
//            self.updateMuteStatus()
//        }
//    }
//    
//    @IBAction func onSpeackerPressed(_ sender: UIButton) {
//        self.audioCallHelper?.toggleAudioRoute(isEnable: !(self.audioCallHelper?.isSpeakerphoneEnabled ?? false))
//        //self.updateSpeakerStatus()
//    }
//}
//
