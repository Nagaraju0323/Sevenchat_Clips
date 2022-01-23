//
//  CommentViewController.swift
//  Sevenchats
//
//  Created by mac-0005 on 18/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Chandrika.R                                 *
 * Model   : CommentViewController                      *
 * Changes :                                             *
                            *
 ********************************************************/

import UIKit
import ActiveLabel

class CommentViewController: ParentViewController {
    
    @IBOutlet fileprivate weak var viewCommentContainer : UIView!
    @IBOutlet fileprivate weak var btnSend : UIButton!
    @IBOutlet fileprivate weak var cnTextViewHeight : NSLayoutConstraint!
    @IBOutlet fileprivate weak var txtViewComment : GenericTextView!
    @IBOutlet fileprivate weak var lblNoData : UILabel!
    
    @IBOutlet fileprivate weak var viewUserSuggestion : UserSuggestionView! {
        didSet {
            viewUserSuggestion.initialization()
            viewUserSuggestion.userSuggestionDelegate = self
        }
    }
    
    @IBOutlet fileprivate weak var tblCommentList : UITableView! {
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
    
    @IBOutlet fileprivate weak var cnTblSuggestionHeight : NSLayoutConstraint! {
        didSet {
            cnTblSuggestionHeight.constant = 0
        }
    }
    
    var apiTask : URLSessionTask?
    var pageNumber = 1
    var refreshControl = UIRefreshControl()
    
    var arrCommentList = [[String:Any]]()
    var arrUserForMention = [[String:Any]]()
    var arrFilterUser = [[String:Any]]()
    
    
    var postId : Int?
   // var rssId : Int?
    var rssId : String?
    var rssID = ""
    var editCommentId : Int? = nil
    var isEditBtnCLK = false
    var index_Row:Int?
    var commentsInfo = [String:Any]()
    var commentCount = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Initialization()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK:- --------- Initialization
    func Initialization(){
        
        self.title = CNavComments
        self.view.backgroundColor = CRGB(r: 249, g: 250, b: 250)
        self.parentView.backgroundColor = .clear
        self.tblCommentList.backgroundColor = .clear
        
        lblNoData.text = CMessageNoCommentFound
        txtViewComment.placeHolder = CMessageTypeYourMessage
        txtViewComment.type = "1"
        viewCommentContainer.layer.masksToBounds = false
        viewCommentContainer.layer.shadowColor = ColorAppTheme.cgColor
        viewCommentContainer.layer.shadowOpacity = 10
        viewCommentContainer.layer.shadowOffset = CGSize(width: 0, height: 5)
        viewCommentContainer.layer.shadowRadius = 10
        
        GCDMainThread.async {
            self.refreshControl.addTarget(self, action: #selector(self.pullToRefresh), for: .valueChanged)
            self.refreshControl.tintColor = ColorAppTheme
            self.tblCommentList.pullToRefreshControl = self.refreshControl
            self.pageNumber = 1
            self.getCommentListFromServer(showLoader: true)
        }
    }
    
}
// MARK:- --------- Api functions
extension CommentViewController{
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
            self.refreshControl.endRefreshing()
            return
        }
        
        // Add load more indicator here...
        self.tblCommentList.tableFooterView = self.pageNumber > 2 ? self.loadMoreIndicator(ColorAppTheme) : UIView()

        self.arrCommentList.removeAll()
        apiTask = APIRequest.shared().getProductCommentLists(page: pageNumber, showLoader: showLoader, productId: rssID) { [weak self] (response, error) in
            
            guard let self = self else { return }

            self.tblCommentList.tableFooterView = UIView()
            self.apiTask?.cancel()
            
            if response != nil {
                
                let commentCnt = response!["comments_count"] as? Int
                let comments =  appDelegate.getCommentCountString(comment:commentCnt ?? 0)
                self.commentCount = comments
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
                //self.lblNoData.isHidden = self.arrCommentList.count != 0
            }
        }
    }
}

// MARK:- --------- UITableView Datasources/Delegate
extension CommentViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrCommentList.count > 0 ? 1 : 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let header = EventCommentTblHeader.viewFromXib as? EventCommentTblHeader{
            header.backgroundColor =  CRGB(r: 249, g: 250, b: 250)
            
            header.lblTitle.text = commentCount
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
                            let userSelectedInfo = arrSelectedUser[0]
                            appDelegate.moveOnProfileScreenNew(userSelectedInfo.valueForString(key: CUserId), userSelectedInfo.valueForString(key: CUsermailID), self)
                        }
                    })
                    
                    commentText = commentText.replacingOccurrences(of: String(NSString(format: kMentionFriendStringFormate as NSString, userInfo.valueForString(key: CUserId))), with: userName)
                }
            }

            cell.lblCommentText.customize { [weak self ] label in
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
                appDelegate.moveOnProfileScreenNew(commentInfo.valueForString(key: CUserId), commentInfo.valueForString(key: CUsermailID), self)
            }
            
            cell.btnUserImage.touchUpInside { [weak self] (sender) in
                guard let self = self else { return }
                appDelegate.moveOnProfileScreenNew(commentInfo.valueForString(key: CUserId), commentInfo.valueForString(key: CUsermailID), self)
            }
            
            // Load more data....
//            if (indexPath == tblCommentList.lastIndexPath()) && apiTask?.state != URLSessionTask.State.running {
//                self.getCommentListFromServer(showLoader: false)
//            }
            
            return cell
        }
        
        return tableView.tableViewDummyCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

// MARK:-  --------- Generic UITextView Delegate
extension CommentViewController: GenericTextViewDelegate{
    
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
extension CommentViewController: UserSuggestionDelegate{
    func didSelectSuggestedUser(_ userInfo: [String : Any]) {
        viewUserSuggestion.arrangeFinalComment(userInfo, textView: txtViewComment)
    }
}

// MARK:-  --------- Action Event
extension CommentViewController{
    @IBAction func btnSendCommentCLK(_ sender : UIButton){
        
        self.resignKeyboard()
        
        if (txtViewComment.text?.isBlank)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageCommentBlank, btnOneTitle: CBtnOk, btnOneTapped: nil)
        } else {
            
            // Get Final text for comment..
            let strComment = viewUserSuggestion.stringToBeSendInComment(txtViewComment)
            
            // Get Mention user's Ids..
            let includedUser = viewUserSuggestion.arrSelectedUser.map({$0.valueForString(key: CUserId) }).joined(separator: ",")
            guard let userid = appDelegate.loginUser?.user_id else {
                return
            }
            let userID = userid.description
            APIRequest.shared().sendProductCommentnew(productId: rssID, commentId : self.editCommentId, comment: strComment, include_user_id:userID)  { [weak self] (response, error) in
               guard let self = self else { return }
  
                if response != nil && error == nil {
                    self.viewUserSuggestion.hideSuggestionView(self.txtViewComment)
                    self.txtViewComment.text = ""
                    self.btnSend.isUserInteractionEnabled = false
                    self.btnSend.alpha = 0.5
                    self.txtViewComment.updatePlaceholderFrame(false)
                    
                    if let comment = response!["meta"] as? [String : Any] {
                        if (comment["status"] as? String ?? "") == "0"{
                            self.getCommentListFromServer(showLoader: true)
                        }
                        self.genericTextViewDidChange(self.txtViewComment, height: 10)
                    }
                    
                    self.editCommentId =  nil
//                    self.tblCommentList.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
                    //self.lblNoData.isHidden = self.arrCommentList.count != 0
                }
            }
        }
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
        
        APIRequest.shared().deleteProductCommentNew(productId:rssID, commentId : commentId, comment: strComment, include_user_id: userId)  { [weak self] (response, error) in
            guard let self = self else { return }
            if response != nil && error == nil {
                DispatchQueue.main.async {
                    self.arrCommentList.remove(at: index)

                    self.getCommentListFromServer(showLoader: true)
                    self.tblCommentList.reloadData()
                }
            }
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.post(name: Notification.Name("updateReloadTable"), object: nil)

    }
    
}
