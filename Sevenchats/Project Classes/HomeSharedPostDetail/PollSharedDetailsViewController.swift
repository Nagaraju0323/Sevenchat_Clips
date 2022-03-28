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
    var totalVotesNew = ""

    var arrCommentList = [[String:Any]]()
    var arrUserForMention = [[String:Any]]()
    var arrFilterUser = [[String:Any]]()
    var likeCount = 0
    var commentCount = 0
    var rssId : Int?
    var editCommentId : Int? = nil
    var pollInformation = [String : Any]()
    
    var pollIDNew : String?
    var totalComment = 0
    var like =  0
    var info = [String:Any]()
    var commentinfo = [String:Any]()
    var likeTotalCount = 0
    var isSelected:Bool?
    var pollInformationNew = [String : Any]()
    var chngString:String?
    var pollfromHomeview:String?
    var dictArray = [String]()
    var arrPostList = [String : Any]()
    var optionText = ""
    var arr = [String]()
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
    var notificationInfo = [String:Any]()
    var polls : [MDLPollOption] = []
    var fullNameArr:[String] = []
    var postPerArr = [String]()
    var pollOptionArr:[String] = []
    
    
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
        if isLikesOthersPage == true {
            tblVAnswre.isLikesOthersPage = true
        }
        self.getPollDetailsFromServer()
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            self.setPollDetails(self.pollInformation)
//            self.updateUIAccordingToLanguage()
//            self.getCommentListFromServer(showLoader: true)
//            self.openUserProfileScreen()
//        }
        self.setPollDetails(self.pollInformation)
        self.updateUIAccordingToLanguage()
        self.getCommentListFromServer(showLoader: true)
        
//        self.updateUIAccordingToLanguage()
//        self.setPollDetails(pollInformation)
//        self.openUserProfileScreen()
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
        
        self.btnSharedProfileImg.touchUpInside { [weak self] (sender) in
            guard let self = self else { return }
            appDelegate.moveOnProfileScreenNew(self.pollInformation.valueForString(key: CSharedUserID), self.pollInformation.valueForString(key: CSharedEmailID), self)
        }
        
        self.btnSharedUserName.touchUpInside { [weak self] (sender) in
            guard let self = self else { return }
            appDelegate.moveOnProfileScreenNew(self.pollInformation.valueForString(key: CSharedUserID), self.pollInformation.valueForString(key: CSharedEmailID), self)
        }
        
        self.btnProfileImg.touchUpInside { [weak self] (sender) in
            guard let self = self else { return }
            appDelegate.moveOnProfileScreenNew(self.pollInformation.valueForString(key: CUserId), self.pollInformation.valueForString(key: CUsermailID), self)
        }
        
        self.btnUserName.touchUpInside { [weak self] (sender) in
            guard let self = self else { return }
            appDelegate.moveOnProfileScreenNew(self.pollInformation.valueForString(key: CUserId), self.pollInformation.valueForString(key: CUsermailID), self)
        }
    }
    
    func setPollDetails(_ pollInformation : [String : Any]?) {
        
        if let pollInfo = pollInformation{
            
            self.pollInformation = pollInfo
            notificationInfo = pollInfo
            
            self.pollIDNew = pollInfo.valueForString(key:CPostId)

            if isLikesOthersPage == true {
                posted_ID = self.posted_IDOthers
            }else {
                posted_ID = pollInfo.valueForString(key: "user_id")
            }
            
            
                self.lblSharedUserName.text = pollInfo.valueForString(key: CFullName) + " " + pollInfo.valueForString(key: CLastName)
                
            let shared_created_at = pollInfo.valueForString(key: CShared_Created_at)
                        let shared_cnv_date = shared_created_at.stringBefore("G")
                        let sharedCreated = DateFormatter.shared().convertDatereversLatest(strDate: shared_cnv_date)
                        lblSharedPostDate.text = sharedCreated
                imgSharedUser.loadImageFromUrl(pollInfo.valueForString(key: CUserSharedProfileImage), true)
                lblMessage.text = pollInfo.valueForString(key: CMessage)
            lblUserName.text = pollInfo.valueForString(key: CFirstname) + " " + pollInfo.valueForString(key: CLastname)
            let created_At = pollInfo.valueForString(key: CCreated_at)
                        let cnvStr = created_At.stringBefore("G")
                        let startCreated = DateFormatter.shared().convertDatereversLatest(strDate: cnvStr)
            lblPollPostDate.text = startCreated
            lblPollTitle.text = pollInfo.valueForString(key: CTitle)
            imgUser.loadImageFromUrl(pollInfo.valueForString(key: CUserProfileImage), true)
            
            if let pollsData = pollInformation{
                let dispatchGroup = DispatchGroup()
                let voteCount = pollsData.valueForString(key:"total_count").toInt ?? 0
                fullNameArr =  jsonToStringConvert(pollString: pollsData["options"] as? String ?? "")
                self.updateVoteCount(count: voteCount)
                tblVAnswre.updateVoteCount = { [weak self] (votesCount) in
                    guard let _ = self else {return}
                    self?.updateVoteCount(count: votesCount)
                }
                
                tblVAnswre.refreshOnVoteWithData = { [weak self] (optionData,countuser) in
                    guard let self = self else {return}
                    DispatchQueue.main.async {

                        MIGeneralsAPI.shared().refreshPollPostRelatedScreens(pollsData, self.tblVAnswre.postID, self.tblVAnswre.userVotedPollId, optionData: optionData, self, .polladded, isSelected: false)
                        
                    }
                }
                var polls : [MDLPollOption] = []
                var pollinformation = [MDLPollInformation]()
                var dictionary = [String: String]()
                for player in fullNameArr {
                    dictionary["poll_text"] = player
                    polls.append(MDLPollOption(fromDictionary: dictionary))
                }
                pollinformation.append(MDLPollInformation(fromDictionary: pollsData))
                tblVAnswre.totalVotes = voteCount
                tblVAnswre.arrOption = polls
                tblVAnswre.arrPollInformation = pollinformation
                tblVAnswre.isDetailsSelected = true
                
                if pollsData.valueForString(key: CUserId) == "\(String(describing: appDelegate.loginUser?.user_id ?? 0))" {
                    tblVAnswre.isSelected = true
                }else{
                    tblVAnswre.isSelected = pollsData.valueForBool(key: CIsUserVoted)
                }
                
                tblVAnswre.userVotedPollId = pollsData.valueForInt(key: CUserVotedPoll) ?? 0
                tblVAnswre.userEmailID = pollsData.valueForString(key: "user_email")
                tblVAnswre.postID = pollsData.valueForString(key: "post_id").toInt ?? 0
                let postID = pollsData.valueForString(key: "post_id").toInt ?? 0
                tblVAnswre.userID = pollsData.valueForString(key: CUserId).toInt ?? 0
                dispatchGroup.enter()
                DispatchQueue.global().async {
                self.pollresponseToarr(postInfo: pollsData,completion: { [self] success,result   in
                    if success == true {
                        print("frames success")
                        self.tblVAnswre.dictArray = result
//                        self.tblVAnswre.pollIsSelected = self.pollIsSelected
                        var dictionarys = [String: Any]()
                        let polltextCnt = self.fullNameArr.count
                        let voteCounts = voteCount
                        postPerArr.removeAll()
                        if polltextCnt == 1{
                            
                        }else if polltextCnt == 2{
                            let poll_Text1 = result[0]
                            let poll_Text2 = result[1]
                            let poll_Res1 = Int(poll_Text1) ?? 0
                            let poll_Res2 = Int(poll_Text2) ?? 0
                            
                            if voteCount == 0{
                                let pollper_firstArrMul = poll_Res1 * 100
                                let pollper_secondArrMul = poll_Res2 * 100
                                let postdata:Float = Float(pollper_firstArrMul)
                                let poll_friststr = String(format:"%0.02f", (Float(postdata)))
                                self.postPerArr.append(poll_friststr)
                                let postdata1:Float = Float(pollper_secondArrMul)
                                let poll_Secondstr = String(format:"%0.02f", (Float(postdata1)))
                                self.postPerArr.append(poll_Secondstr)
                            }else {
                                let pollper_firstArrMul = (poll_Res1 * 100) / voteCounts
                                let pollper_secondArrMul = (poll_Res2 * 100) / voteCounts
                                let postdata:Float = Float(pollper_firstArrMul)
                                let poll_friststr = String(format:"%0.02f", (Float(postdata)))
                                self.postPerArr.append(poll_friststr)
                                let postdata1:Float = Float(pollper_secondArrMul)
                                let poll_Secondstr = String(format:"%0.02f", (Float(postdata1)))
                                self.postPerArr.append(poll_Secondstr)
                            }
                        }else if polltextCnt == 3{
                            print("count\(polltextCnt)")
                            let poll_Text1 = result[0]
                            let poll_Text2 = result[1]
                            let poll_Text3 = result[2]
                            let poll_Res1 = Int(poll_Text1) ?? 0
                            let poll_Res2 = Int(poll_Text2) ?? 0
                            let poll_Res3 = Int(poll_Text3) ?? 0
                            if voteCount == 0{
                                
                                let pollper_firstArrMul = poll_Res1 * 100
                                let pollper_secondArrMul = poll_Res2 * 100
                                let pollper_ThirdArrMul = poll_Res3 * 100
                                let postdata1:Float = Float(pollper_firstArrMul)
                                let poll_friststr = String(format:"%0.02f", (Float(postdata1)))
                                self.postPerArr.append(poll_friststr)
                                let postdata2:Float = Float(pollper_secondArrMul)
                                let poll_Secondstr = String(format:"%0.02f", (Float(postdata2)))
                                self.postPerArr.append(poll_Secondstr)
                                let postdata3:Float = Float(pollper_ThirdArrMul)
                                let poll_Thirdstr = String(format:"%0.02f", (Float(postdata3)))
                                self.postPerArr.append(poll_Thirdstr)
                            }else {
                                let pollper_firstArrMul = (poll_Res1 * 100) / voteCounts
                                let pollper_secondArrMul = (poll_Res2 * 100) / voteCounts
                                let pollper_ThirdArrMul = (poll_Res3 * 100) / voteCounts
                                let postdata1:Float = Float(pollper_firstArrMul)
                                let poll_friststr = String(format:"%0.02f", (Float(postdata1)))
                                self.postPerArr.append(poll_friststr)
                                let postdata2:Float = Float(pollper_secondArrMul)
                                let poll_Secondstr = String(format:"%0.02f", (Float(postdata2)))
                                self.postPerArr.append(poll_Secondstr)
                                let postdata3:Float = Float(pollper_ThirdArrMul)
                                let poll_Thirdstr = String(format:"%0.02f", (Float(postdata3)))
                                self.postPerArr.append(poll_Thirdstr)
                            }
                        }else if polltextCnt == 4 {
                            print("count\(polltextCnt)")
                            
                            let poll_Text1 = result[0]
                            let poll_Text2 = result[1]
                            let poll_Text3 = result[2]
                            let poll_Text4 = result[3]
                            let poll_Res1 = Int(poll_Text1) ?? 0
                            let poll_Res2 = Int(poll_Text2) ?? 0
                            let poll_Res3 = Int(poll_Text3) ?? 0
                            let poll_Res4 = Int(poll_Text4) ?? 0

                            if voteCount == 0{
                                let pollper_firstArrMul = poll_Res1 * 100
                                let pollper_secondArrMul = poll_Res2 * 100
                                let pollper_ThirdArrMul = poll_Res3 * 100
                                let pollper_FourthArrMul = poll_Res4 * 100
                                
                                let postdata1:Float = Float(pollper_firstArrMul)
                                let poll_friststr = String(format:"%0.02f", (Float(postdata1)))
                                self.postPerArr.append(poll_friststr)
                                let postdata2:Float = Float(pollper_secondArrMul)
                                let poll_Secondstr = String(format:"%0.02f", (Float(postdata2)))
                                self.postPerArr.append(poll_Secondstr)
                                let postdata3:Float = Float(pollper_ThirdArrMul)
                                let poll_Thirdstr = String(format:"%0.02f", (Float(postdata3)))
                                self.postPerArr.append(poll_Thirdstr)
                                let postdata4:Float = Float(pollper_FourthArrMul)
                                let poll_Fourthdstr = String(format:"%0.02f", (Float(postdata4)))
                                self.postPerArr.append(poll_Fourthdstr)
                            }else {
                                let pollper_firstArrMul = (poll_Res1 * 100) / voteCounts
                                let pollper_secondArrMul = (poll_Res2 * 100) / voteCounts
                                let pollper_ThirdArrMul = (poll_Res3 * 100) / voteCounts
                                let pollper_FourthArrMul = (poll_Res4 * 100) / voteCounts
                                
                                let postdata1:Float = Float(pollper_firstArrMul)
                                let poll_friststr = String(format:"%0.02f", (Float(postdata1)))
                                self.postPerArr.append(poll_friststr)
                                let postdata2:Float = Float(pollper_secondArrMul)
                                let poll_Secondstr = String(format:"%0.02f", (Float(postdata2)))
                                self.postPerArr.append(poll_Secondstr)
                                let postdata3:Float = Float(pollper_ThirdArrMul)
                                let poll_Thirdstr = String(format:"%0.02f", (Float(postdata3)))
                                self.postPerArr.append(poll_Thirdstr)
                                let postdata4:Float = Float(pollper_FourthArrMul)
                                let poll_Fourthdstr = String(format:"%0.02f", (Float(postdata4)))
                                self.postPerArr.append(poll_Fourthdstr)
                            }
                            

                        }
                        
                        for (index, element) in fullNameArr.enumerated() {
                            print(index, ":", element)
                            dictionarys["poll_text"] = self.fullNameArr[index]
                            dictionarys["poll_vote_per"] = Double(self.postPerArr[index])
                            self.polls.append(MDLPollOption(fromDictionary: dictionarys))
                        }
                    }
                    self.tblVAnswre.arrOption = self.polls
                    dispatchGroup.leave()
                })
                }
                self.tblVAnswre.pollIsSelected = pollsData.valueForString(key: "is_selected")
               self.tblVAnswre.totalVotes = pollsData.valueForString(key: "total_count").toInt ?? 0
                dispatchGroup.notify(queue: .main) {
                    self.tblVAnswre.reloadData()
                }
            }

            //Like button Click Action perorms
            lblPollType.text = CTypePoll
            
            lblPollCategory.text = pollInfo.valueForString(key: CCategory).uppercased()
            
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
            
            
//            btnLike.isSelected = pollInfo.valueForInt(key: CIs_Like) == 1
//            likeCount = pollInfo.valueForInt(key: CTotal_like) ?? 0
//            btnLikeCount.setTitle(appDelegate.getLikeString(like: likeCount), for: .normal)
//
//
//
//            self.commentCount = pollInfo.valueForInt(key: CTotalComment) ?? 0
//            btnComment.setTitle(appDelegate.getCommentCountString(comment: commentCount), for: .normal)
            
            likeCount = pollInfo.valueForString(key: CLikes).toInt ?? 0
            self.btnLikeCount.setTitle(appDelegate.getLikeString(like: likeCount), for: .normal)
            commentCount = pollInfo.valueForString(key: "comments").toInt ?? 0
            self.totalComment = commentCount
            btnComment.setTitle(appDelegate.getCommentCountString(comment: commentCount), for: .normal)
            
            self.tblCommentList.updateHeaderViewHeight(extxtraSpace: 0)
            

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
extension PollSharedDetailsViewController{
    @objc fileprivate func btnMenuClicked(_ sender : UIBarButtonItem) {
        
        let userID = (pollInformation[CSharedPost] as? [String:Any] ?? [:])[CUserId] as? Int64 ?? 0
        if userID == appDelegate.loginUser?.user_id{
            self.presentActionsheetWithOneButton(actionSheetTitle: nil, actionSheetMessage: nil, btnOneTitle: CBtnDelete, btnOneStyle: .default) { (alert) in
                self.deleteArticlePost(self.pollInformation)
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
        self.btnLike.isSelected = !self.btnLike.isSelected
        
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
                        
                        if self?.posted_ID == user_ID {
                        }else {
                        if self?.isLikesOthersPage == true {
                            self?.notificationInfo["friend_liked"] = "Yes"
                        }
                        if self?.isLikesHomePage == true  || self?.isLikesMyprofilePage == true {
                            self?.notificationInfo["is_liked"] = "Yes"
                        }
                        self?.notificationInfo["likes"] = self?.likeTotalCount.toString
                        self?.notificationInfo["options"] = ""
                        MIGeneralsAPI.shared().sendNotification(self?.posted_ID, userID: user_ID, subject: "liked your Post", MsgType: "COMMENT", MsgSent: "", showDisplayContent: "liked your Post", senderName: firstName + lassName, post_ID: self?.notificationInfo ?? [:],shareLink: "shareLikes")
                        if let metaInfo = response![CJsonMeta] as? [String : Any] {
                            let stausLike = metaInfo["status"] as? String ?? "0"
                            if stausLike == "0" {
                            }
                        }
                    }
                        self?.notifcationIsSlected = false
                    }
                    
                    if self?.isLikesOthersPage == true {
                        if self?.isFinalLikeSelected == true{
                            MIGeneralsAPI.shared().likeUnlikePostWebsites(post_id: Int(self?.pollID ?? 0), rss_id: 1, type: 1, likeStatus: self?.like ?? 0 ,info:postInfo, viewController: self)
                            self?.isLikeSelected = false
                        }else {
                            MIGeneralsAPI.shared().likeUnlikePostWebsites(post_id: Int(self?.pollID ?? 0), rss_id: 2, type: 1, likeStatus: self?.like ?? 0 ,info:postInfo, viewController: self)
                            
                        }
                    }
                    if  self?.isLikesHomePage == true || self?.isLikesMyprofilePage == true {
                        MIGeneralsAPI.shared().likeUnlikePostWebsites(post_id: Int(self?.pollID ?? 0), rss_id: 3, type: 1, likeStatus: self?.like ?? 0 ,info:postInfo, viewController: self)
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
                            let stausLike = data["status"] as? String ?? "0"
                            if stausLike == "0"  {

                            }
                            if self.posted_ID != userId.description{
                                guard let firstName = appDelegate.loginUser?.first_name else {return}
                                guard let lassName = appDelegate.loginUser?.last_name else {return}
                                self.notificationInfo["comments"] = self.commentCount
                                self.notificationInfo["options"] = ""
                                MIGeneralsAPI.shared().sendNotification(self.posted_ID, userID: userId, subject: "Commented on your Post", MsgType: "COMMENT", MsgSent: "", showDisplayContent: "Commented on your Post", senderName: firstName + lassName, post_ID: self.notificationInfo,shareLink: "shareComment")
                                
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

extension PollSharedDetailsViewController{
    
    func pollresponseToarr(postInfo:[String:Any],completion:@escaping(_ success:Bool,_ result:[String]) -> Void ) {
        
        self.arr.removeAll()
        var arrayData  = ["0","0","0","0"]
            self.polls = []
            _ = (postInfo["options"] as? String ?? "" ).replace(string: "\"", replacement: "")

            self.pollOptionArr =  self.jsonToStringConvert(pollString:postInfo["options"] as? String ?? "")

            let obj = postInfo["results"] as? [String : AnyObject] ?? [:]
            if obj.count == 1 {
                self.arrPostList =  obj
                for (key, value) in obj {
                    let indexOfA  = self.pollOptionArr.firstIndex(of: key)
                    if indexOfA == 0{
                        self.arr = ["\(value)","0","0","0"]
                    }else if indexOfA == 1{
                        self.arr = ["0","\(value)","0","0"]
                    }else if indexOfA == 2{
                        self.arr = ["0","0","\(value)","0"]
                    }else if indexOfA == 3{
                        self.arr = ["0","0","0","\(value)",]
                    }
                }
            }else {
                self.arrPostList =  obj
                for (key, value) in obj {
                    let indexOfA  = self.pollOptionArr.firstIndex(of: key)
                    arrayData.remove(at: indexOfA ?? 0)
                    arrayData.insert("\(value)", at: indexOfA ?? 0)
                }
                self.arr += arrayData
            }
            self.dictArray = self.arr
        completion(true,self.dictArray)
    }
    
    
}


extension PollSharedDetailsViewController{
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func jsonToStringConvert(pollString:String) -> [String]{
        var jsonStrPoll = [String]()
        let data = pollString.data(using: .utf8)!
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String]{
                jsonStrPoll = jsonArray
            } else {
                print("bad json")
            }
        } catch let error as NSError {
            print(error)
        }
        return jsonStrPoll
    }
    
    
}
