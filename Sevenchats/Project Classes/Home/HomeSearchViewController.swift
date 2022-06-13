//
//  HomeSearchViewController.swift
//  Sevenchats
//
//  Created by mac-00017 on 04/09/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Nagaraju K and Chandrika R                                 *
 * Model   : HomeSearchViewController                    *
 * Changes :                                             *
 * search Users based on First Name, send Friends Request*
 * unfriends                                             *
 ********************************************************/

import UIKit
let CCategoryType = "type"
let CCategoryId = "id"

class HomeSearchViewController: ParentViewController {
    
    @IBOutlet weak var viewSearch : UIView!
    @IBOutlet weak var txtSearch : MIGenericTextFiled!
    @IBOutlet weak var txtSearchDropdown : UITextField!
    @IBOutlet weak var cnNavigationHeight : NSLayoutConstraint!
    @IBOutlet weak var tblEvents : UITableView!
    @IBOutlet weak var btnBack : UIButton!
    @IBOutlet weak var searchView : UIView!
    
    var isRefreshingUserData = false
    var arrHomeSearch = [[String:Any]]()
    var arrBlockList = [[String : Any]?]()
    var arrFriendsList = [String : Any]()
    var arrFriendsTemp = [[String : Any]]()
    var arrSearchList : [MDLSearchList] = []
    var arrSearchLists : [MDLSearchList] = []
    var timeStamp : Double?
    var isPost : Int?
    var searchType = 0
    var Friend_status = 0
    var refreshControl = UIRefreshControl()
    var apiTask : URLSessionTask?
    var param = [String:Any]()
    var notificationInfo = [String:Any]()
    let prefs = UserDefaults.standard
    
    var pageNumber = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Initialization()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateUIAccordingToLanguage()
        
        NotificationCenter.default.addObserver(self, selector: #selector(NotificationRecivedFrends), name: NSNotification.Name(rawValue: "NotificationFrndRequest"), object: nil)
    }
    //..Notification Frdns Request
    
    @objc func NotificationRecivedFrends(){
        DispatchQueue.main.async {
            self.arrHomeSearch.removeAll()
            let searchKey = self.prefs.value(forKey: "searchKey")
            self.getSearchDataFromServer(searchKey as! String, "new",searchTxtOther:true)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.arrHomeSearch.removeAll()
        
    }
    
    
    // MARK:- --------- Initialization
    func Initialization(){
        self.searchView.isHidden = true
        cnNavigationHeight.constant = IS_iPhone_X_Series ? 84 : 64
        txtSearch.becomeFirstResponder()
        
        GCDMainThread.async {
            self.viewSearch.layer.cornerRadius = self.viewSearch.frame.size.height/2
            self.refreshControl.addTarget(self, action: #selector(self.pullToRefresh), for: .valueChanged)
            self.refreshControl.tintColor = ColorAppTheme
            self.tblEvents.pullToRefreshControl = self.refreshControl
        }
        
        tblEvents.estimatedRowHeight = 350
        tblEvents.rowHeight = UITableView.automaticDimension
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
        tblEvents.register(UINib(nibName: "CreatePostTblCell", bundle: nil), forCellReuseIdentifier: "CreatePostTblCell")
        tblEvents.register(UINib(nibName: "PostDeletedCell", bundle: nil), forCellReuseIdentifier: "PostDeletedCell")
        
        var arrSearchType = [[String : Any]]()
        arrSearchType = [
            [CCategoryType:CTypeUser,CCategoryId:CStaticSearchUserTypeId]
        ]
        
        txtSearchDropdown.setPickerData(arrPickerData: arrSearchType, key: CCategoryType, selectedPickerDataHandler: { [weak self] (string, row, index) in
            
            guard let self = self else { return }
            let dic = arrSearchType[row]
            self.searchType = dic.valueForInt(key: CCategoryId)!
            if self.txtSearch.text?.isBlank ?? true{
                return
            }
            if self.apiTask?.state == URLSessionTask.State.running {
                self.apiTask?.cancel()
            }
            self.timeStamp = nil
            self.isPost = nil
        }, defaultPlaceholder: "")
        txtSearchDropdown.text = CTypeUser
    }
    
    func updateUIAccordingToLanguage() {
        
        if Localization.sharedInstance.applicationFlowWithLanguageRTL() {
            // Reverse Flow...
            btnBack.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        }else{
            // Normal Flow...
            btnBack.transform = CGAffineTransform.identity
        }
        
        self.txtSearch.placeholder = CSearch
    }
}

// MARK:- --------- Api Functions
extension HomeSearchViewController  {
    fileprivate func loadMore(_ indexPath : IndexPath) {
        // Load more data...
        if indexPath == tblEvents.lastIndexPath() && !self.isRefreshingUserData {
            self.getSearchDataFromServer(txtSearch.text, "new",searchTxtOther:false)
        }
    }
    
    @objc func pullToRefresh() {
        if apiTask?.state == URLSessionTask.State.running {
            apiTask?.cancel()
        }
        self.arrHomeSearch.removeAll()
        timeStamp = nil
        isPost = nil
        self.getSearchDataFromServer(txtSearch.text, "new",searchTxtOther:true)
        refreshControl.beginRefreshing()
    }
    
    func getSearchDataFromServer(_ searchText : String?, _ typeLook : String?,searchTxtOther:Bool){
        if apiTask?.state == URLSessionTask.State.running {
            return
        }
        // Add load more indicator here...
        if self.pageNumber > 2 {
            self.tblEvents.tableFooterView = self.loadMoreIndicator(ColorAppTheme)
        }else{
            self.tblEvents.tableFooterView = nil
        }
        
        let serchTextStr = searchText?.firstCharacterUpperCase()
        param[CName] = serchTextStr
        //        param[CPage] = "1"
        if searchTxtOther == true {
            param[CPage] = 1
        }else {
            param[CPage] = pageNumber
        }
        
        print("pageNumber\(pageNumber)")
        
        param[CLimitS] = "3000"
        param["user_id"] = appDelegate.loginUser?.user_id.description
        APIRequest.shared().userSearchDetail(Param: param){ [weak self] (response, error) in
            guard let self = self else { return }
            self.tblEvents.tableFooterView = nil
            self.refreshControl.endRefreshing()
            //            self.arrHomeSearch.removeAll()
            GCDMainThread.async {
                if response != nil && error == nil {
                    if let arrList = response!["users"] as? [[String : Any]] {
                        if self.pageNumber == 1 {
                            self.arrHomeSearch.removeAll()
                            self.tblEvents.reloadData()
                        }
                        // Add Data here...
                        if arrList.count > 0 {
                            self.arrHomeSearch = self.arrHomeSearch + arrList
                            self.tblEvents.reloadData()
                            self.pageNumber += 1
                        }
                    }
                }
            }
        }
    }
    //...Search From Other profile
    
    
    func deletePost(_ postId : Int, _ index : Int){
        //        weak var weakSelf = self
    }
    
    // Update Friend status Friend/Unfriend/Cancel Request
    func friendStatusApi(_ userInfo : [String : Any], _ userid : Int?,  _ status : Int?, completion:@escaping  (Bool) -> ()) {
        //    func friendStatusApi(_ userInfo : [String : Any], _ userid : Int?,  _ status : Int?){
        let friend_ID = userInfo.valueForString(key: "user_id")
        guard let user_ID = appDelegate.loginUser?.user_id else { return }
        
        let dict :[String:Any]  =  [
            "user_id":  user_ID.description,
            "friend_user_id": friend_ID,
            "request_type": status?.toString ?? ""
        ]
        
        APIRequest.shared().friendRquestStatus(dict: dict, completion: { [weak self] (response, error) in
            guard let self = self else { return }
            if response != nil{
                
                let dict :[String:Any]  =  [
                    "user_id":  user_ID.description,
                    "friend_user_id": friend_ID,
                ]
                
                if let metaData = response?.value(forKey: CJsonMeta) as? [String : AnyObject] {
                    if  metaData.valueForString(key: "message") == "Request sent successfully"{
                        
                        guard let user_ID =  appDelegate.loginUser?.user_id.description else { return}
                        guard let firstName = appDelegate.loginUser?.first_name else {return}
                        guard let lastName = appDelegate.loginUser?.last_name else {return}
                        
                        MIGeneralsAPI.shared().sendNotification(userid?.toString ?? "", userID: user_ID.description, subject: "send you a Friends Request", MsgType: "FRIEND_REQUEST", MsgSent:"", showDisplayContent: "send you a Friends Request", senderName: firstName + " " + lastName, post_ID: dict,shareLink:"sendFrdRequestLink")
                    }
                    completion(true)
                }
                
                var frndInfo = userInfo
                //                if let data = response![CJsonData] as? [String : Any]{
                //                    frndInfo[CFriend_status] = data.valueForInt(key: CFriend_status)
                //
                //                    if let index = self.arrHomeSearch.firstIndex(where: {$0[CUserId] as? Int == userid && $0[CSearchType]  as? Int == CStaticSearchUserTypeId}){
                //                        DispatchQueue.main.async {
                //                            self.arrHomeSearch.remove(at: index)
                //                            self.arrHomeSearch.insert(frndInfo, at: index)
                //                            self.isRefreshingUserData = true
                //                            self.tblEvents.reloadData()
                //                            self.isRefreshingUserData = false
                //                        }
                //                    }
                //                }
            }
        })
    }
}

// MARK:- --------- UITextField Delegate
extension HomeSearchViewController : UITextFieldDelegate {
    
    @IBAction func textFieldDidChanged(_ textFiled : UITextField){
        
        if apiTask?.state == URLSessionTask.State.running {
            apiTask?.cancel()
        }
        if (textFiled.text?.count)! < 2{
            timeStamp = nil
            isPost = nil
            arrHomeSearch.removeAll()
            tblEvents.restore()
            pageNumber = 1
            tblEvents.reloadData()
            return
        }
        pageNumber = 1
        timeStamp = nil
        isPost = nil
        prefs.setValue(txtSearch.text, forKey: "searchKey")
        UserDefaults.standard.synchronize()
        self.getSearchDataFromServer(txtSearch.text, "new",searchTxtOther:true)
    }
    
}

// MARK:- --------- UITableView Datasources/Delegate
extension HomeSearchViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrHomeSearch.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let searchInfo = arrHomeSearch[indexPath.row]
        let isSharedPost = searchInfo.valueForInt(key: CIsSharedPost)
        let isPostDeleted = searchInfo.valueForInt(key: CIsPostDeleted)
        if isSharedPost == 1 && isPostDeleted == 1{
            if let cell = tableView.dequeueReusableCell(withIdentifier: "PostDeletedCell", for: indexPath) as? PostDeletedCell {
                cell.postDataSetup(searchInfo)
                
                cell.btnLikesCount.touchUpInside { [weak self] (sender) in
                    guard let _ = self else { return }
                    self?.btnLikesCountCLK(searchInfo.valueForInt(key: CId))
                }
                
                cell.btnMore.touchUpInside { [weak self] (sender) in
                    guard let _ = self else { return }
                    let userID = (searchInfo[CSharedPost] as? [String:Any] ?? [:])[CUserId] as? Int64 ?? 0
                    if userID == appDelegate.loginUser?.user_id{
                        self?.btnSharedMoreCLK(indexPath.row, searchInfo)
                    }else{
                        self?.btnSharedReportCLK(postInfo: searchInfo)
                    }
                }
                
                cell.btnSharedProfileImg.touchUpInside { [weak self] (sender) in
                    guard let _ = self else { return }
                    if let userID = (searchInfo[CSharedPost] as? [String:Any] ?? [:])[CUserId] as? Int {
                        appDelegate.moveOnProfileScreen(userID.description, self)
                    }
                }
                
                cell.btnSharedUserName.touchUpInside { [weak self] (sender) in
                    guard let _ = self else { return }
                    if let userID = (searchInfo[CSharedPost] as? [String:Any] ?? [:])[CUserId] as? Int {
                        appDelegate.moveOnProfileScreen(userID.description, self)
                    }
                }
                // Load more data...
                self.loadMore(indexPath)
                
                return cell
            }
        }
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeAddFrdTblCell", for: indexPath) as? HomeAddFrdTblCell {
            
            
            if appDelegate.loginUser?.user_id == Int64(searchInfo.valueForString(key: CUserId)){
                //                cell.btnAddFrd.isHidden = true
                //                cell.btnAccept.isHidden = false
                //                cell.btnReject.isHidden = false
                cell.lblUserName.text = searchInfo.valueForString(key: CFirstname) + " " + searchInfo.valueForString(key: CLastname)
                cell.imgUser.loadImageFromUrl(searchInfo.valueForString(key: CImage), true)
                
            }else{
                cell.btnAddFrd.isHidden = false
                //.............
                let user_id = appDelegate.loginUser?.user_id
                if searchInfo.valueForString(key: "block_status") == "1" && searchInfo.valueForString(key: "blocked_id") == appDelegate.loginUser?.user_id.description {
                    Friend_status = 7
                }else if searchInfo.valueForString(key: "block_status") == "1"  {
                    Friend_status = 6
                } else if searchInfo.valueForString(key: "friend_status") == "1"{
                    Friend_status = 5
                }else if searchInfo.valueForString(key: "request_status") == "1" && searchInfo.valueForString(key: "senders_id") == user_id?.description {
                    Friend_status = 1
                }else if searchInfo.valueForString(key: "request_status") == "0" &&  searchInfo.valueForString(key: "friend_status") == "0" && searchInfo.valueForString(key: "reject_status") == "0" && searchInfo.valueForString(key: "cancel_status") == "0" && searchInfo.valueForString(key: "unfriend_status") == "0" || searchInfo.valueForString(key: "unfriend_status") == "1" &&  searchInfo.valueForString(key: "request_status") == "0" && searchInfo.valueForString(key: "friend_status") == "0" || searchInfo.valueForString(key: "unfriend_status") == "0" &&  searchInfo.valueForString(key: "request_status") == "1" && searchInfo.valueForString(key: "cancel_status") == "1" {
                    Friend_status = 0
                }else if searchInfo.valueForString(key: "request_status")  == "1" && searchInfo.valueForString(key: "senders_id") != user_id?.description {
                    Friend_status = 2
                    
                }else if searchInfo.valueForString(key: "unfriend_status") == "0" &&  searchInfo.valueForString(key: "request_status") == "0" && searchInfo.valueForString(key: "cancel_status") == "1" || searchInfo.valueForString(key: "senders_id").isEmpty {
                    Friend_status = 0
                }
                
                if searchInfo.valueForString(key: "request_status") == "1" && searchInfo.valueForString(key: "senders_id") != user_id?.description{
                    Friend_status = 2
                }
                
                if searchInfo.valueForString(key: "request_status") == "0" &&  searchInfo.valueForString(key: "friend_status") == "0" && searchInfo.valueForString(key: "reject_status") == "1" && searchInfo.valueForString(key: "cancel_status") == "1" &&   searchInfo.valueForString(key: "senders_id") == "0" {
                    Friend_status = 0
                }
                
                
                
                if Friend_status == 2 {
                    cell.btnAddFrd.isHidden = true
                    cell.viewAcceptReject.isHidden = false
                    cell.btnAccept.isHidden = false
                    cell.btnReject.isHidden = false
                    
                }else{
                    cell.btnAddFrd.isHidden = false
                    cell.btnAccept.isHidden = true
                    cell.btnReject.isHidden = true
                    cell.viewAcceptReject.isHidden = true
                    
                    switch Friend_status{
                    case 0:
                        cell.btnAddFrd.setTitle("  \(CBtnAddFriend)  ", for: .normal)
                    case 1:
                        cell.btnAddFrd.setTitle("  \(CBtnCancelRequest)  ", for: .normal)
                    case 5:
                        cell.btnAddFrd.setTitle("  \(CBtnUnfriend)  ", for: .normal)
                    case 6:
                        cell.btnAddFrd.setTitle("  \(CBlockedUser)  ", for: .normal)
                    case 7:
                        cell.btnAddFrd.setTitle("  \(CBtnUnblockUser)  ", for: .normal)
                    default:
                        break
                    }
                }
                //.............
                
                //                cell.setupCell(loan: searchInfo)
                cell.lblUserName.text = searchInfo.valueForString(key: CFirstname) + " " + searchInfo.valueForString(key: CLastname)
                cell.imgUser.loadImageFromUrl(searchInfo.valueForString(key: CImage), true)
                
                
            }
            
            cell.setupImgTapGestures(loan: searchInfo)
            cell.setupLblTapGestures(loan: searchInfo)
            cell.callbacks = { message in
                appDelegate.moveOnProfileScreenNew(message, message, self)
            }
            cell.btnAddFrd.touchUpInside {[weak self] (sender) in
                guard let self = self else { return }
                self.view.endEditing(true)
                //                let buttonPostion = sender.convert(sender.bounds.origin, to: tableView)
                //                if let indexPaths = tableView.indexPathForRow(at: buttonPostion) {
                //                    let searchInfos = self.searchInfo[indexPath.row]
                let friendID = searchInfo.valueForString(key: "user_id")
                let dict :[String:Any]  =  [
                    "user_id":  appDelegate.loginUser?.user_id.description ?? "",
                    "friend_user_id": friendID
                ]
                APIRequest.shared().getFriendStatus(dict: dict, completion: { [weak self] (response, error) in
                    if response != nil && error == nil{
                        //                            MILoader.shared.hideLoader()
                        GCDMainThread.async {
                            if let arrList = response!["data"] as? [[String:Any]]{
                                for arrLst in arrList{
                                    let user_id = appDelegate.loginUser?.user_id
                                    if arrLst.valueForString(key: "block_status") == "1" && arrLst.valueForString(key: "blocked_id") == appDelegate.loginUser?.user_id.description {
                                        self?.Friend_status = 7
                                    }else if arrLst.valueForString(key: "block_status") == "1"  {
                                        self?.Friend_status = 6
                                    } else if arrLst.valueForString(key: "friend_status") == "1"{
                                        self?.Friend_status = 5
                                    }else if arrLst.valueForString(key: "request_status") == "1" && arrLst.valueForString(key: "senders_id") == user_id?.description {
                                        self?.Friend_status = 1
                                    }else if arrLst.valueForString(key: "request_status") == "0" &&  arrLst.valueForString(key: "friend_status") == "0" && arrLst.valueForString(key: "reject_status") == "0" && arrLst.valueForString(key: "cancel_status") == "0" && arrLst.valueForString(key: "unfriend_status") == "0" || arrLst.valueForString(key: "unfriend_status") == "1" &&  arrLst.valueForString(key: "request_status") == "0" && arrLst.valueForString(key: "friend_status") == "0"{
                                        self?.Friend_status = 0
                                    }else if arrLst.valueForString(key: "request_status") == "0" && arrLst.valueForString(key: "senders_id") == "0" {
                                        self?.Friend_status = 0
                                    }
                                    
                                    
                                    var frndStatus = 1
                                    var isShowAlert = true
                                    var alertMessage = ""
                                    let first_name = searchInfo.valueForString(key: "first_name")
                                    let last_name = searchInfo.valueForString(key: "last_name")
                                    switch self?.Friend_status {
                                    case 0:
                                        frndStatus = CFriendRequestSent
                                        isShowAlert = true
                                        cell.btnAddFrd.isHidden = false
                                        alertMessage =  CAlertMessageForSendRequest + " " + first_name + " " + last_name
                                        
                                    case 1:
                                        frndStatus = CFriendRequestCancel
                                        isShowAlert = true
                                        cell.btnAddFrd.isHidden = false
                                        alertMessage = CMessageCancelRequest
                                        
                                    case 5:
                                        frndStatus = CFriendRequestUnfriend
                                        cell.btnAddFrd.isHidden = false
                                        isShowAlert = true
                                        alertMessage =  CMessageUnfriend + " " + first_name + " " + last_name
                                    case 6:
                                        //                                            cell.btnAddFrd.isEnabled = false
                                        cell.btnAddFrd.isUserInteractionEnabled = false
                                        isShowAlert = false
                                    case 7:
                                        frndStatus = CFriendUnblock
                                        cell.btnAddFrd.isHidden = false
                                        isShowAlert = true
                                        alertMessage = CMessageUnBlockUser
                                        
                                    default:
                                        break
                                    }
                                    if isShowAlert{
                                        self?.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: alertMessage, btnOneTitle: CBtnYes, btnOneTapped: { [weak self] (alert) in
                                            guard let self = self else { return }
                                            
                                            
                                            self.friendStatusApi(searchInfo, searchInfo.valueForInt(key: CUserId), frndStatus, completion:{(success) -> Void in
                                                if success {
                                                    cell.setupCell(loan: searchInfo)
                                                }
                                            })
                                        }, btnTwoTitle: CBtnNo, btnTwoTapped: nil)
                                    }else{
                                        //                                            self?.friendStatusApi(searchInfo, searchInfo.valueForInt(key: CUserId), frndStatus)
                                        
                                        self?.friendStatusApi(searchInfo, searchInfo.valueForInt(key: CUserId), frndStatus, completion:{(success) -> Void in
                                            if success {
                                                cell.setupCell(loan: searchInfo)
                                                //                                                     let indexPath = IndexPath(item: indexPath.row, section: 0)
                                                //                                                    if let visibleIndexPaths = self?.tblEvents.indexPathsForVisibleRows?.index(of: indexPath as IndexPath) {
                                                //                                                         if visibleIndexPaths != NSNotFound {
                                                //                                                            self?.tblEvents.reloadRows(at: [indexPath], with: .top)
                                                //                                                         }
                                                //                                                     }
                                                //                                                    self?.navigationController?.popViewController(animated: true)
                                                
                                            }
                                        })
                                    }
                                }
                                
                            }
                            
                        }
                    }
                })
                //                }
            }
            
            cell.btnAccept.touchUpInside {[weak self] (sender) in
                self?.view.endEditing(true)
                guard let self = self else { return }
                self.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: CAlertMessageForAcceptRequest, btnOneTitle: CBtnYes, btnOneTapped: { [weak self] (alert) in
                    guard let self = self else { return }
                    //                    cell.btnAccept.isHidden = false
                    //                    cell.btnReject.isHidden = false
                    
                    self.friendStatusApi(searchInfo, searchInfo.valueForInt(key: CUserId), 5, completion:{(success) -> Void in
                        if success {
                            cell.setupCell(loan: searchInfo)
                            //                             let indexPath = IndexPath(item: indexPath.row, section: 0)
                            //                             if let visibleIndexPaths = self.tblEvents.indexPathsForVisibleRows?.index(of: indexPath as IndexPath) {
                            //                                 if visibleIndexPaths != NSNotFound {
                            //                                     tableView.reloadRows(at: [indexPath], with: .fade)
                            //                                 }
                            //                             }
                            //                              self.navigationController?.popViewController(animated: true)
                            
                        }
                    })
                    
                    
                    
                    //                    self.friendStatusApi(searchInfo, searchInfo.valueForInt(key: CUserId), 5)
                }, btnTwoTitle: CBtnNo, btnTwoTapped: nil)
            }
            
            cell.btnReject.touchUpInside {[weak self] (sender) in
                self?.view.endEditing(true)
                guard let self = self else { return }
                self.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: CAlertMessageForRejectRequest, btnOneTitle: CBtnYes, btnOneTapped: { [weak self] (alert) in
                    guard let self = self else { return }
                    //                    self.friendStatusApi(searchInfo, searchInfo.valueForInt(key: CUserId), 3)
                    self.friendStatusApi(searchInfo, searchInfo.valueForInt(key: CUserId), 3
                                         , completion:{(success) -> Void in
                        if success {
                            
                            //                             let indexPath = IndexPath(item: indexPath.row, section: 0)
                            //                             if let visibleIndexPaths = self.tblEvents.indexPathsForVisibleRows?.index(of: indexPath as IndexPath) {
                            //                                 if visibleIndexPaths != NSNotFound {
                            //                                     tableView.reloadRows(at: [indexPath], with: .fade)
                            //                                 }
                            //                             }
                            cell.setupCell(loan: searchInfo)
                            //                            self.navigationController?.popViewController(animated: true)
                            
                        }
                    })
                }, btnTwoTitle: CBtnNo, btnTwoTapped: nil)
            }
            
            // Load more data...
            // self.loadMore(indexPath)
            return cell
        }
        
        //        switch searchInfo.valueForInt(key: CSearchType) {
        //        case CStaticArticleId:
        //            //            1-article
        //            if isSharedPost == 1{
        //                if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeSharedArticleCell", for: indexPath) as? HomeSharedArticleCell {
        //                    cell.homeArticleDataSetup(searchInfo)
        //
        //                    cell.btnLikesCount.touchUpInside {[weak self] (sender) in
        //                        guard let self = self else { return }
        //                        self.btnLikesCountCLK(searchInfo.valueForInt(key: CId))
        //                    }
        //
        //                    cell.btnMore.touchUpInside {[weak self] (sender) in
        //                        guard let self = self else { return }
        //                        let userID = (searchInfo[CSharedPost] as? [String:Any] ?? [:])[CUserId] as? Int64 ?? 0
        //                        if userID == appDelegate.loginUser?.user_id{
        //                            self.btnSharedMoreCLK(indexPath.row, searchInfo)
        //                        }else{
        //                            self.btnSharedReportCLK(postInfo: searchInfo)
        //                        }
        //                    }
        //
        //                    cell.btnSharedProfileImg.touchUpInside { [weak self] (sender) in
        //                        guard let _ = self else { return }
        //                        if let userID = (searchInfo[CSharedPost] as? [String:Any] ?? [:])[CUserId] as? Int {
        //                            appDelegate.moveOnProfileScreen(userID.description, self)
        //                        }
        //                    }
        //
        //                    cell.btnSharedUserName.touchUpInside { [weak self] (sender) in
        //                        guard let _ = self else { return }
        //                        if let userID = (searchInfo[CSharedPost] as? [String:Any] ?? [:])[CUserId] as? Int {
        //                            appDelegate.moveOnProfileScreen(userID.description, self)
        //                        }
        //                    }
        //
        //                    cell.btnProfileImg.touchUpInside {[weak self] (sender) in
        //                        guard let self = self else { return }
        //                        appDelegate.moveOnProfileScreen(searchInfo.valueForString(key: CUserId), self)
        //                    }
        //
        //                    cell.btnUserName.touchUpInside {[weak self] (sender) in
        //                        guard let self = self else { return }
        //                        appDelegate.moveOnProfileScreen(searchInfo.valueForString(key: CUserId), self)
        //                    }
        //
        //                    cell.btnShare.touchUpInside {[weak self] (sender) in
        //                        guard let self = self else { return }
        //                        //self.presentActivityViewController(mediaData: searchInfo.valueForString(key: CShare_url), contentTitle: CSharePostContentMsg)
        //                        let sharePost = SharePostHelper(controller: self, dataSet: searchInfo)
        //                        sharePost.shareURL = searchInfo.valueForString(key: CShare_url)
        //                        sharePost.presentShareActivity()
        //                    }
        //
        //                    // Load more data...
        //                    self.loadMore(indexPath)
        //
        //                    return cell
        //                }
        //            }
        //
        //            if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeArticleCell", for: indexPath) as? HomeArticleCell {
        //                cell.homeArticleDataSetup(searchInfo)
        //
        //                cell.btnLikesCount.touchUpInside {[weak self] (sender) in
        //                    guard let self = self else { return }
        //                    self.btnLikesCountCLK(searchInfo.valueForInt(key: CId))
        //                }
        //
        //                cell.btnMore.touchUpInside {[weak self] (sender) in
        //                    guard let self = self else { return }
        //                    if Int64(searchInfo.valueForString(key: CUserId)) == appDelegate.loginUser?.user_id{
        //                        self.btnMoreCLK(indexPath.row, searchInfo)
        //                    }else{
        //                        self.btnReportCLK(searchInfo)
        //                    }
        //                }
        //
        //                cell.btnProfileImg.touchUpInside {[weak self] (sender) in
        //                    guard let self = self else { return }
        //                    appDelegate.moveOnProfileScreen(searchInfo.valueForString(key: CUserId), self)
        //                }
        //
        //                cell.btnUserName.touchUpInside {[weak self] (sender) in
        //                    guard let self = self else { return }
        //                    appDelegate.moveOnProfileScreen(searchInfo.valueForString(key: CUserId), self)
        //                }
        //
        //                cell.btnShare.touchUpInside {[weak self] (sender) in
        //                    guard let self = self else { return }
        //                    //self.presentActivityViewController(mediaData: searchInfo.valueForString(key: CShare_url), contentTitle: CSharePostContentMsg)
        //                    let sharePost = SharePostHelper(controller: self, dataSet: searchInfo)
        //                    sharePost.shareURL = searchInfo.valueForString(key: CShare_url)
        //                    sharePost.presentShareActivity()
        //                }
        //
        //                // Load more data...
        //                self.loadMore(indexPath)
        //
        //                return cell
        //            }
        //            break
        //        case CStaticGalleryId:
        //            //            2-gallery
        //            let isSharedPost = searchInfo.valueForInt(key: CIsSharedPost)
        //            if isSharedPost == 1{
        //                if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeSharedGalleryCell", for: indexPath) as? HomeSharedGalleryCell {
        //                    cell.homeGalleryDataSetup(searchInfo)
        //
        //                    cell.btnLikesCount.touchUpInside {[weak self] (sender) in
        //                        guard let self = self else { return }
        //                        self.btnLikesCountCLK(searchInfo.valueForInt(key: CId))
        //                    }
        //
        //                    cell.btnMore.touchUpInside {[weak self] (sender) in
        //                        guard let self = self else { return }
        //                        let userID = (searchInfo[CSharedPost] as? [String:Any] ?? [:])[CUserId] as? Int64 ?? 0
        //                        if userID == appDelegate.loginUser?.user_id{
        //                            self.btnSharedMoreCLK(indexPath.row, searchInfo)
        //                        }else{
        //                            self.btnSharedReportCLK(postInfo: searchInfo)
        //                        }
        //                    }
        //
        //                    cell.btnSharedProfileImg.touchUpInside { [weak self] (sender) in
        //                        guard let _ = self else { return }
        //                        if let userID = (searchInfo[CSharedPost] as? [String:Any] ?? [:])[CUserId] as? Int {
        //                            appDelegate.moveOnProfileScreen(userID.description, self)
        //                        }
        //                    }
        //
        //                    cell.btnSharedUserName.touchUpInside { [weak self] (sender) in
        //                        guard let _ = self else { return }
        //                        if let userID = (searchInfo[CSharedPost] as? [String:Any] ?? [:])[CUserId] as? Int {
        //                            appDelegate.moveOnProfileScreen(userID.description, self)
        //                        }
        //                    }
        //
        //                    cell.btnProfileImg.touchUpInside {[weak self] (sender) in
        //                        guard let self = self else { return }
        //                        appDelegate.moveOnProfileScreen(searchInfo.valueForString(key: CUserId), self)
        //                    }
        //
        //                    cell.btnUserName.touchUpInside {[weak self] (sender) in
        //                        guard let self = self else { return }
        //                        appDelegate.moveOnProfileScreen(searchInfo.valueForString(key: CUserId), self)
        //                    }
        //
        //                    cell.btnShare.touchUpInside {[weak self] (sender) in
        //                        guard let self = self else { return }
        //                        //self.presentActivityViewController(mediaData: searchInfo.valueForString(key: CShare_url), contentTitle: CSharePostContentMsg)
        //                        let sharePost = SharePostHelper(controller: self, dataSet: searchInfo)
        //                        sharePost.shareURL = searchInfo.valueForString(key: CShare_url)
        //                        sharePost.presentShareActivity()
        //                    }
        //
        //                    // Load more data...
        //                    self.loadMore(indexPath)
        //
        //                    return cell
        //                }
        //            }
        //            if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeGalleryCell", for: indexPath) as? HomeGalleryCell {
        //                cell.homeGalleryDataSetup(searchInfo)
        //
        //                cell.btnLikesCount.touchUpInside {[weak self] (sender) in
        //                    guard let self = self else { return }
        //                    self.btnLikesCountCLK(searchInfo.valueForInt(key: CId))
        //                }
        //
        //                cell.btnMore.touchUpInside {[weak self] (sender) in
        //                    guard let self = self else { return }
        //                    if Int64(searchInfo.valueForString(key: CUserId)) == appDelegate.loginUser?.user_id{
        //                        self.btnMoreCLK(indexPath.row, searchInfo)
        //                    }else{
        //                        self.btnReportCLK(searchInfo)
        //                    }
        //                }
        //
        //                cell.btnProfileImg.touchUpInside {[weak self] (sender) in
        //                    guard let self = self else { return }
        //                    appDelegate.moveOnProfileScreen(searchInfo.valueForString(key: CUserId), self)
        //                }
        //
        //                cell.btnUserName.touchUpInside {[weak self] (sender) in
        //                    guard let self = self else { return }
        //                    appDelegate.moveOnProfileScreen(searchInfo.valueForString(key: CUserId), self)
        //                }
        //
        //                cell.btnShare.touchUpInside {[weak self] (sender) in
        //                    guard let self = self else { return }
        //                    //self.presentActivityViewController(mediaData: searchInfo.valueForString(key: CShare_url), contentTitle: CSharePostContentMsg)
        //                    let sharePost = SharePostHelper(controller: self, dataSet: searchInfo)
        //                    sharePost.shareURL = searchInfo.valueForString(key: CShare_url)
        //                    sharePost.presentShareActivity()
        //                }
        //
        //                // Load more data...
        //                self.loadMore(indexPath)
        //
        //                return cell
        //            }
        //            break
        //        case CStaticChirpyId:
        //            //            3-chripy
        //
        //            if searchInfo.valueForString(key: CImage).isBlank {
        //
        //                let isSharedPost = searchInfo.valueForInt(key: CIsSharedPost)
        //                if isSharedPost == 1{
        //                    if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeSharedChirpyTblCell", for: indexPath) as? HomeSharedChirpyTblCell {
        //                        cell.homeChirpyDataSetup(searchInfo)
        //
        //                        cell.btnLikesCount.touchUpInside {[weak self] (sender) in
        //                            guard let self = self else { return }
        //                            self.btnLikesCountCLK(searchInfo.valueForInt(key: CId))
        //                        }
        //
        //                        cell.btnMore.touchUpInside {[weak self] (sender) in
        //                            guard let self = self else { return }
        //                            let userID = (searchInfo[CSharedPost] as? [String:Any] ?? [:])[CUserId] as? Int64 ?? 0
        //                            if userID == appDelegate.loginUser?.user_id{
        //                                self.btnSharedMoreCLK(indexPath.row, searchInfo)
        //                            }else{
        //                                self.btnSharedReportCLK(postInfo: searchInfo)
        //                            }
        //                        }
        //
        //                        cell.btnSharedProfileImg.touchUpInside { [weak self] (sender) in
        //                            guard let _ = self else { return }
        //                            if let userID = (searchInfo[CSharedPost] as? [String:Any] ?? [:])[CUserId] as? Int {
        //                                appDelegate.moveOnProfileScreen(userID.description, self)
        //                            }
        //                        }
        //
        //                        cell.btnSharedUserName.touchUpInside { [weak self] (sender) in
        //                            guard let _ = self else { return }
        //                            if let userID = (searchInfo[CSharedPost] as? [String:Any] ?? [:])[CUserId] as? Int {
        //                                appDelegate.moveOnProfileScreen(userID.description, self)
        //                            }
        //                        }
        //
        //                        cell.btnProfileImg.touchUpInside {[weak self] (sender) in
        //                            guard let self = self else { return }
        //                            appDelegate.moveOnProfileScreen(searchInfo.valueForString(key: CUserId), self)
        //                        }
        //
        //                        cell.btnUserName.touchUpInside {[weak self] (sender) in
        //                            guard let self = self else { return }
        //                            appDelegate.moveOnProfileScreen(searchInfo.valueForString(key: CUserId), self)
        //                        }
        //
        //                        cell.btnShare.touchUpInside {[weak self] (sender) in
        //                            guard let self = self else { return }
        //                            //self.presentActivityViewController(mediaData: searchInfo.valueForString(key: CShare_url), contentTitle: CSharePostContentMsg)
        //                            let sharePost = SharePostHelper(controller: self, dataSet: searchInfo)
        //                            sharePost.shareURL = searchInfo.valueForString(key: CShare_url)
        //                            sharePost.presentShareActivity()
        //                        }
        //
        //                        // Load more data...
        //                        self.loadMore(indexPath)
        //
        //
        //                        return cell
        //                    }
        //                }
        //
        //                if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeChirpyTblCell", for: indexPath) as? HomeChirpyTblCell {
        //                    cell.homeChirpyDataSetup(searchInfo)
        //
        //                    cell.btnLikesCount.touchUpInside {[weak self] (sender) in
        //                        guard let self = self else { return }
        //                        self.btnLikesCountCLK(searchInfo.valueForInt(key: CId))
        //                    }
        //
        //                    cell.btnMore.touchUpInside {[weak self] (sender) in
        //                        guard let self = self else { return }
        //                        if Int64(searchInfo.valueForString(key: CUserId)) == appDelegate.loginUser?.user_id{
        //                            self.btnMoreCLK(indexPath.row, searchInfo)
        //                        }else{
        //                            self.btnReportCLK(searchInfo)
        //                        }
        //                    }
        //
        //                    cell.btnProfileImg.touchUpInside {[weak self] (sender) in
        //                        guard let self = self else { return }
        //                        appDelegate.moveOnProfileScreen(searchInfo.valueForString(key: CUserId), self)
        //                    }
        //
        //                    cell.btnUserName.touchUpInside {[weak self] (sender) in
        //                        guard let self = self else { return }
        //                        appDelegate.moveOnProfileScreen(searchInfo.valueForString(key: CUserId), self)
        //                    }
        //
        //                    cell.btnShare.touchUpInside {[weak self] (sender) in
        //                        guard let self = self else { return }
        //                        //self.presentActivityViewController(mediaData: searchInfo.valueForString(key: CShare_url), contentTitle: CSharePostContentMsg)
        //                        let sharePost = SharePostHelper(controller: self, dataSet: searchInfo)
        //                        sharePost.shareURL = searchInfo.valueForString(key: CShare_url)
        //                        sharePost.presentShareActivity()
        //                    }
        //
        //                    // Load more data...
        //                    self.loadMore(indexPath)
        //
        //
        //                    return cell
        //                }
        //            } else {
        //                let isSharedPost = searchInfo.valueForInt(key: CIsSharedPost)
        //                if isSharedPost == 1{
        //                    if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeSharedChirpyImageTblCell", for: indexPath) as? HomeSharedChirpyImageTblCell {
        //                        cell.homeChirpyImageDataSetup(searchInfo)
        //
        //                        cell.btnLikesCount.touchUpInside {[weak self] (sender) in
        //                            guard let self = self else { return }
        //                            self.btnLikesCountCLK(searchInfo.valueForInt(key: CId))
        //                        }
        //
        //                        cell.btnMore.touchUpInside {[weak self] (sender) in
        //                            guard let self = self else { return }
        //                            let userID = (searchInfo[CSharedPost] as? [String:Any] ?? [:])[CUserId] as? Int64 ?? 0
        //                            if userID == appDelegate.loginUser?.user_id{
        //                                self.btnSharedMoreCLK(indexPath.row, searchInfo)
        //                            }else{
        //                                self.btnSharedReportCLK(postInfo: searchInfo)
        //                            }
        //                        }
        //
        //                        cell.btnSharedProfileImg.touchUpInside { [weak self] (sender) in
        //                            guard let _ = self else { return }
        //                            if let userID = (searchInfo[CSharedPost] as? [String:Any] ?? [:])[CUserId] as? Int {
        //                                appDelegate.moveOnProfileScreen(userID.description, self)
        //                            }
        //                        }
        //
        //                        cell.btnSharedUserName.touchUpInside { [weak self] (sender) in
        //                            guard let _ = self else { return }
        //                            if let userID = (searchInfo[CSharedPost] as? [String:Any] ?? [:])[CUserId] as? Int {
        //                                appDelegate.moveOnProfileScreen(userID.description, self)
        //                            }
        //                        }
        //
        //                        cell.btnProfileImg.touchUpInside {[weak self] (sender) in
        //                            guard let self = self else { return }
        //                            appDelegate.moveOnProfileScreen(searchInfo.valueForString(key: CUserId), self)
        //                        }
        //
        //                        cell.btnUserName.touchUpInside {[weak self] (sender) in
        //                            guard let self = self else { return }
        //                            appDelegate.moveOnProfileScreen(searchInfo.valueForString(key: CUserId), self)
        //                        }
        //
        //                        cell.btnShare.touchUpInside {[weak self] (sender) in
        //                            guard let self = self else { return }
        //                            //self.presentActivityViewController(mediaData: searchInfo.valueForString(key: CShare_url), contentTitle: CSharePostContentMsg)
        //                            let sharePost = SharePostHelper(controller: self, dataSet: searchInfo)
        //                            sharePost.shareURL = searchInfo.valueForString(key: CShare_url)
        //                            sharePost.presentShareActivity()
        //                        }
        //
        //                        // Load more data...
        //                        self.loadMore(indexPath)
        //                        return cell
        //                    }
        //                }
        //                if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeChirpyImageTblCell", for: indexPath) as? HomeChirpyImageTblCell {
        //                    cell.homeChirpyImageDataSetup(searchInfo)
        //
        //                    cell.btnLikesCount.touchUpInside {[weak self] (sender) in
        //                        guard let self = self else { return }
        //                        self.btnLikesCountCLK(searchInfo.valueForInt(key: CId))
        //                    }
        //
        //                    cell.btnMore.touchUpInside {[weak self] (sender) in
        //                        guard let self = self else { return }
        //                        if Int64(searchInfo.valueForString(key: CUserId)) == appDelegate.loginUser?.user_id{
        //                            self.btnMoreCLK(indexPath.row, searchInfo)
        //                        }else{
        //                            self.btnReportCLK(searchInfo)
        //                        }
        //                    }
        //
        //                    cell.btnProfileImg.touchUpInside {[weak self] (sender) in
        //                        guard let self = self else { return }
        //                        appDelegate.moveOnProfileScreen(searchInfo.valueForString(key: CUserId), self)
        //                    }
        //
        //                    cell.btnUserName.touchUpInside {[weak self] (sender) in
        //                        guard let self = self else { return }
        //                        appDelegate.moveOnProfileScreen(searchInfo.valueForString(key: CUserId), self)
        //                    }
        //
        //                    cell.btnShare.touchUpInside {[weak self] (sender) in
        //                        guard let self = self else { return }
        //                        //self.presentActivityViewController(mediaData: searchInfo.valueForString(key: CShare_url), contentTitle: CSharePostContentMsg)
        //                        let sharePost = SharePostHelper(controller: self, dataSet: searchInfo)
        //                        sharePost.shareURL = searchInfo.valueForString(key: CShare_url)
        //                        sharePost.presentShareActivity()
        //                    }
        //
        //                    // Load more data...
        //                    self.loadMore(indexPath)
        //
        //
        //                    return cell
        //                }
        //            }
        //            break
        //        case CStaticShoutId:
        //            //            4-shout
        //            let isSharedPost = searchInfo.valueForInt(key: CIsSharedPost)
        //            if isSharedPost == 1{
        //                if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeSharedShoutsTblCell", for: indexPath) as? HomeSharedShoutsTblCell {
        //                    cell.homeShoutsDataSetup(searchInfo)
        //
        //                    cell.btnLikesCount.touchUpInside {[weak self] (sender) in
        //                        guard let self = self else { return }
        //                        self.btnLikesCountCLK(searchInfo.valueForInt(key: CId))
        //                    }
        //
        //                    cell.btnShare.touchUpInside {[weak self] (sender) in
        //                        guard let self = self else { return }
        //                        //self.presentActivityViewController(mediaData: searchInfo.valueForString(key: CShare_url), contentTitle: CSharePostContentMsg)
        //                        let sharePost = SharePostHelper(controller: self, dataSet: searchInfo)
        //                        sharePost.shareURL = searchInfo.valueForString(key: CShare_url)
        //                        sharePost.presentShareActivity()
        //                    }
        //
        //                    cell.btnMore.touchUpInside {[weak self] (sender) in
        //                        guard let self = self else { return }
        //                        let userID = (searchInfo[CSharedPost] as? [String:Any] ?? [:])[CUserId] as? Int64 ?? 0
        //                        if userID == appDelegate.loginUser?.user_id{
        //                            self.btnSharedMoreCLK(indexPath.row, searchInfo)
        //                        }else{
        //                            self.btnSharedReportCLK(postInfo: searchInfo)
        //                        }
        //                    }
        //
        //                    cell.btnSharedProfileImg.touchUpInside { [weak self] (sender) in
        //                        guard let _ = self else { return }
        //                        if let userID = (searchInfo[CSharedPost] as? [String:Any] ?? [:])[CUserId] as? Int {
        //                            appDelegate.moveOnProfileScreen(userID.description, self)
        //                        }
        //                    }
        //
        //                    cell.btnSharedUserName.touchUpInside { [weak self] (sender) in
        //                        guard let _ = self else { return }
        //                        if let userID = (searchInfo[CSharedPost] as? [String:Any] ?? [:])[CUserId] as? Int {
        //                            appDelegate.moveOnProfileScreen(userID.description, self)
        //                        }
        //                    }
        //
        //                    cell.btnProfileImg.touchUpInside {[weak self] (sender) in
        //                        guard let self = self else { return }
        //                        appDelegate.moveOnProfileScreen(searchInfo.valueForString(key: CUserId), self)
        //                    }
        //
        //                    cell.btnUserName.touchUpInside {[weak self] (sender) in
        //                        guard let self = self else { return }
        //                        appDelegate.moveOnProfileScreen(searchInfo.valueForString(key: CUserId), self)
        //                    }
        //                    // Load more data...
        //                    self.loadMore(indexPath)
        //
        //                    return cell
        //                }
        //            }
        //
        //            if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeShoutsTblCell", for: indexPath) as? HomeShoutsTblCell {
        //                cell.homeShoutsDataSetup(searchInfo)
        //
        //                cell.btnLikesCount.touchUpInside {[weak self] (sender) in
        //                    guard let self = self else { return }
        //                    self.btnLikesCountCLK(searchInfo.valueForInt(key: CId))
        //                }
        //
        //                cell.btnShare.touchUpInside {[weak self] (sender) in
        //                    guard let self = self else { return }
        //                    //self.presentActivityViewController(mediaData: searchInfo.valueForString(key: CShare_url), contentTitle: CSharePostContentMsg)
        //                    let sharePost = SharePostHelper(controller: self, dataSet: searchInfo)
        //                    sharePost.shareURL = searchInfo.valueForString(key: CShare_url)
        //                    sharePost.presentShareActivity()
        //                }
        //
        //                cell.btnMore.touchUpInside {[weak self] (sender) in
        //                    guard let self = self else { return }
        //                    if Int64(searchInfo.valueForString(key: CUserId)) == appDelegate.loginUser?.user_id{
        //                        self.btnMoreCLK(indexPath.row, searchInfo)
        //                    }else{
        //                        self.btnReportCLK(searchInfo)
        //                    }
        //                }
        //
        //                cell.btnProfileImg.touchUpInside {[weak self] (sender) in
        //                    guard let self = self else { return }
        //                    appDelegate.moveOnProfileScreen(searchInfo.valueForString(key: CUserId), self)
        //                }
        //
        //                cell.btnUserName.touchUpInside {[weak self] (sender) in
        //                    guard let self = self else { return }
        //                    appDelegate.moveOnProfileScreen(searchInfo.valueForString(key: CUserId), self)
        //                }
        //                // Load more data...
        //                self.loadMore(indexPath)
        //
        //                return cell
        //            }
        //            break
        //        case CStaticForumId:
        //            //            5-forum
        //            let isSharedPost = searchInfo.valueForInt(key: CIsSharedPost)
        //            if isSharedPost == 1{
        //                if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeSharedFourmTblCell", for: indexPath) as? HomeSharedFourmTblCell {
        //                    cell.homeFourmDataSetup(searchInfo)
        //
        //                    cell.btnLikesCount.touchUpInside {[weak self] (sender) in
        //                        guard let self = self else { return }
        //                        self.btnLikesCountCLK(searchInfo.valueForInt(key: CId))
        //                    }
        //
        //                    cell.btnMore.touchUpInside {[weak self] (sender) in
        //                        guard let self = self else { return }
        //                        let userID = (searchInfo[CSharedPost] as? [String:Any] ?? [:])[CUserId] as? Int64 ?? 0
        //                        if userID == appDelegate.loginUser?.user_id{
        //                            self.btnSharedMoreCLK(indexPath.row, searchInfo)
        //                        }else{
        //                            self.btnSharedReportCLK(postInfo: searchInfo)
        //                        }
        //                    }
        //
        //                    cell.btnSharedProfileImg.touchUpInside { [weak self] (sender) in
        //                        guard let _ = self else { return }
        //                        if let userID = (searchInfo[CSharedPost] as? [String:Any] ?? [:])[CUserId] as? Int {
        //                            appDelegate.moveOnProfileScreen(userID.description, self)
        //                        }
        //                    }
        //
        //                    cell.btnSharedUserName.touchUpInside { [weak self] (sender) in
        //                        guard let _ = self else { return }
        //                        if let userID = (searchInfo[CSharedPost] as? [String:Any] ?? [:])[CUserId] as? Int {
        //                            appDelegate.moveOnProfileScreen(userID.description, self)
        //                        }
        //                    }
        //
        //
        //                    cell.btnProfileImg.touchUpInside {[weak self] (sender) in
        //                        guard let self = self else { return }
        //                        appDelegate.moveOnProfileScreen(searchInfo.valueForString(key: CUserId), self)
        //                    }
        //
        //                    cell.btnUserName.touchUpInside {[weak self] (sender) in
        //                        guard let self = self else { return }
        //                        appDelegate.moveOnProfileScreen(searchInfo.valueForString(key: CUserId), self)
        //                    }
        //
        //                    cell.btnShare.touchUpInside {[weak self] (sender) in
        //                        guard let self = self else { return }
        //                        //self.presentActivityViewController(mediaData: searchInfo.valueForString(key: CShare_url), contentTitle: CSharePostContentMsg)
        //                        let sharePost = SharePostHelper(controller: self, dataSet: searchInfo)
        //                        sharePost.shareURL = searchInfo.valueForString(key: CShare_url)
        //                        sharePost.presentShareActivity()
        //                    }
        //
        //                    // Load more data...
        //                    self.loadMore(indexPath)
        //
        //                    return cell
        //                }
        //            }
        //
        //            if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeFourmTblCell", for: indexPath) as? HomeFourmTblCell {
        //                cell.homeFourmDataSetup(searchInfo)
        //
        //                cell.btnLikesCount.touchUpInside {[weak self] (sender) in
        //                    guard let self = self else { return }
        //                    self.btnLikesCountCLK(searchInfo.valueForInt(key: CId))
        //                }
        //
        //                cell.btnMore.touchUpInside {[weak self] (sender) in
        //                    guard let self = self else { return }
        //                    if Int64(searchInfo.valueForString(key: CUserId)) == appDelegate.loginUser?.user_id{
        //                        self.btnMoreCLK(indexPath.row, searchInfo)
        //                    }else{
        //                        self.btnReportCLK(searchInfo)
        //                    }
        //                }
        //
        //                cell.btnProfileImg.touchUpInside {[weak self] (sender) in
        //                    guard let self = self else { return }
        //                    appDelegate.moveOnProfileScreen(searchInfo.valueForString(key: CUserId), self)
        //                }
        //
        //                cell.btnUserName.touchUpInside {[weak self] (sender) in
        //                    guard let self = self else { return }
        //                    appDelegate.moveOnProfileScreen(searchInfo.valueForString(key: CUserId), self)
        //                }
        //
        //                cell.btnShare.touchUpInside {[weak self] (sender) in
        //                    guard let self = self else { return }
        //                    //self.presentActivityViewController(mediaData: searchInfo.valueForString(key: CShare_url), contentTitle: CSharePostContentMsg)
        //                    let sharePost = SharePostHelper(controller: self, dataSet: searchInfo)
        //                    sharePost.shareURL = searchInfo.valueForString(key: CShare_url)
        //                    sharePost.presentShareActivity()
        //                }
        //
        //                // Load more data...
        //                self.loadMore(indexPath)
        //
        //                return cell
        //            }
        //            break
        //        case CStaticEventId:
        //            //            6-event
        //            if searchInfo.valueForString(key: CImage).isBlank{
        //                let isSharedPost = searchInfo.valueForInt(key: CIsSharedPost)
        //                if isSharedPost == 1{
        //                    if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeSharedEventsCell", for: indexPath) as? HomeSharedEventsCell {
        //                        cell.homeEventDataSetup(searchInfo)
        //
        //                        cell.onChangeEventStatus = { [weak self] (action) in
        //                            self?.btnInterestedNotInterestedMayBeCLK(action, indexPath)
        //                        }
        //
        //                        cell.btnLikesCount.touchUpInside {[weak self] (sender) in
        //                            guard let self = self else { return }
        //                            self.btnLikesCountCLK(searchInfo.valueForInt(key: CId))
        //                        }
        //
        //                        cell.btnMore.touchUpInside {[weak self] (sender) in
        //                            guard let self = self else { return }
        //                            let userID = (searchInfo[CSharedPost] as? [String:Any] ?? [:])[CUserId] as? Int64 ?? 0
        //                            if userID == appDelegate.loginUser?.user_id{
        //                                self.btnSharedMoreCLK(indexPath.row, searchInfo)
        //                            }else{
        //                                self.btnSharedReportCLK(postInfo: searchInfo)
        //                            }
        //                        }
        //
        //                        cell.btnSharedProfileImg.touchUpInside { [weak self] (sender) in
        //                            guard let _ = self else { return }
        //                            if let userID = (searchInfo[CSharedPost] as? [String:Any] ?? [:])[CUserId] as? Int {
        //                                appDelegate.moveOnProfileScreen(userID.description, self)
        //                            }
        //                        }
        //
        //                        cell.btnSharedUserName.touchUpInside { [weak self] (sender) in
        //                            guard let _ = self else { return }
        //                            if let userID = (searchInfo[CSharedPost] as? [String:Any] ?? [:])[CUserId] as? Int {
        //                                appDelegate.moveOnProfileScreen(userID.description, self)
        //                            }
        //                        }
        //
        //                        cell.btnProfileImg.touchUpInside {[weak self] (sender) in
        //                            guard let self = self else { return }
        //                            appDelegate.moveOnProfileScreen(searchInfo.valueForString(key: CUserId), self)
        //                        }
        //
        //                        cell.btnUserName.touchUpInside {[weak self] (sender) in
        //                            guard let self = self else { return }
        //                            appDelegate.moveOnProfileScreen(searchInfo.valueForString(key: CUserId), self)
        //                        }
        //
        //                        cell.btnShare.touchUpInside {[weak self] (sender) in
        //                            guard let self = self else { return }
        //                            //self.presentActivityViewController(mediaData: searchInfo.valueForString(key: CShare_url), contentTitle: CSharePostContentMsg)
        //                            let sharePost = SharePostHelper(controller: self, dataSet: searchInfo)
        //                            sharePost.shareURL = searchInfo.valueForString(key: CShare_url)
        //                            sharePost.presentShareActivity()
        //                        }
        //
        //                        // Load more data...
        //                        self.loadMore(indexPath)
        //
        //                        return cell
        //                    }
        //                }
        //                if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeEventsCell", for: indexPath) as? HomeEventsCell {
        //                    cell.homeEventDataSetup(searchInfo)
        //
        //                    cell.onChangeEventStatus = { [weak self] (action) in
        //                        self?.btnInterestedNotInterestedMayBeCLK(action, indexPath)
        //                    }
        //
        //                    cell.btnLikesCount.touchUpInside {[weak self] (sender) in
        //                        guard let self = self else { return }
        //                        self.btnLikesCountCLK(searchInfo.valueForInt(key: CId))
        //                    }
        //
        //                    cell.btnMore.touchUpInside {[weak self] (sender) in
        //                        guard let self = self else { return }
        //                        if Int64(searchInfo.valueForString(key: CUserId)) == appDelegate.loginUser?.user_id{
        //                            self.btnMoreCLK(indexPath.row, searchInfo)
        //                        }else{
        //                            self.btnReportCLK(searchInfo)
        //                        }
        //                    }
        //
        //                    cell.btnProfileImg.touchUpInside {[weak self] (sender) in
        //                        guard let self = self else { return }
        //                        appDelegate.moveOnProfileScreen(searchInfo.valueForString(key: CUserId), self)
        //                    }
        //
        //                    cell.btnUserName.touchUpInside {[weak self] (sender) in
        //                        guard let self = self else { return }
        //                        appDelegate.moveOnProfileScreen(searchInfo.valueForString(key: CUserId), self)
        //                    }
        //
        //                    cell.btnShare.touchUpInside {[weak self] (sender) in
        //                        guard let self = self else { return }
        //                        //self.presentActivityViewController(mediaData: searchInfo.valueForString(key: CShare_url), contentTitle: CSharePostContentMsg)
        //                        let sharePost = SharePostHelper(controller: self, dataSet: searchInfo)
        //                        sharePost.shareURL = searchInfo.valueForString(key: CShare_url)
        //                        sharePost.presentShareActivity()
        //                    }
        //
        //                    // Load more data...
        //                    self.loadMore(indexPath)
        //
        //                    return cell
        //                }
        //            }else{
        //
        //                let isSharedPost = searchInfo.valueForInt(key: CIsSharedPost)
        //                if isSharedPost == 1{
        //                    if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeSharedEventImageTblCell", for: indexPath) as? HomeSharedEventImageTblCell {
        //                        cell.homeEventDataSetup(searchInfo)
        //
        //                        cell.btnLikesCount.touchUpInside {[weak self] (sender) in
        //                            guard let self = self else { return }
        //                            self.btnLikesCountCLK(searchInfo.valueForInt(key: CId))
        //                        }
        //                        cell.onChangeEventStatus = { [weak self] (action) in
        //                            self?.btnInterestedNotInterestedMayBeCLK(action, indexPath)
        //                        }
        //
        //                        cell.btnMore.touchUpInside {[weak self] (sender) in
        //                            guard let self = self else { return }
        //                            let userID = (searchInfo[CSharedPost] as? [String:Any] ?? [:])[CUserId] as? Int64 ?? 0
        //                            if userID == appDelegate.loginUser?.user_id{
        //                                self.btnSharedMoreCLK(indexPath.row, searchInfo)
        //                            }else{
        //                                self.btnSharedReportCLK(postInfo: searchInfo)
        //                            }
        //                        }
        //
        //                        cell.btnSharedProfileImg.touchUpInside { [weak self] (sender) in
        //                            guard let _ = self else { return }
        //                            if let userID = (searchInfo[CSharedPost] as? [String:Any] ?? [:])[CUserId] as? Int {
        //                                appDelegate.moveOnProfileScreen(userID.description, self)
        //                            }
        //                        }
        //
        //                        cell.btnSharedUserName.touchUpInside { [weak self] (sender) in
        //                            guard let _ = self else { return }
        //                            if let userID = (searchInfo[CSharedPost] as? [String:Any] ?? [:])[CUserId] as? Int {
        //                                appDelegate.moveOnProfileScreen(userID.description, self)
        //                            }
        //                        }
        //
        //                        cell.btnProfileImg.touchUpInside {[weak self] (sender) in
        //                            guard let self = self else { return }
        //                            appDelegate.moveOnProfileScreen(searchInfo.valueForString(key: CUserId), self)
        //                        }
        //
        //                        cell.btnUserName.touchUpInside {[weak self] (sender) in
        //                            guard let self = self else { return }
        //                            appDelegate.moveOnProfileScreen(searchInfo.valueForString(key: CUserId), self)
        //                        }
        //
        //                        cell.btnShare.touchUpInside {[weak self] (sender) in
        //                            guard let self = self else { return }
        //                            //self.presentActivityViewController(mediaData: searchInfo.valueForString(key: CShare_url), contentTitle: CSharePostContentMsg)
        //                            let sharePost = SharePostHelper(controller: self, dataSet: searchInfo)
        //                            sharePost.shareURL = searchInfo.valueForString(key: CShare_url)
        //                            sharePost.presentShareActivity()
        //                        }
        //
        //                        // Load more data...
        //                        self.loadMore(indexPath)
        //
        //                        return cell
        //                    }
        //                }
        //
        //                if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeEventImageTblCell", for: indexPath) as? HomeEventImageTblCell {
        //                    cell.homeEventDataSetup(searchInfo)
        //
        //                    cell.btnLikesCount.touchUpInside {[weak self] (sender) in
        //                        guard let self = self else { return }
        //                        self.btnLikesCountCLK(searchInfo.valueForInt(key: CId))
        //                    }
        //                    cell.onChangeEventStatus = { [weak self] (action) in
        //                        self?.btnInterestedNotInterestedMayBeCLK(action, indexPath)
        //                    }
        //
        //                    cell.btnMore.touchUpInside {[weak self] (sender) in
        //                        guard let self = self else { return }
        //                        if Int64(searchInfo.valueForString(key: CUserId)) == appDelegate.loginUser?.user_id{
        //                            self.btnMoreCLK(indexPath.row, searchInfo)
        //                        }else{
        //                            self.btnReportCLK(searchInfo)
        //                        }
        //                    }
        //
        //                    cell.btnProfileImg.touchUpInside {[weak self] (sender) in
        //                        guard let self = self else { return }
        //                        appDelegate.moveOnProfileScreen(searchInfo.valueForString(key: CUserId), self)
        //                    }
        //
        //                    cell.btnUserName.touchUpInside {[weak self] (sender) in
        //                        guard let self = self else { return }
        //                        appDelegate.moveOnProfileScreen(searchInfo.valueForString(key: CUserId), self)
        //                    }
        //
        //                    cell.btnShare.touchUpInside {[weak self] (sender) in
        //                        guard let self = self else { return }
        //                        //self.presentActivityViewController(mediaData: searchInfo.valueForString(key: CShare_url), contentTitle: CSharePostContentMsg)
        //                        let sharePost = SharePostHelper(controller: self, dataSet: searchInfo)
        //                        sharePost.shareURL = searchInfo.valueForString(key: CShare_url)
        //                        sharePost.presentShareActivity()
        //                    }
        //
        //                    // Load more data...
        //                    self.loadMore(indexPath)
        //
        //                    return cell
        //                }
        //
        //            }
        //            break
        //
        //        case CStaticSearchUserTypeId:
        //            // Users
        //            if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeAddFrdTblCell", for: indexPath) as? HomeAddFrdTblCell {
        //
        //                cell.lblUserName.text = searchInfo.valueForString(key: CFirstname) + " " + searchInfo.valueForString(key: CLastname)
        //                cell.imgUser.loadImageFromUrl(searchInfo.valueForString(key: CImage), true)
        //
        //                if appDelegate.loginUser?.user_id == Int64(searchInfo.valueForString(key: CUserId)){
        //                    cell.btnAddFrd.isHidden = true
        //                }else{
        //                    cell.btnAddFrd.isHidden = false
        //                }
        //
        //                if searchInfo.valueForInt(key: CFriend_status) == 2 {
        //                    cell.btnAddFrd.isHidden = true
        //                    cell.viewAcceptReject.isHidden = false
        //                }else{
        //                    cell.btnAddFrd.isHidden = false
        //                    cell.viewAcceptReject.isHidden = true
        //
        //                    switch searchInfo.valueForInt(key: CFriend_status) {
        //                    case 0:
        //                        cell.btnAddFrd.setTitle("  \(CBtnAddFriend)  ", for: .normal)
        //                    case 1:
        //                        cell.btnAddFrd.setTitle("  \(CBtnCancelRequest)  ", for: .normal)
        //                    case 5:
        //                        cell.btnAddFrd.setTitle("  \(CBtnUnfriend)  ", for: .normal)
        //                    default:
        //                        break
        //                    }
        //                }
        //
        //                cell.btnAddFrd.touchUpInside {[weak self] (sender) in
        //                    guard let self = self else { return }
        //                    var frndStatus = 0
        //                    var isShowAlert = false
        //                    var alertMessage = ""
        //                    switch searchInfo.valueForInt(key: CFriend_status) {
        //                    case 0:
        //                        frndStatus = CFriendRequestSent
        //                    case 1:
        //                        frndStatus = CFriendRequestCancel
        //                        isShowAlert = true
        //                        alertMessage = CMessageCancelRequest
        //                    case 5:
        //                        frndStatus = CFriendRequestUnfriend
        //                        isShowAlert = true
        //                        alertMessage = CMessageUnfriend
        //                    default:
        //                        break
        //                    }
        //                    if isShowAlert{
        //                        self.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: alertMessage, btnOneTitle: CBtnYes, btnOneTapped: { [weak self] (alert) in
        //                            guard let self = self else { return }
        //                            self.friendStatusApi(searchInfo, searchInfo.valueForInt(key: CUserId), frndStatus)
        //                            }, btnTwoTitle: CBtnNo, btnTwoTapped: nil)
        //                    }else{
        //                        self.friendStatusApi(searchInfo, searchInfo.valueForInt(key: CUserId), frndStatus)
        //                    }
        //                }
        //
        //                cell.btnAccept.touchUpInside {[weak self] (sender) in
        //                    guard let self = self else { return }
        //                    self.friendStatusApi(searchInfo, searchInfo.valueForInt(key: CUserId), 2)
        //                }
        //
        //                cell.btnReject.touchUpInside {[weak self] (sender) in
        //                    guard let self = self else { return }
        //                    self.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: CAlertMessageForRejectRequest, btnOneTitle: CBtnYes, btnOneTapped: { [weak self] (alert) in
        //                        guard let self = self else { return }
        //                        self.friendStatusApi(searchInfo, searchInfo.valueForInt(key: CUserId), 3)
        //                        }, btnTwoTitle: CBtnNo, btnTwoTapped: nil)
        //                }
        //
        //                // Load more data...
        //                self.loadMore(indexPath)
        //
        //                return cell
        //            }
        //            break
        //        case CStaticPollId: // Poll Cell....
        //            let isSharedPost = searchInfo.valueForInt(key: CIsSharedPost)
        //            if isSharedPost == 1{
        //                if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeSharedPollTblCell", for: indexPath) as? HomeSharedPollTblCell {
        //
        //                    cell.homePollDataSetup(searchInfo)
        //
        //                    cell.btnLikesCount.touchUpInside {[weak self] (sender) in
        //                        guard let self = self else { return }
        //                        self.btnLikesCountCLK(searchInfo.valueForInt(key: CId))
        //                    }
        //                    cell.btnMore.tag = indexPath.row
        //                    cell.onMorePressed = { [weak self] (index) in
        //                        guard let _ = self else { return }
        //                        let sharePostData = searchInfo[CSharedPost] as? [String:Any] ?? [:]
        //                        let userID = sharePostData[CUserId] as? Int64 ?? 0
        //                        if userID == appDelegate.loginUser?.user_id{
        //                            self?.presentActionsheetWithOneButton(actionSheetTitle: nil, actionSheetMessage: nil, btnOneTitle: CBtnDelete, btnOneStyle: .default) { [weak self] (alert) in
        //                                guard let _ = self else { return }
        //                                let postID = sharePostData[CId] as? Int ?? 0
        //                                self?.deletePost(postID, index)
        //                            }
        //                        }else{
        //                            self?.btnSharedReportCLK(postInfo: searchInfo)
        //                        }
        //                    }
        //
        //                    cell.btnSharedProfileImg.touchUpInside { [weak self] (sender) in
        //                        guard let _ = self else { return }
        //                        if let userID = (searchInfo[CSharedPost] as? [String:Any] ?? [:])[CUserId] as? Int {
        //                            appDelegate.moveOnProfileScreen(userID.description, self)
        //                        }
        //                    }
        //
        //                    cell.btnSharedUserName.touchUpInside { [weak self] (sender) in
        //                        guard let _ = self else { return }
        //                        if let userID = (searchInfo[CSharedPost] as? [String:Any] ?? [:])[CUserId] as? Int {
        //                            appDelegate.moveOnProfileScreen(userID.description, self)
        //                        }
        //                    }
        //
        //                    cell.btnProfileImg.touchUpInside {[weak self] (sender) in
        //                        guard let self = self else { return }
        //                        appDelegate.moveOnProfileScreen(searchInfo.valueForString(key: CUserId), self)
        //                    }
        //
        //                    cell.btnUserName.touchUpInside {[weak self] (sender) in
        //                        guard let self = self else { return }
        //                        appDelegate.moveOnProfileScreen(searchInfo.valueForString(key: CUserId), self)
        //                    }
        //
        //                    cell.btnShare.touchUpInside {[weak self] (sender) in
        //                        guard let self = self else { return }
        //                        //self.presentActivityViewController(mediaData: searchInfo.valueForString(key: CShare_url), contentTitle: CSharePostContentMsg)
        //                        let sharePost = SharePostHelper(controller: self, dataSet: searchInfo)
        //                        sharePost.shareURL = searchInfo.valueForString(key: CShare_url)
        //                        sharePost.presentShareActivity()
        //                    }
        //
        //                    // Load more data...
        //                    self.loadMore(indexPath)
        //
        //                    return cell
        //                }
        //            }
        //            if let cell = tableView.dequeueReusableCell(withIdentifier: "HomePollTblCell", for: indexPath) as? HomePollTblCell {
        //
        //                cell.homePollDataSetup(searchInfo, isSelected: false)
        //
        //                cell.btnLikesCount.touchUpInside {[weak self] (sender) in
        //                    guard let self = self else { return }
        //                    self.btnLikesCountCLK(searchInfo.valueForInt(key: CId))
        //                }
        //                cell.btnMore.tag = indexPath.row
        //                cell.onMorePressed = { [weak self] (index) in
        //                    guard let _ = self else { return }
        //                    let postData = self?.arrHomeSearch[index] ?? [:]
        //                    if Int64(postData.valueForString(key: CUserId)) == appDelegate.loginUser?.user_id{
        //                        self?.presentActionsheetWithOneButton(actionSheetTitle: nil, actionSheetMessage: nil, btnOneTitle: CBtnDelete, btnOneStyle: .default) { [weak self] (alert) in
        //                            guard let _ = self else { return }
        //                            let postId = postData.valueForInt(key: CId) ?? 0
        //                            self?.deletePost(postId, index)
        //                        }
        //                    }else{
        //                        self?.btnReportCLK(postData)
        //                    }
        //                }
        //
        //                cell.btnProfileImg.touchUpInside {[weak self] (sender) in
        //                    guard let self = self else { return }
        //                    appDelegate.moveOnProfileScreen(searchInfo.valueForString(key: CUserId), self)
        //                }
        //
        //                cell.btnUserName.touchUpInside {[weak self] (sender) in
        //                    guard let self = self else { return }
        //                    appDelegate.moveOnProfileScreen(searchInfo.valueForString(key: CUserId), self)
        //                }
        //
        //                cell.btnShare.touchUpInside {[weak self] (sender) in
        //                    guard let self = self else { return }
        //                    //self.presentActivityViewController(mediaData: searchInfo.valueForString(key: CShare_url), contentTitle: CSharePostContentMsg)
        //                    let sharePost = SharePostHelper(controller: self, dataSet: searchInfo)
        //                    sharePost.shareURL = searchInfo.valueForString(key: CShare_url)
        //                    sharePost.presentShareActivity()
        //                }
        //
        //                // Load more data...
        //                self.loadMore(indexPath)
        //
        //                return cell
        //            }
        //            break
        //        default:
        //            break
        //        }
        
        
        return tableView.tableViewDummyCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let searchInfo = arrHomeSearch[indexPath.row]
        let postId = searchInfo.valueForInt(key: CId)
        let isSharedPost = searchInfo.valueForInt(key: CIsSharedPost)
        let isPostDeleted = searchInfo.valueForInt(key: CIsPostDeleted)
        if isPostDeleted == 1{
            let sharePostData = searchInfo[CSharedPost] as? [String:Any] ?? [:]
            let sharedPostId = sharePostData[CId] as? Int ?? 0
            guard let viewcontroller = CStoryboardSharedPost.instantiateViewController(withIdentifier: "PostDeleteDetailViewController") as? PostDeleteDetailViewController else {
                return
            }
            viewcontroller.postID = sharedPostId
            self.navigationController?.pushViewController(viewcontroller, animated: true)
            return
        }
        
        switch searchInfo.valueForInt(key: CSearchType) {
        case CStaticArticleId:
            
            if isSharedPost == 1{
                let sharePostData = searchInfo[CSharedPost] as? [String:Any] ?? [:]
                let sharedPostId = sharePostData[CId] as? Int ?? 0
                guard let viewcontroller = CStoryboardSharedPost.instantiateViewController(withIdentifier: "ArticleSharedDetailViewController") as? ArticleSharedDetailViewController else {
                    return
                }
                viewcontroller.articleID = sharedPostId
                self.navigationController?.pushViewController(viewcontroller, animated: true)
                break
            }
            if let viewArticleVC = CStoryboardHome.instantiateViewController(withIdentifier: "ArticleDetailViewController") as? ArticleDetailViewController {
                viewArticleVC.articleID = postId
                self.navigationController?.pushViewController(viewArticleVC, animated: true)
            }
            break
            
        case CStaticGalleryId:
            let isSharedPost = searchInfo.valueForInt(key: CIsSharedPost)
            if isSharedPost == 1{
                let sharePostData = searchInfo[CSharedPost] as? [String:Any] ?? [:]
                let sharedPostId = sharePostData[CId] as? Int ?? 0
                guard let viewcontroller = CStoryboardSharedPost.instantiateViewController(withIdentifier: "ImageSharedDetailViewController") as? ImageSharedDetailViewController else {
                    return
                }
                viewcontroller.imgPostId = sharedPostId
                self.navigationController?.pushViewController(viewcontroller, animated: true)
                break
            }
            if let imageDetailsVC = CStoryboardImage.instantiateViewController(withIdentifier: "ImageDetailViewController") as? ImageDetailViewController {
                imageDetailsVC.imgPostId = postId
                self.navigationController?.pushViewController(imageDetailsVC, animated: true)
            }
            break
            
        case CStaticChirpyId:
            
            if searchInfo.valueForString(key: CImage).isBlank{
                let isSharedPost = searchInfo.valueForInt(key: CIsSharedPost)
                if isSharedPost == 1{
                    let sharePostData = searchInfo[CSharedPost] as? [String:Any] ?? [:]
                    let sharedPostId = sharePostData[CId] as? Int ?? 0
                    guard let viewcontroller = CStoryboardSharedPost.instantiateViewController(withIdentifier: "ChirpySharedDetailsViewController") as? ChirpySharedDetailsViewController else {
                        return
                    }
                    viewcontroller.chirpyID = sharedPostId
                    self.navigationController?.pushViewController(viewcontroller, animated: true)
                    break
                }
                if let chirpyDetailsVC = CStoryboardHome.instantiateViewController(withIdentifier: "ChirpyDetailsViewController") as? ChirpyDetailsViewController{
                    chirpyDetailsVC.chirpyID = postId
                    self.navigationController?.pushViewController(chirpyDetailsVC, animated: true)
                }
            }else{
                let isSharedPost = searchInfo.valueForInt(key: CIsSharedPost)
                if isSharedPost == 1{
                    let sharePostData = searchInfo[CSharedPost] as? [String:Any] ?? [:]
                    let sharedPostId = sharePostData[CId] as? Int ?? 0
                    guard let viewcontroller = CStoryboardSharedPost.instantiateViewController(withIdentifier: "ChirpySharedImageDetailsViewController") as? ChirpySharedImageDetailsViewController else {
                        return
                    }
                    viewcontroller.chirpyID = sharedPostId
                    self.navigationController?.pushViewController(viewcontroller, animated: true)
                    break
                }
                if let chirpyImageVC = CStoryboardHome.instantiateViewController(withIdentifier: "ChirpyImageDetailsViewController") as? ChirpyImageDetailsViewController{
                    chirpyImageVC.chirpyID = postId
                    self.navigationController?.pushViewController(chirpyImageVC, animated: true)
                }
            }
        case CStaticShoutId:
            let isSharedPost = searchInfo.valueForInt(key: CIsSharedPost)
            if isSharedPost == 1{
                let sharePostData = searchInfo[CSharedPost] as? [String:Any] ?? [:]
                let sharedPostId = sharePostData[CId] as? Int ?? 0
                guard let viewcontroller = CStoryboardSharedPost.instantiateViewController(withIdentifier: "ShoutsSharedDetailViewController") as? ShoutsSharedDetailViewController else {
                    return
                }
                viewcontroller.shoutID = sharedPostId
                self.navigationController?.pushViewController(viewcontroller, animated: true)
                break
            }
            if let shoutsDetailsVC = CStoryboardHome.instantiateViewController(withIdentifier: "ShoutsDetailViewController") as? ShoutsDetailViewController{
                shoutsDetailsVC.shoutID = postId
                self.navigationController?.pushViewController(shoutsDetailsVC, animated: true)
            }
            break
            
        case CStaticForumId:
            let isSharedPost = searchInfo.valueForInt(key: CIsSharedPost)
            if isSharedPost == 1{
                let sharePostData = searchInfo[CSharedPost] as? [String:Any] ?? [:]
                let sharedPostId = sharePostData[CId] as? Int ?? 0
                guard let viewcontroller = CStoryboardSharedPost.instantiateViewController(withIdentifier: "ForumSharedDetailViewController") as? ForumSharedDetailViewController else {
                    return
                }
                viewcontroller.forumID = sharedPostId
                self.navigationController?.pushViewController(viewcontroller, animated: true)
                break
            }
            if let forumDetailsVC = CStoryboardHome.instantiateViewController(withIdentifier: "ForumDetailViewController") as? ForumDetailViewController{
                forumDetailsVC.forumID = postId
                self.navigationController?.pushViewController(forumDetailsVC, animated: true)
            }
            break
            
        case CStaticEventId:
            if searchInfo.valueForString(key: CImage).isBlank{
                let isSharedPost = searchInfo.valueForInt(key: CIsSharedPost)
                if isSharedPost == 1{
                    let sharePostData = searchInfo[CSharedPost] as? [String:Any] ?? [:]
                    let sharedPostId = sharePostData[CId] as? Int ?? 0
                    guard let viewcontroller = CStoryboardSharedPost.instantiateViewController(withIdentifier: "EventSharedDetailViewController") as? EventSharedDetailViewController else {
                        return
                    }
                    viewcontroller.postID = sharedPostId
                    self.navigationController?.pushViewController(viewcontroller, animated: true)
                    break
                }
                if let eventDetailsVC = CStoryboardEvent.instantiateViewController(withIdentifier: "EventDetailViewController") as? EventDetailViewController {
                    eventDetailsVC.postID = searchInfo.valueForInt(key: CId)
                    self.navigationController?.pushViewController(eventDetailsVC, animated: true)
                }
            }else{
                let isSharedPost = searchInfo.valueForInt(key: CIsSharedPost)
                if isSharedPost == 1{
                    let sharePostData = searchInfo[CSharedPost] as? [String:Any] ?? [:]
                    let sharedPostId = sharePostData[CId] as? Int ?? 0
                    guard let viewcontroller = CStoryboardSharedPost.instantiateViewController(withIdentifier: "EventSharedDetailImageViewController") as? EventSharedDetailImageViewController else {
                        return
                    }
                    viewcontroller.postID = sharedPostId
                    self.navigationController?.pushViewController(viewcontroller, animated: true)
                    break
                }
                if let eventDetailsVC = CStoryboardEvent.instantiateViewController(withIdentifier: "EventDetailImageViewController") as? EventDetailImageViewController {
                    eventDetailsVC.postID = searchInfo.valueForInt(key: CId)
                    self.navigationController?.pushViewController(eventDetailsVC, animated: true)
                }
            }
            
            break
        case CStaticPollId: // Poll Cell....
            let isSharedPost = searchInfo.valueForInt(key: CIsSharedPost)
            if isSharedPost == 1{
                let sharePostData = searchInfo[CSharedPost] as? [String:Any] ?? [:]
                let sharedPostId = sharePostData[CId] as? Int ?? 0
                guard let viewcontroller = CStoryboardSharedPost.instantiateViewController(withIdentifier: "PollSharedDetailsViewController") as? PollSharedDetailsViewController else {
                    return
                }
                viewcontroller.pollID = sharedPostId
                self.navigationController?.pushViewController(viewcontroller, animated: true)
                break
            }
            if let viewArticleVC = CStoryboardPoll.instantiateViewController(withIdentifier: "PollDetailsViewController") as? PollDetailsViewController {
                viewArticleVC.pollID = postId
                self.navigationController?.pushViewController(viewArticleVC, animated: true)
            }
            break
        case CStaticSearchUserTypeId: // User
            appDelegate.moveOnProfileScreen(searchInfo.valueForString(key: CUserId), self)
            break
        default:
            break
        }
    }
}

// MARK:- --------  TableView Cells Action
extension HomeSearchViewController{
    fileprivate func btnInterestedNotInterestedMayBeCLK(_ type : Int?, _ indexpath : IndexPath?){
        
        var postInfo = arrHomeSearch[indexpath!.row]
        if type != postInfo.valueForInt(key: CIsInterested){
            // Update existing count here...
            let totalIntersted = postInfo.valueForInt(key: CTotalInterestedUsers)
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
            }
            MIGeneralsAPI.shared().interestNotInterestMayBe(postId, type!, viewController: self)
            arrHomeSearch.remove(at: (indexpath?.row)!)
            arrHomeSearch.insert(postInfo, at: (indexpath?.row)!)
            UIView.performWithoutAnimation {
                if (self.tblEvents.indexPathsForVisibleRows?.contains(indexpath!))!{
                    self.tblEvents.reloadRows(at: [indexpath!], with: .none)
                }
            }
        }
    }
    
    fileprivate func btnLikesCountCLK(_ postId : Int?) {
        
        if let likeVC = CStoryboardGeneral.instantiateViewController(withIdentifier: "LikeViewController") as? LikeViewController {
            likeVC.postID = postId
            self.navigationController?.pushViewController(likeVC, animated: true)
        }
    }
    
    fileprivate func btnCommentCLK(_ postId : Int?) {
        
        if let commentVC = CStoryboardGeneral.instantiateViewController(withIdentifier: "CommentViewController") as? CommentViewController {
            commentVC.postId = postId
            self.navigationController?.pushViewController(commentVC, animated: true)
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
                self?.navigationController?.pushViewController(reportVC, animated: true)
            }
        }
    }
    
    fileprivate func btnReportCLK(_ postInfo : [String : Any]?) {
        
        self.presentActionsheetWithOneButton(actionSheetTitle: nil, actionSheetMessage: nil, btnOneTitle: CReport, btnOneStyle: .default) { [weak self] (alert) in
            guard let self = self else { return }
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
                default:
                    break
                }
                reportVC.userID = postInfo?.valueForInt(key: CUserId)
                reportVC.reportID = postInfo?.valueForInt(key: CId)
                self.navigationController?.pushViewController(reportVC, animated: true)
            }
        }
    }
    //------Button More with Action
    fileprivate func btnMoreCLK(_ index : Int?, _ postInfo : [String : Any]) {
        
        let postId = postInfo.valueForInt(key: CId)
        let postType = postInfo.valueForInt(key: CPostType)
        let currentDateTime = Date().timeIntervalSince1970
        
        if let endDateTime = postInfo.valueForDouble(key: CEvent_End_Date), (postType == CStaticEventId), (Double(currentDateTime) > endDateTime) {
            
            self.presentActionsheetWithOneButton(actionSheetTitle: nil, actionSheetMessage: nil, btnOneTitle: CBtnDelete, btnOneStyle: .default) { [weak self] (onActionClicked) in
                
                guard let `self` = self else { return }
                self.deletePost(postId ?? 0, index ?? 0)
            }
        } else {
            self.presentActionsheetWithTwoButtons(actionSheetTitle: nil, actionSheetMessage: nil, btnOneTitle: CBtnEdit, btnOneStyle: .default, btnOneTapped: { [weak self] (alert) in
                guard let self = self else { return }
                switch postInfo.valueForInt(key: CPostType) {
                case 1:
                    if let addArticleVC = CStoryboardHome.instantiateViewController(withIdentifier: "AddArticleViewController") as? AddArticleViewController {
                        addArticleVC.articleType = .editArticle
                        addArticleVC.articleID = postId
                        self.navigationController?.pushViewController(addArticleVC, animated: true)
                    }
                case 2:
                    /*if let galleyVC = CStoryboardImage.instantiateViewController(withIdentifier: "GalleryPreviewViewController") as? GalleryPreviewViewController {
                     galleyVC.imagePostType = .editImagePost
                     galleyVC.imgPostId = postId
                     self.navigationController?.pushViewController(galleyVC, animated: true)
                     }*/
                    if let galleryListVC = CStoryboardHome.instantiateViewController(withIdentifier: "AddMediaViewController") as? AddMediaViewController{
                        galleryListVC.imagePostType = .editImagePost
                        galleryListVC.imgPostId = postId
                        self.navigationController?.pushViewController(galleryListVC, animated: true)
                    }
                case 3:
                    if let addChirpyVC = CStoryboardHome.instantiateViewController(withIdentifier: "AddChirpyViewController") as? AddChirpyViewController {
                        addChirpyVC.chirpyType = .editChirpy
                        addChirpyVC.chirpyID = postId
                        self.navigationController?.pushViewController(addChirpyVC, animated: true)
                    }
                case 4:
                    if let createShoutsVC = CStoryboardHome.instantiateViewController(withIdentifier: "CreateShoutsViewController") as? CreateShoutsViewController {
                        createShoutsVC.shoutsType = .editShouts
                        createShoutsVC.shoutID = postId
                        self.navigationController?.pushViewController(createShoutsVC, animated: true)
                    }
                    
                case 5:
                    if let addForumVC = CStoryboardHome.instantiateViewController(withIdentifier: "AddForumViewController") as? AddForumViewController {
                        addForumVC.forumType = .editForum
                        addForumVC.forumID = postId
                        self.navigationController?.pushViewController(addForumVC, animated: true)
                    }
                    
                case 6:
                    if let addEventVC = CStoryboardEvent.instantiateViewController(withIdentifier: "AddEventViewController") as? AddEventViewController {
                        addEventVC.eventType = .editEvent
                        addEventVC.eventID = postId
                        self.navigationController?.pushViewController(addEventVC, animated: true)
                    }
                default:
                    break
                }
                
            }, btnTwoTitle: CBtnDelete, btnTwoStyle: .default) { [weak self] (alert) in
                guard let self = self else { return }
                self.deletePost(postId!, index!)
            }
        }
    }
}

// MARK:- -------- Action Event
extension HomeSearchViewController {
    
    @IBAction func btnSearchCancelCLK(_ sender : UIButton) {
        txtSearch.text = nil
        timeStamp = nil
        isPost = nil
        tblEvents.restore()
        arrHomeSearch.removeAll()
        tblEvents.reloadData()
    }
    @IBAction func btnBackMainCLK(_ sender : UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
}



