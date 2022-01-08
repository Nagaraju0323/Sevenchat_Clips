//
//  ChirpyDetailsViewController.swift
//  Sevenchats
//
//  Created by mac-0005 on 17/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit
import ActiveLabel

class ChirpyDetailsViewController: ParentViewController {
    
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
    @IBOutlet fileprivate weak var cnTextViewHeight : NSLayoutConstraint!
    
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
    var arrCommentList = [[String:Any]]()
    var chirpyInformation = [String:Any]()
    var chirpyInfo = [String:Any]()
    var chirpyID : Int?
    var apiTask : URLSessionTask?
    var pageNumber = 1
    var likeCount = 0
    var commentCount = 0
    var editCommentId : Int? = nil
    
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
        self.setChirpyDetailData(chirpyInfo)
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
extension ChirpyDetailsViewController{
    
    fileprivate func getChirpyDetailsFromServer() {
            
            self.parentView.isHidden = true
            if let chirID = self.chirpyID {
                APIRequest.shared().viewPostDetailNew(postID: chirID, apiKeyCall: CAPITagchirpiesDetials){ [weak self] (response, error) in
                    guard let self = self else { return }
                    if response != nil {
                        self.parentView.isHidden = false
                        if let Info = response!["data"] as? [[String:Any]]{
                        print(Info as Any)
                            for chirpInfo in Info {
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
            self.lblUserName.text = chirInfo.valueForString(key: CFirstname) + " " + chirInfo.valueForString(key: CLastname)
            self.lblChirpyPostDate.text = DateFormatter.dateStringFrom(timestamp: chirInfo.valueForDouble(key: CCreated_at), withFormate: CreatedAtPostDF)
            self.lblChirpyDescription.text = chirInfo.valueForString(key: CContent)
            
            self.imgUser.loadImageFromUrl(chirInfo.valueForString(key: CUserProfileImage), true)
            self.lblChirpyCategory.text = chirInfo.valueForString(key: CCategory)
            self.btnLike.isSelected = chirInfo.valueForInt(key: CIs_Like) == 1
            
            likeCount = chirInfo.valueForInt(key: CTotal_like) ?? 0
            
            self.commentCount = chirInfo.valueForInt(key: CTotalComment) ?? 0
            btnComment.setTitle(appDelegate.getCommentCountString(comment: commentCount), for: .normal)
            
            self.btnLikeCount.setTitle(appDelegate.getLikeString(like: likeCount), for: .normal)
            
            self.tblCommentList.updateHeaderViewHeight(extxtraSpace: 0)
        }
    }
    
    fileprivate func deleteChirpyPost(){
    }
    @objc func pullToRefresh() {
        if apiTask?.state == URLSessionTask.State.running {
            apiTask?.cancel()
        }
        
        self.pageNumber = 1
        refreshControl.beginRefreshing()
        self.getChirpyDetailsFromServer()
    }

    fileprivate func getCommentListFromServer(){
        if let chirID = self.chirpyID{
            
            if apiTask?.state == URLSessionTask.State.running {
                return
            }
            // Add load more indicator here...
            self.tblCommentList.tableFooterView = self.pageNumber > 2 ? self.loadMoreIndicator(ColorAppTheme) : UIView()
            
        }
    }
    
    func updateChirpyCommentSection(_ arrComm : [[String : Any]], _ totalComment : Int){
    }
}
// MARK:- --------- UITableView Datasources/Delegate
extension ChirpyDetailsViewController: UITableViewDelegate, UITableViewDataSource{
    
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
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTblCell", for: indexPath) as? CommentTblCell
        {
            weak var weakCell = cell
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
                            appDelegate.moveOnProfileScreenNew(self.chirpyInformation.valueForString(key: CUserId), self.chirpyInformation.valueForString(key: CUsermailID), self)
                        }
                    })
                    
                    commentText = commentText.replacingOccurrences(of: String(NSString(format: kMentionFriendStringFormate as NSString, userInfo.valueForString(key: CUserId))), with: userName)
                }
            }
            
            cell.lblCommentText.customize { [weak self] label in
                label.text = commentText
                label.minimumLineHeight = 0.0
                
                label.configureLinkAttribute = {  [weak self] (type, attributes, isSelected) in
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
extension ChirpyDetailsViewController: GenericTextViewDelegate{
    
    func genericTextViewDidChange(_ textView: UITextView, height: CGFloat){
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
extension ChirpyDetailsViewController: UserSuggestionDelegate{
    func didSelectSuggestedUser(_ userInfo: [String : Any]) {
        viewUserSuggestion.arrangeFinalComment(userInfo, textView: txtViewComment)
    }
}

// MARK:-  --------- Action Event
extension ChirpyDetailsViewController{
    @IBAction func btnSendCommentCLK(_ sender : UIButton){
        self.resignKeyboard()
        
        if (txtViewComment.text?.isBlank)!{
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageCommentBlank, btnOneTitle: CBtnOk, btnOneTapped: nil)
        }else{
            if let chirId = self.chirpyID{
                // Get Final text for comment..
                let strComment = viewUserSuggestion.stringToBeSendInComment(txtViewComment)
                // Get Mention user's Ids..
                let includedUser = viewUserSuggestion.arrSelectedUser.map({$0.valueForString(key: CUserId) }).joined(separator: ",")
                

            }
        }
    }
    
    @objc fileprivate func btnMenuClicked(_ sender : UIBarButtonItem) {
        
        if chirpyInformation.valueForString(key: "user_email") == appDelegate.loginUser?.email {
            self.presentActionsheetWithOneButton(actionSheetTitle: nil, actionSheetMessage: nil, btnOneTitle: CBtnDelete, btnOneStyle: .default) { [weak self] (_) in
                guard let _ = self else {return}
                DispatchQueue.main.async {
                    self?.deleteChirpyPost()
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
        if sender.tag == 0{
            btnLike.isSelected = !btnLike.isSelected
            likeCount = btnLike.isSelected ? likeCount + 1 : likeCount - 1
            btnLikeCount.setTitle(appDelegate.getLikeString(like: likeCount), for: .normal)
            MIGeneralsAPI.shared().likeUnlikePostWebsite(post_id: self.chirpyID, rss_id: nil, type: 1, likeStatus: btnLike.isSelected ? 1 : 0, viewController: self)
        }else{
            if let likeVC = CStoryboardGeneral.instantiateViewController(withIdentifier: "LikeViewController") as? LikeViewController{
                likeVC.postID = self.chirpyID
                self.navigationController?.pushViewController(likeVC, animated: true)
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

    }
}
