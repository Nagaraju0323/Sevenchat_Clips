//
//  NotificationViewController.swift
//  Sevenchats
//
//  Created by Mac-0006 on 23/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//


/*********************************************************
 * Author  : Chandrika.R                                 *
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
        
        apiTask = APIRequest.shared().getNotificationList(receiver: user_ID.description,pageNumber: pageNumber.description, completion: { [weak self] (response, error) in
            guard let self = self else { return }
            MILoader.shared.hideLoader()
            self.refreshControl.endRefreshing()
            self.apiTask?.cancel()
            self.tblVNotification.tableFooterView = nil
            
            if response != nil && error == nil {
                if let responseData = response![CJsonData] as? [[String : Any]] {
                    //...Remove all data
                    if self.apiTimeStamp < 1 || self.pageNumber == 1 {
                        self.arrNotiificationList.removeAll()
                        MIGeneralsAPI.shared().readNotification("-1")
                    }
                    self.isLoadMoreCompleted = responseData.isEmpty
                    
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
        
        let notificationInfo = arrNotiificationList[indexPath.row]
        let dict = notificationInfo.valueForString(key: "content")
        let notificationDict = convertToDictionary(from: dict)
        let notifcationContent = notificationDict.valueForString(key:"content")
        let created_At = notificationInfo.valueForString(key: "timestamp")
        let cnvStr = created_At.stringBefore("G")
        let startCreated = DateFormatter.shared().convertDatereversLatest(strDate: cnvStr)
        if let cell = tblVNotification.dequeueReusableCell(withIdentifier: "NotificationGeneralTblCell") as? NotificationGeneralTblCell{
            cell.lblDate.text = startCreated
            cell.imgUser.loadImageFromUrl(notificationInfo.valueForString(key: "icon"), true)
            cell.lblNotificationDetails.font = CFontPoppins(size: 14, type: .light).setUpAppropriateFont()
            cell.lblNotificationDetails.attributedText = self.htmlToAttributedString(notifcationContent, cell.lblNotificationDetails.font)
            if indexPath == tblVNotification.lastIndexPath() && !self.isLoadMoreCompleted{
                self.getNotificationListFromServer(isLoader: true)
            }
            
            return cell
        }
        
       
        
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var notifKey = ""
        
        let notificationInfo = arrNotiificationList[indexPath.row]
        let notfiContent = notificationInfo.valueForString(key: "content")
        userID = notificationInfo.valueForString(key: "sender")
        
        do {
            let dict = try convertToDictionary(from: notfiContent ?? "")
            guard let userMsg = dict["type"] else { return }
            guard let subject = dict["subject"] else { return }
            subjectCat = subject
            notifKey = userMsg
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
        case kNotTypeCommnet ,kNotTypeEventType:
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

