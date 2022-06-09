//
//  FirebasePushNotification.swift
//  Sevenchats
//
//  Created by mac-0005 on 04/02/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Nagaraju K and Chandrika R                                 *
 * Model   : RestrictedFilesVC                           *
 * Description : Show the Local notifcation              *
 *                                                       *
 ********************************************************/

import Foundation
import UIKit
import Firebase
import UserNotifications

let CNotificationType = "notification_type"
let CNotificationData = "gcm.notification.data"
let kScreenMovingTime = 0.5

let kNotTypeGroupMessage = 1
let kNotTypeOTOMessage = 2
let kNotTypeAddedToGroup = 3
let kNotTypeDeleteGroup = 4
let kNotTypeFriendReqSent = 5
let kNotTypeAcceptFriendReq = 6
let kNotTypeRejectFriendReq = 7
let kNotTypeEventInvitation = 8
let kNotTypeEditEvent = 9
let kNotTypeDeleteEvent = 10
let kNotTypeLikePost = 11
let kNotTypeMentionUser = 12
let kNotTypePostComment = 13
let kNotTypeJoinGroup = 14
let kNotTypeGroupJoinAccept = 15
let kNotTypeADAccountAccept = 16
let kNotTypeADAccountReject = 18
let kNotTypeADPostAccept = 19
let kNotTypeADPostReject = 20
let kNotTypeEventStatus = 21
let kNotTypeSharedFolder = 26
let kNotTypeAdminCreditReward = 23
let kNotTypeAdminDebitReward = 24

let kNotTypeChatUser = "CHAT_MESSAGE"
let kNotTypeGroup = "GROUP_MESSAGE"
let kNotTypeFriendReqAccept = "FRIEND_ACCEPT"
let kNotTypeFriendBlocked = "FRIEND_BLOCKED"
let kNotTypeFriendReqSentNew = "FRIEND_REQUEST"
let kNotTypeEventInvitationNew = "Event"
let kNotTypeCommnet = "COMMENT"
let kNotTypeGroupADD = "GROUP_ADD"
let kNotTypeGroupRemove = "GROUP_REMOVE"
let kNotTypeEventType = "EVENT_CHOICE"




class FirebasePushNotification: NSObject {
    
    // MARK:-
    // MARK:- Singletone class setup..
    
    private override init() {
        super.init()
    }
    
    private static var firebasePushNotification: FirebasePushNotification = {
        let firebasePushNotification = FirebasePushNotification()
        return firebasePushNotification
    }()
    
    static func shared() ->FirebasePushNotification {
        return firebasePushNotification
    }
}

// MARK:- Firebase Setup
// MARK:-
extension FirebasePushNotification : UNUserNotificationCenterDelegate {
    
    func getNotificationSettings() {
        print("isRegisteredForRemoteNotifications : \(UIApplication.shared.isRegisteredForRemoteNotifications)")
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                UNUserNotificationCenter.current().delegate = self
                guard settings.authorizationStatus == .authorized else { return }
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                    //FirebaseApp.configure()
                }
            }
        } else {
            let settings = UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    func registerForPushNotifications() {
        CUserDefaults.set(false, forKey: UserDefaultNotificationCountBadge)
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            guard granted else { return }
            DispatchQueue.main.async {
                self.getNotificationSettings()
            }
        }
    }
}

// MARK:- UNUserNotificationCenterDelegate
// MARK:-

extension FirebasePushNotification {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        appDelegate.notificationPayload = userInfo
        
        //Redirection for notification Sceen
        //        moveOnEventDetailScreenNotifcaiotn()
        
        if let pushPayload = userInfo as? [String:Any]{
            let postConent = pushPayload["content"] as? String ?? ""
            moveOnEventDetailScreenNotifcaiotnLatest(postConent:postConent)
        }
        
        
        completionHandler()
        
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo
        let option = notificationHandleFromActiveMode(userInfo)
        if let pushPayload = userInfo as? [String : Any]{
            print("willPresent ====== \(pushPayload)")
            //            if let _ = pushPayload["identity"] as? String {
            //                VoIPNotificationHandler.shared().actionOnPushNotification(notification: pushPayload)
            
            //                return
            //            }
        }
        
        completionHandler([.alert, .badge, .sound])
    }
    
    
    func moveOnEventDetailScreenNotifcaiotnLatest(postConent:String){
        
        var post_type = ""
        var postInfo = [String:Any]()
        var userID = ""
        _ = ""
        
        let stringCovt = postConent.replace(string: "\\\"", replacement: "\"")
        let dict = convertToDictionaryUserinfo(from: stringCovt)
        guard let userMsg = dict["type"] else { return }
        guard let subject = dict["subject"] else { return }
        
        guard let link = dict["link"] as? String else { return }
        let friend_profile:String = link.stringAfter("=")
        print("link\(friend_profile)")
        
        //New modified
        userID = dict.valueForString(key: "sender") as? String ?? ""
        if userID == ""{
            userID = dict.valueForString(key: "sender_id") as? String ?? ""
        }
        
        postInfo = dict["postInfo"] as? [String:Any] ?? [:]
        if let post_types = postInfo.valueForString(key: "type") as? String{
            post_type = post_types
        }
        
        if let userid = postInfo.valueForString(key: "user_id") as? String{
            userID = userid
            
        }
        
        let subjectCat = subject as! String
        let notifKey = userMsg as! String
        let emailID = postInfo.valueForString(key: "user_email")
        
        switch notifKey {
        case kNotTypeChatUser:
            if subjectCat == "Product viewed"{
                appDelegate.sideMenuController.rootViewController = UINavigationController.init(rootViewController: CStoryboardHome.instantiateViewController(withIdentifier: "HomeViewController"))
                appDelegate.hideSidemenu()
                
                GCDMainThread.asyncAfter(deadline: .now() + kScreenMovingTime) {
                    let homeViewController = appDelegate.getTopMostViewController()
                    appDelegate.moveOnProfileScreenNew(userID,emailID, homeViewController)
                }
            }else {
                appDelegate.sideMenuController.rootViewController = UINavigationController.init(rootViewController: CStoryboardChat.instantiateViewController(withIdentifier: "ChatListViewController"))
                appDelegate.hideSidemenu()
                GCDMainThread.asyncAfter(deadline: .now() + kScreenMovingTime, execute: {
                    if let userDetailVC = CStoryboardChat.instantiateViewController(withIdentifier: "UserChatDetailViewController") as? UserChatDetailViewController {
                        userDetailVC.notifcationStatus = true
                        userDetailVC.iObject = postInfo
                        userDetailVC.isCreateNewChat = true
                        userDetailVC.self.userID = userID.toInt
                        //                        userDetailVC.userID = notificationInfo.valueForInt(key: CFriendId)
                        appDelegate.getTopMostViewController().navigationController?.pushViewController(userDetailVC, animated: true)
                    }
                })
            }
            break
        case kNotTypeGroupRemove:
            
            appDelegate.sideMenuController.rootViewController = UINavigationController.init(rootViewController: CStoryboardGroup.instantiateViewController(withIdentifier: "GroupsViewController"))
            
            if appDelegate.getTopMostViewController().isKind(of: GroupsViewController.classForCoder()) {
                let groupsVC = appDelegate.getTopMostViewController() as? GroupsViewController
                //                groupsVC?.groupType = groupType
            }
            
            appDelegate.hideSidemenu()
            break
            
        case kNotTypeGroup:
            appDelegate.sideMenuController.rootViewController = UINavigationController.init(rootViewController: CStoryboardGroup.instantiateViewController(withIdentifier: "GroupsViewController"))
            appDelegate.hideSidemenu()
            
            GCDMainThread.asyncAfter(deadline: .now() + kScreenMovingTime, execute: {
                if let groupChatDetailsVC = CStoryboardGroup.instantiateViewController(withIdentifier: "GroupChatDetailsViewController") as? GroupChatDetailsViewController {
                    
                    let groupViewController = appDelegate.getTopMostViewController()
                    if let groupVC = groupViewController as? GroupsViewController {
                        groupChatDetailsVC.setBlock { (object, message) in
                            groupVC.getGroupListFromServer(isNew: true)
                        }
                    }
                    let groupID = postInfo.valueForString(key: "group_id")
                    self.getGroupInformationFromServer(groupID:groupID)
                }
            })
            break
            
        case kNotTypeGroupADD:
            
            appDelegate.sideMenuController.rootViewController = UINavigationController.init(rootViewController: CStoryboardGroup.instantiateViewController(withIdentifier: "GroupsViewController"))
            appDelegate.hideSidemenu()
            
            GCDMainThread.asyncAfter(deadline: .now() + kScreenMovingTime, execute: {
                if let groupChatDetailsVC = CStoryboardGroup.instantiateViewController(withIdentifier: "GroupChatDetailsViewController") as? GroupChatDetailsViewController {
                    
                    let groupViewController = appDelegate.getTopMostViewController()
                    if let groupVC = groupViewController as? GroupsViewController {
                        groupChatDetailsVC.setBlock { (object, message) in
                            groupVC.getGroupListFromServer(isNew: true)
                        }
                    }
                    let groupID = postInfo.valueForString(key: "group_id")
                    self.getGroupInformationFromServer(groupID:groupID)
                    
//                    groupChatDetailsVC.notificationGrp = true
//                    groupChatDetailsVC.iObject = postInfo
//                    groupChatDetailsVC.groupNotfInfo = postInfo
//                    groupChatDetailsVC.isCreateNewChat = false
//                    groupViewController.navigationController?.pushViewController(groupChatDetailsVC, animated: true)
                }
            })
            break
            
        case kNotTypeFriendReqAccept,
             kNotTypeFriendReqSentNew:
            
            appDelegate.sideMenuController.rootViewController = UINavigationController.init(rootViewController: CStoryboardHome.instantiateViewController(withIdentifier: "HomeViewController"))
            appDelegate.hideSidemenu()
            
            GCDMainThread.asyncAfter(deadline: .now() + kScreenMovingTime) {
                let homeViewController = appDelegate.getTopMostViewController()
                appDelegate.moveOnProfileScreenNew(friend_profile,emailID, homeViewController)
            }
            //  appDelegate.moveOnProfileScreen(notificationInfo.valueForString(key: "sender"), self)
            break
        case kNotTypeFriendBlocked:
            
            appDelegate.sideMenuController.rootViewController = UINavigationController.init(rootViewController: CStoryboardHome.instantiateViewController(withIdentifier: "HomeViewController"))
            appDelegate.hideSidemenu()
            
            GCDMainThread.asyncAfter(deadline: .now() + kScreenMovingTime) {
                let homeViewController = appDelegate.getTopMostViewController()
                appDelegate.moveOnProfileScreenNew(userID,emailID, homeViewController)
            }
            
            break
        case  kNotTypeEventType:
            
            let userID =  postInfo.valueForString(key: "user_id")
            let postID = postInfo.valueForString(key: "post_id")
            appDelegate.sideMenuController.rootViewController = UINavigationController.init(rootViewController: CStoryboardHome.instantiateViewController(withIdentifier: "HomeViewController"))
            appDelegate.hideSidemenu()
            self.EventDetailsFromServer(eventID: postID.toInt ?? 0, postInfo: postInfo, userID: userID)
            
            break
            
        case kNotTypeCommnet,kNotTypeCommnet:
            let userID =  postInfo.valueForString(key: "user_id")
            let postID = postInfo.valueForString(key: "post_id")
            
            switch post_type {
            case "shout","post_shout":
                appDelegate.sideMenuController.rootViewController = UINavigationController.init(rootViewController: CStoryboardHome.instantiateViewController(withIdentifier: "HomeViewController"))
                appDelegate.hideSidemenu()
                
                self.ShoutDetailsFromServer(shoutID: postID.toInt ?? 0, postInfo: postInfo, userID: userID)
                
            //                if let shoutDetailVC = CStoryboardHome.instantiateViewController(withIdentifier: "ShoutsDetailViewController") as? ShoutsDetailViewController {
            //                    let shoutViewController = appDelegate.getTopMostViewController()
            //                    shoutDetailVC.shoutInformations = postInfo
            //                    shoutDetailVC.likeFromNotify  = true
            //                    print(postInfo.valueForString(key: "post_id"))
            //                    shoutDetailVC.shoutID = postInfo.valueForString(key: "post_id").toInt
            //
            //                    shoutViewController.navigationController?.pushViewController(shoutDetailVC, animated: true)
            //                }
            case "article","post_article":
                
                self.articleDetailsFromServer(articleID: postID.toInt ?? 0, postInfo: postInfo, userID: userID)
                
                appDelegate.sideMenuController.rootViewController = UINavigationController.init(rootViewController: CStoryboardHome.instantiateViewController(withIdentifier: "HomeViewController"))
                appDelegate.hideSidemenu()
                
            //                if let articleDetailVC = CStoryboardHome.instantiateViewController(withIdentifier: "ArticleDetailViewController") as? ArticleDetailViewController {
            //                    let articleViewController = appDelegate.getTopMostViewController()
            //                    articleDetailVC.articleInformation = postInfo
            //                    articleDetailVC.likeFromNotify  = true
            //                    articleDetailVC.articleID = postInfo.valueForString(key: "post_id").toInt
            //                    articleViewController.navigationController?.pushViewController(articleDetailVC, animated: true)
            //                }
            
            
            
            case "gallery","post_gallery":
                let postID = postInfo.valueForString(key: "post_id")
                self.getGalleryDetailsFromServer(imgPostId: postID.toInt,postInfo:postInfo)
            //                self.getGalleryDetailsFromServer(imgPostId: postID.toInt,postInfo:postInfo)
            
            
            case "chirpy","post_chirpy":
                
                appDelegate.sideMenuController.rootViewController = UINavigationController.init(rootViewController: CStoryboardHome.instantiateViewController(withIdentifier: "HomeViewController"))
                appDelegate.hideSidemenu()
                
                //                if let chirpyDetailVC = CStoryboardHome.instantiateViewController(withIdentifier: "ChirpyImageDetailsViewController") as? ChirpyImageDetailsViewController {
                //
                //                    let chirpyViewController = appDelegate.getTopMostViewController()
                //                    //                    chirpyDetailVC.chirpyID = postID
                //                    chirpyDetailVC.chirpyInformation = postInfo
                //                    chirpyDetailVC.likeFromNotify  = true
                //                    chirpyDetailVC.chirpyID = postInfo.valueForString(key: "post_id").toInt
                //                    chirpyViewController.navigationController?.pushViewController(chirpyDetailVC, animated: true)
                //                }
                self.chiripyDetailsFromServer(chiripyID: postID.toInt ?? 0, postInfo: postInfo, userID: userID)
                
            case "forum","post_forum":
                
                appDelegate.sideMenuController.rootViewController = UINavigationController.init(rootViewController: CStoryboardHome.instantiateViewController(withIdentifier: "HomeViewController"))
                appDelegate.hideSidemenu()
                self.forumsDetailsFromServer(forumsID: postID.toInt ?? 0, postInfo: postInfo, userID: userID)
                
            //                if let forumDetailVC = CStoryboardHome.instantiateViewController(withIdentifier: "ForumDetailViewController") as? ForumDetailViewController {
            //
            //                    let forumViewController = appDelegate.getTopMostViewController()
            //                    //                    forumDetailVC.forumID = postID
            //                    forumDetailVC.forumID = postInfo.valueForString(key: "post_id").toInt
            //                    forumDetailVC.likeFromNotify  = true
            //                    forumDetailVC.forumInformation = postInfo
            //                    forumViewController.navigationController?.pushViewController(forumDetailVC, animated: true)
            //                }
            case "event","post_event":
                
                appDelegate.sideMenuController.rootViewController = UINavigationController.init(rootViewController: CStoryboardHome.instantiateViewController(withIdentifier: "HomeViewController"))
                appDelegate.hideSidemenu()
                self.EventDetailsFromServer(eventID: postID.toInt ?? 0, postInfo: postInfo, userID: userID)
                
            //                if let eventDetailVC = CStoryboardEvent.instantiateViewController(withIdentifier: "EventDetailViewController") as? EventDetailImageViewController {
            //
            //                    let eventViewController = appDelegate.getTopMostViewController()
            //                    eventDetailVC.postID = postInfo.valueForString(key: "post_id").toInt
            //                    eventDetailVC.eventInfo = postInfo
            //                    eventDetailVC.likeFromNotify  = true
            //                    eventViewController.navigationController?.pushViewController(eventDetailVC, animated: true)
            //                }
            
            case "poll","post_poll":
                self.getPollDetailsFromServer(pollID: postID.toInt, postInfo: postInfo, userID: userID)
                
            case "productDetails":
                let productID = postInfo.valueForString(key: "product_id")
                
                appDelegate.sideMenuController.rootViewController = UINavigationController.init(rootViewController: CStoryboardHome.instantiateViewController(withIdentifier: "HomeViewController"))
                appDelegate.hideSidemenu()
                
                //                let productID = postInfo.valueForString(key: "product_id")
                if let productDetailVC = CStoryboardProduct.instantiateViewController(withIdentifier: "ProductDetailVC") as? ProductDetailVC {
                    let productViewController = appDelegate.getTopMostViewController()
                    productDetailVC.productIds = productID
                    productViewController.navigationController?.pushViewController(productDetailVC, animated: true)
                }
                
            default:
                break
                
            }
            break
        default:
            break
        }
    }
}



//MARK:- FirebasePushNotificatoin
extension FirebasePushNotification{
    
    //... Shout Detaisl View controller
    
    func ShoutDetailsFromServer(shoutID:Int?,postInfo:[String:Any],userID:String?) {
        if let shoutid = shoutID {
            APIRequest.shared().viewPostDetailLatest(postID: shoutid,userid: userID ?? "", apiKeyCall: "shouts"){ [weak self] (response, error) in
                guard let self = self else { return }
                if response != nil {
                    DispatchQueue.main.async {
                        if let postInfo = response!["data"] as? [[String:Any]]{
                            if let shoutsDetailsVC = CStoryboardHome.instantiateViewController(withIdentifier: "ShoutsDetailViewController") as? ShoutsDetailViewController{
                                let shoutViewController = appDelegate.getTopMostViewController()
                                shoutsDetailsVC.shoutInformations = postInfo.first ?? [:]
                                shoutsDetailsVC.likeFromNotify = true
                                shoutsDetailsVC.shoutID = postInfo.first?.valueForString(key: "post_id").toInt
                                shoutViewController.navigationController?.pushViewController(shoutsDetailsVC, animated: true)
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
                                let articleViewController = appDelegate.getTopMostViewController()
                                articleDetailVC.articleInformation = postInfo.first ?? [:]
                                articleDetailVC.likeFromNotify  = true
                                articleDetailVC.articleID = postInfo.first?.valueForString(key: "post_id").toInt
                                articleViewController.navigationController?.pushViewController(articleDetailVC, animated: true)
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
                                let chiripyViewController = appDelegate.getTopMostViewController()
                                chirpyDetailVC.likeFromNotify = true
                                chirpyDetailVC.chirpyInformation = postInfo.first ?? [:]
                                chirpyDetailVC.chirpyID = postInfo.first?.valueForString(key: "post_id").toInt
                                chiripyViewController.navigationController?.pushViewController(chirpyDetailVC, animated: true)
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
                    DispatchQueue.main.async {
                        if let postInfo = response!["data"] as? [[String:Any]]{
                            if let forumDetailVC = CStoryboardHome.instantiateViewController(withIdentifier: "ForumDetailViewController") as? ForumDetailViewController {
                                let ForumViewController = appDelegate.getTopMostViewController()
                                forumDetailVC.forumID = postInfo.first?.valueForString(key: "post_id").toInt
                                forumDetailVC.likeFromNotify = true
                                forumDetailVC.forumInformation = postInfo.first ?? [:]
                                ForumViewController.navigationController?.pushViewController(forumDetailVC, animated: true)
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
        var postInfos = postInfo
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
                            let galleryViewController = appDelegate.getTopMostViewController()
                            postInfos["image"] = imagesUpload
                            imageDetailVC.galleryInfo = postInfos
                            imageDetailVC.likeFromNotify  = true
                            imageDetailVC.imgPostId = postInfo.valueForString(key: "post_id").toInt
                            galleryViewController.navigationController?.pushViewController(imageDetailVC, animated: true)
                        }
                    }
                }
            }
        }
    }
    
    //...Get Poll Details From Server
    func getPollDetailsFromServer(pollID:Int?,postInfo:[String:Any],userID:String?) {
        var options = ""
        var postInfos = [String:Any]()
        postInfos = postInfo
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
                                let pollViewController = appDelegate.getTopMostViewController()
                                postInfos["options"] = options
                                postInfos["likes"] = Info.first?["likes"] as? String
                                postInfos["comments"] = Info.first?["comments"] as? String
                                postInfos["is_liked"] = Info.first?["is_liked"] as? String
                                pollDetailVC.likeFromNotify  = true
                                pollDetailVC.pollInformation = postInfos
                                pollDetailVC.posted_ID = postInfo.valueForString(key: "post_id")
                                pollViewController.navigationController?.pushViewController(pollDetailVC, animated: true)
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
                                let eventViewController = appDelegate.getTopMostViewController()
                                eventDetailVC.postID = postInfo.first?.valueForString(key: "post_id").toInt
                                eventDetailVC.eventInfo = postInfo.first ?? [:]
                                eventDetailVC.likeFromNotify = true
                                eventViewController.navigationController?.pushViewController(eventDetailVC, animated: true)
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
                            
                            let alertWindow = UIWindow(frame: UIScreen.main.bounds)
                            alertWindow.rootViewController = UIViewController()
                            
                            let alertController = UIAlertController(title: "", message: CMessageGroupDeleted, preferredStyle: UIAlertController.Style.alert)
                            alertController.addAction(UIAlertAction(title: CBtnOk, style: UIAlertAction.Style.cancel, handler: { _ in
                                alertWindow.isHidden = true
                                return
                            }))
                            alertWindow.windowLevel = UIWindow.Level.alert + 1;
                            alertWindow.makeKeyAndVisible()
                            alertWindow.rootViewController?.present(alertController, animated: true, completion: nil)
                            
                            
//                            presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageGroupDeleted, btnOneTitle: CBtnOk, btnOneTapped: nil)
                        }else {
                            var group_id = ""
                        if let groupChatDetailVC = CStoryboardGroup.instantiateViewController(withIdentifier: "GroupChatDetailsViewController") as? GroupChatDetailsViewController {
                            let eventViewController = appDelegate.getTopMostViewController()
                            groupChatDetailVC.iObject =  groupInfo.first ?? [:]
                            groupChatDetailVC.groupNotfInfo = groupInfo.first ?? [:]
                            for group_Data in groupInfo{
                                group_id = group_Data["group_id"] as? String ?? ""
                                print("groupdID \(group_id)")
                            }
                            groupChatDetailVC.group_id = group_id
                            groupChatDetailVC.isCreateNewChat = false
                            groupChatDetailVC.notificationGrp = true
                            eventViewController.navigationController?.pushViewController(groupChatDetailVC, animated: true)
                        }
                        }
                    }
                }
            }
        }
    }
    
    
}


// MARK:- Notification Navigation
// MARK:-

extension FirebasePushNotification {
    
    func notificationHandleFromActiveMode(_ userInfo: [AnyHashable : Any]) -> UNNotificationPresentationOptions {
        
        guard let notificationJsonString = userInfo.valueForJSON(key: CNotificationData) as? String else {
            return []
        }
        guard !notificationJsonString.isEmpty else { return [] }
        
        guard let notificationInfo = convertToDictionary(text: notificationJsonString) else {
            return []
        }
        print("notificationHandleFromActiveMode ====== \(notificationInfo)")
        
        let viewController = appDelegate.getTopMostViewController()
        let notificationType = notificationInfo.valueForInt(key: CNotificationType)
        
        switch notificationType {
        
        case kNotTypeOTOMessage:
            // 2 = OTO Chat
            let friendId = notificationInfo.valueForInt(key: "friend_id") ?? -1
            if let userChatDetail = viewController as? UserChatDetailViewController {
                if (userChatDetail.userID ?? 0) == friendId {
                    return []
                }
            }
            break
        case kNotTypeGroupMessage:
            // 1 = Group Chat
            
            let groupId = notificationInfo.valueForInt(key: "group_id") ?? -1
            if let groupDetail = viewController as? GroupChatDetailsViewController {
                guard let groupDetail = groupDetail.iObject as? [String: Any] else {
                    return [.badge, .alert, .sound]
                }
                let id = (groupDetail.valueForInt(key: "group_id") ?? 0)
                if id ==  groupId {
                    return []
                }
            }
            break
        case kNotTypeFriendReqSent,
             kNotTypeAcceptFriendReq,
             kNotTypeRejectFriendReq:
            // For post related Notification
            return [.badge, .alert, .sound]
            
        case kNotTypeDeleteEvent,
             kNotTypeDeleteGroup:
            // Delete Group and Event Notification
            return [.badge, .alert, .sound]
            
        case kNotTypeJoinGroup:
            // Join Group Notification
            return [.badge, .alert, .sound]
            
        case kNotTypeGroupJoinAccept:
            // Group Join Accept Notification
            return [.badge, .alert, .sound]
            
        case kNotTypeADAccountAccept,
             kNotTypeADAccountReject,
             kNotTypeADPostAccept,
             kNotTypeADPostReject:
            // AD Related Notification
            return [.badge, .alert, .sound]
            
        case kNotTypeEventStatus :
            // Confirmmed, May Be or Declined Event
            return [.badge, .alert, .sound]
            
        case kNotTypeSharedFolder :
            return [.badge, .alert, .sound]
            
        case kNotTypeAdminCreditReward,kNotTypeAdminDebitReward  :
            return [.badge, .alert, .sound]
            
        default:
            // For post related Notification
            return [.badge, .alert, .sound]
        }
        
        if let notificationID = notificationInfo.valueForInt(key: "id") {
            MIGeneralsAPI.shared().readNotification("\(notificationID)")
        }
        
        return [.badge, .alert, .sound]
    }
    
    func redirectToScreen(_ userInfo: [AnyHashable : Any]) {
        
        guard let notificationJsonString = userInfo.valueForJSON(key: CNotificationData) as? String else {
            return
        }
        guard !notificationJsonString.isEmpty else { return  }
        
        guard let notificationInfo = convertToDictionary(text: notificationJsonString) else {
            return
        }
        
        let viewController = appDelegate.getTopMostViewController()
        let notificationType = notificationInfo.valueForInt(key: CNotificationType)
        // From Background.
        
        switch notificationType {
        case kNotTypeOTOMessage:
            // 2 = OTO Chat
            let friendId = notificationInfo.valueForInt(key: "friend_id") ?? -1
            if let userChatDetail = viewController as? UserChatDetailViewController {
                if (userChatDetail.userID ?? 0) != friendId {
                    self.moveOnOTOChatScreen(notificationInfo)
                }
            } else  {
                self.moveOnOTOChatScreen(notificationInfo)
            }
            break
        case kNotTypeGroupMessage:
            // 1 = Group Chat
            
            let groupId = notificationInfo.valueForInt(key: "group_id") ?? -1
            if let groupDetail = viewController as? GroupChatDetailsViewController {
                guard let groupDetail = groupDetail.iObject as? [String: Any] else {
                    self.moveOnGroupChatScreen(notificationInfo)
                    return
                }
                let id = (groupDetail.valueForInt(key: "group_id") ?? 0)
                if id !=  groupId {
                    self.moveOnGroupChatScreen(notificationInfo)
                }
            } else {
                self.moveOnGroupChatScreen(notificationInfo)
            }
            break
            
        case kNotTypeFriendReqSent,
             kNotTypeAcceptFriendReq,
             kNotTypeRejectFriendReq:
            // For post related Notification
            let userId = notificationInfo.valueForString(key: CUserId)
            appDelegate.sideMenuController.rootViewController = UINavigationController.init(rootViewController: CStoryboardHome.instantiateViewController(withIdentifier: "HomeViewController"))
            appDelegate.hideSidemenu()
            
            GCDMainThread.asyncAfter(deadline: .now() + kScreenMovingTime) {
                let homeViewController = appDelegate.getTopMostViewController()
                appDelegate.moveOnProfileScreen(userId, homeViewController)
            }
            
        case kNotTypeDeleteEvent,
             kNotTypeDeleteGroup:
            // Delete Group and Event Notification
            self.moveOnNotificationScreen()
            
        case kNotTypeJoinGroup:
            // Join Group Notification
            self.moveOnGroupMemberRequestScreen(notificationInfo)
            break
            
        case kNotTypeGroupJoinAccept:
            // Group Join Accept Notification
            self.moveOnGroupChatScreen(notificationInfo)
            break
            
        case kNotTypeADAccountAccept,
             kNotTypeADAccountReject,
             kNotTypeADPostAccept,
             kNotTypeADPostReject:
            // AD Related Notification
            self.openAdURlInSafari(notificationInfo.valueForString(key: "url"))
            break
            
        case kNotTypeEventStatus :
            // Confirmmed, May Be or Declined Event
            let postId = notificationInfo.valueForInt(key: CPostId)
            self.moveOnEventInviteesScreen(postId)
            break
        case kNotTypeSharedFolder :
            self.moveOnSharedFolderScreen()
            break
            
        case kNotTypeAdminCreditReward,kNotTypeAdminDebitReward  :
            let categoryName = notificationInfo.valueForString(key: "reward_point_category")
            self.moveOnRewardDetailScreen(category: categoryName)
            break
        default:
            // For post related Notification
            let postId = notificationInfo.valueForInt(key: CPostId)
            let postType = notificationInfo.valueForInt(key: CPostType)
            self.deeplinkingRedirection(postId ?? 0, postType ?? 0)
            break
        }
        
        if let notificationID = notificationInfo.valueForInt(key: "id") {
            MIGeneralsAPI.shared().readNotification("\(notificationID)")
        }
        
        appDelegate.notificationPayload = nil
    }
}

// MARK:- Deeplinking Redirection
// MARK:-

extension FirebasePushNotification {
    
    func deeplinkingRedirection(_ postID: Int, _ postType: Int) {
        
        switch postType {
        case CStaticArticleId:
            self.moveOnArticleDetailScreen(postID)
        case CStaticGalleryId:
            self.moveOnGalleryDetailScreen(postID)
        case CStaticChirpyId:
            self.moveOnChirpyDetailScreen(postID)
        case CStaticShoutId:
            self.moveOnShoutDetailScreen(postID)
        case CStaticForumId:
            self.moveOnForumDetailScreen(postID)
        case CStaticEventId:
            self.moveOnEventDetailScreen(postID)
        default:
            break
        }
    }
    
}


// MARK:- Navigation
// MARK:-

extension FirebasePushNotification {
    // To Move on OTO chat details screen
    func moveOnEventDetailScreenNotifcaiotn(){
        GCDMainThread.asyncAfter(deadline: .now() + kScreenMovingTime, execute: {
            if let userDetailVC = CStoryboardGeneral.instantiateViewController(withIdentifier: "NotificationViewController") as? NotificationViewController {
                appDelegate.getTopMostViewController().navigationController?.pushViewController(userDetailVC, animated: true)
            }
        })
    }
    
    fileprivate func moveOnOTOChatScreen(_ notificationInfo: [String: Any]) {
        
        appDelegate.sideMenuController.rootViewController = UINavigationController.init(rootViewController: CStoryboardChat.instantiateViewController(withIdentifier: "ChatListViewController"))
        appDelegate.hideSidemenu()
        GCDMainThread.asyncAfter(deadline: .now() + kScreenMovingTime, execute: {
            if let userDetailVC = CStoryboardChat.instantiateViewController(withIdentifier: "UserChatDetailViewController") as? UserChatDetailViewController {
                let chatInfo = notificationInfo
                userDetailVC.iObject = chatInfo
                userDetailVC.isCreateNewChat = false
                userDetailVC.userID = notificationInfo.valueForInt(key: CFriendId)
                appDelegate.getTopMostViewController().navigationController?.pushViewController(userDetailVC, animated: true)
            }
        })
    }
    
    // To Move on Group chat details screen
    func moveOnGroupChatScreen(_ notificationInfo: [String: Any]) {
        appDelegate.sideMenuController.rootViewController = UINavigationController.init(rootViewController: CStoryboardGroup.instantiateViewController(withIdentifier: "GroupsViewController"))
        appDelegate.hideSidemenu()
        
        GCDMainThread.asyncAfter(deadline: .now() + kScreenMovingTime, execute: {
            if let groupChatDetailsVC = CStoryboardGroup.instantiateViewController(withIdentifier: "GroupChatDetailsViewController") as? GroupChatDetailsViewController {
                
                let groupViewController = appDelegate.getTopMostViewController()
                if let groupVC = groupViewController as? GroupsViewController {
                    groupChatDetailsVC.setBlock { (object, message) in
                        groupVC.getGroupListFromServer(isNew: true)
                    }
                }
                
                groupChatDetailsVC.iObject = notificationInfo
                groupChatDetailsVC.isCreateNewChat = false
                groupViewController.navigationController?.pushViewController(groupChatDetailsVC, animated: true)
            }
        })
    }
    
    fileprivate func moveOnEventInviteesScreen(_ postID: Int?) {
        appDelegate.sideMenuController.rootViewController = UINavigationController.init(rootViewController: CStoryboardHome.instantiateViewController(withIdentifier: "HomeViewController"))
        appDelegate.hideSidemenu()
         if let eventInviteesVC = CStoryboardEvent.instantiateViewController(withIdentifier: "EventInviteesViewController") as? EventInviteesViewController{
            let articleViewController = appDelegate.getTopMostViewController()
            eventInviteesVC.eventId = postID
            articleViewController.navigationController?.pushViewController(eventInviteesVC, animated: true)
        }
    }
    
    // To Move on Articles details screen
    fileprivate func moveOnArticleDetailScreen(_ postID: Int?) {
        appDelegate.sideMenuController.rootViewController = UINavigationController.init(rootViewController: CStoryboardHome.instantiateViewController(withIdentifier: "HomeViewController"))
        appDelegate.hideSidemenu()
        
        if let articleDetailVC = CStoryboardHome.instantiateViewController(withIdentifier: "ArticleDetailViewController") as? ArticleDetailViewController {
            
            let articleViewController = appDelegate.getTopMostViewController()
            articleDetailVC.articleID = postID
            articleViewController.navigationController?.pushViewController(articleDetailVC, animated: true)
        }
    }
    
    // To Move on Event details screen
    fileprivate func moveOnEventDetailScreen(_ postID: Int?) {
        appDelegate.sideMenuController.rootViewController = UINavigationController.init(rootViewController: CStoryboardHome.instantiateViewController(withIdentifier: "HomeViewController"))
        appDelegate.hideSidemenu()
        
        if let eventDetailVC = CStoryboardEvent.instantiateViewController(withIdentifier: "EventDetailViewController") as? EventDetailViewController {
            
            let eventViewController = appDelegate.getTopMostViewController()
            eventDetailVC.postID = postID
            eventViewController.navigationController?.pushViewController(eventDetailVC, animated: true)
        }
    }
    
    // To Move on With Image Event details screen
    fileprivate func moveOnWithImageEventDetailScreen(_ postID: Int?) {
        appDelegate.sideMenuController.rootViewController = UINavigationController.init(rootViewController: CStoryboardHome.instantiateViewController(withIdentifier: "HomeViewController"))
        appDelegate.hideSidemenu()
        
        if let eventDetailVC = CStoryboardEvent.instantiateViewController(withIdentifier: "EventDetailImageViewController") as? EventDetailImageViewController {
            
            let eventViewController = appDelegate.getTopMostViewController()
            eventDetailVC.postID = postID
            eventViewController.navigationController?.pushViewController(eventDetailVC, animated: true)
        }
    }
    
    // To Move on Chirpy details screen
    fileprivate func moveOnChirpyDetailScreen(_ postID: Int?) {
        appDelegate.sideMenuController.rootViewController = UINavigationController.init(rootViewController: CStoryboardHome.instantiateViewController(withIdentifier: "HomeViewController"))
        appDelegate.hideSidemenu()
        
        if let chirpyDetailVC = CStoryboardHome.instantiateViewController(withIdentifier: "ChirpyDetailsViewController") as? ChirpyDetailsViewController {
            
            let chirpyViewController = appDelegate.getTopMostViewController()
            chirpyDetailVC.chirpyID = postID
            chirpyViewController.navigationController?.pushViewController(chirpyDetailVC, animated: true)
        }
    }
    
    // To Move on With Image Chirpy details screen
    fileprivate func moveOnWithImageChirpyDetailScreen(_ postID: Int?) {
        appDelegate.sideMenuController.rootViewController = UINavigationController.init(rootViewController: CStoryboardHome.instantiateViewController(withIdentifier: "HomeViewController"))
        appDelegate.hideSidemenu()
        
        if let chirpyDetailVC = CStoryboardHome.instantiateViewController(withIdentifier: "ChirpyImageDetailsViewController") as? ChirpyImageDetailsViewController {
            
            let chirpyViewController = appDelegate.getTopMostViewController()
            chirpyDetailVC.chirpyID = postID
            chirpyViewController.navigationController?.pushViewController(chirpyDetailVC, animated: true)
        }
    }
    
    // To Move on Gallery details screen
    fileprivate func moveOnGalleryDetailScreen(_ postID: Int?) {
        appDelegate.sideMenuController.rootViewController = UINavigationController.init(rootViewController: CStoryboardHome.instantiateViewController(withIdentifier: "HomeViewController"))
        appDelegate.hideSidemenu()
        
        if let imageDetailVC = CStoryboardImage.instantiateViewController(withIdentifier: "ImageDetailViewController") as? ImageDetailViewController {
            
            let imageViewController = appDelegate.getTopMostViewController()
            imageDetailVC.imgPostId = postID
            imageViewController.navigationController?.pushViewController(imageDetailVC, animated: true)
        }
    }
    
    // To Move on Forum details screen
    fileprivate func moveOnForumDetailScreen(_ postID: Int?) {
        appDelegate.sideMenuController.rootViewController = UINavigationController.init(rootViewController: CStoryboardHome.instantiateViewController(withIdentifier: "HomeViewController"))
        appDelegate.hideSidemenu()
        
        if let forumDetailVC = CStoryboardHome.instantiateViewController(withIdentifier: "ForumDetailViewController") as? ForumDetailViewController {
            
            let forumViewController = appDelegate.getTopMostViewController()
            forumDetailVC.forumID = postID
            forumViewController.navigationController?.pushViewController(forumDetailVC, animated: true)
        }
    }
    
    // To Move on Shout details screen
    fileprivate func moveOnShoutDetailScreen(_ postID: Int?) {
        appDelegate.sideMenuController.rootViewController = UINavigationController.init(rootViewController: CStoryboardHome.instantiateViewController(withIdentifier: "HomeViewController"))
        appDelegate.hideSidemenu()
        
        if let shoutDetailVC = CStoryboardHome.instantiateViewController(withIdentifier: "ShoutsDetailViewController") as? ShoutsDetailViewController {
            
            let shoutViewController = appDelegate.getTopMostViewController()
            shoutDetailVC.shoutID = postID
            shoutViewController.navigationController?.pushViewController(shoutDetailVC, animated: true)
        }
    }
    
    // To Move on Group Member Request screen
    func moveOnGroupMemberRequestScreen(_ groupInfo: Any) {
        
        appDelegate.sideMenuController.rootViewController = UINavigationController.init(rootViewController: CStoryboardGroup.instantiateViewController(withIdentifier: "GroupsViewController"))
        appDelegate.hideSidemenu()
        
        if let groupInfoVC = CStoryboardGroup.instantiateViewController(withIdentifier: "GroupMemberRequestViewController") as? GroupMemberRequestViewController {
            
            let GroupsViewController = appDelegate.getTopMostViewController()
            groupInfoVC.iObject = groupInfo
            GroupsViewController.navigationController?.pushViewController(groupInfoVC, animated: true)
        }
    }
    
    // To Move on Group List screen
    func moveOnGroupListScreen(groupType: Int) {
        
        appDelegate.sideMenuController.rootViewController = UINavigationController.init(rootViewController: CStoryboardGroup.instantiateViewController(withIdentifier: "GroupsViewController"))
        
        if appDelegate.getTopMostViewController().isKind(of: GroupsViewController.classForCoder()) {
            let groupsVC = appDelegate.getTopMostViewController() as? GroupsViewController
            groupsVC?.groupType = groupType
        }
        
        appDelegate.hideSidemenu()
    }
    
    // To Move on Notification List screen
    fileprivate func moveOnNotificationScreen() {
        appDelegate.sideMenuController.rootViewController = UINavigationController.init(rootViewController: CStoryboardGeneral.instantiateViewController(withIdentifier: "NotificationViewController"))
        appDelegate.hideSidemenu()
    }
    
    // To Move on Group Info screen
    fileprivate func moveOnGroupInfoScreen(_ groupInfo: Any) {
        
        appDelegate.sideMenuController.rootViewController = UINavigationController.init(rootViewController: CStoryboardGroup.instantiateViewController(withIdentifier: "GroupsViewController"))
        appDelegate.hideSidemenu()
        
        if let groupChatDetailVC = CStoryboardGroup.instantiateViewController(withIdentifier: "GroupChatDetailsViewController") as? GroupChatDetailsViewController {
            
            let GroupsViewController = appDelegate.getTopMostViewController()
            groupChatDetailVC.iObject = groupInfo
            GroupsViewController.navigationController?.pushViewController(groupChatDetailVC, animated: true)
        }
    }
    
    fileprivate func moveOnSharedFolderScreen() {
        
        if let sharedFolder = CStoryboardFile.instantiateViewController(withIdentifier: "FileSharingViewController") as? FileSharingViewController {
            sharedFolder.defaultPageIndex = 1
            let sharedNavegation = UINavigationController.init(rootViewController: sharedFolder)
            appDelegate.sideMenuController.rootViewController = sharedNavegation
            appDelegate.hideSidemenu()
        }
    }
    
    fileprivate func moveOnRewardDetailScreen(category:String) {
        if let rewardVC = CStoryboardRewards.instantiateViewController(withIdentifier: "MyRewardsVC") as? MyRewardsVC {
            appDelegate.sideMenuController.rootViewController = UINavigationController.init(rootViewController: rewardVC)
            appDelegate.hideSidemenu()
            
            guard let myWalletHistory = CStoryboardRewards.instantiateViewController(withIdentifier: "MyRewardsHistoryVC") as? MyRewardsHistoryVC else { return }
            myWalletHistory.type = RewardCategory.AdminCorrection
            myWalletHistory.categoryName = category
            rewardVC.navigationController?.pushViewController(myWalletHistory, animated: true)
        }
    }
    
    fileprivate func openAdURlInSafari (_ adUrl: String?) {
        if let url = adUrl {
            appDelegate.getTopMostViewController().openInSafari(strUrl: url)
        }
    }
}



extension FirebasePushNotification{
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func convertToDictionaryUserinfo(from text: String) -> [String: Any] {
        //  print("text from the valies\(text)")
        guard let data = text.data(using: .utf8) else { return [:] }
        let anyResult: Any? = try? JSONSerialization.jsonObject(with: data, options:[])
        return anyResult as? [String: Any] ?? [:]
    }
    
}
