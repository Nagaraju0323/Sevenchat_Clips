//
//  FavWebSiteDetailViewController.swift
//  Sevenchats
//
//  Created by mac-0005 on 20/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit
import ActiveLabel

class FavWebSiteDetailViewController: ParentViewController {

    @IBOutlet var lblWebSiteType : UILabel!
    @IBOutlet var lblWebSiteTitle : UILabel!
    @IBOutlet var lblWebSiteDescription : UILabel!
    @IBOutlet var lblWebSitePostDate : UILabel!
    @IBOutlet var cnTblHeight : NSLayoutConstraint!
    @IBOutlet var btnSend : UIButton!
    @IBOutlet var btnLike : UIButton!
    @IBOutlet var btnLikeCount : UIButton!
    @IBOutlet var btnComment : UIButton!
    @IBOutlet var btnReport : UIButton!
    @IBOutlet var btnShare : UIButton!
    @IBOutlet var btnViewAllComment : UIButton!
    @IBOutlet var txtViewComment : GenericTextView!
    
    @IBOutlet fileprivate var viewCommentContainer : UIView! {
        didSet {
            viewCommentContainer.layer.masksToBounds = false
            viewCommentContainer.layer.shadowColor = ColorAppTheme.cgColor
            viewCommentContainer.layer.shadowOpacity = 10
            viewCommentContainer.layer.shadowOffset = CGSize(width: 0, height: 5)
            viewCommentContainer.layer.shadowRadius = 10
        }
    }
    
    @IBOutlet fileprivate var viewContentContainer : UIView! {
        didSet {
            viewContentContainer.layer.cornerRadius = 8
            viewContentContainer.layer.masksToBounds = false
            viewContentContainer.layer.shadowColor = CRGB(r: 237, g: 236, b: 226).cgColor
            viewContentContainer.layer.shadowOpacity = 10
            viewContentContainer.layer.shadowOffset = CGSize(width: 0, height: 5)
            viewContentContainer.layer.shadowRadius = 10
        }
    }
    
    @IBOutlet fileprivate var tblCommentList : UITableView! {
        didSet {
            tblCommentList.estimatedRowHeight = 100;
            tblCommentList.rowHeight = UITableView.automaticDimension;
//            tblCommentList.transform = CGAffineTransform(rotationAngle: -.pi)
        }
    }
    
    // Set for User suggestion view...
    @IBOutlet fileprivate weak var viewUserSuggestion : UserSuggestionView! {
        didSet {
            viewUserSuggestion.userSuggestionDelegate = self
            viewUserSuggestion.initialization()
        }
    }
    
    var websiteInfo : [String:Any]!
    var arrCommentList = [[String:Any]]()
    
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
    
    // MARK:- --------- Initialization
    func Initialization(){
        
        self.title = CSideFavWebSites

        // Set website related contern here...
        self.favWebSiteDetails()
        self.getCommentListFromServer()
        
    }
    
    func updateUIAccordingToLanguage(){
        
        if Localization.sharedInstance.applicationFlowWithLanguageRTL() {
            // Reverse Flow...
            btnLike.contentHorizontalAlignment = .left
            btnLikeCount.contentHorizontalAlignment = .right
            btnComment.contentHorizontalAlignment = .right
            btnComment.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 7)
        }else{
            // Normal Flow...
            btnLike.contentHorizontalAlignment = .right
            btnLikeCount.contentHorizontalAlignment = .left
            btnComment.contentHorizontalAlignment = .left
            btnComment.titleEdgeInsets = UIEdgeInsets(top: 0, left: 7, bottom: 0, right: 0)
        }
        
        txtViewComment.placeHolder = CMessageTypeYourMessage
        txtViewComment.type = "1"
    }
}
// MARK:- --------- Api Functions
extension FavWebSiteDetailViewController {
    func favWebSiteDetails() {
        if let websiteDetail = websiteInfo {
            lblWebSiteTitle.text = websiteDetail.valueForString(key: "title")
            lblWebSiteDescription.text = websiteDetail.valueForString(key: "description")
            lblWebSiteType.text = websiteDetail.valueForString(key: "interest_category_name")
            lblWebSitePostDate.text = DateFormatter.dateStringFrom(timestamp: websiteDetail.valueForDouble(key: CCreated_at), withFormate: CreatedAtPostDF)
            btnLikeCount.setTitle(websiteDetail.valueForString(key: "total_like"), for: .normal)
            btnComment.setTitle(websiteDetail.valueForString(key: "total_comment"), for: .normal)
            btnLike.isSelected = websiteDetail.valueForBool(key: "is_like")
        }
        
    }
    
    fileprivate func getCommentListFromServer() {
//        _ = APIRequest.shared().getCommentList(page: 1, showLoader: false, post_id: nil, rss_id: websiteInfo.valueForInt(key: CId)) { (response, error) in
//            if response != nil && error == nil {
//                if let arrComm = response![CJsonData] as? [[String : Any]] {
//                    if let metaInfo = response![CJsonMeta] as? [String : Any] {
//                        self.updateCommentSection(arrComm, metaInfo.valueForInt(key: "total")!)
//                    }
//                }
//            }
//        }
    }
    
    func updateCommentSection(_ arrComm : [[String : Any]], _ totalComment : Int){
        btnComment.setTitle("\(totalComment)", for: .normal)
        
        self.arrCommentList.removeAll()
        
        if totalComment > 2{
            self.btnViewAllComment.hide(byHeight: false)
            
            // Add last two comment here...
            self.arrCommentList.append(arrComm.first!)
            self.arrCommentList.append(arrComm[1])
            
        }else{
            self.arrCommentList = arrComm
            self.btnViewAllComment.hide(byHeight: true)
        }
        self.tblCommentList.reloadData()
        
        if #available(iOS 11.0, *) {
            self.tblCommentList.performBatchUpdates({
                self.cnTblHeight.constant = self.tblCommentList.contentSize.height
            }) { (completed) in
                self.cnTblHeight.constant = self.tblCommentList.contentSize.height
            }
        } else {
            // Fallback on earlier versions
            GCDMainThread.asyncAfter(deadline: .now() + 1) {
                self.cnTblHeight.constant = self.tblCommentList.contentSize.height
            }
        }
    }
}

// MARK:- --------- UITableView Datasources/Delegate
extension FavWebSiteDetailViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
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
                appDelegate.moveOnProfileScreenNew(commentInfo.valueForString(key: CUserId), commentInfo.valueForString(key: CUsermailID), self)
            }
            
            cell.btnUserImage.touchUpInside { [weak self] (sender) in
                guard let self = self else { return }
//                appDelegate.moveOnProfileScreen(commentInfo.valueForString(key: CUserId), self)
                appDelegate.moveOnProfileScreenNew(commentInfo.valueForString(key: CUserId), commentInfo.valueForString(key: CUsermailID), self)
            }
            
            return cell
        }
        
        return tableView.tableViewDummyCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

// MARK:-  --------- Generic UITextView Delegate
extension FavWebSiteDetailViewController: GenericTextViewDelegate{
    
    func genericTextViewDidChange(_ textView: UITextView, height: CGFloat)
    {
        if textView.text.count < 1 || textView.text.isBlank{
            btnSend.isUserInteractionEnabled = false
            btnSend.alpha = 0.5
        }else{
            btnSend.isUserInteractionEnabled = true
            btnSend.alpha = 1
        }
    }
    
    func genericTextView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if viewUserSuggestion != nil {
            viewUserSuggestion.filterUser(textView, shouldChangeTextIn: range, replacementText: text)
        }
        
        return true
    }
}

// MARK:-  --------- UserSuggestionDelegate
extension FavWebSiteDetailViewController: UserSuggestionDelegate{
    func didSelectSuggestedUser(_ userInfo: [String : Any]) {
        viewUserSuggestion.arrangeFinalComment(userInfo, textView: txtViewComment)
    }
}

// MARK:-  --------- Action Event
extension FavWebSiteDetailViewController{
    @IBAction func btnSendCommentCLK(_ sender : UIButton){
        self.resignKeyboard()
        
        if (txtViewComment.text?.isBlank)!{
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageCommentBlank, btnOneTitle: CBtnOk, btnOneTapped: nil)
        }else{
            // Get Final text for comment..
            let strComment = viewUserSuggestion.stringToBeSendInComment(txtViewComment)
            
            // Get Mention user's Ids..
            let includedUser = viewUserSuggestion.arrSelectedUser.map({$0.valueForString(key: CUserId) }).joined(separator: ",")
            
//            APIRequest.shared().sendComment(post_id: nil, commentId: nil, rss_id: websiteInfo.valueForInt(key: CId), type: 2, comment: strComment, include_user_id: includedUser) { (response, error) in
//                if response != nil && error == nil {
//                    
//                    self.viewUserSuggestion.hideSuggestionView(self.txtViewComment)
//                    self.txtViewComment.text = nil
//                    self.btnSend.isUserInteractionEnabled = false
//                    self.btnSend.alpha = 0.5
//                    self.txtViewComment.updatePlaceholderFrame(false)
//                    
//                    if let responsInfo = response as? [String : Any]{
//                        MIGeneralsAPI.shared().refreshWebSiteScreens(responsInfo, self.websiteInfo.valueForInt(key: CId), self, .commentPost)
//                    }
//                    
//                }
//            }
        }
    }
    
    @IBAction func btnLikeCLK(_ sender : UIButton){
        if sender.tag == 0{
            // LIKE CLK
            btnLike.isSelected = !btnLike.isSelected
            let totalLikeCount = websiteInfo.valueForInt(key: CTotal_like)
            btnLikeCount.setTitle(btnLike.isSelected ? "\(totalLikeCount!+1)" : "\(totalLikeCount!-1)", for: .normal)
            MIGeneralsAPI.shared().likeUnlikePostWebsite(post_id: nil, rss_id: websiteInfo.valueForInt(key: CId), type: 2, likeStatus: btnLike.isSelected ? 1 : 0, viewController: self)
        }else{
            // LIKE COUNT CLK
            if let likeVC = CStoryboardGeneral.instantiateViewController(withIdentifier: "LikeViewController") as? LikeViewController {
                likeVC.rssID = websiteInfo.valueForInt(key: CId)
                self.navigationController?.pushViewController(likeVC, animated: true)
            }
        }
    }
    
    @IBAction func btnShareReportCLK(_ sender : UIButton){
        if sender.tag == 0{
            // SHARE CLK
        }else{
            // REPORT CLK
            if let reportVC = CStoryboardGeneral.instantiateViewController(withIdentifier: "ReportViewController") as? ReportViewController{
                reportVC.reportType = .reportRss
                reportVC.reportedURL = websiteInfo.valueForString(key: "favourite_website_url")
                self.navigationController?.pushViewController(reportVC, animated: true)
            }
        }
    }
    
    @IBAction func btnCommentCLK(_ sender : UIButton){
        if let commentVC = CStoryboardGeneral.instantiateViewController(withIdentifier: "CommentViewController") as? CommentViewController{
            commentVC.rssId = websiteInfo.valueForString(key: CId)
            self.navigationController?.pushViewController(commentVC, animated: true)
        }
    }
}
