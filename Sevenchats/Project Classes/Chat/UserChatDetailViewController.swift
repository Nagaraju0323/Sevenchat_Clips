//
//  UserChatDetailViewController.swift
//  Sevenchats
//
//  Created by mac-0005 on 04/09/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Chandrika.R                                 *
 * Model   : UserChatDetailViewController                *
 * Changes :                                             *
 * intigrated Socket IO,sent Msg,Attachment              *
 ********************************************************/

import UIKit
import CoreData
import AVFoundation
import MediaPlayer
import StompClientLib
import TrueTime
import AVKit

class UserChatDetailViewController: ParentViewController, MIAudioPlayerDelegate, SocketDelegate{
    
    let network = ChatSocketIo()
    
    weak var stompClientLibDelegte:StompClientLibDelegate?
    
    var serviceInstance: ChatSocketIo = ChatSocketIo()
    
    @IBOutlet weak var cnNavigationHeight : NSLayoutConstraint! {
        didSet {
            //cnNavigationHeight.constant = IS_iPhone_X_Series ? 84 : 64
            let statusBarHeight = UIApplication.shared.statusBarFrame.height
            let navBarHeight = self.navigationController?.navigationBar.bounds.height
            cnNavigationHeight.constant = statusBarHeight + (navBarHeight ?? 44)
        }
    }
    
    @IBOutlet weak var cnVwMsgContainerBottom : NSLayoutConstraint! {
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
            showHideVideoAudio()
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
            tblChat.rowHeight = UITableView.automaticDimension;
            tblChat.allowsMultipleSelection = true
            tblChat.transform = CGAffineTransform(rotationAngle: -.pi)
            tblChat.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: CScreenWidth-10)
        }
    }
    
    @IBOutlet weak var imgUser : UIImageView! {
        didSet {
            imgUser.layer.cornerRadius = imgUser.frame.size.width/2
            
        }
    }
    
    @IBOutlet weak var imgOnline : UIImageView! {
        didSet {
            imgOnline.layer.cornerRadius = imgOnline.frame.size.width/2
            imgOnline.layer.borderWidth = 1
            imgOnline.layer.borderColor = UIColor.white.cgColor
        }
    }
    var shouldReloads:Bool?{
        didSet{
            DispatchQueue.main.async {
                self.tblChat.reloadData()
            }
        }
    }
    
    @IBOutlet weak var viewChatMoreitemsView : UIView!
    @IBOutlet weak var lblUserBlockMessage : UILabel!
    @IBOutlet weak var cnTextViewHeightHeight : NSLayoutConstraint!
    @IBOutlet weak var btnSend : UIButton!
    @IBOutlet weak var btnAutoDelete : UIButton!
    @IBOutlet weak var btnAudioMsg : UIButton!
    @IBOutlet weak var btnBack : UIButton!
    @IBOutlet weak var btnMore : UIButton!
    @IBOutlet private weak var btnVideo: UIButton!
    @IBOutlet private weak var btnAudio: UIButton!
    @IBOutlet weak var txtViewMessage : GenericTextView!{
        didSet{
            self.txtViewMessage.txtDelegate = self
            self.txtViewMessage.type = "2"
            
        }
    }
    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var btnSwipeforward : UIButton!
    @IBOutlet weak var btnCopy : UIButton!
    @IBOutlet weak var btnDelete : UIButton!
    @IBOutlet weak var btnForword : UIButton!
    @IBOutlet weak var lblDeleteCount : UILabel!
    @IBOutlet weak var btnAttachment: UIButton!
    @IBOutlet weak var btnTexttovoice: UIButton!
    //AudioMsg
    @IBOutlet weak var audioMsgView: UIView!
    @IBOutlet weak var audioMsgTimeLbl: UILabel!
    //Recordvidoes
    @IBOutlet var recordingTimeLabel: UILabel!
    @IBOutlet var record_btn_ref: UIButton!
    @IBOutlet var play_btn_ref: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    var audioPlayer : AVAudioPlayer!
    var meterTimer:Timer!
    var isAudioRecordingGranted: Bool!
    var isRecording = false
    var isPlaying = false
    var sessionTask : URLSessionTask!
    var fetchHome : DataSourceController!
    var audioReceiverCell : AudioReceiverTblCell!
    var audioSenderCell : AudioSenderTblCell!
    var strChannelId : String!
    var isCreateNewChat : Bool!
    var userID: Int?
    var arrSelectedMediaForChat = [Any]()
    var arrSelectedMediaForMinIO = [Any]()
    var refreshControl = UIRefreshControl()
    var isLoadMore = true
    var isBlockedByLoginUser = 0
    var strSelectedAudioMessageID : String!
    var autodelete = 0
    var setautoDel_audio : Int?
    var locationPicker : LocationPickerVC?
    var isautoDeleteTime: String?
    var isautoDeletevidoe = 0
    var isautoDeleteLocation = 0
    var latestFileName = ""
    var arrSongLists = [MPMediaItem]()
    var selectedDaysArray = [Int]()
    var messageidListItems:[String] = []
    var pastebaord = UIPasteboard.general
    var isCopySeleted = false
    var ChatTopicID = ""
    var ClientID = ""
    var friendUserId = ""
    var userEmail : String?
    var userIDuser: String?
    var topcName = ""
    var topcNameLocal = ""
    var changeTopic = ""
    var uploadImgUrl:String?
    var ChatListPage:Bool!
    let session = AVAudioSession.sharedInstance()
    let synthesizer = AVSpeechSynthesizer()
    var chatMsg = [MDLChatLastMSG]()
    var socketClient = StompClientLib()
    var timeClient: TrueTimeClient?
    var chatInfoNot = [String:Any]()
    var notifcationStatus:Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ChatSocketIo.shared().SocketInitilized()
        createTopictoChat()
        ChatSocketIo.shared().socketDelegate = self
        self.getMessagesFromServer(isNew: true)
        Initialization()
        notificationObserver = nil
        NotificationCenter.default.addObserver(self, selector: #selector(self.MsgsentNotifications(notification:)), name: Notification.Name("MsgSentNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.MsgrecviedNotification(notification:)), name: Notification.Name("MsgrecviedNotification"), object: nil)
    }
    
    var notificationObserver: Any? {
        willSet {
            if let observer = notificationObserver {
                NotificationCenter.default.removeObserver(observer)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        GCDMainThread.async {
            MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: "\(CMessagePleaseWait)...")
//         }
        
        messageidListItems.removeAll()
        NotificationCenter.default.addObserver(self, selector: #selector(self.DidSelectCLK), name: NSNotification.Name(rawValue: "DidSelectCLK"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.DidDisSelectCLk), name: NSNotification.Name(rawValue: "DidDisSelectCLk"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.shouldReload), name: NSNotification.Name(rawValue: "newDataNotificationForItemEdit"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.swipeEditReload), name: NSNotification.Name(rawValue: "newDataSwiftForItemEdit"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.AttachmentClk), name: NSNotification.Name(rawValue: "btnAttachment"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("NotificationIdentifier"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.cameraReceivedNotification(notification:)), name: Notification.Name("NotificationIdentifierCamera"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.NotificationIdentifierLocation(notification:)), name: Notification.Name("NotificationIdentifierLocation"), object: nil)
        
        self.updateUIAccordingToLanguage()
        if self.arrSelectedMediaForChat.count > 0 {
            self.storeMediaToLocal(.image)
        }
        
        self.uploadMediaFileToServer()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        notificationObserver = nil
        self.stopAllAudio()
    }
    
    
    //MARK :- Notfication Servies ShouldReload
    @objc func shouldReload() {
        self.tblChat.scrollToBottom()
        
    }
    @objc func swipeEditReload(){
        self.tblChat.scrollToBottom()
        self.lblDeleteCount.text = ""
        self.tblChat.reloadData()
        self.viewChatMoreitemsView.isHidden = true
        
    }
    // Update chat message table from local..
    @objc func didRefreshMessages() {
        isLoadMore = false
        if fetchHome != nil {
            fetchHome.loadData()
        }
        GCDMainThread.asyncAfter(deadline: .now() + 2) {
            self.isLoadMore = true
            self.isLoadMore = false
        }
    }
    
    @objc func AttachmentClk(){
        btnAttachmentCLK_call()
        self.tblChat.scrollToBottom()
    }
    
    //MARK :- Notitcationfor DidSelect
    @objc func DidSelectCLK(_ notifiction :Notification){
    }
    
    //MARK :- Notitcationfor DidSelect
    @objc func DidDisSelectCLk(_ notifiction :Notification){
    }
    
    // MARK:- --------- Initialization
    // MARK:-
    func Initialization() {
        
        MIAudioPlayer.shared().miAudioPlayerDelegate = self
        GCDMainThread.async { [self] in
            
            MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: "\(CMessagePleaseWait)...")
            self.messageidListItems.removeAll()
            self.refreshControl.addTarget(self, action: #selector(self.pullToRefresh), for: .valueChanged)
            self.refreshControl.tintColor = ColorAppTheme
            self.tblChat.pullToRefreshControl = self.refreshControl
        }
        if let _locationPicker = CStoryboardLocationPicker.instantiateViewController(withIdentifier: "LocationPickerVC") as? LocationPickerVC {
            _locationPicker.showConfirmAlertOnSelectLocation = true
            locationPicker = _locationPicker
        }
        btnAudio.isHidden = true
        btnVideo.isHidden = true
        self.setFetchController()
        self.setUserDetails()
        showHideVideoAudio()
    }
    
    //MARK :- ---------Create TopicChat
    func createTopictoChat(){
        
        if isCreateNewChat == true {
            
            guard let value_one = userID, let value_two = appDelegate.loginUser?.user_id else {return}
            if value_one > value_two{
                topcName = String(value_one) + "_" + String(value_two)
            }else{
                topcName = String(value_two) + "_" + String(value_one)
            }
            ChatSocketIo.shared().createTopicTouser(userTopic:"/topic/" + topcName)
        }
        if ChatListPage == true {
            guard let value_one = userID, let value_two = appDelegate.loginUser?.user_id else {return}
            if value_one > value_two{
                topcName = String(value_one) + "_" + String(value_two)
            }else{
                topcName = String(value_two) + "_" + String(value_one)
            }
            ChatSocketIo.shared().createTopicTouser(userTopic:"/topic/" + topcName)
        }
    }
    
    //autoDelete Notification values Recievied
    @objc func methodOfReceivedNotification(notification: Notification) {
        guard let autodeleteNotificatoin = notification.object else {
            return
        }
        if let autoconvertValues = autodeleteNotificatoin as? Int{
            isautoDeletevidoe = autoconvertValues
        }
    }
    
    //autoDelete Notification Camera
    @objc func cameraReceivedNotification(notification: Notification) {
        guard let autodeleteNotificatoin = notification.object else {
            return
        }
        if let autoconvertValues = autodeleteNotificatoin as? Int{
            isautoDeletevidoe = autoconvertValues
            if isautoDeletevidoe == 1{
                self.autodelete = 1
            }
        }
    }
    
    //autoDelete Notification Location
    @objc func NotificationIdentifierLocation(notification: Notification) {
        guard let autodeleteNotificatoin = notification.object else {
            return
        }
        if let autoconvertValues = autodeleteNotificatoin as? Int{
            isautoDeleteLocation = autoconvertValues
        }
    }
    
    func updateUIAccordingToLanguage(){
        if Localization.sharedInstance.applicationFlowWithLanguageRTL() {
            // Reverse Flow...
            lblTitle.textAlignment = .right
            btnBack.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            
        }else{
            // Normal Flow...
            lblTitle.textAlignment = .left
            btnBack.transform = CGAffineTransform.identity
        }
        txtViewMessage.placeHolder = CMessageTypeYourMessage
    }
    
    func showHideVideoAudio() {
        if !self.viewMessageContainer.isHidden {
            GCDMainThread.async { [weak self]  () in
                guard let `self` = self else { return }
                self.btnAudio.hide(byWidth: (!IsAudioVideoEnable))
                self.btnVideo.hide(byWidth: !(IsAudioVideoEnable))
            }
        } else {
            self.btnAudio.hide(byWidth: true)
            self.btnVideo.hide(byWidth: true)
        }
    }
}

// MARK:- --------- Api Functions
// MARK:-
extension UserChatDetailViewController {
    
    fileprivate func checkForBlockUser(_ userInfo: [String: Any]) {
        
        /*
         - If login user block front user.
         - If front user block login user.
         - If Login and front user are not friend.
         ## From all above cases user can't chat to each other.
         */
        
        if userInfo.valueForInt(key: CIs_login_blocked) == 1 || userInfo.valueForInt(key: CIs_blocked) == 1 || userInfo.valueForInt(key: CFriend_status) == 0 {
            // Hide chatting controls for block user.
            self.viewMessageContainer.isHidden = true
            self.showHideVideoAudio()
            
            self.cnTextViewHeightHeight.constant = 50
            self.lblUserBlockMessage.isHidden = false
            
            if let blockStatus = userInfo.valueForInt(key: CIs_login_blocked) {
                self.isBlockedByLoginUser = blockStatus
            }
            
            if let loginBlocked = userInfo.valueForInt(key: CIs_login_blocked), loginBlocked == 1 {
                self.lblUserBlockMessage.text = CMessageLoginUserBlock
            }else if let otherBlock = userInfo.valueForInt(key: CIs_blocked), otherBlock == 1 {
                self.lblUserBlockMessage.text = CMessageOtherUserBlock
            }else {
                self.lblUserBlockMessage.text = CMessageNoLongerFriend
            }
        } else {
            self.isBlockedByLoginUser = 0
            self.cnTextViewHeightHeight.constant = 34
            self.viewMessageContainer.isHidden = false
            self.lblUserBlockMessage.isHidden = true
            showHideVideoAudio()
        }
        
        // Three dot button will be hide when login user reported front user
        if userInfo.valueForInt(key: CIs_reported) == 1 {
            btnMore.isHidden = true
        } else {
            btnMore.isHidden = false
        }
    }
    
    fileprivate func setUserDetails() {
        if let userInfo = self.iObject as? [String : Any] {
            self.lblTitle.text = userInfo.valueForString(key: CFirstname) + " " + userInfo.valueForString(key: CLastname)
            self.imgUser.loadImageFromUrl(userInfo.valueForString(key: Cimages), true)
            self.imgOnline.isHidden = !userInfo.valueForBool(key: "isOnline")
//            self.userID = userInfo.valueForString(key: "user_id").toInt
            self.checkForBlockUser(userInfo)
        }
    }
    
    @objc fileprivate func pullToRefresh() {
        if sessionTask != nil {
            if sessionTask!.state == .running {
                return
            }
        }
        refreshControl.beginRefreshing()
    }
    
    func getMessagesFromServer(isNew : Bool) {
        
        MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: "\(CMessagePleaseWait)...")
        
        TblMessages.deleteAllObjects()
        if sessionTask != nil {
            if sessionTask.state == .running {
                print(" Api calling continue =========")
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
                MILoader.shared.hideLoader()
                
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
//                    let chatTimeStamp = DateFormatter.shared().timestampGMTFromDateNew(date: timstmamp)
                    let chatTimeStamp = ""
                    //todo chagnes futures
                    let create  = chatTimeStamp
                    if let sender = dict?["sender"]{
                        senders = sender
                    }
                    
                    let senderName = dict?["name"] ?? ""
                    let senderProfImg = dict?["profile_image"] ?? ""
                    let timestamp2 = dict?["timestamp"]
                    
                    if dictcontent?["type"] == "image"{
                        ChatSocketIo.shared().messagePaylaodLast(arrUser: ["\(senders )"], channelId: self.topcName , message: txtmsg, messageType: .image, chatType: .user, groupID: nil, latitude: 0.0, longitude: 0.0, address: "", forwardedMsgId: "", cloleFile: nil, sender: senders , isSelected: true,createat: create ,timestampDate:timestamp2 ?? "",senderName:senderName,SenderProfImg:senderProfImg)
                        UserDefaultHelper.userChatLastMsg = true
                        
                    }else if dictcontent?["type"] == "video"{
                        
                        ChatSocketIo.shared().messagePaylaodLast(arrUser: ["\(senders )"], channelId: self.topcName , message: txtmsg, messageType: .video, chatType: .user, groupID: nil, latitude: 0.0, longitude: 0.0, address: "", forwardedMsgId: "", cloleFile: nil, sender: senders , isSelected: true,createat: create ,timestampDate:timestamp2 ?? "",senderName:senderName,SenderProfImg:senderProfImg)
                        UserDefaultHelper.userChatLastMsg = true
                        
                    }else if dictcontent?["type"] == "audio"{
                        ChatSocketIo.shared().messagePaylaodLast(arrUser: ["\(senders )"], channelId: self.topcName , message: txtmsg, messageType: .audio, chatType: .user, groupID: nil, latitude: 0.0, longitude: 0.0, address: "", forwardedMsgId: "", cloleFile: nil, sender: senders , isSelected: true,createat: create ,timestampDate:timestamp2 ?? "",senderName:senderName,SenderProfImg:senderProfImg)
                        UserDefaultHelper.userChatLastMsg = true
                        
                    }else {
                        ChatSocketIo.shared().messagePaylaodLast(arrUser: ["\(senders )"], channelId: self.topcName , message: txtmsg, messageType: .text, chatType: .user, groupID: nil, latitude: 0.0, longitude: 0.0, address: "", forwardedMsgId: "", cloleFile: nil, sender: senders , isSelected: true,createat: create ,timestampDate:timestamp2 ?? "",senderName:senderName,SenderProfImg:senderProfImg)
                        UserDefaultHelper.userChatLastMsg = true
                    }
                    
                }
                self.fetchHome.loadData()
                
            }
        }
    }
    
    fileprivate func blockUnblockUserApi() {
        let status = self.isBlockedByLoginUser == 6 ? 7 : 6
        if let userid = self.userID {
            APIRequest.shared().blockUnblockUserNew(userID:userid.description, block_unblock_status: status.description, completion: { (response, error) in
                
                if response != nil{
                    if let metaData = response?.value(forKey: CJsonMeta) as? [String : AnyObject] {
                        if metaData.valueForString(key: "message") == "User Blocked successfully" {
                            guard let user_ID =  appDelegate.loginUser?.user_id.description else { return}
                            guard let firstName = appDelegate.loginUser?.first_name else {return}
                            guard let lastName = appDelegate.loginUser?.last_name else {return}
                            MIGeneralsAPI.shared().sendNotification(userid.description, userID: user_ID.description, subject: "Blocked you", MsgType: "FRIEND_BLOCKED", MsgSent:"", showDisplayContent: "Blocked you", senderName: firstName + lastName, post_ID: [:])
                            self.txtViewMessage.isUserInteractionEnabled = false
                        }
                        
                        var isShowAlert = false
                        var alertMessage = ""
                        let message = metaData.valueForString(key: "message")
                        switch message {
                        case Blocked:
                            isShowAlert = true
                            alertMessage = CAlertblocked
                        case UnBlock:
                            isShowAlert = true
                            alertMessage = CAlertUnblock
                        default:
                            break
                        }
                        if isShowAlert{
                            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: alertMessage, btnOneTitle: CBtnOk, btnOneTapped: nil)
                        }
                    }
                }
            })
        }
    }
    
    // To store Image/Audio/Video in NSDocumentDirectory..
    fileprivate func storeMediaToLocal(_ mediaType: MessageType, latitude:Double = 0.0, longitude:Double = 0.0, address: String = "") {
        
        if let userid = self.userID {
            for media in self.arrSelectedMediaForChat {
                if mediaType == .image {
                    if let img = media as? UIImage {
                        //.....Store Image in Directory...
                        guard let mobileNum = appDelegate.loginUser?.mobile else { return }
                        MInioimageupload.shared().uploadMinioimages(mobileNo: mobileNum, ImageSTt: img,isFrom:"",uploadFrom:"")
                        MInioimageupload.shared().callback = { message in
                            self.uploadImgUrl = message
                            self.ImageAttachemntApiCall(uploadImgUrl:self.uploadImgUrl ?? "",type:"image", thumbLine: img)
                            
                        }
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
                            self.uploadImgUrl = message
                            self.ImageAttachemntApiCall(uploadImgUrl:self.uploadImgUrl ?? "",type:"video", thumbLine: urlVidoes)
                        }
                    }
                }else if mediaType == .audio && self.arrSelectedMediaForChat.count > 0 {
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
                           self.uploadImgUrl = message
                            self.ImageAttachemntApiCall(uploadImgUrl:self.uploadImgUrl ?? "",type:"audio", thumbLine: urlVidoes)
                        }
                        
                    }
                }else if mediaType == .location && self.arrSelectedMediaForChat.count > 0 {
                    guard let img = media as? UIImage else{
                        return
                    }
                    guard let mobileNum = appDelegate.loginUser?.mobile else { return }
                    MInioimageupload.shared().uploadMinioimages(mobileNo: mobileNum, ImageSTt: img,isFrom:"",uploadFrom:"")
                    MInioimageupload.shared().callback = { message in
                        self.uploadImgUrl = message
                        self.ImageAttachemntApiCall(uploadImgUrl:self.uploadImgUrl ?? "",type:"image", thumbLine: img)
                        
                    }
                    
                    //.....Store Image in Directory...
                    let documentsDirectory = self.applicationDocumentsDirectory()
                    let imgName = "/\(CApplicationName ?? "sevenchat")_\(Int(Date().currentTimeStamp * 1000)).jpg"
                    let imgPath = documentsDirectory?.appending(imgName)
                    let imageData =  img.jpegData(compressionQuality: 1.0)
                    if let path = imgPath {
                        let imgURL = URL(fileURLWithPath: path)
                        try! imageData?.write(to: imgURL, options: .atomicWrite)
                    }
                }
                
            }
            
            self.arrSelectedMediaForChat.removeAll()
            // Upload media on server...
            self.uploadMediaFileToServer()
        }
    }
    
    // Upload media on server....
    fileprivate func uploadMediaFileToServer() {
        if let userid = self.userID {
            _ = CMQTTUSERTOPIC + "\(appDelegate.loginUser?.user_id ?? 0)/\(userid)"
            if self.fetchHome.numberOfSections(in: tblChat) > 1 {
                self.tblChat.scrollToBottom()
            }
        }
    }
    
}

// MARK:- --------- FetchController
// MARK:-
extension UserChatDetailViewController {
    func setFetchController() {
        
        if notifcationStatus == true {
            createTopictoChat()
        }
        fetchHome = nil;
        if let userid = self.userID {
            print("topicname\(topcName)")
            strChannelId = topcName ?? ""
        }
        fetchHome = self.fetchController(listView: tblChat,
                                         entity: "TblMessages",
                                         sortDescriptors: [NSSortDescriptor.init(key: CCreated_at, ascending: false)],
                                         predicate: NSPredicate(format: "\(CChannel_id) == %@ ", strChannelId as CVarArg),
                                         sectionKeyPath: "msgdate",
                                         cellIdentifier: "MessageSenderTblCell",
                                         batchSize: 20) { [weak self] (indexpath, cell, item) -> (Void) in
            guard let self = self else { return }
            
            if indexpath == self.tblChat.lastIndexPath() && self.isLoadMore && self.sessionTask != nil {
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
                    //                    if let textlbl = self.lblUserBlockMessage.text{
                    //
                    //                    }
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
        
        fetchHome.blockIdentifierForRow = { [weak self] (_ indexPath:IndexPath, _ item:AnyObject?) in
            guard let _ = self else { return ""}
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
        
        fetchHome.blockIdentifierForFooter = { [weak self] (_ sectionIndex:Int, _ info:NSFetchedResultsSectionInfo?) in
            guard let _ = self else { return ""}
            return "ChatListHeaderView"
        }
        
        fetchHome.blockViewForFooter = { [weak self] (_ section:UIView?, _ index:Int, _ info:NSFetchedResultsSectionInfo?) in
            
            guard let _ = self else { return }
            let headerView =  section as! ChatListHeaderView
            let headerDate = DateFormatter.dateStringFrom(timestamp: Double("\(info?.name ?? "0")")!, withFormate: "dd MMMM yyyy")
            headerView.lblDate.text = headerDate.uppercased()
        }
        fetchHome.blockHeightForFooter = {  [weak self] (_ sectionIndex:Int, _ info:NSFetchedResultsSectionInfo?) in
            guard let _ = self else { return 0.0}
            return 50/375*CScreenWidth
        }
        
        fetchHome.loadData()
        
    }
}

// MARK:-  --------- Audio Related Functions
// MARK:-
extension UserChatDetailViewController: AudioReceiverCellDelegate, AudioSenderCellDelegate {
    
    // AudioSenderCellDelegate
    func cell(_ cell: AudioSenderTblCell, isPlay: Bool?) {
        
        // Pause Receiver Cell audio...
        if let cellRec = audioReceiverCell{
            audioReceiverCell = nil
            self.strSelectedAudioMessageID = nil
            MIAudioPlayer.shared().stopTrack()
            cellRec.btnPlayPause.isSelected = false
            cellRec.audioSlider.isUserInteractionEnabled = false
            cellRec.audioSlider.value = 0.0
        }
        
        if let cellSend = audioSenderCell{
            cellSend.btnPlayPause.isSelected = false
            cellSend.audioSlider.isUserInteractionEnabled = false
            MIAudioPlayer.shared().pauseTrack()
            
            if isPlay!{ // If playing new song that time set slider value = 0
                cellSend.audioSlider.value = 0.0
            }
            
        }
        
        if isPlay!{
            if let selectedID = self.strSelectedAudioMessageID, selectedID == cell.messageInformation.message_id {
                // If playing same song
                MIAudioPlayer.shared().playTrack()
            }else {
                MIAudioPlayer.shared().prepareTrack(cell.audioUrl)
            }
            
            self.audioSenderCell = cell
            self.strSelectedAudioMessageID = cell.messageInformation.message_id
            self.audioSenderCell.btnPlayPause.isSelected = true
            self.audioSenderCell.audioSlider.isUserInteractionEnabled = true
        }
    }
    
    // AudioReceiverTblCell
    func cell(_ cell: AudioReceiverTblCell, isPlay: Bool?) {
        // Pause Sender Cell audio...
        if let cellSend = audioSenderCell{
            audioSenderCell = nil
            self.strSelectedAudioMessageID = nil
            MIAudioPlayer.shared().stopTrack()
            cellSend.btnPlayPause.isSelected = false
            cellSend.audioSlider.isUserInteractionEnabled = false
            cellSend.audioSlider.value = 0.0
        }
        
        if let cellRec = audioReceiverCell{
            cellRec.btnPlayPause.isSelected = false
            cellRec.audioSlider.isUserInteractionEnabled = false
            MIAudioPlayer.shared().pauseTrack()
            
            if isPlay!{ // If playing new song that time set slider value = 0
                cellRec.audioSlider.value = 0.0
            }
        }
        
        if isPlay!{
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
    
    
    fileprivate func stopAllAudio(){
        
        // Stop Sender audio file
        if let cellSend = audioSenderCell{
            audioSenderCell = nil
            self.strSelectedAudioMessageID = nil
            MIAudioPlayer.shared().stopTrack()
            cellSend.btnPlayPause.isSelected = false
            cellSend.audioSlider.isUserInteractionEnabled = false
            cellSend.audioSlider.value = 0.0
        }
        
        // Stop Receiver audio file
        if let cellRec = audioReceiverCell{
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
extension UserChatDetailViewController {
    func MIAudioPlayerDidFinishPlaying(successfully flag: Bool) {
        if flag {
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
extension UserChatDetailViewController: GenericTextViewDelegate {
    
    func genericTextViewDidChange(_ textView: UITextView, height: CGFloat) {
        if textView.text.count < 1 || textView.text.trim.isBlank{
            btnSend.isUserInteractionEnabled = false
            btnAttachment.isHidden = false
            btnSend.alpha = 0.5
        }else{
            btnAttachment.isHidden = true
            btnSend.isUserInteractionEnabled = true
            btnSend.alpha = 1
        }
        
        if height < 34 {
            cnTextViewHeightHeight.constant = 34
        }else if height > 100{
            cnTextViewHeightHeight.constant = 100
        }else{
            cnTextViewHeightHeight.constant = height
        }
    }
}

// MARK:- --------- Audio Message Event
// MARK:-
extension UserChatDetailViewController {
    
    @objc func singlelPress(_ sender: UIGestureRecognizer){
        MIToastAlert.shared.showToastAlert(position: .bottom, message: "Hold to record,Relase to send " )
    }
    @objc func audioMsglongTap(_ sender: UIGestureRecognizer){
        if sender.state == .ended {
            audioMsgView.isHidden = true
            audioMsgTimeLbl.isHidden = true
            txtViewMessage.isHidden = false
            txtViewMessage.placeHolder = ""
            self.isRecordingfunc(_isRecording: false)
            
        }
        else if sender.state == .began {
            txtViewMessage.placeHolder = ""
            txtViewMessage.isHidden = true
            self.isRecordingfunc(_isRecording: true)
            
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

// MARK:- --------- Action Event
// MARK:-
extension UserChatDetailViewController {
    
    @IBAction func btnMainBackCLK(_ sender : UIButton){
        if isCreateNewChat == true{
            self.navigationController?.popToRootViewController(animated: true)
        }else if ChatListPage == true{
            self.navigationController?.popViewController(animated: true)
        }else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func btnVideoClicked(_ sender: UIButton) {
        //        guard let _userid = self.userID else { return }
        
    }
    
    @IBAction func btnAudioClicked(_ sender: UIButton) {
        //        guard let _userid = self.userID else { return }
    }
    
    @IBAction func btnMoreCLK(_ sender : UIButton){
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let reportAction = UIAlertAction(title: CBtnReportUser, style: .default) { [weak self] (_) in
            guard let _ = self else { return }
            if let userid = self?.userID {
                if let reportVC = CStoryboardGeneral.instantiateViewController(withIdentifier: "ReportViewController") as? ReportViewController {
                    reportVC.reportType = .reportUser
                    reportVC.userID = userid
                    reportVC.reportIDNEW = userid.toString
                    
                    self?.navigationController?.pushViewController(reportVC, animated: true)
                }
            }
        }
        let strBlockUnblock = self.isBlockedByLoginUser == 0 ? CBtnBlockUser : CBtnUnblockUser
        let blockAction = UIAlertAction(title: strBlockUnblock, style: .default) { [weak self] (_) in
            guard let _ = self else { return }
            self?.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: CMessageBlockUser, btnOneTitle: CBtnYes, btnOneTapped: { [weak self](alert) in
                self?.blockUnblockUserApi()
                self?.navigationController?.popViewController(animated: true)
                //self?.blockUnblockUserApi(self?.isBlock == true ? 7 : 6)
            }, btnTwoTitle: CBtnNo, btnTwoTapped: nil)
           // self?.blockUnblockUserApi()
        }
        alertController.addAction(reportAction)
        if !self.viewMessageContainer.isHidden {
            alertController.addAction(blockAction)
        }
        showHideVideoAudio()
        alertController.addAction(UIAlertAction(title: CBtnCancel, style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func btnUserInfoCLK(_ sender : UIButton) {
        if let userInfo = self.iObject as? [String : Any] {
            var userID :String = userInfo.valueForString(key: CFriendId)
            if userID.isBlank{
                userID = userInfo.valueForString(key: CUserId)
            }
            appDelegate.moveOnProfileScreenNew(userID, userInfo.valueForString(key: CUsermailID), self)
            
        }
    }
    
    @IBAction func btnSendCLK(_ sender : UIButton){
        
//        ChatSocketIo.shared().SocketInitilized()
        if sessionTask != nil {
            //            if sessionTask.state == .running {
            //                print(" Api calling continue =========")
            //                return
            //            }
        }
        
        if !ChatSocketIo.shared().socketClient.isConnected(){
            ChatSocketIo.shared().reconnect()
        }
        
        
        if isCreateNewChat == true {
//            createTopictoChat()
        }
        if isCopySeleted == true{
            self.lblDeleteCount.text = ""
        }
        guard let user_id = appDelegate.loginUser?.user_id else { return }
        let textMsg = txtViewMessage.text as Any
        if !txtViewMessage.text.trim.isBlank {
            if let userid = self.userID{
                guard let firstName = appDelegate.loginUser?.first_name  else { return }
                guard let lastName = appDelegate.loginUser?.last_name else { return }
                guard let profileImage = appDelegate.loginUser?.profile_img else { return }
                let content:[String:Any]  = [
                    "message": txtViewMessage.text as Any,
                    "type": "text",
                    "name" : firstName + lastName,
                    "profile_image":profileImage
                ]
                let dictAsString = asString(jsonDictionary: content)
                let dict:[String:Any] = [
                    "sender": user_id.description,
                    "topic" : topcName,
                    "content":dictAsString,
                ]
                sessionTask = APIRequest.shared().userSentMsg(dict:dict) { [weak self] (response, error) in
                    guard let self = self else { return }
                    self.tblChat.tableFooterView = UIView()
                    if response != nil && error == nil {
                        DispatchQueue.main.async{
                            guard let arrList = response as? [String:Any] else { return }
//                            self.fetchHome.loadData()
                            if let arrStatus = arrList["message"] as? String{
                                guard let userid = appDelegate.loginUser?.user_id else { return}
                                guard let firstName = appDelegate.loginUser?.first_name else {return}
                                guard let lastName = appDelegate.loginUser?.last_name else {return}
                                MIGeneralsAPI.shared().sendNotification(self.userID?.description, userID:userid.description , subject: "send a text message to you", MsgType: "CHAT_MESSAGE", MsgSent: textMsg as? String, showDisplayContent: "send a text message to you", senderName: firstName + lastName, post_ID: self.chatInfoNot)
                                self.fetchHome.loadData()
                            }
                        }
                    }
                }
                self.fetchHome.loadData()
                txtViewMessage.text = nil
                txtViewMessage.updatePlaceholderFrame(false)
                cnTextViewHeightHeight.constant = 34
                txtViewMessage.resignFirstResponder()
                btnAttachment.isHidden = false
                btnSend.isUserInteractionEnabled = true
                btnSend.alpha = 0.5
                self.tblChat.scrollToBottom()
            }
        }
    }
    
    //MARK :- Message Sent With Notfication
    @objc func MsgsentNotifications(notification: Notification) {
        // Update chat message table from local..
        //        if fetchHome != nil {
        fetchHome.loadData()
        //        }
        GCDMainThread.asyncAfter(deadline: .now() + 1) {
            self.isLoadMore = false
        }
    }
    
    //MARK :- Recvied Side  Sent With Notfication
    @objc func MsgrecviedNotification(notification: Notification) {
        // Update chat message table from local..
        //        if fetchHome != nil {
        fetchHome.loadData()
        //        }
        GCDMainThread.asyncAfter(deadline: .now() + 2) {
            self.isLoadMore = true
        }
    }
    
    func btnAttachmentCLK_call(){
        self.resignKeyboard()
        self.stopAllAudio()
        weak var weakSelf = self
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: CBtnCamera, style: .default, handler: { (alert) in
            weakSelf?.presentImagePickerControllerForCamera(imagePickerControllerCompletionHandler: {  (image, info) in
                if let img = image {
                    weakSelf?.arrSelectedMediaForChat.removeAll()
                    weakSelf?.arrSelectedMediaForChat.append(img)
                    weakSelf?.storeMediaToLocal(.image)
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
            weakSelf?.navigationController?.pushViewController(galleryListVC, animated: true)
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
                        let alertController = UIAlertController(title:message, message:CAutodelete_change, preferredStyle: UIAlertController.Style.alert);
                        alertController.addAction(UIAlertAction(title: CBtnYes, style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
                            weakSelf?.arrSelectedMediaForChat.removeAll()
                            weakSelf?.arrSelectedMediaForChat.append(audioName as Any)
                            weakSelf?.storeMediaToLocal(.audio)
                            
                        }))
                        self.present(alertController, animated: false, completion: { () -> Void in
                        })
                        
                    }
                })
                weakSelf?.present(songVC, animated: true, completion: nil)
            }
        })
        let imgAudio = UIImage(named: "ic_audio_option")?.withRenderingMode(.alwaysOriginal)
        audioAction.setValue(imgAudio, forKey: "image")
        audioAction.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        audioAction.setValue(UIColor.black, forKey: "titleTextColor")
        alertController.addAction(audioAction)
        
        let videoAction = UIAlertAction(title: CBtnVideo, style: .default, handler: { (alert) in
            MIVideoCameraGallery.shared().presentVideoGallery(self, { (url, info) in
                if url != nil{
                    //Upload vidoe url to minio
                    
                    let message = CVideoSendConfirmation + " " + (url?.lastPathComponent ?? "")
                    weakSelf?.presentAlertViewWithCheckButtons(alertTitle:message, alertMessage: CAutodelete_change, btnOneTitle: CBtnYes, btnOneTapped: { (alert) in
                        MIVideoCameraGallery.shared().exportVideoWithFinalOutput(url, drawingImage: nil, { (comUrl, completed, videoName) in
                            if completed {
                                
                                weakSelf?.arrSelectedMediaForChat.removeAll()
                                weakSelf?.arrSelectedMediaForChat.append(comUrl?.description as Any)
                                weakSelf?.storeMediaToLocal(.video)
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
        
        let shareLocationAction = UIAlertAction(title: CLocation, style: .default, handler: { (alert) in
            self.locationPicker?.showCurrentLocationButton = true
            self.locationPicker?.getImageLocation = true
            
            self.locationPicker?.completionAutoDelete = {[weak self] dataReturned in
                self?.autodelete = dataReturned
            }
            self.locationPicker?.completion = {  (placeDetail) in
                if let img = placeDetail?.locationImage {
                    weakSelf?.arrSelectedMediaForChat.removeAll()
                    weakSelf?.arrSelectedMediaForChat.append(img)
                    weakSelf?.storeMediaToLocal(
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
    
    @IBAction func btnAttachmentCLK(_ sender : UIButton){
        btnAttachmentCLK_call()
    }
    
    @IBAction func btnTexttovoiceCLK(_ sender : UIButton){
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

//MARK:- Audio message send
extension UserChatDetailViewController{
    
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
            play_btn_ref.isEnabled = true
            isRecording = false
        }else{
            setup_recorder()
            audioRecorder.record()
            meterTimer = Timer.scheduledTimer(timeInterval: 0.1, target:self, selector:#selector(self.updateAudioMeter(timer:)), userInfo:nil, repeats:true)
            play_btn_ref.isEnabled = false
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
                let mediaItem = getFileUrl()
                let URL: NSURL = NSURL(string: getFileUrl().path)!
                
                let songAsset = AVURLAsset(url: URL as URL, options: nil)
                let exporter = AVAssetExportSession(asset: songAsset, presetName: AVAssetExportPresetAppleM4A)
                exporter?.outputFileType = AVFileType.m4a
                exporter?.outputURL = mediaItem
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
}

//MARK:Audio Delegate Methods

extension UserChatDetailViewController:AVAudioRecorderDelegate, AVAudioPlayerDelegate{
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool){
        if !flag{
            finishAudioRecording(success: false)
        }
    }
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool){
    }
}


//MARK : Chat Multiple COPY & FORWARD & DELETE
extension UserChatDetailViewController{
    
    func claerchatController() {
        if let arrMessages = TblMessages.fetchAllObjects() as? [TblMessages] {
            for _ in arrMessages {
            }
        }
    }
    func delSelectedChatMessages() {
        if messageidListItems.count > 0 {
            for msArrayid in messageidListItems{
                if let arrMessages = TblMessages.fetchAllObjects() as? [TblMessages] {
                    for arrMsg in arrMessages{
                        if arrMsg.message_id == msArrayid{
                        }
                    }
                }
            }
        }
        self.messageidListItems.removeAll()
        tblChat.reloadData()
        lblDeleteCount.text = ""
    }
    
    @IBAction func btnSwipeforwardCLK(_ sender : UIButton){
        if messageidListItems.count > 0 {
            for msArrayid in messageidListItems{
                if let arrMessages = TblMessages.fetchAllObjects() as? [TblMessages] {
                    for arrMsg in arrMessages{
                        if arrMsg.message_id == msArrayid{
                            let addPostView = SwipeReplayMsgView.initHomeAddPostMenuViews()
                            self.view.addSubview(addPostView)
                            addPostView.showPostOption()
                            addPostView.showPostMessage(arrMsg, UserId: self.userID ?? 0, chatTypeMode: 1)
                            
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func btnDeleteCLK(_ sender : UIButton){
        self.delSelectedChatMessages()
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
                            pastebaord.addItems([[UIPasteboard.typeListString[0] as! String : "["],[UIPasteboard.typeListString[0] as! String : Datevalue],[UIPasteboard.typeListString[0] as! String : " "],[UIPasteboard.typeListString[0] as! String : "]"],[UIPasteboard.typeListString[0] as! String : arrMsg.full_name ?? ""],[UIPasteboard.typeListString[0] as! String : ":"],[UIPasteboard.typeListString[0] as! String : arrMsg.message ?? ""]])
                        }
                    }
                }
            }
        }
        self.messageidListItems.removeAll()
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
}

//MARK : Chat with Voice Messages

extension UserChatDetailViewController{
    
    func convertTexttovoice() {
        print("\(type(of: self)) \(#function)")
        session.requestRecordPermission { [weak self] (granted) in
            guard granted else {
                return
            }
            guard let strongSelf = self else {
                return
            }
            do {
                try strongSelf.session.setCategory(.playAndRecord, mode:.spokenAudio, options: [.defaultToSpeaker])
                
                try strongSelf.session.setActive(true)
                
                let recordingFileName = "recording.m4a"
                
                self?.latestFileName = recordingFileName
                
                let recordingURL = strongSelf.documentsDirectoryURL().appendingPathComponent(recordingFileName)
                
                let settings: [String : Any] = [
                    AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue,
                    AVSampleRateKey: 12000.0,
                    AVNumberOfChannelsKey: 1,
                    AVFormatIDKey: Int(kAudioFormatMPEG4AAC)
                ]
                
                try strongSelf.audioRecorder = AVAudioRecorder(
                    url: recordingURL,
                    settings: settings
                )
                strongSelf.audioRecorder?.record()
            }catch let error {
                print("error recordAudio: \(error)")
            }
        }
    }
    
    private func documentsDirectoryURL() -> URL {
        print("\(type(of: self)) \(#function)")
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print("=====\(urls)=============")
        return urls[urls.count-1]
    }
    
}

extension UserChatDetailViewController : AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        print("\(type(of: self)) \(#function)")
        audioRecorder?.stop()
    }
}

extension UserChatDetailViewController{
    func asString(jsonDictionary: [String:Any]) -> String {
        do {
            let data = try JSONSerialization.data(withJSONObject: jsonDictionary, options: .prettyPrinted)
            return String(data: data, encoding: String.Encoding.utf8) ?? ""
        } catch {
            return ""
        }
    }
}

extension Dictionary {
    mutating func updateKeys(_ transform: (Key) -> Key) {
        self = Dictionary(uniqueKeysWithValues:
                            self.map { (transform($0), $1) })
    }
}


extension UserChatDetailViewController{
    func getChatMessagesFromServer(dict : [String:Any],isNew:Bool) {
        if sessionTask != nil {
            if sessionTask.state == .running {
                print(" Api calling continue =========")
                return
            }
        }
        sessionTask = APIRequest.shared().userSentMsg(dict:dict) { [weak self] (response, error) in
            
            guard let self = self else { return }
            self.refreshControl.endRefreshing()
            self.tblChat.tableFooterView = UIView()
            if response != nil && error == nil {
                guard let arrList = response as? [String:Any] else { return }
                self.fetchHome.loadData()
                if let arrStatus = arrList["message"] as? String{
                    print("#######arrStatus\(arrStatus)")
                }
            }
        }
    }
    
}


extension UserChatDetailViewController{
    
    func convertToDictionary(from text: String) throws -> [String: String] {
        guard let data = text.data(using: .utf8) else { return [:] }
        let anyResult: Any = try JSONSerialization.jsonObject(with: data, options: [])
        return anyResult as? [String: String] ?? [:]
    }
    
    func convertToDictionarywithtry(from text: String) -> [String: String]? {
        guard let data = text.data(using: .utf8) else { return nil }
        let anyResult = try? JSONSerialization.jsonObject(with: data, options: [])
        return anyResult as? [String: String]
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

//MARK  API CALLS: Chat Multiple Image & Audio & Videos upload
extension UserChatDetailViewController{
    
    
    func ImageAttachemntApiCall(uploadImgUrl:String,type:String,thumbLine:UIImage){
        
        if !ChatSocketIo.shared().socketClient.isConnected(){
            ChatSocketIo.shared().reconnect()
        }
        
        guard let user_id = appDelegate.loginUser?.user_id else { return }
        guard let firstName = appDelegate.loginUser?.first_name  else { return }
        guard let lastName = appDelegate.loginUser?.last_name else { return }
        guard let profileImage = appDelegate.loginUser?.profile_img else { return }
        if let userid = self.userID{
            
            let contentString:[String:Any]  = [
                "message": uploadImgUrl,
                "type": type,
                "name" : firstName + lastName,
                "profile_image":profileImage,
                "chat":"chat",
            ]
            let dictAsString = asString(jsonDictionary: contentString)
            let trimmedString = dictAsString.components(separatedBy: .whitespacesAndNewlines).joined()
            let uploadimage = trimmedString.replacingOccurrences(of: "\\/", with: "/")
            let dict:[String:Any] = [
                "sender": user_id.description,
                "topic" : topcName,
                "content":uploadimage,
            ]
            sessionTask = APIRequest.shared().userSentMsg(dict:dict) { [weak self] (response, error) in
                guard let self = self else { return }
                self.refreshControl.endRefreshing()
                self.tblChat.tableFooterView = UIView()
                if response != nil && error == nil {
                    DispatchQueue.main.async{
                        guard let arrList = response as? [String:Any] else { return }
                        self.fetchHome.loadData()
                        ChatSocketIo.shared().socketDelegate = self
                        
                        guard let userid = appDelegate.loginUser?.user_id else { return}
                        guard let firstName = appDelegate.loginUser?.first_name else {return}
                        guard let lastName = appDelegate.loginUser?.last_name else {return}
                        MIGeneralsAPI.shared().sendNotification(self.userID?.description, userID:userid.description , subject: "send a text message to you", MsgType: "CHAT_MESSAGE", MsgSent: type, showDisplayContent: "send a text message to you", senderName: firstName + lastName, post_ID: self.chatInfoNot)
                        if let arrStatus = arrList["message"] as? String{
                            print("arrStatus,\(arrStatus)")
                        }
                    }
                }
            }
            self.tblChat.scrollToBottom()
        }
    }
    
}



