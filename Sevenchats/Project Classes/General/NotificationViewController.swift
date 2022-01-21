//
//  NotificationViewController.swift
//  Sevenchats
//
//  Created by Mac-0006 on 23/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Initialization()
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
        
        if apiTask?.state == URLSessionTask.State.running {
            apiTask?.cancel()
        }
        if isLoader{
            MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: "\(CMessagePleaseWait)...")
        }
        // Add load more indicator here...
//        self.tblVNotification.tableFooterView = self.pageNumber > 2 ? self.loadMoreIndicator(ColorAppTheme) : nil
        guard let user_ID = appDelegate.loginUser?.user_id else { return}
        
        apiTask = APIRequest.shared().getNotificationList(receiver: user_ID.description, completion: { [weak self] (response, error) in
            guard let self = self else { return }
            MILoader.shared.hideLoader()
            self.refreshControl.endRefreshing()
            self.apiTask?.cancel()
            self.tblVNotification.tableFooterView = nil
            
            if response != nil && error == nil {
                if let responseData = response![CJsonData] as? [[String : Any]] {
                    //...Remove all data
                    if self.apiTimeStamp < 1 {
                        self.arrNotiificationList.removeAll()
                        MIGeneralsAPI.shared().readNotification("-1")
                    }
                    //...Add Data here...
                    if (responseData.count > 0) {
                        self.arrNotiificationList = self.arrNotiificationList + responseData
                        self.tblVNotification.reloadData()
                        
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
            /*UIView.performWithoutAnimation {
             if (self.tblVNotification.indexPathsForVisibleRows?.contains(indexpath!))!{
             self.tblVNotification.reloadRows(at: [indexpath!], with: .none)
             }
             }*/
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
        
        /************************OLD CODE *******************************/
       /* let notificationInfo = arrNotiificationList[indexPath.row]
        let notificationText = notificationInfo.valueForString(key: "message")
        
        switch notificationInfo.valueForInt(key: "notification_type") {
            
        case kNotTypeEventInvitation: //...Event Invitation Notification
            if let cell = tblVNotification.dequeueReusableCell(withIdentifier: "NotificationInvitationTblCell") as? NotificationInvitationTblCell {
                cell.ConfigureNotificationInvitationTblCell(notificationInfo)
                cell.lblNotificationInvitation.font = CFontPoppins(size: 14, type: .light).setUpAppropriateFont()
                cell.lblNotificationInvitation.attributedText = self.htmlToAttributedString(notificationText, cell.lblNotificationInvitation.font)
                weak var weakCell = cell
                cell.btnInterest.touchUpInside { [weak self] (sender) in
                    guard let _ = self else { return }
                    weakCell?.btnMayBe.isSelected = false
                    weakCell?.btnNotInterested.isSelected = false
                    weakCell?.btnInterest.isSelected = true
                    self?.btnInterestedNotInterestedMayBeCLK(CTypeInterested, indexPath)
                }
                cell.btnNotInterested.touchUpInside { [weak self] (sender) in
                    guard let _ = self else { return }
                    weakCell?.btnMayBe.isSelected = false
                    weakCell?.btnNotInterested.isSelected = true
                    weakCell?.btnInterest.isSelected = false
                    self?.btnInterestedNotInterestedMayBeCLK(CTypeNotInterested, indexPath)
                }
                cell.btnMayBe.touchUpInside { [weak self] (sender) in
                    guard let _ = self else { return }
                    weakCell?.btnMayBe.isSelected = true
                    weakCell?.btnNotInterested.isSelected = false
                    weakCell?.btnInterest.isSelected = false
                    self?.btnInterestedNotInterestedMayBeCLK(CTypeMayBeInterested, indexPath)
                }
                
                // Load more data....
                if (indexPath == tblVNotification.lastIndexPath()) && apiTask?.state != URLSessionTask.State.running {
                    self.getNotificationListFromServer()
                }
                return cell
            }
            
        case kNotTypeFriendReqSent: //...Friend Request Notification
            if let cell = tblVNotification.dequeueReusableCell(withIdentifier: "NotificationRequestTblCell") as? NotificationRequestTblCell {
                cell.lblDate.text = "\(DateFormatter.dateStringFrom(timestamp: notificationInfo.valueForDouble(key: "created_at")!/1000, withFormate: "dd MMM yyyy"))"
                cell.imgUser.loadImageFromUrl(notificationInfo.valueForString(key: CImage), true)
                cell.lblNotificationdetails.font = CFontPoppins(size: 14, type: .light).setUpAppropriateFont()
                cell.lblNotificationdetails.attributedText = self.htmlToAttributedString(notificationText, cell.lblNotificationdetails.font)
                cell.btnAccept.touchUpInside { [weak self] (sender) in
                    guard let _ = self else { return }
                    self?.friendStatusApi(notificationInfo.valueForInt(key: CUserId), 2, indexPath: indexPath)
                }
                
                cell.btnCancel.touchUpInside { [weak self] (sender) in
                    guard let _ = self else { return }
                    self?.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: CMessageCancelRequest, btnOneTitle: CBtnYes, btnOneTapped: { [weak self] (alert) in
                        self?.friendStatusApi(notificationInfo.valueForInt(key: CUserId), 3, indexPath: indexPath)
                    }, btnTwoTitle: CBtnNo, btnTwoTapped: nil)
                }
                
                // Load more data....
                if (indexPath == tblVNotification.lastIndexPath()) && apiTask?.state != URLSessionTask.State.running {
                    self.getNotificationListFromServer()
                }
                return cell
            }
            
        default: //...Other Notification
            if let cell = tblVNotification.dequeueReusableCell(withIdentifier: "NotificationGeneralTblCell") as? NotificationGeneralTblCell {
                
                if (notificationInfo.valueForInt(key: "notification_type") == kNotTypeADAccountAccept ||
                    notificationInfo.valueForInt(key: "notification_type") == kNotTypeADAccountReject ||
                    notificationInfo.valueForInt(key: "notification_type") == kNotTypeADPostAccept ||
                    notificationInfo.valueForInt(key: "notification_type") == kNotTypeADPostReject) {
                    // ADS Related Notification
                    cell.imgUser.image = UIImage(named: "ic_notification_logo")
                } else {
                    cell.imgUser.loadImageFromUrl(notificationInfo.valueForString(key: CImage), true)
                }
                
                cell.lblNotificationDetails.font = CFontPoppins(size: 14, type: .light).setUpAppropriateFont()
                cell.lblNotificationDetails.attributedText = self.htmlToAttributedString(notificationText, cell.lblNotificationDetails.font)
                cell.lblDate.text = "\(DateFormatter.dateStringFrom(timestamp: notificationInfo.valueForDouble(key: "created_at")!/1000 , withFormate: "dd MMM yyyy"))"
                
                // Load more data....
                if (indexPath == tblVNotification.lastIndexPath()) && apiTask?.state != URLSessionTask.State.running {
                    self.getNotificationListFromServer()
                }
                return cell
            }
        }
        
        return UITableViewCell()*/
        
        let notificationInfo = arrNotiificationList[indexPath.row]
//        let notificatoinIsread = notificationInfo.valueForInt(key: "is_read")
        let dict = notificationInfo.valueForString(key: "content")
        let notificationDict = convertToDictionary(from: dict)
        let notifcationContent = notificationDict.valueForString(key:"content")
//        let notifcationsender = notificationInfo.valueForString(key:"sender")
//        let notifcationNid = notificationInfo.valueForString(key:"nid")
        let created_At = notificationInfo.valueForString(key: "timestamp")
        let cnvStr = created_At.stringBefore("G")
        let startCreated = DateFormatter.shared().convertDatereversLatest(strDate: cnvStr)
        if let cell = tblVNotification.dequeueReusableCell(withIdentifier: "NotificationGeneralTblCell") as? NotificationGeneralTblCell{
            cell.lblDate.text = startCreated
//            cell.imgUser.loadImageFromUrl(notificationInfo.valueForString(key: CImage), true)
            cell.imgUser.loadImageFromUrl(notificationInfo.valueForString(key: "icon"), true)
            cell.lblNotificationDetails.font = CFontPoppins(size: 14, type: .light).setUpAppropriateFont()
            cell.lblNotificationDetails.attributedText = self.htmlToAttributedString(notifcationContent, cell.lblNotificationDetails.font)
            return cell
        }

        
//        switch notificationDict.valueForString(key: "type") {
//        case kNotTypeEventInvitationNew: //...Event Invitation Notification
//            if let cell = tblVNotification.dequeueReusableCell(withIdentifier: "NotificationInvitationTblCell") as? NotificationInvitationTblCell {
//
//                if notificatoinIsread == 1{
//                    cell.contentView.backgroundColor = .white
////                    cell.lblNotificationInvitation.backgroundColor = .gray
//                } else {
//
//                    cell.contentView.backgroundColor = .lightGray
//                }
//                cell.ConfigureNotificationInvitationTblCell(notificationInfo)
//                cell.lblNotificationInvitation.font = CFontPoppins(size: 14, type: .light).setUpAppropriateFont()
//                cell.lblNotificationInvitation.attributedText = self.htmlToAttributedString(notificationText, cell.lblNotificationInvitation.font)
//                weak var weakCell = cell
//                cell.btnInterest.touchUpInside { [weak self] (sender) in
//                    guard let _ = self else { return }
//                    weakCell?.btnMayBe.isSelected = false
//                    weakCell?.btnNotInterested.isSelected = false
//                    weakCell?.btnInterest.isSelected = true
//                    self?.btnInterestedNotInterestedMayBeCLK(CTypeInterested, indexPath)
//                }
//                cell.btnNotInterested.touchUpInside { [weak self] (sender) in
//                    guard let _ = self else { return }
//                    weakCell?.btnMayBe.isSelected = false
//                    weakCell?.btnNotInterested.isSelected = true
//                    weakCell?.btnInterest.isSelected = false
//                    self?.btnInterestedNotInterestedMayBeCLK(CTypeNotInterested, indexPath)
//                }
//                cell.btnMayBe.touchUpInside { [weak self] (sender) in
//                    guard let _ = self else { return }
//                    weakCell?.btnMayBe.isSelected = true
//                    weakCell?.btnNotInterested.isSelected = false
//                    weakCell?.btnInterest.isSelected = false
//                    self?.btnInterestedNotInterestedMayBeCLK(CTypeMayBeInterested, indexPath)
//                }
//
//                // Load more data....
//                if (indexPath == tblVNotification.lastIndexPath()) && apiTask?.state != URLSessionTask.State.running {
//                    self.getNotificationListFromServer()
//                }
//                return cell
//            }
//
//        case kNotTypeFriendReqSentNew: //...Friend Request Notification
//            if let cell = tblVNotification.dequeueReusableCell(withIdentifier: "NotificationRequestTblCell") as? NotificationRequestTblCell {
//
////                cell.lblDate.text = "\(DateFormatter.dateStringFrom(timestamp: notificationInfo.valueForString(key: "timestamp")))"
//
//                let created_At = notificationInfo.valueForString(key: "timestamp")
//                let cnvStr = created_At.stringBefore("G")
//                let startCreated = DateFormatter.shared().convertDatereversLatest(strDate: cnvStr)
//                cell.lblDate.text = startCreated
//
//                cell.imgUser.loadImageFromUrl(notificationInfo.valueForString(key: CImage), true)
//                cell.lblNotificationdetails.font = CFontPoppins(size: 14, type: .light).setUpAppropriateFont()
//                cell.lblNotificationdetails.attributedText = self.htmlToAttributedString(notifcationContent, cell.lblNotificationdetails.font)
//
//                if notificatoinIsread == 1{
//                    cell.contentView.backgroundColor = .white
//                } else {
//
//                    //cell.contentView.backgroundColor = .lightGray
//                    cell.contentView.backgroundColor = CRGB(r: 228, g: 230, b: 235)
//                }
//
//                cell.btnAccept.touchUpInside { [weak self] (sender) in
//                    guard let _ = self else { return }
//                    self?.friendStatusApi(notifcationsender, 5, indexPath: indexPath)
//                    MIGeneralsAPI.shared().readNotification(notifcationNid)
//                }
//
//                cell.btnCancel.touchUpInside { [weak self] (sender) in
//                    guard let _ = self else { return }
//                    self?.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: CMessageCancelRequest, btnOneTitle: CBtnYes, btnOneTapped: { [weak self] (alert) in
//                        self?.friendStatusApi(notifcationsender, 3, indexPath: indexPath)
//                    }, btnTwoTitle: CBtnNo, btnTwoTapped: nil)
//                }
//
//                // Load more data....
//                if (indexPath == tblVNotification.lastIndexPath()) && apiTask?.state != URLSessionTask.State.running {
////                    self.getNotificationListFromServer()
//                }
//                return cell
//            }
//
//
//        default: //...Other Notification
//            if let cell = tblVNotification.dequeueReusableCell(withIdentifier: "NotificationGeneralTblCell") as? NotificationGeneralTblCell {
//
//                if (notificationInfo.valueForInt(key: "notification_type") == kNotTypeADAccountAccept ||
//                    notificationInfo.valueForInt(key: "notification_type") == kNotTypeADAccountReject ||
//                    notificationInfo.valueForInt(key: "notification_type") == kNotTypeADPostAccept ||
//                    notificationInfo.valueForInt(key: "notification_type") == kNotTypeADPostReject) {
//                    // ADS Related Notification
//                    cell.imgUser.image = UIImage(named: "ic_notification_logo")
//                } else {
//                    cell.imgUser.loadImageFromUrl(notificationInfo.valueForString(key: CImage), true)
//                }
//
//                if notificatoinIsread == 1{
//                    cell.contentView.backgroundColor = .white
//                } else {
//
//                    cell.contentView.backgroundColor = .lightGray
//                }
//
//                cell.lblNotificationDetails.font = CFontPoppins(size: 14, type: .light).setUpAppropriateFont()
//                cell.lblNotificationDetails.attributedText = self.htmlToAttributedString(notificationText, cell.lblNotificationDetails.font)
////                cell.lblDate.text = "\(DateFormatter.dateStringFrom(timestamp: notificationInfo.valueForDouble(key: "created_at")!/1000 , withFormate: "dd MMM yyyy"))"
//
//                // Load more data....
//                if (indexPath == tblVNotification.lastIndexPath()) && apiTask?.state != URLSessionTask.State.running {
//                    self.getNotificationListFromServer()
//                }
//                return cell
//            }
//        }
        
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var notifKey = ""
        
        let notificationInfo = arrNotiificationList[indexPath.row]
        
//        switch notificationInfo.valueForInt(key: "notification_type") {
//
//
//        case kNotTypeFriendReqSent,
//             kNotTypeRejectFriendReq,
//             kNotTypeAcceptFriendReq:
//            appDelegate.moveOnProfileScreen(notificationInfo.valueForString(key: CUserId), self)
//
//        case kNotTypeAddedToGroup:
//            //Group chat detail screen
//            if let groupChatDetailVC = CStoryboardGroup.instantiateViewController(withIdentifier: "GroupChatDetailsViewController") as? GroupChatDetailsViewController {
//                groupChatDetailVC.iObject = notificationInfo
//                groupChatDetailVC.isCreateNewChat = false
//                self.navigationController?.pushViewController(groupChatDetailVC, animated: true)
//            }
//            break
//
//        case kNotTypeJoinGroup:
//            //Group Member Request Screen
//            if let groupInfoVC = CStoryboardGroup.instantiateViewController(withIdentifier: "GroupMemberRequestViewController") as? GroupMemberRequestViewController {
//                groupInfoVC.iObject = notificationInfo
//                self.navigationController?.pushViewController(groupInfoVC, animated: true)
//            }
//            break
//
//        case kNotTypeGroupJoinAccept:
//            //Group Chat Detail screen
//            if let groupChatDetailVC = CStoryboardGroup.instantiateViewController(withIdentifier: "GroupChatDetailsViewController") as? GroupChatDetailsViewController {
//                groupChatDetailVC.iObject = notificationInfo
//                groupChatDetailVC.isCreateNewChat = false
//                self.navigationController?.pushViewController(groupChatDetailVC, animated: true)
//            }
//            break
//
//        case kNotTypeChatUser:
//            //Group Chat Detail screen
//            if let groupChatDetailVC = CStoryboardGroup.instantiateViewController(withIdentifier: "GroupChatDetailsViewController") as? GroupChatDetailsViewController {
//                groupChatDetailVC.iObject = notificationInfo
//                groupChatDetailVC.isCreateNewChat = false
//                self.navigationController?.pushViewController(groupChatDetailVC, animated: true)
//            }
//            break
//
//
//        //Post detail screen
//        case kNotTypeLikePost,
//             kNotTypePostComment,
//             kNotTypeMentionUser,
//             kNotTypeEventInvitation,
//             kNotTypeEditEvent:
//
//            let postID = notificationInfo.valueForInt(key: CPostId)
//            switch notificationInfo.valueForInt(key: CPostType) {
//            case CStaticArticleId:
//                if let articleDetailVC = CStoryboardHome.instantiateViewController(withIdentifier: "ArticleDetailViewController") as? ArticleDetailViewController {
//                    articleDetailVC.articleID = postID
//                    self.navigationController?.pushViewController(articleDetailVC, animated: true)
//                }
//            case CStaticGalleryId:
//                if let imageDetailVC = CStoryboardImage.instantiateViewController(withIdentifier: "ImageDetailViewController") as? ImageDetailViewController {
//                    imageDetailVC.imgPostId = postID
//                    self.navigationController?.pushViewController(imageDetailVC, animated: true)
//                }
//
//            case CStaticChirpyId:
//                if let chirpyDetailVC = CStoryboardHome.instantiateViewController(withIdentifier: "ChirpyDetailsViewController") as? ChirpyDetailsViewController {
//                    chirpyDetailVC.chirpyID = postID
//                    self.navigationController?.pushViewController(chirpyDetailVC, animated: true)
//                }
//            case CStaticShoutId:
//                if let shoutDetailVC = CStoryboardHome.instantiateViewController(withIdentifier: "ShoutsDetailViewController") as? ShoutsDetailViewController {
//                    shoutDetailVC.shoutID = postID
//                    self.navigationController?.pushViewController(shoutDetailVC, animated: true)
//                }
//            case CStaticForumId:
//                if let forumDetailVC = CStoryboardHome.instantiateViewController(withIdentifier: "ForumDetailViewController") as? ForumDetailViewController {
//                    forumDetailVC.forumID = postID
//                    self.navigationController?.pushViewController(forumDetailVC, animated: true)
//                }
//            case CStaticEventId:
//                if let eventDetailVC = CStoryboardEvent.instantiateViewController(withIdentifier: "EventDetailViewController") as? EventDetailViewController {
//                    eventDetailVC.postID = postID
//                    self.navigationController?.pushViewController(eventDetailVC, animated: true)
//                }
//            default:
//                break
//            }
//
//        // ADS Related Notification
//        case kNotTypeADAccountAccept,
//             kNotTypeADAccountReject,
//             kNotTypeADPostAccept,
//             kNotTypeADPostReject:
//            self.openInSafari(strUrl:  notificationInfo.valueForString(key: "url"))
//            break
//
//        case kNotTypeEventStatus :
//            if let eventInviteesVC = CStoryboardEvent.instantiateViewController(withIdentifier: "EventInviteesViewController") as? EventInviteesViewController{
//                let postID = notificationInfo.valueForInt(key: CPostId)
//                eventInviteesVC.eventId = postID
//                self.navigationController?.pushViewController(eventInviteesVC, animated: true)
//            }
//            break
//        case kNotTypeSharedFolder :
//            if let fileVC = CStoryboardFile.instantiateViewController(withIdentifier: "FileSharingViewController") as? FileSharingViewController{
//
//                CATransaction.begin()
//                CATransaction.setCompletionBlock {
//                    fileVC.changedController(index: 1)
//                }
//                self.navigationController?.pushViewController(fileVC, animated: true)
//                CATransaction.commit()
//            }
//            break
//
//        default:
//            break
//        }
        
        let notfiContent = notificationInfo.valueForString(key: "content")
        userID = notificationInfo.valueForString(key: "sender")
        
    do {
        let dict = try convertToDictionary(from: notfiContent ?? "")
        guard let userMsg = dict["type"] else { return }
        guard let subject = dict["subject"] else { return }
        subjectCat = subject
        
        notifKey = userMsg
//        DispatchQueue.main.async {
//            self.redirectToVerificationScreen(signUpResponse: response,message: userMsg)
//        }
    } catch let error  {
        print("error trying to convert data to \(error)")
    }
        
        switch notifKey {
        case kNotTypeChatUser:
            if subjectCat == "Product viewed"{
                appDelegate.moveOnProfileScreenNew(userID.description, userID.description, self)
            }else {
                if let groupChatDetailVC = CStoryboardChat.instantiateViewController(withIdentifier: "ChatListViewController") as? ChatListViewController {
                    self.navigationController?.pushViewController(groupChatDetailVC, animated: true)
                }
            }
            break
        case kNotTypeGroup,kNotTypeGroupADD,kNotTypeGroupRemove:
            if let groupChatDetailVC = CStoryboardGroup.instantiateViewController(withIdentifier: "GroupsViewController") as? GroupsViewController {
                self.navigationController?.pushViewController(groupChatDetailVC, animated: true)
            }
            break
        case kNotTypeFriendReqAccept,kNotTypeFriendBlocked,kNotTypeFriendReqSentNew:
            if let MyFriendsVC = CStoryboardProfile.instantiateViewController(withIdentifier: "MyFriendsViewController") as? MyFriendsViewController {
                self.navigationController?.pushViewController(MyFriendsVC, animated: true)
            }
        case kNotTypeCommnet:
            if let HomeVC = CStoryboardHome.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController {
                self.navigationController?.pushViewController(HomeVC, animated: true)
            }
            break
        case kNotTypeCommnet:
            if let HomeVC = CStoryboardHome.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController {
                self.navigationController?.pushViewController(HomeVC, animated: true)
            }
            break
            

            default:
                break
            }
            
    }
}

extension NotificationViewController{

    func convertToDictionary(from text: String) -> [String: String] {
        guard let data = text.data(using: .utf8) else { return [:] }
        let anyResult: Any? = try? JSONSerialization.jsonObject(with: data, options: [])
        return anyResult as? [String: String] ?? [:]
    }
}

