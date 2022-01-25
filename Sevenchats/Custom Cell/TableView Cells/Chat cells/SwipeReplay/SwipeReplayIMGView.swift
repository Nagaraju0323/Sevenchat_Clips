//
//  SwipeReplayIMGView.swift
//  Sevenchats
//
//  Created by APPLE on 14/04/21.
//  Copyright © 2021 mac-00020. All rights reserved.
//

/*********************************************************
 * Author  : Chandrika.R                                 *
 * Model   : SwipeReplayIMGView                          *
 * Changes :                                             *
 *                                                       *
 ********************************************************/
import UIKit
import AVFoundation
import MediaPlayer

class SwipeReplayIMGView: UIView {
    
    @IBOutlet weak var viewBack : UIView!{
        didSet{
            viewBack.layer.masksToBounds = false
            ViewmessageText.layer.shadowOpacity = 10
            viewBack.layer.shadowOffset = CGSize(width: 0, height: 5)
            viewBack.layer.shadowRadius = 10
            viewBack.layer.cornerRadius = 6
            viewBack.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var ViewmessageText : UIView!{
        didSet{
            ViewmessageText.layer.masksToBounds = false
            ViewmessageText.layer.shadowColor = ColorAppTheme.cgColor
            ViewmessageText.layer.shadowOpacity = 10
            ViewmessageText.layer.shadowOffset = CGSize(width: 0, height: 5)
            ViewmessageText.layer.shadowRadius = 10
            ViewmessageText.layer.cornerRadius = 6
        }
    }
    
    @IBOutlet weak var Viewmessageline : UIView!{
        didSet{
            Viewmessageline.layer.masksToBounds = false
            Viewmessageline.layer.shadowColor = ColorAppTheme.cgColor
            Viewmessageline.layer.shadowOpacity = 10
            Viewmessageline.layer.shadowOffset = CGSize(width: 0, height: 5)
            Viewmessageline.layer.shadowRadius = 10
            Viewmessageline.layer.cornerRadius = 6
        }
    }
    
    @IBOutlet weak var viewMessageContainer : UIView! {
        didSet {
            viewMessageContainer.layer.masksToBounds = false
            viewMessageContainer.layer.shadowColor = ColorAppTheme.cgColor
            viewMessageContainer.layer.shadowOpacity = 10
            viewMessageContainer.layer.shadowOffset = CGSize(width: 0, height: 5)
            viewMessageContainer.layer.shadowRadius = 10
            //            showHideVideoAudio()
        }
    }
    static var msgCountpass: ((_ msgCount :Int)-> ())?
    
    @IBOutlet weak var cnTextViewHeightHeight : NSLayoutConstraint!
    @IBOutlet weak var btnSend : UIButton!
    @IBOutlet weak var btnAutoDelete : UIButton!
    @IBOutlet weak var btnAudioMsg : UIButton!
    @IBOutlet weak var txtViewMessage : GenericTextView!
    @IBOutlet weak var lblUserTitle : UILabel!
    @IBOutlet weak var lblUserMessage : UILabel!
    @IBOutlet weak var btnClose : UIButton!
    @IBOutlet weak var audioMsgView: UIView!
    @IBOutlet weak var audioMsgTimeLbl: UILabel!
    @IBOutlet weak var replayIMGview: UIImageView!
    
    @IBOutlet var recordingTimeLabel: UILabel!
    @IBOutlet var record_btn_ref: UIButton!
    @IBOutlet var play_btn_ref: UIButton!
    
    var messageInformation: TblMessages!
    var autodelete = 0
    var setautoDel_audio : Int?
    var locationPicker : LocationPickerVC?
    var isautoDeleteTime: String?
    var isautoDeletevidoe = 0
    var isautoDeleteLocation = 0
    var latestFileName = ""
    var UserID:Int?
    var isSelected = false
    var audioRecorder: AVAudioRecorder!
    var audioPlayer : AVAudioPlayer!
    var meterTimer:Timer!
    var isAudioRecordingGranted: Bool!
    var isRecording = false
    var isPlaying = false
    static var num = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        Intilization()
    }
    
    //MARK:- #####################Intilization#####################
    func Intilization(){
        btnAutoDelete.isHidden = true
        audioMsgView.isHidden = true
        audioMsgTimeLbl.isHidden = true
        audioMsgView.layer.cornerRadius = 8
        audioMsgView.layer.masksToBounds = true
        btnClose.addTarget(self, action: #selector(btnClickAction(_:)), for: .touchUpInside)
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.audioMsglongTaps(_:)))
        self.btnAudioMsg.isUserInteractionEnabled = true
        btnAudioMsg.addGestureRecognizer(longGesture)
        btnAudioMsg.addTarget(self, action: #selector(self.audioMsglongTaps(_:)), for: .touchUpInside)
        
        replayIMGview.layer.masksToBounds = true
        replayIMGview.layer.cornerRadius = 5
        
        
    }
    
    //MARK:- #####################btnClickAction#####################
    @objc func btnClickAction(_ sender:UIButton){
        self.removeFromSuperview()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotificationForItemEdit"), object: nil)
    }
    func configureMessageReceiverCells(_ messageInfo: TblMessages?) {
        messageInformation = messageInfo
    }
    func showHideVideoAudio() {
        if !self.viewMessageContainer.isHidden {
            GCDMainThread.async { [weak self]  () in
                guard let `self` = self else { return }
            }
        } else {
        }
    }
    
}

//MARK:- #####################Show MessageVie #####################
extension SwipeReplayIMGView{
    class func initHomeAddPostMenuViews() -> SwipeReplayIMGView{
        
        num += 1
        SwipeReplayMsgView.msgCountpass?(num)
        let theHeight = CScreenHeight
        let objHomeAddPostView : SwipeReplayIMGView = Bundle.main.loadNibNamed("SwipeReplayIMGView", owner: nil, options: nil)?.last as! SwipeReplayIMGView
        objHomeAddPostView.frame = CGRect(x: 0, y: CScreenHeight - 182, width: CScreenWidth, height: CScreenHeight/4)
        return objHomeAddPostView
        
    }
    func showPostOption(){
        GCDMainThread.async {
            self.layoutIfNeeded()
        }
    }
    func showPostMessage(_ messageInfo: TblMessages?,UserId:Int){
        messageInformation = messageInfo
        GCDMainThread.async {
            self.lblUserTitle.text = messageInfo?.full_name
            self.lblUserMessage.text = messageInfo?.message
            self.UserID = UserId
            if messageInfo?.localMediaUrl != nil {
                let imgPath = CTopMostViewController.applicationDocumentsDirectory()! + (messageInfo?.localMediaUrl)!
                if FileManager.default.fileExists(atPath: imgPath) {
                    self.replayIMGview.image = UIImage(contentsOfFile: imgPath)
                    self.lblUserMessage.text = "Image"
                }else {
                    print("media does not exist in deivce ======== ")
                    self.replayIMGview.loadImageFromUrl(messageInfo?.message, false)
                    self.lblUserMessage.text = "Image"
                }
                if messageInfo?.msg_type == 3 {
                    if messageInfo?.localMediaUrl != nil && messageInfo?.thumb_url == nil {
                        let videoPath = CTopMostViewController.applicationDocumentsDirectory()! + "/" + (messageInfo?.localMediaUrl)!
                        if FileManager.default.fileExists(atPath: videoPath) {
//                            MIMQTT.shared().getVideoThumbNail(URL(fileURLWithPath: videoPath)) { (image) in
//                                GCDMainThread.async {
//                                    self.replayIMGview.image = image
//                                    self.lblUserMessage.text = "Video"
//                                }
//                            }
                        }
                    }else {
                        self.replayIMGview.loadImageFromUrl(messageInfo?.thumb_url, false)
                        self.lblUserMessage.text = "Video"
                    }
                }
            }else {
                if messageInfo?.msg_type == 6 || messageInfo?.msg_type == 2 {
                    self.replayIMGview.loadImageFromUrl(messageInfo?.message, false)
                }else {
                    self.replayIMGview.loadImageFromUrl(messageInfo?.thumb_url, false)
                }
            }
        }
    }
}

//MARK:- #####################ButtonAction #####################
extension SwipeReplayIMGView{
    func resignKeyboards(){
        UIApplication.shared.sendAction(#selector(resignFirstResponder), to: nil, from: nil, for: nil)
    }
    @IBAction func btnSendCLK(_ sender : UIButton){
        if !txtViewMessage.text.trim.isBlank {
            if let userid = self.UserID{
//                let channelId = CMQTTUSERTOPIC + "\(userid)"
                // Send message to both Login and front user...
//                MIMQTT.shared().messagePaylaod(arrUser: ["\(appDelegate.loginUser?.user_id ?? 0)", "\(userid)"], channelId: channelId, message: txtViewMessage.text.trim, messageType: .text, chatType: .user, groupID: nil, is_auto_delete: 0)
                txtViewMessage.text = nil
                txtViewMessage.updatePlaceholderFrame(false)
                cnTextViewHeightHeight.constant = 34
                txtViewMessage.resignFirstResponder()
                btnSend.isUserInteractionEnabled = true
                btnSend.alpha = 0.5
                btnAutoDelete.isUserInteractionEnabled = true
                btnAutoDelete.isHidden = true
                btnAudioMsg.isHidden = false
                btnAutoDelete.alpha = 0.5
                self.removeFromSuperview()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotificationForItemEdit"), object: nil)
            }
        }
    }
    @IBAction func btnAutoDeleteCLK(_ sender : UIButton){
        weak var weakSelf = self
        if !self.txtViewMessage.text.trim.isBlank {
            if let userid = self.UserID{
//                let channelId = CMQTTUSERTOPIC + "\(userid)"
                // Send message to both Login and front user...
//                MIMQTT.shared().messagePaylaod(arrUser: ["\(appDelegate.loginUser?.user_id ?? 0)", "\(userid)"], channelId: channelId, message: self.txtViewMessage.text.trim, messageType: .text, chatType: .user, groupID: nil, is_auto_delete: 1)
                self.txtViewMessage.text = nil
                self.txtViewMessage.updatePlaceholderFrame(false)
                self.cnTextViewHeightHeight.constant = 34
                self.txtViewMessage.resignFirstResponder()
                self.btnSend.isUserInteractionEnabled = true
                self.btnSend.alpha = 0.5
                self.btnAutoDelete.isUserInteractionEnabled = true
                self.btnAutoDelete.isHidden = true
                self.btnAudioMsg.isHidden = false
                self.btnAutoDelete.alpha = 0.5
                self.removeFromSuperview()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotificationForItemEdit"), object: nil)
            }
        }
    }
    
    @IBAction func btnAttachmentCLK(_ sender : UIButton){
        self.resignKeyboards()
        //        self.removeFromSuperview()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "btnAttachment"), object: nil)
        
    }
}
//MARK:- TextView Delegate Methods
extension SwipeReplayIMGView:GenericTextViewDelegate{
    func genericTextViewDidChange(_ textView: UITextView, height: CGFloat) {
        if textView.text.count < 1 || textView.text.trim.isBlank{
            btnSend.isUserInteractionEnabled = false
            btnAutoDelete.isUserInteractionEnabled = false
            btnAudioMsg.isHidden = false
            btnAutoDelete.isHidden = true
            btnSend.alpha = 0.5
            btnAutoDelete.alpha = 0.5
        }else{
            btnSend.isUserInteractionEnabled = true
            btnAutoDelete.isUserInteractionEnabled = true
            btnAutoDelete.isHidden = false
            btnAudioMsg.isHidden = true
            btnSend.alpha = 1
            btnAutoDelete.alpha = 1
        }
    }
    
}
extension UIResponder {
    public var parentViewControllers: UIViewController? {
        return next as? UIViewController ?? next?.parentViewController
    }
}
//MARK :- ##############Audio sms send ################
extension SwipeReplayIMGView {
    @objc func audioMsglongTaps(_ sender: UIGestureRecognizer){
        if sender.state == .ended {
            //        self.removeFromSuperview()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "AudioMsgEnd"), object: nil)
        }else if sender.state == .began {
            //            self.removeFromSuperview()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "AudioMsgbegan"), object: nil)
        }
    }
}
