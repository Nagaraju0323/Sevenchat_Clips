//
//  ChirpySharedImageDetailsViewController.swift
//  Sevenchats
//
//  Created by mac-0005 on 17/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Chandrika.R                                 *
 * Model   : ChirpySharedImageDetailsViewController      *
 * Changes :                                             *
 *                                                       *
 ********************************************************/

import UIKit
import ActiveLabel
import Lightbox

class ChirpySharedImageDetailsViewController: ParentViewController {
    
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
    @IBOutlet weak var cnTextViewHeight : NSLayoutConstraint!
    //@IBOutlet weak var imgChirpy : UIImageView!
    @IBOutlet weak var blurImgView : BlurImageView!
    
    @IBOutlet weak var btnChirpyImg : UIButton!
    var chirpyImgURL = ""
    
    var likeCount = 0
    var commentCount = 0
    var editCommentId : Int? = nil
    
    // Set for User suggestion view...
    @IBOutlet fileprivate weak var viewUserSuggestion : UserSuggestionView! {
        didSet {
            viewUserSuggestion.userSuggestionDelegate = self
            viewUserSuggestion.initialization()
        }
    }
    @IBOutlet weak var btnProfileImg : UIButton!
    @IBOutlet weak var btnUserName : UIButton!

    @IBOutlet weak var lblSharedPostDate : UILabel!
    @IBOutlet weak var imgSharedUser : UIImageView!
    @IBOutlet weak var lblSharedUserName : UILabel!
    @IBOutlet weak var btnSharedProfileImg : UIButton!
    @IBOutlet weak var btnSharedUserName : UIButton!
    @IBOutlet weak var lblMessage : UILabel!
    @IBOutlet weak var lblSharedPostType : UILabel!
    
    var refreshControl = UIRefreshControl()
    var apiTask : URLSessionTask?
    var arrCommentList = [[String:Any]]()
    var chirpyInformation = [String:Any]()
    
    var chirpyID : Int?
    var pageNumber = 1
    var like =  0
    var info = [String:Any]()
    var commentinfo = [String:Any]()
    var likeTotalCount = 0
    var totalComment = 0
    var posted_ID = ""
    var chirpyId : String?
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
    var chirpyIDNew :String?
    
    
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
        self.setChirpyDetailData(chirpyInformation)
        self.getCommentListFromServer()
        self.openUserProfileScreen()
    }
    
    // MARK:- --------- Initialization
    func Initialization(){
        
        self.title = CNavChirpyDetails
        self.view.backgroundColor = CRGB(r: 249, g: 250, b: 250)
        lblSharedPostType.text = CSharedChirpy
        self.parentView.backgroundColor = .clear
        self.tblCommentList.backgroundColor = .clear
        self.btnShare.setTitle(CBtnShare, for: .normal)
        self.lblChirpyType.text = CTypeChirpy
        
        GCDMainThread.async {
            self.imgUser.layer.cornerRadius = self.imgUser.CViewWidth/2
            self.imgSharedUser.layer.cornerRadius = self.imgSharedUser.frame.size.width / 2
            self.imgSharedUser.layer.borderWidth = 2
            self.imgSharedUser.layer.borderColor = #colorLiteral(red: 0, green: 0.7881455421, blue: 0.7100172639, alpha: 1)
            self.imgUser.layer.borderWidth = 2
            self.imgUser.layer.borderColor = #colorLiteral(red: 0, green: 0.7881455421, blue: 0.7100172639, alpha: 1)

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
            //lightBoxHelper.openSingleImageFromURL(imgURL: self?.chirpyImgURL, viewController: self?.viewController)
            lightBoxHelper.openSingleImage(image: self?.blurImgView?.image, viewController: self?.viewController)
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
    }
}

// MARK:- --------- Api Functions
extension ChirpySharedImageDetailsViewController{
    
    @objc func pullToRefresh() {
        if apiTask?.state == URLSessionTask.State.running {
            apiTask?.cancel()
        }
        
        self.pageNumber = 1
        refreshControl.beginRefreshing()
        self.getChirpyDetailsFromServer()
        self.getCommentListFromServer()
    }
    
    fileprivate func getChirpyDetailsFromServer() {
        
        
        self.parentView.isHidden = true
        
        if let chirID = self.chirpyID {
            APIRequest.shared().viewPostDetailNew(postID: chirID, apiKeyCall: CAPITagchirpiesDetials){ [weak self] (response, error) in
                guard let self = self else { return }
                if response != nil {
                    self.parentView.isHidden = false
                    if let Info = response!["data"] as? [[String:Any]]{
                        for chirpInfo in Info {
                            self.openUserProfileScreen()
                        }
                    }
                }
//                self.getCommentListFromServer()
            }
        }
    }
    
    fileprivate func openUserProfileScreen(){
            
            self.btnSharedProfileImg.touchUpInside { [weak self] (sender) in
                guard let self = self else { return }
                appDelegate.moveOnProfileScreenNew(self.chirpyInformation.valueForString(key: CSharedUserID), self.chirpyInformation.valueForString(key: CSharedEmailID), self)
            }
            
            self.btnSharedUserName.touchUpInside { [weak self] (sender) in
                guard let self = self else { return }
                appDelegate.moveOnProfileScreenNew(self.chirpyInformation.valueForString(key: CSharedUserID), self.chirpyInformation.valueForString(key: CSharedEmailID), self)
            }
            
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
            notificationInfo = chirInfo
            self.chirpyIDNew = chirInfo.valueForString(key:CPostId)
//            posted_ID = chirInfo.valueForString(key: "user_id")
            if isLikesOthersPage == true {
                posted_ID = self.posted_IDOthers
            }else {
                posted_ID = chirInfo.valueForString(key: "user_id")
            }
            chirpyId = chirInfo.valueForString(key: "post_id")
            
           // if let sharedData = chirInfo[CSharedPost] as? [String:Any]{
                self.lblSharedUserName.text = chirInfo.valueForString(key: CFullName) + " " + chirInfo.valueForString(key: CLastName)
                //self.lblSharedPostDate.text = DateFormatter.dateStringFrom(timestamp: chirInfo.valueForDouble(key: CCreated_at), withFormate: CreatedAtPostDF)
            let shared_created_at = chirInfo.valueForString(key: CShared_Created_at)
                       let shared_cnv_date = shared_created_at.stringBefore("G")
                       let sharedCreated = DateFormatter.shared().convertDatereversLatest(strDate: shared_cnv_date)
                       lblSharedPostDate.text = sharedCreated
                imgSharedUser.loadImageFromUrl(chirInfo.valueForString(key: CUserSharedProfileImage), true)
                lblMessage.text = chirInfo.valueForString(key: CMessage)
            //}
            self.lblUserName.text = chirInfo.valueForString(key: CFirstname) + " " + chirInfo.valueForString(key: CLastname)
            //self.lblChirpyPostDate.text = DateFormatter.dateStringFrom(timestamp: chirInfo.valueForDouble(key: CCreated_at), withFormate: CreatedAtPostDF)
            let created_At = chirInfo.valueForString(key: CCreated_at)
                        let cnvStr = created_At.stringBefore("G")
                        let startCreated = DateFormatter.shared().convertDatereversLatest(strDate: cnvStr)
            lblChirpyPostDate.text = startCreated
            self.lblChirpyDescription.text = chirInfo.valueForString(key: CContent)
            let image = chirInfo.valueForString(key: "image")
            if image.isEmpty {
                blurImgView.heightAnchor.constraint(equalToConstant: CGFloat(0)).isActive = true
            }else{
                blurImgView.loadImageFromUrl(chirInfo.valueForString(key: Cimages), false)
            }
            self.chirpyImgURL = chirInfo.valueForString(key: "image")
           self.imgUser.loadImageFromUrl(chirInfo.valueForString(key: CUserProfileImage), true)
//
//            //self.imgChirpy.loadImageFromUrl(chirInfo.valueForString(key: CImage), false)
//            self.blurImgView.loadImageFromUrl(chirInfo.valueForString(key: CImage), false)
            
            self.chirpyImgURL = chirInfo.valueForString(key: CImage)
            self.lblChirpyCategory.text = chirInfo.valueForString(key: CCategory)

//            self.btnLike.isSelected = chirInfo.valueForInt(key: CIs_Like) == 1
//            likeCount = chirInfo.valueForInt(key: CTotal_like) ?? 0
//            self.btnLikeCount.setTitle(appDelegate.getLikeString(like: likeCount), for: .normal)
            if isLikesOthersPage == true {
                if chirInfo.valueForString(key:"friend_liked") == "Yes"  && chirInfo.valueForString(key:"is_liked") == "Yes" {
                    btnLike.isSelected = true
                    if chirInfo.valueForString(key:"is_liked") == "No"{
                        isLikeSelected = false
                    }
                }else {
                    if chirInfo.valueForString(key:"is_liked") == "No" && chirInfo.valueForString(key:"friend_liked") == "No" {
                        isLikeSelected = true
                    }
                    btnLike.isSelected = false
                }
                
                if chirInfo.valueForString(key:"is_liked") == "Yes" && chirInfo.valueForString(key:"friend_liked") == "No" {
                    isLikeSelected = true
                    btnLike.isSelected = false
                }else if chirInfo.valueForString(key:"is_liked") == "No" && chirInfo.valueForString(key:"friend_liked") == "Yes"{
                    isLikeSelected = false
                    btnLike.isSelected = true
                }
            }

            if isLikesHomePage == true  || isLikesMyprofilePage == true {
                if chirInfo.valueForString(key:CIs_Liked) == "Yes"{
                    btnLike.isSelected = true
                }else {
                    btnLike.isSelected = false
                }
            }
            
            likeCount = chirInfo.valueForString(key: CLikes).toInt ?? 0
            self.btnLikeCount.setTitle(appDelegate.getLikeString(like: likeCount), for: .normal)
//            self.commentCount = chirInfo.valueForInt(key: CTotalComment) ?? 0
//            btnComment.setTitle(appDelegate.getCommentCountString(comment: commentCount), for: .normal)
            
            commentCount = chirInfo.valueForString(key: "comments").toInt ?? 0
            self.totalComment = commentCount
            btnComment.setTitle(appDelegate.getCommentCountString(comment: commentCount), for: .normal)
            self.tblCommentList.updateHeaderViewHeight(extxtraSpace: 0)
        }
    }
    
    fileprivate func deleteChirpyPost(_ chirpyInfo : [String : Any]?){
        
        if let chirID = self.chirpyID{
            
            self.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: CMessageDeletePost, btnOneTitle: CBtnYes, btnOneTapped: { [weak self] (alert) in
                
                let postTypeDelete = "post_chirpy"
                let dict = [
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
                APIRequest.shared().deletePostNew(postDetials: dict as [String : Any], apiKeyCall: postTypeDelete, completion: { [weak self](response, error) in
                    guard let self = self else { return }
                    if response != nil && error == nil{
                        self.navigationController?.popViewController(animated: true)
                        MIGeneralsAPI.shared().refreshPostRelatedScreens(nil, chirID, self, .deletePost, rss_id: 0)
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
extension ChirpySharedImageDetailsViewController: UITableViewDelegate, UITableViewDataSource{
    
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
                            _ = arrSelectedUser[0]
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
                appDelegate.moveOnProfileScreenNew(self.chirpyInformation.valueForString(key: CUserId), self.chirpyInformation.valueForString(key: CUsermailID), self)
            }
            
            cell.btnUserImage.touchUpInside { [weak self] (sender) in
                guard let self = self else { return }
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
extension ChirpySharedImageDetailsViewController: GenericTextViewDelegate{
    
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
extension ChirpySharedImageDetailsViewController: UserSuggestionDelegate{
    func didSelectSuggestedUser(_ userInfo: [String : Any]) {
        viewUserSuggestion.arrangeFinalComment(userInfo, textView: txtViewComment)
    }
}

// MARK:-  --------- Action Event
extension ChirpySharedImageDetailsViewController{
    @IBAction func btnSendCommentCLK(_ sender : UIButton){
        self.resignKeyboard()
        
        if (txtViewComment.text?.isBlank)!{
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageCommentBlank, btnOneTitle: CBtnOk, btnOneTapped: nil)
        }else{
            
            if let shoId = self.chirpyID{
                // Get Final text for comment..
                let strComment = viewUserSuggestion.stringToBeSendInComment(txtViewComment)
                
                // Get Mention user's Ids..
                _ = viewUserSuggestion.arrSelectedUser.map({$0.valueForString(key: CUserId) }).joined(separator: ",")
                
                guard let userID = appDelegate.loginUser?.user_id else{return}
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
                            if self.posted_ID != userID.description{
                                
                                guard let firstName = appDelegate.loginUser?.first_name else {return}
                                guard let lastName = appDelegate.loginUser?.last_name else {return}

                                self.notificationInfo["comments"] = self.commentCount
                                MIGeneralsAPI.shared().sendNotification(self.posted_ID, userID: userId, subject: "Commented on your Post", MsgType: "COMMENT", MsgSent: "", showDisplayContent: "Commented on your Post", senderName: firstName + lastName, post_ID: self.notificationInfo,shareLink: "shareComment")
                                
                                
                            }
                            
                            self.genericTextViewDidChange(self.txtViewComment, height: 10)
                        }
                        self.editCommentId =  nil
                        //self.tblCommentList.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
                        
                        //self.lblNoData.isHidden = self.arrCommentList.count != 0
                    }
                }
            }
        }
    }
    
    @objc fileprivate func btnMenuClicked(_ sender : UIBarButtonItem) {
        
        let userID = (chirpyInformation[CSharedPost] as? [String:Any] ?? [:])[CUserId] as? Int64 ?? 0
        if userID == appDelegate.loginUser?.user_id{
            
            self.presentActionsheetWithTwoButtons(actionSheetTitle: nil, actionSheetMessage: nil, btnOneTitle: CBtnEdit, btnOneStyle: .default, btnOneTapped: { [weak self](alert) in
                guard let self = self else { return }
                if let sharePost = CStoryboardSharedPost.instantiateViewController(withIdentifier: "SharePostViewController") as? SharePostViewController{
                    sharePost.postData = self.chirpyInformation
                    sharePost.isFromEdit = true
                    self.navigationController?.pushViewController(sharePost, animated: true)
                }
            }, btnTwoTitle: CBtnDelete, btnTwoStyle: .default) { [weak self] (alert) in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.deleteChirpyPost(self.chirpyInformation)
                }   }
        }else {
            let sharePostData = chirpyInformation[CSharedPost] as? [String:Any] ?? [:]
            if let reportVC = CStoryboardGeneral.instantiateViewController(withIdentifier: "ReportViewController") as? ReportViewController {
                reportVC.reportType = .reportChirpy
                reportVC.isSharedPost = true
                reportVC.userID = sharePostData.valueForInt(key: CUserId)
                reportVC.reportID = sharePostData.valueForInt(key: CId)
                self.navigationController?.pushViewController(reportVC, animated: true)
            }
        }
        
    }
    
    @IBAction func btnLikeCLK(_ sender : UIButton){
//        if sender.tag == 0{
//            // LIKE CLK
//            btnLike.isSelected = !btnLike.isSelected
//            likeCount = btnLike.isSelected ? likeCount + 1 : likeCount - 1
//            btnLikeCount.setTitle(appDelegate.getLikeString(like: likeCount), for: .normal)
//            MIGeneralsAPI.shared().likeUnlikePostWebsite(post_id: self.chirpyID, rss_id: nil, type: 1, likeStatus: btnLike.isSelected ? 1 : 0, viewController: self)
//        }else{
//            // LIKE COUNT CLK
//            if let likeVC = CStoryboardGeneral.instantiateViewController(withIdentifier: "LikeViewController") as? LikeViewController{
//                likeVC.postID = self.chirpyID
//                self.navigationController?.pushViewController(likeVC, animated: true)
//            }
//        }
        
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
    }else{
        if let likeVC = CStoryboardGeneral.instantiateViewController(withIdentifier: "LikeViewController") as? LikeViewController{
            //likeVC.postID = self.shoutID
            likeVC.postIDNew = self.chirpyId
            self.navigationController?.pushViewController(likeVC, animated: true)
        }
    }
    }
    
    func likeCountfromSever(productId: Int,likeCount:Int,postInfo:[String:Any],like:Int){
        APIRequest.shared().likeUnlikeProductCount(productId: self.chirpyIDNew?.toInt ?? 0 ){ [weak self](response, error) in
            guard let _ = self else { return }
            if response != nil {
                GCDMainThread.async { [self] in
                    self?.likeTotalCount = response?["likes_count"] as? Int ?? 0
                    self?.btnLikeCount.setTitle(appDelegate.getLikeString(like: self?.likeTotalCount ?? 0), for: .normal)
                    guard let user_ID = appDelegate.loginUser?.user_id.description else { return }
                    if self?.notifcationIsSlected == true{
                        guard let firstName = appDelegate.loginUser?.first_name else {return}
                        guard let lastName = appDelegate.loginUser?.last_name else {return}

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
//                    MIGeneralsAPI.shared().likeUnlikePostWebsites(post_id: self?.chirpyIDNew?.toInt ?? 0, rss_id: 0, type: 1, likeStatus: self?.like ?? 0 ,info:postInfo, viewController: self)
                    
                    if self?.isLikesOthersPage == true {
                    if self?.isFinalLikeSelected == true{
                        MIGeneralsAPI.shared().likeUnlikePostWebsites(post_id:self?.chirpyIDNew?.toInt ?? 0, rss_id: 1, type: 1, likeStatus: self?.like ?? 0 ,info:postInfo, viewController: self)
                        self?.isLikeSelected = false
                    }else {
                        MIGeneralsAPI.shared().likeUnlikePostWebsites(post_id: self?.chirpyIDNew?.toInt ?? 0, rss_id: 2, type: 1, likeStatus: self?.like ?? 0 ,info:postInfo, viewController: self)

                    }
                   }
                    if  self?.isLikesHomePage == true || self?.isLikesMyprofilePage == true {
                    MIGeneralsAPI.shared().likeUnlikePostWebsites(post_id: self?.chirpyIDNew?.toInt ?? 0, rss_id: 3, type: 1, likeStatus: self?.like ?? 0 ,info:postInfo, viewController: self)
                    }
                }
            }
        }
    }
    
    @IBAction func btnShareReportCLK(_ sender : UIButton){
        //self.presentActivityViewController(mediaData: chirpyInformation.valueForString(key: CShare_url), contentTitle: CSharePostContentMsg)
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
        guard let userID = appDelegate.loginUser?.user_id else{return}
        APIRequest.shared().deleteProductCommentNew(productId:chirpyIDNew ?? "", commentId : commentId, comment: strComment, include_user_id: userID.description)  { [weak self] (response, error) in
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
                    MIGeneralsAPI.shared().refreshPostRelatedScreens(nil,self.chirpyIDNew?.toInt ?? 0 , self, .deleteComment, rss_id: 0)
                }
            }
        }
    }
}

