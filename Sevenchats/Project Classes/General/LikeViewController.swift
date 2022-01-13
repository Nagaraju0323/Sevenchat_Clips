//
//  LikeViewController.swift
//  Sevenchats
//
//  Created by mac-0005 on 16/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class LikeViewController: ParentViewController {

    @IBOutlet var tblLike : UITableView!
    @IBOutlet var activityIndicator : UIActivityIndicatorView!
    @IBOutlet var lblNoData : UILabel!
    
    fileprivate var arrLikes = [[String : Any]]()
    
    var pageNumber = 1
    var refreshControl = UIRefreshControl()
    var apiTask : URLSessionTask?
    
    var productID : Int?
    var postID : Int?
    var postIDNew: String?
    var rssID : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Initialization()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func Initialization() {

        self.title = CNavLikes
        lblNoData.text = CMessageNoLikesFound
        
        GCDMainThread.async {
            self.refreshControl.addTarget(self, action: #selector(self.pullToRefresh), for: .valueChanged)
            self.refreshControl.tintColor = ColorAppTheme
            self.tblLike.pullToRefreshControl = self.refreshControl
            self.pageNumber = 1
            self.callAPI(true)
        }
    }
}

// MARK:- --------- Api Functions
extension LikeViewController{
    @objc func pullToRefresh() {
        self.pageNumber = 1
        refreshControl.beginRefreshing()
        self.callAPI(false)
    }
    
    func callAPI(_ shouldShowLoader : Bool){
        if (productID ?? 0) != 0{
            self.getProductLikesList(shouldShowLoader)
        }else{
            self.getLikeListFromServer(shouldShowLoader)
        }
    }
    
    func getLikeListFromServer(_ shouldShowLoader : Bool){
        
        if apiTask?.state == URLSessionTask.State.running {
            return
        }
        
        if self.pageNumber > 2{
            self.tblLike.tableFooterView = self.loadMoreIndicator(ColorAppTheme)
        }else{
            self.tblLike.tableFooterView = nil
        }
        
        if shouldShowLoader {
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
        }
        
        apiTask = APIRequest.shared().getLikeList(page: pageNumber, post_id: postIDNew, rss_id: rssID) { (response, error) in

            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
            self.refreshControl.endRefreshing()
            self.tblLike.tableFooterView = nil

            self.arrLikes.removeAll()
            if response != nil{
                if let arrList = response!["liked_users"] as? [[String:Any]]{
                    
                    // Remove all data here when page number == 1
                    if self.pageNumber == 1{
                        self.arrLikes.removeAll()
                        self.tblLike.reloadData()
                    }
                    
                    // Add Data here...
                    if arrList.count > 0{
                        self.arrLikes = self.arrLikes + arrList
                        self.tblLike.reloadData()
                        self.pageNumber += 1
                    }
                    
                    self.lblNoData.isHidden = self.arrLikes.count > 0
                }
            }
        }
    }
    
    func getProductLikesList(_ shouldShowLoader : Bool){
        
        if apiTask?.state == URLSessionTask.State.running {
            return
        }
        
        if self.pageNumber > 2{
            self.tblLike.tableFooterView = self.loadMoreIndicator(ColorAppTheme)
        }else{
            self.tblLike.tableFooterView = nil
        }
        
        if shouldShowLoader {
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
        }
        
        
        apiTask = APIRequest.shared().getLikeList(page: pageNumber, post_id: postIDNew, rss_id: rssID) { (response, error) in

            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
            self.refreshControl.endRefreshing()
            self.tblLike.tableFooterView = nil

            self.arrLikes.removeAll()
            if response != nil{
                if let arrList = response!["liked_users"] as? [[String:Any]]{
                    
                    // Remove all data here when page number == 1
                    if self.pageNumber == 1{
                        self.arrLikes.removeAll()
                        self.tblLike.reloadData()
                    }
                    
                    // Add Data here...
                    if arrList.count > 0{
                        self.arrLikes = self.arrLikes + arrList
                        self.tblLike.reloadData()
                        self.pageNumber += 1
                    }
                    
                    self.lblNoData.isHidden = self.arrLikes.count > 0
                }
            }
        }
        
//        apiTask = APIRequest.shared().productsLikesUserList(page: pageNumber, productId: productID, completion:{ (response, error) in
//
//            self.activityIndicator.isHidden = true
//            self.activityIndicator.stopAnimating()
//            self.refreshControl.endRefreshing()
//            self.tblLike.tableFooterView = nil
//
//            if response != nil{
//                if let arrList = response![CJsonData] as? [[String:Any]]{
//
//                    // Remove all data here when page number == 1
//                    if self.pageNumber == 1{
//                        self.arrLikes.removeAll()
//                        self.tblLike.reloadData()
//                    }
//
//                    // Add Data here...
//                    if arrList.count > 0{
//                        self.arrLikes = self.arrLikes + arrList
//                        self.tblLike.reloadData()
//                        self.pageNumber += 1
//                    }
//
//                    self.lblNoData.isHidden = self.arrLikes.count > 0
//                }
//            }
//        })
    }
}
// MARK:- --------- UITableView Datasources/Delegate
extension LikeViewController : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrLikes.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "LikesTblCell", for: indexPath) as? LikesTblCell {
            let userInfo = arrLikes[indexPath.row]
            cell.lblUserName.text = userInfo.valueForString(key: CFirstname) + " " + userInfo.valueForString(key: CLastname)
            cell.imgUser.loadImageFromUrl(userInfo.valueForString(key: CUserProfileImage), true)
            
            // LOAD MORE DATA...
            if indexPath == tblLike.lastIndexPath() {
                self.callAPI(false)
            }
            
            return cell
        }
        
        return tableView.tableViewDummyCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userInfo = arrLikes[indexPath.row]
       // appDelegate.moveOnProfileScreen(userInfo.valueForString(key: CUserId), self)
        appDelegate.moveOnProfileScreenNew(userInfo.valueForString(key: "user_id"), userInfo.valueForString(key: CUsermailID), self)
    }
}

