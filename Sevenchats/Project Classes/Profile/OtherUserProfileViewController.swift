//
//  OtherUserProfileViewController.swift
//  Sevenchats
//
//  Created by mac-0005 on 30/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//


/*********************************************************
 * Author  : Chandrika.R                                 *
 * Model   : OtherUserProfileViewController              *
 * Changes :                                             *
 *                                                       *
 ********************************************************/



import UIKit
let CNoDataCell = "NO"
let CNoDataCellType = "cell_type"


class OtherUserProfileViewController: ParentViewController {
    
    @IBOutlet weak var cnHeaderHight : NSLayoutConstraint!
    @IBOutlet weak var cnTblUserTopSpace : NSLayoutConstraint!
    @IBOutlet weak var tblUser : UITableView!
    @IBOutlet weak var viewBlockContainer : UIView!
    @IBOutlet weak var lblBlockText : UILabel! {
        didSet {
            self.lblBlockText.text = CYouCannotSeeHisHerProfile
        }
    }
    @IBOutlet weak var imgUser : UIImageView! {
        didSet {
            GCDMainThread.async {
                self.imgUser.layer.cornerRadius = self.imgUser.frame.height / 2
                self.imgUser.layer.borderWidth = 3
                self.imgUser.layer.borderColor = #colorLiteral(red: 0, green: 0.7881455421, blue: 0.7100172639, alpha: 1)
            }
        }
    }
    @IBOutlet weak var imgUserCover : UIImageView! {
        didSet {
            GCDMainThread.async {
            }
        }
    }
    @IBOutlet weak var cnImgTopSpace : NSLayoutConstraint!{
        didSet {
            cnImgTopSpace.constant = IS_iPhone_X_Series ? 84 : 64
        }
    }
    
    @IBOutlet weak var lblUserName : UILabel!
    @IBOutlet weak var btnUnblock : UIButton! {
        didSet {
            self.btnUnblock.layer.cornerRadius = 5
            self.btnUnblock.layer.borderWidth = 1
            self.btnUnblock.layer.borderColor = CRGB(r: 119, g: 171, b: 110).cgColor
        }
    }
    
    var userID : Int?
    var userIDNew : String?
    var useremail : String?
    var arrUserDetail = [[String : Any]]()
    var arrBlockList = [[String : Any]?]()
    var refreshControl = UIRefreshControl()
    var arrPostList = [[String : Any]?]()
    var pageNumber = 1
    var apiTask : URLSessionTask?
    var isSelected:Bool?
    var emailID = ""
    var userid = ""
    var postype : String?
    var userBlock = [String : Any]()
    var isBlock : Bool?
    var Friend_status : Int?
    var isPullToRefresh = true
    var strUserImg = ""
    var usersotherID : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Initialization()
        NotificationCenter.default.addObserver(self, selector: #selector(loadOtherProfile), name: NSNotification.Name(rawValue: "loadOtherProfile"), object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
// MARK:- ---------- Initialization
    func Initialization(){
        
        self.title = ""
        if IS_iPhone_X_Series{
            // cnHeaderHight.constant = 210
        }
        
        GCDMainThread.async {
            self.refreshControl.addTarget(self, action: #selector(self.pullToRefresh), for: .valueChanged)
            self.refreshControl.tintColor = ColorAppTheme
            self.tblUser.pullToRefreshControl = self.refreshControl
            
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
        
        tblUser.register(UINib(nibName: "HomeSharedArticleCell", bundle: nil), forCellReuseIdentifier: "HomeSharedArticleCell")
        tblUser.register(UINib(nibName: "HomeSharedGalleryCell", bundle: nil), forCellReuseIdentifier: "HomeSharedGalleryCell")
        tblUser.register(UINib(nibName: "HomeSharedEventImageTblCell", bundle: nil), forCellReuseIdentifier: "HomeSharedEventImageTblCell")
        tblUser.register(UINib(nibName: "HomeSharedEventsCell", bundle: nil), forCellReuseIdentifier: "HomeSharedEventsCell")
        tblUser.register(UINib(nibName: "HomeSharedChirpyImageTblCell", bundle: nil), forCellReuseIdentifier: "HomeSharedChirpyImageTblCell")
        tblUser.register(UINib(nibName: "HomeSharedChirpyTblCell", bundle: nil), forCellReuseIdentifier: "HomeSharedChirpyTblCell")
        tblUser.register(UINib(nibName: "HomeSharedShoutsTblCell", bundle: nil), forCellReuseIdentifier: "HomeSharedShoutsTblCell")
        tblUser.register(UINib(nibName: "HomeSharedFourmTblCell", bundle: nil), forCellReuseIdentifier: "HomeSharedFourmTblCell")
        tblUser.register(UINib(nibName: "HomeSharedPollTblCell", bundle: nil), forCellReuseIdentifier: "HomeSharedPollTblCell")
        tblUser.register(UINib(nibName: "NoPostFoundCell", bundle: nil), forCellReuseIdentifier: "NoPostFoundCell")
        tblUser.register(UINib(nibName: "PostDeletedCell", bundle: nil), forCellReuseIdentifier: "PostDeletedCell")
        tblUser.register(UINib(nibName: "AudioVideoButtonCell", bundle: nil), forCellReuseIdentifier: "AudioVideoButtonCell")
        
        btnUnblock.setTitle("  \(CBtnUnblockUser)  ", for: .normal)
        // To Get User detail from server.......
        self.getFriendStatus()
        self.otherUserDetails(isLoader:true)
//        self.getPostListFromServer()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        DispatchQueue.main.async {
            self.otherUserDetails(isLoader:true)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(loadOtherProfile), name: NSNotification.Name(rawValue: "loadOtherIntrest"), object: nil)
    }
    
    @objc func loadOtherProfile(){
        //load data here
        self.tblUser.reloadData()
    }
}
// MARK:- --------- Api Functions
extension OtherUserProfileViewController{
    fileprivate func loadMore(_ indexPath : IndexPath) {
        // Load more data...
        if indexPath == tblUser.lastIndexPath() && !self.isPullToRefresh{
            self.getPostListFromServer()
        }
    }
    
    @objc func pullToRefresh() {
        isPullToRefresh = true
        pageNumber = 0
        refreshControl.beginRefreshing()
        self.getPostListFromServer()
        self.otherUserDetails(isLoader:false)
    }
    
    func otherUserDetails(isLoader:Bool) {
        if let email = useremail {
            if email.isValidEmail{
                userid = email
                postype = "users/"
            }else{
                self.userid = userIDNew ?? ""
                postype = "users/id/"
            }
        }else{
            self.userid = userIDNew ?? ""
            postype = "users/id/"
        }
        if isLoader{
            MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: "\(CMessagePleaseWait)...")
        }
        
        APIRequest.shared().userDetailNew(userID: userid,apiKeyCall: postype ?? "") { [weak self] (response, error) in
            guard let self = self else { return }
            self.refreshControl.endRefreshing()
            MILoader.shared.hideLoader()
            self.isPullToRefresh = false
            if response != nil{
                if let Info = response!["data"] as? [[String:Any]]{
                    
                    for data in Info {
                        let usrID  = (data.valueForString(key: "user_id"))
                        print("userID\(usrID)")
                        self.usersotherID = usrID
                        
                        for block in self.arrBlockList {
                            if block?.valueForString(key: "block_status") == "1"{
                                print("IS BLOCK")
                                self.isBlock = true
                            }else{
                                print("IS NOT BLOCK")
                                self.isBlock = false
                            }
                        }
                        if self.isBlock == true {
                            self.tblUser.isHidden = true
                            self.viewBlockContainer.isHidden = false
                            self.imgUser.loadImageFromUrl(data.valueForString(key: CImage), true)
                            self.imgUserCover.loadImageFromUrl(data.valueForString(key: "cover_image"), true)
                            self.strUserImg = data.valueForString(key: CImage)
                            self.lblUserName.text = data.valueForString(key: CFirstname) + " " + data.valueForString(key: CLastname)
                            self.lblBlockText.text = CYouCannotSeeHisHerProfile
                            for friend in self.arrBlockList{
                                let user_id =  appDelegate.loginUser?.user_id
                                if friend?.valueForString(key: "blocked_id") == user_id?.description {
                                    self.btnUnblock.hide(byHeight: false)
                                }else {
                                    self.btnUnblock.hide(byHeight: true)
                                }
                                
                            }
                            
                        } else {
                            self.imgUser.loadImageFromUrl(data.valueForString(key: CImage), true)
                            self.imgUserCover.loadImageFromUrl(data.valueForString(key: "cover_image"), true)
                            self.strUserImg = data.valueForString(key: CImage)
                            self.lblUserName.text = data.valueForString(key: CFirstname) + " " + data.valueForString(key: CLastname)
                            self.tblUser.isHidden = false
                            self.viewBlockContainer.isHidden = true
                            
                            self.arrUserDetail.removeAll()
                            self.arrUserDetail.append(data)
                            self.arrPostList.removeAll()
                            
                            UIView.performWithoutAnimation {
                                self.tblUser.reloadData()
                            }
                            // If user not friend and his profile prefrenece is basic..
                            for friend in self.arrBlockList{
                                if friend?.valueForString(key: "friend_status") == "1"{
                                    self.Friend_status = 5
                                }
                                
                            }
                            let CVisible_to_other = data.valueForInt(key: "visible_to_other")
                            if self.Friend_status != 5 && CVisible_to_other == 1 {
                                // Show bottom private View
                                self.arrPostList.append([CNoDataCellType:CNoDataCell])
                                UIView.performWithoutAnimation {
                                    self.tblUser.reloadData()
                                }
                            }else {
                                // Call post list api here........
                                self.getPostListFromServer()
                            }
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        if let meta = response?[CJsonMeta] as? [String : Any] {
                            // self.lblDeleteUser.isHidden = false
                            //   self.lblDeleteUser.text = meta.valueForString(key: "message")
                        }
                    }
                }
            }
        }
    }
    
    
    func friendStatusApi(_ userInfo : [String : Any], _ status : Int?) {
        
        let friend_ID = userInfo.valueForString(key: "user_id")
        let dict :[String:Any]  =  [
            "user_id":  appDelegate.loginUser?.user_id ?? "",
            "friend_user_id": friend_ID,
            "request_type": status?.toString as Any
        ]
        
        APIRequest.shared().friendRquestStatus(dict: dict, completion: { [weak self] (response, error) in
            guard let self = self else { return }
            if response != nil{
                var frndInfo = userInfo
                if let data = response![CJsonData] as? [String : Any]{
                    frndInfo[CFriend_status] = data.valueForInt(key: CFriend_status)
                    self.arrUserDetail.removeAll()
                    self.arrUserDetail.append(frndInfo)
                    MIGeneralsAPI.shared().refreshPostRelatedScreens(frndInfo, frndInfo.valueForInt(key: CUserId), self, .friendRequest, rss_id: 0)
                    UIView.performWithoutAnimation {
                        self.tblUser.reloadSections(IndexSet(integer: 0), with: .none)
                    }
                    
                    // If user accept/Unfriend the request..
                    if status == 2 || status == CFriendRequestUnfriend {
                        self.pullToRefresh()
                    }
                    DispatchQueue.main.async {
                        if let profoleVC = self.getViewControllerFromNavigation(MyFriendsViewController.self){
                            profoleVC.pullToRefresh()
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            }
        })
    }
    
    func blockUnblockUserApi(_ status : Int) {
        
        APIRequest.shared().blockUnblockUserNew(userID:userIDNew?.description, block_unblock_status: status.description, completion: { (response, error) in
            
            if response != nil{
                if let metaData = response?.value(forKey: CJsonMeta) as? [String : AnyObject] {
                    if metaData.valueForString(key: "message") == "User Blocked successfully" {
                        guard let user_ID =  appDelegate.loginUser?.user_id.description else { return}
                        guard let firstName = appDelegate.loginUser?.first_name else {return}
                        guard let lastName = appDelegate.loginUser?.last_name else {return}
                        MIGeneralsAPI.shared().sendNotification(self.userIDNew?.description, userID: user_ID.description, subject: "Blocked you", MsgType: "FRIEND_BLOCKED", MsgSent:"", showDisplayContent: "Blocked you", senderName: firstName + lastName)
                        
                    }
                }
                if status == 1 && status == 0 {
                    // Blocked user
                    self.tblUser.isHidden = true
                    self.viewBlockContainer.isHidden = false
                    self.arrPostList.removeAll()
                    self.arrUserDetail.removeAll()
                    self.tblUser.reloadData()
                }else {
                    // Unblock user
                    self.tblUser.isHidden = false
                    self.viewBlockContainer.isHidden = true
//                    self.pullToRefresh()
                    
                    self.navigationController?.popViewController(animated: true)
                }
            }
        })
    }
    
    //MARK:- GET BLOCK LIST
    func getFriendStatus() {
        
        let dict :[String:Any]  =  [
            "user_id":  appDelegate.loginUser?.user_id ?? "",
            "friend_user_id": userIDNew ?? ""
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
    
    func getPostListFromServer() {
        
        if let userID = self.usersotherID {
            if apiTask?.state == URLSessionTask.State.running { return}
            // Add load more indicator here...
            if self.pageNumber > 2 {
                self.tblUser.tableFooterView = self.loadMoreIndicator(ColorAppTheme)
            }else{
                self.tblUser.tableFooterView = nil
            }
            apiTask = APIRequest.shared().getUserFriendPostList(page: self.pageNumber, user_id: userID.toInt, search_type: nil) { [weak self] (response, error) in
                guard let self = self else { return }
                self.tblUser.tableFooterView = nil
                self.refreshControl.endRefreshing()
                
                if response != nil && error == nil {
                    let data = response!["post_listing"] as! [String:Any]
                    if let arrList = data["post"] as? [[String : Any]] {
                        print(arrList)
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
                }
            }
        }
    }
    
    func deletePost(_ postId : Int, _ index : Int) {
        
    }
}


// MARK:- --------- UITableView Datasources/Delegate
extension OtherUserProfileViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrUserDetail.isEmpty{
            return 0
        }
        if section == 0{
            var cellCount = 1
            let userInfo = arrUserDetail[0]
            if userInfo.valueForInt(key: CFriend_status) == 5 && IsAudioVideoEnable {
                cellCount += 1
            }
            return cellCount
        }
        if arrPostList.isEmpty{
            return 1
        }
        return arrPostList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            if indexPath.row == 0 {
                let userInfo = arrUserDetail[0]
                if let cell = tableView.dequeueReusableCell(withIdentifier: "OtherUserProfileHeaderTblCell", for: indexPath) as? OtherUserProfileHeaderTblCell {
                    cell.frdList = self.arrBlockList
                    cell.cellConfigureForUserDetail(userInfo)
                    cell.btnTotalFriend.touchUpInside { [weak self](sender) in
                        if let friendListVC = CStoryboardProfile.instantiateViewController(withIdentifier: "OtherUserFriendListViewController") as? OtherUserFriendListViewController {
                            friendListVC.userID = self?.userID
                            friendListVC.userIDNew = self?.userIDNew
                            self?.navigationController?.pushViewController(friendListVC, animated: true)
                        }
                    }
                    cell.btnViewCompleteProfile.touchUpInside {[weak self] (sender) in
                        if let completeVC = CStoryboardProfile.instantiateViewController(withIdentifier: "OtherUserCompleteProfileViewController") as? OtherUserCompleteProfileViewController {
                            completeVC.isLoginUser = false
                            completeVC.userID = userInfo.valueForInt(key: CUserId)
                            self?.navigationController?.pushViewController(completeVC, animated: true)
                        }
                    }
                    cell.btnMessage.isHidden = true
                    for friend in self.arrBlockList{
                        let user_id = appDelegate.loginUser?.user_id
                        if friend?.valueForString(key: "request_status") == "1" && friend?.valueForString(key: "senders_id") != user_id?.description {
                            self.Friend_status = 2
                        }
                    }
                    if self.Friend_status == 2{
                        cell.btnAddFriend.isHidden = true
                        cell.viewAcceptReject.isHidden = false
                    }else{
                        cell.btnAddFriend.isHidden = false
                        cell.viewAcceptReject.isHidden = true
                        
                        //MARK:-FRIEND
                        for friend in arrBlockList{
                            let user_id = appDelegate.loginUser?.user_id
                            if friend?.valueForString(key: "friend_status") == "1"{
                                self.Friend_status = 5
                            }else if friend?.valueForString(key: "request_status") == "1" && friend?.valueForString(key: "senders_id") == user_id?.description {
                                self.Friend_status = 1
                            }else if friend?.valueForString(key: "request_status") == "1" && friend?.valueForString(key: "senders_id") != user_id?.description {
                                self.Friend_status = 0
                            }
                        }
                       
                        switch self.Friend_status {
                        case 0:
                            cell.btnAddFriend.setTitle(CBtnAddFriend, for: .normal)
                        case 1:
                            cell.btnAddFriend.setTitle(CBtnCancelRequest, for: .normal)
                        case 5:
                            cell.btnAddFriend.setTitle(CBtnUnfriend, for: .normal)
                            cell.btnMessage.isHidden = false
                        default:
                            break
                        }
                    }
                    
                    cell.btnAddFriend.touchUpInside { [weak self](sender) in
                        var frndStatus = 0
                        var isShowAlert = false
                        var alertMessage = ""
                        //MARK:-FRIEND
                        for data in self?.arrBlockList ?? []{
                            let user_id = appDelegate.loginUser?.user_id
                            if data?.valueForString(key: "friend_status") == "1"{
                                self?.Friend_status = 5
                            }else if data?.valueForString(key: "request_status") == "1" && data?.valueForString(key: "senders_id") == user_id?.description {
                                self?.Friend_status = 1
                            }else if data?.valueForString(key: "request_status") == "1" && data?.valueForString(key: "senders_id") != user_id?.description {
                                self?.Friend_status = 0
                            }
                        }
                        switch self?.Friend_status {
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
                        
                        if isShowAlert{
                            self?.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: alertMessage, btnOneTitle: CBtnYes, btnOneTapped: { (alert) in
                                self?.friendStatusApi(userInfo, frndStatus)
                                NotificationCenter.default.post(name: Notification.Name("NotificationRecived"), object: nil,userInfo: nil)
                                self?.navigationController?.popViewController(animated: true)
                            }, btnTwoTitle: CBtnNo, btnTwoTapped: nil)
                        }else{
                            self?.friendStatusApi(userInfo, 1)
                        }
                    }
                    
                    cell.btnRequestAccept.touchUpInside { [weak self](sender) in
                        self?.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: CAlertMessageForAcceptRequest, btnOneTitle: CBtnYes, btnOneTapped: { [weak self] (alert) in
                            guard let self = self else { return }
                            self.friendStatusApi(userInfo, 5)
                            self.navigationController?.popViewController(animated: true)
                        }, btnTwoTitle: CBtnNo, btnTwoTapped: nil)
                    }
                    
                    cell.btnRequestReject.touchUpInside {[weak self] (sender) in
                        
                        self?.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: CAlertMessageForRejectRequest, btnOneTitle: CBtnYes, btnOneTapped: { (alert) in
                            self?.friendStatusApi(userInfo, 3)
                        }, btnTwoTitle: CBtnNo, btnTwoTapped: nil)
                    }
                    
                    
                    cell.btnMore.touchUpInside {[weak self] (sender) in
                        if self?.userBlock.valueForString(key: "friend_user_id") ==                        userInfo.valueForString(key: "user_id"){
                            print("IS BLOCK")
                            self?.isBlock = true
                            
                        }else{
                            print("IS NOT BLOCK")
                            self?.isBlock = false
                        }
                        var blockUnBlock = ""
                        if self?.isBlock == true{
                            blockUnBlock = CBtnUnblockUser
                        }else{
                            blockUnBlock = CBtnBlockUser
                        }
                        
                        self?.presentActionsheetWithTwoButtons(actionSheetTitle: nil, actionSheetMessage: nil, btnOneTitle: blockUnBlock, btnOneStyle: .default, btnOneTapped: { [weak self](alert) in
                            // Block or Unblock
                            if self?.userBlock.valueForString(key: "friend_user_id") ==                        userInfo.valueForString(key: "user_id"){
                                print("IS BLOCK")
                                self?.isBlock = true
                            }else{
                                print("IS NOT BLOCK")
                                self?.isBlock = false
                            }
                            if self?.isBlock == true {
                                self?.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: CMessageBlockUser, btnOneTitle: CBtnYes, btnOneTapped: { [weak self](alert) in
                                    self?.blockUnblockUserApi(self?.isBlock == true ? 7 : 6)
                                }, btnTwoTitle: CBtnNo, btnTwoTapped: nil)
                                
                            }else {
                                self?.blockUnblockUserApi(self?.isBlock == true ? 7 : 6)
                            }
                            
                        }, btnTwoTitle: CBtnReportUser, btnTwoStyle: .default, btnTwoTapped: {[weak self] (_) in
                            
                            // Report User
                            if let reportVC = CStoryboardGeneral.instantiateViewController(withIdentifier: "ReportViewController") as? ReportViewController {
                                reportVC.setBlock(block: { (response, error) in
                                    self?.tblUser.isHidden = true
                                    self?.viewBlockContainer.isHidden = false
                                })
                                reportVC.reportType = .reportUser
                                reportVC.reportID = userInfo.valueForInt(key: CUserId)
                                reportVC.userID = userInfo.valueForInt(key: CUserId)
                                reportVC.reportIDNEW = userInfo.valueForString(key: "email")
                                self?.navigationController?.pushViewController(reportVC, animated: true)
                            }; if let reportVC = CStoryboardGeneral.instantiateViewController(withIdentifier: "ReportViewController") as? ReportViewController {
                                reportVC.setBlock(block: { (response, error) in
                                    self?.tblUser.isHidden = true
                                    self?.viewBlockContainer.isHidden = false
                                })
                                reportVC.reportType = .reportUser
                                reportVC.reportID = userInfo.valueForInt(key: CUserId)
                                reportVC.userID = userInfo.valueForInt(key: CUserId)
                                reportVC.reportIDNEW = userInfo.valueForString(key: "user_id")
                                self?.navigationController?.pushViewController(reportVC, animated: true)
                            }
                        })
                    }
                    cell.btnMessage.touchUpInside { [weak self](button) in
                        guard let _ = self else {return}
                        if let userDetailVC = CStoryboardChat.instantiateViewController(withIdentifier: "UserChatDetailViewController") as? UserChatDetailViewController {
                            userDetailVC.isCreateNewChat = false
                            userDetailVC.iObject = userInfo
                            userDetailVC.userID = userInfo.valueForInt(key: CUserId)
                            userDetailVC.userIDuser = userInfo.valueForString(key: "user_id")
                            userDetailVC.isCreateNewChat = true
                            if let nav = self?.viewController as? UINavigationController{
                                nav.pushViewController(userDetailVC, animated: true)
                            }else{
                                self?.viewController?.navigationController?.pushViewController(userDetailVC, animated: true)
                            }
                        }
                    }
                    return cell
                }
            } else {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "AudioVideoButtonCell", for: indexPath) as? AudioVideoButtonCell {
                    _ = arrUserDetail[0]
                    cell.btnAudioCall.touchUpInside {[weak self] (sender) in
                    }
                    cell.btnVideoCall.touchUpInside {[weak self] (sender) in
                    }
                    return cell
                }
            }
        }
        
        if arrPostList.isEmpty{
            if let cell = tableView.dequeueReusableCell(withIdentifier: "NoPostFoundCell", for: indexPath) as? NoPostFoundCell {
                return cell
            }
            return tableView.tableViewDummyCell()
        }
        let postInfo = arrPostList[indexPath.row]
        let isshared = 0
        let isdelete = 0
        if isshared == 1 && isdelete == 1{
            if let cell = tableView.dequeueReusableCell(withIdentifier: "PostDeletedCell", for: indexPath) as? PostDeletedCell {
                cell.postDataSetup(postInfo!)
                
                cell.btnLikesCount.touchUpInside { [weak self] (sender) in
                    guard let _ = self else { return }
                    self?.btnLikesCountCLK(postInfo?.valueForInt(key: CId))
                }
                
                cell.btnMore.touchUpInside { [weak self] (sender) in
                    guard let _ = self else { return }
                    let sharePost = SharePostHelper(controller: self, dataSet: postInfo)
                    sharePost.shareURL = postInfo?.valueForString(key: CShare_url) ?? ""
                    sharePost.presentShareActivity()
                }
                
                // .... LOAD MORE DATA HERE
                self.loadMore(indexPath)
                
                return cell
            }
        }
        if  postInfo?.valueForString(key: CNoDataCellType) != nil && !(postInfo?.valueForString(key: CNoDataCellType).isBlank)!{
            if let cell = tableView.dequeueReusableCell(withIdentifier: "PrivateAccountTblCell", for: indexPath) as? PrivateAccountTblCell {
                cell.lblText.text = CMessageAccountPrivacyMsg
                return cell
            }
        }else {
            switch postInfo?.valueForString(key: CPostTypeNew) {
            case CStaticArticleIdNew:
                //            1-article
                let isshared = 0
                if isshared == 1{
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeSharedArticleCell", for: indexPath) as? HomeSharedArticleCell {
                        cell.homeArticleDataSetup(postInfo!)
                        
                        cell.btnLikesCount.touchUpInside {[weak self] (sender) in
                            self?.btnLikesCountCLK(postInfo?.valueForInt(key: CId))
                        }
                        
                        cell.btnMore.touchUpInside {[weak self] (sender) in
                            self?.btnSharedReportCLK(postInfo: postInfo)
                        }
                        
                        cell.btnShare.touchUpInside {[weak self] (sender) in
                            let sharePost = SharePostHelper(controller: self, dataSet: postInfo)
                            sharePost.shareURL = postInfo?.valueForString(key: CShare_url) ?? ""
                            sharePost.presentShareActivity()
                        }
                        
                        // .... LOAD MORE DATA HERE
                        self.loadMore(indexPath)
                        return cell
                    }
                }
                
                if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeArticleCell", for: indexPath) as? HomeArticleCell {
                    
                    cell.isLikesOthersPage = true
                    cell.homeArticleDataSetup(postInfo!)
                    
                    cell.btnLikesCount.touchUpInside {[weak self] (sender) in
//                        self?.btnLikesCountCLK(postInfo?.valueForInt(key: CId))
                        self?.btnLikesCountCLK(postInfo?.valueForString(key: CPostId).toInt)
                    }
                    
                    cell.btnMore.touchUpInside {[weak self] (sender) in
                        self?.btnReportCLK(postInfo)
                    }
                    
                    cell.btnShare.touchUpInside {[weak self] (sender) in
                        let sharePost = SharePostHelper(controller: self, dataSet: postInfo)
                        sharePost.shareURL = postInfo?.valueForString(key: CShare_url) ?? ""
                        sharePost.presentShareActivity()
                    }
                    
                    // .... LOAD MORE DATA HERE
                    self.loadMore(indexPath)
                    
                    return cell
                }
                break
            case CStaticGalleryIdNew:
                //            2-gallery
                let isshared = 0
                if isshared == 1{
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeSharedGalleryCell", for: indexPath) as? HomeSharedGalleryCell {
                        cell.homeGalleryDataSetup(postInfo!)
                        
                        cell.btnLikesCount.touchUpInside {[weak self] (sender) in
                            self?.btnLikesCountCLK(postInfo?.valueForInt(key: CId))
                        }
                        
                        cell.btnMore.touchUpInside { [weak self](sender) in
                            self?.btnSharedReportCLK(postInfo: postInfo)
                        }
                        
                        cell.btnShare.touchUpInside { [weak self](sender) in
                            let sharePost = SharePostHelper(controller: self, dataSet: postInfo)
                            sharePost.shareURL = postInfo?.valueForString(key: CShare_url) ?? ""
                            sharePost.presentShareActivity()
                        }
                        
                        // .... LOAD MORE DATA HERE
                        self.loadMore(indexPath)
                        
                        return cell
                    }
                }
                if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeGalleryCell", for: indexPath) as? HomeGalleryCell {
                    
                    cell.isLikesOthersPage = true
                    
                    cell.homeGalleryDataSetup(postInfo!)
                    
                    cell.btnLikesCount.touchUpInside {[weak self] (sender) in
                        self?.btnLikesCountCLK(postInfo?.valueForString(key: CPostId).toInt)
                    }
                    
                    cell.btnMore.touchUpInside { [weak self](sender) in
                        self?.btnReportCLK(postInfo)
                    }
                    
                    cell.btnShare.touchUpInside { [weak self](sender) in
                        let sharePost = SharePostHelper(controller: self, dataSet: postInfo)
                        sharePost.shareURL = postInfo?.valueForString(key: CShare_url) ?? ""
                        sharePost.presentShareActivity()
                    }
                    
                    // .... LOAD MORE DATA HERE
                    self.loadMore(indexPath)
                    
                    return cell
                }
                break
            case CStaticChirpyIdNew:
                //            3-chripy
                
                if (postInfo?.valueForString(key: CImage).isBlank)!{
                    let isshared = 0
                    if isshared == 1{
                        if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeSharedChirpyTblCell", for: indexPath) as? HomeSharedChirpyTblCell {
                            cell.homeChirpyDataSetup(postInfo!)
                            
                            cell.btnLikesCount.touchUpInside { [weak self](sender) in
                                self?.btnLikesCountCLK(postInfo?.valueForInt(key: CId))
                            }
                            
                            cell.btnMore.touchUpInside { [weak self](sender) in
                                self?.btnSharedReportCLK(postInfo: postInfo)
                            }
                            
                            cell.btnShare.touchUpInside { [weak self](sender) in
                                let sharePost = SharePostHelper(controller: self, dataSet: postInfo)
                                sharePost.shareURL = postInfo?.valueForString(key: CShare_url) ?? ""
                                sharePost.presentShareActivity()
                            }
                            
                            // .... LOAD MORE DATA HERE
                            self.loadMore(indexPath)
                            
                            return cell
                        }
                    }
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeChirpyImageTblCell", for: indexPath) as? HomeChirpyImageTblCell {
                        cell.isLikesOthersPage = true
                        
                        cell.homeChirpyImageDataSetup(postInfo!)
                        
                        cell.btnLikesCount.touchUpInside { [weak self](sender) in
                            self?.btnLikesCountCLK(postInfo?.valueForString(key: CPostId).toInt)
                        }
                        
                        cell.btnMore.touchUpInside { [weak self](sender) in
                            self?.btnReportCLK(postInfo)
                        }
                        
                        cell.btnShare.touchUpInside { [weak self](sender) in
                            let sharePost = SharePostHelper(controller: self, dataSet: postInfo)
                            sharePost.shareURL = postInfo?.valueForString(key: CShare_url) ?? ""
                            sharePost.presentShareActivity()
                        }
                        
                        // .... LOAD MORE DATA HERE
                        self.loadMore(indexPath)
                        
                        return cell
                    }
                }else{
                    let isshared = 0
                    if isshared == 1{
                        if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeSharedChirpyImageTblCell", for: indexPath) as? HomeSharedChirpyImageTblCell {
                            cell.homeChirpyImageDataSetup(postInfo!)
                            
                            cell.btnLikesCount.touchUpInside { [weak self](sender) in
                                self?.btnLikesCountCLK(postInfo?.valueForInt(key: CId))
                            }
                            
                            cell.btnMore.touchUpInside { [weak self](sender) in
                                self?.btnSharedReportCLK(postInfo: postInfo)
                            }
                            
                            cell.btnShare.touchUpInside { [weak self](sender) in
                                let sharePost = SharePostHelper(controller: self, dataSet: postInfo)
                                sharePost.shareURL = postInfo?.valueForString(key: CShare_url) ?? ""
                                sharePost.presentShareActivity()
                            }
                            
                            // .... LOAD MORE DATA HERE
                            self.loadMore(indexPath)
                            
                            return cell
                        }
                    }
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeChirpyImageTblCell", for: indexPath) as? HomeChirpyImageTblCell {
                        
                        cell.isLikesOthersPage = true
                        
                        cell.homeChirpyImageDataSetup(postInfo!)
                        
                        cell.btnLikesCount.touchUpInside { [weak self](sender) in
                            self?.btnLikesCountCLK(postInfo?.valueForString(key: CPostId).toInt)
                        }
                        
                        cell.btnMore.touchUpInside { [weak self](sender) in
                            self?.btnReportCLK(postInfo)
                        }
                        
                        cell.btnShare.touchUpInside { [weak self](sender) in
                            let sharePost = SharePostHelper(controller: self, dataSet: postInfo)
                            sharePost.shareURL = postInfo?.valueForString(key: CShare_url) ?? ""
                            sharePost.presentShareActivity()
                        }
                        
                        // .... LOAD MORE DATA HERE
                        self.loadMore(indexPath)
                        
                        return cell
                    }
                }
                break
            case CStaticShoutIdNew:
                //            4-shout
                let isSharedPost = postInfo?.valueForInt(key: CIsSharedPost)
                if isSharedPost == 1{
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeSharedShoutsTblCell", for: indexPath) as? HomeSharedShoutsTblCell {
                        cell.homeShoutsDataSetup(postInfo!)
                        
                        cell.btnLikesCount.touchUpInside {[weak self] (sender) in
                            self?.btnLikesCountCLK(postInfo?.valueForInt(key: CId))
                        }
                        
                        cell.btnMore.touchUpInside {[weak self] (sender) in
                            self?.btnSharedReportCLK(postInfo: postInfo)
                        }
                        
                        cell.btnShare.touchUpInside { [weak self](sender) in
                            let sharePost = SharePostHelper(controller: self, dataSet: postInfo)
                            sharePost.shareURL = postInfo?.valueForString(key: CShare_url) ?? ""
                            sharePost.presentShareActivity()
                        }
                        
                        // .... LOAD MORE DATA HERE
                        self.loadMore(indexPath)
                        
                        return cell
                    }
                }
                if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeShoutsTblCell", for: indexPath) as? HomeShoutsTblCell {
                    
                    cell.isLikesOthersPage = true
                    cell.posted_IDOthers = userIDNew ?? ""
                    cell.homeShoutsDataSetup(postInfo!)
                    
                    cell.btnLikesCount.touchUpInside {[weak self] (sender) in
                        self?.btnLikesCountCLK(postInfo?.valueForString(key: CPostId).toInt)
                    }
                    
                    cell.btnMore.touchUpInside {[weak self] (sender) in
                        self?.btnReportCLK(postInfo)
                    }
                    
                    cell.btnShare.touchUpInside { [weak self](sender) in
                        let sharePost = SharePostHelper(controller: self, dataSet: postInfo)
                        sharePost.shareURL = postInfo?.valueForString(key: CShare_url) ?? ""
                        sharePost.presentShareActivity()
                    }
                    
                    // .... LOAD MORE DATA HERE
                    self.loadMore(indexPath)
                    
                    return cell
                }
                break
            case CStaticForumIdNew:
                //            5-forum
                let isshared = 0
                if isshared == 1{
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeSharedFourmTblCell", for: indexPath) as? HomeSharedFourmTblCell {
                        cell.homeFourmDataSetup(postInfo!)
                        
                        cell.btnLikesCount.touchUpInside {[weak self] (sender) in
                            self?.btnLikesCountCLK(postInfo?.valueForInt(key: CId))
                        }
                        
                        cell.btnMore.touchUpInside { [weak self](sender) in
                            self?.btnSharedReportCLK(postInfo: postInfo)
                        }
                        
                        cell.btnShare.touchUpInside { [weak self](sender) in
                            let sharePost = SharePostHelper(controller: self, dataSet: postInfo)
                            sharePost.shareURL = postInfo?.valueForString(key: CShare_url) ?? ""
                            sharePost.presentShareActivity()
                        }
                        
                        // .... LOAD MORE DATA HERE
                        self.loadMore(indexPath)
                        
                        return cell
                    }
                }
                if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeFourmTblCell", for: indexPath) as? HomeFourmTblCell {
                    cell.isLikesOthersPage = true
                    cell.homeFourmDataSetup(postInfo!)
                    
                    cell.btnLikesCount.touchUpInside {[weak self] (sender) in
                        self?.btnLikesCountCLK(postInfo?.valueForString(key: CPostId).toInt)
                    }
                    
                    cell.btnMore.touchUpInside { [weak self](sender) in
                        self?.btnReportCLK(postInfo)
                    }
                    
                    cell.btnShare.touchUpInside { [weak self](sender) in
                        let sharePost = SharePostHelper(controller: self, dataSet: postInfo)
                        sharePost.shareURL = postInfo?.valueForString(key: CShare_url) ?? ""
                        sharePost.presentShareActivity()
                    }
                    
                    // .... LOAD MORE DATA HERE
                    self.loadMore(indexPath)
                    
                    return cell
                }
                break
            case CStaticEventIdNew:
                //            6-event
                
                if (postInfo?.valueForString(key: CImage).isBlank)!{
                    let isshared = 0
                    if isshared == 1{
                        if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeSharedEventsCell", for: indexPath) as? HomeSharedEventsCell {
                            cell.homeEventDataSetup(postInfo!)
                            
                            cell.onChangeEventStatus = { [weak self] (action) in
                                self?.btnInterestedNotInterestedMayBeCLK(action, indexPath)
                            }
                            
                            cell.btnLikesCount.touchUpInside { [weak self](sender) in
                                self?.btnLikesCountCLK(postInfo?.valueForInt(key: CId))
                            }
                            
                            cell.btnMore.touchUpInside { [weak self](sender) in
                                self?.btnSharedReportCLK(postInfo: postInfo)
                            }
                            
                            cell.btnShare.touchUpInside { [weak self](sender) in
                                let sharePost = SharePostHelper(controller: self, dataSet: postInfo)
                                sharePost.shareURL = postInfo?.valueForString(key: CShare_url) ?? ""
                                sharePost.presentShareActivity()
                            }
                            
                            // .... LOAD MORE DATA HERE
                            self.loadMore(indexPath)
                            
                            return cell
                        }
                    }
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeEventImageTblCell", for: indexPath) as? HomeEventImageTblCell {
                       
                        cell.isLikesOthersPage = true
                        
                        cell.homeEventDataSetup(postInfo!)
                        
                        cell.onChangeEventStatus = { [weak self] (action) in
                            self?.btnInterestedNotInterestedMayBeCLK(action, indexPath)
                        }
                        
                        cell.btnLikesCount.touchUpInside { [weak self](sender) in
                            self?.btnLikesCountCLK(postInfo?.valueForString(key: CPostId).toInt)
                        }
                        
                        cell.btnMore.touchUpInside { [weak self](sender) in
                            self?.btnReportCLK(postInfo)
                        }
                        
                        cell.btnShare.touchUpInside { [weak self](sender) in
                            let sharePost = SharePostHelper(controller: self, dataSet: postInfo)
                            sharePost.shareURL = postInfo?.valueForString(key: CShare_url) ?? ""
                            sharePost.presentShareActivity()
                        }
                        
                        // .... LOAD MORE DATA HERE
                        self.loadMore(indexPath)
                        
                        return cell
                    }
                }else{
                    let isshared = 0
                    if isshared == 1{
                        if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeSharedEventImageTblCell", for: indexPath) as? HomeSharedEventImageTblCell {
                            cell.homeEventDataSetup(postInfo!)
                            
                            cell.btnLikesCount.touchUpInside { [weak self](sender) in
                                self?.btnLikesCountCLK(postInfo?.valueForInt(key: CId))
                            }
                            cell.onChangeEventStatus = { [weak self] (action) in
                                self?.btnInterestedNotInterestedMayBeCLK(action, indexPath)
                            }
                            
                            cell.btnMore.touchUpInside { [weak self](sender) in
                                self?.btnSharedReportCLK(postInfo: postInfo)
                            }
                            
                            cell.btnShare.touchUpInside {[weak self] (sender) in
                                let sharePost = SharePostHelper(controller: self, dataSet: postInfo)
                                sharePost.shareURL = postInfo?.valueForString(key: CShare_url) ?? ""
                                sharePost.presentShareActivity()
                            }
                            
                            // .... LOAD MORE DATA HERE
                            self.loadMore(indexPath)
                            
                            return cell
                        }
                    }
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeEventImageTblCell", for: indexPath) as? HomeEventImageTblCell {
                        cell.homeEventDataSetup(postInfo!)
                        cell.isLikesOthersPage = true
                        cell.btnLikesCount.touchUpInside { [weak self](sender) in
                            self?.btnLikesCountCLK(postInfo?.valueForString(key: CPostId).toInt)
                        }
                        cell.onChangeEventStatus = { [weak self] (action) in
                            self?.btnInterestedNotInterestedMayBeCLK(action, indexPath)
                        }
                        
                        cell.btnMore.touchUpInside { [weak self](sender) in
                            self?.btnReportCLK(postInfo)
                        }
                        
                        cell.btnShare.touchUpInside {[weak self] (sender) in
                            let sharePost = SharePostHelper(controller: self, dataSet: postInfo)
                            sharePost.shareURL = postInfo?.valueForString(key: CShare_url) ?? ""
                            sharePost.presentShareActivity()
                        }
                        
                        // .... LOAD MORE DATA HERE
                        self.loadMore(indexPath)
                        
                        return cell
                    }
                    
                }
                break
            case CStaticPollIdNew: // Poll Cell....
                let isshared = 0
                if isshared == 1{
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeSharedPollTblCell", for: indexPath) as? HomeSharedPollTblCell {
                        
                        cell.homePollDataSetup(postInfo!)
                        
                        cell.btnLikesCount.touchUpInside { [weak self](sender) in
                            self?.btnLikesCountCLK(postInfo?.valueForInt(key: CId))
                        }
                        
                        cell.btnMore.tag = indexPath.row
                        cell.onMorePressed = { [weak self] (index) in
                            guard let _ = self else { return }
                            self?.btnSharedReportCLK(postInfo: postInfo)
                        }
                        
                        cell.btnShare.touchUpInside { [weak self](sender) in
                            let sharePost = SharePostHelper(controller: self, dataSet: postInfo)
                            sharePost.shareURL = postInfo?.valueForString(key: CShare_url) ?? ""
                            sharePost.presentShareActivity()
                        }
                        
                        // .... LOAD MORE DATA HERE
                        self.loadMore(indexPath)
                        
                        return cell
                    }
                }
                if let cell = tableView.dequeueReusableCell(withIdentifier: "HomePollTblCell", for: indexPath) as? HomePollTblCell {
                    
                    cell.isLikesOthersPage = true
                    
                    cell.homePollDataSetup(postInfo!, isSelected: false)
                    
                    cell.btnLikesCount.touchUpInside { [weak self](sender) in
                        self?.btnLikesCountCLK(postInfo?.valueForString(key: CPostId).toInt)
                    }
                    
                    cell.btnMore.tag = indexPath.row
                    cell.onMorePressed = { [weak self] (index) in
                        guard let _ = self else { return }
                        self?.btnReportCLK(postInfo)
                    }
                    
                    cell.btnShare.touchUpInside { [weak self](sender) in
                        let sharePost = SharePostHelper(controller: self, dataSet: postInfo)
                        sharePost.shareURL = postInfo?.valueForString(key: CShare_url) ?? ""
                        sharePost.presentShareActivity()
                    }
                    
                    // .... LOAD MORE DATA HERE
                    self.loadMore(indexPath)
                    
                    return cell
                }
                break
            default:
                break
            }
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
        let postId = postInfo?.valueForString(key: "post_id")
        let isshared = 0
        let isdelete = 0
        if isdelete == 1{
            let sharePostData = postInfo?[CSharedPost] as? [String:Any] ?? [:]
            let sharedPostId = sharePostData[CId] as? Int ?? 0
            guard let viewcontroller = CStoryboardSharedPost.instantiateViewController(withIdentifier: "PostDeleteDetailViewController") as? PostDeleteDetailViewController else {
                return
            }
            viewcontroller.postID = sharedPostId
            self.navigationController?.pushViewController(viewcontroller, animated: true)
            return
        }
        switch postInfo?.valueForString(key: CPostTypeNew) {
        case CStaticArticleIdNew:
            
            if isshared == 1{
                let sharePostData = postInfo?[CSharedPost] as? [String:Any] ?? [:]
                let sharedPostId = sharePostData[CId] as? Int ?? 0
                guard let viewcontroller = CStoryboardSharedPost.instantiateViewController(withIdentifier: "ArticleSharedDetailViewController") as? ArticleSharedDetailViewController else {
                    return
                }
                
                viewcontroller.articleID = sharedPostId
                self.navigationController?.pushViewController(viewcontroller, animated: true)
                break
            }
            if let viewArticleVC = CStoryboardHome.instantiateViewController(withIdentifier: "ArticleDetailViewController") as? ArticleDetailViewController {
                viewArticleVC.isLikesOthersPage = true
                viewArticleVC.articleID = postId?.toInt
                viewArticleVC.articleInformation = postInfo ?? [:]
                self.navigationController?.pushViewController(viewArticleVC, animated: true)
            }
            break
            
        case CStaticGalleryIdNew:
            
            let isshared = 0
            if isshared == 1{
                let sharePostData = postInfo?[CSharedPost] as? [String:Any] ?? [:]
                let sharedPostId = sharePostData[CId] as? Int ?? 0
                guard let viewcontroller = CStoryboardSharedPost.instantiateViewController(withIdentifier: "ImageSharedDetailViewController") as? ImageSharedDetailViewController else {
                    return
                }
                viewcontroller.imgPostId = sharedPostId
                self.navigationController?.pushViewController(viewcontroller, animated: true)
                break
            }
            if let imageDetailsVC = CStoryboardImage.instantiateViewController(withIdentifier: "ImageDetailViewController") as? ImageDetailViewController {
                imageDetailsVC.isLikesOthersPage = true
                imageDetailsVC.galleryInfo = postInfo ?? [:]
                imageDetailsVC.imgPostId = postId?.toInt
                self.navigationController?.pushViewController(imageDetailsVC, animated: true)
            }
            break
            
        case CStaticChirpyIdNew:
            
            if postInfo?.valueForString(key: CImage).isBlank ?? true{
                
                let isshared = 0
                if isshared == 1{
                    let sharePostData = postInfo?[CSharedPost] as? [String:Any] ?? [:]
                    let sharedPostId = sharePostData[CId] as? Int ?? 0
                    guard let viewcontroller = CStoryboardSharedPost.instantiateViewController(withIdentifier: "ChirpySharedDetailsViewController") as? ChirpySharedDetailsViewController else {
                        return
                    }
                    viewcontroller.chirpyID = sharedPostId
                    self.navigationController?.pushViewController(viewcontroller, animated: true)
                    break
                }
                if let chirpyDetailsVC = CStoryboardHome.instantiateViewController(withIdentifier: "ChirpyImageDetailsViewController") as? ChirpyImageDetailsViewController{
                    chirpyDetailsVC.isLikesOthersPage = true
                    chirpyDetailsVC.chirpyInformation = postInfo ?? [:]
                    chirpyDetailsVC.chirpyID = postId?.toInt
                    self.navigationController?.pushViewController(chirpyDetailsVC, animated: true)
                }
            }else{
                
                let isshared = 0
                if isshared == 1{
                    let sharePostData = postInfo?[CSharedPost] as? [String:Any] ?? [:]
                    let sharedPostId = sharePostData[CId] as? Int ?? 0
                    guard let viewcontroller = CStoryboardSharedPost.instantiateViewController(withIdentifier: "ChirpySharedImageDetailsViewController") as? ChirpySharedImageDetailsViewController else {
                        return
                    }
                    viewcontroller.chirpyID = sharedPostId
                    self.navigationController?.pushViewController(viewcontroller, animated: true)
                    break
                }
                if let chirpyImageVC = CStoryboardHome.instantiateViewController(withIdentifier: "ChirpyImageDetailsViewController") as? ChirpyImageDetailsViewController{
                    chirpyImageVC.isLikesOthersPage = true
                    chirpyImageVC.chirpyInformation = postInfo ?? [:]
                    chirpyImageVC.chirpyID = postId?.toInt
                    self.navigationController?.pushViewController(chirpyImageVC, animated: true)
                }
            }
        case CStaticShoutIdNew:
            
            let isshared = 0
            if isshared == 1{
                let sharePostData = postInfo?[CSharedPost] as? [String:Any] ?? [:]
                let sharedPostId = sharePostData[CId] as? Int ?? 0
                guard let viewcontroller = CStoryboardSharedPost.instantiateViewController(withIdentifier: "ShoutsSharedDetailViewController") as? ShoutsSharedDetailViewController else {
                    return
                }
                viewcontroller.shoutID = sharedPostId
                self.navigationController?.pushViewController(viewcontroller, animated: true)
                break
            }
            if let shoutsDetailsVC = CStoryboardHome.instantiateViewController(withIdentifier: "ShoutsDetailViewController") as? ShoutsDetailViewController{
                shoutsDetailsVC.isLikesOthersPage = true
                shoutsDetailsVC.shoutInformations = postInfo ?? [:]
                shoutsDetailsVC.shoutID = postId?.toInt
                self.navigationController?.pushViewController(shoutsDetailsVC, animated: true)
            }
            break
            
        case CStaticForumIdNew:
            
            let isshared = 0
            if isshared == 1{
                let sharePostData = postInfo?[CSharedPost] as? [String:Any] ?? [:]
                let sharedPostId = sharePostData[CId] as? Int ?? 0
                guard let viewcontroller = CStoryboardSharedPost.instantiateViewController(withIdentifier: "ForumSharedDetailViewController") as? ForumSharedDetailViewController else {
                    return
                }
                viewcontroller.forumID = sharedPostId
                self.navigationController?.pushViewController(viewcontroller, animated: true)
                break
            }
            if let forumDetailsVC = CStoryboardHome.instantiateViewController(withIdentifier: "ForumDetailViewController") as? ForumDetailViewController{
                forumDetailsVC.isLikesOthersPage = true
                forumDetailsVC.forumInformation = postInfo ?? [:]
                forumDetailsVC.forumID = postId?.toInt
                self.navigationController?.pushViewController(forumDetailsVC, animated: true)
            }
            break
            
        case CStaticEventIdNew:
            if postInfo?.valueForString(key: CImage).isBlank ?? true{
                
                let isshared = 0
                if isshared == 1{
                    let sharePostData = postInfo?[CSharedPost] as? [String:Any] ?? [:]
                    let sharedPostId = sharePostData[CId] as? Int ?? 0
                    guard let viewcontroller = CStoryboardSharedPost.instantiateViewController(withIdentifier: "EventSharedDetailViewController") as? EventSharedDetailViewController else {
                        return
                    }
                    viewcontroller.postID = sharedPostId
                    self.navigationController?.pushViewController(viewcontroller, animated: true)
                    break
                }
                if let eventDetailsVC = CStoryboardEvent.instantiateViewController(withIdentifier: "EventDetailImageViewController") as? EventDetailImageViewController {
                    eventDetailsVC.isLikesOthersPage = true
                    eventDetailsVC.eventInfo = postInfo ?? [:]
                    eventDetailsVC.postID =  postId?.toInt
                    self.navigationController?.pushViewController(eventDetailsVC, animated: true)
                }
            }else{
                //let isSharedPost = postInfo?.valueForInt(key: CIsSharedPost)
                let isshared = 0
                if isshared == 1{
                    let sharePostData = postInfo?[CSharedPost] as? [String:Any] ?? [:]
                    let sharedPostId = sharePostData[CId] as? Int ?? 0
                    guard let viewcontroller = CStoryboardSharedPost.instantiateViewController(withIdentifier: "EventSharedDetailImageViewController") as? EventSharedDetailImageViewController else {
                        return
                    }
                    viewcontroller.postID = sharedPostId
                    self.navigationController?.pushViewController(viewcontroller, animated: true)
                    break
                }
                if let eventDetailsVC = CStoryboardEvent.instantiateViewController(withIdentifier: "EventDetailImageViewController") as? EventDetailImageViewController {
                    eventDetailsVC.isLikesOthersPage = true
                    eventDetailsVC.eventInfo = postInfo ?? [:]
                    eventDetailsVC.postID =  postId?.toInt
                    self.navigationController?.pushViewController(eventDetailsVC, animated: true)
                }
            }
            
            break
        case CStaticPollIdNew: // Poll Cell....
            
            let isshared = 0
            if isshared == 1{
                let sharePostData = postInfo?[CSharedPost] as? [String:Any] ?? [:]
                let sharedPostId = sharePostData[CId] as? Int ?? 0
                guard let viewcontroller = CStoryboardSharedPost.instantiateViewController(withIdentifier: "PollSharedDetailsViewController") as? PollSharedDetailsViewController else {
                    return
                }
                viewcontroller.pollID = sharedPostId
                self.navigationController?.pushViewController(viewcontroller, animated: true)
                break
            }
            if let viewArticleVC = CStoryboardPoll.instantiateViewController(withIdentifier: "PollDetailsViewController") as? PollDetailsViewController {
                viewArticleVC.isLikesOthersPage = true
                viewArticleVC.pollInformation = postInfo ?? [:]
                viewArticleVC.pollID =  postId?.toInt
                self.navigationController?.pushViewController(viewArticleVC, animated: true)
            }
            break
        default:
            break
        }
    }
}

// MARK:- --------  TableView Cells Action
extension OtherUserProfileViewController {
    fileprivate func btnInterestedNotInterestedMayBeCLK(_ type : Int?, _ indexpath : IndexPath?){
        var postInfo = arrPostList[indexpath!.row]
        if type != postInfo?.valueForInt(key: CIsInterested){
            
            // Update existing count here...
            let totalIntersted = postInfo?.valueForString(key: CTotalInterestedUsers)
            let totalNotIntersted = postInfo?.valueForString(key: CTotalNotInterestedUsers)
            let totalMaybe = postInfo?.valueForString(key: CTotalMaybeInterestedUsers)
            switch postInfo?.valueForInt(key: CIsInterested) {
            case CTypeInterested:
                postInfo?[CTotalInterestedUsers] = totalIntersted?.toInt ?? 0 - 1
                break
            case CTypeNotInterested:
                postInfo?[CTotalNotInterestedUsers] = totalNotIntersted?.toInt ?? 0 - 1
                break
            case CTypeMayBeInterested:
                postInfo?[CTotalMaybeInterestedUsers] = totalMaybe?.toInt ?? 0 - 1
                break
            default:
                break
            }
            postInfo?[CIsInterested] = type
            
            switch type {
            case CTypeInterested:
                postInfo?[CTotalInterestedUsers] = totalIntersted?.toInt ?? 0 + 1
                break
            case CTypeNotInterested:
                postInfo?[CTotalNotInterestedUsers] = totalNotIntersted?.toInt ?? 0 + 1
                break
            case CTypeMayBeInterested:
                postInfo?[CTotalMaybeInterestedUsers] = totalMaybe?.toInt ?? 0 + 1
                break
            default:
                break
            }
            let postId = postInfo?.valueForString(key: "post_id")
            _ = postInfo?.valueForInt(key: CIsSharedPost)
            
            MIGeneralsAPI.shared().interestNotInterestMayBe(postId?.toInt, type!, viewController: self)
        }
        
    }
    
    fileprivate func btnLikesCountCLK(_ postId : Int?){
        if let likeVC = CStoryboardGeneral.instantiateViewController(withIdentifier: "LikeViewController") as? LikeViewController{
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
        
        self.presentActionsheetWithOneButton(actionSheetTitle: nil, actionSheetMessage: nil, btnOneTitle: CReport, btnOneStyle: .default) { (alert) in
            
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
                    break
                }
                reportVC.userID = postInfo?.valueForInt(key: CUserId)
                reportVC.reportID = postInfo?.valueForInt(key: CId)
                self.navigationController?.pushViewController(reportVC, animated: true)
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
}

// MARK:- --------  Action Event
extension OtherUserProfileViewController {
    
    @IBAction func btnUnblockCLK(_ sender: UIButton) {
        self.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: CMessageUnBlockUser, btnOneTitle: CBtnYes, btnOneTapped: { [weak self](alert) in
            self?.blockUnblockUserApi(7)
        }, btnTwoTitle: CBtnNo, btnTwoTapped: nil)
    }
    
    @IBAction func btnUserImgCLK(_ sender: UIButton) {
        let lightBoxHelper = LightBoxControllerHelper()
        lightBoxHelper.openSingleImage(image: self.imgUser.image, viewController: self)
    }
}
