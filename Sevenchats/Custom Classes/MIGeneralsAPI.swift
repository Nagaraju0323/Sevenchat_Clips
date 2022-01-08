//
//  MIGeneralsAPI.swift
//  Sevenchats
//
//  Created by mac-00017 on 23/10/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

enum PostAction : Int {
    case deletePost = 1
    case editPost = 2
    case addPost = 3
    case likePost = 4
    case commentPost = 5
    case interestPost = 6
    case friendRequest = 7
    case reportPost = 8
    case deleteComment = 9
}

class MIGeneralsAPI: NSObject {
    
    private override init() {
        super.init()
    }
    
    private static var generalAPI : MIGeneralsAPI = {
        let generalAPI = MIGeneralsAPI()
        return generalAPI
    }()
    
    static func shared() -> MIGeneralsAPI {
        return generalAPI
    }
}

extension MIGeneralsAPI {
    
    func fetchAllGeneralDataFromServer()
    {
        self.laodLoginUserDetail()
        self.loadCountryList()
        self.loadRelationList()
        self.loadAnnualIncomeList()
        self.loadEducationList()
        self.loadInterestList()
        self.loadSubInterestList()
      //  self.loadFeedbackCategory()
        self.loadNewsCategory()
        self.loadInterestListArticle()
        self.loadInterestListChiripy()
        self.loadInterestListForum()
        self.loadInterestListGallery()
        self.loadInterestListPoll()
        self.loadInterestListEvent()
        self.loadPointsConfigs()
        self.loadRewardsCategory()
        self.loadProductCategory()
        self.loadUserRewardPoings()
        self.loadPslCategory()
    
        
        
    }
    
    
    func loadUserRewardPoings() {
        
        if let userID = appDelegate.loginUser?.user_id {
            
            let dict:[String:Any] = [
                CUserId : userID.description
            ]
            
            APIRequest.shared().rewardsSummaryNew(dict: dict,showLoader : true) { (response, error) in
                if response != nil {
                }
            }
        }
    }
    
    func laodLoginUserDetail() {
        
        if let userEmail = appDelegate.loginUser?.email {
            
            let dict:[String:Any] = [
                CEmail_Mobile : userEmail.description
            ]
            
            APIRequest.shared().userDetails(para: dict as [String : AnyObject]) { (response, error) in
                if response != nil {
                }
            }
        }
        
//        APIRequest.shared().getFeedbackCategoryList { (response, error) in
//            if response != nil && error == nil {
//            }
//        }
    }
    
//    func loadFeedbackCategory() {
//        APIRequest.shared().getFeedbackCategoryList { (response, error) in
//            if response != nil && error == nil {
//            }
//        }
//    }
        
    func loadCountryList() {
        
        //...Load country list from server
        let timestamp : TimeInterval = 0
        
        if CUserDefaults.value(forKey: UserDefaultTimestamp) != nil {
            //timestamp = CUserDefaults.value(forKey: UserDefaultTimestamp) as! TimeInterval
        }
        
        APIRequest.shared().countryList(timestamp: timestamp as AnyObject) { (response, error) in
            
            if response != nil && error == nil {
                
                let metaData = response?.value(forKey: CJsonMeta) as? [String : AnyObject]
                
                CUserDefaults.setValue(metaData?["new_timestamp"], forKey: UserDefaultTimestamp)
                CUserDefaults.synchronize()
            }
        }
    }
    
    func loadRewardsCategory() {
        
        //...Load country list from server
        let timestamp : TimeInterval = 0
        
        if CUserDefaults.value(forKey: UserDefaultTimestamp) != nil {
        }
        
        APIRequest.shared().loadRewardsCategory(timestamp: timestamp as AnyObject) { (response, error) in
            
            if response != nil && error == nil {
                
                let metaData = response?.value(forKey: CJsonMeta) as? [String : AnyObject]
                
                CUserDefaults.setValue(metaData?["new_timestamp"], forKey: UserDefaultTimestamp)
                CUserDefaults.synchronize()
            }
        }
    }
    
    func loadPointsConfigs() {
        
        //...Load country list from server
        let timestamp : TimeInterval = 0
        
        if CUserDefaults.value(forKey: UserDefaultTimestamp) != nil {
            //timestamp = CUserDefaults.value(forKey: UserDefaultTimestamp) as! TimeInterval
        }
        
        APIRequest.shared().loadPointsConfigs(timestamp: timestamp as AnyObject) { (response, error) in
            
            if response != nil && error == nil {
                
                let metaData = response?.value(forKey: CJsonMeta) as? [String : AnyObject]
                
                CUserDefaults.setValue(metaData?["new_timestamp"], forKey: UserDefaultTimestamp)
                CUserDefaults.synchronize()
            }
        }
    }
    
    
    
    func loadRelationList(){
        APIRequest.shared().getRelationList { (response, error) in
            if response != nil && error == nil {
            }
        }
    }
    
    func loadAnnualIncomeList() {
        APIRequest.shared().getAnnualIncomeList { (response, error) in
            if response != nil && error == nil {
            }
        }
    }
    
    func loadEducationList() {
        APIRequest.shared().getEducationList { (response, error) in
            if response != nil && error == nil {
            }
        }
    }
    
    func loadInterestList() {
        guard let langName = appDelegate.loginUser?.lang_name else {
            return
        }
        _ = APIRequest.shared().getInterestListNew(search: "",langName:langName, type: CInterestType, page: nil, showLoader: false) { (response, error) in
            if response != nil && error == nil {
            }
        }
    }
    
    
    func loadProductCategory() {
        guard let langName = appDelegate.loginUser?.lang_name else {return}
        _ = APIRequest.shared().productLevelCategoriesList(searchText:langName,showLoader : false) { (response, error) in
            if response != nil && error == nil {
            }
        }
    }

    
    
    /********************************************************
     * Author : & Chandrika R                               *
     * Model  : PostCategory Notification                   *
     * option                                               *
     ********************************************************/
    
    
    func loadInterestListArticle() {
        guard let langName = appDelegate.loginUser?.lang_name else {
            return
        }
        _ = APIRequest.shared().getInterestListArticle(articleType:"Article",langName:langName, type: CInterestType, page: nil, showLoader: false) { (response, error) in
            if response != nil && error == nil {
            }
        }
    }
    
    func loadInterestListChiripy() {
        guard let langName = appDelegate.loginUser?.lang_name else {
            return
        }
        _ = APIRequest.shared().getInterestListChiripy(articleType:"Chirpy",langName:langName, type: CInterestType, page: nil, showLoader: false) { (response, error) in
            if response != nil && error == nil {
            }
        }
    }
    func loadInterestListEvent() {
        guard let langName = appDelegate.loginUser?.lang_name else {
            return
        }
        _ = APIRequest.shared().getInterestListEvent(articleType:"Event",langName:langName, type: CInterestType, page: nil, showLoader: false) { (response, error) in
            if response != nil && error == nil {
            }
        }
    }
    func loadInterestListForum() {
        guard let langName = appDelegate.loginUser?.lang_name else {
            return
        }
        _ = APIRequest.shared().getInterestListForum(articleType:"Forum",langName:langName, type: CInterestType, page: nil, showLoader: false) { (response, error) in
            if response != nil && error == nil {
            }
        }
    }
    func loadInterestListGallery() {
        guard let langName = appDelegate.loginUser?.lang_name else {
            return
        }
        _ = APIRequest.shared().getInterestListGallery(articleType:"Gallery",langName:langName, type: CInterestType, page: nil, showLoader: false) { (response, error) in
            if response != nil && error == nil {
            }
        }
    }
    func loadInterestListPoll() {
        guard let langName = appDelegate.loginUser?.lang_name else {
            return
        }
        _ = APIRequest.shared().getInterestListPoll(articleType:"Poll",langName:langName, type: CInterestType, page: nil, showLoader: false) { (response, error) in
            if response != nil && error == nil {
            }
        }
    }
    
    
    
    
    func loadSubInterestList() {
        
        guard let langName = appDelegate.loginUser?.lang_name else {
            return
        }
        
        _ = APIRequest.shared().getInterestListNew(search: "",langName:langName, type: CInterestType, page: nil, showLoader: false) { (response, error) in
            if response != nil && error == nil {
            }
        }
    }
    
    
    func loadNewsCategory() {
        
        _ = APIRequest.shared().getNewsCategory(completion: { (response, error) in
            if response != nil && error == nil {
            }
        })
    }
    
    
    func loadPslCategory() {
        
        _ = APIRequest.shared().getPslCategory(completion: { (response, error) in
            if response != nil && error == nil {
            }
        })
    }
    
  
    
     func likeUnlikePostWebsite(post_id : Int?, rss_id : Int?, type : Int?, likeStatus : Int, viewController : UIViewController?){
       
//        if type == 1{
//            MIGeneralsAPI.shared().refreshPostRelatedScreens(likeInfo, post_id, viewController!, .likePost)
//        }else{
//            MIGeneralsAPI.shared().refreshWebSiteScreens(likeInfo, rss_id, viewController!, .likePost)
//        }
        
        
        
//        APIRequest.shared().likeUnlikePostWebsite(post_id: post_id, rss_id: rss_id, type: type, like_unlike_status: likeStatus) { (response, error) in
        APIRequest.shared().likeUnlikeProductCount(productId:post_id ?? 0){ [weak self](response, error) in
            if response != nil && error == nil{
                print(response!["liked_users"] as? [String:Any] ?? [:])
                GCDMainThread.async { [self] in
                   
                    if let likeInfo = response!["liked_users"] as? [String : Any]{
                        if type == 1{
                            MIGeneralsAPI.shared().refreshPostRelatedScreens(likeInfo, post_id, viewController!, .likePost)
                        }else{
                            MIGeneralsAPI.shared().refreshWebSiteScreens(likeInfo, rss_id, viewController!, .likePost)
                        }
                   }
                }
            }
        }
    }
    
    
    func likeUnlikePostWebsites(post_id : Int?, rss_id : Int?, type : Int?, likeStatus : Int,info:[String:Any], viewController : UIViewController?){
      
//        if type == 1{
//            MIGeneralsAPI.shared().refreshPostRelatedScreens(likeInfo, post_id, viewController!, .likePost)
//        }else{
//            MIGeneralsAPI.shared().refreshWebSiteScreens(likeInfo, rss_id, viewController!, .likePost)
//        }
       
        MIGeneralsAPI.shared().refreshPostRelatedScreens(info, post_id, viewController!, .likePost)
       
//        APIRequest.shared().likeUnlikePostWebsite(post_id: post_id, rss_id: rss_id, type: type, like_unlike_status: likeStatus) { (response, error) in
//       APIRequest.shared().likeUnlikeProductCount(productId:post_id ?? 0){ [weak self](response, error) in
//           if response != nil && error == nil{
//               print(response!["liked_users"] as? [String:Any] ?? [:])
//               GCDMainThread.async { [self] in
//
//                   if let likeInfo = response!["liked_users"] as? [String : Any]{
//                       if type == 1{
//                           MIGeneralsAPI.shared().refreshPostRelatedScreens(likeInfo, post_id, viewController!, .likePost)
//                       }else{
//                           MIGeneralsAPI.shared().refreshWebSiteScreens(likeInfo, rss_id, viewController!, .likePost)
//                       }
//                  }
//               }
//           }
//       }
   }
    
    
    func likeUnlikePostWebsites(post_id : Int?, rss_id : Int?, type : Int?, likeStatus : Int, viewController : UIViewController?){
//       APIRequest.shared().likeUnlikePostWebsite(post_id: post_id, rss_id: rss_id, type: type, like_unlike_status: likeStatus) { (response, error) in
//           if response != nil && error == nil{
//               if let likeInfo = response![CJsonData] as? [String : Any]{
//                   if type == 1{
//                       MIGeneralsAPI.shared().refreshPostRelatedScreens(likeInfo, post_id, viewController!, .likePost)
//                   }else{
//                       MIGeneralsAPI.shared().refreshWebSiteScreens(likeInfo, rss_id, viewController!, .likePost)
//                   }
//               }
//           }
//       }
   }
    
//    func interestNotInterestMayBe(_ post_id : Int?, _ type : Int, viewController : UIViewController?){
//        APIRequest.shared().interestMayBeNotInterest(post_id: post_id, type: type) { (response, error) in
//            if response != nil && error == nil {
//                if let interInfo = response![CJsonData] as? [String : Any] {
//                        MIGeneralsAPI.shared().refreshPostRelatedScreens(interInfo, post_id, viewController!, .interestPost)
//                }
//            }
//        }
//    }
//
    func interestNotInterestMayBe(_ post_id : Int?, _ type : Int, viewController : UIViewController?){
        APIRequest.shared().interestMayBeNotInterest(post_id: post_id, type: type) { (response, error) in
            if response != nil && error == nil {
                let interInfo = response![CJsonData] as? [[String : Any]]
                if let interInfo = response![CJsonData] as? [[String : Any]] {
                    let userChoice = interInfo.first ?? [:]
                    MIGeneralsAPI.shared().refreshPostRelatedScreens(userChoice, post_id, viewController!, .interestPost)
                }
            }else {
                
                guard  let errorUserinfo = error?.userInfo["error"] as? String else {
                    return
                }
                let errorMsg = errorUserinfo.stringAfter(":")
                print("erroMsg\(errorMsg)")
                if errorMsg == " choice Already Exists"{
                    CTopMostViewController.presentAlertViewWithOneButton(alertTitle: "", alertMessage: errorMsg, btnOneTitle: CBtnOk, btnOneTapped: { [weak self] (alert) in
                        guard let self = self else { return }
                        
                    })
                }
            }
        }
    }
    
    func addRemoveNotificationToken(isLogout : Int?) {
        appDelegate.logOut()
        UserDefaultHelper.deleteuserChatLastMsg()
        
//        if let token = CUserDefaults.value(forKey: UserDefaultNotificationToken) as? String {
//            _ = APIRequest.shared().addAndRemoveDeviceToken(device_token: token, is_logout: isLogout) { (response, error) in
//                if response != nil && error == nil {
//                    if isLogout != nil {
//                        // LOGOUT
//                        appDelegate.logOut()
//                    }
//                }
//            }
//        }else {
//            print("Notification token not found...")
//            if isLogout != nil {
//                // LOGOUT
//                appDelegate.logOut()
//            }
//        }
    }

    func getAdvertisementList() {
//        APIRequest.shared().advertisementList(page: 0) { (response, error) in
//        }
//
    }
    
    func readNotification(_ notId: String?) {
        APIRequest.shared().readNotification(notificationIDs: notId) { (response, error) in
            if response != nil && error == nil {
                print("response\(response)")
            }
        }
    }
    
    
    func removeAdvertisement(transactionID: String?, completion:((Bool)-> Void)? = nil) {
//        APIRequest.shared().removeAdvertisement(transactionId: transactionID) { (response, error) in
//            if response != nil && error == nil {
//                completion?(true)
//                appDelegate.getTopMostViewController().dismiss(animated: true, completion: nil)
//            } else {
//                completion?(false)
//            }
//        }
    }
}

//MARK:- ------ Refresh post related Screens..
extension MIGeneralsAPI {
    
    func refreshWebSiteScreens(_ websiteInfo : [String : Any]?,_ rssId : Int?, _ view : UIViewController, _ postAction : PostAction?) {
        if let arrViewControllers = view.navigationController?.viewControllers{
            for viewController in arrViewControllers{
                // Refresh Website screen here....
                if viewController.isKind(of: FavWebSideViewController.classForCoder()){
                    if let webSiteVC = viewController as? FavWebSideViewController{
                        switch postAction {
                        case .likePost?:
                            if let index = webSiteVC.arrFavWebSite.firstIndex(where: { $0[CId] as? Int == rssId}) {
                                var webLikeInfo = webSiteVC.arrFavWebSite[index]
                                webLikeInfo[CIs_Like] = websiteInfo?.valueForInt(key: CIs_Like)
                                webLikeInfo[CTotal_like] = websiteInfo?.valueForInt(key: CTotal_like)
                                webSiteVC.arrFavWebSite.remove(at: index)
                                webSiteVC.arrFavWebSite.insert(webLikeInfo, at: index)
                                UIView.performWithoutAnimation {
                                    let indexPath = IndexPath(item: index, section: 0)
                                    if (webSiteVC.tblFavWebSite.indexPathsForVisibleRows?.contains(indexPath))!{
                                        webSiteVC.tblFavWebSite.reloadRows(at: [indexPath], with: .none)
                                    }
                                }
                            }
                            break
                        case .deletePost?, .reportPost?:
                            webSiteVC.pullToRefresh()
                            /*if let index = webSiteVC.arrFavWebSite.firstIndex(where: { $0[CId] as? Int == rssId}) {
                                webSiteVC.arrFavWebSite.remove(at: index)
                                UIView.performWithoutAnimation {
                                    webSiteVC.tblFavWebSite.reloadData()
                                }
                            }*/
                            break
                        case .commentPost?:
                            if let index = webSiteVC.arrFavWebSite.firstIndex(where: { $0[CId] as? Int == rssId}) {
                                if let webMetaInfo = websiteInfo![CJsonMeta] as? [String : Any]{
                                    var webLikeInfo = webSiteVC.arrFavWebSite[index]
                                    webLikeInfo[CTotalComment] = webMetaInfo.valueForInt(key: CTotal)
                                    webSiteVC.arrFavWebSite.remove(at: index)
                                    webSiteVC.arrFavWebSite.insert(webLikeInfo, at: index)
                                    
                                    UIView.performWithoutAnimation {
                                        let indexPath = IndexPath(item: index, section: 0)
                                        if (webSiteVC.tblFavWebSite.indexPathsForVisibleRows?.contains(indexPath))!{
                                            webSiteVC.tblFavWebSite.reloadRows(at: [indexPath], with: .none)
                                        }
                                    }
                                }
                            }
                            break
                        default:
                            break
                        }
                    }
                }
                
                // Refresh Website details screen here....
                if viewController.isKind(of: FavWebSiteDetailViewController.classForCoder()){
                    if let webSiteVC = viewController as? FavWebSiteDetailViewController{
                        if postAction == .commentPost{
                            if let arrComm = websiteInfo![CJsonData] as? [[String : Any]]{
                                if let metaInfo = websiteInfo![CJsonMeta] as? [String : Any]{
                                    webSiteVC.updateCommentSection(arrComm, metaInfo.valueForInt(key: CTotal)!)
                                }
                            }
                        }
                    }
                }
                
                
            }
        }
        
    }
        
    func refreshPostRelatedScreens(_ postInfo : [String : Any]?,_ postId : Int?, _ view : UIViewController, _ postAction : PostAction?) {
        
        // To refresh detail screens.....
        if let blockHandler = view.block {
            blockHandler(postInfo, "success")
        }
        
        if let arrViewControllers = view.navigationController?.viewControllers{
            for viewController in arrViewControllers{
                // Refresh Home screen here....
                if viewController.isKind(of: HomeViewController.classForCoder()) {
                    if let homeVC = viewController as? HomeViewController{
                        
                        switch postAction {
                        case .addPost?:
                            if homeVC.apiTask?.state == URLSessionTask.State.running {
                                homeVC.apiTask?.cancel()
                            }
                            
                            homeVC.pageNumber = 1
                            homeVC.getPostListFromServer(showLoader: false)
                            homeVC.tblEvents.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                        case .editPost?:
                            if let index = homeVC.arrPostList.firstIndex(where: { $0[CId] as? Int == postInfo!.valueForInt(key: CId)}) {
                                homeVC.arrPostList.remove(at: index)
                                homeVC.arrPostList.insert(postInfo!, at: index)
                                UIView.performWithoutAnimation {
                                    let indexPath = IndexPath(item: index, section: 1)
                                    if (homeVC.tblEvents.indexPathsForVisibleRows?.contains(indexPath))!{
                                        homeVC.tblEvents.reloadRows(at: [indexPath], with: .none)
                                    }
                                }
                            }
                            break
                            case .reportPost?:
                            if let index = homeVC.arrPostList.firstIndex(where: { $0[CId] as? Int == postId}) {
                                homeVC.arrPostList.remove(at: index)
                                UIView.performWithoutAnimation {
                                    homeVC.tblEvents.reloadData()
                                    homeVC.lblNoData.isHidden = homeVC.arrPostList.count > 0
                                }
                            }
                            break
                            case .deletePost?:
                                if let index = homeVC.arrPostList.firstIndex(where: { $0["post_id"] as? String == postId?.toString}) {
                                    homeVC.arrPostList.remove(at:index)
                                    UIView.performWithoutAnimation {
                                        homeVC.tblEvents.reloadData()
                                        homeVC.lblNoData.isHidden = homeVC.arrPostList.count > 0
                                    }
                                }
                                let arrPosts = homeVC.arrPostList
                                for (index,obj) in arrPosts.enumerated(){
                                    if obj[COriginalPostId] as? Int == postId{
                                        var postPollInfo = obj
                                        postPollInfo[CIsPostDeleted] = 1
                                        homeVC.arrPostList.remove(at: index)
                                        homeVC.arrPostList.insert(postPollInfo, at: index)
                                        UIView.performWithoutAnimation {
                                            DispatchQueue.main.async {
                                                let indexPath = IndexPath(item: index, section: 1)
                                                if (homeVC.tblEvents.indexPathsForVisibleRows?.contains(indexPath))!{
                                                    homeVC.tblEvents.reloadRows(at: [indexPath], with: .none)
                                                }
                                            }
                                        }
                                    }
                                }
                            break
                            case .likePost?:
                                if let index = homeVC.arrPostList.firstIndex(where: { $0["post_id"] as? String == postId?.toString}) {
                                    var postLikeInfo = homeVC.arrPostList[index]
//                                    postLikeInfo[CIs_Like] = postInfo?.valueForInt(key: CIs_Like)
                                    postLikeInfo[CLikes] = postInfo?.valueForString(key: "likes")
//                                    postLikeInfo[CLikes] = postInfo?.valueForString(key: CLikes)
                                    postLikeInfo[CIsLiked] = postInfo?.valueForString(key: CIsLiked)
//                                    postLikeInfo[CTotal_like] = postInfo?.valueForInt(key: CTotal_like)
                                    homeVC.arrPostList.remove(at: index)
                                    homeVC.arrPostList.insert(postLikeInfo, at: index)
                                    UIView.performWithoutAnimation {
                                        let indexPath = IndexPath(item: index, section: 1)
                                        if (homeVC.tblEvents.indexPathsForVisibleRows?.contains(indexPath))!{
                                            homeVC.tblEvents.reloadRows(at: [indexPath], with: .none)
                                        }
                                    }
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
                                }
                            break
                        case .interestPost?:
                            if let index = homeVC.arrPostList.firstIndex(where: { $0["post_id"] as? String == postId?.toString}) {
                                var postLikeInfo = homeVC.arrPostList[index]
                                let choice =  postInfo?.valueForString(key: "choice")
                                
                                
                                if choice == "yes"{
                                    let yesCount = postLikeInfo.valueForString(key:"yes_count").toInt ?? 0
                                    let totalCnt = (yesCount + 1).toString
                                    postLikeInfo["yes_count"] = totalCnt
                                    postLikeInfo[CIsInterested] = "1"
                                    postLikeInfo["selected_choice"] = "1"
                                }
                                if choice == "maybe"{
                                    let mayCount = postLikeInfo.valueForString(key:"maybe_count").toInt ?? 0
                                    let totalCnt = (mayCount + 1).toString
                                    postLikeInfo["maybe_count"] = totalCnt
                                    postLikeInfo[CIsInterested] = "3"
                                    postLikeInfo["selected_choice"] = "3"
                                }
                                if choice == "no"{
                                    let noCount = postLikeInfo.valueForString(key:"no_count").toInt ?? 0
                                    let totalCnt = (noCount + 1).toString
                                    postLikeInfo["no_count"] = totalCnt
                                    postLikeInfo[CIsInterested] = "2"
                                    postLikeInfo["selected_choice"] = "2"
                                }
                                
//                                postLikeInfo[CIsInterested] = postInfo?.valueForInt(key: CIsInterested)
                                homeVC.arrPostList.remove(at: index)
                                homeVC.arrPostList.insert(postLikeInfo, at: index)
                                UIView.performWithoutAnimation {
                                    let indexPath = IndexPath(item: index, section: 1)
                                    if (homeVC.tblEvents.indexPathsForVisibleRows?.contains(indexPath))!{
                                        homeVC.tblEvents.reloadRows(at: [indexPath], with: .none)
                                    }
                                }
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
                            }
                            let arrPosts = homeVC.arrPostList
                            for (index,obj) in arrPosts.enumerated(){
                                if obj[COriginalPostId] as? Int == postId{
                                    var postPollInfo = obj
                                    postPollInfo[CIsInterested] = postInfo?.valueForInt(key: CIsInterested)
                                    postPollInfo[CTotalInterestedUsers] = postInfo?.valueForInt(key: CTotalInterestedUsers)
                                    postPollInfo[CTotalNotInterestedUsers] = postInfo?.valueForInt(key: CTotalNotInterestedUsers)
                                    postPollInfo[CTotalMaybeInterestedUsers] = postInfo?.valueForInt(key: CTotalMaybeInterestedUsers)
                                    homeVC.arrPostList.remove(at: index)
                                    homeVC.arrPostList.insert(postPollInfo, at: index)
                                    UIView.performWithoutAnimation {
                                        DispatchQueue.main.async {
                                            let indexPath = IndexPath(item: index, section: 1)
                                            if (homeVC.tblEvents.indexPathsForVisibleRows?.contains(indexPath))!{
                                                homeVC.tblEvents.reloadRows(at: [indexPath], with: .none)
                                            }
                                        }
                                    }
                                }
                            }
                            break
                        case .commentPost?:
                            if let index = homeVC.arrPostList.firstIndex(where: { $0["post_id"] as? String == postId?.toString}) {
                                var postLikeInfo = homeVC.arrPostList[index]
                                postLikeInfo["comments"] = postInfo?.valueForString(key: "comments")
//                                postLikeInfo[CIsLiked] = postInfo?.valueForString(key: CIsLiked)
//                                homeVC.arrPostList.remove(at: index)
//                                homeVC.arrPostList.insert(postLikeInfo, at: index)
                                homeVC.arrPostList.remove(at: index)
                                homeVC.arrPostList.insert(postLikeInfo, at: index)
                                
                                UIView.performWithoutAnimation {
                                    let indexPath = IndexPath(item: index, section: 1)
                                    if (homeVC.tblEvents.indexPathsForVisibleRows?.contains(indexPath))!{
                                        homeVC.tblEvents.reloadRows(at: [indexPath], with: .none)
                                    }
                                
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
//                                if let postMetaInfo = postInfo![CJsonMeta] as? [String : Any]{
//                                    postLikeInfo[CTotalComment] = postMetaInfo.valueForInt(key: CTotal)
//                                    homeVC.arrPostList.remove(at: index)
//                                    homeVC.arrPostList.insert(postLikeInfo, at: index)
//                                    UIView.performWithoutAnimation {
//                                        let indexPath = IndexPath(item: index, section: 1)
//                                        if (homeVC.tblEvents.indexPathsForVisibleRows?.contains(indexPath))!{
//                                            homeVC.tblEvents.reloadRows(at: [indexPath], with: .none)
//                                        }
//                                    }
                                }
                            }
                            break
                            case .deleteComment?:
                                if let index = homeVC.arrPostList.firstIndex(where: { $0["post_id"] as? String == postId?.toString}) {
                                var postLikeInfo = homeVC.arrPostList[index]
                                    
                                let commentDel = (postLikeInfo.valueForString(key: "comments") )
                                let commentAfDele = (commentDel.toInt) ?? 0
                                let commet = commentAfDele - 1
                                postLikeInfo["comments"] = commet.toString
//                                homeVC.arrPostList.remove(at: index)
//                                homeVC.arrPostList.insert(postLikeInfo, at: index)
                                    homeVC.arrPostList.remove(at: index)
                                    homeVC.arrPostList.insert(postLikeInfo, at: index)
                                UIView.performWithoutAnimation {
                                    let indexPath = IndexPath(item: index, section: 1)
                                    if (homeVC.tblEvents.indexPathsForVisibleRows?.contains(indexPath))!{
                                        homeVC.tblEvents.reloadRows(at: [indexPath], with: .none)
                                    }
                                }
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
                            }
                            break
                        default:
                            break
                        }
                    }
                }
                
                // Refresh Home search screen here....
                if viewController.isKind(of: HomeSearchViewController.classForCoder()){
                    if let homeSearchVC = viewController as? HomeSearchViewController{
                        
                        switch postAction {
                        case .addPost?:
                            homeSearchVC.timeStamp = nil
                            homeSearchVC.isPost = nil
                            homeSearchVC.getSearchDataFromServer(homeSearchVC.txtSearch.text, "new")
                            
                        case .editPost?:
                            if let index = homeSearchVC.arrHomeSearch.firstIndex(where: { $0[CId] as? Int == postInfo!.valueForInt(key: CId)}) {
                                homeSearchVC.arrHomeSearch.remove(at: index)
                                homeSearchVC.arrHomeSearch.insert(postInfo!, at: index)
                                UIView.performWithoutAnimation {
                                    let indexPath = IndexPath(item: index, section: 0)
                                    if (homeSearchVC.tblEvents.indexPathsForVisibleRows?.contains(indexPath))!{
                                        homeSearchVC.tblEvents.reloadRows(at: [indexPath], with: .none)
                                    }
                                }
                            }
                            break
                        case .reportPost?:
                            if let index = homeSearchVC.arrHomeSearch.firstIndex(where: { $0[CId] as? Int == postId}) {
                                homeSearchVC.arrHomeSearch.remove(at: index)
                                UIView.performWithoutAnimation {
                                    homeSearchVC.tblEvents.reloadData()
                                }
                            }
                            break
                        case .deletePost?:
                            if let index = homeSearchVC.arrHomeSearch.firstIndex(where: { $0[CId] as? Int == postId}) {
                                homeSearchVC.arrHomeSearch.remove(at: index)
                                UIView.performWithoutAnimation {
                                    homeSearchVC.tblEvents.reloadData()
                                }
                            }
                            let arrPosts = homeSearchVC.arrHomeSearch
                            for (index,obj) in arrPosts.enumerated(){
                                if obj[COriginalPostId] as? Int == postId{
                                    var postPollInfo = obj
                                    postPollInfo[CIsPostDeleted] = 1
                                    homeSearchVC.arrHomeSearch.remove(at: index)
                                    homeSearchVC.arrHomeSearch.insert(postPollInfo, at: index)
                                    UIView.performWithoutAnimation {
                                        DispatchQueue.main.async {
                                            let indexPath = IndexPath(item: index, section: 1)
                                            if (homeSearchVC.tblEvents.indexPathsForVisibleRows?.contains(indexPath))!{
                                                homeSearchVC.tblEvents.reloadRows(at: [indexPath], with: .none)
                                            }
                                        }
                                    }
                                }
                            }
                            break
                        case .likePost?:
                            if let index = homeSearchVC.arrHomeSearch.firstIndex(where: { $0[CId] as? Int == postId}) {
                                var postLikeInfo = homeSearchVC.arrHomeSearch[index]
                                postLikeInfo[CIs_Like] = postInfo?.valueForInt(key: CIs_Like)
                                postLikeInfo[CTotal_like] = postInfo?.valueForInt(key: CTotal_like)
                                homeSearchVC.arrHomeSearch.remove(at: index)
                                homeSearchVC.arrHomeSearch.insert(postLikeInfo, at: index)
                                UIView.performWithoutAnimation {
                                    let indexPath = IndexPath(item: index, section: 0)
                                    if (homeSearchVC.tblEvents.indexPathsForVisibleRows?.contains(indexPath))!{
                                        homeSearchVC.tblEvents.reloadRows(at: [indexPath], with: .none)
                                    }
                                }
                            }
                            break
                        case .interestPost?:
                            if let index = homeSearchVC.arrHomeSearch.firstIndex(where: { $0[CId] as? Int == postId}) {
                                var postLikeInfo = homeSearchVC.arrHomeSearch[index]
                                
                                postLikeInfo[CIsInterested] = postInfo?.valueForInt(key: CIsInterested)
                                postLikeInfo[CTotalInterestedUsers] = postInfo?.valueForInt(key: CTotalInterestedUsers)
                                postLikeInfo[CTotalNotInterestedUsers] = postInfo?.valueForInt(key: CTotalNotInterestedUsers)
                                postLikeInfo[CTotalMaybeInterestedUsers] = postInfo?.valueForInt(key: CTotalMaybeInterestedUsers)
                                
                                homeSearchVC.arrHomeSearch.remove(at: index)
                                homeSearchVC.arrHomeSearch.insert(postLikeInfo, at: index)
                                UIView.performWithoutAnimation {
                                    let indexPath = IndexPath(item: index, section: 0)
                                    if (homeSearchVC.tblEvents.indexPathsForVisibleRows?.contains(indexPath))!{
                                        homeSearchVC.tblEvents.reloadRows(at: [indexPath], with: .none)
                                    }
                                }
                            }
                            let arrPosts = homeSearchVC.arrHomeSearch
                            for (index,obj) in arrPosts.enumerated(){
                                if obj[COriginalPostId] as? Int == postId{
                                    var postPollInfo = obj
                                    postPollInfo[CIsInterested] = postInfo?.valueForInt(key: CIsInterested)
                                    postPollInfo[CTotalInterestedUsers] = postInfo?.valueForInt(key: CTotalInterestedUsers)
                                    postPollInfo[CTotalNotInterestedUsers] = postInfo?.valueForInt(key: CTotalNotInterestedUsers)
                                    postPollInfo[CTotalMaybeInterestedUsers] = postInfo?.valueForInt(key: CTotalMaybeInterestedUsers)
                                    homeSearchVC.arrHomeSearch.remove(at: index)
                                    homeSearchVC.arrHomeSearch.insert(postPollInfo, at: index)
                                    UIView.performWithoutAnimation {
                                        DispatchQueue.main.async {
                                            let indexPath = IndexPath(item: index, section: 1)
                                            if (homeSearchVC.tblEvents.indexPathsForVisibleRows?.contains(indexPath))!{
                                                homeSearchVC.tblEvents.reloadRows(at: [indexPath], with: .none)
                                            }
                                        }
                                    }
                                }
                            }
                            break
                        case .commentPost?:
                            if let index = homeSearchVC.arrHomeSearch.firstIndex(where: { $0[CId] as? Int == postId}) {
                                var postLikeInfo = homeSearchVC.arrHomeSearch[index]
                                if let postMetaInfo = postInfo![CJsonMeta] as? [String : Any]{
                                    postLikeInfo[CTotalComment] = postMetaInfo.valueForInt(key: CTotal)
                                    homeSearchVC.arrHomeSearch.remove(at: index)
                                    homeSearchVC.arrHomeSearch.insert(postLikeInfo, at: index)
                                    UIView.performWithoutAnimation {
                                        let indexPath = IndexPath(item: index, section: 0)
                                        if (homeSearchVC.tblEvents.indexPathsForVisibleRows?.contains(indexPath))!{
                                            homeSearchVC.tblEvents.reloadRows(at: [indexPath], with: .none)
                                        }
                                    }
                                }
                            }
                            break
                        case .deleteComment?:
                            if let index = homeSearchVC.arrHomeSearch.firstIndex(where: { $0[CId] as? Int == postId}) {
                                var postLikeInfo = homeSearchVC.arrHomeSearch[index]
                                postLikeInfo[CTotalComment] = (postLikeInfo.valueForInt(key: CTotalComment) ?? 0) - 1
                                homeSearchVC.arrHomeSearch.remove(at: index)
                                homeSearchVC.arrHomeSearch.insert(postLikeInfo, at: index)
                                UIView.performWithoutAnimation {
                                    let indexPath = IndexPath(item: index, section: 0)
                                    if (homeSearchVC.tblEvents.indexPathsForVisibleRows?.contains(indexPath))!{
                                        homeSearchVC.tblEvents.reloadRows(at: [indexPath], with: .none)
                                    }
                                }
                            }
                            break
                        case .friendRequest?:
                            if let index = homeSearchVC.arrHomeSearch.firstIndex(where: { $0[CUserId] as? Int == postId}) {
                                var userInfo = homeSearchVC.arrHomeSearch[index]
                                userInfo[CFriend_status] = postInfo!.valueForInt(key: CFriend_status)
                                homeSearchVC.arrHomeSearch.remove(at: index)
                                homeSearchVC.arrHomeSearch.insert(userInfo, at: index)
                                UIView.performWithoutAnimation {
                                    let indexPath = IndexPath(item: index, section: 0)
                                    if (homeSearchVC.tblEvents.indexPathsForVisibleRows?.contains(indexPath))!{
                                        homeSearchVC.tblEvents.reloadRows(at: [indexPath], with: .none)
                                    }
                                }
                                
                            }
                            break
                        default:
                            break
                        }
                    }
                }
                
                // Refresh post detail screen here....
                if viewController.isKind(of: ArticleDetailViewController.classForCoder()){
                    if let detailPost = viewController as? ArticleDetailViewController{
                        switch postAction {
                        case .likePost?:
//                            detailPost.articleInformation[CIs_Like] = postInfo?.valueForInt(key: CIs_Like)
//                            detailPost.articleInformation[CTotal_like] = postInfo?.valueForInt(key: CTotal_like)
//                            detailPost.setArticleDetails(detailPost.articleInformation)
                            
                            detailPost.articleInformation[CLikes] = postInfo?.valueForString(key: "likes")
                            detailPost.articleInformation[CIsLiked] = postInfo?.valueForString(key: CIsLiked)
                            detailPost.setArticleDetails(detailPost.articleInformation)
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
                            
                        break
                        default: break
                        }
                    }
                }
                
                if viewController.isKind(of: ImageDetailViewController.classForCoder()){
                    if let detailPost = viewController as? ImageDetailViewController{
                        switch postAction {
                        case .likePost?:
//                            detailPost.galleryInfo[CIs_Like] = postInfo?.valueForInt(key: CIs_Like)
//                            detailPost.galleryInfo[CTotal_like] = postInfo?.valueForInt(key: CTotal_like)
//                            detailPost.setGalleryDetailData(detailPost.galleryInfo)
                            
                            detailPost.galleryInfo[CLikes] = postInfo?.valueForString(key: "likes")
                            detailPost.galleryInfo[CIsLiked] = postInfo?.valueForString(key: CIsLiked)
                            detailPost.setGalleryDetailData(detailPost.galleryInfo)
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
                            
                            
                            break
                        default: break
                        }
                    }
                }
                
                if viewController.isKind(of: ChirpyDetailsViewController.classForCoder()){
                    if let detailPost = viewController as? ChirpyDetailsViewController{
                        switch postAction {
                        case .likePost?:
                            detailPost.chirpyInformation[CIs_Like] = postInfo?.valueForInt(key: CIs_Like)
                            detailPost.chirpyInformation[CTotal_like] = postInfo?.valueForInt(key: CTotal_like)
                            detailPost.setChirpyDetailData(detailPost.chirpyInformation)
                            break
                        default: break
                        }
                    }
                }
                
                if viewController.isKind(of: ChirpyImageDetailsViewController.classForCoder()){
                    if let detailPost = viewController as? ChirpyImageDetailsViewController{
                        switch postAction {
                        case .likePost?:
//                            detailPost.chirpyInformation[CIs_Like] = postInfo?.valueForInt(key: CIs_Like)
//                            detailPost.chirpyInformation[CTotal_like] = postInfo?.valueForInt(key: CTotal_like)
//                            detailPost.setChirpyDetailData(detailPost.chirpyInformation)
                            detailPost.chirpyInformation[CLikes] = postInfo?.valueForString(key: "likes")
//                                    postLikeInfo[CLikes] = postInfo?.valueForString(key: CLikes)
                            detailPost.chirpyInformation[CIsLiked] = postInfo?.valueForString(key: CIsLiked)
                            detailPost.setChirpyDetailData(detailPost.chirpyInformation)
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
                            
                            break
                        default: break
                        }
                    }
                }
                
                if viewController.isKind(of: ShoutsDetailViewController.classForCoder()){
                    if let detailPost = viewController as? ShoutsDetailViewController{
                        switch postAction {
                        case .likePost?:
//                            detailPost.shoutInformation[CIs_Like] = postInfo?.valueForInt(key: CIs_Like)
//                            detailPost.shoutInformation[CTotal_like] = postInfo?.valueForInt(key: CTotal_like)
                            detailPost.shoutInformation[CLikes] = postInfo?.valueForString(key: "likes")
//                                    postLikeInfo[CLikes] = postInfo?.valueForString(key: CLikes)
                            detailPost.shoutInformation[CIsLiked] = postInfo?.valueForString(key: CIsLiked)
                            detailPost.setShoutsDetailData(detailPost.shoutInformation)
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
                            break
                        default: break
                        }
                    }
                }
                
                if viewController.isKind(of: ForumDetailViewController.classForCoder()){
                    if let detailPost = viewController as? ForumDetailViewController{
                        switch postAction {
                        case .likePost?:
//                            detailPost.forumInformation[CIs_Like] = postInfo?.valueForInt(key: CIs_Like)
//                            detailPost.forumInformation[CTotal_like] = postInfo?.valueForInt(key: CTotal_like)
//                            detailPost.setForumDetailData(detailPost.forumInformation)
                            
                            detailPost.forumInformation[CLikes] = postInfo?.valueForString(key: "likes")
//                                    postLikeInfo[CLikes] = postInfo?.valueForString(key: CLikes)
                            detailPost.forumInformation[CIsLiked] = postInfo?.valueForString(key: CIsLiked)
                            detailPost.setForumDetailData(detailPost.forumInformation)
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
                            break
                        default: break
                        }
                    }
                }
                
                if viewController.isKind(of: EventDetailViewController.classForCoder()){
                    if let detailPost = viewController as? EventDetailViewController{
                        switch postAction {
                        case .likePost?:
//                            detailPost.eventInfo[CIs_Like] = postInfo?.valueForInt(key: CIs_Like)
//                            detailPost.eventInfo[CTotal_like] = postInfo?.valueForInt(key: CTotal_like)
//                            detailPost.setEventDetail(dict: detailPost.eventInfo)
                            
                            detailPost.eventInfo[CLikes] = postInfo?.valueForString(key: "likes")
                            detailPost.eventInfo[CIsLiked] = postInfo?.valueForString(key: CIsLiked)
                            detailPost.setEventDetail(dict: detailPost.eventInfo)
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
                            
                            break
                        default: break
                        }
                    }
                }
               
                if viewController.isKind(of: EventDetailImageViewController.classForCoder()){
                    if let detailPost = viewController as? EventDetailImageViewController{
                        switch postAction {
                        case .likePost?:
//                            detailPost.eventInfo[CIs_Like] = postInfo?.valueForInt(key: CIs_Like)
//                            detailPost.eventInfo[CTotal_like] = postInfo?.valueForInt(key: CTotal_like)
//                            detailPost.setEventDetail(dict: detailPost.eventInfo)
                            detailPost.eventInfo[CLikes] = postInfo?.valueForString(key: "likes")
                            detailPost.eventInfo[CIsLiked] = postInfo?.valueForString(key: CIsLiked)
                            detailPost.setEventDetail(dict: detailPost.eventInfo)
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
                            break
                        default: break
                        }
                    }
                }
                
                if viewController.isKind(of: PollDetailsViewController.classForCoder()){
                    if let detailPost = viewController as? PollDetailsViewController{
                        switch postAction {
                        case .likePost?:
//                            detailPost.pollInformation[CIs_Like] = postInfo?.valueForInt(key: CIs_Like)
//                            detailPost.pollInformation[CTotal_like] = postInfo?.valueForInt(key: CTotal_like)
//                            detailPost.setPollDetails(detailPost.pollInformation)
                            
                            detailPost.pollInformation[CLikes] = postInfo?.valueForString(key: "likes")
                            detailPost.pollInformation[CIsLiked] = postInfo?.valueForString(key: CIsLiked)
                            detailPost.setPollDetails(detailPost.pollInformation)
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
                            
                            break
                        default: break
                        }
                    }
                }
                
                if viewController.isKind(of: PostDeleteDetailViewController.classForCoder()){
                    if let detailPost = viewController as? PostDeleteDetailViewController{
                        switch postAction {
                        case .likePost?:
                            detailPost.postInformation[CIs_Like] = postInfo?.valueForInt(key: CIs_Like)
                            detailPost.postInformation[CTotal_like] = postInfo?.valueForInt(key: CTotal_like)
                            detailPost.setPostDetailData(detailPost.postInformation)
                            break
                        case .editPost?:
                            detailPost.setPostDetailData(postInfo)
                            break
                        default: break
                        }
                    }
                }
                
                if viewController.isKind(of: ArticleSharedDetailViewController.classForCoder()){
                    if let detailPost = viewController as? ArticleSharedDetailViewController{
                        switch postAction {
                        case .likePost?:
                            detailPost.articleInformation[CIs_Like] = postInfo?.valueForInt(key: CIs_Like)
                            detailPost.articleInformation[CTotal_like] = postInfo?.valueForInt(key: CTotal_like)
                            detailPost.setArticleDetails(detailPost.articleInformation)
                            break
                        case .editPost?:
                            detailPost.setArticleDetails(postInfo)
                            break
                        default: break
                        }
                    }
                }
                
                if viewController.isKind(of: ImageSharedDetailViewController.classForCoder()){
                    if let detailPost = viewController as? ImageSharedDetailViewController{
                        switch postAction {
                        case .likePost?:
                            detailPost.galleryInfo[CIs_Like] = postInfo?.valueForInt(key: CIs_Like)
                            detailPost.galleryInfo[CTotal_like] = postInfo?.valueForInt(key: CTotal_like)
                            detailPost.setGalleryDetailData(detailPost.galleryInfo)
                            break
                        case .editPost?:
                            detailPost.setGalleryDetailData(postInfo)
                            break
                        default: break
                        }
                    }
                }
                
                if viewController.isKind(of: ChirpySharedDetailsViewController.classForCoder()){
                    if let detailPost = viewController as? ChirpySharedDetailsViewController{
                        switch postAction {
                        case .likePost?:
                            detailPost.chirpyInformation[CIs_Like] = postInfo?.valueForInt(key: CIs_Like)
                            detailPost.chirpyInformation[CTotal_like] = postInfo?.valueForInt(key: CTotal_like)
                            detailPost.setChirpyDetailData(detailPost.chirpyInformation)
                            break
                        case .editPost?:
                            detailPost.setChirpyDetailData(postInfo)
                            break
                        default: break
                        }
                    }
                }
                
                if viewController.isKind(of: ChirpySharedImageDetailsViewController.classForCoder()){
                    if let detailPost = viewController as? ChirpySharedImageDetailsViewController{
                        switch postAction {
                        case .likePost?:
                            detailPost.chirpyInformation[CIs_Like] = postInfo?.valueForInt(key: CIs_Like)
                            detailPost.chirpyInformation[CTotal_like] = postInfo?.valueForInt(key: CTotal_like)
                            detailPost.setChirpyDetailData(detailPost.chirpyInformation)
                            break
                        case .editPost?:
                            detailPost.setChirpyDetailData(postInfo)
                            break
                        default: break
                        }
                    }
                }
                
                if viewController.isKind(of: ShoutsSharedDetailViewController.classForCoder()){
                    if let detailPost = viewController as? ShoutsSharedDetailViewController{
                        switch postAction {
                        case .likePost?:
                            detailPost.shoutInformation[CIs_Like] = postInfo?.valueForInt(key: CIs_Like)
                            detailPost.shoutInformation[CTotal_like] = postInfo?.valueForInt(key: CTotal_like)
                            detailPost.setShoutsDetailData(detailPost.shoutInformation)
                            break
                        case .editPost?:
                            detailPost.setShoutsDetailData(postInfo)
                            break
                        default: break
                        }
                    }
                }
                
                if viewController.isKind(of: ForumSharedDetailViewController.classForCoder()){
                    if let detailPost = viewController as? ForumSharedDetailViewController{
                        switch postAction {
                        case .likePost?:
                            detailPost.forumInformation[CIs_Like] = postInfo?.valueForInt(key: CIs_Like)
                            detailPost.forumInformation[CTotal_like] = postInfo?.valueForInt(key: CTotal_like)
                            detailPost.setForumDetailData(detailPost.forumInformation)
                            break
                        case .editPost?:
                            detailPost.setForumDetailData(postInfo)
                            break
                        default: break
                        }
                    }
                }
                
                if viewController.isKind(of: EventSharedDetailViewController.classForCoder()){
                    if let detailPost = viewController as? EventSharedDetailViewController{
                        switch postAction {
                        case .likePost?:
                            detailPost.eventInfo[CIs_Like] = postInfo?.valueForInt(key: CIs_Like)
                            detailPost.eventInfo[CTotal_like] = postInfo?.valueForInt(key: CTotal_like)
                            detailPost.setEventDetail(dict: detailPost.eventInfo)
                            break
                        case .editPost?:
                            detailPost.setEventDetail(dict: postInfo ?? [:])
                            break
                        default: break
                        }
                    }
                }
                
                if viewController.isKind(of: EventSharedDetailImageViewController.classForCoder()){
                    if let detailPost = viewController as? EventSharedDetailImageViewController{
                        switch postAction {
                        case .likePost?:
                            detailPost.eventInfo[CIs_Like] = postInfo?.valueForInt(key: CIs_Like)
                            detailPost.eventInfo[CTotal_like] = postInfo?.valueForInt(key: CTotal_like)
                            detailPost.setEventDetail(dict: detailPost.eventInfo)
                            break
                        case .editPost?:
                            detailPost.setEventDetail(dict: postInfo ?? [:])
                            break
                        default: break
                        }
                    }
                }
                
                if viewController.isKind(of: PollSharedDetailsViewController.classForCoder()){
                    if let detailPost = viewController as? PollSharedDetailsViewController{
                        switch postAction {
                        case .likePost?:
                            detailPost.pollInformation[CIs_Like] = postInfo?.valueForInt(key: CIs_Like)
                            detailPost.pollInformation[CTotal_like] = postInfo?.valueForInt(key: CTotal_like)
                            detailPost.setPollDetails(detailPost.pollInformation)
                            break
                        case .editPost?:
                            detailPost.setPollDetails(postInfo)
                            break
                        default: break
                        }
                    }
                }
                
                // UPDATE POST DETAILS SCREEN FOR Like..
                if postAction == .likePost{
                    //Image details screen
                    if viewController.isKind(of: ImageDetailViewController.classForCoder()){
                        if let imageVC = viewController as? ImageDetailViewController{
                            imageVC.galleryInfo[CIs_Like] = postInfo?.valueForInt(key: CIs_Like)
                            imageVC.galleryInfo[CTotal_like] = postInfo?.valueForInt(key: CTotal_like)
                        }
                    }
                }
                    
                // UPDATE POST DETAILS SCREEN FOR COMMENT..
                if postAction == .commentPost{
                    let cmtCount = postInfo?["comments"] as? String
                    if let arrComm = postInfo![CJsonData] as? [[String : Any]]{
                        if let metaInfo = postInfo![CJsonMeta] as? [String : Any]{
                            
                            //Event details screen
                            if viewController.isKind(of: EventDetailViewController.classForCoder()){
                                if let eventVC = viewController as? EventDetailViewController{
                                    eventVC.btnComment.setTitle("\(metaInfo.valueForInt(key: CTotal) ?? 0)", for: .normal)
                                }
                            }
                            
                            //Event Image details screen
                            if viewController.isKind(of: EventDetailImageViewController.classForCoder()){
                                if let eventVC = viewController as? EventDetailImageViewController{
                                    eventVC.btnComment.setTitle("\(metaInfo.valueForInt(key: CTotal) ?? 0)", for: .normal)
                                }
                            }
                            
                            //chirpy details screen
                            if viewController.isKind(of: ChirpyDetailsViewController.classForCoder()){
                                if let chirpVC = viewController as? ChirpyDetailsViewController{
                                    chirpVC.updateChirpyCommentSection(arrComm, metaInfo.valueForInt(key: CTotal)!)
                                }
                            }
                            
                            //chirpy Image details screen
                            if viewController.isKind(of: ChirpyImageDetailsViewController.classForCoder()){
                                if let chirpVC = viewController as? ChirpyImageDetailsViewController{
                                    chirpVC.updateChirpyCommentSection(arrComm, metaInfo.valueForInt(key: CTotal)!)
                                }
                            }
                            
                            //shout details screen
                            if viewController.isKind(of: ShoutsDetailViewController.classForCoder()){
                                if let shoutVC = viewController as? ShoutsDetailViewController{
//                                    shoutVC.updateShoutCommentSection(arrComm, metaInfo.valueForInt(key: CTotal)!)
//                                    shoutVC.updateShoutCommentSection(arrComm)
                                }
                            }
                            
                            //Forum details screen
                            if viewController.isKind(of: ForumDetailViewController.classForCoder()){
                                if let forumVC = viewController as? ForumDetailViewController{
                                    forumVC.updateForumCommentSection(arrComm, metaInfo.valueForInt(key: CTotal)!)
                                }
                            }
                            
                            //Image details screen
                            if viewController.isKind(of: ImageDetailViewController.classForCoder()){
                                if let imageVC = viewController as? ImageDetailViewController{
                                    imageVC.updateGalleryCommentSection(arrComm, metaInfo.valueForInt(key: CTotal)!)
                                }
                            }
                            
                        }
                    }
                }
                
                // Refresh My profile screen here....
                if viewController.isKind(of: MyProfileViewController.classForCoder()){
                    if let myProfileVC = viewController as? MyProfileViewController {
                        
                        switch postAction {
                        case .addPost?:
                            myProfileVC.pageNumber = 1
                            myProfileVC.getPostListFromServer()
                            myProfileVC.tblUser.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                        case .editPost?:
                            if let index = myProfileVC.arrPostList.firstIndex(where: { $0[CId] as? Int == postInfo!.valueForInt(key: CId)}) {
                                myProfileVC.arrPostList.remove(at: index)
                                myProfileVC.arrPostList.insert(postInfo!, at: index)
                                UIView.performWithoutAnimation {
                                    let indexPath = IndexPath(item: index, section: 1)
                                    if (myProfileVC.tblUser.indexPathsForVisibleRows?.contains(indexPath))!{
                                        myProfileVC.tblUser.reloadRows(at: [indexPath], with: .none)
                                    }
                                }
                            }
                            break
                        case .deletePost?:
                            if let index = myProfileVC.arrPostList.firstIndex(where: { $0[CId] as? Int == postId}) {
                                myProfileVC.arrPostList.remove(at: index)
                                UIView.performWithoutAnimation {
                                    myProfileVC.tblUser.reloadData()
                                }
                            }
                            let arrPosts = myProfileVC.arrPostList
                            for (index,obj) in arrPosts.enumerated(){
                                if obj[COriginalPostId] as? Int == postId{
                                    var postPollInfo = obj
                                    postPollInfo[CIsPostDeleted] = 1
                                    myProfileVC.arrPostList.remove(at: index)
                                    myProfileVC.arrPostList.insert(postPollInfo, at: index)
                                    UIView.performWithoutAnimation {
                                        DispatchQueue.main.async {
                                            let indexPath = IndexPath(item: index, section: 1)
                                            if (myProfileVC.tblUser.indexPathsForVisibleRows?.contains(indexPath))!{
                                                myProfileVC.tblUser.reloadRows(at: [indexPath], with: .none)
                                            }
                                        }
                                    }
                                }
                            }
                            break
                        case .likePost?:
                            
//                            if let index = myProfileVC.arrPostList.firstIndex(where: { $0["post_id"] as? String == postId?.toString}) {
//                                var postLikeInfo = myProfileVC.arrPostList[index]
//                                postLikeInfo[CIs_Like] = postInfo?.valueForInt(key: CIs_Like)
//                                postLikeInfo[CTotal_like] = postInfo?.valueForInt(key: CTotal_like)
//                                myProfileVC.arrPostList.remove(at: index)
//                                myProfileVC.arrPostList.insert(postLikeInfo, at: index)
//                                UIView.performWithoutAnimation {
//                                    let indexPath = IndexPath(item: index, section: 1)
//                                    if (myProfileVC.tblUser.indexPathsForVisibleRows?.contains(indexPath))!{
//                                        myProfileVC.tblUser.reloadRows(at: [indexPath], with: .none)
//                                    }
//                                }
//                            }
                            
                            if let index = myProfileVC.arrPostList.firstIndex(where: { $0["post_id"] as? String == postId?.toString}) {
                                var postLikeInfo = myProfileVC.arrPostList[index]
                                postLikeInfo[CLikes] = postInfo?.valueForString(key: "likes")
                                postLikeInfo[CIsLiked] = postInfo?.valueForString(key: CIsLiked)
                                myProfileVC.arrPostList.remove(at: index)
                                myProfileVC.arrPostList.insert(postLikeInfo, at: index)
                                UIView.performWithoutAnimation {
                                    let indexPath = IndexPath(item: index, section: 1)
                                    if (myProfileVC.tblUser.indexPathsForVisibleRows?.contains(indexPath))!{
                                        myProfileVC.tblUser.reloadRows(at: [indexPath], with: .none)
                                    }
                                }
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadMyprofile"), object: nil)
                            }
                            break
                        case .interestPost?:
                            if let index = myProfileVC.arrPostList.firstIndex(where: { $0[CId] as? Int == postId}) {
                                var postLikeInfo = myProfileVC.arrPostList[index]
                                
                                postLikeInfo[CIsInterested] = postInfo?.valueForInt(key: CIsInterested)
                                postLikeInfo[CTotalInterestedUsers] = postInfo?.valueForInt(key: CTotalInterestedUsers)
                                postLikeInfo[CTotalNotInterestedUsers] = postInfo?.valueForInt(key: CTotalNotInterestedUsers)
                                postLikeInfo[CTotalMaybeInterestedUsers] = postInfo?.valueForInt(key: CTotalMaybeInterestedUsers)
                                
                                myProfileVC.arrPostList.remove(at: index)
                                myProfileVC.arrPostList.insert(postLikeInfo, at: index)
                                UIView.performWithoutAnimation {
                                    let indexPath = IndexPath(item: index, section: 1)
                                    if (myProfileVC.tblUser.indexPathsForVisibleRows?.contains(indexPath))!{
                                        myProfileVC.tblUser.reloadRows(at: [indexPath], with: .none)
                                    }
                                }
                            }
                            let arrPosts = myProfileVC.arrPostList
                            for (index,obj) in arrPosts.enumerated(){
                                if obj[COriginalPostId] as? Int == postId{
                                    var postPollInfo = obj
                                    postPollInfo[CIsInterested] = postInfo?.valueForInt(key: CIsInterested)
                                    postPollInfo[CTotalInterestedUsers] = postInfo?.valueForInt(key: CTotalInterestedUsers)
                                    postPollInfo[CTotalNotInterestedUsers] = postInfo?.valueForInt(key: CTotalNotInterestedUsers)
                                    postPollInfo[CTotalMaybeInterestedUsers] = postInfo?.valueForInt(key: CTotalMaybeInterestedUsers)
                                    myProfileVC.arrPostList.remove(at: index)
                                    myProfileVC.arrPostList.insert(postPollInfo, at: index)
                                    UIView.performWithoutAnimation {
                                        DispatchQueue.main.async {
                                            let indexPath = IndexPath(item: index, section: 1)
                                            if (myProfileVC.tblUser.indexPathsForVisibleRows?.contains(indexPath))!{
                                                myProfileVC.tblUser.reloadRows(at: [indexPath], with: .none)
                                            }
                                        }
                                    }
                                }
                            }
                            break
                        case .commentPost?:
                            if let index = myProfileVC.arrPostList.firstIndex(where: { $0["post_id"] as? String == postId?.toString}) {
                                var postLikeInfo = myProfileVC.arrPostList[index]
                                postLikeInfo["comments"] = postInfo?.valueForString(key: "comments")
//                                if let postMetaInfo = postInfo![CJsonMeta] as? [String : Any]{
//                                    postLikeInfo[CTotalComment] = postMetaInfo.valueForInt(key: CTotal)
                                    myProfileVC.arrPostList.remove(at: index)
                                    myProfileVC.arrPostList.insert(postLikeInfo, at: index)
                                    UIView.performWithoutAnimation {
                                        let indexPath = IndexPath(item: index, section: 1)
                                        if (myProfileVC.tblUser.indexPathsForVisibleRows?.contains(indexPath))!{
                                            myProfileVC.tblUser.reloadRows(at: [indexPath], with: .none)
//                                        }
                                    }
                                }
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadMyprofile"), object: nil)
                                
                            }
                            break
                        case .deleteComment?:
                            if let index = myProfileVC.arrPostList.firstIndex(where: { $0["post_id"] as? String == postId?.toString}) {
                                var postLikeInfo = myProfileVC.arrPostList[index]
                                
                                let commentDel = (postLikeInfo.valueForString(key: "comments") )
                                let commentAfDele = (commentDel.toInt) ?? 0
                                let commet = commentAfDele - 1
                                postLikeInfo["comments"] = commet.toString
                                
                                
//                                postLikeInfo[CTotalComment] = (postLikeInfo.valueForInt(key: CTotalComment) ?? 0) - 1
                                myProfileVC.arrPostList.remove(at: index)
                                myProfileVC.arrPostList.insert(postLikeInfo, at: index)
                                
                                
                                
                                UIView.performWithoutAnimation {
                                    let indexPath = IndexPath(item: index, section: 1)
                                    if (myProfileVC.tblUser.indexPathsForVisibleRows?.contains(indexPath))!{
                                        myProfileVC.tblUser.reloadRows(at: [indexPath], with: .none)
                                    }
                                }
                                
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadMyprofile"), object: nil)
                            }
                            break
                        default:
                            break
                        }
                    }
                }
                
                // Refresh Other profile screen here....
                if viewController.isKind(of: OtherUserProfileViewController.classForCoder()){
                    // Refresh My profile screen here....
                    if let otherProfileVC = viewController as? OtherUserProfileViewController {
                        
                        switch postAction {
                        case .addPost?:
                            otherProfileVC.pageNumber = 1
                            otherProfileVC.getPostListFromServer()
                            otherProfileVC.tblUser.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                        case .editPost?:
                            if let index = otherProfileVC.arrPostList.firstIndex(where: { $0?.valueForInt(key: CId) == postInfo!.valueForInt(key: CId)}) {
                                otherProfileVC.arrPostList.remove(at: index)
                                otherProfileVC.arrPostList.insert(postInfo!, at: index)
                                UIView.performWithoutAnimation {
                                    let indexPath = IndexPath(item: index, section: 1)
                                    if (otherProfileVC.tblUser.indexPathsForVisibleRows?.contains(indexPath))!{
                                        otherProfileVC.tblUser.reloadRows(at: [indexPath], with: .none)
                                    }
                                }
                            }
                            break
                        case .deletePost?, .reportPost?:
                            
                            if let index = otherProfileVC.arrPostList.firstIndex(where: { $0?.valueForInt(key: CId) == postId}) {
                                otherProfileVC.arrPostList.remove(at: index)
                                UIView.performWithoutAnimation {
                                    otherProfileVC.tblUser.reloadData()
                                }
                            }
                            break
                        case .likePost?:
                            if let index = otherProfileVC.arrPostList.firstIndex(where: { $0?["post_id"] as? String == postId?.toString}) {
//                            if let index = otherProfileVC.arrPostList.firstIndex(where: { $0?.valueForInt(key: CId) == postId}) {
                                var postLikeInfo = otherProfileVC.arrPostList[index]
                                postLikeInfo?[CLikes] = postInfo?.valueForString(key: "likes")
                                postLikeInfo?[CIsLiked] = postInfo?.valueForString(key: CIsLiked)
                                
//                                postLikeInfo?[CIs_Like] = postInfo?.valueForInt(key: CIs_Like)
//                                postLikeInfo?[CTotal_like] = postInfo?.valueForInt(key: CTotal_like)
                                otherProfileVC.arrPostList.remove(at: index)
                                otherProfileVC.arrPostList.insert(postLikeInfo, at: index)
                                UIView.performWithoutAnimation {
                                    let indexPath = IndexPath(item: index, section: 1)
                                    if (otherProfileVC.tblUser.indexPathsForVisibleRows?.contains(indexPath))!{
                                        otherProfileVC.tblUser.reloadRows(at: [indexPath], with: .none)
                                    }
                                }
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadOtherProfile"), object: nil)
                            }
                            break
                        case .interestPost?:
                            if let index = otherProfileVC.arrPostList.firstIndex(where: { $0?.valueForInt(key: CId) == postId}) {
                                var postLikeInfo = otherProfileVC.arrPostList[index]
                                
                                postLikeInfo?[CIsInterested] = postInfo?.valueForInt(key: CIsInterested)
                                postLikeInfo?[CTotalInterestedUsers] = postInfo?.valueForInt(key: CTotalInterestedUsers)
                                postLikeInfo?[CTotalNotInterestedUsers] = postInfo?.valueForInt(key: CTotalNotInterestedUsers)
                                postLikeInfo?[CTotalMaybeInterestedUsers] = postInfo?.valueForInt(key: CTotalMaybeInterestedUsers)
                                
                                otherProfileVC.arrPostList.remove(at: index)
                                otherProfileVC.arrPostList.insert(postLikeInfo, at: index)
                                UIView.performWithoutAnimation {
                                    let indexPath = IndexPath(item: index, section: 1)
                                    if (otherProfileVC.tblUser.indexPathsForVisibleRows?.contains(indexPath))!{
                                        otherProfileVC.tblUser.reloadRows(at: [indexPath], with: .none)
                                    }
                                }
                            }
                            let arrPosts = otherProfileVC.arrPostList
                            for (index,obj) in arrPosts.enumerated(){
                                if obj?[COriginalPostId] as? Int == postId{
                                    var postPollInfo = obj
                                    postPollInfo?[CIsInterested] = postInfo?.valueForInt(key: CIsInterested)
                                    postPollInfo?[CTotalInterestedUsers] = postInfo?.valueForInt(key: CTotalInterestedUsers)
                                    postPollInfo?[CTotalNotInterestedUsers] = postInfo?.valueForInt(key: CTotalNotInterestedUsers)
                                    postPollInfo?[CTotalMaybeInterestedUsers] = postInfo?.valueForInt(key: CTotalMaybeInterestedUsers)
                                    otherProfileVC.arrPostList.remove(at: index)
                                    otherProfileVC.arrPostList.insert(postPollInfo, at: index)
                                    UIView.performWithoutAnimation {
                                        DispatchQueue.main.async {
                                            let indexPath = IndexPath(item: index, section: 1)
                                            if (otherProfileVC.tblUser.indexPathsForVisibleRows?.contains(indexPath))!{
                                                otherProfileVC.tblUser.reloadRows(at: [indexPath], with: .none)
                                            }
                                        }
                                    }
                                }
                            }
                            break
                        case .commentPost?:
                            if let index = otherProfileVC.arrPostList.firstIndex(where:{ $0?["post_id"] as? String == postId?.toString}) {
                                var postLikeInfo = otherProfileVC.arrPostList[index]
//                                if let postMetaInfo = postInfo![CJsonMeta] as? [String : Any]{
//                                    postLikeInfo?[CTotalComment] = postMetaInfo.valueForInt(key: CTotal)
                                    postLikeInfo?["comments"] = postInfo?.valueForString(key: "comments")
                                    otherProfileVC.arrPostList.remove(at: index)
                                    otherProfileVC.arrPostList.insert(postLikeInfo, at: index)
                                    UIView.performWithoutAnimation {
                                        let indexPath = IndexPath(item: index, section: 1)
                                        if (otherProfileVC.tblUser.indexPathsForVisibleRows?.contains(indexPath))!{
                                            otherProfileVC.tblUser.reloadRows(at: [indexPath], with: .none)
                                        }
                                    }
//                                }
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadOtherProfile"), object: nil)
                            }
                            break
                        case .deleteComment?:
                            if let index = otherProfileVC.arrPostList.firstIndex(where:{ $0?["post_id"] as? String == postId?.toString}) {
                                var postLikeInfo = otherProfileVC.arrPostList[index]
//                                let totalComment = (postLikeInfo?.valueForInt(key: CTotalComment) ?? 0) - 1
//                                postLikeInfo?[CTotalComment] = totalComment
                                
                                
                                let commentDel = (postLikeInfo?.valueForString(key: "comments") )
                                let commentAfDele = (commentDel?.toInt) ?? 0
                                let commet = commentAfDele - 1
                                postLikeInfo?["comments"] = commet.toString
                                
                                otherProfileVC.arrPostList.remove(at: index)
                                otherProfileVC.arrPostList.insert(postLikeInfo!, at: index)
                                
                                UIView.performWithoutAnimation {
                                let indexPath = IndexPath(item: index, section: 1)
                                if (otherProfileVC.tblUser.indexPathsForVisibleRows?.contains(indexPath))!{
                                        otherProfileVC.tblUser.reloadRows(at: [indexPath], with: .none)
                                    }
                                }
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadOtherProfile"), object: nil)
                            }
                            break
                        default:
                            break
                        }
                    }
                }
                // Refresh Fav Web Site....
                if viewController.isKind(of: FavWebSideViewController.classForCoder()){
                    if let favWebSite = viewController as? FavWebSideViewController {
                        if let index = favWebSite.arrFavWebSite.firstIndex(where: { $0.valueForInt(key: CId) == postId}) {
                            favWebSite.arrFavWebSite.remove(at: index)
                            UIView.performWithoutAnimation {
                                favWebSite.tblFavWebSite.reloadData()
                            }
                        }
                    }
                }
                
                // Refresh Home search screen here....
                if viewController.isKind(of: NotificationViewController.classForCoder()){
                    if let notification = viewController as? NotificationViewController{
                        switch postAction {
                        case .friendRequest?:
                            DispatchQueue.main.async {
                                notification.arrNotiificationList.removeAll()
                                notification.tblVNotification.reloadData()
                                notification.pullToRefresh()
                            }
                            break;
                        default:break
                        }
                    }
                }
            }
        }
    }
    
    func refreshPollPostRelatedScreens(_ postInfo : [String : Any]?,_ postId : Int?, _ pollAnsewrID:Int?, optionData:[String:Any]?, _ view : UIViewController?) {
        guard let viewVC = view else {
            return
        }
        guard let arrViewControllers = viewVC.navigationController?.viewControllers else{
            return
        }
        
        for viewController in arrViewControllers{
           
            if viewController.isKind(of: HomeViewController.classForCoder()){
                
                guard let homeVC = viewController as? HomeViewController else{
                    continue
                }
                if let index = homeVC.arrPostList.firstIndex(where: { $0["post_id"] as? String == postId?.toString}) {
                    var postPollInfo = homeVC.arrPostList[index]
//                    postPollInfo[CPollData] = optionData
//                    postPollInfo[CUserVotedPoll] = pollAnsewrID
//                    postPollInfo[CIsUserVoted] = 1
//                    postPollInfo["is_selected"] =
                    
                    
                    let resultKey = optionData?["results"] as? [String:String]
                    print("this key\(resultKey)")
//                    resultKey.allKeys(forValue: resultKey?.values)
                    
                

                    postPollInfo["is_selected"] =
                    homeVC.arrPostList.remove(at: index)
                    homeVC.arrPostList.insert(postPollInfo, at: index)
                    UIView.performWithoutAnimation {
                        DispatchQueue.main.async {
                            let indexPath = IndexPath(item: index, section: 1)
                            if (homeVC.tblEvents.indexPathsForVisibleRows?.contains(indexPath))!{
                                homeVC.tblEvents.reloadRows(at: [indexPath], with: .none)
                            }
                        }
                    }
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "pollloadder"), object: nil)
                }
//                let arrPosts = homeVC.arrPostList
//                for (index,obj) in arrPosts.enumerated(){
//                    if obj["post_id"] as? String == postId?.toString{
//                        var postPollInfo = obj
//
////                        print("this is calling first tile")
////                        postPollInfo[CPollData] = optionData
////                        postPollInfo[CUserVotedPoll] = pollAnsewrID
//                        postPollInfo["is_selected"] = "Yes"
////                        postPollInfo[CIsUserVoted] = 1
//                        homeVC.arrPostList.remove(at: index)
//                        homeVC.arrPostList.insert(postPollInfo, at: index)
//                        UIView.performWithoutAnimation {
//                            DispatchQueue.main.async {
//                                let indexPath = IndexPath(item: index, section: 1)
//
//                                if (homeVC.tblEvents.indexPathsForVisibleRows?.contains(indexPath))!{
//                                    homeVC.tblEvents.reloadRows(at: [indexPath], with: .none)
//                                }
//                            }
//                        }
//                    }
//                }
            }
            
            if viewController.isKind(of: MyProfileViewController.classForCoder()){
                
                guard let myProfile = viewController as? MyProfileViewController else{
                    continue
                }
                if let index = myProfile.arrPostList.firstIndex(where: { $0[CId] as? Int == postId}) {
                    var postPollInfo = myProfile.arrPostList[index]
                    postPollInfo[CPollData] = optionData
                    postPollInfo[CUserVotedPoll] = pollAnsewrID
                    postPollInfo[CIsUserVoted] = 1
                    myProfile.arrPostList.remove(at: index)
                    myProfile.arrPostList.insert(postPollInfo, at: index)
                    UIView.performWithoutAnimation {
                        DispatchQueue.main.async {
                            let indexPath = IndexPath(item: index, section: 1)
                            if (myProfile.tblUser.indexPathsForVisibleRows?.contains(indexPath))!{
                                myProfile.tblUser.reloadRows(at: [indexPath], with: .none)
                            }
                        }
                    }
                }
                let arrPosts = myProfile.arrPostList
                for (index,obj) in arrPosts.enumerated(){
                    if obj[COriginalPostId] as? Int == postId{
                        var postPollInfo = obj
                        postPollInfo[CPollData] = optionData
                        postPollInfo[CUserVotedPoll] = pollAnsewrID
                        postPollInfo[CIsUserVoted] = 1
                        myProfile.arrPostList.remove(at: index)
                        myProfile.arrPostList.insert(postPollInfo, at: index)
                        UIView.performWithoutAnimation {
                            DispatchQueue.main.async {
                                let indexPath = IndexPath(item: index, section: 1)
                                if (myProfile.tblUser.indexPathsForVisibleRows?.contains(indexPath))!{
                                    myProfile.tblUser.reloadRows(at: [indexPath], with: .none)
                                }
                            }
                        }
                    }
                }
            }
            if viewController.isKind(of: HomeSearchViewController.classForCoder()){
                guard let homeSearchVC = viewController as? HomeSearchViewController else{
                    continue
                }
                if let index = homeSearchVC.arrHomeSearch.firstIndex(where: { $0[CId] as? Int == postId}) {
                    var postPollInfo = homeSearchVC.arrHomeSearch[index]
                    postPollInfo[CPollData] = optionData
                    postPollInfo[CUserVotedPoll] = pollAnsewrID
                    postPollInfo[CIsUserVoted] = 1
                    homeSearchVC.arrHomeSearch.remove(at: index)
                    homeSearchVC.arrHomeSearch.insert(postPollInfo, at: index)
                    UIView.performWithoutAnimation {
                        DispatchQueue.main.async {
                            let indexPath = IndexPath(item: index, section: 0)
                            if (homeSearchVC.tblEvents.indexPathsForVisibleRows?.contains(indexPath))!{
                                homeSearchVC.tblEvents.reloadRows(at: [indexPath], with: .none)
                            }
                        }
                    }
                }
                let arrPosts = homeSearchVC.arrHomeSearch
                for (index,obj) in arrPosts.enumerated(){
                    if obj[COriginalPostId] as? Int == postId{
                        var postPollInfo = obj
                        postPollInfo[CPollData] = optionData
                        postPollInfo[CUserVotedPoll] = pollAnsewrID
                        postPollInfo[CIsUserVoted] = 1
                        homeSearchVC.arrHomeSearch.remove(at: index)
                        homeSearchVC.arrHomeSearch.insert(postPollInfo, at: index)
                        UIView.performWithoutAnimation {
                            DispatchQueue.main.async {
                                let indexPath = IndexPath(item: index, section: 1)
                                if (homeSearchVC.tblEvents.indexPathsForVisibleRows?.contains(indexPath))!{
                                    homeSearchVC.tblEvents.reloadRows(at: [indexPath], with: .none)
                                }
                            }
                        }
                    }
                }
            }
            
            if viewController.isKind(of: OtherUserProfileViewController.classForCoder()){
                guard let otherProfileVC = viewController as? OtherUserProfileViewController else{
                    continue
                }
                if let index = otherProfileVC.arrPostList.firstIndex(where: { $0?[CId] as? Int == postId}) {
                    var postPollInfo = otherProfileVC.arrPostList[index]
                    postPollInfo?[CPollData] = optionData
                    postPollInfo?[CUserVotedPoll] = pollAnsewrID
                    postPollInfo?[CIsUserVoted] = 1
                    otherProfileVC.arrPostList.remove(at: index)
                    otherProfileVC.arrPostList.insert(postPollInfo, at: index)
                    UIView.performWithoutAnimation {
                        DispatchQueue.main.async {
                            let indexPath = IndexPath(item: index, section: 1)
                            if (otherProfileVC.tblUser.indexPathsForVisibleRows?.contains(indexPath))!{
                                otherProfileVC.tblUser.reloadRows(at: [indexPath], with: .none)
                            }
                        }
                    }
                }
                let arrPosts = otherProfileVC.arrPostList
                for (index,obj) in arrPosts.enumerated(){
                    if obj?[COriginalPostId] as? Int == postId{
                        var postPollInfo = obj
                        postPollInfo?[CPollData] = optionData
                        postPollInfo?[CUserVotedPoll] = pollAnsewrID
                        postPollInfo?[CIsUserVoted] = 1
                        otherProfileVC.arrPostList.remove(at: index)
                        otherProfileVC.arrPostList.insert(postPollInfo, at: index)
                        UIView.performWithoutAnimation {
                            DispatchQueue.main.async {
                                let indexPath = IndexPath(item: index, section: 1)
                                if (otherProfileVC.tblUser.indexPathsForVisibleRows?.contains(indexPath))!{
                                    otherProfileVC.tblUser.reloadRows(at: [indexPath], with: .none)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

//MARK:- ------ Category related Functions..
extension MIGeneralsAPI {
    func fetchCategoryFromLocal() -> [[String : Any]] {
        var arrCategory = [[String : Any]]()
        
         
        if arrCategory.count < 1 {
            // If not intereste selected by user then show all interest.....
            let arrCategoryTemp = TblInterest.fetchAllObjects()
            for interest in arrCategoryTemp!{
                var dicData = [String : Any]()
                let interestInfo = interest as? TblInterest
//                dicData[CId] = interestInfo?.id
//                dicData[CType] = interestInfo?.type
                dicData[CName] = interestInfo?.name
                arrCategory.append(dicData)
            }
        }
        if !arrCategory.isEmpty{
            let sortedResults =  arrCategory.sorted { (obj1, obj2) -> Bool in
                (obj1[CName] as! String).localizedCaseInsensitiveCompare(obj2[CName] as! String) == .orderedAscending
            }
            return sortedResults
        }
        return arrCategory
    }
    
    
    func fetchCategoryFromLocalArticle() -> [[String : Any]] {
        var arrCategory = [[String : Any]]()
        if arrCategory.count < 1 {
            // If not intereste selected by user then show all interest.....
            let arrCategoryTemp = TblArticle.fetchAllObjects()
            for interest in arrCategoryTemp!{
                var dicData = [String : Any]()
                let interestInfo = interest as? TblArticle
//                dicData[CId] = interestInfo?.id
//                dicData[CType] = interestInfo?.type
//                dicData["category_id"] = interestInfo?.category_id
                dicData[CCategoryName] = interestInfo?.category_name
//                dicData["lang_name"] = interestInfo?.lang_name
                arrCategory.append(dicData)
            }
        }
        if !arrCategory.isEmpty{
            let sortedResults =  arrCategory.sorted { (obj1, obj2) -> Bool in
                (obj1[CCategoryName] as! String).localizedCaseInsensitiveCompare(obj2[CCategoryName] as! String) == .orderedAscending
            }
            return sortedResults
        }
        return arrCategory
    }
    
    
    func fetchproductCategoryFromLocalArticle() -> [[String : Any]] {
        var arrCategory = [[String : Any]]()
        if arrCategory.count < 1 {
            // If not intereste selected by user then show all interest.....
            let arrCategoryTemp = TblProductCategory.fetchAllObjects()
            for interest in arrCategoryTemp!{
                var dicData = [String : Any]()
                let interestInfo = interest as? TblProductCategory
                dicData["product_category_type"] = interestInfo?.product_category_type
                arrCategory.append(dicData)
            }
        }
        if !arrCategory.isEmpty{
            let sortedResults =  arrCategory.sorted { (obj1, obj2) -> Bool in
                (obj1["product_category_type"] as! String).localizedCaseInsensitiveCompare(obj2["product_category_type"] as! String) == .orderedAscending
            }
            return sortedResults
        }
        return arrCategory
    }
    
    
    
    
    
    func fetchCategoryFromLocalChiripy() -> [[String : Any]] {
        var arrCategory = [[String : Any]]()
        if arrCategory.count < 1 {
            // If not intereste selected by user then show all interest.....
            let arrCategoryTemp = TblChirpy.fetchAllObjects()
            for interest in arrCategoryTemp!{
                var dicData = [String : Any]()
                let interestInfo = interest as? TblChirpy
//                dicData[CId] = interestInfo?.id
//                dicData[CType] = interestInfo?.type
//                dicData["category_id"] = interestInfo?.category_id
                dicData[CCategoryName] = interestInfo?.category_name
//                dicData["lang_name"] = interestInfo?.lang_name
                arrCategory.append(dicData)
            }
        }
        if !arrCategory.isEmpty{
            let sortedResults =  arrCategory.sorted { (obj1, obj2) -> Bool in
                (obj1[CCategoryName] as! String).localizedCaseInsensitiveCompare(obj2[CCategoryName] as! String) == .orderedAscending
            }
            return sortedResults
        }
        return arrCategory
    }
    
    func fetchCategoryFromLocalEvent() -> [[String : Any]] {
        var arrCategory = [[String : Any]]()
        if arrCategory.count < 1 {
            // If not intereste selected by user then show all interest.....
            let arrCategoryTemp = TblEvent.fetchAllObjects()
            for interest in arrCategoryTemp!{
                var dicData = [String : Any]()
                let interestInfo = interest as? TblEvent
//                dicData[CId] = interestInfo?.id
//                dicData[CType] = interestInfo?.type
//                dicData["category_id"] = interestInfo?.category_id
                dicData[CCategoryName] = interestInfo?.category_name
//                dicData["lang_name"] = interestInfo?.lang_name
                arrCategory.append(dicData)
            }
        }
        if !arrCategory.isEmpty{
            let sortedResults =  arrCategory.sorted { (obj1, obj2) -> Bool in
                (obj1[CCategoryName] as! String).localizedCaseInsensitiveCompare(obj2[CCategoryName] as! String) == .orderedAscending
            }
            return sortedResults
        }
        return arrCategory
    }
    
    func fetchCategoryFromLocalForum() -> [[String : Any]] {
        var arrCategory = [[String : Any]]()
        if arrCategory.count < 1 {
            // If not intereste selected by user then show all interest.....
            let arrCategoryTemp = TblForum.fetchAllObjects()
            for interest in arrCategoryTemp!{
                var dicData = [String : Any]()
                let interestInfo = interest as? TblForum
//                dicData[CId] = interestInfo?.id
//                dicData[CType] = interestInfo?.type
//                dicData["category_id"] = interestInfo?.category_id
                dicData[CCategoryName] = interestInfo?.category_name
//                dicData["lang_name"] = interestInfo?.lang_name
                arrCategory.append(dicData)
            }
        }
        if !arrCategory.isEmpty{
            let sortedResults =  arrCategory.sorted { (obj1, obj2) -> Bool in
                (obj1[CCategoryName] as! String).localizedCaseInsensitiveCompare(obj2[CCategoryName] as! String) == .orderedAscending
            }
            return sortedResults
        }
        return arrCategory
    }
    
    func fetchCategoryFromLocalGallery() -> [[String : Any]] {
        var arrCategory = [[String : Any]]()
        if arrCategory.count < 1 {
            // If not intereste selected by user then show all interest.....
            let arrCategoryTemp = TblGallery.fetchAllObjects()
            for interest in arrCategoryTemp!{
                var dicData = [String : Any]()
                let interestInfo = interest as? TblGallery
//                dicData[CId] = interestInfo?.id
//                dicData[CType] = interestInfo?.type
//                dicData["category_id"] = interestInfo?.category_id
                dicData[CCategoryName] = interestInfo?.category_name
//                dicData["lang_name"] = interestInfo?.lang_name
                arrCategory.append(dicData)
            }
        }
        if !arrCategory.isEmpty{
            let sortedResults =  arrCategory.sorted { (obj1, obj2) -> Bool in
                (obj1[CCategoryName] as! String).localizedCaseInsensitiveCompare(obj2[CCategoryName] as! String) == .orderedAscending
            }
            return sortedResults
        }
        return arrCategory
    }
    
    
    func fetchCategoryFromLocalPoll() -> [[String : Any]] {
        var arrCategory = [[String : Any]]()
        if arrCategory.count < 1 {
            // If not intereste selected by user then show all interest.....
            let arrCategoryTemp = TblPoll.fetchAllObjects()
            for interest in arrCategoryTemp!{
                var dicData = [String : Any]()
                let interestInfo = interest as? TblPoll
//                dicData[CId] = interestInfo?.id
//                dicData[CType] = interestInfo?.type
//                dicData["category_id"] = interestInfo?.category_id
                dicData[CCategoryName] = interestInfo?.category_name
//                dicData["lang_name"] = interestInfo?.lang_name
                arrCategory.append(dicData)
            }
        }
        if !arrCategory.isEmpty{
            let sortedResults =  arrCategory.sorted { (obj1, obj2) -> Bool in
                (obj1[CCategoryName] as! String).localizedCaseInsensitiveCompare(obj2[CCategoryName] as! String) == .orderedAscending
            }
            return sortedResults
        }
        return arrCategory
    }
    
}

//MARK:- ------ Category sub related Functions..
extension MIGeneralsAPI {
    func fetchsubCategoryFromLocal() -> [[String : Any]] {
        var arrCategory = [[String : Any]]()
        
         
        if arrCategory.count < 1 {
            // If not intereste selected by user then show all interest.....
            let arrCategoryTemp = TblSubIntrest.fetchAllObjects()
            for interest in arrCategoryTemp!{
                var dicData = [String : Any]()
                let interestInfo = interest as? TblSubIntrest
//                dicData[CId] = interestInfo?.id
//                dicData[CType] = interestInfo?.type
                dicData[CinterestLevel2] = interestInfo?.interest_level2
                arrCategory.append(dicData)
            }
        }
        if !arrCategory.isEmpty{
            let sortedResults =  arrCategory.sorted { (obj1, obj2) -> Bool in
                (obj1[CinterestLevel2] as! String).localizedCaseInsensitiveCompare(obj2[CinterestLevel2] as! String) == .orderedAscending
            }
            return sortedResults
        }
        return arrCategory
    }
}

//MARK:- ------ Chat Related Core Data Funcstions
extension MIGeneralsAPI {
    
    func asString(jsonDictionary: [String:Any]) -> String {
      do {
        let data = try JSONSerialization.data(withJSONObject: jsonDictionary, options: .prettyPrinted)
        return String(data: data, encoding: String.Encoding.utf8) ?? ""
      } catch {
        return ""
      }
    }
    
    
    func fetchChatGroupObjectFromLocal(isNew:Bool) -> TblChatGroupList? {
       
        if var arrUserList : [TblChatGroupList] = TblChatGroupList.fetchAllObjects() as? [TblChatGroupList] {
            
            arrUserList.sort(by: {$0.datetime < $1.datetime})
            
            if arrUserList.count > 0 {
                return isNew ? arrUserList.first : arrUserList.last
            } else {
                return nil
            }
        }
        
        return nil
    }
    
    func fetchChatUserObjectFromLocal(isNew:Bool) -> TblChatUserList? {
        if var arrUserList : [TblChatUserList] = TblChatUserList.fetchAllObjects() as? [TblChatUserList] {
            
            arrUserList.sort(by: {$0.created_at < $1.created_at})
            
            if arrUserList.count > 0 {
                return isNew ? arrUserList.first : arrUserList.last
            } else {
                return nil
            }
        }
        
        return nil
    }
    
    func fetchLatestMessageFromLocal(_ strChannelId : String, isNew:Bool) -> TblMessages? {
        
            if var arrMessageList : [TblMessages] = TblMessages .fetch(predicate: NSPredicate(format: "\(CChannel_id) == %@", strChannelId), orderBy: CCreated_at, ascending: true) as? [TblMessages] {
                arrMessageList.sort(by: {$0.created_at < $1.created_at})
           
            if arrMessageList.count > 0 {
                return isNew ? arrMessageList.last : arrMessageList.first
            } else{
                return nil
            }
        }
        
        return nil
    }
 
}

/********************************************************
 * Author : Chandrika R                                 *
 * Model  : Notfication Send                            *
 * Description:                                         *
 ********************************************************/

extension MIGeneralsAPI {
  
    func sendNotification(_ receiverID: String?,userID:String?,subject:String?,MsgType:String?,MsgSent:String?,showDisplayContent:String?,senderName:String) {
        
        guard let firstName = appDelegate.loginUser?.first_name else {return}
        guard let lastName = appDelegate.loginUser?.last_name else {return}
        guard let profileImg = appDelegate.loginUser?.profile_img else {return}
        
        var contentStr = ""
        let content:[String:Any]  = [
            "subject":subject as Any,
            "senderName": senderName,
//            "content":"<b>\(firstName) \(lastName)</b> &nbsp\(showDisplayContent ?? "")<br>\(MsgSent ?? "")",
            "content":"<b>\(firstName) \(lastName)</b> \(showDisplayContent ?? "")<br>\(MsgSent ?? "")",
          
            "link":"http://localhost:3000/589fd493-401f-4c7c-867c-1938e16d7b68",
            "type":MsgType as Any,
        ]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: content, options: .prettyPrinted)
            let jsonToString = String(data: jsonData, encoding: .utf8)
            let trimmedString = jsonToString?.components(separatedBy: .whitespacesAndNewlines).joined()
            let imgStr_Third = trimmedString?.replacingOccurrences(of: "\"", with: "\\\"")
            contentStr = imgStr_Third ?? ""
            
        } catch {
            print(error.localizedDescription)
        }
        
//        let image = "https:\\/\\/qa.sevenchats.com:3443\\/sevenchats\\/7736772922\\/1636189071050.jpg"

        let profileImgRlc = profileImg.replacingOccurrences(of: "/", with: "\\/")
        
        let dict:[String:Any] = [
            "receiver":receiverID ?? "",
            "sender":userID ?? "",
            "type":1,
            "subject":subject ?? "",
            "content":contentStr,
            "icon":profileImgRlc
        ]
         APIRequest.shared().sendNotification(notifications: dict) { (response, error) in
        if response != nil && error == nil {
        }
      }
    }
    
    func addRewardsPoints(_ points_config_idName: String,message:String,type:String,title:String,name:String,icon:String) {
        
        var points_config_id:String?
        var max_points:String?
        
        guard let userID = appDelegate.loginUser?.user_id else {return}
        
        if let arrMessageList : [TblPointsConfig] = TblPointsConfig .fetch(predicate: NSPredicate(format: "\("points_config_name") == %@",points_config_idName ), orderBy: CCreated_at, ascending: true) as? [TblPointsConfig] {
        if arrMessageList.count > 0 {
            points_config_id = arrMessageList[0].points_config_id
            max_points = arrMessageList[0].max_points
            
        } else{
            return
        }
        }
        let dict:[String:Any] = [
            "user_id":userID,
            "points_config_id":points_config_id ?? "" ,
            "target_id":0,
            "points":max_points ?? "",
            "message":message,
            "detail_text":"",
            "type":type,
            "title":title,
            "name":name,
            "icon":icon
        ]

        print("dict\(dict)")
        APIRequest.shared().rewardsAdding(param: dict) { (response, error) in
        if response != nil && error == nil {
       
        }
      }
    }
}
    

//extension Dictionary where Value: Equatable {
//    func someKey(forValue val: Value) -> Key? {
//        return first(where: { $1 == val })?.key
//    }
//}


extension Dictionary where Value: Equatable {
    func allKeys(forValue val: Value) -> [Key] {
        return self.filter { $1 == val }.map { $0.0 }
    }
}
