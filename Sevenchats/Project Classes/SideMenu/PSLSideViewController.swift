//
//  PSLSideViewController.swift
//  Sevenchats
//
//  Created by CHANDU on 03/01/22.
//  Copyright © 2022 mac-00020. All rights reserved.
//

import UIKit

class PSLSideViewController: ParentViewController {

    var arrFavWebSite = [[String:Any]]()
    var pageNumber = 1
    var refreshControl = UIRefreshControl()
    @IBOutlet var tblFavWebSite : UITableView!
    var apiTask : URLSessionTask?
    var isLoadMoreCompleted = false
    var likeCount = 0
    var likeTotalCount = 0
    var likeStrCount = ""
    var isSelected = false
    var notifcationIsSlected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Initialization()
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("updateReloadTable"), object: nil)
    }
    
    
    @objc func methodOfReceivedNotification(notification: Notification) {
        self.pullToRefresh()
//        tblFavWebSite.reloadData()
    
     }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK:- --------- Initialization
    func Initialization(){
        self.title = CSidePSL
        tblFavWebSite.register(UINib(nibName: "PSLSitesTblCell", bundle: nil), forCellReuseIdentifier: "PSLSitesTblCell")
        tblFavWebSite.estimatedRowHeight = 200;
        tblFavWebSite.rowHeight = UITableView.automaticDimension;
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        refreshControl.tintColor = ColorAppTheme
        tblFavWebSite.pullToRefreshControl = refreshControl
        self.getWebSiteListFromServer(true)
    }
}

// MARK:- --------- Api Functions
extension PSLSideViewController{
    @objc func pullToRefresh() {
        self.pageNumber = 1
        refreshControl.beginRefreshing()
        self.getWebSiteListFromServer(false)
    }
    
    fileprivate func getWebSiteListFromServer(_ shouldShowLoader : Bool){
        
        var para = [String : Any]()
        
        
        if apiTask?.state == URLSessionTask.State.running {
            return
        }
        
        // Add load more indicator here...
        if self.pageNumber > 2 {
            self.tblFavWebSite.tableFooterView = self.loadMoreIndicator(ColorAppTheme)
        }else{
            self.tblFavWebSite.tableFooterView = nil
        }
        guard let userID = appDelegate.loginUser?.user_id else {return}
        
        
        apiTask = APIRequest.shared().getFavWebSiteList(page: pageNumber, type: "psl", showLoader: shouldShowLoader,userId:userID.description) { [weak self] (response, error) in
            guard let self = self else { return }
            if response != nil{
                //                self.arrFavWebSite.removeAll()
                self.refreshControl.endRefreshing()
                self.tblFavWebSite.tableFooterView = nil
                
                //                if let arrList = response![CJsonData] as? [[String:Any]]{
                //
                //                    // Remove all data here when page number == 1
                //                    if self.pageNumber == 1{
                //                        self.arrFavWebSite.removeAll()
                //                    }
                //                    self.isLoadMoreCompleted = arrList.isEmpty
                //                    // Add Data here...
                //                    if arrList.count > 0{
                //                        self.arrFavWebSite = self.arrFavWebSite + arrList
                //                        self.pageNumber += 1
                //                    }
                //                    DispatchQueue.main.async {
                //                        self.tblFavWebSite.reloadData()
                //                    }
                //                }
                if let webarrList = response![CWebsites] as? [String:Any]{
                    //                    let arrDatass = response!["products"] as? [String : Any] ?? [:]
                    let arrList = webarrList["favourite_websites"] as? [[String : Any]] ?? []
                    
                    // Remove all data here when page number == 1
                    if self.pageNumber == 1{
                        self.arrFavWebSite.removeAll()
                    }
                    self.isLoadMoreCompleted = arrList.isEmpty
                    // Add Data here...
                    if arrList.count > 0{
                        self.arrFavWebSite = self.arrFavWebSite + arrList
                        self.pageNumber += 1
                    }
                    DispatchQueue.main.async {
                        self.tblFavWebSite.reloadData()
                    }
                }
                
                
            }
        }
    }
}

// MARK:- --------- UITableView Datasources/Delegate
extension PSLSideViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.arrFavWebSite.isEmpty{
            self.tblFavWebSite.setEmptyMessage(CNoFavWebList)
        }else{
            self.tblFavWebSite.restore()
        }
        return arrFavWebSite.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PSLSitesTblCell", for: indexPath) as? PSLSitesTblCell {
            
            
            let dicFavWeSite = arrFavWebSite[indexPath.row]
            //            cell.lblWebSiteTitle.text = dicFavWeSite.valueForString(key: "title")
            cell.lblWebSiteType.text = dicFavWeSite.valueForString(key: "category_name").uppercased()
            cell.lblWebSiteDescription.text = dicFavWeSite.valueForString(key: "description")
            cell.lblWebSiteTitle.text = dicFavWeSite.valueForString(key: "favourite_website_title")
            
            // cell.lblWebSitePostDate.text = DateFormatter.dateStringFrom(timestamp: dicFavWeSite.valueForDouble(key: CCreated_at), withFormate: CreatedAtPostDF)
         
            let created_At = dicFavWeSite.valueForString(key: "created_at")
            let cnvStr = created_At.stringBefore("G")
//            let removeFrst = cnvStr.chopPrefix(3)
            let startCreated = DateFormatter.shared().convertDatereversLatest(strDate: cnvStr)
            cell.lblWebSitePostDate.text = startCreated
            
            //cell.btnLike.isSelected = dicFavWeSite.valueForInt(key: CIs_Like) == 1
            //cell.likeCount = dicFavWeSite.valueForInt(key: CLikes) ?? 0
            //cell.btnLikeCount.setTitle(appDelegate.getLikeString(like: cell.likeCount), for: .normal)
            //cell.commentCount = dicFavWeSite.valueForInt(key: CTotalComment) ?? 0
            //let strCommentCount = appDelegate.getCommentCountString(comment: cell.commentCount)
            //cell.btnComment.setTitle(strCommentCount, for: .normal)
            
            let userLiker = dicFavWeSite.valueForString(key: "user_has_liked")
            if userLiker == "Yes" {
                cell.btnLike.isSelected = true
            }else {
                cell.btnLike.isSelected = false
            }
            cell.likeCounts = dicFavWeSite.valueForString(key: CLikes)
            
            let strLikeCount =  "\(cell.likeCounts) \(CLike)"
            cell.btnLikeCount.setTitle(strLikeCount, for: .normal)
            //            cell.btnLikeCount.setTitle(appDelegate.getLikeString(like: Int(cell.likeCounts) ?? 0), for: .normal)
            
            cell.commentCounts = dicFavWeSite.valueForString(key: "comments")
            let strCommentCount = appDelegate.getCommentCountString(comment: Int(cell.commentCounts) ?? 0)
            cell.btnComment.setTitle(strCommentCount, for: .normal)
            
            cell.btnShare.setTitle(CBtnShare, for: .normal)
            weak var weakCell = cell
            cell.btnLike.touchUpInside { [weak self] (sender) in
                guard let _ = self else { return }
                weakCell?.btnLike.isSelected = !weakCell!.btnLike.isSelected
                
                //weakCell?.likeCount = weakCell!.btnLike.isSelected ? Int(weakCell!.likeCounts) ?? 0 + 1 : Int(weakCell!.likeCounts) ?? 0 - 1
                //weakCell?.btnLikeCount.setTitle(appDelegate.getLikeString(like: weakCell?.likeCount ?? 0), for: .normal)

                if  weakCell?.btnLike.isSelected == true{
                    self?.likeCount = 1
//                    self.notifcationIsSlected = true
                }else {
                    self?.likeCount = 2
                }
                guard let userID = appDelegate.loginUser?.user_id else {
                    return
                }
                let favID = dicFavWeSite.valueForString(key: CfavWebID)
                APIRequest.shared().likeUnlikeProducts(userId: Int(userID), productId: Int(favID) ?? 0, isLike: self?.likeCount ?? 0){ [weak self](response, error) in
                    
                    guard let _ = self else { return }
                    if response != nil {
                        GCDMainThread.async {
                            let data = response![CJsonMeta] as? [String:Any] ?? [:]
                            let stausLike = data["status"] as? String ?? "0"
                            if stausLike == "0"{
                                APIRequest.shared().likeUnlikeProductCount(productId: Int(favID) ?? 0){ [weak self](response, error) in
                                    guard let _ = self else { return }
                                    if response != nil {
                                        GCDMainThread.async { [self] in
                                            if let arrData = response?["likes_count"] as? Int{
                                                let strLikeCount =  "\(arrData) \(CLike)"
                                                weakCell?.btnLikeCount.setTitle(strLikeCount, for: .normal)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            cell.btnLikeCount.touchUpInside { [weak self] (sender) in
                guard let _ = self else { return }
                if let likeVC = CStoryboardGeneral.instantiateViewController(withIdentifier: "LikeViewController") as? LikeViewController{
                    likeVC.rssID = dicFavWeSite.valueForInt(key: CId)
                    self?.navigationController?.pushViewController(likeVC, animated: true)
                }
            }
            
            cell.btnComment.touchUpInside { [weak self] (sender) in
                guard let _ = self else { return }
                if let commentVC = CStoryboardGeneral.instantiateViewController(withIdentifier: "CommentViewController") as? CommentViewController{
                    commentVC.rssID = dicFavWeSite.valueForString(key: CfavWebID)
//                    commentVC.commentCount = Int(dicFavWeSite.valueForString(key: "comments")) ?? 0
                    self?.navigationController?.pushViewController(commentVC, animated: true)
                }
            }
            
            cell.btnReport.touchUpInside { [weak self] (sender) in
                guard let _ = self else { return }
                if let reportVC = CStoryboardGeneral.instantiateViewController(withIdentifier: "ReportViewController") as? ReportViewController{
                    reportVC.reportType = .reportRss
                    //reportVC.reportID = dicFavWeSite.valueForInt(key: "id")
                    reportVC.reportedURL = dicFavWeSite.valueForString(key: "favourite_website_url")
                    self?.navigationController?.pushViewController(reportVC, animated: true)
                }
                
            }
            
            cell.btnShare.touchUpInside { [weak self] (sender) in
                guard let _ = self else { return }
                self?.presentActivityViewController(mediaData: dicFavWeSite.valueForString(key: "favourite_website_url"), contentTitle: CShareWebsiteContentMsg)
            }
            
            // Load More data......
            if indexPath == tblFavWebSite.lastIndexPath() && !self.isLoadMoreCompleted{
                self.getWebSiteListFromServer(false)
            }
            return cell
        }
        
        return tableView.tableViewDummyCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let favWebsiteInfo = arrFavWebSite[indexPath.row]
        
        if let newsWebVC = CStoryboardGeneral.instantiateViewController(withIdentifier: "NewsWebViewController") as? NewsWebViewController {
            newsWebVC.isFavWebSite = true
            newsWebVC.iObject = favWebsiteInfo
            self.navigationController?.pushViewController(newsWebVC, animated: true)
        }
        
        /*if let favWebSiteDetailVC = CStoryboardSideMenu.instantiateViewController(withIdentifier: "FavWebSiteDetailViewController") as? FavWebSiteDetailViewController{
         favWebSiteDetailVC.websiteInfo = arrFavWebSite[indexPath.row]
         self.navigationController?.pushViewController(favWebSiteDetailVC, animated: true)
         }*/
    }
}