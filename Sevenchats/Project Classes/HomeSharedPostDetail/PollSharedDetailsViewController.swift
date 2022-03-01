//
//  PollSharedDetailsViewController.swift
//  Sevenchats
//
//  Created by mac-00020 on 06/06/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Chandrika.R                                 *
 * Model   : PollSharedDetailsViewController             *
 * Changes :                                             *
 *                                                       *
 ********************************************************/

import Foundation
import UIKit
import ActiveLabel

class PollSharedDetailsViewController: ParentViewController {
    
    @IBOutlet weak var lblPollTitle : UILabel!
    @IBOutlet weak var imgUser : UIImageView!
    @IBOutlet weak var lblUserName : UILabel!
    @IBOutlet weak var lblPollPostDate : UILabel!
    @IBOutlet weak var lblPollType : UILabel!
    @IBOutlet weak var lblPollCategory : UILabel!
    @IBOutlet weak var btnLikeCount : UIButton!
    @IBOutlet weak var btnLike : UIButton!
    @IBOutlet weak var btnComment : UIButton!
    @IBOutlet weak var btnShare : UIButton!
    @IBOutlet weak var btnProfileImg : UIButton!
    @IBOutlet weak var btnUserName : UIButton!
    @IBOutlet weak var lblVoteCount : UILabel!
    
    @IBOutlet weak var tblVAnswre: PollOptionTableView!
    
    @IBOutlet var tblCommentList : UITableView! {
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
    
    @IBOutlet fileprivate weak var viewCommentContainer : UIView!
    @IBOutlet fileprivate weak var btnSend : UIButton!
    @IBOutlet fileprivate weak var cnTextViewHeight : NSLayoutConstraint!
    @IBOutlet fileprivate weak var txtViewComment : GenericTextView!{
        didSet{
            txtViewComment.genericDelegate = self
            txtViewComment.PlaceHolderColor = ColorPlaceholder
        }
    }
    @IBOutlet fileprivate weak var viewUserSuggestion : UserSuggestionView! {
        didSet {
            viewUserSuggestion.initialization()
            viewUserSuggestion.userSuggestionDelegate = self
        }
    }
    
    @IBOutlet fileprivate weak var cnTblSuggestionHeight : NSLayoutConstraint! {
        didSet {
            cnTblSuggestionHeight.constant = 0
        }
    }
    
    @IBOutlet weak var lblSharedPostDate : UILabel!
    @IBOutlet weak var imgSharedUser : UIImageView!
    @IBOutlet weak var lblSharedUserName : UILabel!
    @IBOutlet weak var btnSharedProfileImg : UIButton!
    @IBOutlet weak var btnSharedUserName : UIButton!
    @IBOutlet weak var lblMessage : UILabel!
    @IBOutlet weak var lblSharedPostType : UILabel!
    
    var pollID : Int?
    var apiTask : URLSessionTask?
    var pageNumber = 1
    var refreshControl = UIRefreshControl()
    
    var arrCommentList = [[String:Any]]()
    var arrUserForMention = [[String:Any]]()
    var arrFilterUser = [[String:Any]]()
    var likeCount = 0
    var commentCount = 0
    var rssId : Int?
    var editCommentId : Int? = nil
    var pollInformation = [String : Any]()
    
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
        //self.tableView.updateHeaderViewHeight()
    }
    
    fileprivate func sizeToFitHeader(){
        DispatchQueue.main.async {
            self.tblCommentList.updateHeaderViewHeight()
            self.tblCommentList.updateHeaderViewHeight()
        }
    }
    
    // MARK:- --------- Initialization
    func Initialization(){
        
        self.title = CPollDetails
        self.view.backgroundColor = CRGB(r: 249, g: 250, b: 250)
        lblSharedPostType.text = CSharedEvents
        self.parentView.backgroundColor = .clear
        self.tblCommentList.backgroundColor = .clear
        
        self.txtViewComment.placeHolder = CMessageTypeYourMessage
        viewCommentContainer.layer.masksToBounds = false
        viewCommentContainer.layer.shadowColor = ColorAppTheme.cgColor
        viewCommentContainer.layer.shadowOpacity = 10
        viewCommentContainer.layer.shadowOffset = CGSize(width: 0, height: 5)
        viewCommentContainer.layer.shadowRadius = 10
        
        GCDMainThread.async {
            self.imgUser.layer.cornerRadius = self.imgUser.frame.size.width / 2
            self.imgSharedUser.layer.cornerRadius = self.imgSharedUser.frame.size.width / 2
            self.imgSharedUser.layer.borderWidth = 2
            self.imgSharedUser.layer.borderColor = #colorLiteral(red: 0, green: 0.7881455421, blue: 0.7100172639, alpha: 1)
            self.imgUser.layer.borderWidth = 2
            self.imgUser.layer.borderColor = #colorLiteral(red: 0, green: 0.7881455421, blue: 0.7100172639, alpha: 1)
            self.lblPollType.layer.cornerRadius = 3
        }
        
        GCDMainThread.async {
            self.refreshControl.addTarget(self, action: #selector(self.pullToRefresh), for: .valueChanged)
            self.refreshControl.tintColor = ColorAppTheme
            self.tblCommentList.pullToRefreshControl = self.refreshControl
            self.pageNumber = 1
            self.btnShare.setTitle(CBtnShare, for: .normal)
            self.sizeToFitHeader()
        }
        self.getPollDetailsFromServer()
        //self.getArticleDetailsFromServer()
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: #imageLiteral(resourceName: "ic_btn_nav_more"), style: .plain, target: self, action: #selector(self.btnMenuClicked(_:)))]
    }
    
    func updateUIAccordingToLanguage(){
        
        if Localization.sharedInstance.applicationFlowWithLanguageRTL() {
            // Reverse Flow...
            btnLike.contentHorizontalAlignment = .left
            btnLikeCount.contentHorizontalAlignment = .right
            btnComment.contentHorizontalAlignment = .right
            //btnComment.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 7)
            btnShare.contentHorizontalAlignment = .right
            //btnShare.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 7)
        }else{
            // Normal Flow...
            btnLike.contentHorizontalAlignment = .right
            btnLikeCount.contentHorizontalAlignment = .left
            btnComment.contentHorizontalAlignment = .left
            //btnComment.titleEdgeInsets = UIEdgeInsets(top: 0, left: 7, bottom: 0, right: 0)
            btnShare.contentHorizontalAlignment = .left
            //btnShare.titleEdgeInsets = UIEdgeInsets(top: 0, left: 7, bottom: 0, right: 0)
        }
    }
}

// MARK:- --------- Api Functions
extension PollSharedDetailsViewController {
    
    func getPollDetailsFromServer() {
        
//        self.parentView.isHidden = true
//        if let artID = self.pollID {
//            APIRequest.shared().viewPostDetail(postID: artID) { [weak self] (response, error) in
//                guard let self = self else { return }
//                if response != nil {
//                    self.parentView.isHidden = false
//                    if let articleInfo = response![CJsonData] as? [String : Any]{
//                        DispatchQueue.main.async {
//                            self.setPollDetails(articleInfo)
//                            self.openUserProfileScreen()
//                        }
//                    }
//                }
//                self.getCommentListFromServer(showLoader: true)
//            }
//        }
    }
    
    fileprivate func openUserProfileScreen(){
        
        self.btnSharedProfileImg.touchUpInside { [weak self] (sender) in
            guard let self = self else { return }
            if let userID = (self.pollInformation[CSharedPost] as? [String:Any] ?? [:])[CUserId] as? Int {
                appDelegate.moveOnProfileScreen(userID.description, self)
            }
        }
        
        self.btnSharedUserName.touchUpInside { [weak self] (sender) in
            guard let self = self else { return }
            if let userID = (self.pollInformation[CSharedPost] as? [String:Any] ?? [:])[CUserId] as? Int {
                appDelegate.moveOnProfileScreen(userID.description, self)
            }
        }
        
        self.btnProfileImg.touchUpInside { [weak self] (sender) in
            guard let self = self else { return }
            appDelegate.moveOnProfileScreen(self.pollInformation.valueForString(key: CUserId), self)
        }
        
        self.btnUserName.touchUpInside { [weak self] (sender) in
            guard let self = self else { return }
            appDelegate.moveOnProfileScreen(self.pollInformation.valueForString(key: CUserId), self)
        }
    }
    
    func setPollDetails(_ pollInformation : [String : Any]?) {
        
        if let pollInfo = pollInformation{
            
            self.pollInformation = pollInfo
            if let sharedData = pollInfo[CSharedPost] as? [String:Any]{
                
                self.lblSharedUserName.text = sharedData.valueForString(key: CFullName)
                
                self.lblSharedPostDate.text = DateFormatter.dateStringFrom(timestamp: sharedData.valueForDouble(key: CCreated_at), withFormate: CreatedAtPostDF)
                imgSharedUser.loadImageFromUrl(sharedData.valueForString(key: CUserProfileImage), true)
                lblMessage.text = sharedData.valueForString(key: CMessage)
            }
            lblUserName.text = pollInfo.valueForString(key: CFirstname) + " " + pollInfo.valueForString(key: CLastname)
            lblPollPostDate.text = DateFormatter.dateStringFrom(timestamp: pollInfo.valueForDouble(key: CCreated_at), withFormate: CreatedAtPostDF)
            lblPollTitle.text = pollInfo.valueForString(key: CTitle)
            
            imgUser.loadImageFromUrl(pollInfo.valueForString(key: CUserProfileImage), true)
            if let pollsData = pollInfo[CPollData] as? [String:Any] {
                
                let voteCount = pollsData.valueForInt(key:CAllVotes) ?? 0
                self.updateVoteCount(count: voteCount)
                tblVAnswre.updateVoteCount = { [weak self] (votesCount) in
                    guard let _ = self else {return}
                    DispatchQueue.main.async {
                        self?.updateVoteCount(count: votesCount)
                    }
                }
                tblVAnswre.refreshOnVoteWithData = { [weak self] (optionData,countVoted) in
                    guard let self = self else {return}
                    DispatchQueue.main.async {
                        MIGeneralsAPI.shared().refreshPollPostRelatedScreens(self.pollInformation, self.tblVAnswre.postID, self.tblVAnswre.userVotedPollId, optionData: optionData, self, isSelected: false)
                    }
                }
                
                
                var polls : [MDLPollOption] = []
                for obj in pollsData[CPolles] as? [[String : Any]] ?? []{
                    polls.append(MDLPollOption(fromDictionary: obj))
                }
                tblVAnswre.totalVotes = voteCount
                tblVAnswre.arrOption = polls
                
                if pollInfo.valueForString(key: CUserId) == "\(String(describing: appDelegate.loginUser?.user_id ?? 0))"{
                    tblVAnswre.isSelected = true
                }else{
                    tblVAnswre.isSelected = pollInfo.valueForBool(key: CIsUserVoted)
                }
                
                tblVAnswre.userVotedPollId = pollInfo.valueForInt(key: CUserVotedPoll) ?? 0
                
                let isSharedPost = pollInfo.valueForInt(key: CIsSharedPost)
                if isSharedPost == 1{
                    tblVAnswre.postID = pollInfo.valueForInt(key: COriginalPostId) ?? 0
                }else{
                    tblVAnswre.postID = pollInfo.valueForInt(key: CId) ?? 0
                }
                tblVAnswre.userID = pollInfo.valueForInt(key: CUserId) ?? 0
                
                tblVAnswre.reloadData()
            }
            
            lblPollType.text = CTypePoll
            
            lblPollCategory.text = pollInfo.valueForString(key: CCategory).uppercased()
            btnLike.isSelected = pollInfo.valueForInt(key: CIs_Like) == 1
            
            likeCount = pollInfo.valueForInt(key: CTotal_like) ?? 0
            
            self.commentCount = pollInfo.valueForInt(key: CTotalComment) ?? 0
            btnComment.setTitle(appDelegate.getCommentCountString(comment: commentCount), for: .normal)
            
            btnLikeCount.setTitle(appDelegate.getLikeString(like: likeCount), for: .normal)
            btnShare.setTitle(CBtnShare, for: .normal)
            tblVAnswre.layoutIfNeeded()
            self.view.layoutIfNeeded()
            self.sizeToFitHeader()
        }
    }
    
    fileprivate func updateVoteCount(count:Int){
        if count == 1{
            self.lblVoteCount.text = "\(count) \(CVote)"
        }else{
            self.lblVoteCount.text = "\(count) \(CVotes)"
        }
    }
    
    fileprivate func deleteArticlePost(){
        if let artID = self.pollID{
//            self.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: CMessageDeletePost, btnOneTitle: CBtnYes, btnOneTapped: { [weak self] (alert) in
//                guard let self = self else { return }
//                APIRequest.shared().deletePost(postID: artID, completion: { [weak self] (response, error) in
//                    guard let self = self else { return }
//                    if response != nil && error == nil{
//                        self.navigationController?.popViewController(animated: true)
//                        MIGeneralsAPI.shared().refreshPostRelatedScreens(nil, artID, self, .deletePost)
//                    }
//                })
//            }, btnTwoTitle: CBtnNo, btnTwoTapped: nil)
        }
    }
}

// MARK:- --------- Action Event
extension PollSharedDetailsViewController{
    @objc fileprivate func btnMenuClicked(_ sender : UIBarButtonItem) {
        
        let userID = (pollInformation[CSharedPost] as? [String:Any] ?? [:])[CUserId] as? Int64 ?? 0
        if userID == appDelegate.loginUser?.user_id{
            self.presentActionsheetWithOneButton(actionSheetTitle: nil, actionSheetMessage: nil, btnOneTitle: CBtnDelete, btnOneStyle: .default) { (alert) in
                self.deleteArticlePost()
            }
        }else{
            let sharePostData = pollInformation[CSharedPost] as? [String:Any] ?? [:]
            if let reportVC = CStoryboardGeneral.instantiateViewController(withIdentifier: "ReportViewController") as? ReportViewController {
                reportVC.reportType = .reportPoll
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
            
            MIGeneralsAPI.shared().likeUnlikePostWebsite(post_id: self.pollID, rss_id: nil, type: 1, likeStatus: btnLike.isSelected ? 1 : 0, viewController: self)
        }else{
            // LIKE COUNT CLK
            if let likeVC = CStoryboardGeneral.instantiateViewController(withIdentifier: "LikeViewController") as? LikeViewController{
                likeVC.postID = self.pollID
                self.navigationController?.pushViewController(likeVC, animated: true)
            }
        }
    }
    
    @IBAction func btnShareReportCLK(_ sender : UIButton){
        //self.presentActivityViewController(mediaData: pollInformation.valueForString(key: CShare_url), contentTitle: CSharePostContentMsg)
        let sharePost = SharePostHelper(controller: self, dataSet: pollInformation)
        sharePost.shareURL = pollInformation.valueForString(key: CShare_url)
        sharePost.presentShareActivity()
    }
    
}

// MARK:- --------- Api functions
extension PollSharedDetailsViewController{
    @objc func pullToRefresh() {
        if apiTask?.state == URLSessionTask.State.running {
            apiTask?.cancel()
        }
        
        self.pageNumber = 1
        refreshControl.beginRefreshing()
        self.getCommentListFromServer(showLoader: false)
    }
    
    fileprivate func getCommentListFromServer(showLoader: Bool){
        
        if apiTask?.state == URLSessionTask.State.running {
            return
        }
        
        // Add load more indicator here...
        self.tblCommentList.tableFooterView = self.pageNumber > 2 ? self.loadMoreIndicator(ColorAppTheme) : UIView()
        
//        apiTask = APIRequest.shared().getCommentList(page: pageNumber, showLoader: showLoader, post_id: pollID, rss_id: rssId) { [weak self] (response, error) in
//            guard let self = self else { return }
//            self.tblCommentList.tableFooterView = UIView()
//            self.refreshControl.endRefreshing()
//            self.apiTask?.cancel()
//
//            if response != nil {
//
//                if let arrList = response![CJsonData] as? [[String:Any]] {
//
//                    // Remove all data here when page number == 1
//                    if self.pageNumber == 1 {
//                        self.arrCommentList.removeAll()
//                        self.tblCommentList.reloadData()
//                    }
//
//                    // Add Data here...
//                    if arrList.count > 0{
//                        self.arrCommentList = self.arrCommentList + arrList
//                        self.tblCommentList.reloadData()
//                        self.pageNumber += 1
//                    }
//                }
//
//                print("arrCommentListCount : \(self.arrCommentList.count)")
//                //self.lblNoData.isHidden = self.arrCommentList.count != 0
//            }
//        }
    }
}


// MARK:- UITableViewDelegate, UITableViewDataSource
extension PollSharedDetailsViewController: UITableViewDelegate, UITableViewDataSource{
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTblCell", for: indexPath) as? CommentTblCell
        {
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
                        print(name)
                        guard let _ = self else { return }
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
                guard let _ = self else { return }
                label.text = commentText
                label.minimumLineHeight = 0
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
                self.getCommentListFromServer(showLoader: false)
            }
            
            return cell
        }
        
        return tableView.tableViewDummyCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

// MARK:-  --------- Generic UITextView Delegate
extension PollSharedDetailsViewController: GenericTextViewDelegate{
    
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
extension PollSharedDetailsViewController: UserSuggestionDelegate{
    func didSelectSuggestedUser(_ userInfo: [String : Any]) {
        viewUserSuggestion.arrangeFinalComment(userInfo, textView: txtViewComment)
    }
}

// MARK:-  --------- Action Event
extension PollSharedDetailsViewController{
    @IBAction func btnSendCommentCLK(_ sender : UIButton){
        self.resignKeyboard()
        
        if (txtViewComment.text?.isBlank)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageCommentBlank, btnOneTitle: CBtnOk, btnOneTapped: nil)
        } else {
            
            // Get Final text for comment..
            let strComment = viewUserSuggestion.stringToBeSendInComment(txtViewComment)
            
            // Get Mention user's Ids..
            let includedUser = viewUserSuggestion.arrSelectedUser.map({$0.valueForString(key: CUserId) }).joined(separator: ",")
            
//            APIRequest.shared().sendComment(post_id: pollID, commentId: self.editCommentId, rss_id: nil, type: 1, comment: strComment, include_user_id: includedUser) { [weak self] (response, error) in
//                guard let self = self else {return}
//                if response != nil && error == nil {
//                    
//                    self.viewUserSuggestion.hideSuggestionView(self.txtViewComment)
//                    self.txtViewComment.text = ""
//                    self.btnSend.isUserInteractionEnabled = false
//                    self.btnSend.alpha = 0.5
//                    self.txtViewComment.updatePlaceholderFrame(false)
//                    
//                    if let comment = response![CJsonData] as? [String : Any] {
//                        if (self.editCommentId ?? 0) == 0{
//                            self.arrCommentList.insert(comment, at: 0)
//                            self.commentCount += 1
//                            
//                            self.btnComment.setNormalTitle(normalTitle: appDelegate.getCommentCountString(comment: self.commentCount))
//                            
//                            self.tblCommentList.reloadData()
//                            if let responsInfo = response as? [String : Any]{
//                                // To udpate previous screen data....
//                                MIGeneralsAPI.shared().refreshPostRelatedScreens(responsInfo, self.pollID, self, .commentPost)
//                            }
//                        }else{
//                            // Edit comment in array
//                            if let index = self.arrCommentList.index(where: { $0[CId] as? Int ==  (self.editCommentId ?? 0)}) {
//                                self.arrCommentList.remove(at: index)
//                                self.arrCommentList.insert(comment, at: 0)
//                                self.tblCommentList.reloadData()
//                            }
//                        }
//                        self.genericTextViewDidChange(self.txtViewComment, height: 10)
//                    }
//                    self.editCommentId =  nil
//                    self.tblCommentList.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
//                    //self.lblNoData.isHidden = self.arrCommentList.count != 0
//                }
//            }
            
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
//                    self.btnComment.setTitle(appDelegate.getCommentCountString(comment: self.commentCount), for: .normal)
//                    self.arrCommentList.remove(at: index)
//                    self.tblCommentList.reloadData()
//                    MIGeneralsAPI.shared().refreshPostRelatedScreens(nil, self.pollID, self, .deleteComment)
//                }
//            }
//        }
    }
}
