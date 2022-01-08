//
//  ChirpyImageDetailsViewController.swift
//  Sevenchats
//
//  Created by mac-0005 on 17/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit
import ActiveLabel
import Lightbox

class ChirpyImageDetailsViewController: ParentViewController {
    
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
    @IBOutlet weak var viewCommentContainer : UIView!
    @IBOutlet weak var btnSend : UIButton!
    @IBOutlet weak var btnLike : UIButton!
    @IBOutlet weak var btnLikeCount : UIButton!
    @IBOutlet weak var btnComment : UIButton!
    @IBOutlet weak var btnShare : UIButton!
    @IBOutlet weak var lblUserName : UILabel!
    @IBOutlet weak var lblChirpyPostDate : UILabel!
    @IBOutlet weak var lblChirpyCategory : UILabel!
    @IBOutlet weak var lblChirpyDescription : UILabel!
    @IBOutlet weak var lblChirpyType : UILabel!
    @IBOutlet weak var imgUser : UIImageView!
    @IBOutlet weak var txtViewComment : GenericTextView!
    
    //@IBOutlet weak var imgChirpy : UIImageView!
    @IBOutlet weak var blurImgView : BlurImageView!
    @IBOutlet weak var cnTextViewHeight : NSLayoutConstraint!
    @IBOutlet weak var btnChirpyImg : UIButton!
    var chirpyImgURL = ""
    
    var likeCount = 0
    var commentCount = 0
    var editCommentId : Int? = nil
    var like =  0
    var info = [String:Any]()
    var commentinfo = [String:Any]()
    var likeTotalCount = 0
    var totalComment = 0
    var posted_ID = ""
    var profileImg = ""
    var notifcationIsSlected = false 
    
    // Set for User suggestion view...
    @IBOutlet fileprivate weak var viewUserSuggestion : UserSuggestionView! {
        didSet {
            viewUserSuggestion.userSuggestionDelegate = self
            viewUserSuggestion.initialization()
        }
    }
    
    @IBOutlet weak var btnProfileImg : UIButton!
    @IBOutlet weak var btnUserName : UIButton!
    
    var refreshControl = UIRefreshControl()
    var apiTask : URLSessionTask?
    var arrCommentList = [[String:Any]]()
    var chirpyInformation = [String:Any]()
    var chirpyInformations = [String:Any]()
    var chirpyID : Int?
    var chirpyIDNew :String?
    var pageNumber = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Initialization()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setChirpyDetailData(chirpyInformation)
        self.updateUIAccordingToLanguage()
        
    }
    
    // MARK:- --------- Initialization
    func Initialization(){
        self.title = CNavChirpyDetails
        self.view.backgroundColor = CRGB(r: 249, g: 250, b: 250)
        self.parentView.backgroundColor = .clear
        self.tblCommentList.backgroundColor = .clear
        self.btnShare.setTitle(CBtnShare, for: .normal)
        self.lblChirpyType.text = CTypeChirpy
        
        GCDMainThread.async {
            self.imgUser.layer.cornerRadius = self.imgUser.CViewWidth/2
            self.viewCommentContainer.shadow(color: ColorAppTheme, shadowOffset: CGSize(width: 0, height: 5), shadowRadius: 10.0, shadowOpacity: 10.0)
            self.lblChirpyType.layer.cornerRadius = 3
        }
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: #imageLiteral(resourceName: "ic_btn_nav_more"), style: .plain, target: self, action: #selector(self.btnMenuClicked(_:)))]
        
        self.refreshControl.addTarget(self, action: #selector(self.pullToRefresh), for: .valueChanged)
        self.refreshControl.tintColor = ColorAppTheme
        self.tblCommentList.pullToRefreshControl = self.refreshControl
        self.pageNumber = 1
        
        self.getChirpyDetailsFromServer()
        
        self.btnChirpyImg.touchUpInside(genericTouchUpInsideHandler: { [weak self](_) in
            let lightBoxHelper = LightBoxControllerHelper()
            lightBoxHelper.openSingleImage(image: self?.blurImgView?.image, viewController: self)
        })
        
        
        
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
        txtViewComment.placeHolder = CMessageTypeYourMessage
        txtViewComment.type = "1"
    }
}

// MARK:- --------- Api Functions
extension ChirpyImageDetailsViewController{
    
    @objc func pullToRefresh() {
        if apiTask?.state == URLSessionTask.State.running {
            apiTask?.cancel()
        }
        
        self.pageNumber = 1
        refreshControl.beginRefreshing()
        self.getChirpyDetailsFromServer()
    }
    
    fileprivate func getChirpyDetailsFromServer() {
        
        self.parentView.isHidden = true
        if let chirID = self.chirpyID {
            
            
            APIRequest.shared().viewPostDetailNew(postID: chirID, apiKeyCall: CAPITagchirpiesDetials){ [weak self] (response, error) in
                //  APIRequest.shared().viewPostDetail(postID: shouID) { [weak self] (response, error) in
                guard let self = self else { return }
                if response != nil {
                    self.parentView.isHidden = false
                    if let Info = response!["data"] as? [[String:Any]]{
                        
                        print(Info as Any)
                        for chirpInfo in Info {
                            
                            //                                self.setChirpyDetailData(self.chirpyInformation)
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
            appDelegate.moveOnProfileScreenNew(self.chirpyInformation.valueForString(key: CUserId), self.chirpyInformation.valueForString(key: CUsermailID), self)
        }
        
        self.btnUserName.touchUpInside { [weak self] (sender) in
            guard let self = self else { return }
            appDelegate.moveOnProfileScreenNew(self.chirpyInformation.valueForString(key: CUserId), self.chirpyInformation.valueForString(key: CUsermailID), self)
        }
    }
    
    func setChirpyDetailData(_ chirpyInfo : [String : Any]?){
        if let chirInfo = chirpyInfo{
            chirpyInformation = chirInfo
            self.chirpyIDNew = chirInfo.valueForString(key:CPostId)
            posted_ID = chirInfo.valueForString(key: "user_id")
            self.lblUserName.text = chirInfo.valueForString(key: CFirstname) + " " + chirInfo.valueForString(key: CLastname)
            self.lblChirpyDescription.text = chirInfo.valueForString(key: CContent)
            self.imgUser.loadImageFromUrl(chirInfo.valueForString(key: CUserProfileImage), true)
            let image = chirInfo.valueForString(key: "image")
            if image.isEmpty {
                blurImgView.heightAnchor.constraint(equalToConstant: CGFloat(0)).isActive = true
            }else{
                blurImgView.loadImageFromUrl(chirInfo.valueForString(key: Cimages), false)
            }
            self.chirpyImgURL = chirInfo.valueForString(key: "image")
            self.lblChirpyCategory.text = chirInfo.valueForString(key: CCategory)
            commentCount = chirInfo.valueForString(key: "comments").toInt ?? 0
            self.totalComment = commentCount
            btnComment.setTitle(appDelegate.getCommentCountString(comment: commentCount), for: .normal)
            self.tblCommentList.updateHeaderViewHeight(extxtraSpace: 0)
            
            let is_Liked = chirInfo.valueForString(key: CIsLiked)
            
            if is_Liked == "Yes"{
                btnLike.isSelected = true
            }else {
                btnLike.isSelected = false
            }
            
            self.tblCommentList.updateHeaderViewHeight(extxtraSpace: 0)
            let created_At = chirInfo.valueForString(key: CCreated_at)
            let cnvStr = created_At.stringBefore("G")
            //            let removeFrst = cnvStr.chopPrefix(3)
            let startCreated = DateFormatter.shared().convertDatereversLatest(strDate: cnvStr)
            lblChirpyPostDate.text = startCreated
            
            likeCount = chirInfo.valueForString(key: CLikes).toInt ?? 0
            self.btnLikeCount.setTitle(appDelegate.getLikeString(like: likeCount), for: .normal)
            
            
        }
        
    }
    
    //MARK:- NEW CODE
    
    fileprivate func deleteChirpyPost(_ chirpyInfo : [String : Any]?){
        
        if let chirID = self.chirpyID{
            self.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: CMessageDeletePost, btnOneTitle: CBtnYes, btnOneTapped: { [weak self] (alert) in
                
                let postTypeDelete = "post_chirpy"
                let dict =
                    [
                        "post_id": chirpyInfo?.valueForString(key: "post_id"),
                        "image":chirpyInfo?.valueForString(key: "image"),
                        "post_title": chirpyInfo?.valueForString(key: "post_title"),
                        "post_category": chirpyInfo?.valueForString(key: "post_category"),
                        "post_content": chirpyInfo?.valueForString(key: "post_title"),
                        "age_limit": chirpyInfo?.valueForString(key: "age_limit"),
                        "targeted_audience": chirpyInfo?.valueForString(key: "targeted_audience"),
                        "selected_persons": chirpyInfo?.valueForString(key: "selected_persons"),
                        "status_id": "3"
                    ]
                
                
                guard let self = self else { return }
                APIRequest.shared().deletePostNew(postDetials: dict, apiKeyCall: postTypeDelete, completion: { [weak self](response, error) in
                    guard let self = self else { return }
                    if response != nil && error == nil{
                        self.navigationController?.popViewController(animated: true)
                        MIGeneralsAPI.shared().refreshPostRelatedScreens(nil, chirID, self, .deletePost)
                        
                    }
                })
                
            }, btnTwoTitle: CBtnNo, btnTwoTapped: nil)
        }
    }
    
    
    fileprivate func getCommentListFromServer(){
        if let chirID = self.chirpyIDNew{
            
            if apiTask?.state == URLSessionTask.State.running {
                self.refreshControl.endRefreshing()
                return
            }
            
            // Add load more indicator here...
            self.tblCommentList.tableFooterView = self.pageNumber > 2 ? self.loadMoreIndicator(ColorAppTheme) : UIView()
            
            apiTask = APIRequest.shared().getProductCommentLists(page: pageNumber, showLoader: false, productId:chirID) { [weak self] (response, error) in
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
    
    func updateChirpyCommentSection(_ arrComm : [[String : Any]], _ totalComment : Int){
        
    }
}
// MARK:- --------- UITableView Datasources/Delegate
extension ChirpyImageDetailsViewController: UITableViewDelegate, UITableViewDataSource{
    
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
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTblCell", for: indexPath) as? CommentTblCell
        {
            weak var weakCell = cell
            let commentInfo = arrCommentList[indexPath.row]
            //            cell.lblCommentPostDate.text = DateFormatter.shared().durationString(duration: commentInfo.valueForString(key: CCreated_at))
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
                    
                    cell.lblCommentText.handleCustomTap(for: customTypeUserName, handler: { [weak self] (name) in
                        guard let self = self else { return }
                        print(name)
                        let arrSelectedUser = arrIncludedUsers.filter({$0[CFullName] as? String == name})
                        
                        if arrSelectedUser.count > 0 {
                            let userSelectedInfo = arrSelectedUser[0]
                            //                            appDelegate.moveOnProfileScreen(userSelectedInfo.valueForString(key: CUserId), self)
                            appDelegate.moveOnProfileScreenNew(self.chirpyInformation.valueForString(key: CUserId), self.chirpyInformation.valueForString(key: CUsermailID), self)
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
                //                appDelegate.moveOnProfileScreen(commentInfo.valueForString(key: CUserId), self)
                appDelegate.moveOnProfileScreenNew(self.chirpyInformation.valueForString(key: CUserId), self.chirpyInformation.valueForString(key: CUsermailID), self)
            }
            
            cell.btnUserImage.touchUpInside { [weak self] (sender) in
                guard let self = self else { return }
                //                appDelegate.moveOnProfileScreen(commentInfo.valueForString(key: CUserId), self)
                appDelegate.moveOnProfileScreenNew(self.chirpyInformation.valueForString(key: CUserId), self.chirpyInformation.valueForString(key: CUsermailID), self)
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
extension ChirpyImageDetailsViewController: GenericTextViewDelegate{
    
    func genericTextViewDidChange(_ textView: UITextView, height: CGFloat)
    {
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
extension ChirpyImageDetailsViewController: UserSuggestionDelegate{
    func didSelectSuggestedUser(_ userInfo: [String : Any]) {
        viewUserSuggestion.arrangeFinalComment(userInfo, textView: txtViewComment)
    }
}

// MARK:-  --------- Action Event
extension ChirpyImageDetailsViewController{
    @IBAction func btnSendCommentCLK(_ sender : UIButton){
        self.resignKeyboard()
        
        if (txtViewComment.text?.isBlank)!{
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageCommentBlank, btnOneTitle: CBtnOk, btnOneTapped: nil)
        }else{
            
            if let shoId = self.chirpyID{
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
                                    self.getCommentListFromServer()
                                    let comment_data = comments["comments"] as? String
                                    self.commentCount = comment_data?.toInt ?? 0
                                    self.btnComment.setNormalTitle(normalTitle: appDelegate.getCommentCountString(comment: self.commentCount))
                                    MIGeneralsAPI.shared().refreshPostRelatedScreens(self.commentinfo, shoId, self, .commentPost)
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
                            if stausLike == "0" {
                                guard let firstName = appDelegate.loginUser?.first_name else {return}
                                guard let lastName = appDelegate.loginUser?.last_name else {return}
                                MIGeneralsAPI.shared().sendNotification(self.posted_ID, userID: userId, subject: "Comment to Post Chirpy", MsgType: "COMMENT", MsgSent: "", showDisplayContent: "Comment to Post Chirpy", senderName: firstName + lastName)
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
    }
    
    @objc fileprivate func btnMenuClicked(_ sender : UIBarButtonItem) {
        
        if chirpyInformation.valueForString(key: "user_email") == appDelegate.loginUser?.email{
            self.presentActionsheetWithOneButton(actionSheetTitle: nil, actionSheetMessage: nil, btnOneTitle: CBtnDelete, btnOneStyle: .default) { [weak self] (_) in
                guard let _ = self else {return}
                DispatchQueue.main.async {
                    self?.deleteChirpyPost(self?.chirpyInformation)
                }
            }
        }else {
            if let reportVC = CStoryboardGeneral.instantiateViewController(withIdentifier: "ReportViewController") as? ReportViewController {
                reportVC.reportType = .reportChirpy
                reportVC.userID = chirpyInformation.valueForInt(key: CUserId)
                reportVC.reportID = self.chirpyID
                reportVC.reportIDNEW = chirpyInformation.valueForString(key: "email")
                self.navigationController?.pushViewController(reportVC, animated: true)
            }
        }
        
    }
    
    @IBAction func btnLikeCLK(_ sender : UIButton){
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
        APIRequest.shared().likeUnlikeProducts(userId: Int(userID), productId: (self.chirpyIDNew)?.toInt ?? 0 , isLike: likeCount){ [weak self](response, error) in
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
                        self?.likeCountfromSever(productId: self?.chirpyIDNew?.toInt ?? 0,likeCount:self?.likeCount ?? 0, postInfo: self?.info ?? [:],like:self?.like ?? 0)
                    }
                }
            }
        }
    }
    
    func likeCountfromSever(productId: Int,likeCount:Int,postInfo:[String:Any],like:Int){
        APIRequest.shared().likeUnlikeProductCount(productId: self.chirpyIDNew?.toInt ?? 0 ){ [weak self](response, error) in
            guard let _ = self else { return }
            if response != nil {
                GCDMainThread.async { [self] in
                    //                    info = response!["liked_users"] as? [String:Any] ?? [:]
                    self?.likeTotalCount = response?["likes_count"] as? Int ?? 0
                    self?.btnLikeCount.setTitle(appDelegate.getLikeString(like: self?.likeTotalCount ?? 0), for: .normal)
                    guard let user_ID = appDelegate.loginUser?.user_id.description else { return }
                    if self?.notifcationIsSlected == true{
                        guard let firstName = appDelegate.loginUser?.first_name else {return}
                        guard let lastName = appDelegate.loginUser?.last_name else {return}
                        MIGeneralsAPI.shared().sendNotification(self?.posted_ID, userID: user_ID, subject: "liked your Post Chirpy", MsgType: "COMMENT", MsgSent: "", showDisplayContent: "liked your Post Chirpy", senderName: firstName + lastName)
                        self?.notifcationIsSlected = false
                    }
                    MIGeneralsAPI.shared().likeUnlikePostWebsites(post_id: self?.chirpyIDNew?.toInt ?? 0, rss_id: 0, type: 1, likeStatus: self?.like ?? 0 ,info:postInfo, viewController: self)
                }
            }
        }
    }
    
    @IBAction func btnShareReportCLK(_ sender : UIButton){
        let sharePost = SharePostHelper(controller: self, dataSet: chirpyInformation)
        sharePost.shareURL = chirpyInformation.valueForString(key: CShare_url)
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
        let strComment = commentInfo.valueForString(key: "comment")
        guard let userID = appDelegate.loginUser?.user_id else{
            return
        }
        let userId = userID.description
        APIRequest.shared().deleteProductCommentNew(productId:chirpyIDNew ?? "", commentId : commentId, comment: strComment, include_user_id: userId)  { [weak self] (response, error) in
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
                    MIGeneralsAPI.shared().refreshPostRelatedScreens(nil,self.chirpyIDNew?.toInt ?? 0 , self, .deleteComment)
                }
            }
        }
    }
}
