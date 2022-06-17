//
//  FavWebSideViewController.swift
//  Sevenchats
//
//  Created by mac-0005 on 20/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Nagaraju K and Chandrika R                                 *
 * Model   : FavWebSideViewController                    *
 * Changes :                                             *
 *                                                       *
 ********************************************************/

import UIKit

class FavWebSideViewController: ParentViewController {
    
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
        //  tblFavWebSite.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK:- --------- Initialization
    func Initialization(){
        self.title = CSideFavWebSites
        tblFavWebSite.register(UINib(nibName: "FavWebSitesTblCell", bundle: nil), forCellReuseIdentifier: "FavWebSitesTblCell")
        tblFavWebSite.estimatedRowHeight = 200;
        tblFavWebSite.rowHeight = UITableView.automaticDimension;
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        refreshControl.tintColor = ColorAppTheme
        tblFavWebSite.pullToRefreshControl = refreshControl
        self.getWebSiteListFromServer(true)
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: #imageLiteral(resourceName: "ic_info_tint"), style: .plain, target: self, action: #selector(btnHelpInfoClicked(_:)))]
    }
    
    @objc fileprivate func btnHelpInfoClicked(_ sender : UIBarButtonItem){
        if let helpLineVC = CStoryboardHelpLine.instantiateViewController(withIdentifier: "HelpLineViewController") as? HelpLineViewController {
            helpLineVC.fromVC = "favVC"
            self.navigationController?.pushViewController(helpLineVC, animated: true)
        }
        
    }
}

// MARK:- --------- Api Functions
extension FavWebSideViewController{
    @objc func pullToRefresh() {
        self.pageNumber = 1
        refreshControl.beginRefreshing()
        self.getWebSiteListFromServer(false)
    }
    
    fileprivate func getWebSiteListFromServer(_ shouldShowLoader : Bool){
        
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
        
        apiTask = APIRequest.shared().getFavWebSiteList(page: pageNumber, type: "FAV", showLoader: shouldShowLoader,userId:userID.description) { [weak self] (response, error) in
            guard let self = self else { return }
            if response != nil{
                self.refreshControl.endRefreshing()
                self.tblFavWebSite.tableFooterView = nil
                
                let respErrorMsg = response?["error"] as? String
                print("response\(respErrorMsg)")
                let errorMsg = respErrorMsg?.stringAfter(":")
//                if errorMsg == " No Favourite Websites Details Found "{
//                    self.tblFavWebSite.setEmptyMessage(errorMsg ?? CNoFavWebList)
//                }
                
                if let webarrList = response![CWebsites] as? [String:Any]{
                    let arrList = webarrList["favourite_websites"] as? [[String : Any]] ?? []
                    if self.pageNumber == 1{
                        self.arrFavWebSite.removeAll()
                        self.tblFavWebSite.reloadData()
                    }
                    if arrList.isEmpty{
//                        self.tblFavWebSite.setEmptyMessage(CNoFavWebList)
                    }
                    
                    self.isLoadMoreCompleted = arrList.isEmpty
                    // Add Data here...
                    if arrList.count > 0{
                        self.arrFavWebSite = self.arrFavWebSite + arrList
                        self.tblFavWebSite.reloadData()
                        self.pageNumber += 1
                    }
                }
            }
            
        }
    }
}

// MARK:- --------- UITableView Datasources/Delegate
extension FavWebSideViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.arrFavWebSite.isEmpty{
//            self.tblFavWebSite.setEmptyMessage(CNoFavWebList)
        }else{
            self.tblFavWebSite.restore()
        }
        return arrFavWebSite.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FavWebSitesTblCell", for: indexPath) as? FavWebSitesTblCell {
            
            
            let dicFavWeSite = arrFavWebSite[indexPath.row]
            cell.lblWebSiteType.text = dicFavWeSite.valueForString(key: "category_name").uppercased()
            cell.lblWebSiteDescription.text = dicFavWeSite.valueForString(key: "description")
            cell.lblWebSiteTitle.text = dicFavWeSite.valueForString(key: "favourite_website_title")
            let created_At = dicFavWeSite.valueForString(key: "created_at")
            let cnvStr = created_At.stringBefore("G")
            let startCreated = DateFormatter.shared().convertDatereversLatest(strDate: cnvStr)
            cell.lblWebSitePostDate.text = startCreated
            
            let userLiker = dicFavWeSite.valueForString(key: "user_has_liked")
            if userLiker == "Yes" {
                cell.btnLike.isSelected = true
            }else {
                cell.btnLike.isSelected = false
            }
            cell.likeCounts = dicFavWeSite.valueForString(key: CLikes)
            
            let strLikeCount =  "\(cell.likeCounts) \(CLike)"
            cell.btnLikeCount.setTitle(strLikeCount, for: .normal)
            cell.commentCounts = dicFavWeSite.valueForString(key: "comments")
            let strCommentCount = appDelegate.getCommentCountString(comment: Int(cell.commentCounts) ?? 0)
//            cell.btnComment.setTitle(strCommentCount, for: .normal)
            cell.btnComment.isHidden = true
            cell.btnShare.setTitle(strCommentCount, for: .normal)
//            cell.btnShare.setTitle(CBtnShare, for: .normal)
            weak var weakCell = cell
            cell.btnLike.touchUpInside { [weak self] (sender) in
                guard let _ = self else { return }
                weakCell?.btnLike.isSelected = !weakCell!.btnLike.isSelected
                if  weakCell?.btnLike.isSelected == true{
                    self?.likeCount = 1
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
                    likeVC.postIDNew = dicFavWeSite.valueForString(key: "favourite_website_id")
                    self?.navigationController?.pushViewController(likeVC, animated: true)
                }
            }
            
            cell.btnComment.touchUpInside { [weak self] (sender) in
                guard let _ = self else { return }
//                if let commentVC = CStoryboardGeneral.instantiateViewController(withIdentifier: "CommentViewController") as? CommentViewController{
//                    commentVC.rssID = dicFavWeSite.valueForString(key: CfavWebID)
//                    self?.navigationController?.pushViewController(commentVC, animated: true)
//                }
            }
            
            cell.btnReport.touchUpInside { [weak self] (sender) in
                guard let _ = self else { return }
                if let reportVC = CStoryboardGeneral.instantiateViewController(withIdentifier: "ReportViewController") as? ReportViewController{
                    reportVC.reportType = .reportRss
                    reportVC.reportedURL = dicFavWeSite.valueForString(key: "favourite_website_url")
                    let user_id = appDelegate.loginUser?.user_id
                    reportVC.reportIDNEW = user_id?.description
                    self?.navigationController?.pushViewController(reportVC, animated: true)
                }
            }
            
            cell.btnShare.touchUpInside { [weak self] (sender) in
                guard let _ = self else { return }
//                self?.presentActivityViewController(mediaData: dicFavWeSite.valueForString(key: "favourite_website_url"), contentTitle: CShareWebsiteContentMsg)
                if let commentVC = CStoryboardGeneral.instantiateViewController(withIdentifier: "CommentViewController") as? CommentViewController{
                    commentVC.rssID = dicFavWeSite.valueForString(key: CfavWebID)
                    self?.navigationController?.pushViewController(commentVC, animated: true)
                }
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
    }
}



