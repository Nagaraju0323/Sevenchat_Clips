//
//  HomeViewController.swift
//  Sevenchats
//
//  Created by mac-0005 on 09/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//


/*********************************************************
 * Author  : Chandrika.R                                 *
 * Model   : HomeViewController                          *
 * Changes :                                             *
 * Added Search,Filter,List post,Like and comments post  *
 * share particluar post,                                *
 * Forum Details user can like and comments,short mesg   *
 * send using with shout                                 *
 * Delete forparticular post                             *
 ********************************************************/


import UIKit
import PhotosUI

class HomeViewController: ParentViewController {
    
    @IBOutlet weak var tblEvents : UITableView!
    @IBOutlet weak var cnHeaderHight : NSLayoutConstraint!
    @IBOutlet weak var cnTblEventTopSpace : NSLayoutConstraint!
    @IBOutlet weak var btnAddPost : UIButton!
    @IBOutlet weak var activityLoader : UIActivityIndicatorView!
    @IBOutlet weak var lblNoData : UILabel!
    
    var searchbtnNav = UIButton()
    var arrPostList = [[String : Any]]()
//    var arrPostList = [[String : Any]]()
    var pageNumber = 1
    var refreshControl = UIRefreshControl()
    var apiTask : URLSessionTask?
    var arrSelectedFilterOption = [[String : Any]]()
    var isLoadMoreCompleted =  false
    var isSelected = false
    var issearchSelected = false
    var usersotherID = ""
    var isSelectedFilter:Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Initialization()
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loading), name: NSNotification.Name(rawValue: "loading"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loadListval), name: NSNotification.Name(rawValue: "loadder"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(pollloadder), name: NSNotification.Name(rawValue: "pollloadder"), object: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        self.getPostListFromServer(showLoader: true)
        
        NotificationCenter.default.addObserver(self, selector: #selector(loading), name: NSNotification.Name(rawValue: "loading"), object: nil)
        lblNoData.text = CToEnhanceFeed
    }
    deinit {
        print("Deinit -> HomeViewController")
    }
    
    @objc func loadList(){
        self.tblEvents.reloadData()
    }
    @objc func loadListval(){
        self.tblEvents.reloadData()
    }
    @objc func pollloadder(){
        self.tblEvents.reloadData()
    }
    @objc func loading(){
        self.tblEvents.reloadData()
    }
    
    //MARK:- ----------- Initialization
    func Initialization(){
        
        self.title = CSideHome
        
        let lblTitleName = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
        lblTitleName.text = "Sevenchats"
        lblTitleName.textColor = UIColor.white
        lblTitleName.font = UIFont(name:"Poppins-Bold",size: 16.0)
        navigationItem.titleView = lblTitleName
        
        //Search Bar button
        searchbtnNav.setImage(UIImage(named: "ic_btn_search"), for: .normal)
        searchbtnNav.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        searchbtnNav.addTarget(self, action: #selector(btnSearchClicked(_:)), for: .touchUpInside)
        let navSearchbtn = UIBarButtonItem(customView: searchbtnNav)
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: #imageLiteral(resourceName: "ic_home_btn_filter"), style: .plain, target: self, action: #selector(btnFilterClicked(_:))),UIBarButtonItem(image: #imageLiteral(resourceName: "ic_home_btn_language"), style: .plain, target: self, action: #selector(btnTranslateClicked(_:))),navSearchbtn]
        tblEvents.estimatedRowHeight = 250;
        tblEvents.rowHeight = UITableView.automaticDimension;
        tblEvents.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 85, right: 0)
        
        //        tblEvents.register(UINib(nibName: "CreatePostTblCell", bundle: nil), forCellReuseIdentifier: "CreatePostTblCell")
        tblEvents.register(UINib(nibName: "HomeArticleCell", bundle: nil), forCellReuseIdentifier: "HomeArticleCell")
        tblEvents.register(UINib(nibName: "HomeGalleryCell", bundle: nil), forCellReuseIdentifier: "HomeGalleryCell")
        tblEvents.register(UINib(nibName: "HomeEventImageTblCell", bundle: nil), forCellReuseIdentifier: "HomeEventImageTblCell")
        tblEvents.register(UINib(nibName: "HomeEventsCell", bundle: nil), forCellReuseIdentifier: "HomeEventsCell")
        tblEvents.register(UINib(nibName: "HomeChirpyImageTblCell", bundle: nil), forCellReuseIdentifier: "HomeChirpyImageTblCell")
        tblEvents.register(UINib(nibName: "HomeChirpyTblCell", bundle: nil), forCellReuseIdentifier: "HomeChirpyTblCell")
        tblEvents.register(UINib(nibName: "HomeShoutsTblCell", bundle: nil), forCellReuseIdentifier: "HomeShoutsTblCell")
        tblEvents.register(UINib(nibName: "HomeFourmTblCell", bundle: nil), forCellReuseIdentifier: "HomeFourmTblCell")
        tblEvents.register(UINib(nibName: "HomePollTblCell", bundle: nil), forCellReuseIdentifier: "HomePollTblCell")
        tblEvents.register(UINib(nibName: "HomeSharedArticleCell", bundle: nil), forCellReuseIdentifier: "HomeSharedArticleCell")
        tblEvents.register(UINib(nibName: "HomeSharedGalleryCell", bundle: nil), forCellReuseIdentifier: "HomeSharedGalleryCell")
        tblEvents.register(UINib(nibName: "HomeSharedEventImageTblCell", bundle: nil), forCellReuseIdentifier: "HomeSharedEventImageTblCell")
        tblEvents.register(UINib(nibName: "HomeSharedEventsCell", bundle: nil), forCellReuseIdentifier: "HomeSharedEventsCell")
        tblEvents.register(UINib(nibName: "HomeSharedChirpyImageTblCell", bundle: nil), forCellReuseIdentifier: "HomeSharedChirpyImageTblCell")
        tblEvents.register(UINib(nibName: "HomeSharedChirpyTblCell", bundle: nil), forCellReuseIdentifier: "HomeSharedChirpyTblCell")
        tblEvents.register(UINib(nibName: "HomeSharedShoutsTblCell", bundle: nil), forCellReuseIdentifier: "HomeSharedShoutsTblCell")
        tblEvents.register(UINib(nibName: "HomeSharedFourmTblCell", bundle: nil), forCellReuseIdentifier: "HomeSharedFourmTblCell")
        tblEvents.register(UINib(nibName: "HomeSharedPollTblCell", bundle: nil), forCellReuseIdentifier: "HomeSharedPollTblCell")
        tblEvents.register(UINib(nibName: "PostDeletedCell", bundle: nil), forCellReuseIdentifier: "PostDeletedCell")
        //  tblEvents.register(UINib(nibName: "HomeStoriesTblCell", bundle: nil), forCellReuseIdentifier: "HomeStoriesTblCell")
        
        if IS_iPhone_X_Series{
            cnHeaderHight.constant = 210
        }
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let navBarHeight = self.navigationController?.navigationBar.bounds.height
        cnTblEventTopSpace.constant = statusBarHeight + (navBarHeight ?? 44)
        
        GCDMainThread.async {
            self.refreshControl.addTarget(self, action: #selector(self.pullToRefresh), for: .valueChanged)
            self.refreshControl.tintColor = ColorAppTheme
            self.tblEvents.pullToRefreshControl = self.refreshControl
            self.getPostListFromServer(showLoader: true)
            AppUpdateManager.shared.checkForUpdate()
        }
    }
}


// MARK:- --------- Api Functions
extension HomeViewController {
    
    @objc func pullToRefresh() {
        if apiTask?.state == URLSessionTask.State.running {
            apiTask?.cancel()
        }
        self.pageNumber = 1
        refreshControl.beginRefreshing()
        self.getPostListFromServer(showLoader: false)
    }
    /**
     This funcation for get post list from server
     - Parameter showLoader:- showLoader is for show loader.
     */
    //MARK:- New Filter API
    func getPostListFromServerFilter() {
        
        if let userID = appDelegate.loginUser?.user_id {
            if apiTask?.state == URLSessionTask.State.running {
                return
            }
            // Add load more indicator here...
            if self.pageNumber > 2 {
                self.tblEvents.tableFooterView = self.loadMoreIndicator(ColorAppTheme)
            }else{
                self.tblEvents.tableFooterView = nil
            }
            
            var serachType : String?
            if arrSelectedFilterOption.count > 0 {
                serachType = arrSelectedFilterOption.map({$0.valueForString(key: CCategoryId)}).joined(separator: ",")
            }
            
            apiTask = APIRequest.shared().getPostListNew(page: self.pageNumber, user_id: Int(userID), search_type: serachType) { [weak self](response, error) in
                guard let self = self else { return }
                self.tblEvents.tableFooterView = nil
                self.refreshControl.endRefreshing()
                
                if response != nil && error == nil {
                    _ = response?["Shout"] as? [[String : Any]]
                    if let arrArticleList = response?["Article"] as? [[String : Any]] {
                        // Remove all data here when page number == 1
                        if self.pageNumber == 1 {
                            self.arrPostList.removeAll()
                            self.tblEvents.reloadData()
                        }
                        // Add Data here...
                        if arrArticleList.count > 0 {
                            self.arrPostList = self.arrPostList + arrArticleList
                            self.tblEvents.reloadData()
                            self.pageNumber += 1
                        }
                    }
                    if let arrChirpyList = response?["Chirpy"] as? [[String : Any]] {
                        // Remove all data here when page number == 1
                        if self.pageNumber == 1 {
                            self.arrPostList.removeAll()
                            self.tblEvents.reloadData()
                        }
                        // Add Data here...
                        if arrChirpyList.count > 0 {
                            self.arrPostList = self.arrPostList + arrChirpyList
                            self.tblEvents.reloadData()
                            self.pageNumber += 1
                        }
                    }
                    if let arrEventList = response?["Event"] as? [[String : Any]] {
                        // Remove all data here when page number == 1
                        if self.pageNumber == 1 {
                            self.arrPostList.removeAll()
                            self.tblEvents.reloadData()
                        }
                        // Add Data here...
                        if arrEventList.count > 0 {
                            self.arrPostList = self.arrPostList + arrEventList
                            self.tblEvents.reloadData()
                            self.pageNumber += 1
                        }
                    }
                    if let arrForumList = response?["Forum"] as? [[String : Any]] {
                        
                        if self.pageNumber == 1 {
                            self.arrPostList.removeAll()
                            self.tblEvents.reloadData()
                        }
                        
                        // Add Data here...
                        if arrForumList.count > 0 {
                            self.arrPostList = self.arrPostList + arrForumList
                            self.tblEvents.reloadData()
                            self.pageNumber += 1
                        }
                    }
                    if let arrGalleryList = response?["Gallery"] as? [[String : Any]] {
                        if self.pageNumber == 1 {
                            self.arrPostList.removeAll()
                            self.tblEvents.reloadData()
                        }
                        
                        // Add Data here...
                        if arrGalleryList.count > 0 {
                            self.arrPostList = self.arrPostList + arrGalleryList
                            self.tblEvents.reloadData()
                            self.pageNumber += 1
                        }
                    }
                    if let arrPollList = response?["Poll"] as? [[String : Any]] {
                        // Remove all data here when page number == 1
                        if self.pageNumber == 1 {
                            self.arrPostList.removeAll()
                            self.tblEvents.reloadData()
                        }
                        
                        // Add Data here...
                        if arrPollList.count > 0 {
                            self.arrPostList = self.arrPostList + arrPollList
                            self.tblEvents.reloadData()
                            self.pageNumber += 1
                        }
                    }
                    
                    if let arrShoutList = response?["Shout"] as? [[String : Any]] {
                        // Remove all data here when page number == 1
                        if self.pageNumber == 1 {
                            self.arrPostList.removeAll()
                            self.tblEvents.reloadData()
                        }
                        
                        // Add Data here...
                        if arrShoutList.count > 0 {
                            self.arrPostList = self.arrPostList + arrShoutList
                            self.tblEvents.reloadData()
                            self.pageNumber += 1
                        }
                    }
                }
            }
        }
    }
    
    func getPostListFromServer(showLoader : Bool){
        if apiTask?.state == URLSessionTask.State.running {
            refreshControl.beginRefreshing()
            return
        }
        if showLoader {
            activityLoader.startAnimating()
        }
        var arrFilterData = [[String : Any]]()
        if arrSelectedFilterOption.count > 0{
            // Get Article filter data...
            let arrArticle = arrSelectedFilterOption.filter({$0[CType] as? Int == CStaticArticleId})
            if arrArticle.count > 0{
                var articleFilter = [String : Any]()
                let artIDS = arrArticle.map({$0.valueForString(key: CId)}).joined(separator: ",")
                articleFilter[CPostType] = CStaticArticleId
                articleFilter[CInterest_ids] = artIDS
                arrFilterData.append(articleFilter)
            }
            // Get Chirpy filter data...
            let arrChirpy = arrSelectedFilterOption.filter({$0[CType] as? Int == CStaticChirpyId})
            if arrChirpy.count > 0{
                var chirFilter = [String : Any]()
                let chirIDS = arrChirpy.map({$0.valueForString(key: CId)}).joined(separator: ",")
                chirFilter[CPostType] = CStaticChirpyId
                chirFilter[CInterest_ids] = chirIDS
                arrFilterData.append(chirFilter)
            }
            // Get Event filter data...
            let arrEvent = arrSelectedFilterOption.filter({$0[CType] as? Int == CStaticEventId})
            if arrEvent.count > 0{
                var eventFilter = [String : Any]()
                let eventIDS = arrEvent.map({$0.valueForString(key: CId)}).joined(separator: ",")
                eventFilter[CPostType] = CStaticEventId
                eventFilter[CInterest_ids] = eventIDS
                arrFilterData.append(eventFilter)
            }
            
            // Get Forum filter data...
            let arrForum = arrSelectedFilterOption.filter({$0[CType] as? Int == CStaticForumId})
            if arrForum.count > 0{
                var forumFilter = [String : Any]()
                let forumIDS = arrForum.map({$0.valueForString(key: CId)}).joined(separator: ",")
                forumFilter[CPostType] = CStaticForumId
                forumFilter[CInterest_ids] = forumIDS
                arrFilterData.append(forumFilter)
            }
            
            // Get Shout filter data...
            let arrShout = arrSelectedFilterOption.filter({$0[CType] as? Int == CStaticShoutId})
            if arrShout.count > 0{
                var shoutFilter = [String : Any]()
                shoutFilter[CPostType] = CStaticShoutId
                shoutFilter[CInterest_ids] = "0"
                arrFilterData.append(shoutFilter)
            }
            
            // Get Gallery filter data...
            let arrGallery = arrSelectedFilterOption.filter({$0[CType] as? Int == CStaticGalleryId})
            if arrGallery.count > 0{
                var galFilter = [String : Any]()
                let galleryIDS = arrGallery.map({$0.valueForString(key: CId)}).joined(separator: ",")
                galFilter[CPostType] = CStaticGalleryId
                galFilter[CInterest_ids] = galleryIDS
                arrFilterData.append(galFilter)
            }
            
            // Get Poll filter data...
            let arrPoll = arrSelectedFilterOption.filter({$0[CType] as? Int == CStaticPollId})
            if arrPoll.count > 0{
                var galFilter = [String : Any]()
                let pollIDS = arrPoll.map({$0.valueForString(key: CId)}).joined(separator: ",")
                galFilter[CPostType] = CStaticPollId
                galFilter[CInterest_ids] = pollIDS
                arrFilterData.append(galFilter)
            }
        }
        
        // Add load more indicator here...
        if self.pageNumber > 2 {
            self.tblEvents.tableFooterView = self.loadMoreIndicator(ColorAppTheme)
        }else{
            self.tblEvents.tableFooterView = nil
        }
        //        self.arrPostList.removeAll()
        guard let userID = appDelegate.loginUser?.user_id else {return}
        apiTask = APIRequest.shared().getPostList(userID: Int(userID), page: pageNumber, filter : arrFilterData, showLoader: showLoader) { [weak self] (response, error) in
            
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.activityLoader.stopAnimating()
                self.refreshControl.endRefreshing()
                self.tblEvents.tableFooterView = nil
                
                if response != nil && error == nil {
                    let data = response!["post_listing"] as! [String:Any]
                    if let arrList = data["post"] as? [[String : Any]] {
//                        print(arrList)
                        // Remove all data here when page number == 1
                        if self.pageNumber == 1 {
                            self.arrPostList.removeAll()
                            self.tblEvents.reloadData()
                        }
                        self.isLoadMoreCompleted = arrList.isEmpty
                        // Add Data here...
                        if arrList.count > 0 {
                            self.arrPostList = self.arrPostList + arrList
                            self.tblEvents.reloadData()
                            self.pageNumber += 1
                        }
                        self.tblEvents.reloadData()
                    }
                    self.lblNoData.isHidden = self.arrPostList.count > 0
                }
            }
        }
    }
    
    func deletePost(_ postId : Int, _ index : Int) {
    }
    
}

// MARK:- --------- UITableView Datasources/Delegate
extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            if self.issearchSelected == true{
                return 95
            }else {
                return 0;
            }
            
        } else if indexPath.section == 1 {
            return 0
            
        }else if indexPath.section == 2{
            if self.isSelected == true{
                return 200
            }else {
                return 135;
            }
        } else if indexPath.section == 3{
            return 68
        }else {
            return UITableView.automaticDimension;
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section) {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return 1
        case 3:
            return 1
        default:
            return arrPostList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Top Search view...
        if indexPath.section == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeHeaderTblCell", for: indexPath) as? HomeHeaderTblCell {
                cell.btnSearch.touchUpInside { [weak self] (sender) in
                    guard let _ = self else { return }
                    if let searchHomeVC = CStoryboardHome.instantiateViewController(withIdentifier: "HomeSearchViewController") as? HomeSearchViewController{
                        self?.navigationController?.pushViewController(searchHomeVC, animated: false)
                    }
                }
                return cell
            }
        }
        
        if indexPath.section == 1 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeStoriesTblCell", for: indexPath) as? HomeStoriesTblCell{
                return cell
            }
        }
        
        if indexPath.section == 2 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CreatePostTblCell", for: indexPath) as? CreatePostTblCell {
                cell.closure = { (value,arrSel) in
                    if let groupFriendVC = CStoryboardGeneral.instantiateViewController(withIdentifier: "GroupFriendSelectionViewController") as? GroupFriendSelectionViewController{
                        groupFriendVC.isFriendList = value
                        groupFriendVC.arrSelectedGroupFriend = arrSel
                        groupFriendVC.setBlock { (arrSelected, message) in
                            if let arr = arrSelected as? [[String : Any]]{
                                cell.arrSelectedGroupFriends = arr
                                cell.clGroupFriend.isHidden = cell.arrSelectedGroupFriends.count == 0
                                cell.btnAddMoreFriends.isHidden = cell.arrSelectedGroupFriends.count == 0
                                cell.btnSelectGroupFriend.isHidden = cell.arrSelectedGroupFriends.count != 0
                                cell.clGroupFriend.reloadData()
                            }
                        }
                        self.navigationController?.pushViewController(groupFriendVC, animated: true)
                    }
                }
                cell.closureShowMessage = { (data) in
                    if data == 1 {
                        self.showAlertMessate()
                    }else if data == 2{
                        self.showAlertMessageGroup()
                    }
                }
                CreatePostTblCell.countCompletion = { (data) in
                    if data == 0{
                        self.isSelected = false
                        tableView.beginUpdates()
                        tableView.endUpdates()
                    }else if data == 1{
                        self.isSelected = true
                        tableView.beginUpdates()
                        tableView.endUpdates()
                    }
                }
                
                cell.onDataAvailable = { (data) in
                    if data == true {
                        DispatchQueue.main.async {
                            let cell0FromSection0 = IndexPath(row: 0, section: 2)
                            self.tblEvents.reloadRows(at:[cell0FromSection0], with: .automatic)
                            self.isSelected = false
                            tableView.beginUpdates()
                            tableView.endUpdates()
                        }
                    }
                }
                
                cell.btnimgUser.touchUpInside { [weak self] (sender) in
                    guard let _ = self else { return }
                    let myProfileVC = CStoryboardProfile.instantiateViewController(withIdentifier: "MyProfileViewController")
                    myProfileVC.view.tag = 107
                    self?.navigationController?.pushViewController(myProfileVC, animated: true)
                }
                return cell
            }
        }
        
        if indexPath.section == 3 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CreatePostTblCell1", for: indexPath) as? CreatePostTblCell1{
                cell.pollButton.addTarget(self, action: #selector(pollConnected(sender:)), for: .touchUpInside)
                cell.galleryButton.addTarget(self, action: #selector(galleryConnected(sender:)), for: .touchUpInside)
                cell.forumButton.addTarget(self, action: #selector(forumConnected(sender:)), for: .touchUpInside)
                cell.eventButton.addTarget(self, action: #selector(eventConnected(sender:)), for: .touchUpInside)
                cell.cripyButton.addTarget(self, action: #selector(cripyConnected(sender:)), for: .touchUpInside)
                cell.articleButton.addTarget(self, action: #selector(articleConnected(sender:)), for: .touchUpInside)
                cell.galleryButton.tag = indexPath.row
                return cell
            }
            
        }
        
        let postInfo = arrPostList[indexPath.row]
        //        let isSharedPost = postInfo.valueForInt(key: CIsSharedPost)
        //        let isPostDeleted = postInfo.valueForInt(key: CIsPostDeleted)
        let isshared = 0
        let isdelete = 0
        if isshared == 1 && isdelete == 1{
            if let cell = tableView.dequeueReusableCell(withIdentifier: "PostDeletedCell", for: indexPath) as? PostDeletedCell {
                cell.postDataSetup(postInfo)
                
                cell.btnLikesCount.touchUpInside { [weak self] (sender) in
                    guard let _ = self else { return }
                    self?.btnLikesCountCLK(postInfo.valueForInt(key: CId))
                }
                
                cell.btnMore.touchUpInside { [weak self] (sender) in
                    guard let _ = self else { return }
                    let userID = (postInfo[CSharedPost] as? [String:Any] ?? [:])[CUserId] as? Int64 ?? 0
                    if userID == appDelegate.loginUser?.user_id{
                        self?.btnSharedMoreCLK(indexPath.row, postInfo)
                    }else{
                        self?.btnSharedReportCLK(postInfo: postInfo)
                    }
                }
                
                cell.btnSharedProfileImg.touchUpInside { [weak self] (sender) in
                    guard let _ = self else { return }
                    if let userID = (postInfo[CSharedPost] as? [String:Any] ?? [:])[CUserId] as? Int {
                        appDelegate.moveOnProfileScreen(userID.description, self)
                    }
                }
                
                cell.btnSharedUserName.touchUpInside { [weak self] (sender) in
                    guard let _ = self else { return }
                    if let userID = (postInfo[CSharedPost] as? [String:Any] ?? [:])[CUserId] as? Int {
                        appDelegate.moveOnProfileScreen(userID.description, self)
                    }
                }
                // .... LOAD MORE DATA HERE
                if indexPath == tblEvents.lastIndexPath() && !self.isLoadMoreCompleted{
                    if isSelectedFilter == true{
                        self.getPostListFromServerFilter()
                    }else {
                        self.getPostListFromServer(showLoader: false)
                    }
                    
                }
                
                return cell
            }
        }
        switch postInfo.valueForString(key: CPostTypeNew) {
        case CStaticArticleIdNew:
            //            1-article
            let isshared = 0
            let isdelete = 1
            if isshared == 1 && isdelete == 0{
                if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeSharedArticleCell", for: indexPath) as? HomeSharedArticleCell {
                    cell.homeArticleDataSetup(postInfo)
                    
                    cell.btnLikesCount.touchUpInside { [weak self] (sender) in
                        guard let _ = self else { return }
                        self?.btnLikesCountCLK(postInfo.valueForInt(key: CId))
                    }
                    
                    cell.btnMore.touchUpInside { [weak self] (sender) in
                        guard let _ = self else { return }
                        let userID = (postInfo[CSharedPost] as? [String:Any] ?? [:])[CUserId] as? Int64 ?? 0
                        if userID == appDelegate.loginUser?.user_id{
                            self?.btnSharedMoreCLK(indexPath.row, postInfo)
                        }else{
                            self?.btnSharedReportCLK(postInfo: postInfo)
                        }
                    }
                    
                    cell.btnSharedProfileImg.touchUpInside { [weak self] (sender) in
                        guard let _ = self else { return }
                        if let userID = (postInfo[CSharedPost] as? [String:Any] ?? [:])[CUserId] as? Int {
                            appDelegate.moveOnProfileScreen(userID.description, self)
                        }
                    }
                    
                    cell.btnSharedUserName.touchUpInside { [weak self] (sender) in
                        guard let _ = self else { return }
                        if let userID = (postInfo[CSharedPost] as? [String:Any] ?? [:])[CUserId] as? Int {
                            appDelegate.moveOnProfileScreen(userID.description, self)
                        }
                    }
                    
                    cell.btnProfileImg.touchUpInside { [weak self] (sender) in
                        guard let _ = self else { return }
                        appDelegate.moveOnProfileScreenNew(postInfo.valueForString(key: CUserId), postInfo.valueForString(key: CUsermailID), self)
                    }
                    
                    cell.btnUserName.touchUpInside { [weak self] (sender) in
                        guard let _ = self else { return }
                        appDelegate.moveOnProfileScreenNew(postInfo.valueForString(key: CUserId), postInfo.valueForString(key: CUsermailID), self)
                    }
                    
                    cell.btnShare.touchUpInside { [weak self] (sender) in
                        guard let _ = self else { return }
                        let sharePost = SharePostHelper(controller: self, dataSet: postInfo)
                        sharePost.shareURL = postInfo.valueForString(key: CShare_url)
                        sharePost.presentShareActivity()
                    }
                    cell.btnIconShare.touchUpInside { [weak self] (sender) in
                        guard let _ = self else { return }
                        let sharePost = SharePostHelper(controller: self, dataSet: postInfo)
                        sharePost.shareURL = postInfo.valueForString(key: CShare_url)
                        sharePost.presentShareActivity()
                    }
                    // .... LOAD MORE DATA HERE
                    if indexPath == tblEvents.lastIndexPath() && !self.isLoadMoreCompleted{
                        
                        if isSelectedFilter == true {
                            self.getPostListFromServerFilter()
                        }else {
                            self.getPostListFromServer(showLoader: false)
                        }
//                        self.getPostListFromServer(showLoader: false)
                    }
                    return cell
                }
            }
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeArticleCell", for: indexPath) as? HomeArticleCell {
               
                cell.isLikesHomePage = true
                cell.homeArticleDataSetup(postInfo)
                
                cell.btnLikesCount.touchUpInside { [weak self] (sender) in
                    guard let _ = self else { return }
                    self?.btnLikesCountCLK(postInfo.valueForString(key: CPostId).toInt)
                }
                cell.btnMore.touchUpInside { [weak self] (sender) in
                    guard let _ = self else { return }
                    if Int64(postInfo.valueForString(key: CUserId)) == appDelegate.loginUser?.user_id{
                        self?.btnMoreCLK(indexPath.row, postInfo)
                    }else{
                        self?.btnReportCLK(postInfo)
                    }
                }
                
                cell.btnProfileImg.touchUpInside { [weak self] (sender) in
                    guard let _ = self else { return }
                    appDelegate.moveOnProfileScreenNew(postInfo.valueForString(key: CUserId), postInfo.valueForString(key: CUsermailID), self)
                }
                
                cell.btnUserName.touchUpInside { [weak self] (sender) in
                    guard let _ = self else { return }
                    appDelegate.moveOnProfileScreenNew(postInfo.valueForString(key: CUserId), postInfo.valueForString(key: CUsermailID), self)
                }
                
                cell.btnShare.touchUpInside { [weak self] (sender) in
                    guard let _ = self else { return }
                    let sharePost = SharePostHelper(controller: self, dataSet: postInfo)
                    sharePost.shareURL = postInfo.valueForString(key: CShare_url)
                    sharePost.presentShareActivity()
                }
                cell.btnIconShare.touchUpInside { [weak self] (sender) in
                    guard let _ = self else { return }
                    let sharePost = SharePostHelper(controller: self, dataSet: postInfo)
                    sharePost.shareURL = postInfo.valueForString(key: CShare_url)
                    sharePost.presentShareActivity()
                }
                // .... LOAD MORE DATA HERE
                if indexPath == tblEvents.lastIndexPath() && !self.isLoadMoreCompleted{
                    if isSelectedFilter == true {
                        self.getPostListFromServerFilter()
                    }else {
                        self.getPostListFromServer(showLoader: false)
                    }
//                    self.getPostListFromServer(showLoader: false)
                }
                return cell
            }
            break
        case CStaticGalleryIdNew:
            //            2-gallery
            //let isSharedPost = postInfo.valueForInt(key: CIsSharedPost)
            let isshared = 0
            if isshared == 1{
                
                if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeSharedGalleryCell", for: indexPath) as? HomeSharedGalleryCell {
                    cell.homeGalleryDataSetup(postInfo)
                    
                    cell.btnLikesCount.touchUpInside { [weak self] (sender) in
                        guard let _ = self else { return }
                        self?.btnLikesCountCLK(postInfo.valueForInt(key: CId))
                    }
                    
                    cell.btnMore.touchUpInside { [weak self] (sender) in
                        guard let _ = self else { return }
                        let userID = (postInfo[CSharedPost] as? [String:Any] ?? [:])[CUserId] as? Int64 ?? 0
                        if userID == appDelegate.loginUser?.user_id{
                            self?.btnSharedMoreCLK(indexPath.row, postInfo)
                        }else{
                            self?.btnSharedReportCLK(postInfo: postInfo)
                        }
                    }
                    
                    cell.btnSharedProfileImg.touchUpInside { [weak self] (sender) in
                        guard let _ = self else { return }
                        if let userID = (postInfo[CSharedPost] as? [String:Any] ?? [:])[CUserId] as? Int {
                            appDelegate.moveOnProfileScreenNew(postInfo.valueForString(key: CUserId), postInfo.valueForString(key: CUsermailID), self)
                        }
                    }
                    
                    cell.btnSharedUserName.touchUpInside { [weak self] (sender) in
                        guard let _ = self else { return }
                        if let userID = (postInfo[CSharedPost] as? [String:Any] ?? [:])[CUserId] as? Int {
                            appDelegate.moveOnProfileScreenNew(postInfo.valueForString(key: CUserId), postInfo.valueForString(key: CUsermailID), self)
                        }
                    }
                    cell.btnProfileImg.touchUpInside { [weak self] (sender) in
                        guard let _ = self else { return }
                        appDelegate.moveOnProfileScreenNew(postInfo.valueForString(key: CUserId), postInfo.valueForString(key: CUsermailID), self)
                    }
                    
                    cell.btnUserName.touchUpInside { [weak self] (sender) in
                        guard let _ = self else { return }
                        appDelegate.moveOnProfileScreenNew(postInfo.valueForString(key: CUserId), postInfo.valueForString(key: CUsermailID), self)
                    }
                    
                    cell.btnShare.touchUpInside { [weak self] (sender) in
                        guard let _ = self else { return }
                        let sharePost = SharePostHelper(controller: self, dataSet: postInfo)
                        sharePost.shareURL = postInfo.valueForString(key: CShare_url)
                        sharePost.presentShareActivity()
                    }
                    cell.btnIconShare.touchUpInside { [weak self] (sender) in
                        guard let _ = self else { return }
                        let sharePost = SharePostHelper(controller: self, dataSet: postInfo)
                        sharePost.shareURL = postInfo.valueForString(key: CShare_url)
                        sharePost.presentShareActivity()
                    }
                    // .... LOAD MORE DATA HERE
                    if indexPath == tblEvents.lastIndexPath() && !self.isLoadMoreCompleted{
                        if isSelectedFilter == true {
                            self.getPostListFromServerFilter()
                        }else {
                            self.getPostListFromServer(showLoader: false)
                        }
//                        self.getPostListFromServer(showLoader: false)
                    }
                    
                    return cell
                }
            }
            if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeGalleryCell", for: indexPath) as? HomeGalleryCell {
                
                cell.isLikesHomePage = true
                cell.homeGalleryDataSetup(postInfo)
                
                cell.btnLikesCount.touchUpInside { [weak self] (sender) in
                    guard let _ = self else { return }
                    self?.btnLikesCountCLK(postInfo.valueForString(key: CPostId).toInt)
                }
                
                cell.btnMore.touchUpInside { [weak self] (sender) in
                    guard let _ = self else { return }
                    if Int64(postInfo.valueForString(key: CUserId)) == appDelegate.loginUser?.user_id{
                        self?.btnMoreCLK(indexPath.row, postInfo)
                    }else{
                        self?.btnReportCLK(postInfo)
                    }
                }
                
                cell.btnProfileImg.touchUpInside { [weak self] (sender) in
                    guard let _ = self else { return }
                    appDelegate.moveOnProfileScreenNew(postInfo.valueForString(key: CUserId), postInfo.valueForString(key: CUsermailID), self)
                }
                
                cell.btnUserName.touchUpInside { [weak self] (sender) in
                    guard let _ = self else { return }
                    appDelegate.moveOnProfileScreenNew(postInfo.valueForString(key: CUserId), postInfo.valueForString(key: CUsermailID), self)
                }
                
                cell.btnShare.touchUpInside { [weak self] (sender) in
                    guard let _ = self else { return }
                    let sharePost = SharePostHelper(controller: self, dataSet: postInfo)
                    sharePost.shareURL = postInfo.valueForString(key: CShare_url)
                    sharePost.presentShareActivity()
                }
                cell.btnIconShare.touchUpInside { [weak self] (sender) in
                    guard let _ = self else { return }
                    let sharePost = SharePostHelper(controller: self, dataSet: postInfo)
                    sharePost.shareURL = postInfo.valueForString(key: CShare_url)
                    sharePost.presentShareActivity()
                }
                // .... LOAD MORE DATA HERE
                if indexPath == tblEvents.lastIndexPath() && !self.isLoadMoreCompleted{
                    if isSelectedFilter == true {
                        self.getPostListFromServerFilter()
                    }else {
                        self.getPostListFromServer(showLoader: false)
                    }
                    
                    self.getPostListFromServer(showLoader: false)
                }
                
                return cell
            }
            break
        case CStaticChirpyIdNew:
            //            3-chripy
            if postInfo.valueForString(key: CImage).isBlank{
                let isshared = 0
                if isshared == 1{
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeSharedChirpyTblCell", for: indexPath) as? HomeSharedChirpyTblCell {
                        cell.homeChirpyDataSetup(postInfo)
                        
                        cell.btnLikesCount.touchUpInside { [weak self] (sender) in
                            guard let _ = self else { return }
                            self?.btnLikesCountCLK(postInfo.valueForInt(key: CId))
                        }
                        
                        cell.btnMore.touchUpInside { [weak self] (sender) in
                            guard let _ = self else { return }
                            let userID = (postInfo[CSharedPost] as? [String:Any] ?? [:])[CUserId] as? Int64 ?? 0
                            if userID == appDelegate.loginUser?.user_id{
                                self?.btnSharedMoreCLK(indexPath.row, postInfo)
                            }else{
                                self?.btnSharedReportCLK(postInfo: postInfo)
                            }
                        }
                        
                        cell.btnSharedProfileImg.touchUpInside { [weak self] (sender) in
                            guard let _ = self else { return }
                            if let userID = (postInfo[CSharedPost] as? [String:Any] ?? [:])[CUserId] as? Int {
                                appDelegate.moveOnProfileScreenNew(postInfo.valueForString(key: CUserId), postInfo.valueForString(key: CUsermailID), self)
                            }
                        }
                        
                        cell.btnSharedUserName.touchUpInside { [weak self] (sender) in
                            guard let _ = self else { return }
                            if let userID = (postInfo[CSharedPost] as? [String:Any] ?? [:])[CUserId] as? Int {
                                appDelegate.moveOnProfileScreenNew(postInfo.valueForString(key: CUserId), postInfo.valueForString(key: CUsermailID), self)
                            }
                        }
                        cell.btnProfileImg.touchUpInside { [weak self] (sender) in
                            guard let _ = self else { return }
                            appDelegate.moveOnProfileScreenNew(postInfo.valueForString(key: CUserId), postInfo.valueForString(key: CUsermailID), self)
                        }
                        
                        cell.btnUserName.touchUpInside { [weak self] (sender) in
                            guard let _ = self else { return }
                            appDelegate.moveOnProfileScreenNew(postInfo.valueForString(key: CUserId), postInfo.valueForString(key: CUsermailID), self)
                        }
                        
                        cell.btnShare.touchUpInside { [weak self] (sender) in
                            guard let _ = self else { return }
                            let sharePost = SharePostHelper(controller: self, dataSet: postInfo)
                            sharePost.shareURL = postInfo.valueForString(key: CShare_url)
                            sharePost.presentShareActivity()
                        }
                        cell.btnIconShare.touchUpInside { [weak self] (sender) in
                            guard let _ = self else { return }
                            let sharePost = SharePostHelper(controller: self, dataSet: postInfo)
                            sharePost.shareURL = postInfo.valueForString(key: CShare_url)
                            sharePost.presentShareActivity()
                        }
                        // .... LOAD MORE DATA HERE
                        if indexPath == tblEvents.lastIndexPath() && !self.isLoadMoreCompleted{
                            if isSelectedFilter == true {
                                self.getPostListFromServerFilter()
                            }else {
                                self.getPostListFromServer(showLoader: false)
                            }
                            self.getPostListFromServer(showLoader: false)
                        }
                        
                        return cell
                    }
                }
                if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeChirpyImageTblCell", for: indexPath) as? HomeChirpyImageTblCell {
                    cell.isLikesHomePage = true
                    cell.homeChirpyImageDataSetup(postInfo)
                    cell.btnLikesCount.touchUpInside { [weak self] (sender) in
                        guard let _ = self else { return }
                        self?.btnLikesCountCLK(postInfo.valueForString(key: CPostId).toInt)
                    }
                    
                    cell.btnMore.touchUpInside { [weak self] (sender) in
                        guard let _ = self else { return }
                        if Int64(postInfo.valueForString(key: CUserId)) == appDelegate.loginUser?.user_id{
                            self?.btnMoreCLK(indexPath.row, postInfo)
                        }else{
                            self?.btnReportCLK(postInfo)
                        }
                    }
                    
                    cell.btnProfileImg.touchUpInside { [weak self] (sender) in
                        guard let _ = self else { return }
                        appDelegate.moveOnProfileScreenNew(postInfo.valueForString(key: CUserId), postInfo.valueForString(key: CUsermailID), self)
                    }
                    
                    cell.btnUserName.touchUpInside { [weak self] (sender) in
                        guard let _ = self else { return }
                        appDelegate.moveOnProfileScreenNew(postInfo.valueForString(key: CUserId), postInfo.valueForString(key: CUsermailID), self)
                    }
                    
                    cell.btnShare.touchUpInside { [weak self] (sender) in
                        guard let _ = self else { return }
                        let sharePost = SharePostHelper(controller: self, dataSet: postInfo)
                        sharePost.shareURL = postInfo.valueForString(key: CShare_url)
                        sharePost.presentShareActivity()
                    }
                    cell.btnIconShare.touchUpInside { [weak self] (sender) in
                        guard let _ = self else { return }
                        let sharePost = SharePostHelper(controller: self, dataSet: postInfo)
                        sharePost.shareURL = postInfo.valueForString(key: CShare_url)
                        sharePost.presentShareActivity()
                    }
                    // .... LOAD MORE DATA HERE
                    if indexPath == tblEvents.lastIndexPath() && !self.isLoadMoreCompleted{
                        
                        if isSelectedFilter == true {
                            self.getPostListFromServerFilter()
                        }else {
                            self.getPostListFromServer(showLoader: false)
                        }
//                        self.getPostListFromServer(showLoader: false)
                    }
                    
                    return cell
                }
            }else{
                let isshared = 0
                if isshared == 1{
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeSharedChirpyImageTblCell", for: indexPath) as? HomeSharedChirpyImageTblCell {
                        cell.homeChirpyImageDataSetup(postInfo)
                        
                        cell.btnLikesCount.touchUpInside { [weak self] (sender) in
                            guard let _ = self else { return }
                            self?.btnLikesCountCLK(postInfo.valueForInt(key: CId))
                        }
                        
                        cell.btnMore.touchUpInside { [weak self] (sender) in
                            guard let _ = self else { return }
                            let userID = (postInfo[CSharedPost] as? [String:Any] ?? [:])[CUserId] as? Int64 ?? 0
                            if userID == appDelegate.loginUser?.user_id{
                                self?.btnSharedMoreCLK(indexPath.row, postInfo)
                            }else{
                                self?.btnSharedReportCLK(postInfo: postInfo)
                            }
                        }
                        
                        cell.btnSharedProfileImg.touchUpInside { [weak self] (sender) in
                            guard let _ = self else { return }
                            if let userID = (postInfo[CSharedPost] as? [String:Any] ?? [:])[CUserId] as? Int {
                                appDelegate.moveOnProfileScreenNew(postInfo.valueForString(key: CUserId), postInfo.valueForString(key: CUsermailID), self)
                            }
                        }
                        
                        cell.btnSharedUserName.touchUpInside { [weak self] (sender) in
                            guard let _ = self else { return }
                            if let userID = (postInfo[CSharedPost] as? [String:Any] ?? [:])[CUserId] as? Int {
                                appDelegate.moveOnProfileScreenNew(postInfo.valueForString(key: CUserId), postInfo.valueForString(key: CUsermailID), self)
                            }
                        }
                        cell.btnProfileImg.touchUpInside { [weak self] (sender) in
                            guard let _ = self else { return }
                            appDelegate.moveOnProfileScreenNew(postInfo.valueForString(key: CUserId), postInfo.valueForString(key: CUsermailID), self)
                        }
                        
                        cell.btnUserName.touchUpInside { [weak self] (sender) in
                            guard let _ = self else { return }
                            appDelegate.moveOnProfileScreenNew(postInfo.valueForString(key: CUserId), postInfo.valueForString(key: CUsermailID), self)
                        }
                        
                        cell.btnShare.touchUpInside { [weak self] (sender) in
                            guard let _ = self else { return }
                            let sharePost = SharePostHelper(controller: self, dataSet: postInfo)
                            sharePost.shareURL = postInfo.valueForString(key: CShare_url)
                            sharePost.presentShareActivity()
                        }
                        cell.btnIconShare.touchUpInside { [weak self] (sender) in
                            guard let _ = self else { return }
                            let sharePost = SharePostHelper(controller: self, dataSet: postInfo)
                            sharePost.shareURL = postInfo.valueForString(key: CShare_url)
                            sharePost.presentShareActivity()
                        }
                        // .... LOAD MORE DATA HERE
                        if indexPath == tblEvents.lastIndexPath() && !self.isLoadMoreCompleted{
                            
                            if isSelectedFilter == true {
                                self.getPostListFromServerFilter()
                            }else {
                                self.getPostListFromServer(showLoader: false)
                            }
//                            self.getPostListFromServer(showLoader: false)
                        }
                        
                        return cell
                    }
                }
                if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeChirpyImageTblCell", for: indexPath) as? HomeChirpyImageTblCell {
                    cell.isLikesHomePage = true
                    cell.homeChirpyImageDataSetup(postInfo)
                    
                    cell.btnLikesCount.touchUpInside { [weak self] (sender) in
                        guard let _ = self else { return }
                        self?.btnLikesCountCLK(postInfo.valueForString(key: CPostId).toInt)
                    }
                    
                    cell.btnMore.touchUpInside { [weak self] (sender) in
                        guard let _ = self else { return }
                        if Int64(postInfo.valueForString(key: CUserId)) == appDelegate.loginUser?.user_id{
                            self?.btnMoreCLK(indexPath.row, postInfo)
                        }else{
                            self?.btnReportCLK(postInfo)
                        }
                    }
                    cell.btnProfileImg.touchUpInside { [weak self] (sender) in
                        guard let _ = self else { return }
                        appDelegate.moveOnProfileScreenNew(postInfo.valueForString(key: CUserId), postInfo.valueForString(key: CUsermailID), self)
                    }
                    
                    cell.btnUserName.touchUpInside { [weak self] (sender) in
                        guard let _ = self else { return }
                        appDelegate.moveOnProfileScreenNew(postInfo.valueForString(key: CUserId), postInfo.valueForString(key: CUsermailID), self)
                    }
                    
                    cell.btnShare.touchUpInside { [weak self] (sender) in
                        guard let _ = self else { return }
                        let sharePost = SharePostHelper(controller: self, dataSet: postInfo)
                        sharePost.shareURL = postInfo.valueForString(key: CShare_url)
                        sharePost.presentShareActivity()
                    }
                    cell.btnIconShare.touchUpInside { [weak self] (sender) in
                        guard let _ = self else { return }
                        let sharePost = SharePostHelper(controller: self, dataSet: postInfo)
                        sharePost.shareURL = postInfo.valueForString(key: CShare_url)
                        sharePost.presentShareActivity()
                    }
                    // .... LOAD MORE DATA HERE
                    if indexPath == tblEvents.lastIndexPath() && !self.isLoadMoreCompleted{
                        
                        if isSelectedFilter == true {
                            self.getPostListFromServerFilter()
                        }else {
                            self.getPostListFromServer(showLoader: false)
                        }
//                        self.getPostListFromServer(showLoader: false)
                    }
                    
                    return cell
                }
            }
            break
        case CStaticShoutIdNew:
            //            4-shout
            // let isSharedPost = postInfo.valueForInt(key: CIsSharedPost)
            let isshared = 0
            if isshared == 1{
                if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeSharedShoutsTblCell", for: indexPath) as? HomeSharedShoutsTblCell {
                    
                    cell.homeShoutsDataSetup(postInfo)
                    cell.btnLikesCount.touchUpInside { [weak self] (sender) in
                        guard let _ = self else { return }
                        self?.btnLikesCountCLK(postInfo.valueForInt(key: CId))
                    }
                    cell.btnMore.touchUpInside { [weak self] (sender) in
                        guard let _ = self else { return }
                        let userID = (postInfo[CSharedPost] as? [String:Any] ?? [:])[CUserId] as? Int64 ?? 0
                        if userID == appDelegate.loginUser?.user_id{
                            self?.btnSharedMoreCLK(indexPath.row, postInfo)
                        }else{
                            self?.btnSharedReportCLK(postInfo: postInfo)
                        }
                    }
                    cell.btnSharedProfileImg.touchUpInside { [weak self] (sender) in
                        guard let _ = self else { return }
                        if let userID = (postInfo[CSharedPost] as? [String:Any] ?? [:])[CUserId] as? Int {
                            appDelegate.moveOnProfileScreenNew(postInfo.valueForString(key: CUserId), postInfo.valueForString(key: CUsermailID), self)
                        }
                    }
                    
                    cell.btnSharedUserName.touchUpInside { [weak self] (sender) in
                        guard let _ = self else { return }
                        if let userID = (postInfo[CSharedPost] as? [String:Any] ?? [:])[CUserId] as? Int {
                            appDelegate.moveOnProfileScreenNew(postInfo.valueForString(key: CUserId), postInfo.valueForString(key: CUsermailID), self)
                        }
                    }
                    cell.btnProfileImg.touchUpInside { [weak self] (sender) in
                        guard let _ = self else { return }
                        appDelegate.moveOnProfileScreenNew(postInfo.valueForString(key: CUserId), postInfo.valueForString(key: CUsermailID), self)
                    }
                    
                    cell.btnUserName.touchUpInside { [weak self] (sender) in
                        guard let _ = self else { return }
                        appDelegate.moveOnProfileScreenNew(postInfo.valueForString(key: CUserId), postInfo.valueForString(key: CUsermailID), self)
                    }
                    
                    cell.btnShare.touchUpInside { [weak self] (sender) in
                        guard let _ = self else { return }
                        let sharePost = SharePostHelper(controller: self, dataSet: postInfo)
                        sharePost.shareURL = postInfo.valueForString(key: CShare_url)
                        sharePost.presentShareActivity()
                    }
                    cell.btnIconShare.touchUpInside { [weak self] (sender) in
                        guard let _ = self else { return }
                        //self?.presentActivityViewController(mediaData: postInfo.valueForString(key: CShare_url), contentTitle: CSharePostContentMsg)
                        let sharePost = SharePostHelper(controller: self, dataSet: postInfo)
                        sharePost.shareURL = postInfo.valueForString(key: CShare_url)
                        sharePost.presentShareActivity()
                    }
                    // .... LOAD MORE DATA HERE
                    if indexPath == tblEvents.lastIndexPath() && !self.isLoadMoreCompleted{
                        
                        if isSelectedFilter == true {
                            self.getPostListFromServerFilter()
                        }else {
                            self.getPostListFromServer(showLoader: false)
                        }
//                        self.getPostListFromServer(showLoader: false)
                    }
                    
                    return cell
                }
            }
            if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeShoutsTblCell", for: indexPath) as? HomeShoutsTblCell {
                cell.isLikesHomePage = true
                cell.homeShoutsDataSetup(postInfo)
                cell.btnLikesCount.touchUpInside { [weak self] (sender) in
                    guard let _ = self else { return }
                    self?.btnLikesCountCLK(postInfo.valueForString(key: CPostId).toInt)
                }
                
                cell.btnMore.touchUpInside { [weak self] (sender) in
                    guard let _ = self else { return }
                    if Int64(postInfo.valueForString(key: CUserId)) == appDelegate.loginUser?.user_id{
                        self?.btnMoreCLK(indexPath.row, postInfo)
                    }else{
                        self?.btnReportCLK(postInfo)
                    }
                }
                
                cell.btnProfileImg.touchUpInside { [weak self] (sender) in
                    guard let _ = self else { return }
                    appDelegate.moveOnProfileScreenNew(postInfo.valueForString(key: CUserId),postInfo.valueForString(key: CUsermailID), self)
                }
                
                cell.btnUserName.touchUpInside { [weak self] (sender) in
                    guard let _ = self else { return }
                    appDelegate.moveOnProfileScreenNew(postInfo.valueForString(key: CUserId), postInfo.valueForString(key: CUsermailID), self)
                }
                
                cell.btnShare.touchUpInside { [weak self] (sender) in
                    guard let _ = self else { return }
                    let sharePost = SharePostHelper(controller: self, dataSet: postInfo)
                    sharePost.shareURL = postInfo.valueForString(key: CShare_url)
                    sharePost.presentShareActivity()
                }
                cell.btnIconShare.touchUpInside { [weak self] (sender) in
                    guard let _ = self else { return }
                    let sharePost = SharePostHelper(controller: self, dataSet: postInfo)
                    sharePost.shareURL = postInfo.valueForString(key: CShare_url)
                    sharePost.presentShareActivity()
                }
                // .... LOAD MORE DATA HERE
                if indexPath == tblEvents.lastIndexPath() && !self.isLoadMoreCompleted{
                    
                    if isSelectedFilter == true {
                        self.getPostListFromServerFilter()
                    }else {
                        self.getPostListFromServer(showLoader: false)
                    }
//                    self.getPostListFromServer(showLoader: false)
                }
                
                return cell
            }
            break
        case CStaticForumIdNew:
            //            5-forum
            // let isSharedPost = postInfo.valueForInt(key: CIsSharedPost)
            let isshared = 0
            if isshared == 1{
                if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeSharedFourmTblCell", for: indexPath) as? HomeSharedFourmTblCell {
                    
                    cell.homeFourmDataSetup(postInfo)
                    cell.btnLikesCount.touchUpInside { [weak self] (sender) in
                        guard let _ = self else { return }
                        self?.btnLikesCountCLK(postInfo.valueForString(key: CPostId).toInt)
                    }
                    
                    cell.btnMore.touchUpInside { [weak self] (sender) in
                        guard let _ = self else { return }
                        let userID = (postInfo[CSharedPost] as? [String:Any] ?? [:])[CUserId] as? Int64 ?? 0
                        if userID == appDelegate.loginUser?.user_id{
                            self?.btnMoreCLK(indexPath.row, postInfo)
                        }else{
                            self?.btnReportCLK(postInfo)
                        }
                    }
                    
                    cell.btnSharedProfileImg.touchUpInside { [weak self] (sender) in
                        guard let _ = self else { return }
                        if let userID = (postInfo[CSharedPost] as? [String:Any] ?? [:])[CUserId] as? Int {
                            appDelegate.moveOnProfileScreenNew(postInfo.valueForString(key: CUserId), postInfo.valueForString(key: CUsermailID), self)
                        }
                    }
                    
                    cell.btnSharedUserName.touchUpInside { [weak self] (sender) in
                        guard let _ = self else { return }
                        if let userID = (postInfo[CSharedPost] as? [String:Any] ?? [:])[CUserId] as? Int {
                            appDelegate.moveOnProfileScreenNew(postInfo.valueForString(key: CUserId), postInfo.valueForString(key: CUsermailID), self)
                        }
                    }
                    cell.btnProfileImg.touchUpInside { [weak self] (sender) in
                        guard let _ = self else { return }
                        appDelegate.moveOnProfileScreenNew(postInfo.valueForString(key: CUserId), postInfo.valueForString(key: CUsermailID), self)
                    }
                    
                    cell.btnUserName.touchUpInside { [weak self] (sender) in
                        guard let _ = self else { return }
                        appDelegate.moveOnProfileScreenNew(postInfo.valueForString(key: CUserId), postInfo.valueForString(key: CUsermailID), self)
                    }
                    
                    cell.btnShare.touchUpInside { [weak self] (sender) in
                        guard let _ = self else { return }
                        let sharePost = SharePostHelper(controller: self, dataSet: postInfo)
                        sharePost.shareURL = postInfo.valueForString(key: CShare_url)
                        sharePost.presentShareActivity()
                    }
                    cell.btnIconShare.touchUpInside { [weak self] (sender) in
                        guard let _ = self else { return }
                        let sharePost = SharePostHelper(controller: self, dataSet: postInfo)
                        sharePost.shareURL = postInfo.valueForString(key: CShare_url)
                        sharePost.presentShareActivity()
                    }
                    // .... LOAD MORE DATA HERE
                    if indexPath == tblEvents.lastIndexPath() && !self.isLoadMoreCompleted{
                        
                        if isSelectedFilter == true {
                            self.getPostListFromServerFilter()
                        }else {
                            self.getPostListFromServer(showLoader: false)
                        }
//                        self.getPostListFromServer(showLoader: false)
                    }
                    
                    return cell
                }
            }
            if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeFourmTblCell", for: indexPath) as? HomeFourmTblCell {
                
                cell.isLikesHomePage = true
                cell.homeFourmDataSetup(postInfo)
               
                cell.btnLikesCount.touchUpInside { [weak self] (sender) in
                    guard let _ = self else { return }
                    self?.btnLikesCountCLK(postInfo.valueForString(key: CPostId).toInt)
                }
                
                cell.btnMore.touchUpInside { [weak self] (sender) in
                    guard let _ = self else { return }
                    if Int64(postInfo.valueForString(key: CUserId)) == appDelegate.loginUser?.user_id{
                        self?.btnMoreCLK(indexPath.row, postInfo)
                    }else{
                        self?.btnReportCLK(postInfo)
                    }
                }
                
                cell.btnProfileImg.touchUpInside { [weak self] (sender) in
                    guard let _ = self else { return }
                    appDelegate.moveOnProfileScreenNew(postInfo.valueForString(key: CUserId), postInfo.valueForString(key: CUsermailID), self)
                }
                
                cell.btnUserName.touchUpInside { [weak self] (sender) in
                    guard let _ = self else { return }
                    appDelegate.moveOnProfileScreenNew(postInfo.valueForString(key: CUserId), postInfo.valueForString(key: CUsermailID), self)
                }
                
                cell.btnShare.touchUpInside { [weak self] (sender) in
                    guard let _ = self else { return }
                    let sharePost = SharePostHelper(controller: self, dataSet: postInfo)
                    sharePost.shareURL = postInfo.valueForString(key: CShare_url)
                    sharePost.presentShareActivity()
                }
                cell.btnIconShare.touchUpInside { [weak self] (sender) in
                    guard let _ = self else { return }
                    let sharePost = SharePostHelper(controller: self, dataSet: postInfo)
                    sharePost.shareURL = postInfo.valueForString(key: CShare_url)
                    sharePost.presentShareActivity()
                }
                // .... LOAD MORE DATA HERE
                if indexPath == tblEvents.lastIndexPath() && !self.isLoadMoreCompleted{
                    
                    if isSelectedFilter == true {
                        self.getPostListFromServerFilter()
                    }else {
                        self.getPostListFromServer(showLoader: false)
                    }
//                    self.getPostListFromServer(showLoader: false)
                }
                
                return cell
            }
            break
        case CStaticEventIdNew:
            //            6-event
            if postInfo.valueForString(key: CImage).isBlank{
                
                // let isSharedPost = postInfo.valueForInt(key: CIsSharedPost)
                let isshared = 0
                if isshared == 1{
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeSharedEventsCell", for: indexPath) as? HomeSharedEventsCell {
                        cell.homeEventDataSetup(postInfo)
                        
                        cell.onChangeEventStatus = { [weak self] (action) in
                            self?.btnInterestedNotInterestedMayBeCLK(action, indexPath)
                        }
                        
                        cell.btnLikesCount.touchUpInside { [weak self] (sender) in
                            guard let _ = self else { return }
                            self?.btnLikesCountCLK(postInfo.valueForInt(key: CId))
                        }
                        
                        cell.btnMore.touchUpInside { [weak self] (sender) in
                            guard let _ = self else { return }
                            let userID = (postInfo[CSharedPost] as? [String:Any] ?? [:])[CUserId] as? Int64 ?? 0
                            if userID == appDelegate.loginUser?.user_id{
                                self?.btnSharedMoreCLK(indexPath.row, postInfo)
                            }else{
                                self?.btnSharedReportCLK(postInfo: postInfo)
                            }
                        }
                        
                        cell.btnSharedProfileImg.touchUpInside { [weak self] (sender) in
                            guard let _ = self else { return }
                            if let userID = (postInfo[CSharedPost] as? [String:Any] ?? [:])[CUserId] as? Int {
                                appDelegate.moveOnProfileScreenNew(postInfo.valueForString(key: CUserId), postInfo.valueForString(key: CUsermailID), self)
                            }
                        }
                        
                        cell.btnSharedUserName.touchUpInside { [weak self] (sender) in
                            guard let _ = self else { return }
                            if let userID = (postInfo[CSharedPost] as? [String:Any] ?? [:])[CUserId] as? Int {
                                appDelegate.moveOnProfileScreenNew(postInfo.valueForString(key: CUserId), postInfo.valueForString(key: CUsermailID), self)
                            }
                        }
                        cell.btnProfileImg.touchUpInside { [weak self] (sender) in
                            guard let _ = self else { return }
                            appDelegate.moveOnProfileScreenNew(postInfo.valueForString(key: CUserId), postInfo.valueForString(key: CUsermailID), self)
                        }
                        
                        cell.btnUserName.touchUpInside { [weak self] (sender) in
                            guard let _ = self else { return }
                            appDelegate.moveOnProfileScreenNew(postInfo.valueForString(key: CUserId), postInfo.valueForString(key: CUsermailID), self)
                        }
                        
                        cell.btnShare.touchUpInside { [weak self] (sender) in
                            guard let _ = self else { return }
                            let sharePost = SharePostHelper(controller: self, dataSet: postInfo)
                            sharePost.shareURL = postInfo.valueForString(key: CShare_url)
                            sharePost.presentShareActivity()
                        }
                        cell.btnIconShare.touchUpInside { [weak self] (sender) in
                            guard let _ = self else { return }
                            let sharePost = SharePostHelper(controller: self, dataSet: postInfo)
                            sharePost.shareURL = postInfo.valueForString(key: CShare_url)
                            sharePost.presentShareActivity()
                        }
                        // .... LOAD MORE DATA HERE
                        if indexPath == tblEvents.lastIndexPath() && !self.isLoadMoreCompleted{
                            
                            if isSelectedFilter == true {
                                self.getPostListFromServerFilter()
                            }else {
                                self.getPostListFromServer(showLoader: false)
                            }
//                            self.getPostListFromServer(showLoader: false)
                        }
                        
                        return cell
                    }
                }
                
                if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeEventImageTblCell", for: indexPath) as? HomeEventImageTblCell {
                    cell.isLikesHomePage = true
                    cell.homeEventDataSetup(postInfo)
                    
                    cell.onChangeEventStatus = { [weak self] (action) in
                        self?.btnInterestedNotInterestedMayBeCLK(action, indexPath)
                    }
                    
                    cell.btnLikesCount.touchUpInside { [weak self] (sender) in
                        guard let _ = self else { return }
                        self?.btnLikesCountCLK(postInfo.valueForString(key: CPostId).toInt)
                    }
                    
                    cell.btnMore.touchUpInside { [weak self] (sender) in
                        guard let _ = self else { return }
                        if Int64(postInfo.valueForString(key: CUserId)) == appDelegate.loginUser?.user_id{
                            self?.btnMoreCLK(indexPath.row, postInfo)
                        }else{
                            self?.btnReportCLK(postInfo)
                        }
                    }
                    
                    cell.btnProfileImg.touchUpInside { [weak self] (sender) in
                        guard let _ = self else { return }
                        appDelegate.moveOnProfileScreenNew(postInfo.valueForString(key: CUserId), postInfo.valueForString(key: CUsermailID), self)
                    }
                    
                    cell.btnUserName.touchUpInside { [weak self] (sender) in
                        guard let _ = self else { return }
                        appDelegate.moveOnProfileScreenNew(postInfo.valueForString(key: CUserId), postInfo.valueForString(key: CUsermailID), self)
                    }
                    
                    cell.btnShare.touchUpInside { [weak self] (sender) in
                        guard let _ = self else { return }
                        let sharePost = SharePostHelper(controller: self, dataSet: postInfo)
                        sharePost.shareURL = postInfo.valueForString(key: CShare_url)
                        sharePost.presentShareActivity()
                    }
                    cell.btnIconShare.touchUpInside { [weak self] (sender) in
                        guard let _ = self else { return }
                        let sharePost = SharePostHelper(controller: self, dataSet: postInfo)
                        sharePost.shareURL = postInfo.valueForString(key: CShare_url)
                        sharePost.presentShareActivity()
                    }
                    // .... LOAD MORE DATA HERE
                    if indexPath == tblEvents.lastIndexPath() && !self.isLoadMoreCompleted{
                        
                        if isSelectedFilter == true {
                            self.getPostListFromServerFilter()
                        }else {
                            self.getPostListFromServer(showLoader: false)
                        }
//                        self.getPostListFromServer(showLoader: false)
                    }
                    
                    return cell
                }
            }else{
                let isshared = 0
                if isshared == 1{
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeSharedEventImageTblCell", for: indexPath) as? HomeSharedEventImageTblCell {
                        cell.homeEventDataSetup(postInfo)
                        
                        cell.btnLikesCount.touchUpInside { [weak self] (sender) in
                            guard let _ = self else { return }
                            self?.btnLikesCountCLK(postInfo.valueForInt(key: CId))
                        }
                        cell.onChangeEventStatus = { [weak self] (action) in
                            self?.btnInterestedNotInterestedMayBeCLK(action, indexPath)
                        }
                        
                        cell.btnMore.touchUpInside { [weak self] (sender) in
                            guard let _ = self else { return }
                            let userID = (postInfo[CSharedPost] as? [String:Any] ?? [:])[CUserId] as? Int64 ?? 0
                            if userID == appDelegate.loginUser?.user_id{
                                self?.btnSharedMoreCLK(indexPath.row, postInfo)
                            }else{
                                self?.btnSharedReportCLK(postInfo: postInfo)
                            }
                        }
                        
                        cell.btnSharedProfileImg.touchUpInside { [weak self] (sender) in
                            guard let _ = self else { return }
                            if let userID = (postInfo[CSharedPost] as? [String:Any] ?? [:])[CUserId] as? Int {
                                appDelegate.moveOnProfileScreenNew(postInfo.valueForString(key: CUserId), postInfo.valueForString(key: CUsermailID), self)
                            }
                        }
                        
                        cell.btnSharedUserName.touchUpInside { [weak self] (sender) in
                            guard let _ = self else { return }
                            if let userID = (postInfo[CSharedPost] as? [String:Any] ?? [:])[CUserId] as? Int {
                                appDelegate.moveOnProfileScreenNew(postInfo.valueForString(key: CUserId), postInfo.valueForString(key: CUsermailID), self)
                            }
                        }
                        
                        cell.btnProfileImg.touchUpInside { [weak self] (sender) in
                            guard let _ = self else { return }
                            appDelegate.moveOnProfileScreenNew(postInfo.valueForString(key: CUserId), postInfo.valueForString(key: CUsermailID), self)
                        }
                        
                        cell.btnUserName.touchUpInside { [weak self] (sender) in
                            guard let _ = self else { return }
                            appDelegate.moveOnProfileScreenNew(postInfo.valueForString(key: CUserId), postInfo.valueForString(key: CUsermailID), self)
                        }
                        
                        cell.btnShare.touchUpInside { [weak self] (sender) in
                            guard let _ = self else { return }
                            let sharePost = SharePostHelper(controller: self, dataSet: postInfo)
                            sharePost.shareURL = postInfo.valueForString(key: CShare_url)
                            sharePost.presentShareActivity()
                        }
                        cell.btnIconShare.touchUpInside { [weak self] (sender) in
                            guard let _ = self else { return }
                            let sharePost = SharePostHelper(controller: self, dataSet: postInfo)
                            sharePost.shareURL = postInfo.valueForString(key: CShare_url)
                            sharePost.presentShareActivity()
                        }
                        // .... LOAD MORE DATA HERE
                        if indexPath == tblEvents.lastIndexPath() && !self.isLoadMoreCompleted{
                            
                            if isSelectedFilter == true {
                                self.getPostListFromServerFilter()
                            }else {
                                self.getPostListFromServer(showLoader: false)
                            }
//                            self.getPostListFromServer(showLoader: false)
                        }
                        
                        return cell
                    }
                }
                if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeEventImageTblCell", for: indexPath) as? HomeEventImageTblCell {
                    cell.isLikesHomePage = true
                    cell.homeEventDataSetup(postInfo)
                    cell.btnLikesCount.touchUpInside { [weak self] (sender) in
                        guard let _ = self else { return }
                        self?.btnLikesCountCLK(postInfo.valueForString(key: CPostId).toInt)
                    }
                    cell.onChangeEventStatus = { [weak self] (action) in
                        self?.btnInterestedNotInterestedMayBeCLK(action, indexPath)
                    }
                    
                    cell.btnMore.touchUpInside { [weak self] (sender) in
                        guard let _ = self else { return }
                        if Int64(postInfo.valueForString(key: CUserId)) == appDelegate.loginUser?.user_id{
                            self?.btnMoreCLK(indexPath.row, postInfo)
                        }else{
                            self?.btnReportCLK(postInfo)
                        }
                    }
                    
                    cell.btnProfileImg.touchUpInside { [weak self] (sender) in
                        guard let _ = self else { return }
                        appDelegate.moveOnProfileScreenNew(postInfo.valueForString(key: CUserId), postInfo.valueForString(key: CUsermailID), self)
                    }
                    
                    cell.btnUserName.touchUpInside { [weak self] (sender) in
                        guard let _ = self else { return }
                        appDelegate.moveOnProfileScreenNew(postInfo.valueForString(key: CUserId), postInfo.valueForString(key: CUsermailID), self)
                    }
                    
                    cell.btnShare.touchUpInside { [weak self] (sender) in
                        guard let _ = self else { return }
                        let sharePost = SharePostHelper(controller: self, dataSet: postInfo)
                        sharePost.shareURL = postInfo.valueForString(key: CShare_url)
                        sharePost.presentShareActivity()
                    }
                    cell.btnIconShare.touchUpInside { [weak self] (sender) in
                        guard let _ = self else { return }
                        let sharePost = SharePostHelper(controller: self, dataSet: postInfo)
                        sharePost.shareURL = postInfo.valueForString(key: CShare_url)
                        sharePost.presentShareActivity()
                    }
                    // .... LOAD MORE DATA HERE
                    if indexPath == tblEvents.lastIndexPath() && !self.isLoadMoreCompleted{
                        
                        if isSelectedFilter == true {
                            self.getPostListFromServerFilter()
                        }else {
                            self.getPostListFromServer(showLoader: false)
                        }
//                        self.getPostListFromServer(showLoader: false)
                    }
                    
                    return cell
                }
            }
            break
            
        case CStaticPollIdNew: // Poll Cell....
            let isshared = 0
            if isshared == 1{
                if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeSharedPollTblCell", for: indexPath) as? HomeSharedPollTblCell {
                    
                    cell.homePollDataSetup(postInfo)
                    
                    cell.btnLikesCount.touchUpInside { [weak self] (sender) in
                        guard let _ = self else { return }
                        self?.btnLikesCountCLK(postInfo.valueForInt(key: CId))
                    }
                    cell.btnMore.tag = indexPath.row
                    cell.onMorePressed = { [weak self] (index) in
                        guard let _ = self else { return }
                        let sharePostData = postInfo[CSharedPost] as? [String:Any] ?? [:]
                        let userID = sharePostData[CUserId] as? Int64 ?? 0
                        if userID == appDelegate.loginUser?.user_id{
                            self?.presentActionsheetWithOneButton(actionSheetTitle: nil, actionSheetMessage: nil, btnOneTitle: CBtnDelete, btnOneStyle: .default) { [weak self] (alert) in
                                guard let _ = self else { return }
                                let postID = sharePostData[CId] as? Int ?? 0
                                self?.deletePost(postID, index)
                            }
                        }else{
                            //self?.btnReportCLK(postInfo)
                            self?.btnSharedReportCLK(postInfo: postInfo)
                        }
                    }
                    
                    cell.btnSharedProfileImg.touchUpInside { [weak self] (sender) in
                        guard let _ = self else { return }
                        if let userID = (postInfo[CSharedPost] as? [String:Any] ?? [:])[CUserId] as? Int {
                            appDelegate.moveOnProfileScreenNew(postInfo.valueForString(key: CUserId), postInfo.valueForString(key: CUsermailID), self)
                        }
                    }
                    
                    cell.btnSharedUserName.touchUpInside { [weak self] (sender) in
                        guard let _ = self else { return }
                        if let userID = (postInfo[CSharedPost] as? [String:Any] ?? [:])[CUserId] as? Int {
                            appDelegate.moveOnProfileScreenNew(postInfo.valueForString(key: CUserId), postInfo.valueForString(key: CUsermailID), self)
                        }
                    }
                    
                    cell.btnProfileImg.touchUpInside { [weak self] (sender) in
                        guard let _ = self else { return }
                        appDelegate.moveOnProfileScreenNew(postInfo.valueForString(key: CUserId), postInfo.valueForString(key: CUsermailID), self)
                    }
                    
                    cell.btnUserName.touchUpInside { [weak self] (sender) in
                        guard let _ = self else { return }
                        appDelegate.moveOnProfileScreenNew(postInfo.valueForString(key: CUserId), postInfo.valueForString(key: CUsermailID), self)
                    }
                    
                    cell.btnShare.touchUpInside { [weak self] (sender) in
                        guard let _ = self else { return }
                        let sharePost = SharePostHelper(controller: self, dataSet: postInfo)
                        sharePost.shareURL = postInfo.valueForString(key: CShare_url)
                        sharePost.presentShareActivity()
                    }
                    cell.btnIconShare.touchUpInside { [weak self] (sender) in
                        guard let _ = self else { return }
                        let sharePost = SharePostHelper(controller: self, dataSet: postInfo)
                        sharePost.shareURL = postInfo.valueForString(key: CShare_url)
                        sharePost.presentShareActivity()
                    }
                    // .... LOAD MORE DATA HERE
                    if indexPath == tblEvents.lastIndexPath() && !self.isLoadMoreCompleted{
                        
                        if isSelectedFilter == true {
                            self.getPostListFromServerFilter()
                        }else {
                            self.getPostListFromServer(showLoader: false)
                        }
//                        self.getPostListFromServer(showLoader: false)
                    }
                    
                    return cell
                }
            }
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: "HomePollTblCell", for: indexPath) as? HomePollTblCell {
                
                cell.isLikesHomePage = true
                cell.homePollDataSetup(postInfo, isSelected: false)
                cell.btnLikesCount.touchUpInside { [weak self] (sender) in
                    guard let _ = self else { return }
                    self?.btnLikesCountCLK(postInfo.valueForString(key: "post_id").toInt)
                }
                cell.btnMore.tag = indexPath.row
                cell.onMorePressed = { [weak self] (index) in
                    guard let _ = self else { return }
                    let postData = self?.arrPostList[index] ?? [:]
                    if Int64(postData.valueForString(key: CUserId)) == appDelegate.loginUser?.user_id{
                        self?.presentActionsheetWithOneButton(actionSheetTitle: nil, actionSheetMessage: nil, btnOneTitle: CBtnDelete, btnOneStyle: .default) { [weak self] (alert) in
                            guard let _ = self else { return }
                            let postId = postData.valueForInt(key: CId) ?? 0
                            self?.deletePost(postId, index)
                        }
                    }else{
                        self?.btnReportCLK(postData)
                    }
                }
                cell.btnProfileImg.touchUpInside { [weak self] (sender) in
                    guard let _ = self else { return }
                    appDelegate.moveOnProfileScreenNew(postInfo.valueForString(key: CUserId), postInfo.valueForString(key: CUsermailID), self)
                }
                
                cell.btnUserName.touchUpInside { [weak self] (sender) in
                    guard let _ = self else { return }
                    appDelegate.moveOnProfileScreenNew(postInfo.valueForString(key: CUserId), postInfo.valueForString(key: CUsermailID), self)
                }
                
                cell.btnShare.touchUpInside { [weak self] (sender) in
                    guard let _ = self else { return }
                    let sharePost = SharePostHelper(controller: self, dataSet: postInfo)
                    sharePost.shareURL = postInfo.valueForString(key: CShare_url)
                    sharePost.presentShareActivity()
                }
                cell.btnIconShare.touchUpInside { [weak self] (sender) in
                    guard let _ = self else { return }
                    let sharePost = SharePostHelper(controller: self, dataSet: postInfo)
                    sharePost.shareURL = postInfo.valueForString(key: CShare_url)
                    sharePost.presentShareActivity()
                }
                // .... LOAD MORE DATA HERE
                if indexPath == tblEvents.lastIndexPath() && !self.isLoadMoreCompleted{
                    if self.isSelectedFilter == true {
                        
                    }else {
                        self.getPostListFromServer(showLoader: false)
                    }
                    
                }
                return cell
            }
            break
        default:
            break
        }
        return tableView.tableViewDummyCell()
    }
    
    
    @objc func galleryConnected(sender: UIButton){
        if let galleryListVC = CStoryboardHome.instantiateViewController(withIdentifier: "AddMediaViewController") as? AddMediaViewController{
            galleryListVC.imagePostType = .addImagePost
            self.navigationController?.pushViewController(galleryListVC, animated: true)
        }
    }
    
    @objc func articleConnected(sender: UIButton){
        if let addArticleVC = CStoryboardHome.instantiateViewController(withIdentifier: "AddArticleViewController") as? AddArticleViewController{
            addArticleVC.articleType = .addArticle
            self.navigationController?.pushViewController(addArticleVC, animated: true)
        }
    }
    
    @objc func cripyConnected(sender: UIButton){
        if let addChirpyVC = CStoryboardHome.instantiateViewController(withIdentifier: "AddChirpyViewController") as? AddChirpyViewController{
            addChirpyVC.chirpyType = .addChirpy
            self.navigationController?.pushViewController(addChirpyVC, animated: true)
        }
    }
    @objc func eventConnected(sender: UIButton){
        if let addEventVC = CStoryboardEvent.instantiateViewController(withIdentifier: "AddEventViewController") as? AddEventViewController{
            addEventVC.eventType = .addEvent
            self.navigationController?.pushViewController(addEventVC, animated: true)
        }
    }
    @objc func pollConnected(sender: UIButton){
        if let AddPollVC = CStoryboardPoll.instantiateViewController(withIdentifier: "AddPollViewController") as? AddPollViewController{
            //            AddPollVC.shoutsType = .addShouts
            self.navigationController?.pushViewController(AddPollVC, animated: true)
        }
    }
    @objc func forumConnected(sender: UIButton){
        if let addForumVC = CStoryboardHome.instantiateViewController(withIdentifier: "AddForumViewController") as? AddForumViewController{
            addForumVC.forumType = .addForum
            self.navigationController?.pushViewController(addForumVC, animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0{
            return
        }
        if indexPath.section == 1{
            return
        }
        
        if indexPath.section == 2 {
            return
        }
        
        let row = indexPath.row
        print("selectdRow\(row),")
        
        guard arrPostList[indexPath.row].count != 0 else { return}
        
        //        guard arrPostList[indexPath.row].count != 0 else { return}
        let postInfo = arrPostList[row]
        let postId = postInfo.valueForString(key: "post_id")
        //        let isSharedPost = postInfo.valueForInt(key: CIsSharedPost)
        //        let isPostDeleted = postInfo.valueForInt(key: CIsPostDeleted)
        let isshared = 0
        let isdelete = 0
        if isdelete == 1{
            let sharePostData = postInfo[CSharedPost] as? [String:Any] ?? [:]
            let sharedPostId = sharePostData[CId] as? Int ?? 0
            guard let viewcontroller = CStoryboardSharedPost.instantiateViewController(withIdentifier: "PostDeleteDetailViewController") as? PostDeleteDetailViewController else {
                return
            }
            viewcontroller.postID = sharedPostId
            self.navigationController?.pushViewController(viewcontroller, animated: true)
            return
        }
        switch postInfo.valueForString(key: CPostTypeNew) {
        
        case CStaticArticleIdNew:
            
            if isshared == 1{
                let sharePostData = postInfo[CSharedPost] as? [String:Any] ?? [:]
                let sharedPostId = sharePostData[CId] as? Int ?? 0
                guard let viewcontroller = CStoryboardSharedPost.instantiateViewController(withIdentifier: "ArticleSharedDetailViewController") as? ArticleSharedDetailViewController else {
                    return
                }
                viewcontroller.articleID = sharedPostId
                self.navigationController?.pushViewController(viewcontroller, animated: true)
                break
            }
            if let viewArticleVC = CStoryboardHome.instantiateViewController(withIdentifier: "ArticleDetailViewController") as? ArticleDetailViewController {
                viewArticleVC.isLikesHomePage = true
                viewArticleVC.articleID = postId.toInt
                viewArticleVC.articleInformation = postInfo
                self.navigationController?.pushViewController(viewArticleVC, animated: true)
            }
            break
            
        case CStaticGalleryIdNew:
            let isshared = 0
            if isshared == 1{
                let sharePostData = postInfo[CSharedPost] as? [String:Any] ?? [:]
                let sharedPostId = sharePostData[CId] as? Int ?? 0
                guard let viewcontroller = CStoryboardSharedPost.instantiateViewController(withIdentifier: "ImageSharedDetailViewController") as? ImageSharedDetailViewController else {
                    return
                }
                viewcontroller.imgPostId = sharedPostId
                self.navigationController?.pushViewController(viewcontroller, animated: true)
                break
            }
            if let imageDetailsVC = CStoryboardImage.instantiateViewController(withIdentifier: "ImageDetailViewController") as? ImageDetailViewController {
                imageDetailsVC.isLikesHomePage = true
                imageDetailsVC.galleryInfo = postInfo
                imageDetailsVC.imgPostId = postId.toInt
                self.navigationController?.pushViewController(imageDetailsVC, animated: true)
            }
            break
            
        case CStaticChirpyIdNew:
            
            if postInfo.valueForString(key: CImage).isBlank{
                let isshared = 0
                if isshared == 1{
                    let sharePostData = postInfo[CSharedPost] as? [String:Any] ?? [:]
                    let sharedPostId = sharePostData[CId] as? Int ?? 0
                    guard let viewcontroller = CStoryboardSharedPost.instantiateViewController(withIdentifier: "ChirpySharedDetailsViewController") as? ChirpySharedDetailsViewController else {
                        return
                    }
                    viewcontroller.chirpyID = sharedPostId
                    self.navigationController?.pushViewController(viewcontroller, animated: true)
                    break
                }
                if let chirpyDetailsVC = CStoryboardHome.instantiateViewController(withIdentifier: "ChirpyImageDetailsViewController") as? ChirpyImageDetailsViewController{
                    chirpyDetailsVC.isLikesHomePage = true
                    chirpyDetailsVC.chirpyID = postId.toInt
                    chirpyDetailsVC.chirpyInformation = postInfo
                    self.navigationController?.pushViewController(chirpyDetailsVC, animated: true)
                }
            }else{
                let isshared = 0
                if isshared == 1{
                    let sharePostData = postInfo[CSharedPost] as? [String:Any] ?? [:]
                    let sharedPostId = sharePostData[CId] as? Int ?? 0
                    guard let viewcontroller = CStoryboardSharedPost.instantiateViewController(withIdentifier: "ChirpySharedImageDetailsViewController") as? ChirpySharedImageDetailsViewController else {
                        return
                    }
                    viewcontroller.chirpyID = sharedPostId
                    self.navigationController?.pushViewController(viewcontroller, animated: true)
                    break
                }
                if let chirpyImageVC = CStoryboardHome.instantiateViewController(withIdentifier: "ChirpyImageDetailsViewController") as? ChirpyImageDetailsViewController{
                    chirpyImageVC.isLikesHomePage = true
                    chirpyImageVC.chirpyID = postId.toInt
                    chirpyImageVC.chirpyInformation = postInfo
                    self.navigationController?.pushViewController(chirpyImageVC, animated: true)
                }
            }
        case CStaticShoutIdNew:
            
            let isshared = 0
            let sharePostData = postInfo[CSharedPost] as? [String:Any] ?? [:]
            if isshared == 1{
                let sharePostData = postInfo[CSharedPost] as? [String:Any] ?? [:]
                let sharedPostId = sharePostData[CId] as? Int ?? 0
                guard let viewcontroller = CStoryboardSharedPost.instantiateViewController(withIdentifier: "ShoutsSharedDetailViewController") as? ShoutsSharedDetailViewController else {
                    return
                }
                viewcontroller.shoutID = sharedPostId
                self.navigationController?.pushViewController(viewcontroller, animated: true)
                break
            }
            if let shoutsDetailsVC = CStoryboardHome.instantiateViewController(withIdentifier: "ShoutsDetailViewController") as? ShoutsDetailViewController{
                shoutsDetailsVC.isLikesHomePage = true
                shoutsDetailsVC.shoutInformations = postInfo
                shoutsDetailsVC.shoutID = postId.toInt
                self.navigationController?.pushViewController(shoutsDetailsVC, animated: true)
            }
            break
            
        case CStaticForumIdNew:
            
            let isshared = 0
            if isshared == 1{
                let sharePostData = postInfo[CSharedPost] as? [String:Any] ?? [:]
                let sharedPostId = sharePostData[CId] as? Int ?? 0
                guard let viewcontroller = CStoryboardSharedPost.instantiateViewController(withIdentifier: "ForumSharedDetailViewController") as? ForumSharedDetailViewController else {
                    return
                }
                viewcontroller.forumID = sharedPostId
                self.navigationController?.pushViewController(viewcontroller, animated: true)
                break
            }
            if let forumDetailsVC = CStoryboardHome.instantiateViewController(withIdentifier: "ForumDetailViewController") as? ForumDetailViewController{
                forumDetailsVC.isLikesHomePage = true
                forumDetailsVC.forumInformation = postInfo
                forumDetailsVC.forumID = postId.toInt
                self.navigationController?.pushViewController(forumDetailsVC, animated: true)
            }
            break
            
        case CStaticEventIdNew:
            if postInfo.valueForString(key: CImage).isBlank{
                
                let isshared = 0
                if isshared == 1{
                    let sharePostData = postInfo[CSharedPost] as? [String:Any] ?? [:]
                    let sharedPostId = sharePostData[CId] as? Int ?? 0
                    guard let viewcontroller = CStoryboardSharedPost.instantiateViewController(withIdentifier: "EventSharedDetailViewController") as? EventSharedDetailViewController else {
                        return
                    }
                    viewcontroller.postID = sharedPostId
                    self.navigationController?.pushViewController(viewcontroller, animated: true)
                    break
                }
                
                if let eventDetailsVC = CStoryboardEvent.instantiateViewController(withIdentifier: "EventDetailImageViewController") as? EventDetailImageViewController {
                    eventDetailsVC.isLikesHomePage = true
                    eventDetailsVC.eventInfo = postInfo
                    eventDetailsVC.postID = postId.toInt
                    self.navigationController?.pushViewController(eventDetailsVC, animated: true)
                }
            }else{
                let isSharedPost = postInfo.valueForInt(key: CIsSharedPost)
                if isSharedPost == 1{
                    let sharePostData = postInfo[CSharedPost] as? [String:Any] ?? [:]
                    let sharedPostId = sharePostData[CId] as? Int ?? 0
                    guard let viewcontroller = CStoryboardSharedPost.instantiateViewController(withIdentifier: "EventSharedDetailImageViewController") as? EventSharedDetailImageViewController else {
                        return
                    }
                    viewcontroller.postID = sharedPostId
                    self.navigationController?.pushViewController(viewcontroller, animated: true)
                    break
                }
                if let eventDetailsVC = CStoryboardEvent.instantiateViewController(withIdentifier: "EventDetailImageViewController") as? EventDetailImageViewController {
                    // eventDetailsVC.postID = postInfo.valueForInt(key: CId)
                    eventDetailsVC.isLikesHomePage = true
                    eventDetailsVC.eventInfo = postInfo
                    eventDetailsVC.postID = postId.toInt
                    self.navigationController?.pushViewController(eventDetailsVC, animated: true)
                }
            }
            
            break
        case CStaticPollIdNew: // Poll Cell....
            
            let isshared = 0
            if isshared == 1{
                let sharePostData = postInfo[CSharedPost] as? [String:Any] ?? [:]
                let sharedPostId = sharePostData[CId] as? Int ?? 0
                guard let viewcontroller = CStoryboardSharedPost.instantiateViewController(withIdentifier: "PollSharedDetailsViewController") as? PollSharedDetailsViewController else {
                    return
                }
                viewcontroller.pollID = sharedPostId
                self.navigationController?.pushViewController(viewcontroller, animated: true)
                break
            }
            if let viewArticleVC = CStoryboardPoll.instantiateViewController(withIdentifier: "PollDetailsViewController") as? PollDetailsViewController {
                viewArticleVC.isLikesHomePage = true
                viewArticleVC.pollInformation = postInfo
                
                viewArticleVC.pollID = postId.toInt
                viewArticleVC.pollfromHomeview = "home"
                self.navigationController?.pushViewController(viewArticleVC, animated: true)
            }
            break
        default:
            break
        }
    }
}

// MARK:- --------  TableView Cells Action
extension HomeViewController {
    fileprivate func btnInterestedNotInterestedMayBeCLK(_ type : Int?, _ indexpath : IndexPath?){
        
        var postInfo = arrPostList[indexpath!.row]
        if type != postInfo.valueForInt(key: CIsInterested) {
            
            let totalIntersted = postInfo.valueForString(key: "yes_count")
            let totalNotIntersted = postInfo.valueForString(key:"no_count")
            let totalMaybe = postInfo.valueForString(key: "maybe_count")
            
            switch postInfo.valueForInt(key: CIsInterested) {
            case CTypeInterested:
                postInfo["yes_count"] = totalIntersted.toInt ?? 0 - 1
                break
            case CTypeNotInterested:
                postInfo["no_count"] = totalNotIntersted.toInt ?? 0 - 1
                break
            case CTypeMayBeInterested:
                postInfo["maybe_count"] = totalMaybe.toInt ?? 0 - 1
                break
            default:
                break
            }
            postInfo[CIsInterested] = type
            
            switch type {
            case CTypeInterested:
                postInfo["yes_count"] = totalIntersted.toInt ?? 0 - 1
                break
            case CTypeNotInterested:
                postInfo["no_count"] = totalNotIntersted.toInt ?? 0 - 1
                break
            case CTypeMayBeInterested:
                postInfo["maybe_count"] = totalMaybe.toInt ?? 0 - 1
                break
            default:
                break
            }
            let postId = postInfo.valueForString(key: "post_id")
            _ = postInfo.valueForInt(key: CIsSharedPost)
            MIGeneralsAPI.shared().interestNotInterestMayBe(postId.toInt, type!, viewController: self)
            
        }
        
    }
    
    fileprivate func btnLikesCountCLK(_ postId : Int?){
        if let likeVC = CStoryboardGeneral.instantiateViewController(withIdentifier: "LikeViewController") as? LikeViewController{
            likeVC.postID = postId
            likeVC.postIDNew = postId?.description
            self.navigationController?.pushViewController(likeVC, animated: true)
        }
    }
    
    fileprivate func btnCommentCLK(_ postId : Int?){
        if let commentVC = CStoryboardGeneral.instantiateViewController(withIdentifier: "CommentViewController") as? CommentViewController{
            commentVC.postId = postId
            self.navigationController?.pushViewController(commentVC, animated: true)
        }
        
    }
    
    fileprivate func btnReportCLK(_ postInfo : [String : Any]?){
        
        self.presentActionsheetWithOneButton(actionSheetTitle: nil, actionSheetMessage: nil, btnOneTitle: CReport, btnOneStyle: .default) { [weak self] (alert) in
            guard let _ = self else { return }
            
            if let reportVC = CStoryboardGeneral.instantiateViewController(withIdentifier: "ReportViewController") as? ReportViewController {
                
                switch postInfo!.valueForString(key: CPostTypeNew) {
                case CStaticArticleIdNew:
                    reportVC.reportType = .reportArticle
                case CStaticGalleryIdNew:
                    reportVC.reportType = .reportGallery
                case CStaticChirpyIdNew:
                    reportVC.reportType = .reportChirpy
                case CStaticShoutIdNew:
                    reportVC.reportType = .reportShout
                case CStaticForumIdNew:
                    reportVC.reportType = .reportForum
                case CStaticEventIdNew:
                    reportVC.reportType = .reportEvent
                case CStaticPollIdNew:
                    reportVC.reportType = .reportPoll
                default:
                    break
                }
                
                reportVC.userID = postInfo?.valueForInt(key: CUserId)
                reportVC.reportID = postInfo?.valueForInt(key: CId)
                reportVC.post_id = postInfo?.valueForString(key: "post_id")
                reportVC.reportIDNEW = postInfo?.valueForString(key: "user_id")
                self?.navigationController?.pushViewController(reportVC, animated: true)
            }
        }
    }
    
    fileprivate func btnSharedMoreCLK(_ index : Int?, _ postInfo : [String : Any]){
        let sharePostData = postInfo[CSharedPost] as? [String:Any] ?? [:]
        let postId = sharePostData[CId] as? Int ?? 0
        let postType = postInfo.valueForInt(key: CPostType)
        let currentDateTime = Date().timeIntervalSince1970
        if let endDateTime = postInfo.valueForDouble(key: CEvent_End_Date), (postType == CStaticEventId), (Double(currentDateTime) > endDateTime) {
            self.presentActionsheetWithOneButton(actionSheetTitle: nil, actionSheetMessage: nil, btnOneTitle: CBtnDelete, btnOneStyle: .default) { [weak self] (onActionClicked) in
                
                guard let `self` = self else { return }
                self.deletePost(postId, index ?? 0)
            }
        } else {
            
            self.presentActionsheetWithTwoButtons(actionSheetTitle: nil, actionSheetMessage: nil, btnOneTitle: CBtnEdit, btnOneStyle: .default, btnOneTapped: { [weak self](alert) in
                guard let _ = self else { return }
                if let sharePost = CStoryboardSharedPost.instantiateViewController(withIdentifier: "SharePostViewController") as? SharePostViewController{
                    sharePost.postData = postInfo
                    sharePost.isFromEdit = true
                    self?.navigationController?.pushViewController(sharePost, animated: true)
                }
            }, btnTwoTitle: CBtnDelete, btnTwoStyle: .default) { [weak self](alert) in
                guard let _ = self else { return }
                self?.deletePost(postId, index!)
            }
        }
    }
    
    fileprivate func btnSharedReportCLK(postInfo : [String : Any]?){
        
        let sharePostData = postInfo?[CSharedPost] as? [String:Any] ?? [:]
        self.presentActionsheetWithOneButton(actionSheetTitle: nil, actionSheetMessage: nil, btnOneTitle: CReport, btnOneStyle: .default) { [weak self] (alert) in
            guard let _ = self else { return }
            if let reportVC = CStoryboardGeneral.instantiateViewController(withIdentifier: "ReportViewController") as? ReportViewController {
                switch postInfo!.valueForInt(key: CPostType) {
                case CStaticArticleId:
                    reportVC.reportType = .reportArticle
                case CStaticGalleryId:
                    reportVC.reportType = .reportGallery
                case CStaticChirpyId:
                    reportVC.reportType = .reportChirpy
                case CStaticShoutId:
                    reportVC.reportType = .reportShout
                case CStaticForumId:
                    reportVC.reportType = .reportForum
                case CStaticEventId:
                    reportVC.reportType = .reportEvent
                case CStaticPollId:
                    reportVC.reportType = .reportPoll
                default:
                    reportVC.reportType = .reportSharedPost
                    break
                }
                reportVC.isSharedPost = true
                reportVC.userID = sharePostData.valueForInt(key: CUserId)
                reportVC.reportID = sharePostData.valueForInt(key: CId)
                reportVC.reportIDNEW = sharePostData.valueForString(key: "email")
                self?.navigationController?.pushViewController(reportVC, animated: true)
            }
        }
    }
    
    fileprivate func btnMoreCLK(_ index : Int?, _ postInfo : [String : Any]){
        let postId = postInfo.valueForInt(key: CId)
        
        let postType = postInfo.valueForInt(key: CPostType)
        let currentDateTime = Date().timeIntervalSince1970
        
        
        if let endDateTime = postInfo.valueForDouble(key: CEvent_End_Date), (postType == CStaticEventId), (Double(currentDateTime) > endDateTime) {
            
            self.presentActionsheetWithOneButton(actionSheetTitle: nil, actionSheetMessage: nil, btnOneTitle: CBtnDelete, btnOneStyle: .default) { [weak self] (onActionClicked) in
                
                guard let `self` = self else { return }
                self.deletePost(postId ?? 0, index ?? 0)
            }
        } else {
            
            self.presentActionsheetWithTwoButtons(actionSheetTitle: nil, actionSheetMessage: nil, btnOneTitle: CBtnEdit, btnOneStyle: .default, btnOneTapped: { [weak self](alert) in
                guard let _ = self else { return }
                switch postInfo.valueForInt(key: CPostType){
                case CStaticArticleId:
                    
                    if let addArticleVC = CStoryboardHome.instantiateViewController(withIdentifier: "AddArticleViewController") as? AddArticleViewController{
                        addArticleVC.articleType = .editArticle
                        addArticleVC.articleID = postId
                        self?.navigationController?.pushViewController(addArticleVC, animated: true)
                    }
                case CStaticGalleryId:
                    
                    if let galleryListVC = CStoryboardHome.instantiateViewController(withIdentifier: "AddMediaViewController") as? AddMediaViewController{
                        galleryListVC.imagePostType = .editImagePost
                        galleryListVC.imgPostId = postId
                        self?.navigationController?.pushViewController(galleryListVC, animated: true)
                    }
                    
                case CStaticChirpyId:
                    
                    if let addChirpyVC = CStoryboardHome.instantiateViewController(withIdentifier: "AddChirpyViewController") as? AddChirpyViewController{
                        addChirpyVC.chirpyType = .editChirpy
                        addChirpyVC.chirpyID = postId
                        self?.navigationController?.pushViewController(addChirpyVC, animated: true)
                    }
                case CStaticShoutId:
                    
                    if let createShoutsVC = CStoryboardHome.instantiateViewController(withIdentifier: "CreateShoutsViewController") as? CreateShoutsViewController{
                        createShoutsVC.shoutsType = .editShouts
                        createShoutsVC.shoutID = postId
                        self?.navigationController?.pushViewController(createShoutsVC, animated: true)
                    }
                    
                case CStaticForumId:
                    
                    if let addForumVC = CStoryboardHome.instantiateViewController(withIdentifier: "AddForumViewController") as? AddForumViewController{
                        addForumVC.forumType = .editForum
                        addForumVC.forumID = postId
                        self?.navigationController?.pushViewController(addForumVC, animated: true)
                    }
                    
                case CStaticEventId:
                    
                    if let addEventVC = CStoryboardEvent.instantiateViewController(withIdentifier: "AddEventViewController") as? AddEventViewController{
                        addEventVC.eventType = .editEvent
                        addEventVC.eventID = postId
                        self?.navigationController?.pushViewController(addEventVC, animated: true)
                    }
                default:
                    break
                }
                
            }, btnTwoTitle: CBtnDelete, btnTwoStyle: .default) { [weak self](alert) in
                guard let _ = self else { return }
                self?.deletePost(postId!, index!)
            }
        }
    }
}

// MARK:- -------- Add post
extension HomeViewController: PostTypeSelectionDelegate{
    
    func didSelectPostType(_ item: String) {
        btnAddPost.isHidden = false
        
        switch item {
        case CTypeArticle:
            // Articles CLK
            if let addArticleVC = CStoryboardHome.instantiateViewController(withIdentifier: "AddArticleViewController") as? AddArticleViewController{
                addArticleVC.articleType = .addArticle
                self.navigationController?.pushViewController(addArticleVC, animated: true)
            }
            
            break
        case CTypeForum :
            // Forum CLK
            if let addForumVC = CStoryboardHome.instantiateViewController(withIdentifier: "AddForumViewController") as? AddForumViewController{
                addForumVC.forumType = .addForum
                self.navigationController?.pushViewController(addForumVC, animated: true)
            }
            
            break
        case CGallery:
            // Image CLK
            if let galleryListVC = CStoryboardHome.instantiateViewController(withIdentifier: "AddMediaViewController") as? AddMediaViewController{
                galleryListVC.imagePostType = .addImagePost
                self.navigationController?.pushViewController(galleryListVC, animated: true)
            }
            break
        case CTypeEvent:
            // Event CLK
            if let addEventVC = CStoryboardEvent.instantiateViewController(withIdentifier: "AddEventViewController") as? AddEventViewController{
                addEventVC.eventType = .addEvent
                self.navigationController?.pushViewController(addEventVC, animated: true)
            }
            break
        case CTypeChirpy:
            // Chirpy CLK
            if let addChirpyVC = CStoryboardHome.instantiateViewController(withIdentifier: "AddChirpyViewController") as? AddChirpyViewController{
                addChirpyVC.chirpyType = .addChirpy
                self.navigationController?.pushViewController(addChirpyVC, animated: true)
            }
            break
        case CTypeShout:
            // Shouts CLK
            if let createShoutsVC = CStoryboardHome.instantiateViewController(withIdentifier: "CreateShoutsViewController") as? CreateShoutsViewController{
                createShoutsVC.shoutsType = .addShouts
                self.navigationController?.pushViewController(createShoutsVC, animated: true)
            }
            break
        case CTypePoll:
            // Add Poll
            if let AddPollVC = CStoryboardPoll.instantiateViewController(withIdentifier: "AddPollViewController") as? AddPollViewController{
                self.navigationController?.pushViewController(AddPollVC, animated: true)
            }
            break
        default:
            break
        }
    }
    
    func showAddPostView(){
        btnAddPost.isHidden = true
        let addPostView = HomeAddPostMenuView.initHomeAddPostMenuView()
        addPostView.delegate = self
        self.view.addSubview(addPostView)
        addPostView.showPostOption()
        
    }
}
// MARK:- -------- Action Event
extension HomeViewController{
    @objc fileprivate func btnFilterClicked(_ sender : UIBarButtonItem) {
        
        if let postFilterVC = CStoryboardProfile.instantiateViewController(withIdentifier: "ProfileFilterViewController") as? ProfileFilterViewController {
            
            postFilterVC.arrSelectedFilter = arrSelectedFilterOption
            
            postFilterVC.callbacks = { message in
                print("message\(message)")
                self.isSelectedFilter = message
                print("self.selectedFilter\(self.isSelectedFilter)")
            }
            postFilterVC.setBlock { [weak self](object, message) in
                guard let _ = self else { return }
                if let arrFitInfo = object as? [[String : Any]] {
                    if self?.apiTask?.state == URLSessionTask.State.running {
                        self?.apiTask?.cancel()
                    }
                    self?.arrSelectedFilterOption = arrFitInfo
                    self?.pageNumber = 1
                    self?.getPostListFromServerFilter()
                }
            }
            self.navigationController?.pushViewController(postFilterVC, animated: true)
        }
    }
    
    @objc fileprivate func btnTranslateClicked(_ sender : UIBarButtonItem) {
        if let langVC = CStoryboardLRF.instantiateViewController(withIdentifier: "SelectLanguageViewController") as? SelectLanguageViewController{
            langVC.isBackButton = true
            self.navigationController?.pushViewController(langVC, animated: true)
        }
    }
    
    //search Button Click
    
    @objc fileprivate func btnSearchClicked(_ sender : UIBarButtonItem) {
        if searchbtnNav.isSelected == true {
            issearchSelected = false
            searchbtnNav.isSelected = false
            tblEvents.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        }else {
            issearchSelected = true
            searchbtnNav.isSelected = true
            tblEvents.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        }
    }
    
    
    @IBAction func btnAddPostCLK(_ sender : UIButton){
        self.showAddPostView()
    }
}

extension HomeViewController{
    func showAlertMessate(){
        self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: "Detials updated successfully", btnOneTitle: CBtnOk, btnOneTapped: nil)
    }
    func showAlertMessageGroup(){
        self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageSelectContactGroupShout, btnOneTitle: CBtnOk, btnOneTapped: nil)
    }
    
    
}
