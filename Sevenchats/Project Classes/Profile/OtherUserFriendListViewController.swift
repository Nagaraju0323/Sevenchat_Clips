//
//  OtherUserFriendListViewController.swift
//  Sevenchats
//
//  Created by mac-0005 on 30/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class OtherUserFriendListViewController: ParentViewController {

    @IBOutlet var viewSearchBar : UIView!
    @IBOutlet var btnSearch : UIButton!
    @IBOutlet var btnBack : UIButton!
    @IBOutlet var btnCancel : UIButton!
    @IBOutlet var txtSearch : UITextField!{
        didSet{
            txtSearch.returnKeyType = .search
        }
    }
    @IBOutlet var lblTitle : UILabel!
    @IBOutlet var cnNavigationHeight : NSLayoutConstraint!
    @IBOutlet var tblFriendList : UITableView!
    
    var userID : Int?
    var userIDNew : String?
//    var arrListFriend = [[String : Any]?]()
//    var arrRequestList = [[String : Any]?]()
//    var arrPendingList = [[String : Any]?]()
    var arrBlockList = [[String : Any]?]()
    var Friend_status = 0
    var arrFriendList = [[String:Any]]()
    var pageNumber = 1
    var refreshControl = UIRefreshControl()
    var apiTask : URLSessionTask?
    var isRefreshingUserData = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Initialization()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateUIAccordingToLanguage()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK:- --------- Initialization
    func Initialization() {
        cnNavigationHeight.constant = IS_iPhone_X_Series ? 84 : 64
        GCDMainThread.async {
            self.viewSearchBar.layer.cornerRadius = self.viewSearchBar.frame.size.height/2
            self.refreshControl.addTarget(self, action: #selector(self.pullToRefresh), for: .valueChanged)
            self.refreshControl.tintColor = ColorAppTheme
            self.tblFriendList.pullToRefreshControl = self.refreshControl
        }
        
        self.getFriendListFromServer("")
    }
    
    func updateUIAccordingToLanguage() {
        
        if Localization.sharedInstance.applicationFlowWithLanguageRTL() {
            // Reverse Flow...
            btnSearch.contentHorizontalAlignment = .left
            btnBack.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        }else {
            // Normal Flow...
            btnSearch.contentHorizontalAlignment = .right
            btnBack.transform = CGAffineTransform.identity
        }
        
        btnCancel.setTitle(CBtnCancel, for: .normal)
        lblTitle.text = CProfileFriends
    }
}
// MARK:- --------- Api Functions
extension OtherUserFriendListViewController {
    
    @objc func pullToRefresh() {
        self.pageNumber = 1
        refreshControl.beginRefreshing()
        self.getFriendListFromServer(txtSearch.text)
    }
    
    fileprivate func getFriendListFromServer(_ search : String?) {
        
       // if let userid = userID {
            if apiTask?.state == URLSessionTask.State.running {
                return
            }
            
            
            // Add load more indicator here...
            if self.pageNumber > 2 {
                self.tblFriendList.tableFooterView = self.loadMoreIndicator(ColorAppTheme)
            }else{
                self.tblFriendList.tableFooterView = nil
            }
            
           // apiTask = APIRequest.shared().getOtherUserFriendList(page: pageNumber, user_id: userid, search: search) { (response, error) in
            apiTask = APIRequest.shared().getOtherUserFriendListNew(user_id: userIDNew) { (response, error) in
                self.refreshControl.endRefreshing()
                self.tblFriendList.tableFooterView = nil

                if response != nil && error == nil {
                    let list = response!["friends_Of_friend"] as? [String:Any]
                    if let arrList = list![CJsonData] as? [[String:Any]] {
                        print("arraylist\(arrList)")
                        for data in arrList{
                            self.getFriendStatus(user_id: data.valueForString(key: "id"))
                        }
                      //  self.getFriendStatus(user_id: <#String#>)
                        // Remove all data here when page number == 1
                        if self.pageNumber == 1{
                            self.arrFriendList.removeAll()
                            self.tblFriendList.reloadData()
                        }
                        
                        // Add Data here...
                        if arrList.count > 0 {
                            self.arrFriendList = self.arrFriendList + arrList
                            self.tblFriendList.reloadData()
                            self.pageNumber += 1
                        }
                    }
                }
            }
        //}
    }
    //MARK:- GET BLOCK LIST
    func getFriendStatus(user_id : String?) {
        // if let userid = self.userID{
//        let friendID = userInfo.valueForString(key: "user_id")
       print(user_id)
        let dict :[String:Any]  =  [
            "user_id":  appDelegate.loginUser?.user_id ?? "",
            "friend_user_id": user_id ?? ""
            
        ]
            APIRequest.shared().getFriendStatus(dict: dict, completion: { [weak self] (response, error) in
                    self?.refreshControl.endRefreshing()
            if response != nil && error == nil{
                if let arrList = response!["data"] as? [[String:Any]]{
                    self?.arrBlockList = arrList
                }
            }
            
        })
    }
    // Update Friend status Friend/Unfriend/Cancel Request
   fileprivate func friendStatusApi(_ userInfo : [String : Any], _ userid : Int?,  _ status : Int?) {
    let friend_ID = userInfo.valueForInt(key: "friend_user_id")
           let dict :[String:Any]  =  [
            "user_id":  userid?.toString as Any,
               "friend_user_id": friend_ID!.toString,
               "request_type": status!.toString
               ]
    
        APIRequest.shared().friendRquestStatus(dict: dict, completion: { (response, error) in
            if response != nil{
                var frndInfo = userInfo
                if let data = response![CJsonData] as? [String : Any]{
                    frndInfo[CFriend_status] = data.valueForInt(key: CFriend_status)
                    
                    if let index = self.arrFriendList.index(where: {$0[CUserId] as? Int == userid}){
                        self.arrFriendList.remove(at: index)
                        self.arrFriendList.insert(frndInfo, at: index)
                        self.isRefreshingUserData = true
                        UIView.performWithoutAnimation {
                            self.tblFriendList.reloadRows(at: [IndexPath(item: index, section: 0)], with: .none)
                            self.isRefreshingUserData = false
                        }
                    }
                    
                    
                }
            }
        })
    }
    
}

// MARK:- --------- UITableView Datasources/Delegate
extension OtherUserFriendListViewController : UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrFriendList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MyFriendTblCell", for: indexPath) as? MyFriendTblCell {
            let userInfo = arrFriendList[indexPath.row]
          
            cell.lblUserName.text = userInfo.valueForString(key: CFirstname) + " " + userInfo.valueForString(key: CLastname)
            cell.imgUser.loadImageFromUrl(userInfo.valueForString(key: CImage), true)
            cell.btnUnfriendCancelRequest.isHidden = appDelegate.loginUser?.user_id == Int64(userInfo.valueForString(key: CUserId))
            
            cell.btnUnfriendCancelRequest.isHidden = true
            cell.viewAcceptReject.isHidden = true
            do{
//MARK:- FRIENDS
                        for data in arrBlockList{
                            if data?.valueForString(key: "request_status") == "5"{
                                self.Friend_status = 5
                            }
                        }
 //MARK:- REQUEST
                        for data in arrBlockList{
                            let user_id = appDelegate.loginUser?.user_id
                            if data?.valueForString(key: "request_status") == "1" && data?.valueForString(key: "senders_id") == user_id?.description {
                                    self.Friend_status = 1
                                }
                            }
//MARK:- PENDING
                            for data in arrBlockList{
                                let user_id = appDelegate.loginUser?.user_id
                                if data?.valueForString(key: "request_status") == "1" && data?.valueForString(key: "senders_id") != user_id?.description {
                                        self.Friend_status = 2
                                    }
                                }
                        }
           // switch userInfo.valueForInt(key: CFriend_status) {
            switch self.Friend_status {
            case 0: //... Add Friend
                cell.btnUnfriendCancelRequest.isHidden = appDelegate.loginUser?.user_id == Int64(userInfo.valueForString(key: CUserId))
                cell.btnUnfriendCancelRequest.setTitle("  \(CBtnAddFriend)  ", for: .normal)
            case 1:  //...Cancel Request
                cell.btnUnfriendCancelRequest.isHidden = false
                cell.btnUnfriendCancelRequest.setTitle("  \(CBtnCancelRequest)  ", for: .normal)
            case 2:  //...Accept-Reject
                cell.viewAcceptReject.isHidden = false
            case 5:  //...UnFriend
                cell.btnUnfriendCancelRequest.isHidden = false
                cell.btnUnfriendCancelRequest.setTitle("  \(CBtnUnfriend)  ", for: .normal)
            default:
                break
            }

            cell.btnAcceptRequest.touchUpInside { [weak self] (sender) in
                guard let self = self else { return }
                
                self.friendStatusApi(userInfo, userInfo.valueForInt(key: CUserId), 2)
                self.friendStatusApi(userInfo, userInfo.valueForInt(key: CUserId), 2)
            }
            
            cell.btnRejectRequest.touchUpInside { [weak self] (sender) in
                guard let self = self else { return }
                self.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: CAlertMessageForRejectRequest, btnOneTitle: CBtnYes, btnOneTapped: { (alert) in
                    self.friendStatusApi(userInfo, userInfo.valueForInt(key: CUserId), 3)
                }, btnTwoTitle: CBtnNo, btnTwoTapped: nil)
            }
            
            cell.btnUnfriendCancelRequest.touchUpInside { [weak self] (sender) in
                guard let self = self else { return }
                var frndStatus = 0
                var isShowAlert = false
                var alertMessage = ""
                do{
                                    for data in self.arrBlockList {
                                        if data?.valueForString(key: "request_status") == "5"{
                                        self.Friend_status = 5
                                    }
                                }
                                    for data in self.arrBlockList {
                                        let user_id = appDelegate.loginUser?.user_id
                                        if data?.valueForString(key: "request_status") == "1" && data?.valueForString(key: "senders_id") == user_id?.description {
                                            self.Friend_status = 1
                                        }
                                    }
                                    for data in self.arrBlockList{
                                        let user_id = appDelegate.loginUser?.user_id
                                        if data?.valueForString(key: "request_status") == "1" && data?.valueForString(key: "senders_id") != user_id?.description {
                                                self.Friend_status = 0
                                            }
                                        }
                                }
                switch self.Friend_status {
                case 0:
                    frndStatus = CFriendRequestSent
                case 1:
                    frndStatus = CFriendRequestCancel
                    isShowAlert = true
                    alertMessage = CMessageCancelRequest
                case 5:
                    frndStatus = CFriendRequestUnfriend
                    isShowAlert = true
                    alertMessage = CMessageUnfriend
                default:
                    break
                }
                if isShowAlert {
                    self.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: alertMessage, btnOneTitle: CBtnYes, btnOneTapped: { (alert) in
                        self.friendStatusApi(userInfo, userInfo.valueForInt(key: CUserId), frndStatus)
                    }, btnTwoTitle: CBtnNo, btnTwoTapped: nil)
                }else {
                    self.friendStatusApi(userInfo, userInfo.valueForInt(key: CUserId), frndStatus)
                }
            }
            
            // Load More data..
            if indexPath == tblFriendList.lastIndexPath() && !self.isRefreshingUserData{
//                self.getFriendListFromServer(txtSearch.text)
            }
            
            return cell
        }
        
        return tableView.tableViewDummyCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userInfo = arrFriendList[indexPath.row]
//        appDelegate.moveOnProfileScreen(userInfo.valueForString(key: CUserId), self)
        appDelegate.moveOnProfileScreenNew(userInfo.valueForString(key: "id"), userInfo.valueForString(key: CUsermailID), self)
    }
}

// MARK:- --------- UITextField Delegate
extension OtherUserFriendListViewController : UITextFieldDelegate {
    
    @IBAction func textFieldDidChanged(_ textFiled : UITextField){
        if apiTask?.state == URLSessionTask.State.running {
            apiTask?.cancel()
        }
        
        if (textFiled.text?.count)! < 2{
            pageNumber = 1
            arrFriendList.removeAll()
            tblFriendList.reloadData()
            return
        }
        
        pageNumber = 1
        self.getFriendListFromServer(txtSearch.text)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}

// MARK:- --------- Action Event
extension OtherUserFriendListViewController{
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
            break
            
        case 2:
            txtSearch.text = nil
            break
            
        default:
            break
            
        }
        
        // Remove search data on Cancel/Clear button click...
        if sender.tag != 0{
            txtSearch.text = nil
            pageNumber = 1
            arrFriendList.removeAll()
            tblFriendList.reloadData()
            self.getFriendListFromServer(txtSearch.text)
        }
        
    }
}
