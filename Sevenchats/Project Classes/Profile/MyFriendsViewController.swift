//
//  MyFriendsViewController.swift
//  Sevenchats
//
//  Created by mac-0005 on 29/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Nagaraju K and Chandrika R                                 *
 * Model   : MyFriendsViewController                     *
 * Changes :                                             *
 *                                                       *
 ********************************************************/

import UIKit

class MyFriendsViewController: ParentViewController {
    
    @IBOutlet weak var viewSearchBar : UIView!
    @IBOutlet weak var btnSearch : UIButton!
    @IBOutlet weak var btnBack : UIButton!
    @IBOutlet weak var btnCancel : UIButton!
    @IBOutlet weak var txtSearch : UITextField!{
        didSet{
            txtSearch.returnKeyType = .search
        }
    }
    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var cnNavigationHeight : NSLayoutConstraint!
    @IBOutlet weak var tblFriendList : UITableView!
    @IBOutlet weak var clTabBar : UICollectionView!
    
    var selectedIndexPath = IndexPath(item: 0, section: 0)
    
    var isRefreshingUserData = false
//    var arrFriendList = [[String:Any]]()
    var pageNumber = 1
    var strEmptyMessage = ""
    var refreshControl = UIRefreshControl()
    var apiTask : URLSessionTask?
    var isFromSideMenu = false
    var arrList = [[String : Any]?]()
    var arrRequestList = [[String : Any]?]()
    var arrPendingList = [[String : Any]?]()
    var Friend_status : Int?
    var arrFriendListNew = [[String:Any]]()
    var arrFriendList : [[String:Any]] = [[:]] {
           didSet{
               self.arrFriendListNew = arrFriendList
               
           }
       }
    var searchStatus:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Initialization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateUIAccordingToLanguage()
        self.getFriendList(txtSearch.text, showLoader: true)
        self.getListFriends("", showLoader: true)
        self.getRequestList("", showLoader: true)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(NotificationRecived), name: NSNotification.Name(rawValue: "NotificationRecived"), object: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func NotificationRecived(){
        DispatchQueue.main.async {
            self.tblFriendList.reloadData()
        }
        
    }
    
    // MARK:- --------- Initialization
    func Initialization(){
        NotificationCenter.default.addObserver(self, selector: #selector(NotificationRecived), name: NSNotification.Name(rawValue: "NotificationRecived"), object: nil)
        
        cnNavigationHeight.constant = IS_iPhone_X_Series ? 84 : 64
        
        GCDMainThread.async {
            self.viewSearchBar.layer.cornerRadius = self.viewSearchBar.frame.size.height/2
            self.refreshControl.addTarget(self, action: #selector(self.pullToRefresh), for: .valueChanged)
            self.refreshControl.tintColor = ColorAppTheme
            self.tblFriendList.pullToRefreshControl = self.refreshControl
        }
        self.addBackOrHomeBurgerButton()
        
    }
    
    func updateUIAccordingToLanguage(){
        
        if Localization.sharedInstance.applicationFlowWithLanguageRTL() {
            // Reverse Flow...
            btnSearch.contentHorizontalAlignment = .left
            //btnBack.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        }else{
            // Normal Flow...
            btnSearch.contentHorizontalAlignment = .right
            //btnBack.transform = CGAffineTransform.identity
        }
        
        btnCancel.setTitle(CBtnCancel, for: .normal)
        lblTitle.text = CProfileFriends
        
    }
    
    func addBackOrHomeBurgerButton(){
        
        if isFromSideMenu{
            self.view.tag = 110
            var imgMenu : UIImage?
            if Localization.sharedInstance.applicationFlowWithLanguageRTL() {
                imgMenu = UIImage(named: "ic_sidemenu_reverse")
                self.btnBack.setImage(imgMenu, for: .normal)
            }
            else{
                imgMenu = UIImage(named: "ic_sidemenu")
                self.btnBack.setImage(imgMenu, for: .normal)
            }
        }else{
            self.view.tag = 109
            var imgBack : UIImage?
            if Localization.sharedInstance.applicationFlowWithLanguageRTL() {
                imgBack = UIImage(named: "ic_back_reverse")!
            }else{
                imgBack = UIImage(named: "ic_back")!
            }
            self.btnBack.setImage(imgBack, for: .normal)
        }
        self.btnBack.addTarget(self, action: #selector(onBackButtonAction), for: .touchUpInside)
    }
    
    @objc func onBackButtonAction(){
        
        if isFromSideMenu{
            appDelegate.showSidemenu()
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
}
// MARK:- --------- Api Functions
extension MyFriendsViewController{
    @objc func pullToRefresh() {
        if apiTask?.state == URLSessionTask.State.running {
            apiTask?.cancel()
        }
        
        self.pageNumber = 1
        refreshControl.beginRefreshing()
        self.getFriendList(txtSearch.text, showLoader: false)
    }
    
    fileprivate func getFriendList(_ search : String?, showLoader : Bool) {
        
        if apiTask?.state == URLSessionTask.State.running {
            apiTask?.cancel()
        }
        
        var reqType = 0
        switch selectedIndexPath.item {
        case 0:
            reqType = 0
        case 1:
            reqType = 1
        default:
            reqType = 2
        }
        
        // Add load more indicator here...
        if self.pageNumber > 2 {
            self.tblFriendList.tableFooterView = self.loadMoreIndicator(ColorAppTheme)
        }else{
            self.tblFriendList.tableFooterView = nil
        }
        guard let user_Id = appDelegate.loginUser?.user_id else {
            return
        }
        
        apiTask = APIRequest.shared().getFriendList(page: self.pageNumber, request_type: reqType, search: search, group_id : Int(user_Id), showLoader: showLoader, completion: { [weak self] (response, error) in
            guard let self = self else { return }
            self.refreshControl.endRefreshing()
            self.tblFriendList.tableFooterView = nil
           // MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: "\(CMessagePleaseWait)...")
            if response != nil{
                if reqType == 0 {
                    if let arrList = response!["my_friends"] as? [[String:Any]]{
                        // Remove all data here when page number == 1
                        if self.pageNumber == 1{
                            self.arrFriendList.removeAll()
                            self.tblFriendList.reloadData()
                            
                        }
                        // Add Data here...
                        if arrList.count > 0{
                            self.arrFriendList = self.arrFriendList + arrList
                            self.searchStatus = true
                            self.tblFriendList.reloadData()
                            self.pageNumber += 1
                        }
                    }
                }else if reqType == 1{
                    if let arrList = response!["frndReq"] as? [[String:Any]]{
                        
                        // Remove all data here when page number == 1
                        if self.pageNumber == 1{
                            self.arrFriendList.removeAll()
                            self.tblFriendList.reloadData()
                        }
                        
                        // Add Data here...
                        if arrList.count > 0{
                            self.arrFriendList = self.arrFriendList + arrList
                            self.searchStatus = true
                            self.tblFriendList.reloadData()
                            self.pageNumber += 1
                        }
                    }
                }else {
                    if let arrList = response!["pendingReq"] as? [[String:Any]]{
                        
                        // Remove all data here when page number == 1
                        if self.pageNumber == 1{
                            self.arrFriendList.removeAll()
                            self.tblFriendList.reloadData()
                        }
                        
                        // Add Data here...
                        if arrList.count > 0{
                            self.arrFriendList = self.arrFriendList + arrList
                            self.searchStatus = true
                            self.tblFriendList.reloadData()
                            self.pageNumber += 1
                        }
                    }
                }
            }
            if self.arrFriendList.isEmpty{
                MILoader.shared.hideLoader()
                self.tblFriendList.setEmptyMessage(self.strEmptyMessage)
            }else{
                MILoader.shared.hideLoader()
                self.tblFriendList.restore()
            }
        })
        
    }
    
    //MARK:- FRIEND STATUS
    
    func getListFriends(_ search : String?, showLoader : Bool) {
        
        guard let user_Id = appDelegate.loginUser?.user_id else {return}
        
        apiTask = APIRequest.shared().getFriendList(page: self.pageNumber, request_type: 0, search: search, group_id : Int(user_Id), showLoader: showLoader, completion: { [weak self] (response, error) in
            guard let self = self else { return }
            self.refreshControl.endRefreshing()
            if response != nil{
                if let arrList = response!["my_friends"] as? [[String:Any]]{
                    self.arrList = arrList
                }
                
            }
        })
        
    }
    func getRequestList(_ search : String?, showLoader : Bool) {
        
        guard let user_Id = appDelegate.loginUser?.user_id else {return}
        apiTask = APIRequest.shared().getFriendList(page: self.pageNumber, request_type: 1, search: search, group_id : Int(user_Id), showLoader: showLoader, completion: { [weak self] (response, error) in
            guard let self = self else { return }
            self.refreshControl.endRefreshing()
            if response != nil{
                if let arrList = response!["frndReq"] as? [[String:Any]]{
                    self.arrRequestList = arrList
                }
                
            }
        })
        
    }
    
    func friendStatusApi(_ userInfo : [String : Any], _ userid : Int?,  _ status : Int?){
        let friend_ID = userInfo.valueForString(key: "friend_user_id")
        let user_ID = userInfo.valueForString(key: "user_id")
        let dict :[String:Any]  =  [
            "user_id":  user_ID,
            "friend_user_id": friend_ID,
            "request_type": status?.toString ?? "0"
        ]
        APIRequest.shared().friendRquestStatus(dict: dict, completion: { [weak self] (response, error) in
            guard let self = self else { return }
            if response != nil{
                
                if let metaData = response?.value(forKey: CJsonMeta) as? [String : AnyObject] {
//                    if  metaData.valueForString(key: "message") == "Request accepted successfully"{\\
                    let totalPoints = metaData.valueForString(key: "total_points")
                    if  totalPoints == "" && metaData.valueForString(key: "message") == "Request accepted successfully" {
                        let name = (appDelegate.loginUser?.first_name ?? "") + " " + (appDelegate.loginUser?.last_name ?? "")
                        guard let image = appDelegate.loginUser?.profile_img else { return }
                        guard let firstName = appDelegate.loginUser?.first_name else {return}
                        guard let lastName = appDelegate.loginUser?.last_name else {return}
                        guard let userID = appDelegate.loginUser?.user_id else {return}
                        MIGeneralsAPI.shared().sendNotification(friend_ID, userID: userID.description, subject: "accepted your friend request", MsgType: "FRIEND_ACCEPT", MsgSent:"", showDisplayContent: "accepted your friend request", senderName: firstName + lastName, post_ID: [:],shareLink: "sendFrdAcceptLink")
                        
                        MIGeneralsAPI.shared().addRewardsPoints(CFriendsrequestaccept,message:"Friends request accept",type:CFriendsrequestaccept,title:"",name:name,icon:image, detail_text: "friend_point",target_id: friend_ID.toInt ?? 0)
                    }else if totalPoints != "" && metaData.valueForString(key: "message") == "Request accepted successfully" {
                        guard let userID = appDelegate.loginUser?.user_id else {return}
                        guard let firstName = appDelegate.loginUser?.first_name else {return}
                        guard let lastName = appDelegate.loginUser?.last_name else {return}
                        MIGeneralsAPI.shared().sendNotification(friend_ID, userID: user_ID.description, subject: "accepted your friend request", MsgType: "FRIEND_ACCEPT", MsgSent:"", showDisplayContent: "accepted your friend request", senderName: firstName + lastName, post_ID: [:],shareLink: "sendFrdAcceptLink")
                        
                    }
                }
                
                if let index = self.arrFriendList.firstIndex(where: {$0["friend_user_id"] as? String == friend_ID}){
                    self.arrFriendList.remove(at: index)
                    self.isRefreshingUserData = true
                    UIView.performWithoutAnimation {
                        self.tblFriendList.reloadData()
                        self.isRefreshingUserData = false
                    }
                    DispatchQueue.main.async {
                        if let profoleVC = self.getViewControllerFromNavigation(MyProfileViewController.self){
                            profoleVC.pullToRefresh()
                        }
                    }
                }
                let metaInfo = response![CJsonMeta] as? [String:Any] ?? [:]
                let message = metaInfo["message"] as? String ?? "0"
                if message == "0"{
                    
//                    MIGeneralsAPI.shared().sendNotification( friend_ID, userID: friend_ID, subject: "accepted your friend request", MsgType: "FRIEND_ACCEPT", MsgSent: "", showDisplayContent: "accepted your friend request", senderName: firstName + lastName, post_ID: [:])
                }
                var isShowAlert = false
                var alertMessage = ""
                let first_name = userInfo.valueForString(key: "first_name")
                let last_name = userInfo.valueForString(key: "last_name")
                switch message {
                case CancelRequest:
                    isShowAlert = true
                    alertMessage = CMessageAfterCancel
                case RejectRequest:
                    isShowAlert = true
                    alertMessage = CMessageAfterReject
                case UnFriendRequest:
                    isShowAlert = true
                    alertMessage = first_name + " " + last_name + " " + CMessageAfterUnfriend
                case AcceptRequest:
                    isShowAlert = true
                    alertMessage = CMessageAfterAccept
                default:
                    break
                }
                if isShowAlert{
                    self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: alertMessage, btnOneTitle: CBtnOk, btnOneTapped: nil)
                }
            }
        })
    }
}

// MARK:- --------- UICollectionView Delegate/Datasources
extension MyFriendsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: clTabBar.frame.size.width/3, height: clTabBar.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyFriendListTabBarCollCell", for: indexPath) as! MyFriendListTabBarCollCell
        
        if indexPath == selectedIndexPath{
            cell.lblType.textColor = CRGB(r: 3, g: 191, b: 166)
            cell.viewBottomLine.isHidden = false
        }else{
            cell.lblType.textColor = CRGB(r: 115, g: 124, b: 124)
            cell.viewBottomLine.isHidden = true
        }
        
        switch indexPath.item {
        case 0:
            cell.lblType.text = CTabAllFriend
        case 1:
            cell.lblType.text = CTabRequestSend
        default:
            cell.lblType.text = CTabPendingRequest
        }
        
        // Load more data...
        if indexPath == tblFriendList.lastIndexPath() && !self.isRefreshingUserData {
            self.getFriendList(txtSearch.text, showLoader: false)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if selectedIndexPath == indexPath{
            return
        }
        
        if apiTask?.state == URLSessionTask.State.running {
            apiTask?.cancel()
        }
        
        selectedIndexPath = indexPath
        clTabBar.reloadData()
        arrFriendList.removeAll()
        tblFriendList.reloadData()
        pageNumber = 1
        self.getFriendList(txtSearch.text, showLoader: true)
    }
}

// MARK:- --------- UITableView Datasources/Delegate
extension MyFriendsViewController : UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch selectedIndexPath.item {
        case 0:
            strEmptyMessage = CNoFriendsFound
        case 1:
            strEmptyMessage = CNoRequestDataSent
        default:
            strEmptyMessage = CNoPendingRequestYet
        }
        if arrFriendList.isEmpty{
           // self.tblFriendList.setEmptyMessage(strEmptyMessage)
        }else{
            self.tblFriendList.restore()
        }
        return arrFriendListNew.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MyFriendTblCell", for: indexPath) as? MyFriendTblCell {
            let userInfo = arrFriendListNew[indexPath.row]
            cell.lblUserName.text = userInfo.valueForString(key: CFirstname) + " " + userInfo.valueForString(key: CLastname)
//            cell.imgUser.loadImageFromUrl(userInfo.valueForString(key: CImage), true)
            
            let imgExt = URL(fileURLWithPath:userInfo.valueForString(key: CImage)).pathExtension
            
            
            if imgExt == "gif"{
                        print("-----ImgExt\(imgExt)")
                        
                cell.imgUser.isHidden  = true
                cell.imgUserGIF.isHidden = false
                        cell.imgUserGIF.sd_setImage(with: URL(string:userInfo.valueForString(key: CImage)), completed: nil)
                cell.imgUserGIF.sd_cacheFLAnimatedImage = false
                        
                    }else {
                        cell.imgUserGIF.isHidden = true
                        cell.imgUser.isHidden  = false
                        cell.imgUser.loadImageFromUrl(userInfo.valueForString(key: CImage), true)
                        _ = appDelegate.loginUser?.total_friends ?? 0
                    }
            
//            cell.btnUnfriendCancelRequest.touchUpInside { [weak self] (sender) in
//                guard let _ = self else { return }
//
//                var frndStatus = 0
//                var alertMessage = ""
//                do{
//                    for data in self?.arrList ?? []{
//                        if userInfo.valueForString(key: "friend_user_id") == data?.valueForString(key: "friend_user_id"){
//                            self?.Friend_status = 5
//                        }
//                    }
//                    for data in self?.arrRequestList ?? []{
//                        if userInfo.valueForString(key: "friend_user_id") == data?.valueForString(key: "friend_user_id"){
//                            self?.Friend_status = 1
//                        }
//                    }
//
//                }
//                switch self?.Friend_status {
//                case 1:
//                    frndStatus = CFriendRequestCancel
//                    alertMessage = CMessageCancelRequest
//                case 5:
//                    frndStatus = CFriendRequestUnfriend
//                    alertMessage = CMessageUnfriend
//                default:
//                    break
//                }
//                self?.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: alertMessage, btnOneTitle: CBtnYes, btnOneTapped: { [weak self] (alert) in
//                    self?.friendStatusApi(userInfo, userInfo.valueForInt(key: CUserId), frndStatus)
//                }, btnTwoTitle: CBtnNo, btnTwoTapped: nil)
//            }
            cell.btnUnfriendCancelRequest.touchUpInside { [weak self] (sender) in
                guard let _ = self else { return }
                let buttonPostion = sender.convert(sender.bounds.origin, to: tableView)
                if let indexPath = tableView.indexPathForRow(at: buttonPostion) {
                    let rowIndex =  indexPath.row
                    let userinfos = self?.arrFriendList[rowIndex]
                    let first_name = userinfos?.valueForString(key: "first_name") ?? ""
                    let last_name = userinfos?.valueForString(key: "last_name") ?? ""
                    
                    
                    let userID = EncryptDecrypt.shared().encryptDecryptModel(userResultStr: userinfos?.valueForString(key: "friend_user_id") ?? "")
                     let friendID = EncryptDecrypt.shared().encryptDecryptModel(userResultStr: userinfos?.valueForString(key: "user_id") ?? "")
                    
                    
//                    let friendID = userinfos?.valueForString(key: "friend_user_id")
//                    let userID = userinfos?.valueForString(key: "user_id")
                    let dict :[String:Any]  =  [
                        "user_id": userID as Any,
                        "friend_user_id": friendID as Any
                    ]
                    APIRequest.shared().getFriendStatus(dict: dict, completion: { [weak self] (response, error) in
                        if response != nil && error == nil{
                            GCDMainThread.async {
                                if let arrList = response!["data"] as? [[String:Any]]{
                                    for arrLst in arrList{
                var frndStatus = 0
                var alertMessage = ""
                let user_id = appDelegate.loginUser?.user_id
                if arrLst.valueForString(key: "friend_status") == "1" {
                    self?.Friend_status = 5
                }else if arrLst.valueForString(key: "request_status") == "1" && arrLst.valueForString(key: "senders_id") == user_id?.description {
                    self?.Friend_status = 1
                }
                switch self?.Friend_status {
                case 1:
                    frndStatus = CFriendRequestCancel
                    alertMessage = CMessageCancelRequest
                case 5:
                    frndStatus = CFriendRequestUnfriend
                    alertMessage = CMessageUnfriend + " " + first_name + " " + last_name
                default:
                    break
                }
                self?.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: alertMessage, btnOneTitle: CBtnYes, btnOneTapped: { [weak self] (alert) in
                    self?.friendStatusApi(userInfo, userInfo.valueForInt(key: CUserId), frndStatus)
                }, btnTwoTitle: CBtnNo, btnTwoTapped: nil)
            }
                                }
                            }
                        }
                })
            }
            }
            
            cell.btnAcceptRequest.touchUpInside { [weak self] (sender) in
                guard let _ = self else { return }
               // self?.friendStatusApi(userInfo, userInfo.valueForInt(key: CUserId), 5)
                self?.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: CAlertMessageForAcceptRequest, btnOneTitle: CBtnYes, btnOneTapped: { [weak self] (alert) in
                    guard let self = self else { return }
                    self.friendStatusApi(userInfo, userInfo.valueForInt(key: CUserId), 5)
                }, btnTwoTitle: CBtnNo, btnTwoTapped: nil)
            }
            
            cell.btnRejectRequest.touchUpInside { [weak self] (sender) in
                guard let _ = self else { return }
                
                self?.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: CAlertMessageForRejectRequest, btnOneTitle: CBtnYes, btnOneTapped: { [weak self] (alert) in
                    self?.friendStatusApi(userInfo, userInfo.valueForInt(key: CUserId), 3)
                }, btnTwoTitle: CBtnNo, btnTwoTapped: nil)
                
            }
            switch selectedIndexPath.item {
            case 0:
                cell.viewAcceptReject.isHidden = true
                cell.btnUnfriendCancelRequest.isHidden = false
                cell.btnUnfriendCancelRequest.setTitle("  \(CBtnUnfriend)  ", for: .normal)
            case 1:
                cell.viewAcceptReject.isHidden = true
                cell.btnUnfriendCancelRequest.isHidden = false
                cell.btnUnfriendCancelRequest.setTitle("  \(CBtnCancelRequest)  ", for: .normal)
            default:
                cell.viewAcceptReject.isHidden = false
                cell.btnUnfriendCancelRequest.isHidden = true
            }
            
             //Load more data...
            if indexPath == tblFriendList.lastIndexPath() && !self.isRefreshingUserData {
//                if self.searchStatus == true {
//                self.getFriendList(txtSearch.text, showLoader: false)
//                }else {
//
//                }
                self.getFriendList(txtSearch.text, showLoader: false)
            }
            
            return cell
        }
        
        return tableView.tableViewDummyCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userInfo = arrFriendList[indexPath.row]
        appDelegate.moveOnProfileScreenNew(userInfo.valueForString(key: "friend_user_id"), userInfo.valueForString(key: CUsermailID), self)
    }
}

// MARK:- --------- Action Event
extension MyFriendsViewController {
    
    @IBAction func btnSearchCancelCLK(_ sender : UIButton){
        
        switch sender.tag {
        case 0:
            lblTitle.isHidden = true
            viewSearchBar.isHidden = false
            btnCancel.isHidden = false
            btnSearch.isHidden = true
            break
        case 1:
            txtSearch.resignFirstResponder()
            lblTitle.isHidden = false
            viewSearchBar.isHidden = true
            btnCancel.isHidden = true
            btnSearch.isHidden = false
            // Clear all search data...
            if !(txtSearch.text?.isBlank)! {
                txtSearch.text = nil
                self.pageNumber = 1
                self.getFriendList(txtSearch.text, showLoader: false)
            }
            break
        case 2:
            txtSearch.text = nil
            self.pageNumber = 1
            self.getFriendList(txtSearch.text, showLoader: false)
            break
        default:
            break
        }
    }
}

// MARK:- --------- UITextField Delegate
extension MyFriendsViewController : UITextFieldDelegate {
    
    @IBAction func textFieldDidChanged(_ textFiled : UITextField){
        if apiTask?.state == URLSessionTask.State.running {
            apiTask?.cancel()
        }
//        if (textFiled.text?.count)! < 2{
//            pageNumber = 1
//            arrFriendList.removeAll()
//            tblFriendList.reloadData()
//            self.getFriendList("", showLoader: false)
//            return
//        }
//        pageNumber = 1
//        self.getFriendList(txtSearch.text, showLoader: false)
        
        
        switch selectedIndexPath.item {
                case 0:
                    debugPrint("::::::::::this All Friends:::::::")
//                    pageNumber = 1
                    arrFriendListNew.removeAll()
                    arrFriendListNew =  (arrFriendList as? [[String: AnyObject]])?.filter({($0["first_name"] as? String)?.range(of: txtSearch.text ?? "", options: [.caseInsensitive]) != nil }) ?? []
//                    tblFriendList.reloadData()
                    if (textFiled.text?.isEmpty ?? true){
                        arrFriendListNew = arrFriendList
                    }
//                    pageNumber = 1
                    tblFriendList.reloadData()
                    
                case 1:
//                    pageNumber = 1
                    arrFriendListNew.removeAll()
                    arrFriendListNew =  (arrFriendList as? [[String: AnyObject]])?.filter({($0["first_name"] as? String)?.range(of: txtSearch.text ?? "", options: [.caseInsensitive]) != nil }) ?? []
//                    tblFriendList.reloadData()
                    if (textFiled.text?.isEmpty ?? true){
                        arrFriendListNew = arrFriendList
                    }
//                    pageNumber = 1
                    tblFriendList.reloadData()
                    debugPrint(":::::::::Request sent::::::::")
                default:
//                    pageNumber = 1
                    arrFriendListNew.removeAll()
                    arrFriendListNew =  (arrFriendList as? [[String: AnyObject]])?.filter({($0["first_name"] as? String)?.range(of: txtSearch.text ?? "", options: [.caseInsensitive]) != nil }) ?? []
//                    tblFriendList.reloadData()
                    if (textFiled.text?.isEmpty ?? true){
                        arrFriendListNew = arrFriendList
                    }
//                    pageNumber = 1
                    tblFriendList.reloadData()
                    debugPrint(":::::::::PendingReques::::::::")
                }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}

