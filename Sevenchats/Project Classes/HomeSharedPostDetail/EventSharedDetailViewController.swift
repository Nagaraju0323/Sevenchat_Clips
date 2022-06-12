//
//  EventSharedDetailViewController.swift
//  Sevenchats
//
//  Created by mac-0005 on 22/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Nagaraju K and Chandrika R                                 *
 * Model   : EventSharedDetailViewController             *
 * Changes :                                             *
 *                                                       *
 ********************************************************/

import UIKit
import ActiveLabel

class EventSharedDetailViewController: ParentViewController {

    @IBOutlet weak var lblEventType : UILabel!
    @IBOutlet weak var lblEventTitle : UILabel!
    @IBOutlet weak var lblEventPostDate : UILabel!
    @IBOutlet weak var lblEventStartDate : UILabel!
    @IBOutlet weak var lblStartDate : UILabel!
    @IBOutlet weak var lblEndDate : UILabel!
    @IBOutlet weak var lblEventEndDate : UILabel!
    @IBOutlet weak var lblEventAddress : UILabel!
    @IBOutlet weak var lblEventDescription : UILabel!
    @IBOutlet weak var lblEventCategory : UILabel!
    //@IBOutlet weak var lblInvitedUserCount : UILabel!
    //@IBOutlet weak var lblAboutEvent : UILabel!
    
    @IBOutlet weak var btnLikeCount : UIButton!
    @IBOutlet weak var btnLike : UIButton!
    @IBOutlet weak var btnComment : UIButton!
    @IBOutlet weak var btnShare : UIButton!
    @IBOutlet weak var btnMaybe : UIButton!
    @IBOutlet weak var btnNotInterested : UIButton!
    @IBOutlet weak var btnInterested : UIButton!
    
    //@IBOutlet weak var viewEventImage : UIView!
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
    
    @IBOutlet weak var lblSharedPostDate : UILabel!
    @IBOutlet weak var imgSharedUser : UIImageView!
    @IBOutlet weak var lblSharedUserName : UILabel!
    @IBOutlet weak var btnSharedProfileImg : UIButton!
    @IBOutlet weak var btnSharedUserName : UIButton!
    @IBOutlet weak var lblMessage : UILabel!
    @IBOutlet weak var lblSharedPostType : UILabel!
    
    @IBOutlet weak var btnProfileImg : UIButton!
    @IBOutlet weak var btnUserName : UIButton!

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
    var Interested = ""
    var notInterested = ""
    var mayBe = ""
    var notificationInfo = [String:Any]()
    var isSelectedChoice = ""
    var isLikeSelected = false
    var selectedChoice = ""
    var posted_ID = ""
    var postIDNew : String?
    var isLikesOthersPage:Bool?
    var isLikesHomePage:Bool?
    var isLikesMyprofilePage:Bool?
    
    
    let currentDateTime = Date().timeIntervalSince1970
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Initialization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateUIAccordingToLanguage()
        self.setEventDetail(dict: eventInfo)
        self.openUserProfileScreen()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK:- -------- Initialization
    func Initialization(){
        
        self.title = CNavEventsDetails
        lblSharedPostType.text = CSharedEvents
        imgUser.layer.cornerRadius = imgUser.frame.size.width / 2
        self.imgSharedUser.layer.cornerRadius = self.imgSharedUser.frame.size.width / 2
        self.imgSharedUser.layer.borderWidth = 2
        self.imgSharedUser.layer.borderColor = #colorLiteral(red: 0, green: 0.7881455421, blue: 0.7100172639, alpha: 1)
        self.imgUser.layer.borderWidth = 2
        self.imgUser.layer.borderColor = #colorLiteral(red: 0, green: 0.7881455421, blue: 0.7100172639, alpha: 1)

        lblEventType.layer.cornerRadius = 3
        self.view.backgroundColor = CRGB(r: 249, g: 250, b: 250)
        self.parentView.backgroundColor = .clear
        self.tblCommentList.backgroundColor = .clear
        
        func setupInterestButton(sender:UIButton){
            sender.layer.cornerRadius = 4
            sender.clipsToBounds = true
        }
        setupInterestButton(sender: btnInterested)
        setupInterestButton(sender: btnNotInterested)
        setupInterestButton(sender: btnMaybe)
        
        self.btnShare.setTitle(CBtnShare, for: .normal)
        
        self.refreshControl.addTarget(self, action: #selector(self.pullToRefresh), for: .valueChanged)
        self.refreshControl.tintColor = ColorAppTheme
        self.tblCommentList.pullToRefreshControl = self.refreshControl
        self.pageNumber = 1
        
        self.loadEventDetailFromServer()
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
extension EventSharedDetailViewController {
    
    func loadEventDetailFromServer() {
//        self.parentView.isHidden = true
//        APIRequest.shared().viewPostDetail(postID: self.postID) { [weak self] (response, error) in
//            guard let self = self else { return }
//            if response != nil {
//                self.parentView.isHidden = false
//                self.setEventDetail(dict: response?.value(forKey: CJsonData) as! [String : AnyObject])
//                self.openUserProfileScreen()
//            }
//            self.getCommentListFromServer(showLoader: true)
//        }
    }
    
    fileprivate func openUserProfileScreen(){
        
        self.btnSharedProfileImg.touchUpInside { [weak self] (sender) in
            guard let self = self else { return }
            appDelegate.moveOnProfileScreenNew(self.eventInfo.valueForString(key: CSharedUserID), self.eventInfo.valueForString(key: CSharedEmailID), self)
        }
        
        self.btnSharedUserName.touchUpInside { [weak self] (sender) in
            guard let self = self else { return }
            appDelegate.moveOnProfileScreenNew(self.eventInfo.valueForString(key: CSharedUserID), self.eventInfo.valueForString(key: CSharedEmailID), self)
        }
        
        self.btnProfileImg.touchUpInside { [weak self] (sender) in
            guard let self = self else { return }
            appDelegate.moveOnProfileScreenNew(self.eventInfo.valueForString(key: CUserId), self.eventInfo.valueForString(key: CUsermailID), self)
        }
        
        self.btnUserName.touchUpInside { [weak self] (sender) in
            guard let self = self else { return }
            appDelegate.moveOnProfileScreenNew(self.eventInfo.valueForString(key: CUserId), self.eventInfo.valueForString(key: CUsermailID), self)
        }
    }
    
    func setEventDetail(dict : [String : Any]) {
        
        //...Set prefilled event detail here
        eventInfo = dict
       // if let sharedData = dict[CSharedPost] as? [String:Any]{
            self.lblSharedUserName.text = dict.valueForString(key: CFullName) + " " + dict.valueForString(key: CLastName)
            let shared_created_at = dict.valueForString(key: CShared_Created_at)
             let shared_cnv_date = shared_created_at.stringBefore("G")
             let sharedCreated = DateFormatter.shared().convertDatereversLatest(strDate: shared_cnv_date)
             lblSharedPostDate.text = sharedCreated
            let str_Back_desc_share = dict.valueForString(key: CMessage).return_replaceBack(replaceBack: dict.valueForString(key: CMessage))
                      lblMessage.text = str_Back_desc_share
           // lblMessage.text = sharedData.valueForString(key: CMessage)
       // }
        self.parentView.isHidden = false
        self.lbluserName.text = "\(dict.valueForString(key: CFirstname)) \(dict.valueForString(key: CLastname))"
        let created_At = dict.valueForString(key: CCreated_at)
                    let cnvStr = created_At.stringBefore("G")
                    let startCreated = DateFormatter.shared().convertDatereversLatest(strDate: cnvStr)
        lblEventPostDate.text = startCreated
        self.lblEventCategory.text = dict.valueForString(key: CCategory).uppercased()
        self.lblEventType.text = CTypeEvent
        let str_Back_title = dict.valueForString(key: CTitle).return_replaceBack(replaceBack: dict.valueForString(key: CTitle))
        lblEventTitle.text = str_Back_title
                    
                     let str_Back_desc = dict.valueForString(key: CContent).return_replaceBack(replaceBack: dict.valueForString(key: CContent))
        lblEventDescription.text = str_Back_desc
//        self.lblEventTitle.text = dict.valueForString(key: CTitle)
//        self.lblEventDescription.text = dict.valueForString(key: CContent)
        
//        self.lblStartDate.text = "\(CStartDate)"
//        self.lblEndDate.text = "\(CEndDate)"
        
        let created_At1 = eventInfo.valueForString(key: "start_date")
        let cnvStr1 = created_At1.stringBefore("G")
        guard let startCreated1 = DateFormatter.shared().convertDatereversLatest(strDate: cnvStr1)  else { return}
        self.lblEventStartDate.text = startCreated1
        let created_At2 = eventInfo.valueForString(key: "end_date")
        let cnvStr2 = created_At2.stringBefore("G")
        guard let startCreated2 = DateFormatter.shared().convertDatereversLatest(strDate: cnvStr2) else { return}
        self.lblEventEndDate.text = startCreated2
        
        self.lblEventAddress.text = dict.valueForString(key: CEvent_Location)
        btnMaybe.setTitle("\(dict.valueForString(key: "maybe_count"))\n" + CMaybe, for: .normal)
        btnNotInterested.setTitle("\(dict.valueForString(key: "no_count"))\n" + CDeclined, for: .normal)
        btnInterested.setTitle("\(dict.valueForString(key: "yes_count"))\n" + CConfirmed, for: .normal)
        self.Interested = dict.valueForString(key: "yes_count")
        self.notInterested = dict.valueForString(key: "no_count")
        self.mayBe = dict.valueForString(key: "maybe_count")
        self.isSelectedChoice = dict.valueForString(key: "selected_choice")

        
        /*if dict.valueForString(key: CImage).isBlank{
         //viewEventImage.hide(byHeight: true)
         viewEventImage.isHidden = true
         }else{
         imgVEvent.loadImageFromUrl(dict.valueForString(key: CImage), false)
         }*/
        
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
        
        if isLikesOthersPage == true {
            
            switch dict.valueForString(key: "friend_selected_choice").toInt ?? 0 {
            case 3:
                btnMaybe.isSelected = true
            case 1:
                btnInterested.isSelected = true
            case 2:
                btnNotInterested.isSelected = true
            default:
                break
            }
            
            
        }else {
            
            switch dict.valueForString(key: "selected_choice").toInt ?? 0 {
            case 3:
                btnMaybe.isSelected = true
            case 1:
                btnInterested.isSelected = true
            case 2:
                btnNotInterested.isSelected = true
            default:
                break
            }
            
        }

        setSelectedButtonStyle(dict)
        setSelectedButtonStyle()
        
        
        imgUser.loadImageFromUrl(dict.valueForString(key: CUserProfileImage), true)
        if dict.valueForString(key: "user_email") == appDelegate.loginUser?.email{
            if self.isHideNavCalenderButton {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_btn_nav_more"), style: .plain, target: self, action: #selector(btnMenuClicked(_:)))
            }else {
            }
        }else{
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_btn_nav_more"), style: .plain, target: self, action: #selector(btnMenuClicked(_:)))
       /* if Int64(dict.valueForString(key: CUserId)) == appDelegate.loginUser?.user_id{
            if self.isHideNavCalenderButton {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_btn_nav_more"), style: .plain, target: self, action: #selector(btnMenuClicked(_:)))
            }else {
                self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: #imageLiteral(resourceName: "ic_btn_nav_more"), style: .plain, target: self, action: #selector(btnMenuClicked(_:))),UIBarButtonItem(image: #imageLiteral(resourceName: "ic_event_calender"), style: .plain, target: self, action: #selector(btnCalenderClicked(_:)))]
            }
        }else{
            if !self.isHideNavCalenderButton {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_event_calender"), style: .plain, target: self, action: #selector(btnCalenderClicked(_:)))
            }
        }*/
        
        
        self.arrMaybe = dict.valueForJSON(key: "maybe_event_users") as? [[String : Any]] ?? []
        self.arrDeclined = dict.valueForJSON(key: "decline_event_users") as? [[String : Any]] ?? []
        self.arrConfirmed = dict.valueForJSON(key: "event_users") as? [[String : Any]] ?? []
        
        self.arrInvitedUser = self.arrConfirmed
        self.setDefaultEventActionList()
        self.tblUserList.reloadData()

        
        self.tblCommentList.updateHeaderViewHeight(extxtraSpace: 0)
    }
    func setSelectedButtonStyle(_ dict : [String : Any]?){
       
        if isLikesOthersPage == true {
            selectedChoice = dict?.valueForString(key:"friend_selected_choice") ?? ""
        }else {
            selectedChoice = dict?.valueForString(key:"selected_choice") ?? ""
        }
//        selectedChoice = dict?.valueForString(key:"selected_choice") ?? ""
        
        btnInterested.layer.borderColor = CRGB(r: 223, g: 234, b: 227).cgColor
        btnInterested.layer.borderWidth = 2
        btnInterested.backgroundColor =  .clear
        
        btnMaybe.layer.borderColor = CRGB(r: 255, g: 237, b: 216).cgColor
        btnMaybe.layer.borderWidth = 2
        btnMaybe.backgroundColor =  .clear
        
        btnNotInterested.layer.borderColor = CRGB(r: 255, g: 214, b: 214).cgColor
        btnNotInterested.layer.borderWidth = 2
        btnNotInterested.backgroundColor =  .clear
        
        if isLikesOthersPage == true {
//            selectedChoice = dict?.valueForString(key:"friend_selected_choice") ?? ""
            if dict?.valueForString(key:"friend_selected_choice") == "3"{
                btnMaybe.isSelected = true
                btnMaybe.backgroundColor =  CRGB(r: 255, g: 237, b: 216)
            }else if dict?.valueForString(key:"friend_selected_choice") == "2"{
                btnNotInterested.isSelected = true
                btnNotInterested.backgroundColor =  CRGB(r: 255, g: 214, b: 214)
            }else if dict?.valueForString(key:"friend_selected_choice") == "1"{
                btnInterested.isSelected = true
                btnInterested.backgroundColor =  CRGB(r: 223, g: 234, b: 227)
            }
        }else {
//            selectedChoice = dict?.valueForString(key:"selected_choice") ?? ""
            if dict?.valueForString(key:"selected_choice") == "3"{
                btnMaybe.isSelected = true
                btnMaybe.backgroundColor =  CRGB(r: 255, g: 237, b: 216)
            }else if dict?.valueForString(key:"selected_choice") == "2"{
                btnNotInterested.isSelected = true
                btnNotInterested.backgroundColor =  CRGB(r: 255, g: 214, b: 214)
            }else if dict?.valueForString(key:"selected_choice") == "1"{
                btnInterested.isSelected = true
                btnInterested.backgroundColor =  CRGB(r: 223, g: 234, b: 227)
            }
        }
        
        
        
//        if dict?.valueForString(key:"selected_choice") == "3"{
//            btnMaybe.isSelected = true
//            btnMaybe.backgroundColor =  CRGB(r: 255, g: 237, b: 216)
//        }else if dict?.valueForString(key:"selected_choice") == "2"{
//            btnNotInterested.isSelected = true
//            btnNotInterested.backgroundColor =  CRGB(r: 255, g: 214, b: 214)
//        }else if dict?.valueForString(key:"selected_choice") == "1"{
//            btnInterested.isSelected = true
//            btnInterested.backgroundColor =  CRGB(r: 223, g: 234, b: 227)
//        }
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
    func selectedoption(){
        if selectedChoice.toInt == 1 {
            //btnMaybe.isEnabled = false
            btnMaybe.isSelected = false
            btnNotInterested.isSelected = false
            btnInterested.isSelected = true
           // onChangeEventStatus?(CTypeInterested)
        }else if selectedChoice.toInt == 3 {
            btnMaybe.isSelected = true
            btnNotInterested.isSelected = false
            btnInterested.isSelected = false
           // onChangeEventStatus?(CTypeMayBeInterested)
        }else if selectedChoice.toInt == 2 {
            btnMaybe.isSelected = false
            btnNotInterested.isSelected = true
            btnInterested.isSelected = false
           // onChangeEventStatus?(CTypeNotInterested)
        }
    }
    fileprivate func btnInterestedNotInterestedMayBeCLK(_ type : Int?){
        
        if type != eventInfo.valueForInt(key: CIsInterested){
            if eventInfo.valueForInt(key: "selected_choice") == 1 || eventInfo.valueForInt(key: "selected_choice") == 2  || eventInfo.valueForInt(key: "selected_choice") == 3 || eventInfo.valueForInt(key: "friend_selected_choice") == 1  || eventInfo.valueForInt(key: "friend_selected_choice") == 2  ||  eventInfo.valueForInt(key: "friend_selected_choice") == 3 {
                if selectedChoice.toInt == 1 {
                   // btnMaybe.isEnabled = false
                    btnMaybe.isSelected = false
                    btnNotInterested.isSelected = false
                    btnInterested.isSelected = true
                   // onChangeEventStatus?(CTypeInterested)
                }else if selectedChoice.toInt == 3 {
                    btnMaybe.isSelected = true
                    btnNotInterested.isSelected = false
                    btnInterested.isSelected = false
                   // onChangeEventStatus?(CTypeMayBeInterested)
                }else if selectedChoice.toInt == 2 {
                    btnMaybe.isSelected = false
                    btnNotInterested.isSelected = true
                    btnInterested.isSelected = false
                   // onChangeEventStatus?(CTypeNotInterested)
                }
                return
            }else {

            //MARK:- NEW
            let totalIntersted = eventInfo.valueForString(key: "yes_count")
            let totalNotIntersted = eventInfo.valueForString(key:"no_count")
            let totalMaybe = eventInfo.valueForString(key: "maybe_count")
                guard let user_ID = appDelegate.loginUser?.user_id.description else { return }
                guard let firstName = appDelegate.loginUser?.first_name else {return}
                guard let lastName = appDelegate.loginUser?.last_name else {return}
                print(self.posted_ID)
            switch eventInfo.valueForInt(key: CIsInterested) {
            case CTypeInterested:
                
                if self.posted_ID == user_ID {
                    eventInfo["yes_count"] = totalIntersted.toInt ?? 0 - 1
                }else {
                    if self.Interested.toInt == 0 && self.notInterested.toInt == 0 && self.mayBe.toInt == 0 || isSelectedChoice == "null"{
                        var intrestCount = self.Interested.toInt ?? 0
                        intrestCount = +1
                        notificationInfo["yes_count"] = intrestCount.toString
                        notificationInfo["selected_choice"] = "1"
                      MIGeneralsAPI.shared().sendNotification(self.posted_ID, userID: user_ID, subject: " has tentatively Accept event", MsgType: "EVENT_CHOICE", MsgSent: "", showDisplayContent: "has tentatively Accept event", senderName: firstName + lastName, post_ID: notificationInfo,shareLink: "sendEventChLink")
                    }
                    eventInfo["yes_count"] = totalIntersted.toInt ?? 0 - 1
                }
                break
            case CTypeNotInterested:
                    if self.posted_ID == user_ID {
                        eventInfo["no_count"] = totalNotIntersted.toInt ?? 0 - 1
                    }else {
                        
                        if self.Interested.toInt == 0 && self.notInterested.toInt == 0 && self.mayBe.toInt == 0 || isSelectedChoice == "null"{
                            var notIntrestCount = self.notInterested.toInt ?? 0
                            notIntrestCount = +1
                            notificationInfo["no_count"] = notIntrestCount
                            notificationInfo["selected_choice"] = "2"

                        MIGeneralsAPI.shared().sendNotification(self.posted_ID, userID: user_ID, subject: " has tentatively Decline event", MsgType: "EVENT_CHOICE", MsgSent: "", showDisplayContent: "has tentatively Accept event", senderName: firstName + lastName, post_ID: notificationInfo,shareLink: "sendEventChLink")
                        }
                        eventInfo["no_count"] = totalNotIntersted.toInt ?? 0 - 1
                    }
                break
            case CTypeMayBeInterested:
                
                if self.posted_ID == user_ID {
                    eventInfo["maybe_count"] = totalMaybe.toInt ?? 0 - 1
                }else {
                    if self.Interested.toInt == 0 && self.notInterested.toInt == 0 && self.mayBe.toInt == 0 || isSelectedChoice == "null"{
                        var maybeCount = self.mayBe.toInt ?? 0
                        maybeCount = +1
                        notificationInfo["maybe_count"] = maybeCount
                        notificationInfo["selected_choice"] = "3"
                        MIGeneralsAPI.shared().sendNotification(self.posted_ID, userID: user_ID, subject: " has tentatively Maybe event", MsgType: "EVENT_CHOICE", MsgSent: "", showDisplayContent: "has tentatively Accept event", senderName: firstName + lastName, post_ID: [:],shareLink: "sendEventChLink")
                    }
                    eventInfo["maybe_count"] = totalMaybe.toInt ?? 0 - 1
                }
                break
            default:
                break
            }
            eventInfo[CIsInterested] = type
            
            switch type {
            case CTypeInterested:
               // selectedoption()
                let yesCount = totalIntersted.toInt ?? 0
                let totalCnt = (yesCount + 1).toString
                eventInfo["yes_count"] = totalCnt.toInt ?? 0 - 1
                break
            case CTypeNotInterested:
               // selectedoption()
                let yesCount = totalNotIntersted.toInt ?? 0
                let totalCnt = (yesCount + 1).toString
                eventInfo["no_count"] = totalCnt.toInt ?? 0 - 1
                break
            case CTypeMayBeInterested:
               // selectedoption()
                let yesCount = totalMaybe.toInt ?? 0
                let totalCnt = (yesCount + 1).toString
                eventInfo["maybe_count"] = totalCnt.toInt ?? 0 - 1
                break
            default:
                break
            }
            //var postId = postInfo.valueForInt(key: CId)
            let postId = eventInfo.valueForString(key: "post_id")
            _ = eventInfo.valueForInt(key: CIsSharedPost)
            self.setEventDetail(dict: eventInfo)
            MIGeneralsAPI.shared().interestNotInterestMayBe(postId.toInt, type!, viewController: self)
            }
        }
        
    }
    
    func deletePost() {
        self.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: CMessageDeletePost, btnOneTitle: CBtnYes, btnOneTapped: { [weak self] (alert) in
            
            let postTypeDelete = "post_event"
            let dict =
                [
                    "post_id": self?.eventInfo.valueForString(key: "post_id"),
                    "image": self?.eventInfo.valueForString(key: "image"),
                    "post_title": self?.eventInfo.valueForString(key: "post_title"),
                    "post_category": self?.eventInfo.valueForString(key: "post_category"),
                    "post_content": self?.eventInfo.valueForString(key: "post_content"),
                    "age_limit": self?.eventInfo.valueForString(key: "age_limit"),
                    "latitude": self?.eventInfo.valueForString(key: "latitude"),
                    "longitude": self?.eventInfo.valueForString(key: "longitude"),
                    "start_date": self?.eventInfo.valueForString(key: "start_date"),
                    "end_date": self?.eventInfo.valueForString(key: "end_date"),
                    "targeted_audience": self?.eventInfo.valueForString(key: "targeted_audience"),
                    "selected_persons": self?.eventInfo.valueForString(key: "selected_persons"),
                    "status_id": "3"
                ]
            APIRequest.shared().deletePostNew(postDetials: dict as [String : Any], apiKeyCall: postTypeDelete, completion: { [weak self](response, error) in
                guard let self = self else { return }
                if response != nil && error == nil{
                    self.navigationController?.popViewController(animated: true)
                    // MIGeneralsAPI.shared().refreshPostRelatedScreens(nil, chirID, self, .deletePost)
                }
            })
        }, btnTwoTitle: CBtnNo, btnTwoTapped: nil)
    }
}


// MARK:- --------- UITableView Datasources/Delegate
extension EventSharedDetailViewController: UITableViewDelegate, UITableViewDataSource{
    
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
                let postId = self.eventInfo.valueForInt(key: COriginalPostId)
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
extension EventSharedDetailViewController{
    
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
                    
                    self.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: CMessageDeletePost, btnOneTitle: CBtnOk, btnOneTapped: { (action) in
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
                    self.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: CMessageDeletePost, btnOneTitle: CBtnOk, btnOneTapped: { (action) in
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
extension EventSharedDetailViewController{
    @objc func pullToRefresh() {
        if apiTask?.state == URLSessionTask.State.running {
            apiTask?.cancel()
        }
        
        self.pageNumber = 1
        refreshControl.beginRefreshing()
        self.loadEventDetailFromServer()
    }
    
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
extension EventSharedDetailViewController: GenericTextViewDelegate{
    
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
extension EventSharedDetailViewController: UserSuggestionDelegate{
    func didSelectSuggestedUser(_ userInfo: [String : Any]) {
        viewUserSuggestion.arrangeFinalComment(userInfo, textView: txtViewComment)
    }
}

// MARK:-  --------- Action Event
extension EventSharedDetailViewController{
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
