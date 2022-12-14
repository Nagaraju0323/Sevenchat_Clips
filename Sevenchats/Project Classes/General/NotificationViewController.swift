//
//  NotificationViewController.swift
//  Sevenchats
//
//  Created by Mac-0006 on 23/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//


/*********************************************************
 * Author  : Nagaraju K and Chandrika R                                 *
 * Model   : NotificationViewController                  *
 * Changes :                                             *
 ********************************************************/

import UIKit
import ActiveLabel
enum NotificationName {
    
    case sun
    case CHAT_MESSAGE
    case GROUP_MESSAGE
    case GROUP_ADD
    case GROUP_REMOVE
    case FRIEND_ACCEPT
    case FRIEND_BLOCKED
    case FRIEND_REQUEST
    case EVENT_CHOICE
    case COMMENT
}

class NotificationViewController: ParentViewController {
    
    @IBOutlet weak var tblVNotification: UITableView!
    
    var arrNotiificationList = [[String: Any]]()
    var apiTask: URLSessionTask?
    var refreshControl = UIRefreshControl()
    var apiTimeStamp = 0.0
    var pageNumber = 1
    var subjectCat = ""
    var userID = ""
    var isLoadMoreCompleted = false
    var postInfo = [String:Any]()
    var post_type = ""
    var post_id = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Initialization()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.pageNumber = 1
        self.getNotificationListFromServer(isLoader: true)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK:- ---------- Initialization
    func Initialization() {
        self.title = CSideNotifications
        GCDMainThread.async {
            self.refreshControl.addTarget(self, action: #selector(self.pullToRefresh), for: .valueChanged)
            self.refreshControl.tintColor = ColorAppTheme
            self.tblVNotification.pullToRefreshControl = self.refreshControl
            self.pageNumber = 1
            self.getNotificationListFromServer(isLoader: true)
        }
//        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: #imageLiteral(resourceName: "ic_info_tint"), style: .plain, target: self, action: #selector(btnHelpInfoClicked(_:)))]
    }
    
    @objc fileprivate func btnHelpInfoClicked(_ sender : UIBarButtonItem){
        if let helpLineVC = CStoryboardHelpLine.instantiateViewController(withIdentifier: "HelpLineViewController") as? HelpLineViewController {
            helpLineVC.fromVC = "notificationVC"
            self.navigationController?.pushViewController(helpLineVC, animated: true)
        }
        
    }
    
    
}

// MARK:- ---------- Api Functions
extension NotificationViewController {
    
    @objc func pullToRefresh() {
        refreshControl.beginRefreshing()
        apiTimeStamp = 0.0
        self.pageNumber = 1
        self.getNotificationListFromServer()
    }
    
    fileprivate func getNotificationListFromServer(isLoader:Bool = false) {
        
        guard let user_ID = appDelegate.loginUser?.user_id else { return}
        
        if apiTask?.state == URLSessionTask.State.running {
            apiTask?.cancel()
        }
        if isLoader{
            MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: "\(CMessagePleaseWait)...")
        }
        
        if self.pageNumber > 2 {
            self.tblVNotification.tableFooterView = self.loadMoreIndicator(ColorAppTheme)
        }else{
            self.tblVNotification.tableFooterView = nil
        }
        
        var param = [String:Any]()
        param["receiver"] = user_ID.description
        param["type"] = "1"
        param[CPage] = pageNumber
        param["limit"] = "20"
        
        apiTask = APIRequest.shared().getNotificationList(param:param, completion: { [weak self] (response, error) in
            guard let self = self else { return }
            MILoader.shared.hideLoader()
            self.refreshControl.endRefreshing()
            self.apiTask?.cancel()
            self.tblVNotification.tableFooterView = nil
            
            if response != nil && error == nil {
                if let responseData = response![CJsonData] as? [[String : Any]]     {
                    //...Remove all data
                    if self.pageNumber == 1 {
                        self.arrNotiificationList.removeAll()
                        self.tblVNotification.reloadData()
                        //                        MIGeneralsAPI.shared().readNotification("-1")
                    }
                    //                    self.isLoadMoreCompleted = responseData.isEmpty
                    
                    //...Add Data here...
                    if (responseData.count > 0) {
                        self.arrNotiificationList = self.arrNotiificationList + responseData
                        self.tblVNotification.reloadData()
                        self.pageNumber += 1
                        if let metaInfo = response![CJsonMeta] as? [String : Any] {
                            self.apiTimeStamp = metaInfo.valueForDouble(key: "timestamp") ?? 0.0
                        }
                    }
                }
            }
        })
    }
    
    // Update Friend status Friend/Unfriend/Cancel Request
    fileprivate func friendStatusApi( _ userid : String?,  _ status : Int?, indexPath: IndexPath) {
        guard let userID = appDelegate.loginUser?.user_id else { return }
        
        let dict :[String:Any]  =  [
            CUserId:  userID,
            CFriendUserID: userid?.description as Any,
            Crequesttype: status!.toString
        ]
        
        APIRequest.shared().friendRquestStatus(dict: dict, completion: { [weak self] (response, error) in
            guard let self = self else { return }
            if response != nil {
                self.arrNotiificationList.remove(at: indexPath.row)
                UIView.performWithoutAnimation {
                    self.tblVNotification.reloadData()
                }
            }
        })
    }
    
    fileprivate func btnInterestedNotInterestedMayBeCLK(_ type : Int?, _ indexpath : IndexPath?) {
        
        var notificationInfo = arrNotiificationList[indexpath!.row]
        if type != notificationInfo.valueForInt(key: CIsInterested) {
            
            // Update existing count here...
            let totalIntersted = notificationInfo.valueForInt(key: CTotalInterestedUsers)
            let totalNotIntersted = notificationInfo.valueForInt(key: CTotalNotInterestedUsers)
            let totalMaybe = notificationInfo.valueForInt(key: CTotalMaybeInterestedUsers)
            switch notificationInfo.valueForInt(key: CIsInterested) {
            case CTypeInterested:
                notificationInfo[CTotalInterestedUsers] = totalIntersted! - 1
                break
            case CTypeNotInterested:
                notificationInfo[CTotalNotInterestedUsers] = totalNotIntersted! - 1
                break
            case CTypeMayBeInterested:
                notificationInfo[CTotalMaybeInterestedUsers] = totalMaybe! - 1
                break
            default:
                break
            }
            notificationInfo[CIsInterested] = type
            
            switch type {
            case CTypeInterested:
                notificationInfo[CTotalInterestedUsers] = totalIntersted! + 1
                break
            case CTypeNotInterested:
                notificationInfo[CTotalNotInterestedUsers] = totalNotIntersted! + 1
                break
            case CTypeMayBeInterested:
                notificationInfo[CTotalMaybeInterestedUsers] = totalMaybe! + 1
                break
            default:
                break
            }
            var postId = notificationInfo.valueForInt(key: CId)
            let isSharedPost = notificationInfo.valueForInt(key: CIsSharedPost)
            if isSharedPost == 1{
                postId = notificationInfo[COriginalPostId] as? Int ?? 0
            }
            MIGeneralsAPI.shared().interestNotInterestMayBe(postId, type!, viewController: self)
            
            arrNotiificationList.remove(at: (indexpath?.row)!)
            arrNotiificationList.insert(notificationInfo, at: (indexpath?.row)!)
            self.tblVNotification.reloadData()
        }
    }
    
    func htmlToAttributedString(_ html: String, _ font: UIFont)-> NSAttributedString? {
        let modifiedFont = "<span style=\"font-family: \(font.fontName); font-size: \(font.pointSize)\">\(html)</span>"
        guard let data = modifiedFont.data(using: String.Encoding.unicode) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType:  NSAttributedString.DocumentType.html], documentAttributes: nil)
            
        } catch {
            return NSAttributedString()
        }
    }
    
}

// MARK:- --------- UITableView Datasources/Delegate

extension NotificationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.arrNotiificationList.isEmpty{
            self.tblVNotification.setEmptyMessage(CNoNotificationsYet)
        }else{
            self.tblVNotification.restore()
        }
        return arrNotiificationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var contentInfo = ""
        let notificationInfo = arrNotiificationList[indexPath.row]
        print("::::::::::::\(notificationInfo)")
        let dict = notificationInfo.valueForString(key: "content")
        let stringCovt = dict.replace(string: "\\", replacement: "\"")
        let notificationDict = convertToDictionary(from: stringCovt)
        let notifcationContent = notificationDict.valueForString(key:"content")
        let senderType = notificationDict.valueForString(key:"type")
        
        if senderType == "CHAT_MESSAGE"
        {
            let str_Back_desc = notifcationContent.return_replaceBack(replaceBack: notifcationContent)
            contentInfo = str_Back_desc
            
            
        }else {
            contentInfo = notifcationContent
        }
        let created_At = notificationInfo.valueForString(key: "timestamp")
        let cnvStr = created_At.stringBefore("G")
        let startCreated = DateFormatter.shared().convertDatereversLatest(strDate: cnvStr)
        //Notification Type with show Details
        if let cell = tblVNotification.dequeueReusableCell(withIdentifier: "NotificationGeneralTblCell") as? NotificationGeneralTblCell{
            cell.lblDate.text = startCreated
            cell.imgUser.loadImageFromUrl(notificationInfo.valueForString(key: "icon"), true)
            cell.lblNotificationDetails.font = CFontPoppins(size: 14, type: .light).setUpAppropriateFont()
            cell.lblNotificationDetails.attributedText = self.htmlToAttributedString(contentInfo, cell.lblNotificationDetails.font)
            let readStatus = notificationInfo.valueForString(key:"read_status")
            if readStatus.toInt == 1 {
                cell.contentView.backgroundColor = .white
            } else {
                
                cell.contentView.backgroundColor = .lightGray
            }
            if indexPath == tblVNotification.lastIndexPath() && !self.isLoadMoreCompleted{
                self.getNotificationListFromServer(isLoader: true)
            }
            
            return cell
        }
        return UITableViewCell()
        
    }
    
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //
    //        var notifKey = ""
    //        let notificationInfo = arrNotiificationList[indexPath.row]
    //        let notfiContent = notificationInfo.valueForString(key: "content")
    //        userID = notificationInfo.valueForString(key: "sender")
    //        let nib = notificationInfo.valueForString(key: "nid")
    //        do {
    //            let dict = try convertToDictionary(from: notfiContent)
    //            guard let userMsg = dict["type"] else { return }
    //            guard let subject = dict["subject"] else { return }
    //            let postinfo = dict["postInfo"] as? [String:Any] ?? [:]
    //            if let post_types = postinfo.valueForString(key: "type") as? String{
    //                post_type = post_types
    //            }
    //
    //            if let post_ids = postinfo.valueForString(key: "typost_idpe") as? String{
    //                post_id = post_ids
    //            }
    //            postInfo = postinfo
    //            subjectCat = subject as! String
    //            notifKey = userMsg as! String
    //        } catch let error  {
    //            print("error trying to convert data to \(error)")
    //        }
    //
    //        let notifReadStatus = notificationInfo.valueForString(key: "read_status")
    //        if notifReadStatus.toInt == 1{
    //            switch notifKey {
    //            case kNotTypeChatUser:
    //                if self.subjectCat == "Product viewed"{
    //                    appDelegate.moveOnProfileScreenNew(self.userID.description, self.userID.description, self)
    //                }else {
    //                    if let userChatDetailVC = CStoryboardChat.instantiateViewController(withIdentifier: "UserChatDetailViewController") as? UserChatDetailViewController {
    //                        userChatDetailVC.iObject =  self.postInfo
    //                        userChatDetailVC.self.userID = userID.toInt
    //                        userChatDetailVC.isCreateNewChat = true
    //                        self.navigationController?.pushViewController(userChatDetailVC, animated: true)
    //                    }
    //                }
    //                break
    //            case kNotTypeGroupRemove:
    //                if let groupChatDetailVC = CStoryboardGroup.instantiateViewController(withIdentifier: "GroupsViewController") as? GroupsViewController {
    //                    self.navigationController?.pushViewController(groupChatDetailVC, animated: true)
    //                }
    //                break
    //
    //            case kNotTypeGroup:
    //                if let groupChatDetailVC = CStoryboardGroup.instantiateViewController(withIdentifier: "GroupChatDetailsViewController") as? GroupChatDetailsViewController {
    //                    groupChatDetailVC.iObject =  self.postInfo
    //                    groupChatDetailVC.isCreateNewChat = false
    //                    self.navigationController?.pushViewController(groupChatDetailVC, animated: true)
    //                }
    //
    //                break
    //
    //            case kNotTypeGroupADD:
    //                //Group chat detail screen
    //                if let groupChatDetailVC = CStoryboardGroup.instantiateViewController(withIdentifier: "GroupChatDetailsViewController") as? GroupChatDetailsViewController {
    //                    groupChatDetailVC.iObject =  self.postInfo
    //                    groupChatDetailVC.isCreateNewChat = false
    //                    self.navigationController?.pushViewController(groupChatDetailVC, animated: true)
    //                }
    //                break
    //
    //            case kNotTypeFriendReqAccept,
    //                 kNotTypeFriendReqSentNew:
    //
    //                appDelegate.moveOnProfileScreenNew(notificationInfo.valueForString(key: "sender"),notificationInfo.valueForString(key: CUsermailID), self)
    //              //  appDelegate.moveOnProfileScreen(notificationInfo.valueForString(key: "sender"), self)
    //                break
    //            case kNotTypeFriendBlocked:
    //
    //                self.presentAlertViewWithOneButton(alertTitle: CAlertblocked, alertMessage: CMessageNoLongerFriend, btnOneTitle: CBtnOk, btnOneTapped: nil)
    //
    //                break
    //            case  kNotTypeEventType:
    //
    //                if let eventInviteesVC = CStoryboardEvent.instantiateViewController(withIdentifier: "EventDetailImageViewController") as? EventDetailImageViewController{
    //                    let postID = postInfo.valueForString(key: CPostId)
    //                    eventInviteesVC.postIDNew = postID
    //                    eventInviteesVC.postID = postID.toInt
    //                    eventInviteesVC.eventInfo = postInfo
    //                    self.navigationController?.pushViewController(eventInviteesVC, animated: true)
    //                }
    //                break
    //
    //            case kNotTypeCommnet,kNotTypeCommnet:
    //                switch post_type {
    //                case "post_shout":
    //                    if let shoutsDetailsVC = CStoryboardHome.instantiateViewController(withIdentifier: "ShoutsDetailViewController") as? ShoutsDetailViewController{
    //                        shoutsDetailsVC.shoutInformations = postInfo
    //                        print(postInfo.valueForString(key: "post_id"))
    //                        shoutsDetailsVC.shoutID = postInfo.valueForString(key: "post_id").toInt
    //                        self.navigationController?.pushViewController(shoutsDetailsVC, animated: true)
    //                    }
    //                case "post_article":
    //                    if let articleDetailVC = CStoryboardHome.instantiateViewController(withIdentifier: "ArticleDetailViewController") as? ArticleDetailViewController {
    //                        articleDetailVC.articleInformation = postInfo
    //                        articleDetailVC.articleID = postInfo.valueForString(key: "post_id").toInt
    //                        self.navigationController?.pushViewController(articleDetailVC, animated: true)
    //                    }
    //                case "post_gallery":
    //                    let postID = postInfo.valueForString(key: "post_id")
    //                    self.getGalleryDetailsFromServer(imgPostId: postID.toInt,postInfo:self.postInfo)
    //
    //
    //                case "post_chirpy":
    //                    if let chirpyDetailVC = CStoryboardHome.instantiateViewController(withIdentifier: "ChirpyImageDetailsViewController") as? ChirpyImageDetailsViewController {
    //                        chirpyDetailVC.chirpyInformation = postInfo
    //                        chirpyDetailVC.chirpyID = postInfo.valueForString(key: "post_id").toInt
    //                        self.navigationController?.pushViewController(chirpyDetailVC, animated: true)
    //                    }
    //                case "post_forum":
    //                    if let forumDetailVC = CStoryboardHome.instantiateViewController(withIdentifier: "ForumDetailViewController") as? ForumDetailViewController {
    //                        forumDetailVC.forumID = postInfo.valueForString(key: "post_id").toInt
    //                        forumDetailVC.forumInformation = postInfo
    //                        self.navigationController?.pushViewController(forumDetailVC, animated: true)
    //                    }
    //                case "post_event":
    //                    if let eventDetailVC = CStoryboardEvent.instantiateViewController(withIdentifier: "EventDetailImageViewController") as? EventDetailImageViewController {
    //                        eventDetailVC.postID = postInfo.valueForString(key: "post_id").toInt
    //                        eventDetailVC.eventInfo = postInfo
    //                        self.navigationController?.pushViewController(eventDetailVC, animated: true)
    //                    }
    //                case "post_poll":
    //                    let productID = self.postInfo.valueForString(key: "post_id")
    //                    self.getPollDetailsFromServer(pollID: productID.toInt, postInfo: self.postInfo)
    //                case "productDetails":
    //                    let productID = self.postInfo.valueForString(key: "product_id")
    //                    if let ProductDetailVC = CStoryboardProduct.instantiateViewController(withIdentifier: "ProductDetailVC") as? ProductDetailVC {
    //                        ProductDetailVC.productIds = productID
    //                        self.navigationController?.pushViewController(ProductDetailVC, animated: true)
    //                    }
    //
    //                default:
    //                    break
    //
    //                }
    //                break
    //            default:
    //                break
    //            }
    //        }else {
    //            var para = [String:Any]()
    //            para["nid"] = nib
    //            para["status_id"] = "1"
    //            para["read_status"] = "1"
    //            APIRequest.shared().sendNotificationStautsUpdate(notifications: para, completion: { [weak self] (response, error) in
    //                guard let self = self else { return }
    //                self.apiTask?.cancel()
    //                if response != nil && error == nil {
    //                    if let responseData = response as? [String: Any] {
    //                        let response_Status = responseData["status"] as? Int
    //                        if response_Status == 0{
    //                            switch notifKey {
    //                            case kNotTypeChatUser:
    //                                if self.subjectCat == "Product viewed"{
    //                                    appDelegate.moveOnProfileScreenNew(self.userID.description, self.userID.description, self)
    //                                }else {
    //                                    if let userChatDetailVC = CStoryboardChat.instantiateViewController(withIdentifier: "UserChatDetailViewController") as? UserChatDetailViewController {
    //                                        userChatDetailVC.iObject =  self.postInfo
    //                                        userChatDetailVC.self.userID = self.userID.toInt
    //                                        userChatDetailVC.isCreateNewChat = true
    //                                        self.navigationController?.pushViewController(userChatDetailVC, animated: true)
    //                                    }
    //                                }
    //                                break
    //                            case kNotTypeGroupRemove:
    //                                if let groupChatDetailVC = CStoryboardGroup.instantiateViewController(withIdentifier: "GroupsViewController") as? GroupsViewController {
    //                                    self.navigationController?.pushViewController(groupChatDetailVC, animated: true)
    //                                }
    //                                break
    //                            case kNotTypeGroup:
    //                                if let groupChatDetailVC = CStoryboardGroup.instantiateViewController(withIdentifier: "GroupChatDetailsViewController") as? GroupChatDetailsViewController {
    //                                    groupChatDetailVC.iObject =  self.postInfo
    //                                    groupChatDetailVC.isCreateNewChat = false
    //                                    self.navigationController?.pushViewController(groupChatDetailVC, animated: true)
    //                                }
    //
    //                                break
    //                            case kNotTypeGroupADD:
    //                                //Group chat detail screen
    //                                if let groupChatDetailVC = CStoryboardGroup.instantiateViewController(withIdentifier: "GroupChatDetailsViewController") as? GroupChatDetailsViewController {
    //                                    groupChatDetailVC.iObject =  self.postInfo
    //                                    groupChatDetailVC.isCreateNewChat = false
    //                                    self.navigationController?.pushViewController(groupChatDetailVC, animated: true)
    //                                }
    //                                break
    //
    //
    //                            case kNotTypeFriendReqAccept,kNotTypeFriendReqSentNew:
    //                                appDelegate.moveOnProfileScreen(notificationInfo.valueForString(key: "sender"), self)
    //                                break
    //                            case kNotTypeFriendBlocked:
    //
    //                                self.presentAlertViewWithOneButton(alertTitle: CAlertblocked, alertMessage: CMessageNoLongerFriend, btnOneTitle: CBtnOk, btnOneTapped: nil)
    //
    //                                break
    //                            case  kNotTypeEventType:
    //                                if let eventInviteesVC = CStoryboardEvent.instantiateViewController(withIdentifier: "EventDetailImageViewController") as? EventDetailImageViewController{
    //                                    let postID = self.postInfo.valueForString(key: CPostId)
    //                                    eventInviteesVC.postID = postID.toInt
    //                                    eventInviteesVC.postIDNew = postID
    //                                    eventInviteesVC.eventInfo = self.postInfo
    //                                    self.navigationController?.pushViewController(eventInviteesVC, animated: true)
    //                                }
    //                                break
    //
    //                            case kNotTypeCommnet,kNotTypeCommnet:
    //
    //                                switch self.post_type {
    //                                case "post_shout":
    //                                    if let shoutsDetailsVC = CStoryboardHome.instantiateViewController(withIdentifier: "ShoutsDetailViewController") as? ShoutsDetailViewController{
    //                                        shoutsDetailsVC.shoutInformations = self.postInfo
    //                                        print(self.postInfo.valueForString(key: "post_id"))
    //                                        shoutsDetailsVC.shoutID = self.postInfo.valueForString(key: "post_id").toInt
    //                                        self.navigationController?.pushViewController(shoutsDetailsVC, animated: true)
    //                                    }
    //                                case "post_article":
    //                                    if let articleDetailVC = CStoryboardHome.instantiateViewController(withIdentifier: "ArticleDetailViewController") as? ArticleDetailViewController {
    //                                        articleDetailVC.articleInformation = self.postInfo
    //                                        articleDetailVC.articleID = self.postInfo.valueForString(key: "post_id").toInt
    //                                        self.navigationController?.pushViewController(articleDetailVC, animated: true)
    //                                    }
    //                                case "post_gallery":
    //                                    let postID = self.postInfo.valueForString(key: "post_id")
    //                                    self.getGalleryDetailsFromServer(imgPostId: postID.toInt,postInfo:self.postInfo)
    //
    //                                case "post_chirpy":
    //                                    if let chirpyDetailVC = CStoryboardHome.instantiateViewController(withIdentifier: "ChirpyImageDetailsViewController") as? ChirpyImageDetailsViewController {
    //                                        chirpyDetailVC.chirpyInformation = self.postInfo
    //                                        chirpyDetailVC.chirpyID = self.postInfo.valueForString(key: "post_id").toInt
    //                                        self.navigationController?.pushViewController(chirpyDetailVC, animated: true)
    //                                    }
    //                                case "post_forum":
    //                                    if let forumDetailVC = CStoryboardHome.instantiateViewController(withIdentifier: "ForumDetailViewController") as? ForumDetailViewController {
    //                                        forumDetailVC.forumID = self.postInfo.valueForString(key: "post_id").toInt
    //                                        forumDetailVC.forumInformation = self.postInfo
    //                                        self.navigationController?.pushViewController(forumDetailVC, animated: true)
    //                                    }
    //                                case "post_event":
    //                                    if let eventDetailVC = CStoryboardEvent.instantiateViewController(withIdentifier: "EventDetailImageViewController") as? EventDetailImageViewController {
    //                                        eventDetailVC.postID = self.postInfo.valueForString(key: "post_id").toInt
    //                                        eventDetailVC.eventInfo = self.postInfo
    //                                        self.navigationController?.pushViewController(eventDetailVC, animated: true)
    //                                    }
    //                                case "productDetails":
    //                                    let productID = self.postInfo.valueForString(key: "product_id")
    //                                    if let ProductDetailVC = CStoryboardProduct.instantiateViewController(withIdentifier: "ProductDetailVC") as? ProductDetailVC {
    //                                        ProductDetailVC.productIds = productID
    //                                        self.navigationController?.pushViewController(ProductDetailVC, animated: true)
    //                                    }
    //                                case "post_poll":
    //                                    let productID = self.postInfo.valueForString(key: "post_id")
    //                                    self.getPollDetailsFromServer(pollID: productID.toInt, postInfo: self.postInfo)
    //                                default:
    //                                    break
    //
    //                                }
    //                                break
    //                            default:
    //                                break
    //                            }
    //                        }
    //                    }
    //                }
    //            })
    //        }
    //    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var notifKey = ""
        let notificationInfo = arrNotiificationList[indexPath.row]
        let notfiContent = notificationInfo.valueForString(key: "content")
        let subjectName = notificationInfo.valueForString(key: "subject")
//        let senderName = subjectName.stringBefore("send")
      //  print("senderName:\(senderName)")
        
        userID = notificationInfo.valueForString(key: "sender")
        
        userID = notificationInfo.valueForString(key: "sender") as? String ?? ""
        if userID == ""{
            userID = notificationInfo.valueForString(key: "sender_id") as? String ?? ""
        }
        let nib = notificationInfo.valueForString(key: "nid")
        do {
            let dict = try convertToDictionary(from: notfiContent)
            var postinfo = [String:Any]()
            guard let userMsg = dict["type"] else { return }
            guard let subject = dict["subject"] else { return }
            postinfo = dict["postInfo"] as? [String:Any] ?? [:]
            if let post_types = postinfo.valueForString(key: "type") as? String{
                post_type = post_types
            }
            if let post_ids = postinfo.valueForString(key: "post_id") as? String{
                post_id = post_ids
            }
            postInfo = postinfo
            subjectCat = subject as! String
            notifKey = userMsg as! String
        } catch let error  {
            print("error trying to convert data to \(error)")
        }
        let notifReadStatus = notificationInfo.valueForString(key: "read_status")
        if notifReadStatus.toInt == 1{
            switch notifKey {
            case kNotTypeChatUser:
                if self.subjectCat == "Product viewed"{
                    appDelegate.moveOnProfileScreenNew(self.userID.description, self.userID.description, self)
                }else {
                    if let userChatDetailVC = CStoryboardChat.instantiateViewController(withIdentifier: "UserChatDetailViewController") as? UserChatDetailViewController {
                        userChatDetailVC.iObject =  self.postInfo
                       // userChatDetailVC.isFromNotification = true
                        
                        userChatDetailVC.notifcationStatus = true
                        userChatDetailVC.self.userID = userID.toInt
                        userChatDetailVC.isCreateNewChat = true
                        self.navigationController?.pushViewController(userChatDetailVC, animated: true)
                    }
                }
                break
            case kNotTypeGroupRemove:
                if let groupChatDetailVC = CStoryboardGroup.instantiateViewController(withIdentifier: "GroupsViewController") as? GroupsViewController {
                    self.navigationController?.pushViewController(groupChatDetailVC, animated: true)
                }
                break
            case kNotTypeGroup:
                let groupID = self.postInfo.valueForString(key: "group_id")
                self.getGroupInformationFromServer(groupID:groupID)
                break
            case kNotTypeGroupADD:
                //Group chat detail screen
                //                if let groupChatDetailVC = CStoryboardGroup.instantiateViewController(withIdentifier: "GroupChatDetailsViewController") as? GroupChatDetailsViewController {
                //                    groupChatDetailVC.iObject =  self.postInfo
                //                    groupChatDetailVC.groupNotfInfo =  self.postInfo
                //                    groupChatDetailVC.notificationGrp = true
                //                    groupChatDetailVC.isCreateNewChat = false
                //                    self.navigationController?.pushViewController(groupChatDetailVC, animated: true)
                //                }
                let groupID = self.postInfo.valueForString(key: "group_id")
                self.getGroupInformationFromServer(groupID:groupID)
                
                break
                
            case kNotTypeFriendReqAccept,
                 kNotTypeFriendReqSentNew:
                
                appDelegate.moveOnProfileScreenNew(notificationInfo.valueForString(key: "sender"),notificationInfo.valueForString(key: CUsermailID), self)
                //  appDelegate.moveOnProfileScreen(notificationInfo.valueForString(key: "sender"), self)
                break
            case kNotTypeFriendBlocked:
                
                self.presentAlertViewWithOneButton(alertTitle: CAlertblocked, alertMessage: CMessageNoLongerFriend, btnOneTitle: CBtnOk, btnOneTapped: nil)
                
                break
            case  kNotTypeEventType:
                
                let postID = self.postInfo.valueForString(key: "post_id")
                let userID =  self.postInfo.valueForString(key: "user_id")
                self.EventDetailsFromServer(eventID: postID.toInt ?? 0, postInfo: self.postInfo, userID: userID)
                break
                
            case kNotTypeCommnet,kNotTypeCommnet:
                let postID = self.postInfo.valueForString(key: "post_id")
                let userID =  self.postInfo.valueForString(key: "user_id")
                
                switch post_type {
                case "shout","post_shout":
                    self.ShoutDetailsFromServer(shoutID: postID.toInt ?? 0, postInfo: self.postInfo, userID: userID)
                case "article","post_article":
                    self.articleDetailsFromServer(articleID: postID.toInt ?? 0, postInfo: self.postInfo, userID: userID)
                case "gallery","post_gallery":
                    self.getGalleryDetailsFromServer(imgPostId: postID.toInt,postInfo:self.postInfo)
                    
                case "chirpy","post_chirpy":
                    self.chiripyDetailsFromServer(chiripyID: postID.toInt ?? 0, postInfo: self.postInfo, userID: userID)
                case "forum","post_forum":
                    self.forumsDetailsFromServer(forumsID: postID.toInt ?? 0, postInfo: self.postInfo, userID: userID)
                case "event","post_event":
                    self.EventDetailsFromServer(eventID: postID.toInt ?? 0, postInfo: self.postInfo, userID: userID)
                case "poll","post_poll":
                    self.getPollDetailsFromServer(pollID: postID.toInt, postInfo: self.postInfo, userID: userID.description)
                case "productDetails":
                    let productID = self.postInfo.valueForString(key: "product_id")
                    self.getProductDetail(productIds:productID)
//                    if let ProductDetailVC = CStoryboardProduct.instantiateViewController(withIdentifier: "ProductDetailVC") as? ProductDetailVC {
//                        ProductDetailVC.productIds = productID
//                        self.navigationController?.pushViewController(ProductDetailVC, animated: true)
//                    }
                default:
                    break
                }
                break
            default:
                break
            }
        }else {
            var para = [String:Any]()
            para["nid"] = nib
            para["status_id"] = "1"
            para["read_status"] = "1"
            APIRequest.shared().sendNotificationStautsUpdate(notifications: para, completion: { [weak self] (response, error) in
                guard let self = self else { return }
                self.apiTask?.cancel()
                if response != nil && error == nil {
                    if let responseData = response as? [String: Any] {
                        let response_Status = responseData["status"] as? Int
                        if response_Status == 0{
                            switch notifKey {
                            case kNotTypeChatUser:
                                if self.subjectCat == "Product viewed"{
                                    appDelegate.moveOnProfileScreenNew(self.userID.description, self.userID.description, self)
                                }else {
                                    if let userChatDetailVC = CStoryboardChat.instantiateViewController(withIdentifier: "UserChatDetailViewController") as? UserChatDetailViewController {
                                        userChatDetailVC.notifcationStatus = true
                                        userChatDetailVC.iObject =  self.postInfo
                                        userChatDetailVC.self.userID = self.userID.toInt
                                        userChatDetailVC.isCreateNewChat = true
                                        self.navigationController?.pushViewController(userChatDetailVC, animated: true)
                                    }
                                }
                                break
                            case kNotTypeGroupRemove:
                                if let groupChatDetailVC = CStoryboardGroup.instantiateViewController(withIdentifier: "GroupsViewController") as? GroupsViewController {
                                    self.navigationController?.pushViewController(groupChatDetailVC, animated: true)
                                }
                                break
                            case kNotTypeGroup:
                                
                                let groupID = self.postInfo.valueForString(key: "group_id")
                                
                                self.getGroupInformationFromServer(groupID:groupID)
                                
                                
                                
                                break
                            case kNotTypeGroupADD:
                                //Group chat detail screen
                                //                                if let groupChatDetailVC = CStoryboardGroup.instantiateViewController(withIdentifier: "GroupChatDetailsViewController") as? GroupChatDetailsViewController {
                                //                                    groupChatDetailVC.iObject =  self.postInfo
                                //                                    groupChatDetailVC.groupNotfInfo =  self.postInfo
                                //                                    groupChatDetailVC.isCreateNewChat = false
                                //                                    groupChatDetailVC.notificationGrp = true
                                //                                    self.navigationController?.pushViewController(groupChatDetailVC, animated: true)
                                //                                }
                                
                                let groupID = self.postInfo.valueForString(key: "group_id")
                                self.getGroupInformationFromServer(groupID:groupID)
                                break
                                
                                
                            case kNotTypeFriendReqAccept,kNotTypeFriendReqSentNew:
                                appDelegate.moveOnProfileScreenNew(notificationInfo.valueForString(key: "sender"),notificationInfo.valueForString(key: CUsermailID), self)
                                //                                appDelegate.moveOnProfileScreen(notificationInfo.valueForString(key: "sender"), self)
                                break
                            case kNotTypeFriendBlocked:
                                
                                self.presentAlertViewWithOneButton(alertTitle: CAlertblocked, alertMessage: CMessageNoLongerFriend, btnOneTitle: CBtnOk, btnOneTapped: nil)
                                
                                break
                            case  kNotTypeEventType:
                                let postID = self.postInfo.valueForString(key: "post_id")
                                let userID =  self.postInfo.valueForString(key: "user_id")
                                self.EventDetailsFromServer(eventID: postID.toInt ?? 0, postInfo: self.postInfo, userID: userID)
                                break
                                
                            case kNotTypeCommnet,kNotTypeCommnet:
                                
                                let postID = self.postInfo.valueForString(key: "post_id")
                                let userID =  self.postInfo.valueForString(key: "user_id")
                                
                                switch self.post_type {
                                case "shout","post_shout":
                                    self.ShoutDetailsFromServer(shoutID: postID.toInt ?? 0, postInfo: self.postInfo, userID: userID)
                                    
                                case "article","post_article":
                                    self.articleDetailsFromServer(articleID: postID.toInt ?? 0, postInfo: self.postInfo, userID: userID)
                                    
                                case "gallery","post_gallery":
                                    self.getGalleryDetailsFromServer(imgPostId: postID.toInt,postInfo:self.postInfo)
                                    
                                case "chirpy","post_chirpy":
                                    
                                    self.chiripyDetailsFromServer(chiripyID: postID.toInt ?? 0, postInfo: self.postInfo, userID: userID)
                                    
                                case "forum","post_forum":
                                    self.forumsDetailsFromServer(forumsID: postID.toInt ?? 0, postInfo: self.postInfo, userID: userID)
                                    
                                case "event","post_event":
                                    self.EventDetailsFromServer(eventID: postID.toInt ?? 0, postInfo: self.postInfo, userID: userID)
                                    
                                case "productDetails":
                                    
                                    let productID = self.postInfo.valueForString(key: "product_id")
                                    self.getProductDetail(productIds:productID)
                                    
                                case "poll","post_poll":
                                    self.getPollDetailsFromServer(pollID: postID.toInt, postInfo: self.postInfo, userID: userID)
                                default:
                                    break
                                    
                                }
                                break
                            default:
                                break
                            }
                        }
                    }
                }
            })
        }
    }
    
    
    
}

//MARK:- postDetails
extension NotificationViewController{
    
    //... Shout Detaisl View controller
    
    func ShoutDetailsFromServer(shoutID:Int?,postInfo:[String:Any],userID:String?) {
        if let shoutid = shoutID {
            APIRequest.shared().viewPostDetailLatest(postID: shoutid,userid: userID ?? "", apiKeyCall: "shouts"){ [weak self] (response, error) in
                guard let self = self else { return }
                if response != nil {
                    DispatchQueue.main.async {
                        if let postInfo = response!["data"] as? [[String:Any]]{
                            if let shoutsDetailsVC = CStoryboardHome.instantiateViewController(withIdentifier: "ShoutsDetailViewController") as? ShoutsDetailViewController{
                                shoutsDetailsVC.shoutInformations = postInfo.first ?? [:]
                                shoutsDetailsVC.likeFromNotify = true
                                print(self.postInfo.valueForString(key: "post_id"))
                                shoutsDetailsVC.shoutID = self.postInfo.valueForString(key: "post_id").toInt
                                self.navigationController?.pushViewController(shoutsDetailsVC, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
    
    //...post Article
    func articleDetailsFromServer(articleID:Int?,postInfo:[String:Any],userID:String?) {
        if let articleid = articleID {
            APIRequest.shared().viewPostDetailLatest(postID: articleid,userid: userID ?? "", apiKeyCall: "articles"){ [weak self] (response, error) in
                guard let self = self else { return }
                if response != nil {
                    //self.parentView.isHidden = false
                    DispatchQueue.main.async {
                        if let postInfo = response!["data"] as? [[String:Any]]{
                            
                            if let articleDetailVC = CStoryboardHome.instantiateViewController(withIdentifier: "ArticleDetailViewController") as? ArticleDetailViewController {
                                articleDetailVC.articleInformation = postInfo.first ?? [:]
                                articleDetailVC.likeFromNotify  = true
                                articleDetailVC.articleID = self.postInfo.valueForString(key: "post_id").toInt
                                self.navigationController?.pushViewController(articleDetailVC, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
    //...Chiripy Detailsview Controller
    
    func chiripyDetailsFromServer(chiripyID:Int?,postInfo:[String:Any],userID:String?) {
        if let articleid = chiripyID {
            APIRequest.shared().viewPostDetailLatest(postID: articleid,userid: userID ?? "", apiKeyCall: "chirpies"){ [weak self] (response, error) in
                guard let self = self else { return }
                if response != nil {
                    //self.parentView.isHidden = false
                    DispatchQueue.main.async {
                        if let postInfo = response!["data"] as? [[String:Any]]{
                            if let chirpyDetailVC = CStoryboardHome.instantiateViewController(withIdentifier: "ChirpyImageDetailsViewController") as? ChirpyImageDetailsViewController {
                                chirpyDetailVC.likeFromNotify = true
                                chirpyDetailVC.chirpyInformation = postInfo.first ?? [:]
                                chirpyDetailVC.chirpyID = self.postInfo.valueForString(key: "post_id").toInt
                                self.navigationController?.pushViewController(chirpyDetailVC, animated: true)
                            }
                            
                        }
                    }
                }
            }
        }
    }
    
    //..Forums DetailsViewController
    
    func forumsDetailsFromServer(forumsID:Int?,postInfo:[String:Any],userID:String?) {
        if let forumsid = forumsID {
            APIRequest.shared().viewPostDetailLatest(postID: forumsid,userid: userID ?? "", apiKeyCall: "forums"){ [weak self] (response, error) in
                guard let self = self else { return }
                if response != nil {
                    //self.parentView.isHidden = false
                    DispatchQueue.main.async {
                        if let postInfo = response!["data"] as? [[String:Any]]{
                            if let forumDetailVC = CStoryboardHome.instantiateViewController(withIdentifier: "ForumDetailViewController") as? ForumDetailViewController {
                                forumDetailVC.forumID = self.postInfo.valueForString(key: "post_id").toInt
                                forumDetailVC.likeFromNotify = true
                                forumDetailVC.forumInformation = postInfo.first ?? [:]
                                self.navigationController?.pushViewController(forumDetailVC, animated: true)
                            }
                            
                        }
                    }
                }
            }
        }
    }
    //...Get Gellery Details From Server
    func getGalleryDetailsFromServer(imgPostId:Int?,postInfo:[String:Any]) {
        var imagesUpload = ""
        guard let userID = appDelegate.loginUser?.user_id else {return}
        if let imgID = imgPostId {
            APIRequest.shared().viewPostDetailLatest(postID: imgID,userid: userID.description, apiKeyCall: CAPITagsgalleryDetials){ [weak self] (response, error) in
                guard let self = self else { return }
                
                if response != nil {
                    if let Info = response!["data"] as? [[String:Any]]{
                        for galleryInfo in Info {
                            imagesUpload = galleryInfo["image"] as? String ?? ""
                        }
                        if let imageDetailVC = CStoryboardImage.instantiateViewController(withIdentifier: "ImageDetailViewController") as? ImageDetailViewController {
//                            self.postInfo["image"] = Info.first?["image"] as? String
                            self.postInfo["image"] = imagesUpload
                            imageDetailVC.galleryInfo = self.postInfo
                            imageDetailVC.likeFromNotify  = true
                            imageDetailVC.imgPostId = postInfo.valueForString(key: "post_id").toInt
                            self.navigationController?.pushViewController(imageDetailVC, animated: true)
                        }
                    }
                }
            }
        }
    }
    
    //...Get Poll Details From Server
    func getPollDetailsFromServer(pollID:Int?,postInfo:[String:Any],userID:String?) {
        var options = ""
        if let artID = pollID {
            APIRequest.shared().viewPostDetailLatest(postID: artID,userid: userID ?? "", apiKeyCall: "polls"){ [weak self] (response, error) in
                guard let self = self else { return }
                if response != nil {
                    DispatchQueue.main.async {
                        if let Info = response!["data"] as? [[String:Any]]{
                            for articleInfo in Info {
                                options = articleInfo["options"] as? String ?? ""
                            }
                            if let pollDetailVC = CStoryboardPoll.instantiateViewController(withIdentifier: "PollDetailsViewController") as? PollDetailsViewController {
                                self.postInfo["options"] = options
                                self.postInfo["likes"] = Info.first?["likes"] as? String
                                self.postInfo["comments"] = Info.first?["comments"] as? String
                                self.postInfo["is_liked"] = Info.first?["is_liked"] as? String
                                pollDetailVC.likeFromNotify  = true
                                pollDetailVC.pollInformation = self.postInfo
                                pollDetailVC.posted_ID = postInfo.valueForString(key: "post_id")
                                self.navigationController?.pushViewController(pollDetailVC, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func EventDetailsFromServer(eventID:Int?,postInfo:[String:Any],userID:String?) {
        var options = ""
        if let artID = eventID {
            APIRequest.shared().viewPostDetailLatest(postID: artID,userid: userID ?? "", apiKeyCall: "events"){ [weak self] (response, error) in
                guard let self = self else { return }
                if response != nil {
                    //self.parentView.isHidden = false
                    DispatchQueue.main.async {
                        if let postInfo = response!["data"] as? [[String:Any]]{
                            if let eventDetailVC = CStoryboardEvent.instantiateViewController(withIdentifier: "EventDetailImageViewController") as? EventDetailImageViewController {
                                eventDetailVC.postID = self.postInfo.valueForString(key: "post_id").toInt
                                eventDetailVC.eventInfo = postInfo.first ?? [:]
                                eventDetailVC.likeFromNotify = true
                                self.navigationController?.pushViewController(eventDetailVC, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
    
    //...GroupDeatils.....
    func getGroupInformationFromServer(groupID:String) {
        APIRequest.shared().groupDetail(group_id:groupID ,shouldShowLoader:false) { (response, error) in
            if response != nil && error == nil{
                DispatchQueue.main.async {
                    if let groupInfo = response?[CJsonData] as? [[String : Any]] {
                        if groupInfo.isEmpty{
                            print("is empty")
                            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageGroupDeleted, btnOneTitle: CBtnOk, btnOneTapped: nil)
                        }else {
                            self.iObject = groupInfo
                            if let groupChatDetailVC = CStoryboardGroup.instantiateViewController(withIdentifier: "GroupChatDetailsViewController") as? GroupChatDetailsViewController {
//                                groupChatDetailVC.iObject =  groupInfo.first ?? [:]
//                                groupChatDetailVC.groupNotfInfo = groupInfo.first ?? [:]
//                                groupChatDetailVC.isCreateNewChat = false
//                                groupChatDetailVC.notificationGrp = true
                                
                                
                                groupChatDetailVC.iObject =  groupInfo.first ?? [:]
                                groupChatDetailVC.groupNotfInfo = groupInfo.first ?? [:]
                                groupChatDetailVC.isCreateNewChat = false
                                groupChatDetailVC.topcName = groupID
                                groupChatDetailVC.group_id = groupID
                                groupChatDetailVC.groupInfo = groupInfo.first ?? [:]
                                groupChatDetailVC.notificationGrp = true
                                
                                
                                self.navigationController?.pushViewController(groupChatDetailVC, animated: true)
                            }
                            
                        }
                        
                    }
                }
            }
        }
    }
    
    //...productDetails
    func getProductDetail(productIds:String) {
        
        if apiTask?.state == URLSessionTask.State.running {return}
        guard let userId = appDelegate.loginUser?.user_id else {return}
        let userID = String(userId)
        var para = [String:Any]()
        para["user_id"] = userID
        para["product_id"] = productIds
        
        let _ = APIRequest.shared().getProductDetail(para:para,productID: productIds.toInt ?? 0,userID:userID, showLoader: true, completion:{ [weak self](response, error) in
            guard let self = self else { return }
            if response != nil {
                GCDMainThread.async {
                    if let data = response?[CData] as? [[String:Any]] {
                        if data.isEmpty {
                            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageGroupDeleted, btnOneTitle: CBtnOk, btnOneTapped: nil)
                        }else {
                            if let ProductDetailVC = CStoryboardProduct.instantiateViewController(withIdentifier: "ProductDetailVC") as? ProductDetailVC {
                                ProductDetailVC.productIds = productIds
                                
                                self.navigationController?.pushViewController(ProductDetailVC, animated: true)
                            }
                        }
                    }
                }
            }else{
                MILoader.shared.hideLoader()
            }
        })
    }
    
}

extension NotificationViewController{
    
    func convertToDictionary(from text: String) -> [String: Any] {
        //  print("text from the valies\(text)")
        guard let data = text.data(using: .utf8) else { return [:] }
        let anyResult: Any? = try? JSONSerialization.jsonObject(with: data, options:[])
        return anyResult as? [String: Any] ?? [:]
    }
    
}


