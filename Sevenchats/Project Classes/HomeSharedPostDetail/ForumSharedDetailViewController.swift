//
//  ForumSharedDetailViewController.swift
//  Sevenchats
//
//  Created by mac-0005 on 21/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//
/*********************************************************
 * Author  : Nagaraju K and Chandrika R                                 *
 * Model   : ForumSharedDetailViewController             *
 * Changes :                                             *
 *                                                       *
 ********************************************************/

import UIKit
import ActiveLabel
import SDWebImage

class ForumSharedDetailViewController: ParentViewController {
    
    @IBOutlet weak var viewCommentContainer : UIView!
    @IBOutlet weak var lblForumType : UILabel!
    @IBOutlet weak var lblForumTitle : UILabel!
    @IBOutlet weak var lblForumDescription : UILabel!
    @IBOutlet weak var lblForumPostDate : UILabel!
    @IBOutlet weak var lblForumCategory : UILabel!
    @IBOutlet weak var lblUserName : UILabel!
    @IBOutlet weak var imgUser : UIImageView!
    @IBOutlet weak var imgUserGIF : FLAnimatedImageView!
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
    @IBOutlet weak var imgSharedUserGIF : FLAnimatedImageView!
    @IBOutlet weak var lblSharedUserName : UILabel!
    @IBOutlet weak var btnSharedProfileImg : UIButton!
    @IBOutlet weak var btnSharedUserName : UIButton!
    @IBOutlet weak var lblMessage : UILabel!
    @IBOutlet weak var lblSharedPostType : UILabel!
    
    @IBOutlet weak var btnProfileImg : UIButton!
    @IBOutlet weak var btnUserName : UIButton!

    var refreshControl = UIRefreshControl()
    var forumID : Int?
    var forumIDNew : String?
    var arrCommentList = [[String:Any]]()
    var forumInformation = [String:Any]()
    var apiTask : URLSessionTask?
    var pageNumber = 1
    var likeCount = 0
    var commentCount = 0
    var editCommentId : Int? = nil
    var totalComment = 0
    var like =  0
    var info = [String:Any]()
    var commentinfo = [String:Any]()
    var likeTotalCount = 0
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
        self.btnShare.isHidden = true
        self.btnShare.setTitle(CBtnShare, for: .normal)
        self.lblForumType.text = CTypeForum
        
        GCDMainThread.async {
            self.imgUser.layer.cornerRadius = self.imgUser.CViewWidth/2
            self.imgSharedUser.layer.cornerRadius = self.imgSharedUser.frame.size.width / 2
            self.imgSharedUser.layer.borderWidth = 2
            self.imgSharedUser.layer.borderColor = #colorLiteral(red: 0, green: 0.7881455421, blue: 0.7100172639, alpha: 1)
            self.imgUser.layer.borderWidth = 2
            self.imgUser.layer.borderColor = #colorLiteral(red: 0, green: 0.7881455421, blue: 0.7100172639, alpha: 1)
            
            self.imgUserGIF.layer.cornerRadius = self.imgUserGIF.frame.size.width / 2
            self.imgUserGIF.layer.borderWidth = 2
            self.imgUserGIF.layer.borderColor = #colorLiteral(red: 0, green: 0.7881455421, blue: 0.7100172639, alpha: 1)
            
            self.imgSharedUserGIF.layer.cornerRadius = self.imgSharedUserGIF.frame.size.width / 2
            self.imgSharedUserGIF.layer.borderWidth = 2
            self.imgSharedUserGIF.layer.borderColor = #colorLiteral(red: 0, green: 0.7881455421, blue: 0.7100172639, alpha: 1)

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
        self.parentView.isHidden = true
        if let forID = self.forumID {
            guard let userid = appDelegate.loginUser?.user_id else { return }
            APIRequest.shared().viewPostDetailLatest(postID: forID, userid: userid.description, apiKeyCall: CAPITagforumsDetials){ [weak self] (response, error) in
                guard let self = self else { return }
                if response != nil {
                    self.parentView.isHidden = false
                    if let Info = response!["data"] as? [[String:Any]]{
                        for _ in Info {
                            self.openUserProfileScreen()
                        }
                    }
                }
                self.getCommentListFromServer()
            }
        }
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
            
            forumInformation = forInfo
            notificationInfo = forInfo
            self.forumIDNew = forumInformation.valueForString(key:CPostId)
//            posted_ID = forumInformation.valueForString(key: "user_id")
            
            if isLikesOthersPage == true {
                posted_ID = self.posted_IDOthers
            }else {
                posted_ID = forumInformation.valueForString(key: "user_id")
            }
            //if let sharedData = forInfo[CSharedPost] as? [String:Any]{
                self.lblSharedUserName.text = forInfo.valueForString(key: CFullName) + " " + forInfo.valueForString(key: CLastName)
                //self.lblSharedPostDate.text = DateFormatter.dateStringFrom(timestamp: forInfo.valueForDouble(key: CCreated_at), withFormate: CreatedAtPostDF)
            let shared_created_at = forInfo.valueForString(key: CShared_Created_at)
                       let shared_cnv_date = shared_created_at.stringBefore("G")
                       let sharedCreated = DateFormatter.shared().convertDatereversLatest(strDate: shared_cnv_date)
                       lblSharedPostDate.text = sharedCreated
//                imgSharedUser.loadImageFromUrl(forInfo.valueForString(key: CUserSharedProfileImage), true)
            
            let imgExtShared = URL(fileURLWithPath:forInfo.valueForString(key: CUserSharedProfileImage)).pathExtension
            
            if imgExtShared == "gif"{
                        print("-----ImgExt\(imgExtShared)")
                        
                imgSharedUser.isHidden  = true
                        self.imgSharedUserGIF.isHidden = false
                        self.imgSharedUserGIF.sd_setImage(with: URL(string:forInfo.valueForString(key: CUserSharedProfileImage)), completed: nil)
                self.imgSharedUserGIF.sd_cacheFLAnimatedImage = false
                        
                    }else {
                        self.imgSharedUserGIF.isHidden = true
                        imgSharedUser.isHidden  = false
                        imgSharedUser.loadImageFromUrl(forInfo.valueForString(key: CUserSharedProfileImage), true)
                        _ = appDelegate.loginUser?.total_friends ?? 0
                    }
            
            
            let str_Back_desc_share = forInfo.valueForString(key: CMessage).return_replaceBack(replaceBack: forInfo.valueForString(key: CMessage))
             lblMessage.text = str_Back_desc_share
              //  lblMessage.text = forInfo.valueForString(key: CMessage)
            //}
            self.lblUserName.text = forInfo.valueForString(key: CFirstname) + " " + forInfo.valueForString(key: CLastname)
            //self.lblForumPostDate.text = DateFormatter.dateStringFrom(timestamp: forInfo.valueForDouble(key: CCreated_at), withFormate: CreatedAtPostDF)
            let created_At = forInfo.valueForString(key: CCreated_at)
                        let cnvStr = created_At.stringBefore("G")
                        let startCreated = DateFormatter.shared().convertDatereversLatest(strDate: cnvStr)
            lblForumPostDate.text = startCreated
            let str_Back_title = forInfo.valueForString(key: CTitle).return_replaceBack(replaceBack: forInfo.valueForString(key: CTitle))
            self.lblForumTitle.text = str_Back_title
              let str_Back_desc = forInfo.valueForString(key: CContent).return_replaceBack(replaceBack: forInfo.valueForString(key: CContent))
            self.lblForumDescription.text = str_Back_desc
           // self.lblForumTitle.text = forInfo.valueForString(key: CTitle)
           // self.lblForumDescription.text = forInfo.valueForString(key: CContent)
            //self.imgUser.loadImageFromUrl(forInfo.valueForString(key: CUserProfileImage), true)
            
            let imgExt = URL(fileURLWithPath:forInfo.valueForString(key: CUserProfileImage)).pathExtension
            
            
            if imgExt == "gif"{
                        print("-----ImgExt\(imgExt)")
                        
                imgUser.isHidden  = true
                        self.imgUserGIF.isHidden = false
                        self.imgUserGIF.sd_setImage(with: URL(string:forInfo.valueForString(key: CUserProfileImage)), completed: nil)
                self.imgUserGIF.sd_cacheFLAnimatedImage = false
                        
                    }else {
                        self.imgUserGIF.isHidden = true
                        imgUser.isHidden  = false
                        self.imgUser.loadImageFromUrl(forInfo.valueForString(key: CUserProfileImage), true)
                        _ = appDelegate.loginUser?.total_friends ?? 0
                    }
            
           
            self.lblForumCategory.text = forInfo.valueForString(key: CCategory).uppercased()
//            self.btnLike.isSelected = forInfo.valueForInt(key: CIs_Like) == 1
            
//            likeCount = forInfo.valueForInt(key: CTotal_like) ?? 0
            
            if isLikesOthersPage == true {
                if forInfo.valueForString(key:"friend_liked") == "Yes"  && forInfo.valueForString(key:"is_liked") == "Yes" {
                    btnLike.isSelected = true
                    if forInfo.valueForString(key:"is_liked") == "No"{
                        isLikeSelected = false
                    }
                }else {
                    if forInfo.valueForString(key:"is_liked") == "No" && forInfo.valueForString(key:"friend_liked") == "No" {
                        isLikeSelected = true
                    }
                    btnLike.isSelected = false
                }
                
                if forInfo.valueForString(key:"is_liked") == "Yes" && forInfo.valueForString(key:"friend_liked") == "No" {
                    isLikeSelected = true
                    btnLike.isSelected = false
                }else if forInfo.valueForString(key:"is_liked") == "No" && forInfo.valueForString(key:"friend_liked") == "Yes"{
                    
                    isLikeSelected = false
                    btnLike.isSelected = true

                }
            }
            
            
            if isLikesHomePage == true  || isLikesMyprofilePage == true {
                if forInfo.valueForString(key:CIs_Liked) == "Yes"{
                    btnLike.isSelected = true
                }else {
                    btnLike.isSelected = false
                }
            }
            likeCount = forumInformation.valueForString(key: CLikes).toInt ?? 0
            self.btnLikeCount.setTitle(appDelegate.getLikeString(like: likeCount), for: .normal)
            commentCount = forumInformation.valueForString(key: "comments").toInt ?? 0
            self.totalComment = commentCount
            btnComment.setTitle(appDelegate.getCommentCountString(comment: commentCount), for: .normal)

            self.tblCommentList.updateHeaderViewHeight()
        }
    }
    
    fileprivate func deleteForumPost(_ fourmInfo : [String : Any]?){
        
        if let forID = self.forumID{
            
            self.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: CMessageDeletePost, btnOneTitle: CBtnYes, btnOneTapped: { [weak self] (alert) in
                guard let self = self else { return }
                
                let postTypeDelete = "post_forum"
                let dict = [
                    "post_id": fourmInfo?.valueForString(key: "post_id"),
                    "image": "",
                    "post_title":  fourmInfo?.valueForString(key: "post_title"),
                    "post_category":  fourmInfo?.valueForString(key: "post_category"),
                    "post_content":  fourmInfo?.valueForString(key: "post_content"),
                    "age_limit":  fourmInfo?.valueForString(key: "age_limit"),
                    "targeted_audience": fourmInfo?.valueForString(key: "targeted_audience"),
                    "selected_persons": fourmInfo?.valueForString(key: "selected_persons"),
                    "status_id": "3"
                ]
                APIRequest.shared().deletePostNew(postDetials: dict as [String : Any], apiKeyCall: postTypeDelete, completion: { [weak self](response, error) in
                    
                    guard let self = self else { return }
                    if response != nil && error == nil{
                        self.navigationController?.popViewController(animated: true)
                        MIGeneralsAPI.shared().refreshPostRelatedScreens(nil, forID, self, .deletePost, rss_id: 0)
                    }
                })
            }, btnTwoTitle: CBtnNo, btnTwoTapped: nil)
        }
    }
    
    fileprivate func getCommentListFromServer(){
        if let forID = self.forumIDNew{
            
            if apiTask?.state == URLSessionTask.State.running {
                self.refreshControl.endRefreshing()
                return
            }
            // Add load more indicator here...
            self.tblCommentList.tableFooterView = self.pageNumber > 2 ? self.loadMoreIndicator(ColorAppTheme) : UIView()
            self.arrCommentList.removeAll()
            apiTask = APIRequest.shared().getProductCommentLists(page: pageNumber, showLoader: false, productId:forID) { [weak self] (response, error) in
                guard let self = self else { return }
                self.tblCommentList.tableFooterView = UIView()
                self.apiTask?.cancel()
                self.refreshControl.endRefreshing()
                if response != nil {
                    
                    if let arrList = response!["comments"] as? [[String:Any]] {
                        
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
            weak var weakCell = cell
            let commentInfo = arrCommentList[indexPath.row]
            let timeStamp = DateFormatter.shared().getDateFromTimeStamp(timeStamp:commentInfo.valueForString(key: "updated_at").toDouble ?? 0.0)
            cell.lblCommentPostDate.text = timeStamp
            cell.lblUserName.text = commentInfo.valueForString(key: CFirstname) + " " + commentInfo.valueForString(key: CLastname)
            //cell.imgUser.loadImageFromUrl(commentInfo.valueForString(key: CUserProfileImage), true)
            
            let imgExt = URL(fileURLWithPath:commentInfo.valueForString(key: CUserProfileImage)).pathExtension
            if imgExt == "gif"{
                        print("-----ImgExt\(imgExt)")
                        
                cell.imgUser.isHidden  = true
                cell.imgUserGIF.isHidden = false
                cell.imgUserGIF.sd_setImage(with: URL(string:commentInfo.valueForString(key: CUserProfileImage)), completed: nil)
                cell.imgUserGIF.sd_cacheFLAnimatedImage = false
                        
                    }else {
                        cell.imgUserGIF.isHidden = true
                        cell.imgUser.isHidden  = false
                        cell.imgUser.loadImageFromUrl(commentInfo.valueForString(key: CUserProfileImage), true)
                        _ = appDelegate.loginUser?.total_friends ?? 0
                    }
            
           // var commentText = commentInfo.valueForString(key: "comment")
            let str_Back_comment = commentInfo.valueForString(key: "comment").return_replaceBack(replaceBack:commentInfo.valueForString(key: "comment"))
            var commentText = str_Back_comment
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
                            appDelegate.moveOnProfileScreenNew(self.forumInformation.valueForString(key: CUserId), self.forumInformation.valueForString(key: CUsermailID), self)
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
                    atts[NSAttributedString.Key.font] = CFontPoppins(size: weakCell?.lblCommentText.font.pointSize ?? 0, type: .meduim)
                    return atts
                }
            }
            
            cell.btnUserName.touchUpInside { [weak self] (sender) in
                guard let self = self else { return }
                appDelegate.moveOnProfileScreenNew(commentInfo.valueForString(key: CUserId), commentInfo.valueForString(key: CUsermailID), self)
            }
            
            cell.btnUserImage.touchUpInside { [weak self] (sender) in
                guard let self = self else { return }
                appDelegate.moveOnProfileScreenNew(commentInfo.valueForString(key: CUserId), commentInfo.valueForString(key: CUsermailID), self)
            }
            
            // Load more data....
            //if (indexPath == tblCommentList.lastIndexPath()) && apiTask?.state != URLSessionTask.State.running {
            // self.getCommentListFromServer()
            //  }
            
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
                let strComment = viewUserSuggestion.stringToBeSendInComment(txtViewComment)?.replace_str(replace: viewUserSuggestion.stringToBeSendInComment(txtViewComment) ?? "")
                
                // Get Mention user's Ids..
                let includedUser = viewUserSuggestion.arrSelectedUser.map({$0.valueForString(key: CUserId) }).joined(separator: ",")
                
                guard let userID = appDelegate.loginUser?.user_id else{return}
                let userId = userID.description
                APIRequest.shared().sendProductCommentnew(productId:forId.description, commentId : self.editCommentId, comment: strComment, include_user_id: userId)  { [weak self] (response, error) in
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
                                    self.getCommentListFromServer()
                                    let comment_data = comments["comments"] as? String
                                    self.commentCount = comment_data?.toInt ?? 0
                                    self.btnComment.setNormalTitle(normalTitle: appDelegate.getCommentCountString(comment: self.commentCount))
                                    MIGeneralsAPI.shared().refreshPostRelatedScreens(self.commentinfo, forId, self, .commentPost, rss_id: 0)
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
                            guard let lastName = appDelegate.loginUser?.last_name else {return}
                            let stausLike = data["status"] as? String ?? "0"
                            if self.posted_ID != userID.description {
                                
                                self.notificationInfo["comments"] = self.commentCount
                                MIGeneralsAPI.shared().sendNotification(self.posted_ID, userID: userId, subject: "Commented on your Post", MsgType: "COMMENT", MsgSent: "", showDisplayContent: "Commented on your Post", senderName: firstName + lastName, post_ID: self.notificationInfo, shareLink: "shareComment")
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
                DispatchQueue.main.async {
                    self.deleteForumPost(self.forumInformation)
                }
            }
        }else{
            let sharePostData = forumInformation[CSharedPost] as? [String:Any] ?? [:]
            if let reportVC = CStoryboardGeneral.instantiateViewController(withIdentifier: "ReportViewController") as? ReportViewController {
                reportVC.reportType = .reportForum
                reportVC.isSharedPost = true
//                reportVC.userID = sharePostData.valueForInt(key: CUserId)
//                reportVC.reportID = sharePostData.valueForInt(key: CId)
                
                reportVC.userID = forumInformation.valueForInt(key: CUserId)
                reportVC.reportID = self.forumID
                reportVC.reportIDNEW = forumInformation.valueForString(key: "post_id")
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
        
        
        guard let userID = appDelegate.loginUser?.user_id else {
            return
        }
        APIRequest.shared().likeUnlikeProducts(userId: Int(userID), productId: (self.forumIDNew)?.toInt ?? 0 , isLike: likeCount){ [weak self](response, error) in
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
                        self?.likeCountfromSever(productId: self?.forumIDNew?.toInt ?? 0,likeCount:self?.likeCount ?? 0, postInfo: self?.info ?? [:],like:self?.like ?? 0)
                    }
                }
            }
        }
    }else{
        if let likeVC = CStoryboardGeneral.instantiateViewController(withIdentifier: "LikeViewController") as? LikeViewController{
            //likeVC.postID = self.shoutID
            likeVC.postIDNew = self.forumIDNew
            self.navigationController?.pushViewController(likeVC, animated: true)
        }
    }
    }
    
    func likeCountfromSever(productId: Int,likeCount:Int,postInfo:[String:Any],like:Int){
        APIRequest.shared().likeUnlikeProductCount(productId: self.forumIDNew?.toInt ?? 0 ){ [weak self](response, error) in
            guard let _ = self else { return }
            if response != nil {
                GCDMainThread.async { [self] in
                    self?.likeTotalCount = response?["likes_count"] as? Int ?? 0
                    self?.btnLikeCount.setTitle(appDelegate.getLikeString(like: self?.likeTotalCount ?? 0), for: .normal)
                    guard let user_ID = appDelegate.loginUser?.user_id.description else { return }
                    guard let firstName = appDelegate.loginUser?.first_name else {return}
                    guard let lastName = appDelegate.loginUser?.last_name else {return}
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
                        MIGeneralsAPI.shared().sendNotification(self?.posted_ID, userID: user_ID, subject: "liked your Post", MsgType: "COMMENT", MsgSent: "", showDisplayContent: "liked your Post", senderName: firstName + lastName, post_ID: self?.notificationInfo ?? [:],shareLink: "shareLikes")
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
                        MIGeneralsAPI.shared().likeUnlikePostWebsites(post_id:self?.forumIDNew?.toInt, rss_id: 1, type: 1, likeStatus: self?.like ?? 0 ,info:postInfo, viewController: self)
                        self?.isLikeSelected = false
                    }else {
                        MIGeneralsAPI.shared().likeUnlikePostWebsites(post_id: self?.forumIDNew?.toInt, rss_id: 2, type: 1, likeStatus: self?.like ?? 0 ,info:postInfo, viewController: self)

                    }
                   }
                    if  self?.isLikesHomePage == true || self?.isLikesMyprofilePage == true {
                    MIGeneralsAPI.shared().likeUnlikePostWebsites(post_id: self?.forumIDNew?.toInt, rss_id: 3, type: 1, likeStatus: self?.like ?? 0 ,info:postInfo, viewController: self)
                    }
                    
//                    MIGeneralsAPI.shared().likeUnlikePostWebsites(post_id: self?.forumIDNew?.toInt ?? 0, rss_id: 0, type: 1, likeStatus: self?.like ?? 0 ,info:postInfo, viewController: self)
                }
            }
        }
    }
    
    @IBAction func btnShareReportCLK(_ sender : UIButton){
       // self.presentActivityViewController(mediaData: forumInformation.valueForString(key: CShare_url), contentTitle: CSharePostContentMsg)
        let sharePost = SharePostHelper(controller: self, dataSet: forumInformation)
        sharePost.shareURL = forumInformation.valueForString(key: CShare_url)
        sharePost.presentShareActivity()
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
        let str_Back_comment = commentInfo.valueForString(key: "comment").return_replaceBack(replaceBack:commentInfo.valueForString(key: "comment"))
        var strComment = str_Back_comment
       // let strComment = commentInfo.valueForString(key: "comment")
        guard let userID = appDelegate.loginUser?.user_id else{return}
        let userId = userID.description
        APIRequest.shared().deleteProductCommentNew(productId:forumIDNew ?? "", commentId : commentId, comment: strComment, include_user_id: userId)  { [weak self] (response, error) in
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
                    MIGeneralsAPI.shared().refreshPostRelatedScreens(nil,self.forumIDNew?.toInt ?? 0 , self, .deleteComment, rss_id: 0)
                }
            }
        }
    }
}

