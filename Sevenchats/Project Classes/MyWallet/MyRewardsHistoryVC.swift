//
//  MyRewardsHistoryVC.swift
//  Sevenchats
//
//  Created by mac-00020 on 29/01/20.
//  Copyright © 2020 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Chandrika.R                                 *
 * Model   : MyRewardsHistoryVC                          *
 * Changes :                                             *
 *                                                       *
 ********************************************************/


import Foundation
import UIKit

enum RewardType:String{
    
    case shoutType = "shout"
    case forumType = "forum"
    case articleType = "article"
    case chirpyType = "chirpy"
    case pollType = "poll"
    case eventType = "event"
    case galleryType = "gallery"
    
}



class MyRewardsHistoryVC: ParentViewController {
    
    
    //MARK: - IBOutlet/Object/Variable Declaration
    @IBOutlet weak var tblHistory: UITableView!
    var refreshControl = UIRefreshControl()
    var isLoadMoreCompleted = false
    var currentPage : Int = 1
    var apiTask : URLSessionTask?
    var arrRewards : [MDLRewardDetail] = []
    var type : RewardCategory = RewardCategory.Posts
    var rewards = MDLRewards(level: "", points: 0)
    var categoryName = ""
    var categoryId = 0
    
    //MARK: - UIViewController life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: - Memory management methods
    deinit {
        print("### deinit -> MyRewardsHistoryVC")
    }
}

//MARK: - SetupUI
extension MyRewardsHistoryVC {
    
    fileprivate func setupView() {
        
        self.title = categoryName
        self.view.backgroundColor = UIColor(hexString: "f9fafa")
        
        self.tblHistory.register(UINib(nibName: "EarnedPointsCell", bundle: nil), forCellReuseIdentifier: "EarnedPointsCell")
        self.tblHistory.register(UINib(nibName: "TotalEarnedPointsCell", bundle: nil), forCellReuseIdentifier: "TotalEarnedPointsCell")
        
        self.tblHistory.separatorStyle = .none
        self.tblHistory.tableFooterView = UIView(frame: .zero)
        
        self.refreshControl.tintColor = ColorAppTheme
        self.refreshControl.addTarget(self, action: #selector(self.pullToRefresh), for: .valueChanged)
        self.tblHistory.pullToRefreshControl = self.refreshControl
        
        self.tblHistory.delegate = self
        self.tblHistory.dataSource = self
        
        self.getRewardsDetail(isLoader: true)
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension MyRewardsHistoryVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        if self.arrRewards.isEmpty {
            tableView.setEmptyMessage("There is no data!")
            return 0
        }
        tableView.restore()
        return self.arrRewards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TotalEarnedPointsCell") as? TotalEarnedPointsCell else {
                return UITableViewCell(frame: .zero)
            }
            cell.reward = self.rewards
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EarnedPointsCell") as? EarnedPointsCell else {
            return UITableViewCell(frame: .zero)
        }
        
        cell.rewardDetail = self.arrRewards[indexPath.row]
        cell.type = self.type
        
        // Load more data....
        if (indexPath == self.tblHistory.lastIndexPath()) && !self.isLoadMoreCompleted {
            self.getRewardsDetail(isLoader: false)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard indexPath.section != 0 else { return }
        
        let rewardObj = self.arrRewards[indexPath.row]
        
        let row = indexPath.row
        print("rewardObj\(rewardObj)")
        
        let postID = rewardObj.pointsConfigId ?? 0
        let postType = rewardObj.postType ?? ""
        redirectOnPostDetailScreen(postID,postType:postType,indexPow:row)
//        switch self.type {
//
//        case .Connections, .UsageTime:
//            appDelegate.moveOnProfileScreen(rewardObj.friendId.description, self)
//            break
//
//        case .Posts:
//            //            self.redirectOnPostDetailScreen(rewardObj)
//            break
//
//        case .SellPosts:
//            self.redirectOnProductDetail(rewardObj)
//            break
//
//        default: break
//        }
    }
   
    func redirectOnPostDetailScreen(_ post_ID : Int,postType:String,indexPow:Int){

        var options = ""
        var post_id = ""
        var apiKeyCall = ""
        
        let rewardType = RewardType(rawValue: postType)
        switch (rewardType){
        case .shoutType:
            apiKeyCall = "shouts"
            break;
        
        case .forumType:
            apiKeyCall = "fourms"
            break;
            
        case .articleType:
            apiKeyCall = "articles"
            break;
        case .chirpyType:
            apiKeyCall = "chirpys"
            break;
        case .pollType:
            apiKeyCall = "polls"
            break;
        case .eventType:
            apiKeyCall = "events"
            break;
            
        case .galleryType:
            apiKeyCall = "galleries"
            break
        default:
            print("tihs is defatult")
        }
        guard let userID = appDelegate.loginUser?.user_id else { return }
        APIRequest.shared().viewPostDetailLatest(postID: post_ID,userid:userID.description,apiKeyCall:apiKeyCall){ [weak self] (response, error) in
                guard let self = self else { return }
                if response != nil {
                    DispatchQueue.main.async {
                        if let Info = response!["data"] as? [[String:Any]]{
                            print("this Reward Poit\(Info)")
                            let postInfo = Info[0]
                            for articleInfo in Info {
                                options = articleInfo["options"] as? String ?? ""
                                post_id = articleInfo["post_id"] as? String ?? ""
                            }
                            
                            print("info\(Info)==============")
                            switch postType {
                            case "shout":
                                if let shoutsDetailsVC = CStoryboardHome.instantiateViewController(withIdentifier: "ShoutsDetailViewController") as? ShoutsDetailViewController{
                                     shoutsDetailsVC.shoutInformations = postInfo
                                    shoutsDetailsVC.likeFromNotify = true
                                    print(postInfo.valueForString(key: "post_id"))
                                    shoutsDetailsVC.shoutID = postInfo.valueForString(key: "post_id").toInt
                                    self.navigationController?.pushViewController(shoutsDetailsVC, animated: true)
                                }
                            case "article":
                                if let articleDetailVC = CStoryboardHome.instantiateViewController(withIdentifier: "ArticleDetailViewController") as? ArticleDetailViewController {
                                    articleDetailVC.articleInformation = postInfo
                                    articleDetailVC.likeFromNotify = true
                                    articleDetailVC.articleID = postInfo.valueForString(key: "post_id").toInt
                                    self.navigationController?.pushViewController(articleDetailVC, animated: true)
                                }
                            case "gallery":
//                                let postID = postInfo.valueForString(key: "post_id")
//                                self.getGalleryDetailsFromServer(imgPostId: postID.toInt)
                                
                                if let chirpyDetailVC = CStoryboardImage.instantiateViewController(withIdentifier: "ImageDetailViewController") as? ImageDetailViewController {
                                    chirpyDetailVC.galleryInfo = postInfo
                                    chirpyDetailVC.likeFromNotify = true
                                    chirpyDetailVC.imgPostId = postInfo.valueForString(key: "post_id").toInt
                                    self.navigationController?.pushViewController(chirpyDetailVC, animated: true)
                                }
                            case "chirpy":
                                if let chirpyDetailVC = CStoryboardHome.instantiateViewController(withIdentifier: "ChirpyImageDetailsViewController") as? ChirpyImageDetailsViewController {
                                    chirpyDetailVC.chirpyInformation = postInfo
                                    chirpyDetailVC.likeFromNotify = true
                                    chirpyDetailVC.chirpyID = postInfo.valueForString(key: "post_id").toInt
                                    self.navigationController?.pushViewController(chirpyDetailVC, animated: true)
                                }
                            case "forum":
                                if let forumDetailVC = CStoryboardHome.instantiateViewController(withIdentifier: "ForumDetailViewController") as? ForumDetailViewController {
                                    forumDetailVC.forumID = postInfo.valueForString(key: "post_id").toInt
                                    forumDetailVC.likeFromNotify = true
                                    forumDetailVC.forumInformation = postInfo
                                    self.navigationController?.pushViewController(forumDetailVC, animated: true)
                                }
                            case "event":
                                if let eventDetailVC = CStoryboardEvent.instantiateViewController(withIdentifier: "EventDetailImageViewController") as? EventDetailImageViewController {
                                    eventDetailVC.postID = postInfo.valueForString(key: "post_id").toInt
                                    eventDetailVC.eventInfo = postInfo
                                    eventDetailVC.likeFromNotify = true
                                    self.navigationController?.pushViewController(eventDetailVC, animated: true)
                                }
                            case "poll":
                                
//                                let postID = postInfo.valueForString(key: "post_id")
//                                self.getGalleryDetailsFromServer(imgPostId: postID.toInt)
//                                let productID = self.postInfo.valueForString(key: "post_id")
//                                self.getPollDetailsFromServer(pollID: post_ID.toInt, postInfo: self.postInfo)
                                if let pollDetailVC = CStoryboardPoll.instantiateViewController(withIdentifier: "PollDetailsViewController") as? PollDetailsViewController {
                                    pollDetailVC.posted_ID = postInfo.valueForString(key: "post_id")
                                    pollDetailVC.likeFromNotify = true
                                    pollDetailVC.pollInformation = postInfo
                                    self.navigationController?.pushViewController(pollDetailVC, animated: true)
                                }
                            
                            
                            case "productDetails":
//                                let productID = self.postInfo.valueForString(key: "product_id")
                                if let ProductDetailVC = CStoryboardProduct.instantiateViewController(withIdentifier: "ProductDetailVC") as? ProductDetailVC {
                                    ProductDetailVC.productIds = post_ID.toString
                                    self.navigationController?.pushViewController(ProductDetailVC, animated: true)
                                }
                                
                            default:
                                break
                                
                            }
                        }
                    }
                }
            }
   
        if postType == "Post on store"{
            if let ProductDetailVC = CStoryboardProduct.instantiateViewController(withIdentifier: "ProductDetailVC") as? ProductDetailVC {
                ProductDetailVC.productIds = post_ID.toString
                self.navigationController?.pushViewController(ProductDetailVC, animated: true)
            }
        }
    }
    
    
    func getGalleryDetailsFromServer(imgPostId:Int?) {
        var imagesUpload = ""
        if let imgID = imgPostId {
            APIRequest.shared().viewPostDetailNew(postID: imgID, apiKeyCall: CAPITagsgalleryDetials){ [weak self] (response, error) in
                guard let self = self else { return }
                if response != nil {
                    if let Info = response!["data"] as? [[String:Any]]{
                        for galleryInfo in Info {
                            imagesUpload = galleryInfo["image"] as? String ?? ""
                        }
                        if let imageDetailVC = CStoryboardImage.instantiateViewController(withIdentifier: "ImageDetailViewController") as? ImageDetailViewController {
//                            self.postInfo["image"] = imagesUpload
//                            imageDetailVC.galleryInfo = self.postInfo
//                            imageDetailVC.imgPostId = postInfo.valueForString(key: "post_id").toInt
                            self.navigationController?.pushViewController(imageDetailVC, animated: true)
                        }
                    }
                }
            }
        }
    }
    
    
    
}

// MARK:- API's Calling
extension MyRewardsHistoryVC {
    
    @objc func pullToRefresh() {
        
        self.refreshControl.beginRefreshing()
        self.currentPage = 1
        self.isLoadMoreCompleted = false
        self.getRewardsDetail(isLoader: false)
    }
    
    
    fileprivate func getRewardsDetail(isLoader: Bool) {
        
//        self.currentPage = 1
        if apiTask?.state == URLSessionTask.State.running {return}
        var dict = [String:Any]()
        guard let userID = appDelegate.loginUser?.user_id.description else { return}
        dict["user_id"] = userID
        dict["category_id"] = categoryId.toString
        dict["page"] = currentPage
        dict["limit"] = "20"
        apiTask = APIRequest.shared().rewardsDetail(param:dict,showLoader: isLoader) { [weak self] (response, error) in
            guard let self = self else { return }
            
            self.refreshControl.endRefreshing()
            print(response as Any)
            if response != nil {
                GCDMainThread.async {
                    
                    let arrData = response!["rewards_history"] as? [String : Any] ?? [:]
                    if  let arrDatas = arrData["rewards_history"] as? [[String : Any]]{
                        
                        if self.currentPage == 1 {
                            self.arrRewards.removeAll()
                        }
                       
                        if arrDatas.count > 0{
                            _ = arrDatas.map({self.arrRewards.append(MDLRewardDetail(fromDictionary: $0))})
                            let points = arrData.valueForString(key: "total_points").toInt
                            self.rewards = MDLRewards(name: self.categoryName, level: "", points: points ?? 0)
                            self.tblHistory.reloadData()
                            self.currentPage += 1
                            
                        }
                        
                    }
                    
                    
                    
                    // Add Data here...
//                    if arrList.count > 0{
//                        self.arrCommentList = self.arrCommentList + arrList
//                        self.tblCommentList.reloadData()
//                        self.pageNumber += 1
//                    }
//                }
//
//
//
//
////                    let arrData = response!["rewards_history"] as? [String : Any] ?? [:]
////                    let arrDatas = arrData["rewards_history"] as? [[String : Any]] ?? [[:]]
               
                }
            }
        }
    }
}

//MARK:- API Calls For PostDetails
extension MyRewardsHistoryVC{
    
    func shoutDetailview(){
        
        
        
        
        
        
        
        
    }
    
    
    
    
    
}




extension MyRewardsHistoryVC {
    func redirectOnProductDetail(_ rewardDetail : MDLRewardDetail) {
        if let productDetail : ProductDetailVC = CStoryboardProduct.instantiateViewController(withIdentifier: "ProductDetailVC") as? ProductDetailVC{
            productDetail.VcController = 2
            productDetail.productId = rewardDetail.productId
            self.navigationController?.pushViewController(productDetail, animated: true)
        }
    }
 
}
