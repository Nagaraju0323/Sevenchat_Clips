//
//  PostDeleteDetailViewController.swift
//  Sevenchats
//
//  Created by mac-00020 on 25/09/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//

import Foundation
import UIKit
import ActiveLabel

class PostDeleteDetailViewController: ParentViewController {
    
    @IBOutlet weak var viewCommentContainer : UIView!
    @IBOutlet weak var tblCommentList : UITableView! {
        didSet {
            
            tblCommentList.register(UINib(nibName: "CommentTblCell", bundle: nil), forCellReuseIdentifier: "CommentTblCell")
            tblCommentList.estimatedRowHeight = 100;
            
            tblCommentList.register(UINib(nibName: "PostDeletedDetailCell", bundle: nil), forCellReuseIdentifier: "PostDeletedDetailCell")
            tblCommentList.sectionHeaderHeight = UITableView.automaticDimension;
            tblCommentList.estimatedSectionHeaderHeight = 200;

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
            txtViewComment.type = "1"
        }
    }
    
    // Set for User suggestion view...
    @IBOutlet fileprivate weak var viewUserSuggestion : UserSuggestionView! {
        didSet {
            viewUserSuggestion.userSuggestionDelegate = self
            viewUserSuggestion.initialization()
        }
    }
    @IBOutlet weak var cnTextViewHeight : NSLayoutConstraint!
    
    var postID : Int?
    var arrCommentList = [[String:Any]]()
    var postInformation = [String:Any]()
    var apiTask : URLSessionTask?
    var pageNumber = 1
    var refreshControl = UIRefreshControl()
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
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //self.tblCommentList.updateHeaderViewHeight()
    }
    
    // MARK:- --------- Initialization
    func Initialization(){
        
        self.title = CNavShoutDetails
        self.view.backgroundColor = CRGB(r: 249, g: 250, b: 250)
        self.parentView.backgroundColor = .clear
        self.tblCommentList.backgroundColor = .clear
        
        GCDMainThread.async {
            self.viewCommentContainer.shadow(color: ColorAppTheme, shadowOffset: CGSize(width: 0, height: 5), shadowRadius: 10.0, shadowOpacity: 10.0)
        }
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: #imageLiteral(resourceName: "ic_btn_nav_more"), style: .plain, target: self, action: #selector(self.btnMenuClicked(_:)))]
        
        self.refreshControl.addTarget(self, action: #selector(self.pullToRefresh), for: .valueChanged)
        self.refreshControl.tintColor = ColorAppTheme
        self.tblCommentList.pullToRefreshControl = self.refreshControl
        self.pageNumber = 1
        
        self.getPostDetailsFromServer()
    }
    
    func updateUIAccordingToLanguage(){
        txtViewComment.placeHolder = CMessageTypeYourMessage
    }
}

// MARK:- --------- Api Functions
extension PostDeleteDetailViewController{
    
    @objc func pullToRefresh() {
        if apiTask?.state == URLSessionTask.State.running {
            apiTask?.cancel()
        }
        
        self.pageNumber = 1
        refreshControl.beginRefreshing()
        self.getPostDetailsFromServer()
    }
    
    fileprivate func getPostDetailsFromServer() {
           
           self.parentView.isHidden = true
           if let shouID = self.postID {
               
               APIRequest.shared().viewPostDetailNew(postID: shouID, apiKeyCall: CAPITagchirpiesDetials){ [weak self] (response, error) in
                   guard let self = self else { return }
                   if response != nil {
                       self.parentView.isHidden = false
                       if let Info = response!["data"] as? [[String:Any]]{
                       
                       print(Info as Any)
                           for shoInfo in Info {
                           DispatchQueue.main.async {
                               self.setPostDetailData(shoInfo)
                           }
                           }
                       }
                   }
                   self.getCommentListFromServer()
               }
           }
       }
    
//    fileprivate func getPostDetailsFromServer() {
//
//        self.parentView.isHidden = true
//        if let shouID = self.postID {
//            APIRequest.shared().viewPostDetail(postID: shouID) { [weak self] (response, error) in
//                guard let self = self else { return }
//                if response != nil {
//                    self.parentView.isHidden = false
//                    if let shoInfo = response![CJsonData] as? [String : Any]{
//                        DispatchQueue.main.async {
//                            self.setPostDetailData(shoInfo)
//                        }
//
//                    }
//                }
//                self.getCommentListFromServer()
//            }
//        }
//    }
//
    func setPostDetailData(_ shoutInfo : [String : Any]?){
        if let shoInfo = shoutInfo{
            postInformation = shoInfo
            likeCount = shoInfo.valueForInt(key: CTotal_like) ?? 0
            self.commentCount = shoInfo.valueForInt(key: CTotalComment) ?? 0
            self.tblCommentList.reloadData()
        }
    }
    fileprivate func deleteShoutPost(_ shoutInfo : [String : Any]?){
           
        if let shoID = self.postID{
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
//        if let shoID = self.postID{
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
        if let shoID = self.postID{
            if apiTask?.state == URLSessionTask.State.running {
                self.refreshControl.endRefreshing()
                return
            }
            
            // Add load more indicator here...
            self.tblCommentList.tableFooterView = self.pageNumber > 2 ? self.loadMoreIndicator(ColorAppTheme) : UIView()
            
//            apiTask  = APIRequest.shared().getCommentList(page: pageNumber, showLoader: false, post_id: shoID, rss_id: nil) { [weak self] (response, error) in
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
    
    func updateShoutCommentSection(_ arrComm : [[String : Any]], _ totalComment : Int){
        
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
extension PostDeleteDetailViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if arrCommentList.isEmpty{
            return 1
        }
        return 2
        //return arrCommentList.count > 0 ? 1 : 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0{
            return nil
        }
        if let header = EventCommentTblHeader.viewFromXib as? EventCommentTblHeader{
            header.backgroundColor =  CRGB(r: 249, g: 250, b: 250)
            header.lblTitle.text = appDelegate.getCommentCountString(comment: commentCount)
            return header
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 0.0
        }
        return 40
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }
        return arrCommentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            if let cell = tableView.dequeueReusableCell(withIdentifier: "PostDeletedDetailCell", for: indexPath) as? PostDeletedDetailCell {
                cell.postDataSetup(postInformation)
                cell.btnComment.setTitle(appDelegate.getCommentCountString(comment: commentCount), for: .normal)
                cell.btnLikesCount.touchUpInside { [weak self] (sender) in
                    guard let _ = self else { return }
                    if let likeVC = CStoryboardGeneral.instantiateViewController(withIdentifier: "LikeViewController") as? LikeViewController{
                        likeVC.postID = self?.postID
                        self?.navigationController?.pushViewController(likeVC, animated: true)
                    }
                }
               
                cell.btnSharedProfileImg.touchUpInside { [weak self] (sender) in
                    guard let _ = self else { return }
                    if let userID = (self?.postInformation[CSharedPost] as? [String:Any] ?? [:])[CUserId] as? Int {
                        appDelegate.moveOnProfileScreen(userID.description, self)
                        
                        
                    }
                }
                
                cell.btnSharedUserName.touchUpInside { [weak self] (sender) in
                    guard let _ = self else { return }
                    if let userID = (self?.postInformation[CSharedPost] as? [String:Any] ?? [:])[CUserId] as? Int {
                        appDelegate.moveOnProfileScreen(userID.description, self)
                    }
                }
                return cell
            }
            return UITableViewCell(frame: .zero)
        }
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
                
                label.configureLinkAttribute = { [weak self](type, attributes, isSelected) in
                    guard let _ = self else { return attributes }
                    var atts = attributes
                    atts[NSAttributedString.Key.font] = CFontPoppins(size: cell.lblCommentText.font.pointSize, type: .meduim)
                    return atts
                }
            }
            
            cell.btnUserName.touchUpInside {[weak self] (sender) in
                guard let self = self else { return }
                appDelegate.moveOnProfileScreen(commentInfo.valueForString(key: CUserId), self)
            }
            
            cell.btnUserImage.touchUpInside {[weak self] (sender) in
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
extension PostDeleteDetailViewController: GenericTextViewDelegate{
    
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
extension PostDeleteDetailViewController: UserSuggestionDelegate{
    func didSelectSuggestedUser(_ userInfo: [String : Any]) {
        viewUserSuggestion.arrangeFinalComment(userInfo, textView: txtViewComment)
    }
}

// MARK:-  --------- Action Event
extension PostDeleteDetailViewController{
    @IBAction func btnSendCommentCLK(_ sender : UIButton){
        self.resignKeyboard()
        
        if (txtViewComment.text?.isBlank)!{
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageCommentBlank, btnOneTitle: CBtnOk, btnOneTapped: nil)
        }else{
            if let shoId = self.postID{
                // Get Final text for comment..
                let strComment = viewUserSuggestion.stringToBeSendInComment(txtViewComment)
                
                // Get Mention user's Ids..
                let includedUser = viewUserSuggestion.arrSelectedUser.map({$0.valueForString(key: CUserId) }).joined(separator: ",")
                
//                APIRequest.shared().sendComment(post_id: shoId, commentId: self.editCommentId, rss_id: nil, type: 1, comment: strComment, include_user_id: includedUser) { [weak self] (response, error) in
//                    guard let self = self else { return }
//                    if response != nil && error == nil{
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
//                                self.tblCommentList.reloadData()
//                                if let responsInfo = response as? [String : Any]{
//                                    // To udpate previous screen data....
//                                    MIGeneralsAPI.shared().refreshPostRelatedScreens(responsInfo, self.postID, self, .commentPost)
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
        
        let userID = (postInformation[CSharedPost] as? [String:Any] ?? [:])[CUserId] as? Int64 ?? 0
        if userID == appDelegate.loginUser?.user_id{
            self.presentActionsheetWithTwoButtons(actionSheetTitle: nil, actionSheetMessage: nil, btnOneTitle: CBtnEdit, btnOneStyle: .default, btnOneTapped: { [weak self] (alert) in
                guard let self = self else { return }
                if let sharePost = CStoryboardSharedPost.instantiateViewController(withIdentifier: "SharePostViewController") as? SharePostViewController{
                    sharePost.postData = self.postInformation
                    sharePost.isFromEdit = true
                    self.navigationController?.pushViewController(sharePost, animated: true)
                }
                
            }, btnTwoTitle: CBtnDelete, btnTwoStyle: .default) { [weak self] (alert) in
                guard let self = self else { return }
                self.deleteShoutPost(self.postInformation)
            }
        }else{
            let sharePostData = postInformation[CSharedPost] as? [String:Any] ?? [:]
            if let reportVC = CStoryboardGeneral.instantiateViewController(withIdentifier: "ReportViewController") as? ReportViewController {
                switch postInformation.valueForInt(key: CPostType) {
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
                self.navigationController?.pushViewController(reportVC, animated: true)
            }
        }
    }
    
    @IBAction func btnLikeCLK(_ sender : UIButton){
        if sender.tag == 0{
            // LIKE CLK
            //btnLike.isSelected = !btnLike.isSelected
            //likeCount = btnLike.isSelected ? likeCount + 1 : likeCount - 1
            
            //btnLikeCount.setTitle(appDelegate.getLikeString(like: likeCount), for: .normal)
            //MIGeneralsAPI.shared().likeUnlikePostWebsite(post_id: self.postID, rss_id: nil, type: 1, likeStatus: btnLike.isSelected ? 1 : 0, viewController: self)
        }else{
            // LIKE COUNT CLK
            if let likeVC = CStoryboardGeneral.instantiateViewController(withIdentifier: "LikeViewController") as? LikeViewController{
                likeVC.postID = self.postID
                self.navigationController?.pushViewController(likeVC, animated: true)
            }
            
        }
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
//                    self.arrCommentList.remove(at: index)
//                    self.tblCommentList.reloadData()
//                    MIGeneralsAPI.shared().refreshPostRelatedScreens(nil, self.postID, self, .deleteComment)
//                }
//            }
//        }
    }
}

