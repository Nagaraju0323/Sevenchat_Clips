//
//  IncomeAudioCallVC.swift
//  Sevenchats
//
//  Created by mac-00020 on 08/11/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import TwilioVoice

class IncomeAudioCallVC: UIViewController {
    
    //MARK: - IBOutlet/Object/Variable Declaration
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblCallingTime: UILabel!
    @IBOutlet weak var btnMuteVideo: UIButton!
    @IBOutlet weak var btnSpeckerVideo: UIButton!
    @IBOutlet weak var lblMobile: UILabel!
    @IBOutlet weak var vwBlur: VisualEffectView!{
        didSet{
            //vwBlur.tint(UIColor.black.withAlphaComponent(0.7), blurRadius: 12.0)
            vwBlur.tint(UIColor.black.withAlphaComponent(0.7), blurRadius: 12.0)
            //vwBlur.tint(UIColor.clear, blurRadius: 0.0)
        }
    }
    
    private var gradientLayer : CAGradientLayer? = nil
    
    var isSender = true
    var fullName = ""
    var userImage = ""
    var mobile = ""
    var countryCode = ""
    var roomType : RoomType = .UserRoom
    let callCountDown = CallCountDownTimer()
    
    //var isMuteCall : Bool = false
    
    //MARK: - View life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.isIdleTimerDisabled = true
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.imgProfile.roundView()
        self.btnSpeckerVideo.roundView()
        if gradientLayer == nil {
            gradientLayer = CAGradientLayer(
                start: .customPoint(customePoint: CGPoint(x: 0.5, y: 0.3)),
                end: .customPoint(customePoint: CGPoint(x: 0.7, y: 0.5)),
                colors: [
                    UIColor(hex: "64939d").cgColor, UIColor(hex: "4d755d").cgColor],
                type: .axial
            )
            gradientLayer?.frame = self.view.bounds
            self.view.layer.insertSublayer(gradientLayer!, at: 0)
        }
    }
    
    //MARK: - Memory management methods
    deinit {
        // CallKit has an odd API contract where the developer must call invalidate or the CXProvider is leaked.
        print("### deinit -> IncomeAudioCallVC")
    }
}

//MARK: - SetupUI
extension IncomeAudioCallVC {
    fileprivate func setupView() {
        
        btnMuteVideo.isSelected = false
        //updateMuteStatus()
        updateUserName()
        //updateSpekerStatus()
        
        //let notificationCenter = NotificationCenter.default
        //notificationCenter.addObserver(self, selector: #selector(appMovedToForground), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        self.startCallingCountDown()
        
        if let audioCall = appDelegate.audioCallHelper {
            audioCall.didUpdateIsSpeakerphoneEnabled = { [weak self] (isEnable) in
                guard let _ = self else { return }
                DispatchQueue.main.async {
                    self?.updateSpekerStatus(isEnable: isEnable)
                }
            }
            
            audioCall.didUpdateMuteStatus = { [weak self] (isEnable) in
                guard let _ = self else { return }
                DispatchQueue.main.async {
                    self?.updateMuteStatus(isEnable: isEnable)
                }
            }
            
            audioCall.endCallFromReceiver = { [weak self] in
                DispatchQueue.main.async {
                    self?.disconnectedCall()
                }
            }
        }

    }
    
    func startCallingCountDown(){
        Timer.scheduledTimer(timeInterval: 1.0, target: self,
            selector: #selector(updateElapsedCallTime(_:)), userInfo: nil, repeats: true)
        callCountDown.start()
    }
    
    func updateUserName(){
        
        if self.roomType == .UserRoom{
            self.imgProfile.loadImageFromUrl(self.userImage, true)
            self.lblUserName.text = CCallFrom + " " + self.fullName
            self.lblMobile.text = self.countryCode + " " + self.mobile
        } else {
            self.lblUserName.text = CGroupCallFrom + " " + self.fullName
        }
    }
    
    func updateSpekerStatus(isEnable : Bool){
        if (isEnable) {
            self.btnSpeckerVideo.setImage(UIImage(named: "ic_speacker_enable"), for: .normal)
        } else {
            self.btnSpeckerVideo.setImage(UIImage(named: "ic_speacker_disable"), for: .normal)
        }
    }
    
    func updateMuteStatus(isEnable : Bool){
        if (isEnable) {
            self.btnMuteVideo.setImage(UIImage(named: "ic_CallMute"), for: .normal)
        } else {
            self.btnMuteVideo.setImage(UIImage(named: "ic_CallUnMute"), for: .normal)
        }
    }
}

//MARK: - IBAction / Selector
extension IncomeAudioCallVC {
    
    func disconnectedCall(){
        callCountDown.stop()
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func onDisconnectCall(_ sender: UIButton) {
        callCountDown.stop()
        if let audioCall = appDelegate.audioCallHelper, let uuid = audioCall.receiveCallUUID {
            audioCall.performEndCallAction(uuid: uuid)
        }
    }
    
    @IBAction func OnSpeckerPressed(_ sender: UIButton) {
        if let audioCall = appDelegate.audioCallHelper {
            audioCall.toggleAudioRoute(isEnable: !audioCall.isSpeakerphoneEnabled)
        }
    }
    
    @IBAction func onMuteCallPressed(_ sender: UIButton) {
        //isMuteCall.toggle()
        appDelegate.audioCallHelper?.performMuteCallAction()
        //updateMuteStatus()
    }
    
    @objc func updateElapsedCallTime(_ timer: Timer) {
        if callCountDown.isRunning {
            lblCallingTime.text = callCountDown.elapsedTimeAsString
        } else {
            timer.invalidate()
        }
    }
}


