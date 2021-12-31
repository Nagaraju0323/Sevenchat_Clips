//
//  MyProfileViewController.swift
//  Sevenchats
//
//  Created by mac-0005 on 29/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class MyProfileViewController: ParentViewController {
    
    @IBOutlet var cnHeaderHight : NSLayoutConstraint!
    @IBOutlet var cnTblUserTopSpace : NSLayoutConstraint!
    @IBOutlet var tblUser : UITableView!
    
    var refreshControl = UIRefreshControl()
    var arrPostList = [[String : Any]]()
    var pageNumber = 1
    var apiTask : URLSessionTask?
    var isProfileUpdate:Bool?
    var imgName = ""
    var profileImgUrl = ""
    var coverImgUrl = ""
    var arrFriends = [[String : Any]]()
    var postTypeDelete = ""
    var dict = [String:Any]()
    fileprivate var arrSelectedFilterOption = [[String : Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Initialization()
        NotificationCenter.default.addObserver(self, selector: #selector(loadMyprofile), name: NSNotification.Name(rawValue: "loadMyprofile"), object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func loadList(){
            //load data here
            self.tblUser.reloadData()
        }
    
    // MARK:- ---------- Initialization
    
    func Initialization(){
        self.title = CNavMyProfile
        if IS_iPhone_X_Series{
            //cnHeaderHight.constant = 210
        }
        tblUser.estimatedRowHeight = 350;
        tblUser.rowHeight = UITableView.automaticDimension;
        tblUser.register(UINib(nibName: "HomeArticleCell", bundle: nil), forCellReuseIdentifier: "HomeArticleCell")
        tblUser.register(UINib(nibName: "HomeGalleryCell", bundle: nil), forCellReuseIdentifier: "HomeGalleryCell")
        tblUser.register(UINib(nibName: "HomeEventImageTblCell", bundle: nil), forCellReuseIdentifier: "HomeEventImageTblCell")
        tblUser.register(UINib(nibName: "HomeEventsCell", bundle: nil), forCellReuseIdentifier: "HomeEventsCell")
        tblUser.register(UINib(nibName: "HomeChirpyImageTblCell", bundle: nil), forCellReuseIdentifier: "HomeChirpyImageTblCell")
        tblUser.register(UINib(nibName: "HomeChirpyTblCell", bundle: nil), forCellReuseIdentifier: "HomeChirpyTblCell")
        tblUser.register(UINib(nibName: "HomeShoutsTblCell", bundle: nil), forCellReuseIdentifier: "HomeShoutsTblCell")
        tblUser.register(UINib(nibName: "HomeFourmTblCell", bundle: nil), forCellReuseIdentifier: "HomeFourmTblCell")
        tblUser.register(UINib(nibName: "HomePollTblCell", bundle: nil), forCellReuseIdentifier: "HomePollTblCell")
        tblUser.register(UINib(nibName: "NoPostFoundCell", bundle: nil), forCellReuseIdentifier: "NoPostFoundCell")
        
        tblUser.register(UINib(nibName: "HomeSharedArticleCell", bundle: nil), forCellReuseIdentifier: "HomeSharedArticleCell")
        tblUser.register(UINib(nibName: "HomeSharedGalleryCell", bundle: nil), forCellReuseIdentifier: "HomeSharedGalleryCell")
        tblUser.register(UINib(nibName: "HomeSharedEventImageTblCell", bundle: nil), forCellReuseIdentifier: "HomeSharedEventImageTblCell")
        tblUser.register(UINib(nibName: "HomeSharedEventsCell", bundle: nil), forCellReuseIdentifier: "HomeSharedEventsCell")
        tblUser.register(UINib(nibName: "HomeSharedChirpyImageTblCell", bundle: nil), forCellReuseIdentifier: "HomeSharedChirpyImageTblCell")
        tblUser.register(UINib(nibName: "HomeSharedChirpyTblCell", bundle: nil), forCellReuseIdentifier: "HomeSharedChirpyTblCell")
        tblUser.register(UINib(nibName: "HomeSharedShoutsTblCell", bundle: nil), forCellReuseIdentifier: "HomeSharedShoutsTblCell")
        tblUser.register(UINib(nibName: "HomeSharedFourmTblCell", bundle: nil), forCellReuseIdentifier: "HomeSharedFourmTblCell")
        tblUser.register(UINib(nibName: "HomeSharedPollTblCell", bundle: nil), forCellReuseIdentifier: "HomeSharedPollTblCell")
        
        tblUser.register(UINib(nibName: "PostDeletedCell", bundle: nil), forCellReuseIdentifier: "PostDeletedCell")
        
        GCDMainThread.async {
            // self.cnTblUserTopSpace.constant = (self.navigationController?.navigationBar.frame.size.height)! + UIApplication.shared.statusBarFrame.size.height
            self.refreshControl.addTarget(self, action: #selector(self.pullToRefresh), for: .valueChanged)
            self.refreshControl.tintColor = ColorAppTheme
            self.tblUser.pullToRefreshControl = self.refreshControl
            
        }
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: #imageLiteral(resourceName: "ic_home_btn_filter"), style: .plain, target: self, action: #selector(btnFilterClicked(_:))),UIBarButtonItem(image: #imageLiteral(resourceName: "ic_edit_profile"), style: .plain, target: self, action: #selector(btnEditProfileClicked(_:)))]
        
        // To Get User detail from server.......
        self.myUserDetails()
//        self.friendsListFromServer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.TableviewReload), name: NSNotification.Name(rawValue: "newDataNotificationForItemEdit"),object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.TableviewReloads), name: NSNotification.Name(rawValue: "newDataNotificationForItemupdate"),object: nil)
    }
    
    @objc func TableviewReload(){
        tblUser.reloadData()
    }
    
    @objc func TableviewReloads(){
        tblUser.reloadData()
    }
    
    @objc func loadMyprofile(){
        tblUser.reloadData()
    }
    
}

// MARK:- --------- Api Functions
extension MyProfileViewController{
    @objc func pullToRefresh() {
        refreshControl.beginRefreshing()
        pageNumber = 1
        self.myUserDetails()
    }
    
    // To Get User detail from server.......
 //MARK:- NEW CODE
    func myUserDetails(){
            if let userID = appDelegate.loginUser?.user_id{
                let dict:[String:Any] = [
                    CEmail_Mobile : appDelegate.loginUser?.email ?? ""
                ]
                APIRequest.shared().userDetails(para: dict as [String : AnyObject]) { (response, error) in
                    self.refreshControl.endRefreshing()
                    if response != nil && error == nil {
                        self.tblUser.reloadData()
                        // Call post list api here........
                        self.getPostListFromServer()
                        
                    }
                }
            }
        }

 
//    func myUserDetails(){
//        if let userID = appDelegate.loginUser?.user_id{
//            APIRequest.shared().userDetail(userID: Int(userID)) {[weak self] (response, error) in
//                guard let _ = self else { return }
//                self?.refreshControl.endRefreshing()
//                if response != nil{
//                    self?.tblUser.reloadData()
//                    // Call post list api here........
//                    self?.getPostListFromServer()
//                }
//            }
//        }
//    }
    
    func getPostListFromServer() {
        
        if let userID = appDelegate.loginUser?.user_id {
            
            if apiTask?.state == URLSessionTask.State.running {
                return
            }
            
            // Add load more indicator here...
            if self.pageNumber > 2 {
                self.tblUser.tableFooterView = self.loadMoreIndicator(ColorAppTheme)
            }else{
                self.tblUser.tableFooterView = nil
            }
            
            var serachType : String?
            if arrSelectedFilterOption.count > 0 {
                serachType = arrSelectedFilterOption.map({$0.valueForString(key: CCategoryId)}).joined(separator: ",")
            }
            
            apiTask = APIRequest.shared().getUserPostList(page: self.pageNumber, user_id: Int(userID), search_type: serachType) { [weak self](response, error) in
                guard let self = self else { return }
                self.tblUser.tableFooterView = nil
                self.refreshControl.endRefreshing()
                
                if response != nil && error == nil {
                    let data = response!["post_listing"] as! [String:Any]
                    if let arrList = data["post"] as? [[String : Any]] {
                        //if let arrList = response![CJsonData] as? [[String : Any]] {
                        // Remove all data here when page number == 1
                        if self.pageNumber == 1 {
                            self.arrPostList.removeAll()
                            self.tblUser.reloadData()
                        }
                        
                        // Add Data here...
                        if arrList.count > 0 {
                            self.arrPostList = self.arrPostList + arrList
                            self.tblUser.reloadData()
                            self.pageNumber += 1
                        }
                    }
                }else {
//                    guard  let errorUserinfo = error?.userInfo["error"] as? String else {return}
//                    let errorMsg = errorUserinfo.stringAfter(":")
//                    self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: errorMsg, btnOneTitle: CBtnOk, btnOneTapped: nil)
            }
          }
        }
    }
    //MARK:- NEW FILTER API
       func getPostListFromServerNew() {
           
           if let userID = appDelegate.loginUser?.user_id {
               
               if apiTask?.state == URLSessionTask.State.running {
                   return
               }
               
               // Add load more indicator here...
               if self.pageNumber > 2 {
                   self.tblUser.tableFooterView = self.loadMoreIndicator(ColorAppTheme)
               }else{
                   self.tblUser.tableFooterView = nil
               }
               
               var serachType : String?
               if arrSelectedFilterOption.count > 0 {
                   serachType = arrSelectedFilterOption.map({$0.valueForString(key: CCategoryId)}).joined(separator: ",")
               }
               
               apiTask = APIRequest.shared().getUserPostListNew(page: self.pageNumber, user_id: Int(userID), search_type: serachType) { [weak self](response, error) in
                   guard let self = self else { return }
                   self.tblUser.tableFooterView = nil
                   self.refreshControl.endRefreshing()
                   
                   if response != nil && error == nil {
                       let arrList = response?["Shout"] as? [[String : Any]]
                       
                       if let arrArticleList = response?["Article"] as? [[String : Any]] {
                           //if let arrList = response![CJsonData] as? [[String : Any]] {
                           // Remove all data here when page number == 1
                           if self.pageNumber == 1 {
                               self.arrPostList.removeAll()
                               self.tblUser.reloadData()
                           }
                           
                           // Add Data here...
                           if arrArticleList.count > 0 {
                               self.arrPostList = self.arrPostList + arrArticleList
                               self.tblUser.reloadData()
                               self.pageNumber += 1
                           }
                       }
                       if let arrChirpyList = response?["Chirpy"] as? [[String : Any]] {
                           //if let arrList = response![CJsonData] as? [[String : Any]] {
                           // Remove all data here when page number == 1
                           if self.pageNumber == 1 {
                               self.arrPostList.removeAll()
                               self.tblUser.reloadData()
                           }
                           
                           // Add Data here...
                           if arrChirpyList.count > 0 {
                               self.arrPostList = self.arrPostList + arrChirpyList
                               self.tblUser.reloadData()
                               self.pageNumber += 1
                           }
                       }
                       if let arrEventList = response?["Event"] as? [[String : Any]] {
                           //if let arrList = response![CJsonData] as? [[String : Any]] {
                           // Remove all data here when page number == 1
                           if self.pageNumber == 1 {
                               self.arrPostList.removeAll()
                               self.tblUser.reloadData()
                           }
                           
                           // Add Data here...
                           if arrEventList.count > 0 {
                               self.arrPostList = self.arrPostList + arrEventList
                               self.tblUser.reloadData()
                               self.pageNumber += 1
                           }
                       }
                       if let arrForumList = response?["Forum"] as? [[String : Any]] {
                           //if let arrList = response![CJsonData] as? [[String : Any]] {
                           // Remove all data here when page number == 1
                           if self.pageNumber == 1 {
                               self.arrPostList.removeAll()
                               self.tblUser.reloadData()
                           }
                           
                           // Add Data here...
                           if arrForumList.count > 0 {
                               self.arrPostList = self.arrPostList + arrForumList
                               self.tblUser.reloadData()
                               self.pageNumber += 1
                           }
                       }
                       if let arrGalleryList = response?["Gallery"] as? [[String : Any]] {
                           //if let arrList = response![CJsonData] as? [[String : Any]] {
                           // Remove all data here when page number == 1
                           if self.pageNumber == 1 {
                               self.arrPostList.removeAll()
                               self.tblUser.reloadData()
                           }
                           
                           // Add Data here...
                           if arrGalleryList.count > 0 {
                               self.arrPostList = self.arrPostList + arrGalleryList
                               self.tblUser.reloadData()
                               self.pageNumber += 1
                           }
                       }
                       if let arrPollList = response?["Poll"] as? [[String : Any]] {
                           //if let arrList = response![CJsonData] as? [[String : Any]] {
                           // Remove all data here when page number == 1
                           if self.pageNumber == 1 {
                               self.arrPostList.removeAll()
                               self.tblUser.reloadData()
                           }
                           
                           // Add Data here...
                           if arrPollList.count > 0 {
                               self.arrPostList = self.arrPostList + arrPollList
                               self.tblUser.reloadData()
                               self.pageNumber += 1
                           }
                       }
                     
                       if let arrShoutList = response?["Shout"] as? [[String : Any]] {
                           //if let arrList = response![CJsonData] as? [[String : Any]] {
                           // Remove all data here when page number == 1
                           if self.pageNumber == 1 {
                               self.arrPostList.removeAll()
                               self.tblUser.reloadData()
                           }
                           
                           // Add Data here...
                           if arrShoutList.count > 0 {
                               self.arrPostList = self.arrPostList + arrShoutList
                               self.tblUser.reloadData()
                               self.pageNumber += 1
                           }
                       }
                       
   //                    let data = response!["post_listing"] as! [String:Any]
   //                    if let arrList = data["post"] as? [[String : Any]] {
   //                        //if let arrList = response![CJsonData] as? [[String : Any]] {
   //                        // Remove all data here when page number == 1
   //                        if self.pageNumber == 1 {
   //                            self.arrPostList.removeAll()
   //                            self.tblUser.reloadData()
   //                        }
   //
   //                        // Add Data here...
   //                        if arrList.count > 0 {
   //                            self.arrPostList = self.arrPostList + arrList
   //                            self.tblUser.reloadData()
   //                            self.pageNumber += 1
   //                        }
   //                    }
                   }
               }
               
           }
       }
       
    
//    func deletePost(_ postId : Int, _ index : Int, _ postType : String) {
//        self.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: CMessageDeletePost, btnOneTitle: CBtnYes, btnOneTapped: { (alert) in
//            APIRequest.shared().deletePostNew(postID: postId, apiKeyCall: postType, completion: { [weak self](response, error) in
//                guard let self = self else { return }
//                if response != nil && error == nil{
//                    self.arrPostList.remove(at: index)
//                    MIGeneralsAPI.shared().refreshPostRelatedScreens(nil, postId, self, .deletePost)
//                    UIView.performWithoutAnimation {
//                        self.tblUser.reloadData()
//                    }
//                }
//            })
//        }, btnTwoTitle: CBtnNo, btnTwoTapped: nil)
//    }
 
   //NEW:- NEW Delete Code
    func deletePostNew(_ postId : Int, _ index : Int, _ postType : [String : Any]) {
           self.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: CMessageDeletePost, btnOneTitle: CBtnYes, btnOneTapped: {_ in
           
              
            switch postType.valueForString(key: CPostTypeNew){
            
            case CStaticArticleIdNew:
                self.postTypeDelete = postType.valueForString(key: "type")
                self.dict =
                    [
                        "post_id": postType.valueForString(key: "post_id"),
                        "image":postType.valueForString(key: "image"),
                        "post_title": postType.valueForString(key: "post_title"),
                        "post_category": postType.valueForString(key: "post_category"),
                        "post_content": postType.valueForString(key: "post_title"),
                        "age_limit": postType.valueForString(key: "age_limit"),
                        "targeted_audience": postType.valueForString(key: "targeted_audience"),
                        "selected_persons": postType.valueForString(key: "selected_persons"),
                        "status_id": "3"
                    ]
                
            case CStaticGalleryIdNew:
                self.postTypeDelete = postType.valueForString(key: "type")
                self.dict =
                    [
                        "post_id": postType.valueForString(key: "post_id"),
                        "post_category": postType.valueForString(key: "post_category"),
                        "images":postType.valueForString(key: "image"),
                        "targeted_audience": postType.valueForString(key: "targeted_audience"),
                        "selected_persons": postType.valueForString(key: "selected_persons"),
                        "status_id": "3"
                    ]
            case CStaticChirpyIdNew:
                
                self.postTypeDelete = postType.valueForString(key: "type")
                self.dict =
                    [
                        "post_id": postType.valueForString(key: "post_id"),
                        "image": postType.valueForString(key: "image"),
                        "post_title": postType.valueForString(key: "post_title"),
                        "post_category": postType.valueForString(key: "post_category"),
                        "post_content": postType.valueForString(key: "post_content"),
                        "targeted_audience": postType.valueForString(key: "targeted_audience"),
                        "selected_persons": postType.valueForString(key: "selected_persons"),
                        "status_id": "3"
                    ]
                
            case CStaticShoutIdNew:
                self.postTypeDelete = postType.valueForString(key: "type")
                self.dict =
                    [
                        "post_id": postType.valueForString(key: "post_id"),
                        "image": "",
                        "post_title": "",
                        "post_content": postType.valueForString(key: "post_content"),
                        "age_limit": "",
                        "targeted_audience": postType.valueForString(key: "targeted_audience"),
                        "selected_persons": postType.valueForString(key: "selected_persons"),
                        "status_id": "3"
                    ]
                
            case CStaticForumIdNew:
                self.postTypeDelete = postType.valueForString(key: "type")
                self.dict =
                    [
                        "post_id": postType.valueForString(key: "post_id"),
                        "image": "",
                        "post_title":  postType.valueForString(key: "post_title"),
                        "post_category":  postType.valueForString(key: "post_category"),
                        "post_content":  postType.valueForString(key: "post_content"),
                        "age_limit":  postType.valueForString(key: "age_limit"),
                        "targeted_audience": postType.valueForString(key: "targeted_audience"),
                        "selected_persons": postType.valueForString(key: "selected_persons"),
                        "status_id": "3"
                    ]
                
                
            case CStaticEventIdNew:
                self.postTypeDelete = postType.valueForString(key: "type")
                self.dict =
                    [
                        "post_id": postType.valueForString(key: "post_id"),
                        "image": postType.valueForString(key: "image"),
                        "post_title": postType.valueForString(key: "post_title"),
                        "post_category": postType.valueForString(key: "post_category"),
                        "post_content": postType.valueForString(key: "post_content"),
                        "age_limit": postType.valueForString(key: "age_limit"),
                        "latitude": postType.valueForString(key: "latitude"),
                        "longitude": postType.valueForString(key: "longitude"),
                        "start_date": postType.valueForString(key: "start_date"),
                        "end_date": postType.valueForString(key: "end_date"),
                        "targeted_audience": postType.valueForString(key: "targeted_audience"),
                        "selected_persons": postType.valueForString(key: "selected_persons"),
                        "status_id": "3",
                        "address_line1":""
                    ]
            case CStaticPollIdNew: // Poll Cell....
                self.postTypeDelete = postType.valueForString(key: "type")
                self.dict =
                    [
                        "post_id":postType.valueForString(key: "post_id"),
                        "post_category": postType.valueForString(key: "post_category"),
                        "post_title": postType.valueForString(key: "post_title"),
                        "options": postType.valueForString(key: "options"),
                        "targeted_audience": postType.valueForString(key: "targeted_audience"),
                        "selected_persons": postType.valueForString(key: "selected_persons"),
                        "status_id": "3"
                    ]
                
            default:
                break
                
                
            }
            APIRequest.shared().deletePostNew(postDetials: self.dict, apiKeyCall: self.postTypeDelete, completion: { [weak self](response, error) in
                   guard let self = self else { return }
                   if response != nil && error == nil{
                       self.arrPostList.remove(at: index)
                       MIGeneralsAPI.shared().refreshPostRelatedScreens(nil, postId, self, .deletePost)
                       UIView.performWithoutAnimation {
                           self.tblUser.reloadData()
                       }
                   }
               })
               
           }, btnTwoTitle: CBtnNo, btnTwoTapped: nil)
   //       self.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: CMessageDeletePost, btnOneTitle: CBtnYes, btnOneTapped: { (alert) in
   //            APIRequest.shared().deletePostNew(postID: postId, apiKeyCall: postType, completion: { [weak self](response, error) in
   //                guard let self = self else { return }
   //                if response != nil && error == nil{
   //                    self.arrPostList.remove(at: index)
   //                    MIGeneralsAPI.shared().refreshPostRelatedScreens(nil, postId, self, .deletePost)
   //                    UIView.performWithoutAnimation {
   //                        self.tblUser.reloadData()
   //                    }
   //                }
   //            })
   //        }, btnTwoTitle: CBtnNo, btnTwoTapped: nil)
       }
       
    
    
    func uploadProfilePic() {
        
        guard let userID = appDelegate.loginUser?.user_id else {return}
        var dict = [String:Any]()
        dict[CUserId] = userID
        dict[CProfileImage] = profileImgUrl
        
        //  keepchange later
        APIRequest.shared().uploadUserProfile(userID: Int(userID), para:dict,profileImgName:profileImgUrl){ [weak self] (response, error) in
            guard let self = self else { return }
            if let _response = response as? [String : AnyObject], error == nil {
                guard let dict = _response.valueForJSON(key: CJsonMeta) as? [String : AnyObject] else{
                    return
                }
                if let sideMenuVc = appDelegate.sideMenuController.leftViewController as? SideMenuViewController {
                    sideMenuVc.updateUserProfile()
                }
                //  self.redirectOnSuccess(metaData: dict)
            }
        }
        
        
    }
    
    func uploadCoverPic() {
        
        guard let userID = appDelegate.loginUser?.user_id else {return}
        var dict = [String:Any]()
        dict[CUserId] = userID
        dict[CCoverImage] = coverImgUrl
        
        //  keepchange later
        APIRequest.shared().uploadUserCover(dict: dict as [String : AnyObject],coverImage:coverImgUrl) { [weak self] (response, error) in
            guard let self = self else { return }
            if let _response = response as? [String : AnyObject], error == nil {
                guard let dict = _response.valueForJSON(key: CJsonMeta) as? [String : AnyObject] else{
                    return
                }
                if let sideMenuVc = appDelegate.sideMenuController.leftViewController as? SideMenuViewController {
                    sideMenuVc.updateUserProfile()
                }
                //  self.redirectOnSuccess(metaData: dict)
            }
        }
    }
    
}

// MARK:- --------- UITableView Datasources/Delegate
extension MyProfileViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }
        if arrPostList.isEmpty{
            return 1
        }
        return arrPostList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "MyProfileHeaderTblCell", for: indexPath) as? MyProfileHeaderTblCell {
                
                cell.cellConfigureProfileDetail()
//                cell.btnUserProfileStatus.touchUpInside { [weak self](sender) in
//                    //                    self?.presentActivityViewController(mediaData: appDelegate.loginUser?.profile_url, contentTitle: CShareProfileContentMsg)
//                    
//                    //                            if self.imgUser.image != nil {
//                    self?.presentActionsheetWithThreeButton(actionSheetTitle: nil, actionSheetMessage: nil, btnOneTitle: "Basic", btnOneStyle: .default, btnOneTapped: { [weak self] (action) in
//                        guard let self = self else { return }
//                    }, btnTwoTitle: "Complete", btnTwoStyle: .default, btnTwoTapped: { [weak self] (action) in
//                        guard let self = self else { return }
//                        
//                    }, btnThreeTitle: "unfriends", btnThreeStyle: .default) { [weak self] (action) in
//                        guard let self = self else { return }
//                        
//                    }
//                }
                cell.btnCoverChange.touchUpInside { [weak self](sender) in
                    guard let modileNum = appDelegate.loginUser?.mobile else {return}
                    //                    self?.presentActivityViewController(mediaData: appDelegate.loginUser?.profile_url, contentTitle: CShareProfileContentMsg)
                    //                            if self.imgUser.image != nil {
                    self?.presentActionsheetWithThreeButton(actionSheetTitle: nil, actionSheetMessage: nil, btnOneTitle: CRegisterChooseFromPhone, btnOneStyle: .default, btnOneTapped: { [weak self] (action) in
                        guard let self = self else { return }
                        
                        self.presentImagePickerControllerForGallery(imagePickerControllerCompletionHandler: { [weak self] (image, info) in
                            guard let self = self else { return }
                            if image != nil{
                                //                                            self.uploadedImg = true
                                //                                            self.imgEditIcon.isHidden = false
                                //                                            self.imgUser.image = image
                                cell.imgCover.image = image
                                
                                guard let imageURL = info?[UIImagePickerController.InfoKey.imageURL] as? NSURL else {return}
                                self.imgName = imageURL.absoluteString ?? ""
                                MInioimageupload.shared().uploadMinioimages(mobileNo: modileNum, ImageSTt: image!,isFrom:"",uploadFrom:"")
                                MInioimageupload.shared().callback = { message in
                                    print("UploadImage::::::::::::::\(message)")
                                    self.coverImgUrl = message
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                                        self.uploadCoverPic()
                                    })
                                }
                                
                            }
                        })
                        
                    }, btnTwoTitle: CRegisterTakePhoto, btnTwoStyle: .default, btnTwoTapped: { [weak self] (action) in
                        guard let self = self else { return }
                        self.presentImagePickerControllerForCamera(imagePickerControllerCompletionHandler: { [weak self] (image, info) in
                            guard let self = self else { return }
                            if image != nil{
                                cell.imgCover.image = image
                                guard let imageURL = info?[UIImagePickerController.InfoKey.imageURL] as? NSURL else {
                                    return
                                }
                                
                                self.imgName = imageURL.absoluteString ?? ""
                                MInioimageupload.shared().uploadMinioimages(mobileNo: modileNum, ImageSTt: image!,isFrom:"",uploadFrom:"")
                                //  MInioimageupload.shared().uploadMinioVideo(ImgnameStr:image!)
                                MInioimageupload.shared().callback = { message in
                                    print("UploadImage::::::::::::::\(message)")
                                    self.coverImgUrl = message
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                                        self.uploadCoverPic()
                                    })
                                }
                                
                            }
                        })
                    }, btnThreeTitle: CRegisterRemovePhoto, btnThreeStyle: .default) { [weak self] (action) in
                        guard let self = self else { return }
                        //                                    self.imgUser.image = nil
                        //                                    self.imgEditIcon.isHidden = true
                        //                                    self.uploadProfilePic()
                        cell.imgCover.image = nil
                    }
                    
                    //                            } else {
                    //                                self.presentImagePickerController(allowEditing: true) { [weak self](image, info) in
                    //                                    guard let self = self else { return }
                    //                                    if image != nil{
                    //                                        self.uploadedImg = true
                    //                                        self.imgEditIcon.isHidden = false
                    //                                        self.imgUser.image = image
                    //                                    }
                    //                                }
                    //                            }
                    
                }
                cell.btnProfileChange.touchUpInside {[weak self](sender) in
                    guard let modileNum = appDelegate.loginUser?.mobile else {
                        return
                    }
                    
                    self?.presentActionsheetWithThreeButton(actionSheetTitle: nil, actionSheetMessage: nil, btnOneTitle: CRegisterChooseFromPhone, btnOneStyle: .default, btnOneTapped: { [weak self] (action) in
                        guard let self = self else { return }
                        
                        self.presentImagePickerControllerForGallery(imagePickerControllerCompletionHandler: { [weak self] (image, info) in
                            guard let self = self else { return }
                            if image != nil{
                                cell.imgUser.image = image
                                let userID : Int64 = appDelegate.loginUser?.user_id ?? 0
                                guard let imageURL = info?[UIImagePickerController.InfoKey.imageURL] as? NSURL else {return}
                                self.imgName = imageURL.absoluteString ?? ""
                                MInioimageupload.shared().uploadMinioimages(mobileNo: modileNum, ImageSTt: image!,isFrom:"",uploadFrom:"")
                                MInioimageupload.shared().callback = { message in
                                    print("UploadImage::::::::::::::\(message)")
                                    self.profileImgUrl = message
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                                        self.uploadProfilePic()
                                    })
                                }
                                
                                /*keep change later
                                 APIRequest.shared().uploadUserProfile(userID: Int(userID), imgProfile: cell.imgUser.image) { [weak self] (response, error) in
                                 guard let self = self else { return }
                                 if let _response = response as? [String : AnyObject], error == nil {
                                 guard let dict = _response.valueForJSON(key: CJsonMeta) as? [String : AnyObject] else{
                                 return
                                 }
                                 if let sideMenuVc = appDelegate.sideMenuController.leftViewController as? SideMenuViewController {
                                 sideMenuVc.updateUserProfile()
                                 }
                                 // self.redirectOnSuccess(metaData: dict)
                                 }
                                 }*/
                                
                            }
                        })
                        
                    }, btnTwoTitle: CRegisterTakePhoto, btnTwoStyle: .default, btnTwoTapped: { [weak self] (action) in
                        guard let self = self else { return }
                        self.presentImagePickerControllerForCamera(imagePickerControllerCompletionHandler: { [weak self] (image, info) in
                            guard let self = self else { return }
                            if image != nil{
                                cell.imgUser.image = image
                            }
                        })
                    }, btnThreeTitle: CRegisterRemovePhoto, btnThreeStyle: .default) { [weak self] (action) in
                        guard let self = self else { return }
                        cell.imgUser.image = nil
                    }
                }
                
                
                /* cell.btnCoverChange.touchUpInside { [weak self](sender) in
                 //                    self?.presentActivityViewController(mediaData: appDelegate.loginUser?.profile_url, contentTitle: CShareProfileContentMsg)
                 
                 
                 //                            if self.imgUser.image != nil {
                 self?.presentActionsheetWithThreeButton(actionSheetTitle: nil, actionSheetMessage: nil, btnOneTitle: CRegisterChooseFromPhone, btnOneStyle: .default, btnOneTapped: { [weak self] (action) in
                 guard let self = self else { return }
                 
                 self.presentImagePickerControllerForGallery(imagePickerControllerCompletionHandler: { [weak self] (image, info) in
                 guard let self = self else { return }
                 if image != nil{
                 //                                            self.uploadedImg = true
                 //                                            self.imgEditIcon.isHidden = false
                 //                                            self.imgUser.image = image
                 cell.imgCover.image = image
                 }
                 })
                 
                 }, btnTwoTitle: CRegisterTakePhoto, btnTwoStyle: .default, btnTwoTapped: { [weak self] (action) in
                 guard let self = self else { return }
                 self.presentImagePickerControllerForCamera(imagePickerControllerCompletionHandler: { [weak self] (image, info) in
                 guard let self = self else { return }
                 if image != nil{
                 //                                            self.uploadedImg = true
                 //                                            self.imgEditIcon.isHidden = false
                 //                                            self.imgUser.image = image
                 cell.imgCover.image = image
                 }
                 })
                 }, btnThreeTitle: CRegisterRemovePhoto, btnThreeStyle: .default) { [weak self] (action) in
                 guard let self = self else { return }
                 //                                    self.imgUser.image = nil
                 //                                    self.imgEditIcon.isHidden = true
                 //                                    self.uploadProfilePic()
                 cell.imgCover.image = nil
                 }
                 
                 //                            } else {
                 //                                self.presentImagePickerController(allowEditing: true) { [weak self](image, info) in
                 //                                    guard let self = self else { return }
                 //                                    if image != nil{
                 //                                        self.uploadedImg = true
                 //                                        self.imgEditIcon.isHidden = false
                 //                                        self.imgUser.image = image
                 //                                    }
                 //                                }
                 //                            }
                 
                 }
                 cell.btnProfileChange.touchUpInside {[weak self](sender) in
                 self?.presentActionsheetWithThreeButton(actionSheetTitle: nil, actionSheetMessage: nil, btnOneTitle: CRegisterChooseFromPhone, btnOneStyle: .default, btnOneTapped: { [weak self] (action) in
                 guard let self = self else { return }
                 
                 self.presentImagePickerControllerForGallery(imagePickerControllerCompletionHandler: { [weak self] (image, info) in
                 guard let self = self else { return }
                 if image != nil{
                 cell.imgUser.image = image
                 let userID : Int64 = appDelegate.loginUser?.user_id ?? 0
                 /*keep change later
                 APIRequest.shared().uploadUserProfile(userID: Int(userID), imgProfile: cell.imgUser.image) { [weak self] (response, error) in
                 guard let self = self else { return }
                 if let _response = response as? [String : AnyObject], error == nil {
                 guard let dict = _response.valueForJSON(key: CJsonMeta) as? [String : AnyObject] else{
                 return
                 }
                 if let sideMenuVc = appDelegate.sideMenuController.leftViewController as? SideMenuViewController {
                 sideMenuVc.updateUserProfile()
                 }
                 // self.redirectOnSuccess(metaData: dict)
                 }
                 }*/
                 
                 }
                 })
                 
                 }, btnTwoTitle: CRegisterTakePhoto, btnTwoStyle: .default, btnTwoTapped: { [weak self] (action) in
                 guard let self = self else { return }
                 self.presentImagePickerControllerForCamera(imagePickerControllerCompletionHandler: { [weak self] (image, info) in
                 guard let self = self else { return }
                 if image != nil{
                 cell.imgUser.image = image
                 }
                 })
                 }, btnThreeTitle: CRegisterRemovePhoto, btnThreeStyle: .default) { [weak self] (action) in
                 guard let self = self else { return }
                 cell.imgUser.image = nil
                 }
                 }*/
                
                cell.onTotalFriendAction = { [weak self] in
                    if let frndVC = CStoryboardProfile.instantiateViewController(withIdentifier: "MyFriendsViewController") as? MyFriendsViewController {
                        self?.navigationController?.pushViewController(frndVC, animated: true)
                    }
                }
                
                /*cell.btnTotalFriend.touchUpInside { [weak self](sender) in
                 if let frndVC = CStoryboardProfile.instantiateViewController(withIdentifier: "MyFriendsViewController") as? MyFriendsViewController {
                 self?.navigationController?.pushViewController(frndVC, animated: true)
                 }
                 }*/
                
                cell.btnViewCompleteProfile.touchUpInside { [weak self](sender) in
                    if let completeVC = CStoryboardProfile.instantiateViewController(withIdentifier: "OtherUserCompleteProfileViewController") as? OtherUserCompleteProfileViewController {
                        completeVC.isLoginUser = true
                        self?.navigationController?.pushViewController(completeVC, animated: true)
                    }
                }
                
                cell.btnShare.touchUpInside { [weak self](sender) in
//                    self?.presentActivityViewController(mediaData: appDelegate.loginUser?.profile_url, contentTitle: CShareProfileContentMsg)
                    
                    
                    if let userDetailVC = CStoryboardChat.instantiateViewController(withIdentifier: "ChatListViewController") as? ChatListViewController{
                                       let nav = self?.viewController as? UINavigationController
                                           nav?.pushViewController(userDetailVC, animated: true)
                    }
                                       
                }
                return cell
            }
        }
        
        if arrPostList.isEmpty{
            if let cell = tableView.dequeueReusableCell(withIdentifier: "NoPostFoundCell", for: indexPath) as? NoPostFoundCell {
                return cell
            }
            return tableView.tableViewDummyCell()
        }
        
        let postInfo = arrPostList[indexPath.row]
        // let isSharedPost = postInfo.valueForInt(key: CIsSharedPost)
        // let isPostDeleted = postInfo.valueForInt(key: CIsPostDeleted)
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
                    self?.btnSharedMoreCLK(indexPath.row, postInfo)
                }
                
                // .... LOAD MORE DATA HERE
                if indexPath == tblUser.lastIndexPath(){
                    self.getPostListFromServer()
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
                    
                    cell.btnLikesCount.touchUpInside { [weak self](sender) in
                        self?.btnLikesCountCLK(postInfo.valueForInt(key: CId))
                    }
                    
                    cell.btnMore.touchUpInside { [weak self](sender) in
                        //self?.btnMoreCLK(indexPath.row, postInfo)
                        self?.btnSharedMoreCLK(indexPath.row, postInfo)
                    }
                    
                    cell.btnShare.touchUpInside { [weak self](sender) in
                        //self?.presentActivityViewController(mediaData: postInfo.valueForString(key: CShare_url), contentTitle: CSharePostContentMsg)
                        let sharePost = SharePostHelper(controller: self, dataSet: postInfo)
                        sharePost.shareURL = postInfo.valueForString(key: CShare_url)
                        sharePost.presentShareActivity()
                    }
                    
                    // .... LOAD MORE DATA HERE
                    if indexPath == tblUser.lastIndexPath(){
                        self.getPostListFromServer()
                    }
                    
                    return cell
                }
            }
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeArticleCell", for: indexPath) as? HomeArticleCell {
                cell.homeArticleDataSetup(postInfo)
                
                cell.btnLikesCount.touchUpInside { [weak self](sender) in
//                    self?.btnLikesCountCLK(postInfo.valueForInt(key: CId))
                    self?.btnLikesCountCLK(postInfo.valueForString(key: CPostId).toInt)
                }
                
                cell.btnMore.touchUpInside { [weak self](sender) in
                    self?.btnMoreCLK(indexPath.row, postInfo)
                }
                
                cell.btnShare.touchUpInside { [weak self](sender) in
                    //self?.presentActivityViewController(mediaData: postInfo.valueForString(key: CShare_url), contentTitle: CSharePostContentMsg)
                    let sharePost = SharePostHelper(controller: self, dataSet: postInfo)
                    sharePost.shareURL = postInfo.valueForString(key: CShare_url)
                    sharePost.presentShareActivity()
                }
                
                // .... LOAD MORE DATA HERE
                if indexPath == tblUser.lastIndexPath(){
                    self.getPostListFromServer()
                }
                
                return cell
            }
            break
        case CStaticGalleryIdNew:
            //            2-gallery
            // let isSharedPost = postInfo.valueForInt(key: CIsSharedPost)
            let isshared = 0
            if isshared == 1{
                if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeSharedGalleryCell", for: indexPath) as? HomeSharedGalleryCell {
                    cell.homeGalleryDataSetup(postInfo)
                    
                    cell.btnLikesCount.touchUpInside { [weak self](sender) in
                        self?.btnLikesCountCLK(postInfo.valueForInt(key: CId))
                    }
                    
                    cell.btnMore.touchUpInside { [weak self](sender) in
                        //self?.btnMoreCLK(indexPath.row, postInfo)
                        self?.btnSharedMoreCLK(indexPath.row, postInfo)
                    }
                    
                    cell.btnShare.touchUpInside { [weak self](sender) in
                        //self?.presentActivityViewController(mediaData: postInfo.valueForString(key: CShare_url), contentTitle: CSharePostContentMsg)
                        let sharePost = SharePostHelper(controller: self, dataSet: postInfo)
                        sharePost.shareURL = postInfo.valueForString(key: CShare_url)
                        sharePost.presentShareActivity()
                    }
                    
                    // .... LOAD MORE DATA HERE
                    if indexPath == tblUser.lastIndexPath(){
                        self.getPostListFromServer()
                    }
                    
                    return cell
                }
            }
            if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeGalleryCell", for: indexPath) as? HomeGalleryCell {
                cell.homeGalleryDataSetup(postInfo)
                
                cell.btnLikesCount.touchUpInside { [weak self](sender) in
//                    self?.btnLikesCountCLK(postInfo.valueForInt(key: CId))
                    self?.btnLikesCountCLK(postInfo.valueForString(key: CPostId).toInt)
                }
                
                cell.btnMore.touchUpInside { [weak self](sender) in
                    self?.btnMoreCLK(indexPath.row, postInfo)
                }
                
                cell.btnShare.touchUpInside { [weak self](sender) in
                    //self?.presentActivityViewController(mediaData: postInfo.valueForString(key: CShare_url), contentTitle: CSharePostContentMsg)
                    let sharePost = SharePostHelper(controller: self, dataSet: postInfo)
                    sharePost.shareURL = postInfo.valueForString(key: CShare_url)
                    sharePost.presentShareActivity()
                }
                
                // .... LOAD MORE DATA HERE
                if indexPath == tblUser.lastIndexPath(){
                    self.getPostListFromServer()
                }
                
                return cell
            }
            break
        case CStaticChirpyIdNew:
            //            3-chripy
            if postInfo.valueForString(key: CImage).isBlank
            {
                //let isSharedPost = postInfo.valueForInt(key: CIsSharedPost)
                let isshared = 0
                if isshared == 1{
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeSharedChirpyTblCell", for: indexPath) as? HomeSharedChirpyTblCell {
                        cell.homeChirpyDataSetup(postInfo)
                        
                        cell.btnLikesCount.touchUpInside { [weak self](sender) in
                            self?.btnLikesCountCLK(postInfo.valueForInt(key: CId))
                        }
                        
                        cell.btnMore.touchUpInside { [weak self](sender) in
                            //self?.btnMoreCLK(indexPath.row, postInfo)
                            self?.btnSharedMoreCLK(indexPath.row, postInfo)
                        }
                        
                        cell.btnShare.touchUpInside { [weak self](sender) in
                            //self?.presentActivityViewController(mediaData: postInfo.valueForString(key: CShare_url), contentTitle: CSharePostContentMsg)
                            let sharePost = SharePostHelper(controller: self, dataSet: postInfo)
                            sharePost.shareURL = postInfo.valueForString(key: CShare_url)
                            sharePost.presentShareActivity()
                        }
                        
                        // .... LOAD MORE DATA HERE
                        if indexPath == tblUser.lastIndexPath(){
                            self.getPostListFromServer()
                        }
                        
                        return cell
                    }
                }
                if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeChirpyImageTblCell", for: indexPath) as? HomeChirpyImageTblCell {
                    cell.homeChirpyImageDataSetup(postInfo)
                    
                    cell.btnLikesCount.touchUpInside { [weak self](sender) in
//                        self?.btnLikesCountCLK(postInfo.valueForInt(key: CId))
                        self?.btnLikesCountCLK(postInfo.valueForString(key: CPostId).toInt)
                    }
                    
                    cell.btnMore.touchUpInside { [weak self](sender) in
                        self?.btnMoreCLK(indexPath.row, postInfo)
                    }
                    
                    cell.btnShare.touchUpInside { [weak self](sender) in
                        //self?.presentActivityViewController(mediaData: postInfo.valueForString(key: CShare_url), contentTitle: CSharePostContentMsg)
                        let sharePost = SharePostHelper(controller: self, dataSet: postInfo)
                        sharePost.shareURL = postInfo.valueForString(key: CShare_url)
                        sharePost.presentShareActivity()
                    }
                    
                    // .... LOAD MORE DATA HERE
                    if indexPath == tblUser.lastIndexPath(){
                        self.getPostListFromServer()
                    }
                    
                    return cell
                }
            }else{
                let isSharedPost = postInfo.valueForInt(key: CIsSharedPost)
                if isSharedPost == 1{
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeSharedChirpyImageTblCell", for: indexPath) as? HomeSharedChirpyImageTblCell {
                        cell.homeChirpyImageDataSetup(postInfo)
                        
                        cell.btnLikesCount.touchUpInside { [weak self](sender) in
//                            self?.btnLikesCountCLK(postInfo.valueForInt(key: CId))
                            self?.btnLikesCountCLK(postInfo.valueForString(key: CPostId).toInt)
                        }
                        
                        cell.btnMore.touchUpInside { [weak self](sender) in
                            //self?.btnMoreCLK(indexPath.row, postInfo)
                            self?.btnSharedMoreCLK(indexPath.row, postInfo)
                        }
                        
                        cell.btnShare.touchUpInside { [weak self](sender) in
                            //self?.presentActivityViewController(mediaData: postInfo.valueForString(key: CShare_url), contentTitle: CSharePostContentMsg)
                            let sharePost = SharePostHelper(controller: self, dataSet: postInfo)
                            sharePost.shareURL = postInfo.valueForString(key: CShare_url)
                            sharePost.presentShareActivity()
                        }
                        
                        // .... LOAD MORE DATA HERE
                        if indexPath == tblUser.lastIndexPath(){
                            self.getPostListFromServer()
                        }
                        
                        return cell
                    }
                }
                if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeChirpyImageTblCell", for: indexPath) as? HomeChirpyImageTblCell {
                    cell.homeChirpyImageDataSetup(postInfo)
                    
                    cell.btnLikesCount.touchUpInside { [weak self](sender) in
//                        self?.btnLikesCountCLK(postInfo.valueForInt(key: CId))
                        self?.btnLikesCountCLK(postInfo.valueForString(key: CPostId).toInt)
                    }
                    
                    cell.btnMore.touchUpInside { [weak self](sender) in
                        self?.btnMoreCLK(indexPath.row, postInfo)
                    }
                    
                    cell.btnShare.touchUpInside { [weak self](sender) in
                        //self?.presentActivityViewController(mediaData: postInfo.valueForString(key: CShare_url), contentTitle: CSharePostContentMsg)
                        let sharePost = SharePostHelper(controller: self, dataSet: postInfo)
                        sharePost.shareURL = postInfo.valueForString(key: CShare_url)
                        sharePost.presentShareActivity()
                    }
                    
                    // .... LOAD MORE DATA HERE
                    if indexPath == tblUser.lastIndexPath(){
                        self.getPostListFromServer()
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
                    
                    cell.btnLikesCount.touchUpInside { [weak self](sender) in
                        self?.btnLikesCountCLK(postInfo.valueForInt(key: CId))
                    }
                    
                    cell.btnMore.touchUpInside { [weak self](sender) in
                        //self?.btnMoreCLK(indexPath.row, postInfo)
                        self?.btnSharedMoreCLK(indexPath.row, postInfo)
                    }
                    
                    cell.btnShare.touchUpInside { [weak self](sender) in
                        //self?.presentActivityViewController(mediaData: postInfo.valueForString(key: CShare_url), contentTitle: CSharePostContentMsg)
                        let sharePost = SharePostHelper(controller: self, dataSet: postInfo)
                        sharePost.shareURL = postInfo.valueForString(key: CShare_url)
                        sharePost.presentShareActivity()
                    }
                    
                    // .... LOAD MORE DATA HERE
                    if indexPath == tblUser.lastIndexPath(){
                        self.getPostListFromServer()
                    }
                    
                    return cell
                }
            }
            if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeShoutsTblCell", for: indexPath) as? HomeShoutsTblCell {
                cell.homeShoutsDataSetup(postInfo)
                
                cell.btnLikesCount.touchUpInside { [weak self](sender) in
//                    self?.btnLikesCountCLK(postInfo.valueForInt(key: CId))
                    self?.btnLikesCountCLK(postInfo.valueForString(key: CPostId).toInt)
                }
                
                cell.btnMore.touchUpInside { [weak self](sender) in
                    self?.btnMoreCLK(indexPath.row, postInfo)
                }
                
                cell.btnShare.touchUpInside { [weak self](sender) in
                    //self?.presentActivityViewController(mediaData: postInfo.valueForString(key: CShare_url), contentTitle: CSharePostContentMsg)
                    let sharePost = SharePostHelper(controller: self, dataSet: postInfo)
                    sharePost.shareURL = postInfo.valueForString(key: CShare_url)
                    sharePost.presentShareActivity()
                }
                
                // .... LOAD MORE DATA HERE
                if indexPath == tblUser.lastIndexPath(){
                    self.getPostListFromServer()
                }
                
                return cell
            }
            break
        case CStaticForumIdNew:
            //            5-forum
            //let isSharedPost = postInfo.valueForInt(key: CIsSharedPost)
            let isshared = 0
            if isshared == 1{
                if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeSharedFourmTblCell", for: indexPath) as? HomeSharedFourmTblCell {
                    cell.homeFourmDataSetup(postInfo)
                    
                    cell.btnLikesCount.touchUpInside { [weak self](sender) in
                        self?.btnLikesCountCLK(postInfo.valueForInt(key: CId))
                    }
                    
                    cell.btnMore.touchUpInside { [weak self](sender) in
                        //self?.btnMoreCLK(indexPath.row, postInfo)
                        self?.btnSharedMoreCLK(indexPath.row, postInfo)
                    }
                    
                    cell.btnShare.touchUpInside { [weak self](sender) in
                        //self?.presentActivityViewController(mediaData: postInfo.valueForString(key: CShare_url), contentTitle: CSharePostContentMsg)
                        let sharePost = SharePostHelper(controller: self, dataSet: postInfo)
                        sharePost.shareURL = postInfo.valueForString(key: CShare_url)
                        sharePost.presentShareActivity()
                    }
                    
                    // .... LOAD MORE DATA HERE
                    if indexPath == tblUser.lastIndexPath(){
                        self.getPostListFromServer()
                    }
                    
                    return cell
                }
            }
            if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeFourmTblCell", for: indexPath) as? HomeFourmTblCell {
                cell.homeFourmDataSetup(postInfo)
                
                cell.btnLikesCount.touchUpInside { [weak self](sender) in
//                    self?.btnLikesCountCLK(postInfo.valueForInt(key: CId))
                    self?.btnLikesCountCLK(postInfo.valueForString(key: CPostId).toInt)
                }
                
                cell.btnMore.touchUpInside { [weak self](sender) in
                    self?.btnMoreCLK(indexPath.row, postInfo)
                }
                
                cell.btnShare.touchUpInside { [weak self](sender) in
                    //self?.presentActivityViewController(mediaData: postInfo.valueForString(key: CShare_url), contentTitle: CSharePostContentMsg)
                    let sharePost = SharePostHelper(controller: self, dataSet: postInfo)
                    sharePost.shareURL = postInfo.valueForString(key: CShare_url)
                    sharePost.presentShareActivity()
                }
                
                // .... LOAD MORE DATA HERE
                if indexPath == tblUser.lastIndexPath(){
                    self.getPostListFromServer()
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
                        
                        cell.btnLikesCount.touchUpInside { [weak self](sender) in
                            self?.btnLikesCountCLK(postInfo.valueForInt(key: CId))
                        }
                        
                        cell.btnMore.touchUpInside { [weak self](sender) in
                            //self?.btnMoreCLK(indexPath.row, postInfo)
                            self?.btnSharedMoreCLK(indexPath.row, postInfo)
                        }
                        
                        cell.btnShare.touchUpInside { [weak self](sender) in
                            //self?.presentActivityViewController(mediaData: postInfo.valueForString(key: CShare_url), contentTitle: CSharePostContentMsg)
                            let sharePost = SharePostHelper(controller: self, dataSet: postInfo)
                            sharePost.shareURL = postInfo.valueForString(key: CShare_url)
                            sharePost.presentShareActivity()
                        }
                        
                        // .... LOAD MORE DATA HERE
                        if indexPath == tblUser.lastIndexPath(){
                            self.getPostListFromServer()
                        }
                        
                        return cell
                    }
                }
                if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeEventImageTblCell", for: indexPath) as? HomeEventImageTblCell {
                    cell.homeEventDataSetup(postInfo)
                    
                    cell.onChangeEventStatus = { [weak self] (action) in
                        self?.btnInterestedNotInterestedMayBeCLK(action, indexPath)
                    }
                    
                    cell.btnLikesCount.touchUpInside { [weak self](sender) in
                        self?.btnLikesCountCLK(postInfo.valueForString(key: CPostId).toInt)
//                        self?.btnLikesCountCLK(postInfo.valueForInt(key: CId))
                    }
                    
                    cell.btnMore.touchUpInside { [weak self](sender) in
                        self?.btnMoreCLK(indexPath.row, postInfo)
                    }
                    
                    cell.btnShare.touchUpInside { [weak self](sender) in
                        //self?.presentActivityViewController(mediaData: postInfo.valueForString(key: CShare_url), contentTitle: CSharePostContentMsg)
                        let sharePost = SharePostHelper(controller: self, dataSet: postInfo)
                        sharePost.shareURL = postInfo.valueForString(key: CShare_url)
                        sharePost.presentShareActivity()
                    }
                    
                    // .... LOAD MORE DATA HERE
                    if indexPath == tblUser.lastIndexPath(){
                        self.getPostListFromServer()
                    }
                    
                    return cell
                }
            }else{
                //let isSharedPost = postInfo.valueForInt(key: CIsSharedPost)
                let isshared = 0
                if isshared == 1{
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeSharedEventImageTblCell", for: indexPath) as? HomeSharedEventImageTblCell {
                        cell.homeEventDataSetup(postInfo)
                        
                        cell.btnLikesCount.touchUpInside { [weak self](sender) in
                            self?.btnLikesCountCLK(postInfo.valueForInt(key: CId))
//                            self?.btnLikesCountCLK(postInfo.valueForString(key: CPostId).toInt)
                        }
                        
                        cell.onChangeEventStatus = { [weak self] (action) in
                            self?.btnInterestedNotInterestedMayBeCLK(action, indexPath)
                        }
                        
                        cell.btnMore.touchUpInside { [weak self](sender) in
                            //self?.btnMoreCLK(indexPath.row, postInfo)
                            self?.btnSharedMoreCLK(indexPath.row, postInfo)
                        }
                        
                        cell.btnShare.touchUpInside { [weak self](sender) in
                            //self?.presentActivityViewController(mediaData: postInfo.valueForString(key: CShare_url), contentTitle: CSharePostContentMsg)
                            let sharePost = SharePostHelper(controller: self, dataSet: postInfo)
                            sharePost.shareURL = postInfo.valueForString(key: CShare_url)
                            sharePost.presentShareActivity()
                        }
                        
                        // .... LOAD MORE DATA HERE
                        if indexPath == tblUser.lastIndexPath(){
                            self.getPostListFromServer()
                        }
                        
                        return cell
                    }
                }
                if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeEventImageTblCell", for: indexPath) as? HomeEventImageTblCell {
                    cell.homeEventDataSetup(postInfo)
                    
                    cell.btnLikesCount.touchUpInside { [weak self](sender) in
//                        self?.btnLikesCountCLK(postInfo.valueForInt(key: CId))
                        self?.btnLikesCountCLK(postInfo.valueForString(key: CPostId).toInt)
                    }
                    
                    cell.onChangeEventStatus = { [weak self] (action) in
                        self?.btnInterestedNotInterestedMayBeCLK(action, indexPath)
                    }
                    
                    cell.btnMore.touchUpInside { [weak self](sender) in
                        self?.btnMoreCLK(indexPath.row, postInfo)
                    }
                    
                    cell.btnShare.touchUpInside { [weak self](sender) in
                        //self?.presentActivityViewController(mediaData: postInfo.valueForString(key: CShare_url), contentTitle: CSharePostContentMsg)
                        let sharePost = SharePostHelper(controller: self, dataSet: postInfo)
                        sharePost.shareURL = postInfo.valueForString(key: CShare_url)
                        sharePost.presentShareActivity()
                    }
                    
                    // .... LOAD MORE DATA HERE
                    if indexPath == tblUser.lastIndexPath(){
                        self.getPostListFromServer()
                    }
                    
                    return cell
                }
                
            }
            break
        case CStaticPollIdNew: // Poll Cell....
            //let isSharedPost = postInfo.valueForInt(key: CIsSharedPost)
            let isshared = 0
            if isshared == 1{
                if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeSharedPollTblCell", for: indexPath) as? HomeSharedPollTblCell {
                    
                    cell.homePollDataSetup(postInfo)
                    
                    cell.btnLikesCount.touchUpInside { [weak self](sender) in
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
                                let postID = sharePostData[postId] as? Int ?? 0
                                let postType = sharePostData[CPostTypeNew]
                               // self?.deletePost(postID, index, postType as! String)
                                self?.deletePostNew(postID, index , sharePostData)
                            }
                        }
                    }
                    
                    cell.btnShare.touchUpInside { [weak self](sender) in
                        //self?.presentActivityViewController(mediaData: postInfo.valueForString(key: CShare_url), contentTitle: CSharePostContentMsg)
                        let sharePost = SharePostHelper(controller: self, dataSet: postInfo)
                        sharePost.shareURL = postInfo.valueForString(key: CShare_url)
                        sharePost.presentShareActivity()
                    }
                    
                    // .... LOAD MORE DATA HERE
                    if indexPath == tblUser.lastIndexPath(){
                        self.getPostListFromServer()
                    }
                    
                    return cell
                }
            }
            if let cell = tableView.dequeueReusableCell(withIdentifier: "HomePollTblCell", for: indexPath) as? HomePollTblCell {
                
                cell.homePollDataSetup(postInfo, isSelected: true)
                
                cell.btnLikesCount.touchUpInside { [weak self](sender) in
//                    self?.btnLikesCountCLK(postInfo.valueForInt(key: CId))
                    self?.btnLikesCountCLK(postInfo.valueForString(key: CPostId).toInt)
                }
                cell.btnMore.tag = indexPath.row
                cell.onMorePressed = { [weak self] (index) in
                    guard let _ = self else { return }
                    let postData = self?.arrPostList[index] ?? [:]
                    if postData.valueForString(key: "user_email") == appDelegate.loginUser?.email{
                        self?.presentActionsheetWithOneButton(actionSheetTitle: nil, actionSheetMessage: nil, btnOneTitle: CBtnDelete, btnOneStyle: .default) { (alert) in
                            let postId = postData.valueForString(key: "post_id")
                            let postType = postData.valueForString(key: CPostTypeNew)
                           // self?.deletePost(postId.toInt ?? 0, index, postType)
                            self?.deletePostNew(postId.toInt ?? 0, index , postData)
                        }
                    }
                }
                
                cell.btnShare.touchUpInside { [weak self](sender) in
                    //self?.presentActivityViewController(mediaData: postInfo.valueForString(key: CShare_url), contentTitle: CSharePostContentMsg)
                    let sharePost = SharePostHelper(controller: self, dataSet: postInfo)
                    sharePost.shareURL = postInfo.valueForString(key: CShare_url)
                    sharePost.presentShareActivity()
                }
                
                // .... LOAD MORE DATA HERE
                if indexPath == tblUser.lastIndexPath(){
                    self.getPostListFromServer()
                }
                
                return cell
            }
            break
        default:
            break
        }
        
        return tableView.tableViewDummyCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0{
            return
        }
        if arrPostList.isEmpty{
            return
        }
        let postInfo = arrPostList[indexPath.row]
        // let postId = postInfo.valueForInt(key: CId)
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
        
        //switch postInfo.valueForInt(key: CPostType) {
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
                viewArticleVC.articleInformation = postInfo
                viewArticleVC.articleID = postId.toInt
                self.navigationController?.pushViewController(viewArticleVC, animated: true)
            }
            break
            
        case CStaticGalleryIdNew:
            // let isSharedPost = postInfo.valueForInt(key: CIsSharedPost)
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
//                imageDetailsVC.galleryInfoNew = postInfo
//                imageDetailsVC.imgPostId = postId.toInt
                imageDetailsVC.galleryInfo = postInfo
                imageDetailsVC.imgPostId = postId.toInt
                
                self.navigationController?.pushViewController(imageDetailsVC, animated: true)
            }
            break
            
        case CStaticChirpyIdNew:
            
            if postInfo.valueForString(key: CImage).isBlank{
                //let isSharedPost = postInfo.valueForInt(key: CIsSharedPost)
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
                    chirpyDetailsVC.chirpyInformation = postInfo
                    chirpyDetailsVC.chirpyID = postId.toInt
                    
                    
                    self.navigationController?.pushViewController(chirpyDetailsVC, animated: true)
                }
            }else{
                let isshared = 0
                //let isSharedPost = postInfo.valueForInt(key: CIsSharedPost)
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
                    chirpyImageVC.chirpyInformation = postInfo
                    chirpyImageVC.chirpyID = postId.toInt
                    
                    self.navigationController?.pushViewController(chirpyImageVC, animated: true)
                }
            }
        case CStaticShoutIdNew:
            // let isSharedPost = postInfo.valueForInt(key: CIsSharedPost)
            let isshared = 0
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
                shoutsDetailsVC.shoutInformations = postInfo
                shoutsDetailsVC.shoutID = postId.toInt
                
                self.navigationController?.pushViewController(shoutsDetailsVC, animated: true)
            }
            break
            
        case CStaticForumIdNew:
            // let isSharedPost = postInfo.valueForInt(key: CIsSharedPost)
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
                forumDetailsVC.forumInformation = postInfo
                forumDetailsVC.forumID = postId.toInt
                self.navigationController?.pushViewController(forumDetailsVC, animated: true)
            }
            break
            
        case CStaticEventIdNew:
            if postInfo.valueForString(key: CImage).isBlank{
                //let isSharedPost = postInfo.valueForInt(key: CIsSharedPost)
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
                    eventDetailsVC.eventInfo = postInfo
                    eventDetailsVC.postID = postId.toInt
                    self.navigationController?.pushViewController(eventDetailsVC, animated: true)
                }
            }else{
                //let isSharedPost = postInfo.valueForInt(key: CIsSharedPost)
                let isshared = 0
                if isshared == 1{
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
                    eventDetailsVC.eventInfo = postInfo
                    eventDetailsVC.postID = postId.toInt
                    self.navigationController?.pushViewController(eventDetailsVC, animated: true)
                }
            }
            
            break
        case CStaticPollIdNew: // Poll Cell....
            // let isSharedPost = postInfo.valueForInt(key: CIsSharedPost)
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
                viewArticleVC.pollInformation = postInfo
                viewArticleVC.isSelected = true
                viewArticleVC.pollID = postId.toInt
                
                self.navigationController?.pushViewController(viewArticleVC, animated: true)
            }
            break
        default:
            break
        }
    }
}

// MARK:- --------  TableView Cells Action
extension MyProfileViewController{
    fileprivate func btnInterestedNotInterestedMayBeCLK(_ type : Int?, _ indexpath : IndexPath?){
        var postInfo = arrPostList[indexpath!.row]
        if type != postInfo.valueForInt(key: CIsInterested){
            
            // Update existing count here...
           /* let totalIntersted = postInfo.valueForInt(key: CTotalInterestedUsers)
            let totalNotIntersted = postInfo.valueForInt(key: CTotalNotInterestedUsers)
            let totalMaybe = postInfo.valueForInt(key: CTotalMaybeInterestedUsers)
            switch postInfo.valueForInt(key: CIsInterested) {
            case CTypeInterested:
                postInfo[CTotalInterestedUsers] = totalIntersted! - 1
                break
            case CTypeNotInterested:
                postInfo[CTotalNotInterestedUsers] = totalNotIntersted! - 1
                break
            case CTypeMayBeInterested:
                postInfo[CTotalMaybeInterestedUsers] = totalMaybe! - 1
                break
            default:
                break
            }
            postInfo[CIsInterested] = type
            
            switch type {
            case CTypeInterested:
                postInfo[CTotalInterestedUsers] = totalIntersted! + 1
                break
            case CTypeNotInterested:
                postInfo[CTotalNotInterestedUsers] = totalNotIntersted! + 1
                break
            case CTypeMayBeInterested:
                postInfo[CTotalMaybeInterestedUsers] = totalMaybe! + 1
                break
            default:
                break
            }
            var postId = postInfo.valueForInt(key: CId)
            let isSharedPost = postInfo.valueForInt(key: CIsSharedPost)
            if isSharedPost == 1{
                postId = postInfo[COriginalPostId] as? Int ?? 0
            }*/
            //MARK:- NEW
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
                       //var postId = postInfo.valueForInt(key: CId)
            let postId = postInfo.valueForString(key: "post_id")
            _ = postInfo.valueForInt(key: CIsSharedPost)
           //            if isSharedPost == 1{
           //                postId = postInfo[COriginalPostId] as? Int ?? 0
           //            }
            MIGeneralsAPI.shared().interestNotInterestMayBe(postId.toInt, type!, viewController: self)
            
            arrPostList.remove(at: (indexpath?.row)!)
            arrPostList.insert(postInfo, at: (indexpath?.row)!)
            UIView.performWithoutAnimation {
                if (self.tblUser.indexPathsForVisibleRows?.contains(indexpath!))!{
                    self.tblUser.reloadRows(at: [indexpath!], with: .none)
                }
            }
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
    
    fileprivate func btnMoreCLK(_ index : Int?, _ postInfo : [String : Any]) {
        
        // let postId = postInfo.valueForInt(key: CId)
        //        let postType = postInfo.valueForInt(key: CPostType)
        let postId = postInfo.valueForString(key: "post_id")
        let postType = postInfo.valueForString(key: CPostTypeNew)
        let currentDateTime = Date().timeIntervalSince1970
        
        
        if let endDateTime = postInfo.valueForDouble(key: CEvent_End_Date), (postType == CStaticEventIdNew), (Double(currentDateTime) > endDateTime) {
            
            self.presentActionsheetWithOneButton(actionSheetTitle: nil, actionSheetMessage: nil, btnOneTitle: CBtnDelete, btnOneStyle: .default) { [weak self] (onActionClicked) in
                
                guard let `self` = self else { return }
              //  self.deletePost(postId.toInt ?? 0, index ?? 0, postType)
                self.deletePostNew(postId.toInt ?? 0, index ?? 0, postInfo)
                
            }
        } else {
            
            
            self.presentActionsheetWithOneButton(actionSheetTitle: nil, actionSheetMessage: nil, btnOneTitle: CBtnDelete, btnOneStyle: .default) { [weak self] (onActionClicked) in
                guard let `self` = self else { return }
                self.deletePostNew(postId.toInt ?? 0, index ?? 0, postInfo)
                
            }
            
            
            
            
//            self.presentActionsheetWithTwoButtons(actionSheetTitle: nil, actionSheetMessage: nil, btnOneTitle: CBtnEdit, btnOneStyle: .default, btnOneTapped: { (alert) in
//                switch postInfo.valueForString(key: CPostTypeNew){
//                case CStaticArticleIdNew:
//                    if let addArticleVC = CStoryboardHome.instantiateViewController(withIdentifier: "AddArticleViewController") as? AddArticleViewController{
//                        addArticleVC.articleType = .editArticle
//                        addArticleVC.articleID = postId.toInt
//                        self.navigationController?.pushViewController(addArticleVC, animated: true)
//                    }
//                case CStaticGalleryIdNew:
//                    /*if let galleyVC = CStoryboardImage.instantiateViewController(withIdentifier: "GalleryPreviewViewController") as? GalleryPreviewViewController{
//                     galleyVC.imagePostType = .editImagePost
//                     galleyVC.imgPostId = postId
//                     self.navigationController?.pushViewController(galleyVC, animated: true)
//                     }*/
//                    if let galleryListVC = CStoryboardHome.instantiateViewController(withIdentifier: "AddMediaViewController") as? AddMediaViewController{
//                        galleryListVC.imagePostType = .editImagePost
//                        galleryListVC.imgPostId = postId.toInt
//                        self.navigationController?.pushViewController(galleryListVC, animated: true)
//                    }
//                case CStaticChirpyIdNew:
//                    if let addChirpyVC = CStoryboardHome.instantiateViewController(withIdentifier: "AddChirpyViewController") as? AddChirpyViewController{
//                        addChirpyVC.chirpyType = .editChirpy
//                        addChirpyVC.chirpyID = postId.toInt
//                        self.navigationController?.pushViewController(addChirpyVC, animated: true)
//                    }
//                case CStaticShoutIdNew:
//                    if let createShoutsVC = CStoryboardHome.instantiateViewController(withIdentifier: "CreateShoutsViewController") as? CreateShoutsViewController{
//                        createShoutsVC.shoutsType = .editShouts
//                        createShoutsVC.shoutID = postId.toInt
//                        self.navigationController?.pushViewController(createShoutsVC, animated: true)
//                    }
//
//                case CStaticForumIdNew:
//                    if let addForumVC = CStoryboardHome.instantiateViewController(withIdentifier: "AddForumViewController") as? AddForumViewController{
//                        addForumVC.forumType = .editForum
//                        addForumVC.forumID = postId.toInt
//                        self.navigationController?.pushViewController(addForumVC, animated: true)
//                    }
//
//                case CStaticEventIdNew:
//                    if let addEventVC = CStoryboardEvent.instantiateViewController(withIdentifier: "AddEventViewController") as? AddEventViewController{
//                        addEventVC.eventType = .editEvent
//                        addEventVC.eventID = postId.toInt
//                        self.navigationController?.pushViewController(addEventVC, animated: true)
//                    }
//                case CStaticPollIdNew: // Poll Cell....
//                    if let viewArticleVC = CStoryboardPoll.instantiateViewController(withIdentifier: "PollDetailsViewController") as? PollDetailsViewController {
//                        viewArticleVC.pollID = postId.toInt
//                        self.navigationController?.pushViewController(viewArticleVC, animated: true)
//                    }
//                    break
//
//                default:
//                    break
//                }
//
//            }, btnTwoTitle: CBtnDelete, btnTwoStyle: .default) { (alert) in
//               // self.deletePost(postId.toInt!, index!, postType)
//                self.deletePostNew(postId.toInt ?? 0, index ?? 0, postInfo)
//            }
            
        }
    }
    
    fileprivate func btnSharedMoreCLK(_ index : Int?, _ postInfo : [String : Any]){
        
        let sharePostData = postInfo[CSharedPost] as? [String:Any] ?? [:]
        _ = sharePostData[CId] as? Int ?? 0
        let postType = postInfo.valueForInt(key: CPostType)
        let currentDateTime = Date().timeIntervalSince1970
        
        
        if let endDateTime = postInfo.valueForDouble(key: CEvent_End_Date), (postType == CStaticEventId), (Double(currentDateTime) > endDateTime) {
            
            self.presentActionsheetWithOneButton(actionSheetTitle: nil, actionSheetMessage: nil, btnOneTitle: CBtnDelete, btnOneStyle: .default) { [weak self] (onActionClicked) in
                
                guard let `self` = self else { return }
                // self.deletePost(postId, index ?? 0)
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
                //                //self?.deletePost(postId, index!)
            }
        }
    }
}

// MARK:- ---------- Action Event
extension MyProfileViewController{
    
    @objc fileprivate func btnFilterClicked(_ sender : UIBarButtonItem) {
        if let profileFilterVC = CStoryboardProfile.instantiateViewController(withIdentifier: "ProfileFilterViewController") as? ProfileFilterViewController {
            profileFilterVC.arrSelectedFilter = self.arrSelectedFilterOption
            profileFilterVC.setBlock { (arrFilter, message) in
                if let arr = arrFilter as? [[String : Any]]{
                    self.arrSelectedFilterOption = arr
                    self.pageNumber = 1
                    self.getPostListFromServerNew()
                }
            }
            self.navigationController?.pushViewController(profileFilterVC, animated: true)
        }
        
    }
    
    @objc fileprivate func btnEditProfileClicked(_ sender : UIBarButtonItem) {
        
        if let editProfileVC = CStoryboardProfile.instantiateViewController(withIdentifier: "EditProfileViewController") as? EditProfileViewController{
            editProfileVC.isremovedImage = isProfileUpdate
            self.navigationController?.pushViewController(editProfileVC, animated: true)
            
            
        }
    }
    
}

//

