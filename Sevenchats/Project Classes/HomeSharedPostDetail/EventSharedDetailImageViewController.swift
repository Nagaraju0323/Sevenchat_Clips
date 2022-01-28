//
//  EventSharedDetailImageViewController.swift
//  Sevenchats
//
//  Created by mac-0005 on 22/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Chandrika.R                                 *
 * Model   : EventSharedDetailImageViewController        *
 * Changes :                                             *
 *                                                       *
 ********************************************************/


import UIKit
import ActiveLabel
import Lightbox

class EventSharedDetailImageViewController: ParentViewController {
    
    @IBOutlet weak var lblEventType : UILabel!
    @IBOutlet weak var lblEventTitle : UILabel!
    @IBOutlet weak var lblEventPostDate : UILabel!
    @IBOutlet weak var lblStartDate : UILabel!
    @IBOutlet weak var lblEndDate : UILabel!
    @IBOutlet weak var lblEventStartDate : UILabel!
    @IBOutlet weak var lblEventEndDate : UILabel!
    @IBOutlet weak var lblEventAddress : UILabel!
    @IBOutlet weak var lblEventDescription : UILabel!
    @IBOutlet weak var lblEventCategory : UILabel!
    //@IBOutlet weak var lblInvitedUserCount : UILabel!
    //@IBOutlet weak var lblAboutEvent : UILabel!
    @IBOutlet weak var btnProfileImg : UIButton!
    @IBOutlet weak var btnUserName : UIButton!
    
    @IBOutlet weak var btnLikeCount : UIButton!
    @IBOutlet weak var btnLike : UIButton!
    @IBOutlet weak var btnComment : UIButton!
    @IBOutlet weak var btnShare : UIButton!
    @IBOutlet weak var btnMaybe : UIButton!
    @IBOutlet weak var btnNotInterested : UIButton!
    @IBOutlet weak var btnInterested : UIButton!
    
    //@IBOutlet weak var imgVEvent : UIImageView!
    
    //@IBOutlet weak var vwInvitedCount : UIView!
    @IBOutlet weak var imgUser : UIImageView!
    @IBOutlet weak var lbluserName : UILabel!
    @IBOutlet weak var tblUserList : UITableView!
    
    @IBOutlet weak var tblCommentList : UITableView! {
        didSet {
            
            tblCommentList.register(UINib(nibName: "CommentTblCell", bundle: nil), forCellReuseIdentifier: "CommentTblCell")
            tblCommentList.register(UINib(nibName: "EventInviteesAcceptedTblCell", bundle: nil), forCellReuseIdentifier: "EventInviteesAcceptedTblCell")
            
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
            txtViewComment.placeHolder = CMessageTypeYourMessage
        }
    }
    
    @IBOutlet fileprivate weak var viewUserSuggestion : UserSuggestionView! {
        didSet {
            viewUserSuggestion.initialization()
            viewUserSuggestion.userSuggestionDelegate = self
        }
    }
    @IBOutlet weak var btnEventImg : UIButton!
    
    @IBOutlet weak var blurImgView : BlurImageView!
    
    @IBOutlet weak var lblSharedPostDate : UILabel!
    @IBOutlet weak var imgSharedUser : UIImageView!
    @IBOutlet weak var lblSharedUserName : UILabel!
    @IBOutlet weak var btnSharedProfileImg : UIButton!
    @IBOutlet weak var btnSharedUserName : UIButton!
    @IBOutlet weak var lblMessage : UILabel!
    @IBOutlet weak var lblSharedPostType : UILabel!
    
    var eventImgURL = ""
    
    var postID : Int?
    var rssId : Int?
    var arrInvitedUser = [[String : Any]]()
    var eventInfo = [String : Any]()
    var isHideNavCalenderButton = false
    var refreshControl = UIRefreshControl()
    var arrCommentList = [[String:Any]]()
    var arrUserForMention = [[String:Any]]()
    var arrFilterUser = [[String:Any]]()
    var apiTask : URLSessionTask?
    var pageNumber = 1
    var likeCount = 0
    var commentCount = 0
    var editCommentId : Int? = nil
    var actionType : Int = 0
    var arrDropDown : [String] = []
    var arrConfirmed = [[String : Any]]()
    var arrMaybe = [[String : Any]]()
    var arrDeclined = [[String : Any]]()
    
    let currentDateTime = Date().timeIntervalSince1970
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Initialization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateUIAccordingToLanguage()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK:- -------- Initialization
    func Initialization(){
        
        self.title = CNavEventsDetails
        imgUser.layer.cornerRadius = imgUser.frame.size.width / 2
        lblSharedPostType.text = CSharedEvents
        self.imgSharedUser.layer.cornerRadius = self.imgSharedUser.frame.size.width / 2
        self.imgSharedUser.layer.borderWidth = 2
        self.imgSharedUser.layer.borderColor = #colorLiteral(red: 0, green: 0.7881455421, blue: 0.7100172639, alpha: 1)
        self.imgUser.layer.borderWidth = 2
        self.imgUser.layer.borderColor = #colorLiteral(red: 0, green: 0.7881455421, blue: 0.7100172639, alpha: 1)

        lblEventType.layer.cornerRadius = 3
        
        self.view.backgroundColor = CRGB(r: 249, g: 250, b: 250)
        self.parentView.backgroundColor = .clear
        self.tblCommentList.backgroundColor = .clear
        
        self.btnShare.setTitle(CBtnShare, for: .normal)
        
        func setupInterestButton(sender:UIButton){
            sender.layer.cornerRadius = 4
            sender.clipsToBounds = true
        }
        setupInterestButton(sender: btnInterested)
        setupInterestButton(sender: btnNotInterested)
        setupInterestButton(sender: btnMaybe)
        
        self.refreshControl.addTarget(self, action: #selector(self.pullToRefresh), for: .valueChanged)
        self.refreshControl.tintColor = ColorAppTheme
        self.tblCommentList.pullToRefreshControl = self.refreshControl
        self.pageNumber = 1
        
        self.loadEventDetailFromServer()
        
        self.btnEventImg.touchUpInside(genericTouchUpInsideHandler: { [weak self](_) in
            let lightBoxHelper = LightBoxControllerHelper()
            //lightBoxHelper.openSingleImageFromURL(imgURL: self?.eventImgURL, viewController: self?.viewController)
            lightBoxHelper.openSingleImage(image: self?.blurImgView?.image, viewController: self?.viewController)
        })
    }
    
    func updateUIAccordingToLanguage(){
        
        if Localization.sharedInstance.applicationFlowWithLanguageRTL() {
            
            btnLike.contentHorizontalAlignment = .left
            btnLikeCount.contentHorizontalAlignment = .right
            btnComment.contentHorizontalAlignment = .right
            //btnComment.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 7)
            btnShare.contentHorizontalAlignment = .right
            //btnShare.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 7)
            
            // Reverse Flow...
            btnInterested.contentHorizontalAlignment = .right
            btnInterested.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
            
            btnNotInterested.contentHorizontalAlignment = .right
            btnNotInterested.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
            
            btnMaybe.contentHorizontalAlignment = .right
            btnMaybe.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right:10)
            
        }else{
            
            btnLike.contentHorizontalAlignment = .right
            btnLikeCount.contentHorizontalAlignment = .left
            btnComment.contentHorizontalAlignment = .left
            //btnComment.titleEdgeInsets = UIEdgeInsets(top: 0, left: 7, bottom: 0, right: 0)
            btnShare.contentHorizontalAlignment = .left
            //btnShare.titleEdgeInsets = UIEdgeInsets(top: 0, left: 7, bottom: 0, right: 0)
            
            // Normal Flow...
            btnInterested.contentHorizontalAlignment = .left
            btnInterested.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
            
            btnNotInterested.contentHorizontalAlignment = .left
            btnNotInterested.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
            
            btnMaybe.contentHorizontalAlignment = .left
            btnMaybe.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        }
        
        //lblAboutEvent.text = CMessageAboutEvent
    }
    
    func setDefaultEventActionList() {
        
        self.arrDropDown.removeAll()
        
        if !arrConfirmed.isEmpty {
            self.arrDropDown.append(CConfirmed)
        }
        if !arrMaybe.isEmpty {
            self.arrDropDown.append(CMaybe)
        }
        if !arrDeclined.isEmpty {
            self.arrDropDown.append(CDeclined)
        }
        
        if !self.arrDropDown.isEmpty {
            self.setDropDownList(action: self.arrDropDown.first!)
        } else {
            self.tblCommentList.reloadData()
        }
    }
    
    func setDropDownList(action:String) {
        
        switch action {
        case CConfirmed:
            self.actionType = 2
            self.arrInvitedUser = self.arrConfirmed
            break;
        case CMaybe:
            self.actionType = 1
            self.arrInvitedUser = self.arrMaybe
            break;
        case CDeclined:
            self.actionType = 3
            self.arrInvitedUser = self.arrDeclined
            break;
        default:
            break;
        }
        self.tblCommentList.reloadData()
    }
}

// MARK:- --------- Api Functions
extension EventSharedDetailImageViewController {
    
    @objc func pullToRefresh() {
        if apiTask?.state == URLSessionTask.State.running {
            apiTask?.cancel()
        }
        
        self.pageNumber = 1
        refreshControl.beginRefreshing()
        self.loadEventDetailFromServer()
    }
    
    func loadEventDetailFromServer() {
//        self.parentView.isHidden = true
//        APIRequest.shared().viewPostDetail(postID: self.postID) { [weak self] (response, error) in
//            guard let self = self else { return }
//            if response != nil {
//                self.parentView.isHidden = false
//                self.setEventDetail(dict: response?.value(forKey: CJsonData) as! [String : AnyObject])
//                self.openUserProfileScreen()
//            }
//            self.getCommentListFromServer(showLoader: false)
//        }
    }
    
    fileprivate func openUserProfileScreen(){
        
        self.btnSharedProfileImg.touchUpInside { [weak self] (sender) in
            guard let self = self else { return }
            if let userID = (self.eventInfo[CSharedPost] as? [String:Any] ?? [:])[CUserId] as? Int {
                appDelegate.moveOnProfileScreen(userID.description, self)
            }
        }
        
        self.btnSharedUserName.touchUpInside { [weak self] (sender) in
            guard let self = self else { return }
            if let userID = (self.eventInfo[CSharedPost] as? [String:Any] ?? [:])[CUserId] as? Int {
                appDelegate.moveOnProfileScreen(userID.description, self)
            }
        }
        
        self.btnProfileImg.touchUpInside { [weak self] (sender) in
            guard let self = self else { return }
            appDelegate.moveOnProfileScreen(self.eventInfo.valueForString(key: CUserId), self)
        }
        
        self.btnUserName.touchUpInside { [weak self] (sender) in
            guard let self = self else { return }
            appDelegate.moveOnProfileScreen(self.eventInfo.valueForString(key: CUserId), self)
        }
    }
    
    func setEventDetail(dict : [String : Any]) {
        
        //...Set prefilled event detail here
        eventInfo = dict
        if let sharedData = dict[CSharedPost] as? [String:Any]{
            self.lblSharedUserName.text = sharedData.valueForString(key: CFullName)
            self.lblSharedPostDate.text = DateFormatter.dateStringFrom(timestamp: sharedData.valueForDouble(key: CCreated_at), withFormate: CreatedAtPostDF)
            imgSharedUser.loadImageFromUrl(sharedData.valueForString(key: CUserProfileImage), true)
            lblMessage.text = sharedData.valueForString(key: CMessage)
        }
        self.parentView.isHidden = false
        self.lbluserName.text = "\(dict.valueForString(key: CFirstname)) \(dict.valueForString(key: CLastname))"
        self.lblEventPostDate.text = DateFormatter.dateStringFrom(timestamp: dict.valueForDouble(key: CCreated_at), withFormate: CreatedAtPostDF)
        self.lblEventCategory.text = dict.valueForString(key: CCategory).uppercased()
        self.lblEventType.text = CTypeEvent
        self.lblEventTitle.text = dict.valueForString(key: CTitle)
        self.lblEventDescription.text = dict.valueForString(key: CContent)
        self.lblStartDate.text = "\(CStartDate)"
        self.lblEndDate.text = "\(CEndDate)"
        self.lblEventStartDate.text = DateFormatter.dateStringFrom(timestamp: dict.valueForDouble(key: CEvent_Start_Date), withFormate: CDateFormat)
        self.lblEventEndDate.text = DateFormatter.dateStringFrom(timestamp: dict.valueForDouble(key: CEvent_End_Date), withFormate: CDateFormat)
        
        self.lblEventAddress.text = dict.valueForString(key: CEvent_Location)
        self.btnInterested.setTitle("\(dict.valueForString(key: CTotalInterestedUsers))\n" + CConfirmed, for: .normal)
        self.btnMaybe.setTitle("\(dict.valueForString(key: CTotalMaybeInterestedUsers))\n" + CMaybe, for: .normal)
        self.btnNotInterested.setTitle("\(dict.valueForString(key: CTotalNotInterestedUsers))\n" + CDeclined, for: .normal)
        
        self.blurImgView.loadImageFromUrl(dict.valueForString(key: CImage), false)
        //self.imgVEvent.loadImageFromUrl(dict.valueForString(key: CImage), false)
        
        self.eventImgURL = dict.valueForString(key: CImage)
        self.btnLike.isSelected = dict.valueForBool(key: CIs_Like)
        
        likeCount = dict.valueForInt(key: CTotal_like) ?? 0
        
        self.commentCount = dict.valueForInt(key: CTotalComment) ?? 0
        btnComment.setTitle(appDelegate.getCommentCountString(comment: commentCount), for: .normal)
        
        self.btnLikeCount.setTitle(appDelegate.getLikeString(like: likeCount), for: .normal)
        
        if let endDateTime = dict.valueForDouble(key: CEvent_End_Date) {
            
            btnMaybe.isEnabled = Double(currentDateTime) <= endDateTime
            btnNotInterested.isEnabled = Double(currentDateTime) <= endDateTime
            btnInterested.isEnabled = Double(currentDateTime) <= endDateTime
        }
        
        switch dict.valueForInt(key: CIsInterested) {
        case 1:
            btnMaybe.isSelected = true
        case 2:
            btnInterested.isSelected = true
        case 3:
            btnNotInterested.isSelected = true
        default:
            break
        }
        
        setSelectedButtonStyle()
        
        imgUser.loadImageFromUrl(dict.valueForString(key: CUserProfileImage), true)
        if Int64(dict.valueForString(key: CUserId)) == appDelegate.loginUser?.user_id{
            if self.isHideNavCalenderButton {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_btn_nav_more"), style: .plain, target: self, action: #selector(btnMenuClicked(_:)))
            }else {
                self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: #imageLiteral(resourceName: "ic_btn_nav_more"), style: .plain, target: self, action: #selector(btnMenuClicked(_:))),UIBarButtonItem(image: #imageLiteral(resourceName: "ic_event_calender"), style: .plain, target: self, action: #selector(btnCalenderClicked(_:)))]
            }
        }else{
            if !self.isHideNavCalenderButton {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_event_calender"), style: .plain, target: self, action: #selector(btnCalenderClicked(_:)))
            }
        }
        
        self.arrMaybe = dict.valueForJSON(key: "maybe_event_users") as? [[String : Any]] ?? []
        self.arrDeclined = dict.valueForJSON(key: "decline_event_users") as? [[String : Any]] ?? []
        self.arrConfirmed = dict.valueForJSON(key: "event_users") as? [[String : Any]] ?? []
        
        self.arrInvitedUser = self.arrConfirmed
        self.setDefaultEventActionList()
        self.tblUserList.reloadData()

        DispatchQueue.main.async {
            self.tblCommentList.updateHeaderViewHeight(extxtraSpace: 0)
        }
    }
    
    func setSelectedButtonStyle(){
        btnInterested.layer.borderColor = CRGB(r: 223, g: 234, b: 227).cgColor
        btnInterested.layer.borderWidth = 2
        btnInterested.backgroundColor =  .clear
        
        btnMaybe.layer.borderColor = CRGB(r: 255, g: 237, b: 216).cgColor
        btnMaybe.layer.borderWidth = 2
        btnMaybe.backgroundColor =  .clear
        
        btnNotInterested.layer.borderColor = CRGB(r: 255, g: 214, b: 214).cgColor
        btnNotInterested.layer.borderWidth = 2
        btnNotInterested.backgroundColor =  .clear
        
        let arrButton = [btnInterested,btnMaybe,btnNotInterested]
        if let sender = arrButton.filter({$0?.isSelected ?? false}).first{
            if sender == btnInterested{
                btnInterested.backgroundColor =  CRGB(r: 223, g: 234, b: 227)
            }else if sender == btnMaybe{
                btnMaybe.backgroundColor =  CRGB(r: 255, g: 237, b: 216)
            }else if sender == btnNotInterested{
                btnNotInterested.backgroundColor =  CRGB(r: 255, g: 214, b: 214)
            }
        }
    }
    
    fileprivate func btnInterestedNotInterestedMayBeCLK(_ type : Int?){
        
        if type != eventInfo.valueForInt(key: CIsInterested){
            
            // Update existing count here...
            let totalIntersted = eventInfo.valueForInt(key: CTotalInterestedUsers)
            let totalNotIntersted = eventInfo.valueForInt(key: CTotalNotInterestedUsers)
            let totalMaybe = eventInfo.valueForInt(key: CTotalMaybeInterestedUsers)
            switch eventInfo.valueForInt(key: CIsInterested) {
            case CTypeInterested:
                eventInfo[CTotalInterestedUsers] = totalIntersted! - 1
                break
            case CTypeNotInterested:
                eventInfo[CTotalNotInterestedUsers] = totalNotIntersted! - 1
                break
            case CTypeMayBeInterested:
                eventInfo[CTotalMaybeInterestedUsers] = totalMaybe! - 1
                break
            default:
                break
            }
            eventInfo[CIsInterested] = type
            
            switch type {
            case CTypeInterested:
                eventInfo[CTotalInterestedUsers] = totalIntersted! + 1
                break
            case CTypeNotInterested:
                eventInfo[CTotalNotInterestedUsers] = totalNotIntersted! + 1
                break
            case CTypeMayBeInterested:
                eventInfo[CTotalMaybeInterestedUsers] = totalMaybe! + 1
                break
            default:
                break
            }
            var postId = eventInfo.valueForString(key: "post_id").toInt
            let isSharedPost = eventInfo.valueForInt(key: CIsSharedPost)
            if isSharedPost == 1{
                postId = eventInfo[COriginalPostId] as? Int ?? 0
            }
            MIGeneralsAPI.shared().interestNotInterestMayBe(postId, type!, viewController: self)
            self.setEventDetail(dict: eventInfo)
            
        }
        
    }
    
    func deletePost() {
//        APIRequest.shared().removePost(postID: self.postID) { [weak self] (response, error) in
//            guard let self = self else { return }
//            if response != nil {
//
//                for vwController in (self.navigationController?.viewControllers)! {
//                    if vwController.isKind(of: EventListViewController .classForCoder()) {
//                        let eventVC = vwController as? EventListViewController
//                        eventVC?.currentPage = 1
//                        eventVC?.loadEventList(showLoader: false)
//                        break
//                    }
//                }
//                self.navigationController?.popViewController(animated: true)
//            }
//        }
    }
}


// MARK:- --------- UITableView Datasources/Delegate
extension EventSharedDetailImageViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var sectionCnt = 0
        if arrInvitedUser.count > 0{
            sectionCnt += 1
        }
        if arrCommentList.count > 0{
            sectionCnt += 1
        }
        return sectionCnt
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let header = EventCommentTblHeader.viewFromXib as? EventCommentTblHeader else {
            return nil
        }
        func setHeaderTile() {
            var text = ""
            switch self.actionType {
            case 1:
                text = CInviteesMayJoinEvent
                break
            case 2:
                text = CMessageInviteeAcceptedEvent
                break
            case 3:
                text = CInviteesDeclinedEvent
                break
            default:
                text = CMessageInviteeAcceptedEvent
                break
            }
            header.lblTitle.text = "\(arrInvitedUser.count) " + text
            
        }
        if section == 0 && arrInvitedUser.count > 0{
            header.backgroundColor =  CRGB(r: 240, g: 245, b: 233)
            setHeaderTile()
            header.btnDropDown.isHidden = (self.arrDropDown.count <= 1)
            header.btnDropDown.touchUpInside { [weak self] (_) in
                guard let self = self else { return }
                header.txtDropDown.setPickerData(arrPickerData: self.arrDropDown, selectedPickerDataHandler: { [weak self] (text, row, component) in
                    guard let self = self else { return }
                    self.setDropDownList(action: self.arrDropDown[row])
                    setHeaderTile()
                    }, defaultPlaceholder: "")
                header.txtDropDown.becomeFirstResponder()
            }
            
        } else {
            header.btnDropDown.isHidden = true
            header.backgroundColor =  CRGB(r: 249, g: 250, b: 250)
            header.lblTitle.text = appDelegate.getCommentCountString(comment: commentCount)
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && arrInvitedUser.count > 0{
            return 60.0
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 && arrInvitedUser.count > 0{
            return 1
        }
        return arrCommentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 && arrInvitedUser.count > 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "EventInviteesAcceptedTblCell") as? EventInviteesAcceptedTblCell else {
                return UITableViewCell(frame: .zero)
            }
            cell.arrInvitedUser = self.arrInvitedUser
            cell.viewAllInvitees = { [weak self] in
                guard let self = self else { return }
                guard let eventInviteesVC = CStoryboardEvent.instantiateViewController(withIdentifier: "EventInviteesViewController") as? EventInviteesViewController else {
                    return
                }
                let postId = self.eventInfo.valueForInt(key: CId)
                eventInviteesVC.eventId = postId
                eventInviteesVC.arrInvitees = self.arrInvitedUser
                eventInviteesVC.actionType = self.actionType
                self.navigationController?.pushViewController(eventInviteesVC, animated: true)
            }
            return cell
        }
        
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



// MARK:- -------- Action Event
extension EventSharedDetailImageViewController{
    
    @IBAction func btnInterestMayBe(_ sender : UIButton){
        
        btnInterested.isSelected = false
        btnMaybe.isSelected = false
        btnNotInterested.isSelected = false
        sender.isSelected = true
        
        var type = 0
        switch sender.tag {
        case 1:
            type = CTypeInterested
        case 2:
            type = CTypeNotInterested
        default:
            type = CTypeMayBeInterested
        }
        self.btnInterestedNotInterestedMayBeCLK(type)
    }
    
    @IBAction func btnLikeCLK(_ sender : UIButton){
        if sender.tag == 0{
            // LIKE CLK
            
            btnLike.isSelected = !btnLike.isSelected
            
            likeCount = btnLike.isSelected ? likeCount + 1 : likeCount - 1
            
            btnLikeCount.setTitle(appDelegate.getLikeString(like: likeCount), for: .normal)
            MIGeneralsAPI.shared().likeUnlikePostWebsite(post_id: self.postID, rss_id: nil, type: 1, likeStatus: btnLike.isSelected ? 1 : 0, viewController: self)
        }else{
            // LIKE COUNT CLK
            if let likeVC = CStoryboardGeneral.instantiateViewController(withIdentifier: "LikeViewController") as? LikeViewController {
                likeVC.postID = self.postID
                self.navigationController?.pushViewController(likeVC, animated: true)
            }
        }
    }
    
    @IBAction func btnShareReportCLK(_ sender : UIButton){
        
        //self.presentActivityViewController(mediaData: eventInfo.valueForString(key: CShare_url), contentTitle: CSharePostContentMsg)
        let sharePost = SharePostHelper(controller: self, dataSet: eventInfo)
        sharePost.shareURL = eventInfo.valueForString(key: CShare_url)
        sharePost.presentShareActivity()
    }
    
    @IBAction func btnCommentCLK(_ sender : UIButton){
        if let commentVC = CStoryboardGeneral.instantiateViewController(withIdentifier: "CommentViewController") as? CommentViewController {
            commentVC.postId = self.postID
            self.navigationController?.pushViewController(commentVC, animated: true)
        }
    }
    
    @objc fileprivate func btnMenuClicked(_ sender : UIBarButtonItem) {
        
        let userID = (eventInfo[CSharedPost] as? [String:Any] ?? [:])[CUserId] as? Int64 ?? 0
        if userID == appDelegate.loginUser?.user_id{
            
            if let endDateTime = eventInfo.valueForDouble(key: CEvent_End_Date), (Double(currentDateTime) > endDateTime) {
                
                self.presentActionsheetWithOneButton(actionSheetTitle: nil, actionSheetMessage: nil, btnOneTitle: CBtnDelete, btnOneStyle: .default) { [weak self] (onActionClicked) in
                    guard let `self` = self else { return }
                    
                    //...Delete Post
                    self.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: CMessageDeletePost, btnOneTitle: CBtnOk, btnOneTapped: { [weak self] (action) in
                        guard let self = self else { return }
                        self.deletePost()
                        }, btnTwoTitle: CBtnCancel, btnTwoTapped: nil)
                }
            } else {
                
                self.presentActionsheetWithTwoButtons(actionSheetTitle: nil, actionSheetMessage: nil, btnOneTitle: CBtnEdit, btnOneStyle: .default, btnOneTapped: { [weak self] (alert) in
                    guard let self = self else { return }
                    if let sharePost = CStoryboardSharedPost.instantiateViewController(withIdentifier: "SharePostViewController") as? SharePostViewController{
                        sharePost.postData = self.eventInfo
                        sharePost.isFromEdit = true
                        self.navigationController?.pushViewController(sharePost, animated: true)
                    }
                }, btnTwoTitle: CBtnDelete, btnTwoStyle: .default) { [weak self] (alert) in
                    guard let self = self else { return }
                    
                    //...Delete Post
                    self.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: CMessageDeletePost, btnOneTitle: CBtnOk, btnOneTapped: { [weak self] (action) in
                        guard let self = self else { return }
                        self.deletePost()
                        }, btnTwoTitle: CBtnCancel, btnTwoTapped: nil)
                }
            }
        }else {
            let sharePostData = eventInfo[CSharedPost] as? [String:Any] ?? [:]
            if let reportVC = CStoryboardGeneral.instantiateViewController(withIdentifier: "ReportViewController") as? ReportViewController {
                reportVC.reportType = .reportEvent
                reportVC.isSharedPost = true
                reportVC.userID = sharePostData.valueForInt(key: CUserId)
                reportVC.reportID = sharePostData.valueForInt(key: CId)
                self.navigationController?.pushViewController(reportVC, animated: true)
            }
        }
    }
    
    @objc fileprivate func btnCalenderClicked(_ sender : UIBarButtonItem) {
        if let eventListVC = CStoryboardEvent.instantiateViewController(withIdentifier: "EventListViewController") as? EventListViewController{
            eventListVC.view.tag = 107
            self.navigationController?.pushViewController(eventListVC, animated: true)
        }
    }
}

// MARK:- --------- Api functions
extension EventSharedDetailImageViewController{
    
    fileprivate func getCommentListFromServer(showLoader: Bool){
        
        if apiTask?.state == URLSessionTask.State.running {
            self.refreshControl.endRefreshing()
            return
        }
        
        // Add load more indicator here...
        self.tblCommentList.tableFooterView = self.pageNumber > 2 ? self.loadMoreIndicator(ColorAppTheme) : UIView()
        
//        apiTask = APIRequest.shared().getCommentList(page: pageNumber, showLoader: showLoader, post_id: self.postID, rss_id: self.rssId) { [weak self] (response, error) in
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


// MARK:-  --------- Generic UITextView Delegate
extension EventSharedDetailImageViewController: GenericTextViewDelegate{
    
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
extension EventSharedDetailImageViewController: UserSuggestionDelegate{
    func didSelectSuggestedUser(_ userInfo: [String : Any]) {
        viewUserSuggestion.arrangeFinalComment(userInfo, textView: txtViewComment)
    }
}

// MARK:-  --------- Action Event
extension EventSharedDetailImageViewController{
    @IBAction func btnSendCommentCLK(_ sender : UIButton){
        self.resignKeyboard()
        
        if (txtViewComment.text?.isBlank)! {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageCommentBlank, btnOneTitle: CBtnOk, btnOneTapped: nil)
        } else {
            
            // Get Final text for comment..
            let strComment = viewUserSuggestion.stringToBeSendInComment(txtViewComment)
            
            // Get Mention user's Ids..
            let includedUser = viewUserSuggestion.arrSelectedUser.map({$0.valueForString(key: CUserId) }).joined(separator: ",")
            
//            APIRequest.shared().sendComment(post_id: self.postID, commentId: self.editCommentId, rss_id: rssId, type: rssId != nil ? 2 : 1, comment: strComment, include_user_id: includedUser) { [weak self] (response, error) in
//                guard let self = self else { return }
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
//                                MIGeneralsAPI.shared().refreshPostRelatedScreens(responsInfo, self.postID, self, .commentPost)
//                            }
//                        }else{
//                            // Edit comment in array
//                            if let index = self.arrCommentList.firstIndex(where: { $0[CId] as? Int ==  (self.editCommentId ?? 0)}) {
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
//                    MIGeneralsAPI.shared().refreshPostRelatedScreens(nil, self.postID, self, .deleteComment)
//                }
//            }
//        }
    }
}
