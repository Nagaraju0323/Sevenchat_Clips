//
//  PollDetailsViewController.swift
//  Sevenchats
//
//  Created by mac-00020 on 06/06/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Chandrika.R                                 *
 * Model   : PollVotesListViewController                 *
 * Description :                                         *
 *                                                       *
 ********************************************************/

import Foundation
import UIKit
import ActiveLabel

class PollDetailsViewController: ParentViewController {
    
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
    
    var pollID : Int?
    var pollIDNew : String?
    var pageNumber = 1
    var refreshControl = UIRefreshControl()
    var arrCommentList = [[String:Any]]()
    var arrUserForMention = [[String:Any]]()
    var arrFilterUser = [[String:Any]]()
    var likeCount = 0
    var commentCount = 0
    var rssId : Int?
    var editCommentId : Int? = nil
    var totalComment = 0
    var like =  0
    var info = [String:Any]()
    var commentinfo = [String:Any]()
    var likeTotalCount = 0
    var isSelected:Bool?
    var pollInformation = [String : Any]()
    var pollInformationNew = [String : Any]()
    var chngString:String?
    var pollfromHomeview:String?
    var dictArray = [String]()
    var arrPostList = [String : Any]()
    var optionText = ""
    var apiTask : URLSessionTask?
    var arr = [String]()
    var totalVotesNew = ""
    var posted_ID = ""
    var profileImg = ""
    var notifcationIsSlected = false
    var isLikesOthers:Bool?
    var isLikeSelected = false
    var isFinalLikeSelected = false
    var isLikesOthersPage:Bool?
    var isLikesHomePage:Bool?
    var isLikesMyprofilePage:Bool?
    var posted_IDOthers = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Initialization()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tblVAnswre.postinfo = self.pollInformation
        print("Pollinformation::::::::::\(self.pollInformation)")
        self.getPollDetailsFromServer()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.setPollDetails(self.pollInformation)
            
            self.updateUIAccordingToLanguage()
            self.getCommentListFromServer(showLoader: true)
        }
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
extension PollDetailsViewController {

    func getPollDetailsFromServer() {
        if let artID = self.pollID {
            APIRequest.shared().viewPollDetailNew(postID: artID){ [weak self] (response, error) in
                guard let self = self else { return }
                if response != nil {
                    //self.parentView.isHidden = false
                    DispatchQueue.main.async {
                    if let Info = response!["data"] as? [[String:Any]]{
                        for articleInfo in Info {
                            self.totalVotesNew = articleInfo["total_count"] as? String ?? "0"
                            print("self.totalVotes\(self.totalVotesNew)")
                        }
                        self.openUserProfileScreen()
                       
                    }
                }
            }
//            self.getCommentListFromServer(showLoader: true)
        }
    }
}
    
    
    fileprivate func openUserProfileScreen(){
        
        self.btnProfileImg.touchUpInside { [weak self] (sender) in
            guard let self = self else { return }
//            appDelegate.moveOnProfileScreen(self.pollInformation.valueForString(key: CUserId), self)
            appDelegate.moveOnProfileScreenNew(self.pollInformation.valueForString(key: CUserId), self.pollInformation.valueForString(key: CUsermailID), self)
        }
        
        self.btnUserName.touchUpInside { [weak self] (sender) in
            guard let self = self else { return }
//            appDelegate.moveOnProfileScreen(self.pollInformation.valueForString(key: CUserId), self)
            appDelegate.moveOnProfileScreenNew(self.pollInformation.valueForString(key: CUserId), self.pollInformation.valueForString(key: CUsermailID), self)
        }
    }
    
    func setPollDetails(_ pollInformation : [String : Any]?) {
        
        if let pollInfo = pollInformation{
            
            self.pollInformation = pollInfo
            
            self.pollIDNew = pollInfo.valueForString(key:CPostId)
//            posted_ID = pollInfo.valueForString(key: "user_id")
            print(":::::::::::::::is_selected::\(pollInfo.valueForString(key: "is_selected"))")
            
            
            if isLikesOthersPage == true {
                posted_ID = self.posted_IDOthers
            }else {
                posted_ID = pollInfo.valueForString(key: "user_id")
            }
            
      
            lblUserName.text = pollInfo.valueForString(key: CFirstname) + " " + pollInfo.valueForString(key: CLastname)
            lblPollTitle.text = pollInfo.valueForString(key: CTitle)
            
            imgUser.loadImageFromUrl(pollInfo.valueForString(key: CUserProfileImage), true)
            
            var polls : [MDLPollOption] = []
            if isSelected == true {
                let pollstring = pollInfo["options"] as? String
                let replaced2 = pollstring?.replacingOccurrences(of: "\"", with: "")
                let replaced3 = replaced2?.replacingOccurrences(of: "[", with: "")
                let replaced4 = replaced3?.replacingOccurrences(of: "]", with: "")
                chngString = replaced4
            }else {
                let pollstring = pollInfo["options"] as? String
                let replaced2 = pollstring?.replacingOccurrences(of: "\"", with: "")
                let replaced3 = replaced2?.replacingOccurrences(of: "[", with: "")
                let replaced4 = replaced3?.replacingOccurrences(of: "]", with: "")
                chngString = replaced4
            }
            if pollfromHomeview == "home"{
                let pollstring = pollInfo["options"] as? String
                let replaced2 = pollstring?.replacingOccurrences(of: "\"", with: "")
                let replaced3 = replaced2?.replacingOccurrences(of: "[", with: "")
                let replaced4 = replaced3?.replacingOccurrences(of: "]", with: "")
                chngString = replaced4
            }
      
            let fullNameArr:[String] = chngString?.components(separatedBy:",") ?? []
            var dictionary = [String: String]()
            for player in fullNameArr {
                dictionary["poll_text"] = player
                print("dictinory\(dictionary)")
                polls.append(MDLPollOption(fromDictionary: dictionary))
            }
            let voteCount:Int =  self.totalVotesNew.toInt ?? 0
            self.updateVoteCount(count: voteCount )
            tblVAnswre.updateVoteCount = { [weak self] (votesCount) in
                guard let _ = self else {return}
                DispatchQueue.main.async {
                    self?.updateVoteCount(count: votesCount)
                }
            }
            tblVAnswre.refreshOnVoteWithData = { [weak self] (optionData,countVoted) in
                guard let self = self else {return}
                DispatchQueue.main.async {
                    MIGeneralsAPI.shared().refreshPollPostRelatedScreens(self.pollInformationNew, self.pollIDNew?.toInt, self.tblVAnswre.userVotedPollId, optionData: optionData, self, isSelected: true)
                    
                }
            }
            
            
            print("pols\(polls)")
            tblVAnswre.totalVotes = voteCount
            tblVAnswre.arrOption = polls
            if pollInfo.valueForString(key: CUserId) == "\(String(describing: appDelegate.loginUser?.user_id ?? 0))"{
                tblVAnswre.isSelected = true
            }else{
                tblVAnswre.isSelected = pollInfo.valueForBool(key: CIsUserVoted)
            }
            tblVAnswre.userVotedPollId = pollInfo.valueForInt(key: CUserVotedPoll) ?? 0
            tblVAnswre.postID = pollInfo.valueForInt(key: CId) ?? 0
            tblVAnswre.userID = pollInfo.valueForInt(key: CUserId) ?? 0
            
            tblVAnswre.reloadData()
            //            }
            
            lblPollType.text = CTypePoll
            
            lblPollCategory.text = pollInfo.valueForString(key: CCategory).uppercased()
            
            let is_Liked = pollInfo.valueForString(key: CIsLiked)
            
//            if is_Liked == "Yes"{
//                btnLike.isSelected = true
//            }else {
//                btnLike.isSelected = false
//            }
            
//            if isLikesOthersPage == true {
//                if pollInfo.valueForString(key:"friend_liked") == "Yes"  || pollInfo.valueForString(key:"is_liked") == "Yes" {
//                    btnLike.isSelected = true
//                    if pollInfo.valueForString(key:"is_liked") == "No"{
//                        isLikeSelected = false
//                    }
//                }else {
//                    if pollInfo.valueForString(key:"is_liked") == "No" || pollInfo.valueForString(key:"friend_liked") == "No" {
//                        isLikeSelected = true
//                    }
//                    btnLike.isSelected = false
//                }
//            }
            
            if isLikesOthersPage == true {
                if pollInfo.valueForString(key:"friend_liked") == "Yes"  && pollInfo.valueForString(key:"is_liked") == "Yes" {
                    btnLike.isSelected = true
                    if pollInfo.valueForString(key:"is_liked") == "No"{
                        isLikeSelected = false
                    }
                }else {
                    if pollInfo.valueForString(key:"is_liked") == "No" && pollInfo.valueForString(key:"friend_liked") == "No" {
                        isLikeSelected = true
                    }
                    btnLike.isSelected = false
                }
                
                if pollInfo.valueForString(key:"is_liked") == "Yes" && pollInfo.valueForString(key:"friend_liked") == "No" {
                    isLikeSelected = true
                    btnLike.isSelected = false
                }else if pollInfo.valueForString(key:"is_liked") == "No" && pollInfo.valueForString(key:"friend_liked") == "Yes"{
                    
                    isLikeSelected = false
                    btnLike.isSelected = true

                }
            }
            
            
            if isLikesHomePage == true  || isLikesMyprofilePage == true {
                if pollInfo.valueForString(key:CIs_Liked) == "Yes"{
                    btnLike.isSelected = true
                }else {
                    btnLike.isSelected = false
                }
            }
            
            
            likeCount = pollInfo.valueForString(key: CLikes).toInt ?? 0
            self.btnLikeCount.setTitle(appDelegate.getLikeString(like: likeCount), for: .normal)
            commentCount = pollInfo.valueForString(key: "comments").toInt ?? 0
            self.totalComment = commentCount
            btnComment.setTitle(appDelegate.getCommentCountString(comment: commentCount), for: .normal)
            
            self.tblCommentList.updateHeaderViewHeight(extxtraSpace: 0)
            let created_At = pollInfo.valueForString(key: CCreated_at)
            let cnvStr = created_At.stringBefore("G")
//            let removeFrst = cnvStr.chopPrefix(3)
            let startCreated = DateFormatter.shared().convertDatereversLatest(strDate: cnvStr)
            lblPollPostDate.text = startCreated
            
            
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
    
    fileprivate func deleteArticlePost(_ pollInfo : [String : Any]?){
        if let artID = self.pollID{
            self.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: CMessageDeletePost, btnOneTitle: CBtnYes, btnOneTapped: { (alert) in
                
                let postTypeDelete = "post_poll"
              let dict =
                    [
                        "post_id":pollInfo?.valueForString(key: "post_id"),
                        "post_category": pollInfo?.valueForString(key: "post_category"),
                        "post_title": pollInfo?.valueForString(key: "post_title"),
                        "options": pollInfo?.valueForString(key: "options"),
                        "targeted_audience": pollInfo?.valueForString(key: "targeted_audience"),
                        "selected_persons": pollInfo?.valueForString(key: "selected_persons"),
                        "status_id": "3"
                    ]
                APIRequest.shared().deletePostNew(postDetials: dict as [String : Any], apiKeyCall: postTypeDelete, completion: { [weak self](response, error) in
                        guard let self = self else { return }
                        if response != nil && error == nil{
                            self.navigationController?.popViewController(animated: true)
                            MIGeneralsAPI.shared().refreshPostRelatedScreens(nil, artID, self, .deletePost, rss_id: 0)
                        }
                })
            }, btnTwoTitle: CBtnNo, btnTwoTapped: nil)
        }
    }
}

// MARK:- --------- Action Event
extension PollDetailsViewController{
    @objc fileprivate func btnMenuClicked(_ sender : UIBarButtonItem) {
        
       // if Int64(pollInformation.valueForString(key: CUserId)) == appDelegate.loginUser?.user_id{
        if pollInformation.valueForString(key: "user_email") == appDelegate.loginUser?.email{
            self.presentActionsheetWithOneButton(actionSheetTitle: nil, actionSheetMessage: nil, btnOneTitle: CBtnDelete, btnOneStyle: .default) { (alert) in
                self.deleteArticlePost(self.pollInformation)
            }
            
        }else{
            if let reportVC = CStoryboardGeneral.instantiateViewController(withIdentifier: "ReportViewController") as? ReportViewController {
                reportVC.reportType = .reportPoll
                reportVC.userID = pollInformation.valueForInt(key: CUserId)
                reportVC.reportID = self.pollID
                reportVC.reportIDNEW = pollInformation.valueForString(key: "email")
                self.navigationController?.pushViewController(reportVC, animated: true)
            }
        }
    }
    
    @IBAction func btnLikeCLK(_ sender : UIButton){
        if sender.tag == 0{
        self.btnLike.isSelected = !self.btnLike.isSelected
        
//        if self.btnLike.isSelected == true{
//            likeCount = 1
//            like = 1
//            notifcationIsSlected = true
//        }else {
//            likeCount = 2
//            like = 0
//        }
        
        
                if self.btnLike.isSelected == true{
                    likeCount = 1
                    like = 1
                    notifcationIsSlected = true
        
                    if isLikesOthersPage  == true {
                        if isLikeSelected == true{
                            self.isFinalLikeSelected = true
                            isLikeSelected = false
                        }else {
                            self.isFinalLikeSelected = false
                        }
                    }
                }else {
                    likeCount = 2
                    like = 0
        
                    if isLikesOthersPage == true {
                        if isLikeSelected == false{
                            self.isFinalLikeSelected = false
                            isLikeSelected = false
                        }else {
                            self.isFinalLikeSelected = false
                        }
                    }
                }
        
        
        guard let userID = appDelegate.loginUser?.user_id else {return}
        APIRequest.shared().likeUnlikeProducts(userId: Int(userID), productId: (self.pollIDNew)?.toInt ?? 0 , isLike: likeCount){ [weak self](response, error) in
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
                        self?.likeCountfromSever(productId: self?.pollIDNew?.toInt ?? 0,likeCount:self?.likeCount ?? 0, postInfo: self?.info ?? [:],like:self?.like ?? 0)
                    }
                }
            }
        }
        }else{
            if let likeVC = CStoryboardGeneral.instantiateViewController(withIdentifier: "LikeViewController") as? LikeViewController{
                likeVC.postIDNew = self.pollIDNew
                self.navigationController?.pushViewController(likeVC, animated: true)
            }
        }
    }
    
    
    func likeCountfromSever(productId: Int,likeCount:Int,postInfo:[String:Any],like:Int){
        APIRequest.shared().likeUnlikeProductCount(productId: self.pollIDNew?.toInt ?? 0 ){ [weak self](response, error) in
            guard let _ = self else { return }
            if response != nil {
                GCDMainThread.async { [self] in
                    //                    info = response!["liked_users"] as? [String:Any] ?? [:]
                    self?.likeTotalCount = response?["likes_count"] as? Int ?? 0
                    self?.btnLikeCount.setTitle(appDelegate.getLikeString(like: self?.likeTotalCount ?? 0), for: .normal)
                    guard let user_ID = appDelegate.loginUser?.user_id.description else { return }
                    guard let firstName = appDelegate.loginUser?.first_name else {return}
                    guard let lassName = appDelegate.loginUser?.last_name else {return}
                    if self?.notifcationIsSlected == true{
                        MIGeneralsAPI.shared().sendNotification(self?.posted_ID, userID: user_ID, subject: "liked your Post", MsgType: "COMMENT", MsgSent: "", showDisplayContent: "liked your Post",senderName: firstName + lassName)
                        self?.notifcationIsSlected = false
                    }
//                    MIGeneralsAPI.shared().likeUnlikePostWebsites(post_id: self?.pollIDNew?.toInt ?? 0, rss_id: 0, type: 1, likeStatus: self?.like ?? 0 ,info:postInfo, viewController: self)
                    
                    
                    
                }
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
extension PollDetailsViewController{
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
        apiTask = APIRequest.shared().getProductCommentLists(page: pageNumber, showLoader: false, productId:pollIDNew!) { [weak self] (response, error) in
            
            self?.tblCommentList.tableFooterView = UIView()
            self?.refreshControl.endRefreshing()
            self?.apiTask?.cancel()
            self?.arrCommentList.removeAll()
            
            if response != nil {
                
                if let arrList = response!["comments"] as? [[String:Any]] {
                    
                    // Remove all data here when page number == 1
                    if self?.pageNumber == 1 {
                        self?.arrCommentList.removeAll()
                        self?.tblCommentList.reloadData()
                    }
                    
                    // Add Data here...
                    if arrList.count > 0{
                        self?.arrCommentList = (self!.arrCommentList) + arrList
                        self?.tblCommentList.reloadData()
                        self?.pageNumber += 1
                    }
                }
                print("arrCommentListCount : \(self?.arrCommentList.count)")
                //self.lblNoData.isHidden = self.arrCommentList.count != 0
            }
        }
    }
}


// MARK:- UITableViewDelegate, UITableViewDataSource
extension PollDetailsViewController: UITableViewDelegate, UITableViewDataSource{
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
            weak var weakCell = cell
            // cell.lblCommentPostDate.text = DateFormatter.shared().durationString(duration: commentInfo.valueForString(key: CCreated_at))
            
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
            
            if let arrIncludedUsers = commentInfo[CIncludeUserId] as? [[String : Any]] {
                for userInfo in arrIncludedUsers {
                    let userName = userInfo.valueForString(key: CFirstname) + " " + userInfo.valueForString(key: CLastname)
                    let customTypeUserName = ActiveType.custom(pattern: "\(userName)") //Looks for "user name"
                    cell.lblCommentText.enabledTypes.append(customTypeUserName)
                    cell.lblCommentText.customColor[customTypeUserName] = ColorAppTheme
                    
                    cell.lblCommentText.handleCustomTap(for: customTypeUserName, handler: { (name) in
                        print(name)
                        let arrSelectedUser = arrIncludedUsers.filter({$0[CFullName] as? String == name})
                        
                        if arrSelectedUser.count > 0 {
                            let userSelectedInfo = arrSelectedUser[0]
//                            appDelegate.moveOnProfileScreen(userSelectedInfo.valueForString(key: CUserId), self)
                            appDelegate.moveOnProfileScreenNew(userSelectedInfo.valueForString(key: CUserId), userSelectedInfo.valueForString(key: CUsermailID), self)
                        }
                    })
                    
                    commentText = commentText.replacingOccurrences(of: String(NSString(format: kMentionFriendStringFormate as NSString, userInfo.valueForString(key: CUserId))), with: userName)
                }
            }
            
            cell.lblCommentText.customize { [weak self] label in
                guard let self = self else { return }
                label.text = commentText
                label.minimumLineHeight = 0
                label.configureLinkAttribute = { [weak self] (type, attributes, isSelected) in
                    guard let _ = self else { return attributes}
                    var atts = attributes
                    atts[NSAttributedString.Key.font] = CFontPoppins(size: weakCell?.lblCommentText.font.pointSize ?? 0, type: .meduim)
                    return atts
                }
            }
            
            cell.btnUserName.touchUpInside { [weak self] (sender) in
                guard let self = self else { return }
//                appDelegate.moveOnProfileScreen(commentInfo.valueForString(key: CUserId), self)
                appDelegate.moveOnProfileScreenNew(commentInfo.valueForString(key: CUserId), commentInfo.valueForString(key: CUsermailID), self)
                
            }
            
            cell.btnUserImage.touchUpInside { [weak self] (sender) in
                guard let self = self else { return }
//                appDelegate.moveOnProfileScreen(commentInfo.valueForString(key: CUserId), self)
                appDelegate.moveOnProfileScreenNew(commentInfo.valueForString(key: CUserId), commentInfo.valueForString(key: CUsermailID), self)
            }
            
            // Load more data....
            // if (indexPath == tblCommentList.lastIndexPath()) && apiTask?.state != URLSessionTask.State.running {
            //self.getCommentListFromServer(showLoader: false)
            //}
            
            return cell
        }
        
        return tableView.tableViewDummyCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

// MARK:-  --------- Generic UITextView Delegate
extension PollDetailsViewController: GenericTextViewDelegate{
    
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
extension PollDetailsViewController: UserSuggestionDelegate{
    func didSelectSuggestedUser(_ userInfo: [String : Any]) {
        viewUserSuggestion.arrangeFinalComment(userInfo, textView: txtViewComment)
    }
}

// MARK:-  --------- Action Event
extension PollDetailsViewController{
    
    @IBAction func btnSendCommentCLK(_ sender : UIButton){
        self.resignKeyboard()
        if (txtViewComment.text?.isBlank)!{
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageCommentBlank, btnOneTitle: CBtnOk, btnOneTapped: nil)
        }else{
            if let shoId = self.pollID{
                // Get Final text for comment..
                let strComment = viewUserSuggestion.stringToBeSendInComment(txtViewComment)
                
                // Get Mention user's Ids..
                let includedUser = viewUserSuggestion.arrSelectedUser.map({$0.valueForString(key: CUserId) }).joined(separator: ",")
                
                guard let userID = appDelegate.loginUser?.user_id else{
                    return
                }
                let userId = userID.description
                APIRequest.shared().sendProductCommentnew(productId:shoId.description, commentId : self.editCommentId, comment: strComment, include_user_id: userId)  { [weak self] (response, error) in
                    
                    guard let self = self else { return }
                    if response != nil && error == nil  {
                        
                        self.viewUserSuggestion.hideSuggestionView(self.txtViewComment)
                        self.txtViewComment.text = ""
                        self.btnSend.isUserInteractionEnabled = false
                        self.btnSend.alpha = 0.5
                        self.txtViewComment.updatePlaceholderFrame(false)
                        if let comment = response![CJsonData] as? [[String : Any]] {
                            for comments in comment {
                                self.commentinfo = comments
                                if (self.editCommentId ?? 0) == 0{
                                    self.getCommentListFromServer(showLoader:true)
                                    let comment_data = comments["comments"] as? String
                                    self.commentCount = comment_data?.toInt ?? 0
                                    self.btnComment.setNormalTitle(normalTitle: appDelegate.getCommentCountString(comment: self.commentCount))
                                    MIGeneralsAPI.shared().refreshPostRelatedScreens(self.commentinfo, shoId, self, .commentPost, rss_id: 0)
                                    
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
                                MIGeneralsAPI.shared().sendNotification(self.posted_ID, userID: userId, subject: "Comment to Post", MsgType: "COMMENT", MsgSent: "", showDisplayContent: "Comment to Post", senderName:firstName + lassName )
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
    
    func btnMoreOptionOfComment(index:Int){
        
        self.presentActionsheetWithOneButton(actionSheetTitle: nil, actionSheetMessage: nil, btnOneTitle: CBtnDelete, btnOneStyle: .default) { [weak self] (_) in
            guard let _ = self else {return}
            DispatchQueue.main.async {
                self?.deleteComment(index)
            }
        }
        
    }
    func deleteComment(_ index:Int){
        
        let commentInfo = self.arrCommentList[index]
        let commentId = commentInfo.valueForString(key: "updated_at")
        let strComment = commentInfo.valueForString(key: "comment")
        
        guard let userID = appDelegate.loginUser?.user_id else{ return}
        let userId = userID.description
        APIRequest.shared().deleteProductCommentNew(productId:pollIDNew ?? "", commentId : commentId, comment: strComment, include_user_id: userId)  { [weak self] (response, error) in
            guard let self = self else { return }
            if response != nil && error == nil {
                DispatchQueue.main.async {
                    self.arrCommentList.remove(at: index)
                    self.commentCount -= 1
                    if self.commentCount >= 0{
                        self.btnComment.setTitle(appDelegate.getCommentCountString(comment: self.commentCount), for: .normal)
                    }else {
                        return
                    }
                    self.tblCommentList.reloadData()
                    MIGeneralsAPI.shared().refreshPostRelatedScreens(nil,self.pollIDNew?.toInt ?? 0 , self, .deleteComment, rss_id: 0)
                }
            }
        }
    }
}


