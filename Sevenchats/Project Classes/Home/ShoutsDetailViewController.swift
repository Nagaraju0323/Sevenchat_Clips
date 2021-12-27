//
//  ShoutsDetailViewController.swift
//  Sevenchats
//
//  Created by mac-0005 on 21/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit
import ActiveLabel

class ShoutsDetailViewController: ParentViewController {
    
    @IBOutlet weak var viewCommentContainer : UIView!
    @IBOutlet weak var lblUserName : UILabel!
    @IBOutlet weak var imgUser : UIImageView!
    @IBOutlet weak var lblShoutsDescription : UILabel!
    @IBOutlet weak var lblShoutsType : UILabel!
    @IBOutlet weak var lblShoutsPostDate : UILabel!
    @IBOutlet weak var btnLike : UIButton!
    @IBOutlet weak var btnLikeCount : UIButton!
    @IBOutlet weak var btnComment : UIButton!
    @IBOutlet weak var btnShare : UIButton!
    @IBOutlet weak var tblCommentList : UITableView! {
        didSet {
            tblCommentList.register(UINib(nibName: "CommentTblCell", bundle: nil), forCellReuseIdentifier: "CommentTblCell")
            tblCommentList.estimatedRowHeight = 100;
            tblCommentList.rowHeight = UITableView.automaticDimension;
            tblCommentList.tableFooterView = UIView()
            tblCommentList.delegate = self
            tblCommentList.dataSource = self
            tblCommentList.separatorStyle = .none
        }
    }
    
    @IBOutlet weak var btnSend : UIButton!
    @IBOutlet weak var txtViewComment : GenericTextView!{
        didSet{
            txtViewComment.genericDelegate = self
            txtViewComment.PlaceHolderColor = ColorPlaceholder
        }
    }
    @IBOutlet weak var cnTextViewHeight : NSLayoutConstraint!
    // Set for User suggestion view...
    @IBOutlet fileprivate weak var viewUserSuggestion : UserSuggestionView! {
        didSet {
            viewUserSuggestion.userSuggestionDelegate = self
            viewUserSuggestion.initialization()
        }
    }
    
    @IBOutlet weak var btnProfileImg : UIButton!
    @IBOutlet weak var btnUserName : UIButton!
    
    var shoutID : Int?
    var shoutIDNew : String?
    var arrCommentList = [[String:Any]]()
    var shoutInformation = [String:Any]()
    var apiTask : URLSessionTask?
    var pageNumber = 1
    var refreshControl = UIRefreshControl()
    var likeCount = 0
    var commentCount = 0
    var editCommentId : Int? = nil
    var shoutInformations = [String:Any]()
    var totalComment = 0
    var like =  0
    var info = [String:Any]()
    var commentinfo = [String:Any]()
    var likeTotalCount = 0
    var posted_ID = ""
    var profileImg = ""
    var notifcationIsSlected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Initialization()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setShoutsDetailData(shoutInformations)
        self.updateUIAccordingToLanguage()
        
    }
    
    // MARK:- --------- Initialization
    func Initialization(){
        
        self.title = CNavShoutDetails
        self.view.backgroundColor = CRGB(r: 249, g: 250, b: 250)
        self.parentView.backgroundColor = .clear
        self.tblCommentList.backgroundColor = .clear
        
        self.btnShare.setTitle(CBtnShare, for: .normal)
        self.lblShoutsType.text = CTypeShout
        GCDMainThread.async {
            self.imgUser.layer.cornerRadius = self.imgUser.CViewWidth/2
            self.lblShoutsType.layer.cornerRadius = 3
            self.viewCommentContainer.shadow(color: ColorAppTheme, shadowOffset: CGSize(width: 0, height: 5), shadowRadius: 10.0, shadowOpacity: 10.0)
        }
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: #imageLiteral(resourceName: "ic_btn_nav_more"), style: .plain, target: self, action: #selector(self.btnMenuClicked(_:)))]
        
        self.refreshControl.addTarget(self, action: #selector(self.pullToRefresh), for: .valueChanged)
        self.refreshControl.tintColor = ColorAppTheme
        self.tblCommentList.pullToRefreshControl = self.refreshControl
        self.pageNumber = 1
        self.getShoutsDetailsFromServer()
        
    }
    
    func updateUIAccordingToLanguage(){
        
        if Localization.sharedInstance.applicationFlowWithLanguageRTL() {
            // Reverse Flow...
            btnLike.contentHorizontalAlignment = .left
            btnLikeCount.contentHorizontalAlignment = .right
            btnComment.contentHorizontalAlignment = .right
            //btnComment.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 7)
        }else{
            // Normal Flow...
            btnLike.contentHorizontalAlignment = .right
            btnLikeCount.contentHorizontalAlignment = .left
            btnComment.contentHorizontalAlignment = .left
            //btnComment.titleEdgeInsets = UIEdgeInsets(top: 0, left: 7, bottom: 0, right: 0)
        }
        txtViewComment.placeHolder = CMessageTypeYourMessage
    }
}

// MARK:- --------- Api Functions
extension ShoutsDetailViewController{
    
    @objc func pullToRefresh() {
        if apiTask?.state == URLSessionTask.State.running {
            apiTask?.cancel()
        }
        
        self.pageNumber = 1
        refreshControl.beginRefreshing()
        self.getShoutsDetailsFromServer()
        self.getCommentListFromServer()
    }
    
    //    fileprivate func getShoutsDetailsFromServer() {
    //
    //        self.parentView.isHidden = true
    //        if let shouID = self.shoutID {
    //            APIRequest.shared().viewPostDetail(postID: shouID) { [weak self] (response, error) in
    //                guard let self = self else { return }
    //                if response != nil {
    //                    self.parentView.isHidden = false
    //                    if let shoInfo = response![CJsonData] as? [String : Any]{
    //                        self.setShoutsDetailData(shoInfo)
    //                        self.openUserProfileScreen()
    //                    }
    //                }
    //                self.getCommentListFromServer()
    //            }
    //        }
    //    }
    
    fileprivate func getShoutsDetailsFromServer() {
        
        self.parentView.isHidden = true
        if let shouID = self.shoutID {
            
            APIRequest.shared().viewPostDetailNew(postID: shouID, apiKeyCall: CAPITagshoutsDetials){ [weak self] (response, error) in
                //  APIRequest.shared().viewPostDetail(postID: shouID) { [weak self] (response, error) in
                guard let self = self else { return }
                if response != nil {
                    self.parentView.isHidden = false
                    if let shoInfo = response!["data"] as? [[String:Any]]{
                        for arraydata in shoInfo {
                            //if let shoInfo = response!["data"] as? [String : Any]{
                            //                            self.setShoutsDetailData(arraydata)
                            self.openUserProfileScreen()
                        }
                    }
                }
                self.getCommentListFromServer()
            }
        }
    }
    
    
    fileprivate func openUserProfileScreen(){
        
        self.btnProfileImg.touchUpInside { [weak self] (sender) in
            guard let self = self else { return }
           // appDelegate.moveOnProfileScreen(self.shoutInformation.valueForString(key: CUserId), self)
            appDelegate.moveOnProfileScreenNew(self.shoutInformation.valueForString(key: CUserId), self.shoutInformation.valueForString(key: CUsermailID), self)
        }
        
        self.btnUserName.touchUpInside { [weak self] (sender) in
            guard let self = self else { return }
           // appDelegate.moveOnProfileScreen(self.shoutInformation.valueForString(key: CUserId), self)
            appDelegate.moveOnProfileScreenNew(self.shoutInformation.valueForString(key: CUserId), self.shoutInformation.valueForString(key: CUsermailID), self)
        }
    }
    
    func setShoutsDetailData(_ shoutInfo : [String : Any]?){
        if let shoInfo = shoutInfo{
            shoutInformation = shoInfo
            self.shoutIDNew = shoInfo.valueForString(key:CPostId)
            posted_ID = shoInfo.valueForString(key: "user_id")
            
            self.lblUserName.text = shoInfo.valueForString(key: CFirstname) + " " + shoInfo.valueForString(key: CLastname)
            //            self.lblShoutsPostDate.text = DateFormatter.dateStringFrom(timestamp: shoInfo.valueForDouble(key: CCreated_at), withFormate: CreatedAtPostDF)
            self.lblShoutsDescription.text = shoInfo.valueForString(key: CContent)
            self.imgUser.loadImageFromUrl(shoInfo.valueForString(key: CUserProfileImage), true)
            //  self.lblShoutCategory.text = shoInfo.valueForString(key: CCategory)
            
            //LikeButton
            //            self.btnLike.isSelected = shoInfo.valueForInt(key: CIs_Like) == 1
            //            likeCount = shoInfo.valueForInt(key: CTotal_like) ?? 0
            //            self.btnLikeCount.setTitle(appDelegate.getLikeString(like: likeCount), for: .normal)
            
            let is_Liked = shoInfo.valueForString(key: CIsLiked)
            
            if is_Liked == "Yes"{
                btnLike.isSelected = true
            }else {
                btnLike.isSelected = false
            }
            
            likeCount = shoInfo.valueForString(key: CLikes).toInt ?? 0
            //        likeCount = product.likes!.toInt!
            self.btnLikeCount.setTitle(appDelegate.getLikeString(like: likeCount), for: .normal)
            
            //CommentSection
            //            self.commentCount = shoInfo.valueForInt(key: CTotalComment) ?? 0
            //            btnComment.setTitle(appDelegate.getCommentCountString(comment: commentCount), for: .normal)
            
            commentCount = shoInfo.valueForString(key: "comments").toInt ?? 0
            self.totalComment = commentCount
            btnComment.setTitle(appDelegate.getCommentCountString(comment: commentCount), for: .normal)
            
            self.tblCommentList.updateHeaderViewHeight(extxtraSpace: 0)
            let created_At = shoInfo.valueForString(key: CCreated_at)
            let cnvStr = created_At.stringBefore("G")
            let startCreated = DateFormatter.shared().convertDatereversLatest(strDate: cnvStr)
            lblShoutsPostDate.text = startCreated
        }
    }
    fileprivate func deleteShoutPost(_ shoutInfo : [String : Any]?){
        
        if let shoID = self.shoutID{
            self.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: CMessageDeletePost, btnOneTitle: CBtnYes, btnOneTapped: { (alert) in
                
                let postTypeDelete = "post_shout"
                let dict =
                    [
                        "post_id": shoutInfo?.valueForString(key: "post_id"),
                        "image": "",
                        "post_title": "",
                        "post_content": shoutInfo?.valueForString(key: "post_content"),
                        "age_limit": "",
                        "targeted_audience": shoutInfo?.valueForString(key: "targeted_audience"),
                        "selected_persons": shoutInfo?.valueForString(key: "selected_persons"),
                        "status_id": "3"
                    ]
                
                
                APIRequest.shared().deletePostNew(postDetials: dict, apiKeyCall: postTypeDelete, completion: { [weak self](response, error) in
                    guard let self = self else { return }
                    if response != nil && error == nil{
                        self.navigationController?.popViewController(animated: true)
                        MIGeneralsAPI.shared().refreshPostRelatedScreens(nil, shoID, self, .deletePost)
                    }
                })
            }, btnTwoTitle: CBtnNo, btnTwoTapped: nil)
        }
    }
    //    fileprivate func deleteShoutPost(){
    //
    //        if let shoID = self.shoutID{
    //            self.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: CMessageDeletePost, btnOneTitle: CBtnYes, btnOneTapped: { (alert) in
    //                APIRequest.shared().deletePost(postID: shoID, completion: { [weak self] (response, error) in
    //                    guard let self = self else { return }
    //                    if response != nil && error == nil{
    //                        self.navigationController?.popViewController(animated: true)
    //                        MIGeneralsAPI.shared().refreshPostRelatedScreens(nil, shoID, self, .deletePost)
    //                    }
    //                })
    //            }, btnTwoTitle: CBtnNo, btnTwoTapped: nil)
    //        }
    //    }
    
    fileprivate func getCommentListFromServer(){
        if let shoID = self.shoutIDNew{
            if apiTask?.state == URLSessionTask.State.running {
                self.refreshControl.endRefreshing()
                return
            }
            self.arrCommentList.removeAll()
            // Add load more indicator here...
            self.tblCommentList.tableFooterView = self.pageNumber > 2 ? self.loadMoreIndicator(ColorAppTheme) : UIView()
            
            apiTask = APIRequest.shared().getProductCommentLists(page: pageNumber, showLoader: false, productId:shoID) { [weak self] (response, error) in
                //            apiTask  = APIRequest.shared().getCommentList(page: pageNumber, showLoader: false, post_id: shoID, rss_id: nil) { [weak self] (response, error) in
                guard let self = self else { return }
                self.tblCommentList.tableFooterView = UIView()
                self.apiTask?.cancel()
                self.refreshControl.endRefreshing()
                if response != nil {
                    if let arrList = response!["comments"] as? [[String:Any]] {
                        
                        //                        for arrComments in arrList{
                        ////                            self.commentinfo = arrComments
                        //                        }
                        // Remove all data here when page number == 1
                        if self.pageNumber == 1 {
                            self.arrCommentList.removeAll()
                            self.tblCommentList.reloadData()
                        }
                        // Add Data here...
                        if arrList.count > 0{
                            self.arrCommentList = self.arrCommentList + arrList
                            self.tblCommentList.reloadData()
                            self.pageNumber += 1
                        }
                    }
                    
                    print("arrCommentListCount : \(self.arrCommentList.count)")
                }
            }
        }
    }
    
    func updateShoutCommentSection(_ arrComm : [[String : Any]]){
        
        self.arrCommentList.removeAll()
        
        if arrComm.count > 0{
            // Add last two comment here...
            self.arrCommentList = arrComm
            //         self.arrCommentList.append(arrComm.first!)
            //         self.arrCommentList.append(arrComm[1])
            
        }else{
            self.arrCommentList = arrComm
        }
        self.tblCommentList.reloadData()
    }
}

// MARK:- --------- UITableView Datasources/Delegate
extension ShoutsDetailViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrCommentList.count > 0 ? 1 : 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let header = EventCommentTblHeader.viewFromXib as? EventCommentTblHeader{
            header.backgroundColor =  CRGB(r: 249, g: 250, b: 250)
            header.lblTitle.text = appDelegate.getCommentCountString(comment: commentCount)
            return header
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCommentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTblCell", for: indexPath) as? CommentTblCell {
            
            weak var weakCell = cell
            let commentInfo = arrCommentList[indexPath.row]
            //            cell.lblCommentPostDate.text = DateFormatter.shared().durationString(duration: commentInfo.valueForString(key: CCreated_at))
            //            print(DateFormatter.shared().durationString(duration: commentInfo.valueForString(key: "updated_at")))
            
            let timeStamp = DateFormatter.shared().getDateFromTimeStamp(timeStamp:commentInfo.valueForString(key: "updated_at").toDouble ?? 0.0)
            cell.lblCommentPostDate.text = timeStamp
            
            cell.lblUserName.text = commentInfo.valueForString(key: CFirstname) + " " + commentInfo.valueForString(key: CLastname)
            cell.imgUser.loadImageFromUrl(commentInfo.valueForString(key: CUserProfileImage), true)
            
            var commentText = commentInfo.valueForString(key: "comment")
            cell.lblCommentText.enabledTypes.removeAll()
            cell.viewDevider.isHidden = ((arrCommentList.count - 1) == indexPath.row)
            
            if Int64(commentInfo.valueForString(key: CUserId)) == appDelegate.loginUser?.user_id{
                cell.btnMoreOption.isHidden = false
            }else{
                cell.btnMoreOption.isHidden = true
            }
            cell.btnMoreOption.touchUpInside { [weak self] (_) in
                self?.btnMoreOptionOfComment(index: indexPath.row)
            }
            
            if let arrIncludedUsers = commentInfo["user_id"] as? [[String : Any]] {
                for userInfo in arrIncludedUsers {
                    let userName = userInfo.valueForString(key: CFirstname) + " " + userInfo.valueForString(key: CLastname)
                    let customTypeUserName = ActiveType.custom(pattern: "\(userName)") //Looks for "user name"
                    cell.lblCommentText.enabledTypes.append(customTypeUserName)
                    cell.lblCommentText.customColor[customTypeUserName] = ColorAppTheme
                    
                    cell.lblCommentText.handleCustomTap(for: customTypeUserName, handler: { [weak self] (name) in
                        guard let self = self else { return }
                        print(name)
                        let arrSelectedUser = arrIncludedUsers.filter({$0[CFullName] as? String == name})
                        
                        if arrSelectedUser.count > 0 {
                            let userSelectedInfo = arrSelectedUser[0]
                          //  appDelegate.moveOnProfileScreen(userSelectedInfo.valueForString(key: CUserId), self)
                            appDelegate.moveOnProfileScreenNew(self.shoutInformation.valueForString(key: CUserId), self.shoutInformation.valueForString(key: CUsermailID), self)
                        }
                    })
                    
                    commentText = commentText.replacingOccurrences(of: String(NSString(format: kMentionFriendStringFormate as NSString, userInfo.valueForString(key: CUserId))), with: userName)
                }
            }
            
            cell.lblCommentText.customize { [weak self] label in
                guard let self = self else { return }
                label.text = commentText
                label.minimumLineHeight = 0.0
                
                label.configureLinkAttribute = { [weak self](type, attributes, isSelected) in
                    guard let _ = self else { return attributes }
                    var atts = attributes
                    atts[NSAttributedString.Key.font] = CFontPoppins(size: weakCell?.lblCommentText.font.pointSize ?? 0, type: .meduim)
                    return atts
                }
            }
            
            cell.btnUserName.touchUpInside {[weak self] (sender) in
                guard let self = self else { return }
//                appDelegate.moveOnProfileScreen(commentInfo.valueForString(key: CUserId), self)
                appDelegate.moveOnProfileScreenNew(self.shoutInformation.valueForString(key: CUserId), self.shoutInformation.valueForString(key: CUsermailID), self)
            }
            
            cell.btnUserImage.touchUpInside {[weak self] (sender) in
                guard let self = self else { return }
//                appDelegate.moveOnProfileScreen(commentInfo.valueForString(key: CUserId), self)
                appDelegate.moveOnProfileScreenNew(self.shoutInformation.valueForString(key: CUserId), self.shoutInformation.valueForString(key: CUsermailID), self)
            }
            // Load more data....
            //            if (indexPath == tblCommentList.lastIndexPath()) && apiTask?.state != URLSessionTask.State.running {
            //                self.getCommentListFromServer()
            //            }
            return cell
        }
        
        return tableView.tableViewDummyCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

// MARK:-  --------- Generic UITextView Delegate
extension ShoutsDetailViewController: GenericTextViewDelegate{
    
    func genericTextViewDidChange(_ textView: UITextView, height: CGFloat) {
        
        // Set TextView height...
        self.cnTextViewHeight.constant = height > 35 ? height : 35
        
        // If TextView height is greater then 100 (TextView Max height should be 100)
        if self.cnTextViewHeight.constant > 100 {
            self.cnTextViewHeight.constant = 100
        }
        
        if textView.text.count < 1 || textView.text.isBlank {
            btnSend.isUserInteractionEnabled = false
            btnSend.alpha = 0.5
        }else {
            btnSend.isUserInteractionEnabled = true
            btnSend.alpha = 1
        }
        if viewUserSuggestion != nil && textView == txtViewComment{
            self.viewUserSuggestion.setAttributeStringInTextView(self.txtViewComment)
        }
    }
    
    func genericTextView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if viewUserSuggestion != nil {
            let strText = textView.text ?? ""
            if !strText.isEmpty && strText.count > range.location && viewUserSuggestion.isSearchString{
                let str = String(strText[range.location ... range.location])
                if text.isEmpty{
                    //viewUserSuggestion.searchString -= text
                }
                if str == "@" {
                    viewUserSuggestion.isSearchString = false
                    viewUserSuggestion.searchString = ""
                }
            }
            if viewUserSuggestion.isSearchString{
                viewUserSuggestion.searchString += text
            }
            if text == "@"{
                viewUserSuggestion.searchString = ""
                viewUserSuggestion.isSearchString = true
            }
            
            viewUserSuggestion.filterUser(textView, shouldChangeTextIn: range, replacementText: text)
        }
        
        return true
    }
}

// MARK:-  --------- UserSuggestionDelegate
extension ShoutsDetailViewController: UserSuggestionDelegate{
    func didSelectSuggestedUser(_ userInfo: [String : Any]) {
        viewUserSuggestion.arrangeFinalComment(userInfo, textView: txtViewComment)
    }
}

// MARK:-  --------- Action Event
extension ShoutsDetailViewController{
    @IBAction func btnSendCommentCLK(_ sender : UIButton){
        self.resignKeyboard()
        
        if (txtViewComment.text?.isBlank)!{
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageCommentBlank, btnOneTitle: CBtnOk, btnOneTapped: nil)
        }else{
            if let shoId = self.shoutID{
                // Get Final text for comment..
                let strComment = viewUserSuggestion.stringToBeSendInComment(txtViewComment)
                
                // Get Mention user's Ids..
                let includedUser = viewUserSuggestion.arrSelectedUser.map({$0.valueForString(key: CUserId) }).joined(separator: ",")
                
                guard let userID = appDelegate.loginUser?.user_id else{
                    return
                }
                let userId = userID.description
                APIRequest.shared().sendProductCommentnew(productId:shoId.description, commentId : self.editCommentId, comment: strComment, include_user_id: userId)  { [weak self] (response, error) in
                    
                    //                APIRequest.shared().sendComment(post_id: shoId, commentId: self.editCommentId, rss_id: nil, type: 1, comment: strComment, include_user_id: includedUser) { [weak self] (response, error) in
                    guard let self = self else { return }
                    if response != nil && error == nil  {
                        
                        self.viewUserSuggestion.hideSuggestionView(self.txtViewComment)
                        self.txtViewComment.text = ""
                        self.btnSend.isUserInteractionEnabled = false
                        self.btnSend.alpha = 0.5
                        self.txtViewComment.updatePlaceholderFrame(false)
                        
                        //                        print(response![CJsonData] as? [[String : Any]])
                        //                        if let comment = response![CJsonData] as? [String : Any] {
                        if let comment = response![CJsonData] as? [[String : Any]] {
                            
                            for comments in comment {
                                
                                self.commentinfo = comments
                                if (self.editCommentId ?? 0) == 0{
                                    //                                    self.arrCommentList.insert(comments, at: 0)
                                    
                                    self.getCommentListFromServer()
                                    let comment_data = comments["comments"] as? String
                                    self.commentCount = comment_data?.toInt ?? 0
                                    //                                    self.commentCount += 1
                                    
                                    self.btnComment.setNormalTitle(normalTitle: appDelegate.getCommentCountString(comment: self.commentCount))
                                    //                                    if let responsInfo = response as? [String : Any]{
                                    //                                        // To udpate previous screen data....
                                    MIGeneralsAPI.shared().refreshPostRelatedScreens(self.commentinfo, shoId, self, .commentPost)
                                    
                                    //                                    }
                                }else{
                                    // Edit comment in array
                                    if let index = self.arrCommentList.index(where: { $0[CId] as? Int ==  (self.editCommentId ?? 0)}) {
                                        self.arrCommentList.remove(at: index)
                                        self.arrCommentList.insert(comments, at: 0)
                                        self.tblCommentList.reloadData()
                                    }
                                }
                            }
                            let data = response![CJsonMeta] as? [String:Any] ?? [:]
                            guard let firstName = appDelegate.loginUser?.first_name else {return}
                            guard let lassName = appDelegate.loginUser?.last_name else {return}
                            let stausLike = data["status"] as? String ?? "0"
                            if stausLike == "0" {
                                MIGeneralsAPI.shared().sendNotification(self.posted_ID, userID: userId, subject: "Comment to Post Shout", MsgType: "COMMENT", MsgSent: "", showDisplayContent: "Comment to Post Shout", senderName: firstName + lassName)
                            }
                            
                            self.genericTextViewDidChange(self.txtViewComment, height: 10)
                        }
                        self.editCommentId =  nil
                        //                        self.tblCommentList.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
                        
                        //self.lblNoData.isHidden = self.arrCommentList.count != 0
                    }
                }
            }
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadder"), object: nil)
        
    }
    
    
    //    func addEditComment(){
    //
    //        // Get Final text for comment..
    //        let strComment = viewUserSuggestion.stringToBeSendInComment(txtViewComment)
    //        // Get Mention user's Ids..
    //        let includedUser = viewUserSuggestion.arrSelectedUser.map({$0.valueForString(key: CUserId) }).joined(separator: ",")
    //        guard let userID = appDelegate.loginUser?.user_id else{
    //            return
    //        }
    //        let userId = userID.description
    //
    //        APIRequest.shared().sendProductCommentnew(productId:productIds, commentId : self.editCommentId, comment: strComment, include_user_id: userId)  { [weak self] (response, error) in
    //            guard let self = self else { return }
    //            DispatchQueue.main.async {
    //                if response != nil && error == nil {
    //
    //                    self.viewUserSuggestion.hideSuggestionView(self.txtViewComment)
    //                    self.txtViewComment.text = ""
    //                    self.btnSend.isUserInteractionEnabled = false
    //                    self.btnSend.alpha = 0.5
    //                    self.txtViewComment.updatePlaceholderFrame(false)
    //                    if let comment = response!["meta"] as? [String : Any] {
    //                        if (comment["status"] as? String ?? "") == "0"{
    //                            if self.isEditBtnCLK == true {
    //                                self.arrCommentList.remove(at: self.index_Row ?? 0)
    //                                self.commentsInfo["comment"] = strComment
    //                                self.arrCommentList.insert(self.commentsInfo, at: self.index_Row ?? 0)
    //                                self.tblProduct.reloadData()
    //                                UIView.performWithoutAnimation {
    //                                    let indexPath = IndexPath(item: self.index_Row ?? 0, section: 1)
    //                                    if (self.tblProduct.indexPathsForVisibleRows?.contains(indexPath))!{
    //                                        self.tblProduct.reloadRows(at: [indexPath], with: .none)
    //                                    }
    //                                }
    //                                self.isEditBtnCLK = false
    //                            }else {
    //                                var productCount = self.product?.totalComments.toInt ?? 0
    //                                productCount += 1
    //                                self.product?.totalComments = productCount.toString
    //                                self.getCommentListFromServer(showLoader: true)
    //                                ProductHelper<UIViewController>.updateProductData(product: self.product!, controller: self, refreshCnt: [StoreListVC.self, ProductSearchVC.self])
    //                                self.isEditBtnCLK = false
    //                            }
    //
    //                        }
    //                        self.genericTextViewDidChange(self.txtViewComment, height: 10)
    //                    }
    //
    //
    //                    self.editCommentId =  nil
    //                    //                    self.tblProduct.scrollToRow(at: IndexPath(row: 0, section: 1), at: .top, animated: false)
    //                    //self.lblNoData.isHidden = self.arrCommentList.count != 0
    //                }
    //            }
    //        }
    //    }
    
    
    
    @objc fileprivate func btnMenuClicked(_ sender : UIBarButtonItem) {
        
        // if Int64(shoutInformation.valueForString(key: CUserId)) == appDelegate.loginUser?.user_id{
        if shoutInformation.valueForString(key: "user_email") == appDelegate.loginUser?.email{
//            self.presentActionsheetWithTwoButtons(actionSheetTitle: nil, actionSheetMessage: nil, btnOneTitle: CBtnEdit, btnOneStyle: .default, btnOneTapped: { [weak self] (alert) in
//                guard let self = self else { return }
//                if let shoID = self.shoutID{
//                    if let createShoutsVC = CStoryboardHome.instantiateViewController(withIdentifier: "CreateShoutsViewController") as? CreateShoutsViewController{
//                        createShoutsVC.setBlock(block: { (objetInfo, message) in
//                            if let shoutInfo = objetInfo as? [String : Any]{
//                                //                                self.setShoutsDetailData(shoutInfo)
//                            }
//                        })
//                        createShoutsVC.shoutsType = .editShouts
//                        createShoutsVC.shoutID = shoID
//                        self.navigationController?.pushViewController(createShoutsVC, animated: true)
//                    }
//                }
//
//            }, btnTwoTitle: CBtnDelete, btnTwoStyle: .default) { [weak self] (alert) in
//                guard let self = self else { return }
//                self.deleteShoutPost(self.shoutInformation)
//            }
            self.presentActionsheetWithOneButton(actionSheetTitle: nil, actionSheetMessage: nil, btnOneTitle: CBtnDelete, btnOneStyle: .default) { [weak self] (_) in
                guard let _ = self else {return}
                DispatchQueue.main.async {
                    self?.deleteShoutPost(self?.shoutInformation)
    
                }
            }
            
            
        }else{
            if let reportVC = CStoryboardGeneral.instantiateViewController(withIdentifier: "ReportViewController") as? ReportViewController {
                reportVC.reportType = .reportShout
                reportVC.userID = shoutInformation.valueForInt(key: CUserId)
                reportVC.reportID = self.shoutID
                reportVC.reportIDNEW = shoutInformation.valueForString(key: "email")
                self.navigationController?.pushViewController(reportVC, animated: true)
            }
        }
    }
    
    @IBAction func btnLikeCLK(_ sender : UIButton){
        //        if sender.tag == 0{
        //            // LIKE CLK
        //            btnLike.isSelected = !btnLike.isSelected
        //            likeCount = btnLike.isSelected ? likeCount + 1 : likeCount - 1
        //
        //            btnLikeCount.setTitle(appDelegate.getLikeString(like: likeCount), for: .normal)
        //            MIGeneralsAPI.shared().likeUnlikePostWebsite(post_id: self.shoutID, rss_id: nil, type: 1, likeStatus: btnLike.isSelected ? 1 : 0, viewController: self)
        //        }else{
        //            // LIKE COUNT CLK
        //            if let likeVC = CStoryboardGeneral.instantiateViewController(withIdentifier: "LikeViewController") as? LikeViewController{
        //                likeVC.postID = self.shoutID
        //                self.navigationController?.pushViewController(likeVC, animated: true)
        //            }
        //
        //        }
        
        
        //        self.btnLike.isSelected = !self.btnLike.isSelected
        //        if self.btnLike.isSelected == true{
        //            likeCount = 1
        //        }else {
        //            likeCount = 2
        //        }
        //        guard let userID = appDelegate.loginUser?.user_id else {
        //            return
        //        }
        //        APIRequest.shared().likeUnlikeProducts(userId: Int(userID), productId:(self.shoutIDNew)?.toInt ?? 0 , isLike: likeCount){ [weak self](response, error) in
        //            guard let _ = self else { return }
        //            if response != nil {
        //                GCDMainThread.async {
        //                    let data = response![CJsonMeta] as? [String:Any] ?? [:]
        //                    let stausLike = data["status"] as? String ?? "0"
        //                    if stausLike == "0"{
        //                        self?.likeCountfromSever(shoutId:self?.shoutIDNew ?? "0")
        //                    }
        //                }
        //            }
        //        }
        
        
        self.btnLike.isSelected = !self.btnLike.isSelected
        
        if self.btnLike.isSelected == true{
            likeCount = 1
            like = 1
            notifcationIsSlected = true
        }else {
            likeCount = 2
            like = 0
            
        }
        guard let userID = appDelegate.loginUser?.user_id else {
            return
        }
        APIRequest.shared().likeUnlikeProducts(userId: Int(userID), productId: (self.shoutIDNew)?.toInt ?? 0 , isLike: likeCount){ [weak self](response, error) in
            guard let _ = self else { return }
            if response != nil {
                GCDMainThread.async {
                    
                    let infodatass = response![CJsonData] as? [[String:Any]] ?? [[:]]
                    for infora in infodatass{
                        self?.info = infora
                    }
                    let data = response![CJsonMeta] as? [String:Any] ?? [:]
                    let stausLike = data["status"] as? String ?? "0"
                    if stausLike == "0"{
                        self?.likeCountfromSever(productId: self?.shoutIDNew?.toInt ?? 0,likeCount:self?.likeCount ?? 0, postInfo: self?.info ?? [:],like:self?.like ?? 0)
                    }
                }
            }
        }
    }
    
    //    func likeCountfromSever(shoutId: String){
    //
    //        let ShoutID = shoutId.toInt ?? 0
    //        APIRequest.shared().likeUnlikeProductCount(productId:ShoutID){ [weak self](response, error) in
    //            guard let _ = self else { return }
    //            if response != nil {
    //                GCDMainThread.async { [self] in
    //                    self?.likeTotalCount = response?["likes_count"] as? Int ?? 0
    //                    self?.btnLikeCount.setTitle(appDelegate.getLikeString(like: self?.likeTotalCount ?? 0), for: .normal)
    ////                    MIGeneralsAPI.shared().likeUnlikePostWebsite(post_id: self?.shoutIDNew?.toInt, rss_id: 0, type: 1, likeStatus: (self?.btnLike.isSelected)! ? 1 : 0, viewController: self)
    //
    //                }
    //            }
    //        }
    
    //    }
    func likeCountfromSever(productId: Int,likeCount:Int,postInfo:[String:Any],like:Int){
        APIRequest.shared().likeUnlikeProductCount(productId: self.shoutIDNew?.toInt ?? 0 ){ [weak self](response, error) in
            guard let _ = self else { return }
            if response != nil {
                GCDMainThread.async { [self] in
                    //                    info = response!["liked_users"] as? [String:Any] ?? [:]
                    self?.likeTotalCount = response?["likes_count"] as? Int ?? 0
                    self?.btnLikeCount.setTitle(appDelegate.getLikeString(like: self?.likeTotalCount ?? 0), for: .normal)
                    if self?.notifcationIsSlected == true{
                        guard let user_ID = appDelegate.loginUser?.user_id.description else { return }
                        guard let firstName = appDelegate.loginUser?.first_name else {return}
                        guard let lassName = appDelegate.loginUser?.last_name else {return}
                        MIGeneralsAPI.shared().sendNotification(self?.posted_ID, userID: user_ID, subject: "liked your Post", MsgType: "COMMENT", MsgSent: "", showDisplayContent: "liked your Post", senderName: firstName + lassName)
                        self?.notifcationIsSlected = false
                    }
                    MIGeneralsAPI.shared().likeUnlikePostWebsites(post_id: self?.shoutIDNew?.toInt ?? 0, rss_id: 0, type: 1, likeStatus: self?.like ?? 0 ,info:postInfo, viewController: self)
                }
                
            }
            
        }
    }
    
    @IBAction func btnShareReportCLK(_ sender : UIButton){
        //self.presentActivityViewController(mediaData: shoutInformation.valueForString(key: CShare_url), contentTitle: CSharePostContentMsg)
        let sharePost = SharePostHelper(controller: self, dataSet: shoutInformation)
        sharePost.shareURL = shoutInformation.valueForString(key: CShare_url)
        sharePost.presentShareActivity()
    }
    
    func btnMoreOptionOfComment(index:Int){
        
        self.presentActionsheetWithOneButton(actionSheetTitle: nil, actionSheetMessage: nil, btnOneTitle: CBtnDelete, btnOneStyle: .default) { [weak self] (_) in
            guard let _ = self else {return}
            DispatchQueue.main.async {
                self?.deleteComment(index)
//                self?.deleteComment(index)
            }
        }
        
        
        
//        self.presentActionsheetWithTwoButtons(actionSheetTitle: nil, actionSheetMessage: nil, btnOneTitle: CBtnEdit, btnOneStyle: .default, btnOneTapped: {[weak self] (_) in
//
//            guard let self = self else {return}
//            let commentInfo = self.arrCommentList[index]
//            var commentText = commentInfo.valueForString(key: "comment")
//            DispatchQueue.main.async {
//                self.viewUserSuggestion.resetData()
//                //                self.editCommentId = commentInfo.valueForInt(key: CId)
//                //                self.editCommentId = commentInfo.valueForString(key: )
//                if let arrIncludedUsers = commentInfo[CIncludeUserId] as? [[String : Any]] {
//                    for userInfo in arrIncludedUsers {
//                        let userName = userInfo.valueForString(key: CFirstname) + " " + userInfo.valueForString(key: CLastname)
//                        commentText = commentText.replacingOccurrences(of: String(NSString(format: kMentionFriendStringFormate as NSString, userInfo.valueForString(key: CUserId))), with: userName)
//                        self.viewUserSuggestion.addSelectedUser(user: userInfo)
//                    }
//                }
//                self.txtViewComment.text = commentText
//                self.viewUserSuggestion.setAttributeStringInTextView(self.txtViewComment)
//                self.txtViewComment.updatePlaceholderFrame(true)
//                let constraintRect = CGSize(width: self.txtViewComment.frame.size.width, height: .greatestFiniteMagnitude)
//                let boundingBox = self.txtViewComment.text.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: self.txtViewComment.font!], context: nil)
//                self.genericTextViewDidChange(self.txtViewComment, height: ceil(boundingBox.height))
//            }
//
//        }, btnTwoTitle: CBtnDelete, btnTwoStyle: .default) { [weak self](_) in
//            guard let _ = self else {return}
//            DispatchQueue.main.async {
//                self?.deleteComment(index)
//            }
//        }
        
        
        
        
    }
    
    //    func deleteComment(_ index:Int){
    //        let commentInfo = self.arrCommentList[index]
    //        let commentId = commentInfo.valueForInt(key: CId) ?? 0
    //        APIRequest.shared().deleteComment(commentId: commentId) { [weak self] (response, error) in
    //            guard let self = self else { return }
    //            if response != nil && error == nil {
    //                DispatchQueue.main.async {
    //                    self.commentCount -= 1
    //                    self.btnComment.setTitle(appDelegate.getCommentCountString(comment: self.commentCount), for: .normal)
    //                    self.arrCommentList.remove(at: index)
    //                    self.tblCommentList.reloadData()
    //                    MIGeneralsAPI.shared().refreshPostRelatedScreens(nil, self.shoutID, self, .deleteComment)
    //                }
    //            }
    //        }
    //    }
    
    
    func deleteComment(_ index:Int){
        
        let commentInfo = self.arrCommentList[index]
        let commentId = commentInfo.valueForString(key: "updated_at")
        let strComment = commentInfo.valueForString(key: "comment")
        
        guard let userID = appDelegate.loginUser?.user_id else{
            return
        }
        let userId = userID.description
        
        APIRequest.shared().deleteProductCommentNew(productId:shoutIDNew ?? "", commentId : commentId, comment: strComment, include_user_id: userId)  { [weak self] (response, error) in
            guard let self = self else { return }
            if response != nil && error == nil {
                DispatchQueue.main.async {
                    self.arrCommentList.remove(at: index)
                    //                    var productCount = self.product?.totalComments.toInt ?? 0
                    //                    productCount -= 1
                    //                    self.product?.totalComments = productCount.toString
                    //                    //                    self.product?.totalComment -= 1
                    //                    self.tblProduct.reloadData()
                    //                    ProductHelper<UIViewController>.updateProductData(product: self.product!, controller: self, refreshCnt: [StoreListVC.self, ProductSearchVC.self])
                    self.commentCount -= 1
                    if self.commentCount >= 0{
                        self.btnComment.setTitle(appDelegate.getCommentCountString(comment: self.commentCount), for: .normal)
                    }else {
                        return
                    }
                    //                    self.arrCommentList.remove(at: index)
                    self.tblCommentList.reloadData()
                    MIGeneralsAPI.shared().refreshPostRelatedScreens(nil,self.shoutIDNew?.toInt ?? 0 , self, .deleteComment)
                    
                    
                }
            }
        }
    }
    
    
}

