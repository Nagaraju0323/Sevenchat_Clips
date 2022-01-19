//
//  SwipeReplayMsgView.swift
//  Sevenchats
//
//  Created by APPLE on 29/03/21.
//  Copyright © 2021 mac-00020. All rights reserved.
//

//import UIKit
//
//class SwipeReplayMsgView: UIView {
//
//    @IBOutlet weak var viewBack : UIView!{
//    didSet{
//        viewBack.layer.masksToBounds = false
//        ViewmessageText.layer.shadowOpacity = 10
//        viewBack.layer.shadowOffset = CGSize(width: 0, height: 5)
//        viewBack.layer.shadowRadius = 10
//        viewBack.layer.cornerRadius = 6
//        viewBack.backgroundColor = .clear
//        }
//    }
//
//    @IBOutlet weak var ViewmessageText : UIView!{
//    didSet{
//        ViewmessageText.layer.masksToBounds = false
//        ViewmessageText.layer.shadowColor = ColorAppTheme.cgColor
//        ViewmessageText.layer.shadowOpacity = 10
//        ViewmessageText.layer.shadowOffset = CGSize(width: 0, height: 5)
//        ViewmessageText.layer.shadowRadius = 10
//        ViewmessageText.layer.cornerRadius = 6
//        }
//    }
//
//    @IBOutlet weak var Viewmessageline : UIView!{
//    didSet{
//        Viewmessageline.layer.masksToBounds = false
//        Viewmessageline.layer.shadowColor = ColorAppTheme.cgColor
//        Viewmessageline.layer.shadowOpacity = 10
//        Viewmessageline.layer.shadowOffset = CGSize(width: 0, height: 5)
//        Viewmessageline.layer.shadowRadius = 10
//        Viewmessageline.layer.cornerRadius = 6
//        }
//    }
//
//
//    @IBOutlet weak var viewMessageContainer : UIView! {
//        didSet {
//            viewMessageContainer.layer.masksToBounds = false
//            viewMessageContainer.layer.shadowColor = ColorAppTheme.cgColor
//            viewMessageContainer.layer.shadowOpacity = 10
//            viewMessageContainer.layer.shadowOffset = CGSize(width: 0, height: 5)
//            viewMessageContainer.layer.shadowRadius = 10
//            showHideVideoAudio()
//        }
//    }
//
//
//    @IBOutlet weak var lblUserBlockMessage : UILabel!
//    @IBOutlet weak var cnTextViewHeightHeight : NSLayoutConstraint!
//    @IBOutlet weak var btnSend : UIButton!
//    @IBOutlet weak var btnAutoDelete : UIButton!
//    @IBOutlet weak var btnAudioMsg : UIButton!
//    @IBOutlet weak var btnBack : UIButton!
//    @IBOutlet weak var btnMore : UIButton!
//    @IBOutlet private weak var btnVideo: UIButton!
//    @IBOutlet private weak var btnAudio: UIButton!
//    @IBOutlet weak var txtViewMessage : GenericTextView!
//    @IBOutlet weak var lblUserTitle : UILabel!
//    @IBOutlet weak var lblUserMessage : UILabel!
//
//    var messageInformation: TblMessages!
//    var autodelete = 0
//    var setautoDel_audio : Int?
//    var locationPicker : LocationPickerVC?
//    var isautoDeleteTime: String?
//    var isautoDeletevidoe = 0
//    var isautoDeleteLocation = 0
//    var latestFileName = ""
//
//    //AudioMsg
//    @IBOutlet weak var audioMsgView: UIView!
//    @IBOutlet weak var audioMsgTimeLbl: UILabel!
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        Intilization()
//    }
//
////MARK:- Intilization
//    func Intilization(){
//        btnAutoDelete.isHidden = true
//        audioMsgView.isHidden = true
//        audioMsgTimeLbl.isHidden = true
//        audioMsgView.layer.cornerRadius = 8
//        audioMsgView.isHidden = true
//        audioMsgView.layer.masksToBounds = true
//    }
//
//    @IBAction func btnCloseCLK(_ sender: UIButton) {
//        print("this is calling")
//        viewBack.removeFromSuperview()
//        ViewmessageText.removeFromSuperview()
//        Viewmessageline.removeFromSuperview()
//        viewMessageContainer.removeFromSuperview()
//        self.removeFromSuperview()
//    }
//
//    func configureMessageReceiverCells(_ messageInfo: TblMessages?) {
//        messageInformation = messageInfo
//        print("messageinformation\(messageInformation.full_name)")
//
//
//    }
//
//    func showHideVideoAudio() {
//        if !self.viewMessageContainer.isHidden {
//            GCDMainThread.async { [weak self]  () in
//                guard let `self` = self else { return }
//            }
//        } else {
//        }
//    }
//
//}
//
//
////MARK:- Attachement ButtonClick
//extension SwipeReplayMsgView{
//
//
//
//
//}
//
//
//
////MARK : - ---------------LoadUIview======>
//extension SwipeReplayMsgView{
//
//    class func initHomeAddPostMenuViews() -> SwipeReplayMsgView{
//        let theHeight = CScreenHeight
//        print("thehight",theHeight)
//        let objHomeAddPostView : SwipeReplayMsgView = Bundle.main.loadNibNamed("SwipeReplayMsgView", owner: nil, options: nil)?.last as! SwipeReplayMsgView
//        objHomeAddPostView.frame = CGRect(x: 0, y: CScreenHeight - 182, width: CScreenWidth, height: CScreenHeight/4)
//        return objHomeAddPostView
//
//    }
//    func showPostOption(){
//        GCDMainThread.async {
//            UIView.animate(withDuration: 0.3, animations: {
//                //_ = self.tblPostMenu.setConstraintConstant(20, edge: .leading, ancestor: true)
////                _ = self.viewPopUp.setConstraintConstant(-5, edge: .trailing, ancestor: true)
////                _ = self.btnClose.setConstraintConstant(60, edge: .bottom, ancestor: true)
////                self.tblPostMenu.reloadData()
//                self.layoutIfNeeded()
//            }, completion: { (completed) in
//            })
//        }
//    }
//
//    func showPostMessage(_ messageInfo: TblMessages?){
//        messageInformation = messageInfo
//        GCDMainThread.async {
//            self.lblUserTitle.text = messageInfo?.full_name
//            self.lblUserMessage.text = messageInfo?.message
//        }
//    }
//}

//OLD CODE


//
//import UIKit
//import AVFoundation
//import MediaPlayer
//
//protocol DatapassDelegate:class{
//    func didButtonTapped()
//}
//
//class SwipeReplayMsgView: UIView, UITextViewDelegate{
//
//    @IBOutlet weak var viewBack : UIView!{
//        didSet{
//            viewBack.layer.masksToBounds = false
//            ViewmessageText.layer.shadowOpacity = 10
//            viewBack.layer.shadowOffset = CGSize(width: 0, height: 5)
//            viewBack.layer.shadowRadius = 10
//            viewBack.layer.cornerRadius = 6
//            viewBack.backgroundColor = .clear
//        }
//    }
//
//    @IBOutlet weak var ViewmessageText : UIView!{
//        didSet{
//            ViewmessageText.layer.masksToBounds = false
//            ViewmessageText.layer.shadowColor = ColorAppTheme.cgColor
//            ViewmessageText.layer.shadowOpacity = 10
//            ViewmessageText.layer.shadowOffset = CGSize(width: 0, height: 5)
//            ViewmessageText.layer.shadowRadius = 10
//            ViewmessageText.layer.cornerRadius = 6
//        }
//    }
//
//    @IBOutlet weak var Viewmessageline : UIView!{
//        didSet{
//            Viewmessageline.layer.masksToBounds = false
//            Viewmessageline.layer.shadowColor = ColorAppTheme.cgColor
//            Viewmessageline.layer.shadowOpacity = 10
//            Viewmessageline.layer.shadowOffset = CGSize(width: 0, height: 5)
//            Viewmessageline.layer.shadowRadius = 10
//            Viewmessageline.layer.cornerRadius = 6
//        }
//    }
//
//    @IBOutlet weak var viewMessageContainer : UIView! {
//        didSet {
//            viewMessageContainer.layer.masksToBounds = false
//            viewMessageContainer.layer.shadowColor = ColorAppTheme.cgColor
//            viewMessageContainer.layer.shadowOpacity = 10
//            viewMessageContainer.layer.shadowOffset = CGSize(width: 0, height: 5)
//            viewMessageContainer.layer.shadowRadius = 10
//            showHideVideoAudio()
//        }
//    }
//
//    static var msgCountpass: ((_ msgCount :Int)-> ())?
//
//    @IBOutlet weak var cnTextViewHeightHeight : NSLayoutConstraint!
//    @IBOutlet weak var btnSend : UIButton!
//    @IBOutlet weak var btnAutoDelete : UIButton!
//    @IBOutlet weak var btnAudioMsg : UIButton!
//    @IBOutlet weak var txtViewMessage : GenericTextView!
//    @IBOutlet weak var lblUserTitle : UILabel!
//    @IBOutlet weak var lblUserMessage : UILabel!
//    @IBOutlet weak var btnClose : UIButton!
//    @IBOutlet weak var audioMsgView: UIView!
//    @IBOutlet weak var audioMsgTimeLbl: UILabel!
//
//    var arrMembersGroup = [[String : Any]]()
//    var iObject : Any?
//
//
//    @IBOutlet var recordingTimeLabel: UILabel!
//    @IBOutlet var record_btn_ref: UIButton!
//    @IBOutlet var play_btn_ref: UIButton!
//
//    var messageInformation: TblMessages!
//    var autodelete = 0
//    var setautoDel_audio : Int?
//    var locationPicker : LocationPickerVC?
//    var isautoDeleteTime: String?
//    var isautoDeletevidoe = 0
//    var isautoDeleteLocation = 0
//    var latestFileName = ""
//    var UserID:Int?
//    var isSelected = false
//    var audioRecorder: AVAudioRecorder!
//    var audioPlayer : AVAudioPlayer!
//    var meterTimer:Timer!
//    var isAudioRecordingGranted: Bool!
//    var isRecording = false
//    var isPlaying = false
//    static var num = 0
//    var isChatType:Int?
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        Intilization()
//    }
//
//    //MARK:- #####################Intilization#####################
//    func Intilization(){
//        btnAutoDelete.isHidden = true
//        audioMsgView.isHidden = true
//        audioMsgTimeLbl.isHidden = true
//        audioMsgView.layer.cornerRadius = 8
//        audioMsgView.layer.masksToBounds = true
//        btnClose.addTarget(self, action: #selector(btnClickAction(_:)), for: .touchUpInside)
//        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.audioMsglongTaps(_:)))
//        self.btnAudioMsg.isUserInteractionEnabled = true
//        btnAudioMsg.addGestureRecognizer(longGesture)
//        btnAudioMsg.addTarget(self, action: #selector(self.audioMsglongTaps(_:)), for: .touchUpInside)
//    }
//    //MARK:- #####################btnClickAction#####################
//    @objc func btnClickAction(_ sender:UIButton){
//        self.removeFromSuperview()
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotificationForItemEdit"), object: nil)
//    }
//
//    func configureMessageReceiverCells(_ messageInfo: TblMessages?) {
//        messageInformation = messageInfo
//    }
//
//    func showHideVideoAudio() {
//        if !self.viewMessageContainer.isHidden {
//            GCDMainThread.async { [weak self]  () in
//                guard let `self` = self else { return }
//            }
//        } else {
//        }
//    }
//}
//
////MARK:- #####################Show MessageVie #####################
//extension SwipeReplayMsgView{
//    class func initHomeAddPostMenuViews() -> SwipeReplayMsgView{
//        let theHeight = CScreenHeight
//        let objHomeAddPostView : SwipeReplayMsgView = Bundle.main.loadNibNamed("SwipeReplayMsgView", owner: nil, options: nil)?.last as! SwipeReplayMsgView
//        objHomeAddPostView.frame = CGRect(x: 0, y: CScreenHeight - 182, width: CScreenWidth, height: CScreenHeight/4)
//        return objHomeAddPostView
//
//    }
//    func showPostOption(){
//        GCDMainThread.async {
//            self.layoutIfNeeded()
//        }
//    }
//
//    func showPostOptionGroup(_ arrMembersGroups:[[String : Any]]){
//        arrMembersGroup = arrMembersGroups
//        print("arrMesber\(arrMembersGroup)")
//
//    }
//
//    func showPostMessage(_ messageInfo: TblMessages?,UserId:Int,chatTypeMode:Int){
//        messageInformation = messageInfo
//        isChatType = chatTypeMode
//        if messageInfo?.msg_type == 1 {
//            GCDMainThread.async {
//                self.lblUserTitle.text = messageInfo?.full_name
//                self.lblUserMessage.text = messageInfo?.message
//                self.UserID = UserId
//            }
//        } else if messageInfo?.msg_type == 4{
//            self.lblUserTitle.text = messageInfo?.full_name
//            self.lblUserMessage.text =  "Voice messsage(\(messageInfo?.msgdate ?? ""))"
//            self.UserID = UserId
//        }
//    }
//}
//
////MARK:- #####################ButtonAction #####################
//extension SwipeReplayMsgView{
//    func resignKeyboards(){
//        UIApplication.shared.sendAction(#selector(resignFirstResponder), to: nil, from: nil, for: nil)
//    }
//    @IBAction func btnSendCLK(_ sender : UIButton){
//        if !txtViewMessage.text.trim.isBlank {
//            if isChatType == 1 {
//                if let userid = self.UserID{
//                    let channelId = CMQTTUSERTOPIC + "\(userid)"
//                    // Send message to both Login and front user...
//                    MIMQTT.shared().messagePaylaod(arrUser: ["\(appDelegate.loginUser?.user_id ?? 0)", "\(userid)"], channelId: channelId, message: txtViewMessage.text.trim, messageType: .text, chatType: .user, groupID: nil, is_auto_delete: 0)
//                    txtViewMessage.text = nil
//                    txtViewMessage.updatePlaceholderFrame(false)
//                    cnTextViewHeightHeight.constant = 34
//                    txtViewMessage.resignFirstResponder()
//                    btnSend.isUserInteractionEnabled = true
//                    btnSend.alpha = 0.5
//                    btnAutoDelete.isUserInteractionEnabled = true
//                    btnAutoDelete.isHidden = true
//                    btnAudioMsg.isHidden = false
//                    btnAutoDelete.alpha = 0.5
//                    self.removeFromSuperview()
//                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotificationForItemEdit"), object: nil)
//                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataSwiftForItemEdit"), object: nil)
//                }
//            }else {
//                let arrUserIDS = arrMembersGroup.map({$0.valueForString(key: CUserId) })
//                var groupIdcopied  = ""
//                if arrUserIDS.count > 0 {
//                    for maindata in arrMembersGroup{
//                        guard let groupIds = maindata[CGroupId] as? Int else{
//                            return
//                        }
//                        groupIdcopied = String(groupIds)
//                    }
//                    let channelId = CMQTTUSERTOPIC + groupIdcopied
//                    MIMQTT.shared().messagePaylaod(arrUser: arrUserIDS, channelId: channelId, message: txtViewMessage.text, messageType: .text, chatType: .group, groupID: groupIdcopied, is_auto_delete: 0)
//                    txtViewMessage.text = nil
//                    txtViewMessage.updatePlaceholderFrame(false)
//                    cnTextViewHeightHeight.constant = 34
//                    txtViewMessage.resignFirstResponder()
//                    btnSend.isUserInteractionEnabled = false
//                    btnSend.alpha = 0.5
//                    btnAutoDelete.isUserInteractionEnabled = true
//                    btnAutoDelete.isHidden = true
//                    btnAudioMsg.isHidden = false
//                    btnAutoDelete.alpha = 0.5
//                    self.removeFromSuperview()
//                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotificationForItemEdit"), object: nil)
//                }
//            }
//        }
//    }
//
//    @IBAction func btnAutoDeleteCLK(_ sender : UIButton){
//        weak var weakSelf = self
//        if !self.txtViewMessage.text.trim.isBlank {
//            if let userid = self.UserID{
//                let channelId = CMQTTUSERTOPIC + "\(userid)"
//                // Send message to both Login and front user...
//                MIMQTT.shared().messagePaylaod(arrUser: ["\(appDelegate.loginUser?.user_id ?? 0)", "\(userid)"], channelId: channelId, message: self.txtViewMessage.text.trim, messageType: .text, chatType: .user, groupID: nil, is_auto_delete: 1)
//                self.txtViewMessage.text = nil
//                self.txtViewMessage.updatePlaceholderFrame(false)
//                self.cnTextViewHeightHeight.constant = 34
//                self.txtViewMessage.resignFirstResponder()
//                self.btnSend.isUserInteractionEnabled = true
//                self.btnSend.alpha = 0.5
//                self.btnAutoDelete.isUserInteractionEnabled = true
//                self.btnAutoDelete.isHidden = true
//                self.btnAudioMsg.isHidden = false
//                self.btnAutoDelete.alpha = 0.5
//                self.removeFromSuperview()
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotificationForItemEdit"), object: nil)
//            }
//        }
//    }
//
//    @IBAction func btnAttachmentCLK(_ sender : UIButton){
//        self.resignKeyboards()
//        //        self.removeFromSuperview()
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "btnAttachment"), object: nil)
//
//    }
//}
//
////MARK:- TextView Delegate Methods
//extension SwipeReplayMsgView:GenericTextViewDelegate{
//    func genericTextViewDidChange(_ textView: UITextView, height: CGFloat) {
//        if textView.text.count < 1 || textView.text.trim.isBlank{
//            btnSend.isUserInteractionEnabled = false
//            btnAutoDelete.isUserInteractionEnabled = false
//            btnAudioMsg.isHidden = false
//            btnAutoDelete.isHidden = true
//            btnSend.alpha = 0.5
//            btnAutoDelete.alpha = 0.5
//        }else{
//            btnSend.isUserInteractionEnabled = true
//            btnAutoDelete.isUserInteractionEnabled = true
//            btnAutoDelete.isHidden = false
//            btnAudioMsg.isHidden = true
//            btnSend.alpha = 1
//            btnAutoDelete.alpha = 1
//        }
//    }
//
//}
//extension UIResponder {
//    public var parentViewController: UIViewController? {
//        return next as? UIViewController ?? next?.parentViewController
//    }
//}
////MARK :- ##############Audio sms send ################
//extension SwipeReplayMsgView {
//    @objc func audioMsglongTaps(_ sender: UIGestureRecognizer){
//        if sender.state == .ended {
//            //        self.removeFromSuperview()
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "AudioMsgEnd"), object: nil)
//        }else if sender.state == .began {
//            //            self.removeFromSuperview()
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "AudioMsgbegan"), object: nil)
//        }
//    }
//}

/*****************************************************************
 * Swipe repplay is send the messages to partcular users         *
 * swipe contatin the Audio and Auto Delete optin                *
 * swipeReply is sent messages one to one                        *
 *                                                               *
 *****************************************************************/

import UIKit
import AVFoundation
import MediaPlayer

protocol DatapassDelegate:class{
    func didButtonTapped()
}

class SwipeReplayMsgView: UIView, UITextViewDelegate{
    
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
            showHideVideoAudio()
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
    
    var arrMembersGroup = [[String : Any]]()
    var iObject : Any?
    
    
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
    var isChatType:Int?
    
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
extension SwipeReplayMsgView{
    class func initHomeAddPostMenuViews() -> SwipeReplayMsgView{
       
        let theHeight = CScreenHeight
        let objHomeAddPostView : SwipeReplayMsgView = Bundle.main.loadNibNamed("SwipeReplayMsgView", owner: nil, options: nil)?.last as! SwipeReplayMsgView
//        objHomeAddPostView.frame = CGRect(x: 0, y: CScreenHeight - 182, width: CScreenWidth, height: CScreenHeight/4)
        print("screenhight\(UIScreen.main.bounds.height)")
        objHomeAddPostView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height / 1.3 - 20   , width: CScreenWidth, height: CScreenHeight/4)
        return objHomeAddPostView
        
    }
    func showPostOption(){
        GCDMainThread.async {
            self.layoutIfNeeded()
//            view.deactivateAllConstraints()
        }
    }
    
    func showPostOptionGroup(_ arrMembersGroups:[[String : Any]]){
        arrMembersGroup = arrMembersGroups
        print("arrMesber\(arrMembersGroup)")
        
    }
    
    override func layoutSubviews() {
     
       
    }
    
    func showPostMessage(_ messageInfo: TblMessages?,UserId:Int,chatTypeMode:Int){
        messageInformation = messageInfo
        isChatType = chatTypeMode
        if messageInfo?.msg_type == 1 {
            GCDMainThread.async {
                self.lblUserTitle.text = messageInfo?.full_name
                self.lblUserMessage.text = messageInfo?.message
                self.UserID = UserId
            }
        } else if messageInfo?.msg_type == 4{
            self.lblUserTitle.text = messageInfo?.full_name
            self.lblUserMessage.text =  "Voice messsage(\(messageInfo?.msgdate ?? ""))"
            self.UserID = UserId
        }
    }
}

//MARK:- #####################ButtonAction #####################
extension SwipeReplayMsgView{
    func resignKeyboards(){
        UIApplication.shared.sendAction(#selector(resignFirstResponder), to: nil, from: nil, for: nil)
    }
    @IBAction func btnSendCLK(_ sender : UIButton){
        if !txtViewMessage.text.trim.isBlank {
            if isChatType == 1 {
                if let userid = self.UserID{
//                    let channelId = CMQTTUSERTOPIC + "\(userid)"
                    // Send message to both Login and front user...
//                    MIMQTT.shared().messagePaylaod(arrUser: ["\(appDelegate.loginUser?.user_id ?? 0)", "\(userid)"], channelId: channelId, message: txtViewMessage.text.trim, messageType: .text, chatType: .user, groupID: nil, is_auto_delete: 0)
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
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataSwiftForItemEdit"), object: nil)
                }
            }else {
                let arrUserIDS = arrMembersGroup.map({$0.valueForString(key: CUserId) })
                var groupIdcopied  = ""
                if arrUserIDS.count > 0 {
                    for maindata in arrMembersGroup{
                        guard let groupIds = maindata[CGroupId] as? Int else{
                            return
                        }
                        groupIdcopied = String(groupIds)
                    }
//                    let channelId = CMQTTUSERTOPIC + groupIdcopied
//                    MIMQTT.shared().messagePaylaod(arrUser: arrUserIDS, channelId: channelId, message: txtViewMessage.text, messageType: .text, chatType: .group, groupID: groupIdcopied, is_auto_delete: 0)
                    txtViewMessage.text = nil
                    txtViewMessage.updatePlaceholderFrame(false)
                    cnTextViewHeightHeight.constant = 34
                    txtViewMessage.resignFirstResponder()
                    btnSend.isUserInteractionEnabled = false
                    btnSend.alpha = 0.5
                    btnAutoDelete.isUserInteractionEnabled = true
                    btnAutoDelete.isHidden = true
                    btnAudioMsg.isHidden = false
                    btnAutoDelete.alpha = 0.5
                    self.removeFromSuperview()
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotificationForItemEdit"), object: nil)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataSwiftForItemEdit"), object: nil)
                }
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
extension SwipeReplayMsgView:GenericTextViewDelegate{
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
    public var parentViewController: UIViewController? {
        return next as? UIViewController ?? next?.parentViewController
    }
}
//MARK :- ##############Audio sms send ################
extension SwipeReplayMsgView {
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



extension UIStackView {
    @discardableResult
    func removeAllArrangedSubviews() -> [UIView] {
        return arrangedSubviews.reduce([UIView]()) { $0 + [removeArrangedSubViewProperly($1)] }
    }

    func removeArrangedSubViewProperly(_ view: UIView) -> UIView {
        removeArrangedSubview(view)
        NSLayoutConstraint.deactivate(view.constraints)
        view.removeFromSuperview()
        return view
    }
}
