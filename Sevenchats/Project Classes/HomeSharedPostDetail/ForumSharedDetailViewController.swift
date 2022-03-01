//
//  ForumSharedDetailViewController.swift
//  Sevenchats
//
//  Created by mac-0005 on 21/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//
/*********************************************************
 * Author  : Chandrika.R                                 *
 * Model   : ForumSharedDetailViewController             *
 * Changes :                                             *
 *                                                       *
 ********************************************************/

import UIKit
import ActiveLabel

class ForumSharedDetailViewController: ParentViewController {
    
    @IBOutlet weak var viewCommentContainer : UIView!
    @IBOutlet weak var lblForumType : UILabel!
    @IBOutlet weak var lblForumTitle : UILabel!
    @IBOutlet weak var lblForumDescription : UILabel!
    @IBOutlet weak var lblForumPostDate : UILabel!
    @IBOutlet weak var lblForumCategory : UILabel!
    @IBOutlet weak var lblUserName : UILabel!
    @IBOutlet weak var imgUser : UIImageView!
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
    @IBOutlet weak var btnLike : UIButton!
    @IBOutlet weak var btnLikeCount : UIButton!
    @IBOutlet weak var btnComment : UIButton!
    @IBOutlet weak var btnShare : UIButton!
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
    
    @IBOutlet weak var lblSharedPostDate : UILabel!
    @IBOutlet weak var imgSharedUser : UIImageView!
    @IBOutlet weak var lblSharedUserName : UILabel!
    @IBOutlet weak var btnSharedProfileImg : UIButton!
    @IBOutlet weak var btnSharedUserName : UIButton!
    @IBOutlet weak var lblMessage : UILabel!
    @IBOutlet weak var lblSharedPostType : UILabel!
    
    @IBOutlet weak var btnProfileImg : UIButton!
    @IBOutlet weak var btnUserName : UIButton!

    var refreshControl = UIRefreshControl()
    var forumID : Int?
    var arrCommentList = [[String:Any]]()
    var forumInformation = [String:Any]()
    var apiTask : URLSessionTask?
    var pageNumber = 1
    var likeCount = 0
    var commentCount = 0
    var editCommentId : Int? = nil
    
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
        self.setForumDetailData(forumInformation)
        self.openUserProfileScreen()
    }
    
    // MARK:- --------- Initialization
    func Initialization(){
        
        self.title = CNavForumDetails
        self.view.backgroundColor = CRGB(r: 249, g: 250, b: 250)
        lblSharedPostType.text = CSharedForum
        self.parentView.backgroundColor = .clear
        self.tblCommentList.backgroundColor = .clear
        self.btnShare.setTitle(CBtnShare, for: .normal)
        self.lblForumType.text = CTypeForum
        
        GCDMainThread.async {
            self.imgUser.layer.cornerRadius = self.imgUser.CViewWidth/2
            self.imgSharedUser.layer.cornerRadius = self.imgSharedUser.frame.size.width / 2
            self.imgSharedUser.layer.borderWidth = 2
            self.imgSharedUser.layer.borderColor = #colorLiteral(red: 0, green: 0.7881455421, blue: 0.7100172639, alpha: 1)
            self.imgUser.layer.borderWidth = 2
            self.imgUser.layer.borderColor = #colorLiteral(red: 0, green: 0.7881455421, blue: 0.7100172639, alpha: 1)

            self.viewCommentContainer.shadow(color: ColorAppTheme, shadowOffset: CGSize(width: 0, height: 5), shadowRadius: 10.0, shadowOpacity: 10.0)
            self.lblForumType.layer.cornerRadius = 3
        }
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: #imageLiteral(resourceName: "ic_btn_nav_more"), style: .plain, target: self, action: #selector(self.btnMenuClicked(_:)))]
        
        
        self.refreshControl.addTarget(self, action: #selector(self.pullToRefresh), for: .valueChanged)
        self.refreshControl.tintColor = ColorAppTheme
        self.tblCommentList.pullToRefreshControl = self.refreshControl
        self.pageNumber = 1
        
        self.getForumDetailsFromServer()
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
extension ForumSharedDetailViewController{
    
    @objc func pullToRefresh() {
        if apiTask?.state == URLSessionTask.State.running {
            apiTask?.cancel()
        }
        
        self.pageNumber = 1
        refreshControl.beginRefreshing()
        self.getForumDetailsFromServer()
    }
    
    fileprivate func getForumDetailsFromServer() {
//        self.parentView.isHidden = true
//        if let forID = self.forumID {
//            APIRequest.shared().viewPostDetail(postID: forID) { [weak self] (response, error) in
//                guard let self = self else { return }
//                if response != nil {
//                    self.parentView.isHidden = false
//                    if let forInfo = response![CJsonData] as? [String : Any]{
//                        self.setForumDetailData(forInfo)
//                        self.openUserProfileScreen()
//                    }
//                }
//                self.getCommentListFromServer()
//            }
//        }
    }
    
    fileprivate func openUserProfileScreen(){
        
        self.btnSharedProfileImg.touchUpInside { [weak self] (sender) in
            guard let self = self else { return }
            appDelegate.moveOnProfileScreenNew(self.forumInformation.valueForString(key: CSharedUserID), self.forumInformation.valueForString(key: CSharedEmailID), self)
        }
        
        self.btnSharedUserName.touchUpInside { [weak self] (sender) in
            guard let self = self else { return }
            appDelegate.moveOnProfileScreenNew(self.forumInformation.valueForString(key: CSharedUserID), self.forumInformation.valueForString(key: CSharedEmailID), self)
        }
        
        self.btnProfileImg.touchUpInside { [weak self] (sender) in
            guard let self = self else { return }
            appDelegate.moveOnProfileScreenNew(self.forumInformation.valueForString(key: CUserId), self.forumInformation.valueForString(key: CUsermailID), self)
        }
        
        self.btnUserName.touchUpInside { [weak self] (sender) in
            guard let self = self else { return }
            appDelegate.moveOnProfileScreenNew(self.forumInformation.valueForString(key: CUserId), self.forumInformation.valueForString(key: CUsermailID), self)
        }
    }
    
    func setForumDetailData(_ forumInfo : [String : Any]?){
        if let forInfo = forumInfo{
            forumInformation = forInfo
            //if let sharedData = forInfo[CSharedPost] as? [String:Any]{
                self.lblSharedUserName.text = forInfo.valueForString(key: CFullName) + " " + forInfo.valueForString(key: CFullName)
                //self.lblSharedPostDate.text = DateFormatter.dateStringFrom(timestamp: forInfo.valueForDouble(key: CCreated_at), withFormate: CreatedAtPostDF)
            let shared_created_at = forInfo.valueForString(key: CShared_Created_at)
                       let shared_cnv_date = shared_created_at.stringBefore("G")
                       let sharedCreated = DateFormatter.shared().convertDatereversLatest(strDate: shared_cnv_date)
                       lblSharedPostDate.text = sharedCreated
                imgSharedUser.loadImageFromUrl(forInfo.valueForString(key: CUserSharedProfileImage), true)
                lblMessage.text = forInfo.valueForString(key: CMessage)
            //}
            self.lblUserName.text = forInfo.valueForString(key: CFirstname) + " " + forInfo.valueForString(key: CLastname)
            //self.lblForumPostDate.text = DateFormatter.dateStringFrom(timestamp: forInfo.valueForDouble(key: CCreated_at), withFormate: CreatedAtPostDF)
            let created_At = forInfo.valueForString(key: CCreated_at)
                        let cnvStr = created_At.stringBefore("G")
                        let startCreated = DateFormatter.shared().convertDatereversLatest(strDate: cnvStr)
            lblForumPostDate.text = startCreated
            self.lblForumDescription.text = forInfo.valueForString(key: CContent)
            self.imgUser.loadImageFromUrl(forInfo.valueForString(key: CUserProfileImage), true)
            self.lblForumTitle.text = forInfo.valueForString(key: CTitle)
            self.lblForumCategory.text = forInfo.valueForString(key: CCategory).uppercased()
            self.btnLike.isSelected = forInfo.valueForInt(key: CIs_Like) == 1
            
            likeCount = forInfo.valueForInt(key: CTotal_like) ?? 0
            self.commentCount = forInfo.valueForInt(key: CTotalComment) ?? 0
            btnComment.setTitle(appDelegate.getCommentCountString(comment: commentCount), for: .normal)
            
            self.btnLikeCount.setTitle(appDelegate.getLikeString(like: likeCount), for: .normal)
            self.tblCommentList.updateHeaderViewHeight()
        }
    }
    
    fileprivate func deleteForumPost(){
        
        if let forID = self.forumID{
            
//            self.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: CMessageDeletePost, btnOneTitle: CBtnYes, btnOneTapped: { [weak self] (alert) in
//                guard let self = self else { return }
//                APIRequest.shared().deletePost(postID: forID, completion: { [weak self] (response, error) in
//                    guard let self = self else { return }
//                    if response != nil && error == nil{
//                        self.navigationController?.popViewController(animated: true)
//                        MIGeneralsAPI.shared().refreshPostRelatedScreens(nil, forID, self, .deletePost)
//                    }
//                })
//                }, btnTwoTitle: CBtnNo, btnTwoTapped: nil)
        }
    }
    
    fileprivate func getCommentListFromServer(){
        if let forID = self.forumID{
            
            if apiTask?.state == URLSessionTask.State.running {
                self.refreshControl.endRefreshing()
                return
            }
            
            // Add load more indicator here...
            self.tblCommentList.tableFooterView = self.pageNumber > 2 ? self.loadMoreIndicator(ColorAppTheme) : UIView()
            
//            apiTask  = APIRequest.shared().getCommentList(page: pageNumber, showLoader: false, post_id: forID, rss_id: nil) { [weak self] (response, error) in
//                guard let self = self else { return }
//                self.tblCommentList.tableFooterView = UIView()
//                self.apiTask?.cancel()
//                self.refreshControl.endRefreshing()
//                if response != nil {
//
//                    if let arrList = response![CJsonData] as? [[String:Any]] {
//
//                        // Remove all data here when page number == 1
//                        if self.pageNumber == 1 {
//                            self.arrCommentList.removeAll()
//                            self.tblCommentList.reloadData()
//                        }
//
//                        // Add Data here...
//                        if arrList.count > 0{
//                            self.arrCommentList = self.arrCommentList + arrList
//                            self.tblCommentList.reloadData()
//                            self.pageNumber += 1
//                        }
//                    }
//
//                    print("arrCommentListCount : \(self.arrCommentList.count)")
//                }
//            }
        }
    }
    
    func updateForumCommentSection(_ arrComm : [[String : Any]], _ totalComment : Int){
        //self.btnComment.setTitle("\(totalComment)", for: .normal)
        /*self.arrCommentList.removeAll()
         
         if totalComment > 2{
         // Add last two comment here...
         self.arrCommentList.append(arrComm.first!)
         self.arrCommentList.append(arrComm[1])
         
         }else{
         self.arrCommentList = arrComm
         }
         self.tblCommentList.reloadData()*/
    }
}

// MARK:- --------- UITableView Datasources/Delegate
extension ForumSharedDetailViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrCommentList.count > 0 ? 1 : 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let header = EventCommentTblHeader.viewFromXib as? EventCommentTblHeader{
            header.backgroundColor =  CRGB(r: 249, g: 250, b: 250)
            //header.lblTitle.text = "\(arrCommentList.count) " + CNavComments
            
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
            let commentInfo = arrCommentList[indexPath.row]
            cell.lblCommentPostDate.text = DateFormatter.shared().durationString(duration: commentInfo.valueForString(key: CCreated_at))
            
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
            
            if let arrIncludedUsers = commentInfo[CIncludeUserId] as? [[String : Any]] {
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
                            appDelegate.moveOnProfileScreen(userSelectedInfo.valueForString(key: CUserId), self)
                        }
                    })
                    
                    commentText = commentText.replacingOccurrences(of: String(NSString(format: kMentionFriendStringFormate as NSString, userInfo.valueForString(key: CUserId))), with: userName)
                }
            }
            
            cell.lblCommentText.customize { [weak self] label in
                guard let self = self else { return }
                label.text = commentText
                label.minimumLineHeight = 0.0
                
                label.configureLinkAttribute = { [weak self] (type, attributes, isSelected) in
                    guard let _ = self else { return attributes}
                    var atts = attributes
                    atts[NSAttributedString.Key.font] = CFontPoppins(size: cell.lblCommentText.font.pointSize, type: .meduim)
                    return atts
                }
            }
            
            cell.btnUserName.touchUpInside { [weak self] (sender) in
                guard let self = self else { return }
                appDelegate.moveOnProfileScreen(commentInfo.valueForString(key: CUserId), self)
            }
            
            cell.btnUserImage.touchUpInside { [weak self] (sender) in
                guard let self = self else { return }
                appDelegate.moveOnProfileScreen(commentInfo.valueForString(key: CUserId), self)
            }
            
            // Load more data....
            if (indexPath == tblCommentList.lastIndexPath()) && apiTask?.state != URLSessionTask.State.running {
                self.getCommentListFromServer()
            }
            
            return cell
        }
        
        return tableView.tableViewDummyCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

// MARK:-  --------- Generic UITextView Delegate
extension ForumSharedDetailViewController: GenericTextViewDelegate{
    
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
extension ForumSharedDetailViewController: UserSuggestionDelegate{
    func didSelectSuggestedUser(_ userInfo: [String : Any]) {
        viewUserSuggestion.arrangeFinalComment(userInfo, textView: txtViewComment)
    }
}

// MARK:-  --------- Action Event
extension ForumSharedDetailViewController{
    @IBAction func btnSendCommentCLK(_ sender : UIButton){
        self.resignKeyboard()
        
        if (txtViewComment.text?.isBlank)!{
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageCommentBlank, btnOneTitle: CBtnOk, btnOneTapped: nil)
        }else{
            if let forId = self.forumID{
                
                // Get Final text for comment..
                let strComment = viewUserSuggestion.stringToBeSendInComment(txtViewComment)
                
                // Get Mention user's Ids..
                let includedUser = viewUserSuggestion.arrSelectedUser.map({$0.valueForString(key: CUserId) }).joined(separator: ",")
                
//                APIRequest.shared().sendComment(post_id: forId, commentId: self.editCommentId, rss_id: nil, type: 1, comment: strComment, include_user_id: includedUser) { [weak self] (response, error) in
//                    guard let self = self else { return }
//                    if response != nil && error == nil {
//                        
//                        self.viewUserSuggestion.hideSuggestionView(self.txtViewComment)
//                        self.txtViewComment.text = ""
//                        self.btnSend.isUserInteractionEnabled = false
//                        self.btnSend.alpha = 0.5
//                        self.txtViewComment.updatePlaceholderFrame(false)
//                        
//                        if let comment = response![CJsonData] as? [String : Any] {
//                            if (self.editCommentId ?? 0) == 0{
//                                self.arrCommentList.insert(comment, at: 0)
//                                self.commentCount += 1
//                                
//                                self.btnComment.setNormalTitle(normalTitle: appDelegate.getCommentCountString(comment: self.commentCount))
//                                
//                                self.tblCommentList.reloadData()
//                                if let responsInfo = response as? [String : Any]{
//                                    // To udpate previous screen data....
//                                    MIGeneralsAPI.shared().refreshPostRelatedScreens(responsInfo, forId, self, .commentPost)
//                                }
//                            }else{
//                                // Edit comment in array
//                                if let index = self.arrCommentList.index(where: { $0[CId] as? Int ==  (self.editCommentId ?? 0)}) {
//                                    self.arrCommentList.remove(at: index)
//                                    self.arrCommentList.insert(comment, at: 0)
//                                    self.tblCommentList.reloadData()
//                                }
//                            }
//                            self.genericTextViewDidChange(self.txtViewComment, height: 10)
//                        }
//                        self.editCommentId =  nil
//                        self.tblCommentList.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
//                        //self.lblNoData.isHidden = self.arrCommentList.count != 0
//                    }
//                }
            }
        }
    }
    
    @objc fileprivate func btnMenuClicked(_ sender : UIBarButtonItem) {
        
        let userID = (forumInformation[CSharedPost] as? [String:Any] ?? [:])[CUserId] as? Int64 ?? 0
        if userID == appDelegate.loginUser?.user_id{
            self.presentActionsheetWithTwoButtons(actionSheetTitle: nil, actionSheetMessage: nil, btnOneTitle: CBtnEdit, btnOneStyle: .default, btnOneTapped: { [weak self] (alert) in
                guard let self = self else { return }
                if let sharePost = CStoryboardSharedPost.instantiateViewController(withIdentifier: "SharePostViewController") as? SharePostViewController{
                    sharePost.postData = self.forumInformation
                    sharePost.isFromEdit = true
                    self.navigationController?.pushViewController(sharePost, animated: true)
                }
                
            }, btnTwoTitle: CBtnDelete, btnTwoStyle: .default) { [weak self] (alert) in
                guard let self = self else { return }
                self.deleteForumPost()
            }
        }else{
            let sharePostData = forumInformation[CSharedPost] as? [String:Any] ?? [:]
            if let reportVC = CStoryboardGeneral.instantiateViewController(withIdentifier: "ReportViewController") as? ReportViewController {
                reportVC.reportType = .reportForum
                reportVC.isSharedPost = true
                reportVC.userID = sharePostData.valueForInt(key: CUserId)
                reportVC.reportID = sharePostData.valueForInt(key: CId)
                self.navigationController?.pushViewController(reportVC, animated: true)
            }
        }
    }
    
    @IBAction func btnLikeCLK(_ sender : UIButton){
        
        if sender.tag == 0{
            // LIKE CLK
            btnLike.isSelected = !btnLike.isSelected
            
            likeCount = btnLike.isSelected ? likeCount + 1 : likeCount - 1
            btnLikeCount.setTitle(appDelegate.getLikeString(like: likeCount), for: .normal)
            
            MIGeneralsAPI.shared().likeUnlikePostWebsite(post_id: self.forumID, rss_id: nil, type: 1, likeStatus: btnLike.isSelected ? 1 : 0, viewController: self)
        }else{
            // LIKE COUNT CLK
            if let likeVC = CStoryboardGeneral.instantiateViewController(withIdentifier: "LikeViewController") as? LikeViewController{
                likeVC.postID = self.forumID
                self.navigationController?.pushViewController(likeVC, animated: true)
            }
        }
    }
    
    @IBAction func btnShareReportCLK(_ sender : UIButton){
        self.presentActivityViewController(mediaData: forumInformation.valueForString(key: CShare_url), contentTitle: CSharePostContentMsg)
    }
    
    func btnMoreOptionOfComment(index:Int){
        self.presentActionsheetWithTwoButtons(actionSheetTitle: nil, actionSheetMessage: nil, btnOneTitle: CBtnEdit, btnOneStyle: .default, btnOneTapped: {[weak self] (_) in
            
            guard let self = self else {return}
            let commentInfo = self.arrCommentList[index]
            var commentText = commentInfo.valueForString(key: "comment")
            DispatchQueue.main.async {
                self.viewUserSuggestion.resetData()
                self.editCommentId = commentInfo.valueForInt(key: CId)
                if let arrIncludedUsers = commentInfo[CIncludeUserId] as? [[String : Any]] {
                    for userInfo in arrIncludedUsers {
                        let userName = userInfo.valueForString(key: CFirstname) + " " + userInfo.valueForString(key: CLastname)
                        commentText = commentText.replacingOccurrences(of: String(NSString(format: kMentionFriendStringFormate as NSString, userInfo.valueForString(key: CUserId))), with: userName)
                        self.viewUserSuggestion.addSelectedUser(user: userInfo)
                    }
                }
                self.txtViewComment.text = commentText
                self.viewUserSuggestion.setAttributeStringInTextView(self.txtViewComment)
                self.txtViewComment.updatePlaceholderFrame(true)
                let constraintRect = CGSize(width: self.txtViewComment.frame.size.width, height: .greatestFiniteMagnitude)
                let boundingBox = self.txtViewComment.text.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: self.txtViewComment.font!], context: nil)
                self.genericTextViewDidChange(self.txtViewComment, height: ceil(boundingBox.height))
            }
            
        }, btnTwoTitle: CBtnDelete, btnTwoStyle: .default) { [weak self](_) in
            guard let _ = self else {return}
            DispatchQueue.main.async {
                self?.deleteComment(index)
            }
        }
    }
    
    func deleteComment(_ index:Int){
        let commentInfo = self.arrCommentList[index]
        let commentId = commentInfo.valueForInt(key: CId) ?? 0
//        APIRequest.shared().deleteComment(commentId: commentId) { [weak self] (response, error) in
//            guard let self = self else { return }
//            if response != nil && error == nil {
//                DispatchQueue.main.async {
//                    self.commentCount -= 1
//                    self.btnComment.setTitle(appDelegate.getCommentCountString(comment: self.commentCount), for: .normal)
//                    self.arrCommentList.remove(at: index)
//                    self.tblCommentList.reloadData()
//                    MIGeneralsAPI.shared().refreshPostRelatedScreens(nil, self.forumID, self, .deleteComment)
//                }
//            }
//        }
    }
}

