//
//  GroupChatDetailsViewController.swift
//  Sevenchats
//
//  Created by mac-0005 on 31/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//
//
/********************************************************
 * Author :  Chandrika.R                                *
 * Model  : GroupChat Messages                          *
 * options: Group Messages & Notifications              *
 ********************************************************/

import UIKit
import CoreData
import AVFoundation
import MediaPlayer
import SDWebImage
import StompClientLib
import TrueTime

class GroupChatDetailsViewController: ParentViewController,MIAudioPlayerDelegate,SocketDelegate {
    
    
    let network = ChatSocketIo()
    
    weak var stompClientLibDelegte:StompClientLibDelegate?
    
    var serviceInstance: ChatSocketIo = ChatSocketIo()
    
    
    @IBOutlet weak var cnNavigationHeight : NSLayoutConstraint! {
        didSet {
            cnNavigationHeight.constant = IS_iPhone_X_Series ? 84 : 64
        }
    }
    
    @IBOutlet var cnVwMsgContainerBottom : NSLayoutConstraint! {
        didSet {
            cnVwMsgContainerBottom.constant = IS_iPhone_X_Series ? 34 : 0
        }
    }
    
    @IBOutlet weak var viewMessageContainer : UIView! {
        didSet {
            viewMessageContainer.layer.masksToBounds = false
            viewMessageContainer.layer.shadowColor = ColorAppTheme.cgColor
            viewMessageContainer.layer.shadowOpacity = 10
            viewMessageContainer.layer.shadowOffset = CGSize(width: 0, height: 5)
            viewMessageContainer.layer.shadowRadius = 10
        }
    }
    
    @IBOutlet weak var tblChat : UITableView! {
        didSet {
            tblChat.register(UINib(nibName: "ChatListHeaderView", bundle: Bundle.main), forHeaderFooterViewReuseIdentifier: "ChatListHeaderView")
            
            tblChat.register(UINib(nibName: "MessageReceiverTblCell", bundle: nil), forCellReuseIdentifier: "MessageReceiverTblCell")
            tblChat.register(UINib(nibName: "MessageSenderTblCell", bundle: nil), forCellReuseIdentifier: "MessageSenderTblCell")
            tblChat.register(UINib(nibName: "ImageSenderTblCell", bundle: nil), forCellReuseIdentifier: "ImageSenderTblCell")
            tblChat.register(UINib(nibName: "ImageReceiverTblCell", bundle: nil), forCellReuseIdentifier: "ImageReceiverTblCell")
            tblChat.register(UINib(nibName: "AudioReceiverTblCell", bundle: nil), forCellReuseIdentifier: "AudioReceiverTblCell")
            tblChat.register(UINib(nibName: "AudioSenderTblCell", bundle: nil), forCellReuseIdentifier: "AudioSenderTblCell")
            tblChat.register(UINib(nibName: "LocationSenderTblCell", bundle: nil), forCellReuseIdentifier: "LocationSenderTblCell")
            tblChat.register(UINib(nibName: "LocationReceiverTblCell", bundle: nil), forCellReuseIdentifier: "LocationReceiverTblCell")
            
            tblChat.estimatedRowHeight = 80;
            tblChat.allowsMultipleSelection = true
            tblChat.rowHeight = UITableView.automaticDimension;
            tblChat.transform = CGAffineTransform(rotationAngle: -.pi)
            tblChat.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: CScreenWidth-10)
        }
    }
    
    @IBOutlet weak var imgGroupIcon : UIImageView! {
        didSet {
            self.imgGroupIcon.layer.cornerRadius = self.imgGroupIcon.frame.height / 2
        }
    }
    
    @IBOutlet weak var lblUserBlockMessage : UILabel!
    @IBOutlet weak var btnMemberInfo : UIButton!
    @IBOutlet weak var txtViewMessage : GenericTextView!{
        didSet{
            self.txtViewMessage.txtDelegate = self
            self.txtViewMessage.type = "2"
            
        }
    }
    @IBOutlet weak var btnBack : UIButton!
    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var cnTextViewHeightHeight : NSLayoutConstraint!
    @IBOutlet weak var btnSend : UIButton!
    @IBOutlet private weak var btnVideo: UIButton!
    @IBOutlet private weak var btnAudio: UIButton!
    @IBOutlet weak var btnAutoDelete : UIButton!
    @IBOutlet weak var btnAudioMsg : UIButton!
    @IBOutlet weak var lblDeleteCount : UILabel!
    @IBOutlet weak var viewChatMoreitemsView : UIView!
    
    @IBOutlet weak var audioMsgView: UIView!
    @IBOutlet weak var audioMsgTimeLbl: UILabel!
    @IBOutlet weak var audioAnimation:UIImageView!
    
    @IBOutlet weak var btnSwipeforward : UIButton!
    @IBOutlet weak var btnCopy : UIButton!
    @IBOutlet weak var btnDelete : UIButton!
    @IBOutlet weak var btnForword : UIButton!
    
    var ctrl = false
    @IBOutlet weak var imgGIF: FLAnimatedImageView!
    
    //Recordvidoes
    @IBOutlet var recordingTimeLabel: UILabel!
    @IBOutlet var record_btn_ref: UIButton!
    @IBOutlet var play_btn_ref: UIButton!
    
    var fetchHome : DataSourceController!
    var audioReceiverCell : AudioReceiverTblCell!
    weak var audioSenderCell : AudioSenderTblCell!
    var isCreateNewChat : Bool!
    var arrMembers = [[String : Any]]()
    var isLoadMore = true
    var arrSelectedMediaForChat = [Any]()
    var strChannelId : String!
    var strSelectedAudioMessageID : String!
    var sessionTask : URLSessionTask!
    var refreshControl = UIRefreshControl()
    var locationPicker : LocationPickerVC?
    var userID: Int?
    var isautoDeleteTime: String?
    var topcName = ""
    
    var messageidListItems:[String] = []
    var pastebaord = UIPasteboard.general
    var isCopySeleted = false
    var audioRecorder: AVAudioRecorder!
    var audioPlayer : AVAudioPlayer!
    var meterTimer:Timer!
    var isAudioRecordingGranted: Bool!
    var isRecording = false
    var isPlaying = false
    var autodelete = 0
    var latestFileName = ""
    var group_id = ""
    var group_Name = ""
    var uploadImgUrl:String?
    var groupInfo = [String:Any]()
    var groupNotfInfo = [String:Any]()
    var groupInfoLatest = [String:Any]()
    var groupNotificaiton:Bool?
    
    var socketClient = StompClientLib()
    var timeClient: TrueTimeClient?
    var notificationGrp:Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ChatSocketIo.shared().SocketInitilized()
        ChatSocketIo.shared().socketDelegate = self
        self.getMessagesFromServer(isNew: true)
        Initialization()
        notificationObserver = nil
        NotificationCenter.default.addObserver(self, selector: #selector(self.MsgrecviedNotificationGrp(notification:)), name: Notification.Name("MsgrecviedNotificationGrp"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.LoadMsgData(notification:)), name: Notification.Name("LoadMsgData"), object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        notificationObserver = nil
        self.stopAllAudio()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.updateUIAccordingToLanguage()
        self.getGroupInformationFromServer()
        
        if self.arrSelectedMediaForChat.count > 0 {
            self.storeMediaToLocal(.image)
        }
        btnVideo.isHidden = true
        btnAudio.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.DidSelectCLK), name: NSNotification.Name(rawValue: "DidSelectCLK"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.DidDisSelectCLk), name: NSNotification.Name(rawValue: "DidDisSelectCLk"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.shouldReload), name: NSNotification.Name(rawValue: "newDataNotificationForItemEdit"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.AudioMsgEnd), name: NSNotification.Name(rawValue: "AudioMsgEnd"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.AudioMsgbegan), name: NSNotification.Name(rawValue: "AudioMsgbegan"), object: nil)
    }
    
    //funcation Create Topic
    func createTopictoChat(){
        if isCreateNewChat == false {
            ChatSocketIo.shared().createTopicTouser(userTopic:"/topic/" + group_id)
            print("::::::::Topic is Cretaed:::")
        }
    }
    
    @objc func shouldReload() {
        self.tblChat.scrollToBottom()
    }
    
    @objc func swipeEditReload(){
        self.tblChat.scrollToBottom()
        self.tblChat.reloadData()
    }
    
    var notificationObserver: Any? {
        willSet {
            if let observer = notificationObserver {
                NotificationCenter.default.removeObserver(observer)
            }
        }
    }
    //...GroupChat Messages Load
    func getMessagesLoadFromServer(){
        
        
        TblMessages.deleteAllObjects()
        if sessionTask != nil {
            if sessionTask.state == .running {
//                print(" Api calling continue =========")
                return
            }
        }
        
        var _ : Double = 0
        sessionTask = APIRequest.shared().userMesageListNew(chanelID: topcName) { [weak self] (response, error) in
            guard let self = self else { return }
            var txtmsg = ""
            self.refreshControl.endRefreshing()
            self.tblChat.tableFooterView = UIView()
            if response != nil && error == nil {
//                MILoader.shared.hideLoader()
                
                let resp = response as? [String] ?? []
                
                resp.forEach { item in
                    var imagepath = ""
                    var senders  = ""
                    var dict =  self.convertToDictionarywithtry(from: item)
                    let dictcont = dict?["content"]
                    dict?.removeValue(forKey: "content")
                    let dictcontent =  self.convertToDictionarywithtry(from: dictcont ?? "")
                    if dictcontent?["type"] == "image" || dictcontent?["type"] == "video" || dictcontent?["type"] == "audio" {
                        imagepath = dictcontent?["message"] ?? ""
                        txtmsg = imagepath
                    }else {
                        txtmsg = dictcontent?["message"] ?? ""
                    }
                    let timstmamp = dict?["timestamp"]?.replace(string: "T", replacement: " ")
                    //todo chagnes futures
//                    let chatTimeStamp = ""
                    let chatTimeStamp = (DateFormatter.shared().timestampGMTFromDateNew(date: timstmamp))?.toString
//
                    //todo chagnes futures
                    let create  = chatTimeStamp
                    if let sender = dict?["sender"]{
                        senders = sender
                    }
                    
                    let senderName = dict?["name"] ?? ""
                    let senderProfImg = dict?["profile_image"] ?? ""
//                    let timestamp2 = dict?["timestamp"]
                    
                    if dictcontent?["type"] == "image"{
                        ChatSocketIo.shared().messagePaylaodLast(arrUser: ["\(senders )"], channelId: self.topcName , message: txtmsg, messageType: .image, chatType: .user, groupID: nil, latitude: 0.0, longitude: 0.0, address: "", forwardedMsgId: "", cloleFile: nil, sender: senders , isSelected: true,createat: create ?? "" ,timestampDate:chatTimeStamp ?? "",senderName:senderName,SenderProfImg:senderProfImg)
                        UserDefaultHelper.userChatLastMsg = true
                        
                    }else if dictcontent?["type"] == "video"{
                        
                        ChatSocketIo.shared().messagePaylaodLast(arrUser: ["\(senders )"], channelId: self.topcName , message: txtmsg, messageType: .video, chatType: .user, groupID: nil, latitude: 0.0, longitude: 0.0, address: "", forwardedMsgId: "", cloleFile: nil, sender: senders , isSelected: true,createat: create ?? "" ,timestampDate:chatTimeStamp ?? "",senderName:senderName,SenderProfImg:senderProfImg)
                        UserDefaultHelper.userChatLastMsg = true
                        
                    }else if dictcontent?["type"] == "audio"{
                        ChatSocketIo.shared().messagePaylaodLast(arrUser: ["\(senders )"], channelId: self.topcName , message: txtmsg, messageType: .audio, chatType: .user, groupID: nil, latitude: 0.0, longitude: 0.0, address: "", forwardedMsgId: "", cloleFile: nil, sender: senders , isSelected: true,createat: create ?? "" ,timestampDate:chatTimeStamp ?? "",senderName:senderName,SenderProfImg:senderProfImg)
                        UserDefaultHelper.userChatLastMsg = true
                        
                    }else {
                        ChatSocketIo.shared().messagePaylaodLast(arrUser: ["\(senders )"], channelId: self.topcName , message: txtmsg, messageType: .text, chatType: .user, groupID: nil, latitude: 0.0, longitude: 0.0, address: "", forwardedMsgId: "", cloleFile: nil, sender: senders , isSelected: true,createat: create ?? "",timestampDate:chatTimeStamp ?? "",senderName:senderName,SenderProfImg:senderProfImg)
                        UserDefaultHelper.userChatLastMsg = true
                    }
                    
                }
                self.fetchHome.loadData()
                
            }
        }
    }
    
    
    @objc func LoadMsgData(notification: Notification){
        getMessagesLoadFromServer(isNew : true)
    }

    
    @objc func AudioMsgEnd(){
        audioMsgView.isHidden = true
        audioMsgTimeLbl.isHidden = false
        txtViewMessage.isHidden = false
        txtViewMessage.placeHolder = ""
        self.isRecordingfunc(_isRecording: false)
        self.tblChat.scrollToBottom()
    }
    
    @objc func AudioMsgbegan(){
        txtViewMessage.placeHolder = ""
        audioMsgView.isHidden = false
        txtViewMessage.isHidden = true
        self.isRecordingfunc(_isRecording: true)
        self.tblChat.scrollToBottom()
        
    }
    
    //Refresh Messages
    @objc func didRefreshMessages() {
        isLoadMore = false
        // Update chat message table from local..
        if fetchHome != nil {
            fetchHome.loadData()
        }
        GCDMainThread.asyncAfter(deadline: .now() + 2) {
            self.isLoadMore = true
        }
    }
    // MARK:- --------- Initialization
    // MARK:-
    func Initialization() {
        GCDMainThread.async {
            self.tblChat.reloadData()
        }
        if let _locationPicker = CStoryboardLocationPicker.instantiateViewController(withIdentifier: "LocationPickerVC") as? LocationPickerVC {
            _locationPicker.showConfirmAlertOnSelectLocation = true
            locationPicker = _locationPicker
        }
        
        MIAudioPlayer.shared().miAudioPlayerDelegate = self
        GCDMainThread.async {
            self.refreshControl.addTarget(self, action: #selector(self.pullToRefresh), for: .valueChanged)
            self.refreshControl.tintColor = ColorAppTheme
            self.tblChat.pullToRefreshControl = self.refreshControl
        }
        createTopictoChat()
        self.setGroupDetails()
        self.setFetchController()
    }
    
    func updateUIAccordingToLanguage() {
        
        if Localization.sharedInstance.applicationFlowWithLanguageRTL() {
            // Reverse Flow...
            btnBack.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblTitle.textAlignment = .right
        }else {
            // Normal Flow...
            lblTitle.textAlignment = .left
            btnBack.transform = CGAffineTransform.identity
        }
        txtViewMessage.placeHolder = CMessageTypeYourMessage
    }
    
    // MARK:Auto Delete Check Status
    func checkAutoDeleteStatus(){
        
    }
    
}

extension GroupChatDetailsViewController {
    @objc func singlelPress(_ sender: UIGestureRecognizer){
        MIToastAlert.shared.showToastAlert(position: .bottom, message: "Hold to record,Relase to send " )
    }
    @objc func audioMsglongTap(_ sender: UIGestureRecognizer){
        
        if sender.state == .ended {
            self.audioMsgView.isHidden = true
            self.audioMsgTimeLbl.isHidden = true
            self.txtViewMessage.isHidden = false
            self.txtViewMessage.placeHolder = ""
            self.isRecordingfunc(_isRecording: false)
        }
        else if sender.state == .began {
            self.txtViewMessage.placeHolder = ""
            self.txtViewMessage.isHidden = true
            
            self.isRecordingfunc(_isRecording: true)
            self.imgGIF.isHidden = false
            
            if let path =  Bundle.main.path(forResource: "microphone", ofType: "gif") {
                if let data = NSData(contentsOfFile: path) {
                    let gif = FLAnimatedImage(animatedGIFData: data as Data)
                    imgGIF.animatedImage = gif
                }
            }
        }
    }
    
    func isRecordingfunc(_isRecording:Bool){
        if(isRecording){
            finishAudioRecording(success: true)
            isRecording = false
        }else{
            
            audioMsgView.isHidden = false
            audioMsgTimeLbl.isHidden = false
            setup_recorder()
            audioRecorder.record()
            meterTimer = Timer.scheduledTimer(timeInterval: 0.1, target:self, selector:#selector(self.updateAudioMeter(timer:)), userInfo:nil, repeats:true)
            isRecording = true
        }
        
    }
}


//MARK:Audio Delegate Methods

extension GroupChatDetailsViewController:AVAudioRecorderDelegate, AVAudioPlayerDelegate{
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool){
        if !flag{
            finishAudioRecording(success: false)
        }
    }
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool){
        //    record_btn_ref.isEnabled = true
    }
}


// MARK:- --------- Api Functions
// MARK:-
extension GroupChatDetailsViewController {
    // Set Group details here....
    func setGroupDetails() {
        
        if let groupInfo = self.iObject as? [String : Any] {
            lblTitle.text = groupInfo.valueForString(key: CGroupTitle)
            imgGroupIcon.loadImageFromUrl(groupInfo.valueForString(key: CGroupImage), true)
            btnMemberInfo.isHidden = true
            if Int64(groupInfo.valueForString(key: CCreated_By)) == appDelegate.loginUser?.user_id {
                btnMemberInfo.isHidden = !(groupInfo.valueForInt(key: CGroupPendingRequest)! > 0)
            }
            
            if groupInfo.valueForInt(key: CBlock_unblock_status) == 1 {
                // Hide chatting controls for block user.
                self.viewMessageContainer.isHidden = true
                self.cnTextViewHeightHeight.constant = 50
                self.lblUserBlockMessage.isHidden = false
                self.lblUserBlockMessage.text = CMessageOtherUserBlock
            }else {
                self.cnTextViewHeightHeight.constant = 34
                self.viewMessageContainer.isHidden = false
                self.lblUserBlockMessage.isHidden = true
            }
        }
    }
    
//    fileprivate func getGroupInformationFromServer() {
//        if let groupInfo = self.iObject as? [String : Any] {
//            APIRequest.shared().groupDetail(group_id: groupInfo.valueForString(key: CGroupId),shouldShowLoader:false) { (response, error) in
//                if response != nil && error == nil{
//                    DispatchQueue.main.async {
//                        if let groupInfo = response?[CJsonData] as? [[String : Any]] {
//                            self.iObject = groupInfo
//                            self.setGroupDetails()
//                            for groupDetails in groupInfo{
//                                self.group_id = groupDetails["group_id"] as? String ?? ""
//                                if let uesrInfo = groupDetails[CAPITFriendsList] as? [[String : Any]] {
//                                    self.arrMembers = uesrInfo
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
    
    fileprivate func getGroupInformationFromServer() {
            if let groupInfo = self.iObject as? [String : Any] {
                APIRequest.shared().groupDetail(group_id: groupInfo.valueForString(key: CGroupId),shouldShowLoader:false) { (response, error) in
                    if response != nil && error == nil{
                        DispatchQueue.main.async {
                            if let JSON = response as? [String : Any] {
                                if let groupinfor =  JSON["data"] as? [[String : Any]] {
                                    //                                   if let groupInfo = groupinfor{
                                    self.iObject = groupinfor
                                    self.setGroupDetails()
                                    for groupDetails in groupinfor{
                                        self.group_id = groupDetails["group_id"] as? String ?? ""
                                        if let uesrInfo = groupDetails[CAPITFriendsList] as? [[String : Any]] {
                                            self.arrMembers = uesrInfo
                                        }
                                    }
                                }
                            }
                            
                        }
                    }
                }
            }
        }
    
    
    @objc fileprivate func pullToRefresh() {
        if sessionTask != nil {
            if sessionTask!.state == .running {
                return
            }
        }
        getMessagesFromServer(isNew: true)
        refreshControl.beginRefreshing()
    }
    
    func getMessagesFromServer(isNew : Bool) {
        
        TblMessages.deleteAllObjects()
        if sessionTask != nil {
            if sessionTask.state == .running {
                print(" Api calling continue =========")
                return
            }
        }
        var _ : Double = 0
        sessionTask = APIRequest.shared().userMesageListNew(chanelID: group_id) { [weak self] (response, error) in
            guard let self = self else { return }
            var txtmsg = ""
            self.refreshControl.endRefreshing()
            self.tblChat.tableFooterView = UIView()
            if response != nil && error == nil {
                let resp = response as? [String] ?? []
                
                resp.forEach { item in
                    var imagepath = ""
                    var senders  = ""
                    var dict =  self.convertToDictionarywithtry(from: item)
                    let dictcont = dict?["content"]
                    dict?.removeValue(forKey: "content")
                    var dictcontent =  self.convertToDictionarywithtry(from: dictcont ?? "")
                    if dictcontent?["type"] == "image" || dictcontent?["type"] == "video" || dictcontent?["type"] == "audio" {
                        imagepath = dictcontent?["message"] ?? ""
                        txtmsg = imagepath
                    }else {
                        txtmsg = dictcontent?["message"] ?? ""
                    }
                    
                    let senderName = dictcontent?["name"] ?? ""
                    let senderProfImg = dictcontent?["profile_image"] ?? ""
                    let timstmamp = dict?["timestamp"]?.replace(string: "T", replacement: " ")
                    let chatTimeStamp = DateFormatter.shared().timestampGMTFromDateNew(date: timstmamp)
                    let create  = chatTimeStamp?.toString
                    if let sender = dict?["sender"]{
                        senders = sender
                    }
                    let timestamp2 = dict?["timestamp"]
                    
                    if dictcontent?["type"] == "image"{
                        
                        ChatSocketIo.shared().messagePaylaodLast(arrUser: ["\(senders )"], channelId: self.group_id , message: txtmsg, messageType: .image, chatType: .group, groupID: self.group_id, latitude: 0.0, longitude: 0.0, address: "", forwardedMsgId: "", cloleFile: nil, sender: senders , isSelected: true,createat: create ?? "",timestampDate:timestamp2 ?? "",senderName:senderName,SenderProfImg:senderProfImg)
                        UserDefaultHelper.userChatLastMsg = true
                        
                    }else if dictcontent?["type"] == "video"{
                        
                        ChatSocketIo.shared().messagePaylaodLast(arrUser: ["\(senders )"], channelId: self.group_id , message: txtmsg, messageType: .video, chatType: .group, groupID: self.group_id, latitude: 0.0, longitude: 0.0, address: "", forwardedMsgId: "", cloleFile: nil, sender: senders , isSelected: true,createat: create ?? "",timestampDate:timestamp2 ?? "",senderName:senderName,SenderProfImg:senderProfImg)
                        UserDefaultHelper.userChatLastMsg = true
                        
                    }else if dictcontent?["type"] == "audio"{
                        ChatSocketIo.shared().messagePaylaodLast(arrUser: ["\(senders )"], channelId: self.group_id , message: txtmsg, messageType: .audio, chatType: .group, groupID: self.group_id, latitude: 0.0, longitude: 0.0, address: "", forwardedMsgId: "", cloleFile: nil, sender: senders , isSelected: true,createat: create ?? "",timestampDate:timestamp2 ?? "",senderName:senderName,SenderProfImg:senderProfImg)
                        UserDefaultHelper.userChatLastMsg = true
                        
                    }else {
                        
                        ChatSocketIo.shared().messagePaylaodLast(arrUser: ["\(senders )"], channelId: self.group_id , message: txtmsg, messageType: .text, chatType: .group, groupID: self.group_id, latitude: 0.0, longitude: 0.0, address: "", forwardedMsgId: "", cloleFile: nil, sender: senders , isSelected: true,createat: create ?? "",timestampDate:timestamp2 ?? "",senderName:senderName,SenderProfImg:senderProfImg)
                        UserDefaultHelper.userChatLastMsg = true
                    }
                    
                }
                self.fetchHome.loadData()
                
            }
        }
        
    }
    //...GetMessages from Server
    func getMessagesLoadFromServer(isNew : Bool) {
        
        TblMessages.deleteAllObjects()
//        if sessionTask != nil {
//            if sessionTask.state == .running {
//                print(" Api calling continue =========")
//                return
//            }
//        }
        var _ : Double = 0
        sessionTask = APIRequest.shared().userMesageListNew(chanelID: group_id) { [weak self] (response, error) in
            guard let self = self else { return }
            var txtmsg = ""
//            self.refreshControl.endRefreshing()
            self.tblChat.tableFooterView = UIView()
            if response != nil && error == nil {
                let resp = response as? [String] ?? []
                
                resp.forEach { item in
                    var imagepath = ""
                    var senders  = ""
                    var dict =  self.convertToDictionarywithtry(from: item)
                    let dictcont = dict?["content"]
                    dict?.removeValue(forKey: "content")
                    var dictcontent =  self.convertToDictionarywithtry(from: dictcont ?? "")
                    if dictcontent?["type"] == "image" || dictcontent?["type"] == "video" || dictcontent?["type"] == "audio" {
                        imagepath = dictcontent?["message"] ?? ""
                        txtmsg = imagepath
                    }else {
                        txtmsg = dictcontent?["message"] ?? ""
                    }
                    
                    let senderName = dictcontent?["name"] ?? ""
                    let senderProfImg = dictcontent?["profile_image"] ?? ""
                    let timstmamp = dict?["timestamp"]?.replace(string: "T", replacement: " ")
                    let chatTimeStamp = DateFormatter.shared().timestampGMTFromDateNew(date: timstmamp)
                    let create  = chatTimeStamp?.toString
                    if let sender = dict?["sender"]{
                        senders = sender
                    }
                    let timestamp2 = dict?["timestamp"]
                    
                    if dictcontent?["type"] == "image"{
                        
                        ChatSocketIo.shared().messagePaylaodLast(arrUser: ["\(senders )"], channelId: self.group_id , message: txtmsg, messageType: .image, chatType: .group, groupID: self.group_id, latitude: 0.0, longitude: 0.0, address: "", forwardedMsgId: "", cloleFile: nil, sender: senders , isSelected: true,createat: create ?? "",timestampDate:timestamp2 ?? "",senderName:senderName,SenderProfImg:senderProfImg)
                        UserDefaultHelper.userChatLastMsg = true
                        
                    }else if dictcontent?["type"] == "video"{
                        
                        ChatSocketIo.shared().messagePaylaodLast(arrUser: ["\(senders )"], channelId: self.group_id , message: txtmsg, messageType: .video, chatType: .group, groupID: self.group_id, latitude: 0.0, longitude: 0.0, address: "", forwardedMsgId: "", cloleFile: nil, sender: senders , isSelected: true,createat: create ?? "",timestampDate:timestamp2 ?? "",senderName:senderName,SenderProfImg:senderProfImg)
                        UserDefaultHelper.userChatLastMsg = true
                        
                    }else if dictcontent?["type"] == "audio"{
                        ChatSocketIo.shared().messagePaylaodLast(arrUser: ["\(senders )"], channelId: self.group_id , message: txtmsg, messageType: .audio, chatType: .group, groupID: self.group_id, latitude: 0.0, longitude: 0.0, address: "", forwardedMsgId: "", cloleFile: nil, sender: senders , isSelected: true,createat: create ?? "",timestampDate:timestamp2 ?? "",senderName:senderName,SenderProfImg:senderProfImg)
                        UserDefaultHelper.userChatLastMsg = true
                        
                    }else {
                        
                        ChatSocketIo.shared().messagePaylaodLast(arrUser: ["\(senders )"], channelId: self.group_id , message: txtmsg, messageType: .text, chatType: .group, groupID: self.group_id, latitude: 0.0, longitude: 0.0, address: "", forwardedMsgId: "", cloleFile: nil, sender: senders , isSelected: true,createat: create ?? "",timestampDate:timestamp2 ?? "",senderName:senderName,SenderProfImg:senderProfImg)
                        UserDefaultHelper.userChatLastMsg = true
                    }
                    
                }
                self.fetchHome.loadData()
                
            }
        }
        
    }
    
    fileprivate func storeMediaToLocal(_ mediaType: MessageType, latitude:Double = 0.0, longitude:Double = 0.0, address: String = "") {
        
        // Send Message to all user...
        let arrUserIDS = arrMembers.map({$0.valueForString(key: CUserId) })
        if arrUserIDS.count > 0 {
            for media in self.arrSelectedMediaForChat {
                if mediaType == .image {
                    if let img = media as? UIImage {
                        
                        guard let mobileNum = appDelegate.loginUser?.mobile else { return }
                        MInioimageupload.shared().uploadMinioimages(mobileNo: mobileNum, ImageSTt: img,isFrom:"",uploadFrom:"")
                        MInioimageupload.shared().callback = { message in
                            print("UploadImage::::::::::::::\(message)")
                            self.uploadImgUrl = message
                            self.ImageAttachemntApiCall(uploadImgUrl:self.uploadImgUrl ?? "",type:"image", thumbLine: img)
                        }
                        //.....Store Image in Directory...
                        let documentsDirectory = self.applicationDocumentsDirectory()
                        let imgName = "/\(CApplicationName ?? "sevenchat")_\(Int(Date().currentTimeStamp * 1000)).jpg"
                        _ = documentsDirectory?.appending(imgName)
                        _ =  img.jpegData(compressionQuality: 1.0)
                    }
                } else if mediaType == .video && self.arrSelectedMediaForChat.count > 0 {
                    if let videoURL = self.arrSelectedMediaForChat.first as? String {
                        
                        var urlVidoes = UIImage()
                        let ThumbImageView = UIImageView()
                        if let urlVideo = URL(string: videoURL){
                            self.getThumbnailImageFromVideoUrl(url: urlVideo) { (thumbNailImage) in
                                ThumbImageView.image = thumbNailImage
                                guard let urlVid = ThumbImageView.image else { return }
                                urlVidoes = urlVid
                            }
                        }
                        guard let mobileNum = appDelegate.loginUser?.mobile else { return }
                        MInioimageupload.shared().uploadMinioimages(mobileNo: mobileNum, ImageSTt: urlVidoes,isFrom:"videos",uploadFrom:videoURL)
                        MInioimageupload.shared().callback = { message in
                            print("UploadImage::::::::::::::\(message)")
                            self.uploadImgUrl = message
                            self.ImageAttachemntApiCall(uploadImgUrl:self.uploadImgUrl ?? "",type:"video", thumbLine: urlVidoes)
                        }
                        
                    }
                } else if mediaType == .audio && self.arrSelectedMediaForChat.count > 0 {
                    if let audioURL = self.arrSelectedMediaForChat.first as? String {
                        
                        var urlVidoes = UIImage()
                        let ThumbImageView = UIImageView()
                        if let urlVideo = URL(string: audioURL){
                            self.getThumbnailImageFromVideoUrl(url: urlVideo) { (thumbNailImage) in
                                ThumbImageView.image = thumbNailImage
                                guard let urlVid = ThumbImageView.image else { return }
                                urlVidoes = urlVid
                            }
                        }
                        
                        guard let mobileNum = appDelegate.loginUser?.mobile else { return }
                        MInioimageupload.shared().uploadMinioimages(mobileNo: mobileNum, ImageSTt: urlVidoes,isFrom:"audio",uploadFrom:audioURL)
                        MInioimageupload.shared().callback = { message in
                            print("UploadImage::::::::::::::\(message)")
                            self.uploadImgUrl = message
                            self.ImageAttachemntApiCall(uploadImgUrl:self.uploadImgUrl ?? "",type:"audio", thumbLine: urlVidoes)
                        }
                    }
                }else if mediaType == .location && self.arrSelectedMediaForChat.count > 0 {
                    guard let img = media as? UIImage else{
                        return
                    }
                    //.....Store Image in Directory...
                    let documentsDirectory = self.applicationDocumentsDirectory()
                    let imgName = "/\(CApplicationName ?? "sevenchat")_\(Int(Date().currentTimeStamp * 1000)).jpg"
                    let imgPath = documentsDirectory?.appending(imgName)
                    let imageData =  img.jpegData(compressionQuality: 1.0)
                    if let path = imgPath {
                        let imgURL = URL(fileURLWithPath: path)
                        try! imageData?.write(to: imgURL, options: .atomicWrite)
                        
                        guard let mobileNum = appDelegate.loginUser?.mobile else { return }
                        MInioimageupload.shared().uploadMinioimages(mobileNo: mobileNum, ImageSTt: img,isFrom:"",uploadFrom:"")
                        MInioimageupload.shared().callback = { message in
                            print("UploadImage::::::::::::::\(message)")
                            
                            self.uploadImgUrl = message
                            self.ImageAttachemntApiCall(uploadImgUrl:self.uploadImgUrl ?? "",type:"image", thumbLine: img)
                            
                        }
                        
                    }
                }
            }
            
            self.arrSelectedMediaForChat.removeAll()
            // Upload media on server...
            //                self.uploadMediaFileToServer()
            //            }
        }
    }
    
    // Upload media on server....
    fileprivate func uploadMediaFileToServer() {
        if let groupInfo = self.iObject as? [String : Any] {
            let channelId = CMQTTUSERTOPIC + groupInfo.valueForString(key: CGroupId)
            //            MIMQTT.shared().syncUnsentMediaToServer(channelId)
            self.tblChat.scrollToBottom()
        }
    }
    
}


// MARK:- --------- FetchController
// MARK:-
extension GroupChatDetailsViewController {
    
    func setFetchController() {
//        createTopictoChat()
        if notificationGrp == true {
            createTopictoChat()
        }
        
        fetchHome = nil;
        strChannelId = group_id
        fetchHome = self.fetchController(listView: tblChat, entity: "TblMessages", sortDescriptors: [NSSortDescriptor.init(key: CCreated_at, ascending: false)], predicate: NSPredicate(format: "\(CChannel_id) == %@", strChannelId as CVarArg), sectionKeyPath: "msgdate", cellIdentifier: "MessageSenderTblCell", batchSize: 20) { (indexpath, cell, item) -> (Void) in
            
            if indexpath == self.tblChat.lastIndexPath() && self.isLoadMore && self.sessionTask != nil{
                if self.sessionTask.state != .running {
                    print("Load more data ====== ")
                }
            }
            
            let messageInfo = item as! TblMessages
            
            switch messageInfo.msg_type {
            case 1:
                // TEXT MESSAGE
                if messageInfo.sender_id == appDelegate.loginUser?.user_id {
                    let cellSender = cell as! MessageSenderTblCell
                    cellSender.rotateCell()
                    cellSender.configureMessageSenderCell(messageInfo,true)
                }else {
                    let cellReceiver = cell as! MessageReceiverTblCell
                    cellReceiver.rotateCell()
                    cellReceiver.configureMessageReceiverCell(messageInfo)
                }
                
                break
            case 2:
                // IMAGE MESSAGE
                if messageInfo.sender_id == appDelegate.loginUser?.user_id {
                    let cellSender = cell as! ImageSenderTblCell
                    cellSender.rotateCell()
                    cellSender.configureImageSenderCell(messageInfo,true)
                }else {
                    let cellReceiver = cell as! ImageReceiverTblCell
                    cellReceiver.rotateCell()
                    cellReceiver.configureImageReceiverCell(messageInfo)
                }
                
                break
            case 3:
                // VIDEO MESSAGE
                if messageInfo.sender_id == appDelegate.loginUser?.user_id {
                    let cellSender = cell as! ImageSenderTblCell
                    cellSender.rotateCell()
                    cellSender.configureImageSenderCell(messageInfo,true)
                }else {
                    let cellReceiver = cell as! ImageReceiverTblCell
                    cellReceiver.rotateCell()
                    cellReceiver.configureImageReceiverCell(messageInfo)
                }
                break
            case 4:
                // AUDIO MESSAGE
                if messageInfo.sender_id == appDelegate.loginUser?.user_id {
                    let cellSender = cell as! AudioSenderTblCell
                    cellSender.rotateCell()
                    cellSender.configureAudioSenderCell(messageInfo,true)
                    cellSender.audioSenderCellDelegate = self
                    
                    if let selectedID = self.strSelectedAudioMessageID, selectedID == messageInfo.message_id {
                        cellSender.btnPlayPause.isSelected = MIAudioPlayer.shared().isPlaying()
                        cellSender.audioSlider.isUserInteractionEnabled = MIAudioPlayer.shared().isPlaying()
                    }else{
                        cellSender.btnPlayPause.isSelected = false
                        cellSender.audioSlider.value = 0
                        cellSender.audioSlider.isUserInteractionEnabled = false
                    }
                }else {
                    let cellReceiver = cell as! AudioReceiverTblCell
                    cellReceiver.rotateCell()
                    cellReceiver.configureAudioReceiverCell(messageInfo)
                    cellReceiver.audioReceiverCellDelegate = self
                    cellReceiver.tag = indexpath.row
                    
                    if let selectedID = self.strSelectedAudioMessageID, selectedID == messageInfo.message_id {
                        cellReceiver.btnPlayPause.isSelected = MIAudioPlayer.shared().isPlaying()
                        cellReceiver.audioSlider.isUserInteractionEnabled = MIAudioPlayer.shared().isPlaying()
                    }else{
                        cellReceiver.btnPlayPause.isSelected = false
                        cellReceiver.audioSlider.value = 0
                        cellReceiver.audioSlider.isUserInteractionEnabled = false
                    }
                }
                
                break
            case 6:
                // SHARE LOCATION
                if messageInfo.sender_id == appDelegate.loginUser?.user_id {
                    let cellSender = cell as! LocationSenderTblCell
                    cellSender.rotateCell()
                    cellSender.configureImageSenderCell(messageInfo,true)
                }else {
                    let cellReceiver = cell as! LocationReceiverTblCell
                    cellReceiver.rotateCell()
                    cellReceiver.configureImageReceiverCell(messageInfo)
                }
                
                break
            default:
                break
            }
        }
        
        fetchHome.blockIdentifierForRow = { (_ indexPath:IndexPath, _ item:AnyObject?) in
            
            let messageInfo = item as! TblMessages
            switch messageInfo.msg_type {
            case 1:
                return messageInfo.sender_id == appDelegate.loginUser?.user_id ? "MessageSenderTblCell" : "MessageReceiverTblCell"
            case 2:
                return messageInfo.sender_id == appDelegate.loginUser?.user_id ? "ImageSenderTblCell" : "ImageReceiverTblCell"
            case 3:
                return messageInfo.sender_id == appDelegate.loginUser?.user_id ? "ImageSenderTblCell" : "ImageReceiverTblCell"
            case 6:
                return messageInfo.sender_id == appDelegate.loginUser?.user_id ? "LocationSenderTblCell" : "LocationReceiverTblCell"
            default:
                return messageInfo.sender_id == appDelegate.loginUser?.user_id ? "AudioSenderTblCell" : "AudioReceiverTblCell"
            }
        }
        fetchHome.blockIdentifierForFooter = { (_ sectionIndex:Int, _ info:NSFetchedResultsSectionInfo?) in
            return "ChatListHeaderView"
        }
        fetchHome.blockViewForFooter = { (_ section:UIView?, _ index:Int, _ info:NSFetchedResultsSectionInfo?) in
            let headerView =  section as! ChatListHeaderView
            var headerDate = DateFormatter.dateStringFrom(timestamp: Double("\(info?.name ?? "0")")!, withFormate: "dd MMMM yyyy")
            let currentDate = DateFormatter.shared().string(fromDate: Date(), dateFormat: "dd MMMM yyyy")
            let YesterdayDate = DateFormatter.shared().string(fromDate: Date().dateByAdd(days: -1), dateFormat: "dd MMMM yyyy")
            if headerDate == currentDate {
                headerDate = CToday
            }else if headerDate == YesterdayDate {
                headerDate = CYesterday
                
            }
            headerView.lblDate.text = headerDate.uppercased()
        }
        fetchHome.blockHeightForFooter = { (_ sectionIndex:Int, _ info:NSFetchedResultsSectionInfo?) in
            return 50/375*CScreenWidth
        }
        fetchHome.loadData()
    }
}

// MARK:-  --------- AudioReceiverCellDelegate/AudioSenderCellDelegate
// MARK:-
extension GroupChatDetailsViewController: AudioReceiverCellDelegate, AudioSenderCellDelegate {
    func cell(_ cell: AudioSenderTblCell, isPlay: Bool?) {
        
        // Pause Receiver Cell audio...
        if let cellRec = audioReceiverCell {
            audioReceiverCell = nil
            self.strSelectedAudioMessageID = nil
            MIAudioPlayer.shared().stopTrack()
            cellRec.btnPlayPause.isSelected = false
            cellRec.audioSlider.isUserInteractionEnabled = false
            cellRec.audioSlider.value = 0.0
        }
        
        if let cellSend = audioSenderCell {
            cellSend.btnPlayPause.isSelected = false
            cellSend.audioSlider.isUserInteractionEnabled = false
            MIAudioPlayer.shared().pauseTrack()
            
            if isPlay!{ // If playing new song that time set slider value = 0
                cellSend.audioSlider.value = 0.0
            }
            
        }
        
        if isPlay! {
            if let selectedID = self.strSelectedAudioMessageID, selectedID == cell.messageInformation.message_id {
                // If playing same song
                MIAudioPlayer.shared().playTrack()
            }else{
                MIAudioPlayer.shared().prepareTrack(cell.audioUrl)
            }
            
            self.audioSenderCell = cell
            self.strSelectedAudioMessageID = cell.messageInformation.message_id
            self.audioSenderCell.btnPlayPause.isSelected = true
            self.audioSenderCell.audioSlider.isUserInteractionEnabled = true
        }
    }
    
    func cell(_ cell: AudioReceiverTblCell, isPlay: Bool?) {
        
        // Pause Sender Cell audio...
        if let cellSend = audioSenderCell {
            audioSenderCell = nil
            self.strSelectedAudioMessageID = nil
            MIAudioPlayer.shared().stopTrack()
            cellSend.btnPlayPause.isSelected = false
            cellSend.audioSlider.isUserInteractionEnabled = false
            cellSend.audioSlider.value = 0.0
        }
        
        if let cellRec = audioReceiverCell {
            cellRec.btnPlayPause.isSelected = false
            cellRec.audioSlider.isUserInteractionEnabled = false
            MIAudioPlayer.shared().pauseTrack()
            
            if isPlay!{ // If playing new song that time set slider value = 0
                cellRec.audioSlider.value = 0.0
            }
        }
        
        if isPlay! {
            if let selectedID = self.strSelectedAudioMessageID, selectedID == cell.messageInformation.message_id {
                // If playing same song
                MIAudioPlayer.shared().playTrack()
            }else{
                MIAudioPlayer.shared().prepareTrack(cell.audioUrl)
            }
            
            self.audioReceiverCell = cell
            self.strSelectedAudioMessageID = cell.messageInformation.message_id
            self.audioReceiverCell.btnPlayPause.isSelected = true
            self.audioReceiverCell.audioSlider.isUserInteractionEnabled = true
        }
    }
    
    func stopAllAudio(){
        
        // Stop Sender audio file
        if let cellSend = audioSenderCell {
            audioSenderCell = nil
            self.strSelectedAudioMessageID = nil
            MIAudioPlayer.shared().stopTrack()
            cellSend.btnPlayPause.isSelected = false
            cellSend.audioSlider.isUserInteractionEnabled = false
            cellSend.audioSlider.value = 0.0
        }
        
        // Stop Receiver audio file
        if let cellRec = audioReceiverCell {
            audioReceiverCell = nil
            self.strSelectedAudioMessageID = nil
            MIAudioPlayer.shared().stopTrack()
            cellRec.btnPlayPause.isSelected = false
            cellRec.audioSlider.isUserInteractionEnabled = false
            cellRec.audioSlider.value = 0.0
        }
    }
}

// MARK:- -------- MIAudioPlayerDelgate
// MARK:-
extension GroupChatDetailsViewController {
    func MIAudioPlayerDidFinishPlaying(successfully flag: Bool) {
        print("MIAudioPlayerDidFinishPlaying ==== ")
        
        if flag{
            self.stopAllAudio()
        }
    }
    
    func MIAudioPlayerDidUpdateTime(_ currentTime: Double?, maximumTime: Double?) {
        
        var isCellVisible : Bool = false
        for visibleCells in tblChat.visibleCells {
            if let selectedID = self.strSelectedAudioMessageID {
                
                // Check Visiblity for Receiver Cell
                if let cell = visibleCells as? AudioReceiverTblCell {
                    if cell.messageInformation.message_id == selectedID {
                        isCellVisible = true
                        break
                    }
                }
                
                // Check Visiblity for Sender Cell
                if let cell = visibleCells as? AudioSenderTblCell {
                    if cell.messageInformation.message_id == selectedID {
                        isCellVisible = true
                        break
                    }
                }
            }
        }
        
        if isCellVisible {
            if self.audioReceiverCell != nil {
                self.audioReceiverCell.audioSlider.maximumValue = maximumTime?.toFloat ?? 0.0
                self.audioReceiverCell.audioSlider.value = currentTime?.toFloat ?? 0.0
            }
            
            if self.audioSenderCell != nil {
                self.audioSenderCell.audioSlider.maximumValue = maximumTime?.toFloat ?? 0.0
                self.audioSenderCell.audioSlider.value = currentTime?.toFloat ?? 0.0
            }
        }
    }
}

// MARK:-  --------- Generic UITextView Delegate
// MARK:-
extension GroupChatDetailsViewController: GenericTextViewDelegate {
    
    func genericTextViewDidChange(_ textView: UITextView, height: CGFloat) {
        
        if textView.text.count < 1 || textView.text.isBlank{
            btnSend.isUserInteractionEnabled = false
            btnSend.alpha = 0.5
        }else {
            btnSend.isUserInteractionEnabled = true
            btnSend.alpha = 1
        }
        
        if height < 34 {
            cnTextViewHeightHeight.constant = 34
        }else if height > 100 {
            cnTextViewHeightHeight.constant = 100
        }else {
            cnTextViewHeightHeight.constant = height
        }
    }
    
}

// MARK:- --------- Action Event
// MARK:-
extension GroupChatDetailsViewController {
    
    @IBAction func btnMemeberRequestCLK(_ sender : UIButton) {
        if let groupMemberVC = CStoryboardGroup.instantiateViewController(withIdentifier: "GroupMemberRequestViewController") as? GroupMemberRequestViewController {
            groupMemberVC.iObject = self.iObject
            self.navigationController?.pushViewController(groupMemberVC, animated: true)
        }
    }
    
    @IBAction func btnMainBackCLK(_ sender : UIButton) {
        if isCreateNewChat {
            self.navigationController?.popToRootViewController(animated: true)
        }else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func btnGroupInfoCLK(_ sender : UIButton) {
        if let groupInfoVC = CStoryboardGroup.instantiateViewController(withIdentifier: "GroupInfoViewController") as? GroupInfoViewController {
            groupInfoVC.iObject = groupInfo
            self.navigationController?.pushViewController(groupInfoVC, animated: true)
        }
    }
    
    @IBAction func btnSendCLK(_ sender : UIButton) {
        
        //for QA
        if !ChatSocketIo.shared().socketClient.isConnected(){
            ChatSocketIo.shared().reconnect()
        }
        
        ChatSocketIo.shared().SocketInitilized()
        
        // Send Message to all user...
        if !txtViewMessage.text.trim.isBlank {
            let arrUserIDS = arrMembers.map({$0.valueForString(key: CUserId) })
            guard let user_ID = appDelegate.loginUser?.user_id else { return }
            if arrUserIDS.count > 0 {
                if let groupInfo = self.iObject as? [[String : Any]] {
                    if let goruptitle = groupInfo.first?["group_title"] as? String{
                        group_Name = goruptitle
                    }
                    guard let firstName = appDelegate.loginUser?.first_name  else { return }
                    guard let lastName = appDelegate.loginUser?.last_name else { return }
                    guard let profileImage = appDelegate.loginUser?.profile_img else { return }
                    let textMsg = txtViewMessage.text as Any
                    let content:[String:Any]  = [
                        "message": txtViewMessage.text as Any,
                        "type": "text",
                        "chat" : "group",
                        "name" : firstName + lastName,
                        "profile_image":profileImage
                    ]
                    let dictAsString = asString(jsonDictionary: content)
                    let dict:[String:Any] = [
                        "sender": user_ID.description,
                        "topic" : group_id,
                        "content":dictAsString,
                    ]
                    sessionTask = APIRequest.shared().userSentMsg(dict:dict) { [weak self] (response, error) in
                        guard let self = self else { return }
                       // self.refreshControl.endRefreshing()
                        self.tblChat.tableFooterView = UIView()
                        if response != nil && error == nil {
                            guard let arrList = response as? [String:Any] else { return }
                            self.getMessagesLoadFromServer(isNew: true)
//                            self.fetchHome.loadData()
                            if let arrStatus = arrList["message"] as? String{
                                print("arrStatus,\(arrStatus)")
                                let strArr = self.arrMembers.map({$0.valueForString(key: CUserId) })
                                strArr.forEach { friends_ID in
                                    if friends_ID == user_ID.description{
                                    }else {
//                                        let groupInfos = self.iObject as? [String : Any]
                                        guard let firstName = appDelegate.loginUser?.first_name else {return}
                                        guard let lastName = appDelegate.loginUser?.last_name else {return}
                                        MIGeneralsAPI.shared().sendNotification(friends_ID, userID: user_ID.description, subject: "send a text Message to you \(self.group_Name)", MsgType: "GROUP_MESSAGE", MsgSent: textMsg as? String, showDisplayContent: "send a text Message to you \(self.group_Name)", senderName: firstName + lastName, post_ID: self.groupInfoLatest,shareLink: "sendGrpChatLink" )
                                    }
                                }
                            }
                        }
                    }
                    txtViewMessage.text = nil
                    txtViewMessage.updatePlaceholderFrame(false)
                    cnTextViewHeightHeight.constant = 34
                    txtViewMessage.resignFirstResponder()
                    btnSend.isUserInteractionEnabled = false
                    btnSend.alpha = 0.5
                    self.tblChat.scrollToBottom()
                }
            }
        }
        
    }
    
    //MARK :- Sender Side  Sent With Notfication
    @objc func MsgsentNotificationsGrp(notification: Notification) {
        // Update chat message table from local..
        if fetchHome != nil {
            fetchHome.loadData()
        }
        GCDMainThread.asyncAfter(deadline: .now() + 2) {
            self.isLoadMore = false
        }
    }
    //MARK :- Recvied Side  Sent With Notfication
    @objc func MsgrecviedNotificationGrp(notification: Notification) {
        // Update chat message table from local..
        if fetchHome != nil {
            fetchHome.loadData()
        }
        GCDMainThread.asyncAfter(deadline: .now() + 2) {
            self.isLoadMore = false
        }
    }
    
    @IBAction func btnAttachmentCLK(_ sender : UIButton){
        
        self.resignKeyboard()
        self.stopAllAudio()
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: CBtnCamera, style: .default, handler: { (alert) in
            self.presentImagePickerControllerForCamera(imagePickerControllerCompletionHandler: { (image, info) in
                if let img = image {
                    self.arrSelectedMediaForChat.removeAll()
                    self.arrSelectedMediaForChat.append(img)
                    self.storeMediaToLocal(.image)
                }
            })
        })
        let imgCamera = UIImage(named: "ic_camera_option")?.withRenderingMode(.alwaysOriginal)
        cameraAction.setValue(imgCamera, forKey: "image")
        cameraAction.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        cameraAction.setValue(UIColor.black, forKey: "titleTextColor")
        alertController.addAction(cameraAction)
        
        let galleryAction = UIAlertAction(title: CBtnGallery, style: .default, handler: { (alert) in
            let galleryListVC:GalleryListViewController = CStoryboardImage.instantiateViewController(withIdentifier: "GalleryListViewController") as! GalleryListViewController
            galleryListVC.isFromChatScreen = true
            self.navigationController?.pushViewController(galleryListVC, animated: true)
        })
        
        let imgGallery = UIImage(named: "ic_gallery_option")?.withRenderingMode(.alwaysOriginal)
        galleryAction.setValue(imgGallery, forKey: "image")
        galleryAction.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        galleryAction.setValue(UIColor.black, forKey: "titleTextColor")
        alertController.addAction(galleryAction)
        
        let audioAction = UIAlertAction(title: CBtnAudio, style: .default, handler: { (alert) in
            if let songVC = CStoryboardGeneral.instantiateViewController(withIdentifier: "SongListViewController") as? SongListViewController {
                songVC.setBlock(block: { (songName, message) in
                    if let audioName = songName as? String {
                        
                        let message = CAudioSendConfirmation + " " + songVC.selectedFileName
                        self.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: message, btnOneTitle: CBtnYes, btnOneTapped: { (alert) in
                            self.arrSelectedMediaForChat.removeAll()
                            self.arrSelectedMediaForChat.append(audioName as Any)
                            self.storeMediaToLocal(.audio)
                        }, btnTwoTitle: CBtnNo, btnTwoTapped: nil)
                    }
                })
                self.present(songVC, animated: true, completion: nil)
            }
        })
        let imgAudio = UIImage(named: "ic_audio_option")?.withRenderingMode(.alwaysOriginal)
        audioAction.setValue(imgAudio, forKey: "image")
        audioAction.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        audioAction.setValue(UIColor.black, forKey: "titleTextColor")
        alertController.addAction(audioAction)
        
        let videoAction = UIAlertAction(title: CBtnVideo, style: .default, handler: { (alert) in
            MIVideoCameraGallery.shared().presentVideoGallery(self, { (url, info) in
                if url != nil {
                    
                    let message = CVideoSendConfirmation + " " + (url?.lastPathComponent ?? "")
                    self.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: message, btnOneTitle: CBtnYes, btnOneTapped: { (alert) in
                        
                        MIVideoCameraGallery.shared().exportVideoWithFinalOutput(url, drawingImage: nil, { (comUrl, completed, videoName) in
                            if completed {
                                self.arrSelectedMediaForChat.removeAll()
                                self.arrSelectedMediaForChat.append(comUrl?.description as Any)
                                self.storeMediaToLocal(.video)
                            }
                        })
                        
                    }, btnTwoTitle: CBtnNo, btnTwoTapped: nil)
                }
            })
        })
        
        let imgVideo = UIImage(named: "ic_video_option")?.withRenderingMode(.alwaysOriginal)
        videoAction.setValue(imgVideo, forKey: "image")
        videoAction.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        videoAction.setValue(UIColor.black, forKey: "titleTextColor")
        alertController.addAction(videoAction)
        
        let shareLocationAction = UIAlertAction(title: CShareCurrentLocation, style: .default, handler: { (alert) in
            print(CShareCurrentLocation)
            
            
            self.locationPicker?.showCurrentLocationButton = true
            self.locationPicker?.getImageLocation = true
            self.locationPicker?.completion = {  (placeDetail) in
                if let img = placeDetail?.locationImage {
                    self.arrSelectedMediaForChat.removeAll()
                    self.arrSelectedMediaForChat.append(img)
                    //self.storeMediaToLocal(.location)
                    self.storeMediaToLocal(
                        .location,
                        latitude: placeDetail?.coordinate?.latitude ?? 0.0,
                        longitude: placeDetail?.coordinate?.longitude ?? 0.0,
                        address: placeDetail?.formattedAddress ?? ""
                    )
                }
            }
            if self.locationPicker != nil{
                self.navigationController?.pushViewController(self.locationPicker!, animated: true)
            }
        })
        let imgLocation = UIImage(named: "ic_share_location_option")?.withRenderingMode(.alwaysOriginal)
        shareLocationAction.setValue(imgLocation, forKey: "image")
        shareLocationAction.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        shareLocationAction.setValue(UIColor.black, forKey: "titleTextColor")
        alertController.addAction(shareLocationAction)
        
        alertController.addAction(UIAlertAction(title: CBtnCancel, style: .cancel, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func btnGroupMenuCLK(_ sender : UIButton) {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if let groupInfo = self.iObject as? [String: Any] {
            
            if (groupInfo.valueForString(key: "grouuser_idp_admin")) == appDelegate.loginUser?.user_id.description {
                
                let groupDetailAction = UIAlertAction(title: CGroupDetail, style: .default) { [weak self] (_) in
                    guard let _ = self else { return }
                    self?.btnGroupInfoCLK(UIButton())
                }
                
                let editAction = UIAlertAction(title: CGroupEdit, style: .default) { [weak self] (_) in
                    guard let self = self else { return }
                    var arrMemberTemp = self.arrMembers
                    
                    // Remove login user from list...
                    if let index = arrMemberTemp.index(where: {$0[CUserId] as? Int64 == appDelegate.loginUser?.user_id}) {
                        arrMemberTemp.remove(at: index)
                    }
                    
                    if let createGroupVC = CStoryboardGroup.instantiateViewController(withIdentifier: "CreateChatGroupViewController") as? CreateChatGroupViewController {
                        createGroupVC.iObject = groupInfo
                        createGroupVC.arrSelectedParticipants = arrMemberTemp
                        createGroupVC.groupID = groupInfo.valueForInt(key: CGroupId)
                        self.navigationController?.pushViewController(createGroupVC, animated: true)
                    }
                }
                
                let clearChat = UIAlertAction(title:"Clear Chat", style: .default) { [weak self] (_) in
                    guard let _ = self else { return }
                    self?.claerchatControllers()
                }
                
                let deleteAction = UIAlertAction(title: CGroupDelete, style: .default) { [weak self] (_) in
                    guard let self = self else { return }
                    self.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: CAlertGroupDelete, btnOneTitle: CBtnYes, btnOneTapped: { (alert) in
                    }, btnTwoTitle: CBtnNo, btnTwoTapped: nil)
                }
                alertController.addAction(groupDetailAction)
                alertController.addAction(editAction)
                alertController.addAction(deleteAction)
                alertController.addAction(clearChat)
                
                alertController.addAction(UIAlertAction(title: CBtnCancel, style: .cancel, handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
                
            } else {
                
                let groupDetailAction = UIAlertAction(title: CGroupDetail, style: .default) { [weak self] (_) in
                    guard let _ = self else { return }
                    self?.btnGroupInfoCLK(UIButton())
                }
                
                let reportAction = UIAlertAction(title: CGroupReport, style: .default) { [weak self] (_) in
                    guard let self = self else { return }
                    if let groupInfo = self.iObject as? [String : Any] {
                        if let reportVC = CStoryboardGeneral.instantiateViewController(withIdentifier: "ReportViewController") as? ReportViewController {
                            reportVC.reportType = .reportGroup
                            reportVC.groupID = groupInfo.valueForInt(key: CGroupId)
                            
                            reportVC.setBlock(block: { (info, message) in
                                
                                if let blockHandler = self.block {
                                    blockHandler(nil, "refresh Group List screen")
                                }
                                
                                self.navigationController?.popViewController(animated: false)
                            })
                            self.navigationController?.pushViewController(reportVC, animated: true)
                        }
                    }
                }
                if groupInfo.valueForInt(key: CBlock_unblock_status) != 1 {
                    alertController.addAction(reportAction)
                }
                alertController.addAction(groupDetailAction)
                
                
                alertController.addAction(UIAlertAction(title: CBtnCancel, style: .cancel, handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func claerchatControllers() {
        if let arrMessages = TblMessages.fetchAllObjects() as? [TblMessages] {
            for _ in arrMessages {
            }
        }
    }
    
    @IBAction private func btnAudioClicked(_ sender: UIButton) {
        
        if let groupInfo = self.iObject as? [String: Any] {
            if let videoChat  = CStoryboardAudioVideo.instantiateViewController(withIdentifier: "GroupUserListVC") as? GroupUserListVC {
                videoChat.groupId = groupInfo.valueForInt(key: CGroupId) ?? 0
                videoChat.userImage = groupInfo.valueForString(key: CGroupImage)
                videoChat.fullName = groupInfo.valueForString(key: CGroupTitle)
                videoChat.listType = .Audio
                self.navigationController?.pushViewController(videoChat, animated: true)
            }
        }
    }
    
    @IBAction private func btnVideoClicked(_ sender: UIButton) {
        
        if let groupInfo = self.iObject as? [String: Any] {
            
            if let videoChat  = CStoryboardAudioVideo.instantiateViewController(withIdentifier: "GroupUserListVC") as? GroupUserListVC {
                videoChat.groupId = groupInfo.valueForInt(key: CGroupId) ?? 0
                videoChat.userImage = groupInfo.valueForString(key: CGroupImage)
                videoChat.fullName = groupInfo.valueForString(key: CGroupTitle)
                videoChat.listType = .Video
                self.navigationController?.pushViewController(videoChat, animated: true)
            }
        }
        
    }
}

extension GroupChatDetailsViewController{
    
    //@IBAction func btnAutoDeleteCLK(_ sender : UIButton){
    //    weak var weakSelf = self
    //    self.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: CMessageDeletePost, btnOneTitle: CBtnYes, btnOneTapped: { (alert) in
    //        if !self.txtViewMessage.text.trim.isBlank {
    //            if let userid = self.userID{
    ////                let channelId = CMQTTUSERTOPIC + "\(userid)"
    //                // Send message to both Login and front user...
    ////                MIMQTT.shared().messagePaylaod(arrUser: ["\(appDelegate.loginUser?.user_id ?? 0)", "\(userid)"], channelId: channelId, message: self.txtViewMessage.text.trim, messageType: .text, chatType: .user, groupID: nil, is_auto_delete: 1)
    //                self.txtViewMessage.text = nil
    //                self.txtViewMessage.updatePlaceholderFrame(false)
    //                self.cnTextViewHeightHeight.constant = 34
    //                self.txtViewMessage.resignFirstResponder()
    //                self.btnSend.isUserInteractionEnabled = true
    //                self.btnSend.alpha = 0.5
    ////                self.btnAutoDelete.isUserInteractionEnabled = true
    ////                self.btnAutoDelete.isHidden = true
    ////                self.btnAudioMsg.isHidden = false
    ////                self.btnAutoDelete.alpha = 0.5
    //                self.tblChat.scrollToBottom()
    //            }
    //        }
    //    }, btnTwoTitle: CBtnNo, btnTwoTapped: nil)
    //
    //}
    @objc func DidSelectCLK(_ notifiction :Notification){
        
    }
    
    @objc func DidDisSelectCLk(_ notifiction :Notification){
        
    }
}

extension GroupChatDetailsViewController{
    
    @IBAction func btnSwipeforwardCLK(_ sender : UIButton){
        if messageidListItems.count > 0 {
            for msArrayid in messageidListItems{
                if let arrMessages = TblMessages.fetchAllObjects() as? [TblMessages] {
                    for arrMsg in arrMessages{
                        if arrMsg.message_id == msArrayid{
                            let addPostView = SwipeReplayMsgView.initHomeAddPostMenuViews()
                            self.view.addSubview(addPostView)
                            addPostView.showPostOption()
                            addPostView.showPostOptionGroup(arrMembers)
                            let groupid = Int(arrMsg.group_id ?? "0") ?? 0
                            addPostView.showPostMessage(arrMsg, UserId: groupid,chatTypeMode:2)
                            
                        }
                    }
                }
            }
        }
        
    }
    func delSelectedChatMessages() {
        if messageidListItems.count > 0 {
            for msArrayid in messageidListItems{
                if let arrMessages = TblMessages.fetchAllObjects() as? [TblMessages] {
                    for arrMsg in arrMessages{
                        if arrMsg.message_id == msArrayid{
                            print(arrMsg)
                        }
                    }
                    
                }
            }
            
        }
        self.messageidListItems.removeAll()
        tblChat.reloadData()
    }
    @IBAction func btnDeleteCLK(_ sender : UIButton){
        self.delSelectedChatMessages()
        
    }
    
    @IBAction func btnForwordCLK(_ sender : UIButton){
        let storyboard = UIStoryboard(name: "Forward", bundle: nil)
        if let ForwdController = storyboard.instantiateViewController(withIdentifier: "ForwardViewController") as? ForwardViewController {
            ForwdController.forwaordCallBack = { message in
            }
            ForwdController.msgidUsertItems = messageidListItems
            ForwdController.usrCharinfo = true
            self.navigationController?.pushViewController(ForwdController, animated: true)
        }
    }
    
    @IBAction func btnCopyCLK(_ sender : UIButton){
        MIToastAlert.shared.showToastAlert(position: .bottom, message: String(messageidListItems.count) + " Messages Copied" )
        pastebaord.strings = []
        isCopySeleted = true
        if messageidListItems.count > 0 {
            for msArrayid in messageidListItems{
                if let arrMessages = TblMessages.fetchAllObjects() as? [TblMessages] {
                    for arrMsg in arrMessages{
                        if arrMsg.message_id == msArrayid{
                            let Datevalue  = DateFormatter.dateStringFrom(timestamp: Double(arrMsg.msgdate ?? ""), withFormate: CreatedAtPostConvert)
                            let date = NSDate(timeIntervalSince1970: Double(arrMsg.chat_time))
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "HH:mm"
                            let datevalue = dateFormatter.string(from: date as Date)
                            pastebaord.addItems([[UIPasteboard.typeListString[0] as! String : "["],[UIPasteboard.typeListString[0] as! String : Datevalue],[UIPasteboard.typeListString[0] as! String : " "],[UIPasteboard.typeListString[0] as! String :datevalue ],[UIPasteboard.typeListString[0] as! String : "]"],[UIPasteboard.typeListString[0] as! String : arrMsg.full_name ?? ""],[UIPasteboard.typeListString[0] as! String : ":"],[UIPasteboard.typeListString[0] as! String : arrMsg.message ?? ""],[UIPasteboard.typeListString[0] as! String : "\n"]])
                        }
                    }
                }
            }
        }
        self.messageidListItems.removeAll()
    }
    
    func claerchatController() {
        if let arrMessages = TblMessages.fetchAllObjects() as? [TblMessages] {
            for messageInfo in arrMessages {
                //                MIMQTT.shared().deleteAllMessageFromLocal(messageInfo, isSender: false)
            }
        }
    }
}
//MARK:- Audio message send
extension GroupChatDetailsViewController{
    
    /* Get the Document Directory*/
    func getDocumentsDirectory() -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    func getFileUrl() -> URL{
        
        let filename = "myRecording.m4a"
        //        let audioName = "\(Int(Date().currentTimeStamp)).m4a"
        latestFileName = filename
        let filePath = getDocumentsDirectory().appendingPathComponent(filename)
        return filePath
    }
    
    func display_alert(msg_title : String , msg_desc : String ,action_title : String){
        let ac = UIAlertController(title: msg_title, message: msg_desc, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: action_title, style: .default){
            (result : UIAlertAction) -> Void in
            _ = self.navigationController?.popViewController(animated: true)
        })
        present(ac, animated: true)
    }
    //MARK:- setup for record the audio
    func setup_recorder(){
        let session = AVAudioSession.sharedInstance()
        do{
            try session.setCategory(AVAudioSession.Category.playAndRecord, options: .defaultToSpeaker)
            try session.setActive(true)
            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 2,
                AVEncoderAudioQualityKey:AVAudioQuality.high.rawValue
            ]
            audioRecorder = try AVAudioRecorder(url: getFileUrl(), settings: settings)
            audioRecorder.delegate = self
            audioRecorder.isMeteringEnabled = true
            audioRecorder.prepareToRecord()
        }
        catch let error {
            display_alert(msg_title: "Error", msg_desc: error.localizedDescription, action_title: "OK")
        }
    }
    
    //MARK:- setup for start recoding the audio
    func start_recording(_ sender: UIButton){
        if(isRecording){
            finishAudioRecording(success: true)
            //            play_btn_ref.isEnabled = true
            isRecording = false
        }else{
            setup_recorder()
            audioRecorder.record()
            meterTimer = Timer.scheduledTimer(timeInterval: 0.1, target:self, selector:#selector(self.updateAudioMeter(timer:)), userInfo:nil, repeats:true)
            //            play_btn_ref.isEnabled = false
            isRecording = true
        }
    }
    //    Start recording when button start_recording press & display seconds using updateAudioMeter, & if recording is start then finish the recording
    @objc func updateAudioMeter(timer: Timer){
        if audioRecorder.isRecording{
            let min = Int(audioRecorder.currentTime / 60)
            let sec = Int(audioRecorder.currentTime.truncatingRemainder(dividingBy: 60))
            let totalTimeString = String(format: "%02d:%02d", min, sec)
            audioMsgTimeLbl.text = totalTimeString
            audioRecorder.updateMeters()
        }
    }
    
    func finishAudioRecording(success: Bool){
        if success{
            audioRecorder.pause()
            audioRecorder.stop()
            audioRecorder = nil
            meterTimer.invalidate()
            print("recorded successfully.")
            prepare_play()
        }else{
            display_alert(msg_title: "Error", msg_desc: "Recording failed.", action_title: "OK")
        }
    }
    func prepare_play(){
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: getFileUrl())
            audioPlayer.delegate = self
            audioPlayer.prepareToPlay()
            if FileManager.default.fileExists(atPath: getFileUrl().path){
                //                    print("geturlpath",getFileUrl().path)
                //                    audioPlayer.play()
                let mediaItem = getFileUrl()
                print("geturl\(mediaItem)")
                let URL: NSURL = NSURL(string: getFileUrl().path)!
                
                let songAsset = AVURLAsset(url: URL as URL, options: nil)
                let exporter = AVAssetExportSession(asset: songAsset, presetName: AVAssetExportPresetAppleM4A)
                exporter?.outputFileType = AVFileType.m4a
                exporter?.outputURL = mediaItem
                //                    arrSelectedMediaForChat.removeAll()
                //                    arrSelectedMediaForChat.append(latestFileName as Any)
                //                    storeMediaToLocal(.audio)
                //                    self.tblChat.scrollToBottom()
                
                let message = CAudioSendConfirmation
                let alertController = UIAlertController(title:message, message:CAutodelete_change, preferredStyle: UIAlertController.Style.alert);
                alertController.addAction(UIAlertAction(title: CBtnYes, style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
                    self.arrSelectedMediaForChat.removeAll()
                    self.arrSelectedMediaForChat.append(self.latestFileName as Any)
                    self.storeMediaToLocal(.audio)
                    self.tblChat.scrollToBottom()
                    
                }))
                alertController.addAction(UIAlertAction(title: CBtnNo, style: UIAlertAction.Style.default, handler: nil))
                let btnImage    = UIImage(named: "ic_uncheckbox")!
                let imageButton : UIButton = UIButton(frame: CGRect(x: 25, y: 60, width: 30, height: 30))
                imageButton.setBackgroundImage(btnImage, for: UIControl.State())
                imageButton.addTarget(self, action: #selector(self.checkBoxAction(_:)), for: .touchUpInside)
                alertController.view.addSubview(imageButton)
                self.present(alertController, animated: false, completion: { () -> Void in
                })
            }
        }catch{
            print("Error")
        }
    }
    
    @objc func checkBoxAction(_ sender: UIButton){
        if (sender.isSelected == true){
            autodelete = 0
            sender.setBackgroundImage(UIImage(named: "ic_uncheckbox"), for:  UIControl.State())
            sender.isSelected = false;
        }
        else{
            autodelete = 1
            sender.setBackgroundImage(UIImage(named: "ic_checkbox"), for: UIControl.State())
            sender.isSelected = true;
        }
    }
}

extension GroupChatDetailsViewController{
    
    func convertToDictionary(from text: String) throws -> [String: String] {
        guard let data = text.data(using: .utf8) else { return [:] }
        let anyResult: Any = try JSONSerialization.jsonObject(with: data, options: [])
        return anyResult as? [String: String] ?? [:]
    }
    func asString(jsonDictionary: [String:Any]) -> String {
        do {
            let data = try JSONSerialization.data(withJSONObject: jsonDictionary, options: .prettyPrinted)
            return String(data: data, encoding: String.Encoding.utf8) ?? ""
        } catch {
            return ""
        }
    }
    
    func getThumbnailImageFromVideoUrl(url: URL, completion: @escaping ((_ image: UIImage?)->Void)){
        DispatchQueue.global().async { //1
            let asset = AVAsset(url: url) //2
            let avAssetImageGenerator = AVAssetImageGenerator(asset: asset) //3
            avAssetImageGenerator.appliesPreferredTrackTransform = true //4
            let thumnailTime = CMTimeMake(value: 2, timescale: 1) //5
            do {
                let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumnailTime, actualTime: nil) //6
                let thumbNailImage = UIImage(cgImage: cgThumbImage) //7
                DispatchQueue.main.async { //8
                    completion(thumbNailImage) //9
                }
            } catch {
                print(error.localizedDescription) //10
                DispatchQueue.main.async {
                    completion(nil) //11
                }
            }
        }
    }
}
extension GroupChatDetailsViewController {
    
    func ImageAttachemntApiCall(uploadImgUrl:String,type:String,thumbLine:UIImage){
        
        if !ChatSocketIo.shared().socketClient.isConnected(){
            ChatSocketIo.shared().reconnect()
        }
        
        guard let user_ID = appDelegate.loginUser?.user_id else { return }
        guard let firstName = appDelegate.loginUser?.first_name  else { return }
        guard let lastName = appDelegate.loginUser?.last_name else { return }
        guard let profileImage = appDelegate.loginUser?.profile_img else { return }
        
        let contentString:[String:Any]  = [
            "message": uploadImgUrl,
            "type": type,
            "chat" : "group",
            "name" : firstName + lastName,
            "profile_image":profileImage
            
        ]
        let dictAsString = asString(jsonDictionary: contentString)
        let trimmedString = dictAsString.components(separatedBy: .whitespacesAndNewlines).joined()
        let uploadimage = trimmedString.replacingOccurrences(of: "\\/", with: "/")
        let dict:[String:Any] = [
            "sender": user_ID.description,
            "topic" : group_id,
            "content":uploadimage,
        ]
        sessionTask = APIRequest.shared().userSentMsg(dict:dict) { [weak self] (response, error) in
            guard let self = self else { return }
            self.refreshControl.endRefreshing()
            self.tblChat.tableFooterView = UIView()
            if response != nil && error == nil {
                self.fetchHome.loadData()
                self.getMessagesLoadFromServer(isNew: true)
                ChatSocketIo.shared().socketDelegate = self
                let strArr = self.arrMembers.map({$0.valueForString(key: CUserId) })
                strArr.forEach { friends_ID in
                    if friends_ID == user_ID.description{
                    }else {
                        guard let firstName = appDelegate.loginUser?.first_name else {return}
                        guard let lastName = appDelegate.loginUser?.last_name else {return}
                        MIGeneralsAPI.shared().sendNotification(friends_ID, userID: user_ID.description, subject: "send a text Message to you \(self.group_Name)", MsgType: "GROUP_MESSAGE", MsgSent: "send Attachment", showDisplayContent: "send a text Message to you \(self.group_Name)", senderName: firstName + lastName, post_ID: self.groupInfoLatest,shareLink: "sendGrpChatLink")
                    }
                }
            }
        }
    }
    
    
    
}

extension GroupChatDetailsViewController{
    
    func convertToDictionarywithtry(from text: String) -> [String: String]? {
        guard let data = text.data(using: .utf8) else { return nil }
        let anyResult = try? JSONSerialization.jsonObject(with: data, options: [])
        return anyResult as? [String: String]
    }
    
    
}
