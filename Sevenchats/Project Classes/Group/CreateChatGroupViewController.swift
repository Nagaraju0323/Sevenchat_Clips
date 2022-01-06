//
//  CreateChatGroupViewController.swift
//  Sevenchats
//
//  Created by mac-0005 on 30/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class CreateChatGroupViewController: ParentViewController {

    @IBOutlet var txtGroupTitle : MIGenericTextFiled!
    @IBOutlet var viewAddImageContainer : UIView!
    @IBOutlet var viewUploadedImageContainer : UIView!
    @IBOutlet var imgGroupIcon : UIImageView!
    @IBOutlet var btnPublic : UIButton!
    @IBOutlet var btnPrivate : UIButton!
    @IBOutlet var btnSwitch : UISwitch!
    @IBOutlet var lblUploadImg : UILabel!
    @IBOutlet var lblCreateGroupLink : UILabel!
    @IBOutlet var lblAddParticipant : UILabel!

    @IBOutlet var activityLoader : UIActivityIndicatorView!
    @IBOutlet var tblGroupSuggestion : UITableView!
    @IBOutlet var tblParticipants : UITableView!
    @IBOutlet var viewGroupSuggestion : UIView!
    @IBOutlet var viewAddParticipants : UIView!
    @IBOutlet var cnViewGroupSuggestionHeight : NSLayoutConstraint!
    @IBOutlet var cnTblParticipantsHeight : NSLayoutConstraint!
    
    var refreshControl = UIRefreshControl()
    var apiTask : URLSessionTask?
    var arrGroupSuggestion = [[String : Any]]()
    var arrSelectedParticipants = [[String : Any]]()
    var arrMembers = [[String : Any]]()
    
    
    var groupID : Int?
    var groupID_New : String?
    var currentPage = 1
    var groupImage:UIImage?
    var imgUrl = ""
    var imgName = ""
    var userID = ""
    var editGroup:Bool?
    var isSelected = false
    var userIdNot = ""
    var defaultImgUrl = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Initialization()
        
        btnSwitch.isHidden = true
        lblCreateGroupLink.isHidden = true
        btnPrivate.isHidden = true
        btnPublic.isHidden = true 
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 10
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateUIAccordingToLanguage()
        guard let userid = appDelegate.loginUser?.user_id else { return }
        userID = userid.description
    }
    // MARK:- --------- Initialization
    
    func Initialization(){
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_apply_filter"), style: .plain, target: self, action: #selector(btnDoneCLK(_:)))
        viewUploadedImageContainer.isHidden = true
        txtGroupTitle.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        NotificationCenter.default.addObserver(self, selector:#selector(self.keyboardWillDisappear(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 128
        
        viewGroupSuggestion.layer.shadowColor = CRGB(r: 230, g: 235, b: 239).cgColor
        viewGroupSuggestion.layer.shadowOpacity = 2
        viewGroupSuggestion.layer.shadowOffset = CGSize(width: 0, height: 2)
        viewGroupSuggestion.layer.shadowRadius = 2
        
        refreshControl.tintColor = ColorAppTheme
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        tblGroupSuggestion.pullToRefreshControl = refreshControl
        
        if groupID != nil{
            self.title = CGroupEdit
            self.setGroupInformation()
        }else{
            self.title = CNavNewGroup
            btnPublic.isSelected = true
            btnPrivate.isSelected = false
            self.showHideTableAddParticipants()
        }
        
        self.setLanguageText()
        cnViewGroupSuggestionHeight.constant = 0
        tblGroupSuggestion.reloadData()
        
        guard let mobileNum = appDelegate.loginUser?.mobile else {return}
        
        MInioimageupload.shared().uploadMinioimages(mobileNo: mobileNum, ImageSTt: #imageLiteral(resourceName: "ic_shout_discussion"),isFrom:"",uploadFrom:"")
        MInioimageupload.shared().callback = { message in
        print("UploadImage::::::::::::::\(message)")
        self.defaultImgUrl = message
        }
    }
    
    func setLanguageText() {
        txtGroupTitle.placeHolder = CGroupEnterTitle
        lblUploadImg.text = CUploadImage
        lblCreateGroupLink.text = CGroupCreateGroupLinkToJoinGroup
        lblAddParticipant.text = CGroupAddParticipant
        btnPublic.setTitle(CGroupPublic, for: .normal)
        btnPrivate.setTitle(CGroupPrivate, for: .normal)
    }
    
    func updateUIAccordingToLanguage(){
        
        if Localization.sharedInstance.applicationFlowWithLanguageRTL() {
            // Reverse Flow...
            btnPublic.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 3)
            btnPublic.contentHorizontalAlignment = .right
            
            btnPrivate.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 3)
            btnPrivate.contentHorizontalAlignment = .right
            
        } else {
            // Normal Flow...
            btnPublic.titleEdgeInsets = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 0)
            btnPublic.contentHorizontalAlignment = .left
            btnPrivate.titleEdgeInsets = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 0)
            btnPrivate.contentHorizontalAlignment = .left
        }
        
    }
}
// MARK:- --------- Helper Functions
extension CreateChatGroupViewController {
    
    func showHideTableAddParticipants(){
        
        if arrSelectedParticipants.count > 0{
            tblParticipants.isHidden = false
            viewAddParticipants.isHidden = true
            if #available(iOS 11.0, *) {
                tblParticipants.performBatchUpdates({
                    self.cnTblParticipantsHeight.constant = tblParticipants.contentSize.height
                }) { (completed) in
                    self.cnTblParticipantsHeight.constant = self.tblParticipants.contentSize.height
                }
            } else {
                GCDMainThread.async {
                    self.cnTblParticipantsHeight.constant = self.tblParticipants.contentSize.height
                }
            }
        } else{
            viewAddParticipants.isHidden = false
            tblParticipants.isHidden = true
            cnTblParticipantsHeight.constant = 170
        }
    }
}

// MARK:- --------- Api Functions
extension CreateChatGroupViewController {
    
    @objc func pullToRefresh() {
        currentPage = 1
        refreshControl.beginRefreshing()
        self.loadSearchGroup(showLoader: false)
    }
    
    fileprivate func setGroupInformation(){
        if let groupInfo = self.iObject as? [String : Any]{
            txtGroupTitle.text = groupInfo.valueForString(key: CGroupTitle)
            txtGroupTitle.updatePlaceholderFrame(true)
            btnSwitch.isOn = groupInfo.valueForString(key: CGroupLink).isBlank ? false : true
            if groupInfo.valueForInt(key: CGroupType) == 1{
                btnPublic.isSelected = true
                btnPrivate.isSelected = false
            }else{
                btnPublic.isSelected = false
                btnPrivate.isSelected = true
            }
            
            imgGroupIcon.loadImageFromUrl(groupInfo.valueForString(key: CGroupImage), false)
            self.viewAddImageContainer.isHidden = true
            self.viewUploadedImageContainer.isHidden = false
            self.cnTblParticipantsHeight.constant = 0
            viewAddParticipants.isHidden = true
        }
    }
    
    func loadSearchGroup(showLoader : Bool) {
        
        if apiTask?.state == URLSessionTask.State.running {
            return
        }
        if showLoader {
            activityLoader.startAnimating()
        }
        
        // Add load more indicator here...
        if self.currentPage > 2 {
            self.tblGroupSuggestion.tableFooterView = self.loadMoreIndicator(ColorAppTheme)
        }else{
            self.tblGroupSuggestion.tableFooterView = nil
        }
        
//        apiTask = APIRequest.shared().searchGroupForJoin(search: txtGroupTitle.text, page: currentPage, completion: { (response, error) in
//
//            self.activityLoader.stopAnimating()
//            self.refreshControl.endRefreshing()
//            self.tblGroupSuggestion.tableFooterView = nil
//
//            if response != nil {
//
//                //...Remove all data here
//                if self.currentPage == 1{
//                    self.arrGroupSuggestion.removeAll()
//                    self.tblGroupSuggestion.reloadData()
//                }
//                if let arrData = response?.value(forKey: CJsonData) as? [[String : AnyObject]] {
//                    //...Add data
//                    if arrData.count > 0 {
//                        self.arrGroupSuggestion = self.arrGroupSuggestion + arrData
//                        self.tblGroupSuggestion.reloadData()
//                        self.currentPage += 1
//                    }
//                }
//
//                GCDMainThread.async(execute: {
//                    //...set tableview height as per contentView height
//                    self.cnViewGroupSuggestionHeight.constant = self.tblGroupSuggestion.contentSize.height > 128 ? 128 : self.tblGroupSuggestion.contentSize.height
//                })
//            }
//        })
    }
}

// MARK:- --------- Api Functions
extension CreateChatGroupViewController{
    /********************************************************
     * Author : Chandrika R                                *
     * Model  : Group Create Notification                  *
     * option                                              *
     ********************************************************/
    
    fileprivate func addEditGroup(_ moveBack : Bool){
        /*if imgGroupIcon.image == nil{
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageChatGroupImage, btnOneTitle: CBtnOk, btnOneTapped: nil)
        }else */
        var apiParaFriends = [String]()
        
        if (txtGroupTitle.text?.isBlank)!{
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageChatGroupTitle, btnOneTitle: CBtnOk, btnOneTapped: nil)
        } else if !btnPublic.isSelected && !btnPrivate.isSelected{
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageChatGroupType, btnOneTitle: CBtnOk, btnOneTapped: nil)
        } else if editGroup == true{
          
//            guard let mobileNo = appDelegate.loginUser?.mobile else {
//                return
//            }
//
//            guard let groupIconImg = groupImage else {
//                return
//            }
//            MInioimageupload.shared().uploadMinioimages(mobileNo: mobileNo, ImageSTt:groupIconImg)
//            MInioimageupload.shared().callback = { message in
//                print("message::::::::::::::\(message)")
//                self.imgUrl = message
//            }
            
            // call api here....
//            var apiPara = [String : Any]()
//            let userIDS = arrSelectedParticipants.map({$0.valueForString(key: CUserId) }).joined(separator: ",")
//            apiPara[CGroupUsersId] = userIDS
//            apiPara[CGroupTitle] = txtGroupTitle.text
//            if imgGroupIcon.image != nil {
//                apiPara[CGroupImage] = imgGroupIcon.image
//            }
//            apiPara[CGroupLink] = btnSwitch.isOn ? 1 : 0
//            apiPara[CGroupType] = btnPublic.isSelected ? 1 : 2
//
//            // While editing the group.....
//            if groupID != nil {
//                apiPara[CGroupId] = groupID
//                if let groupInfo = self.iObject as? [String : Any]{
//                    apiPara[CLink] = groupInfo.valueForString(key: CGroupLink)
//                }
//            }
            
            
            var apiPara = [String : Any]()
            apiPara[CGroupTitle] = txtGroupTitle.text
            if imgGroupIcon.image != nil {
                if self.isSelected == true {
                    apiPara[CGroupImage] = self.imgName
                }else{
                    if let groupInfo = self.iObject as? [String : Any]{
                        apiPara[CGroupImage] = groupInfo.valueForString(key: CGroupImage)
                    }
                    
                }
            }else {
                self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CUploadImage, btnOneTitle: CBtnOk, btnOneTapped: nil)
            }

//          apiPara[CGroupType] = btnPublic.isSelected ? 1 : 2
            apiPara[CGroupType] = "1"
            
            // While editing the group.....
            if groupID != nil {
                apiPara[CGroupId] = groupID?.toString
//                            if let groupInfo = self.iObject as? [String : Any]{
//                                apiPara[CLink] = groupInfo.valueForString(key: CGroupLink)
//                            }
            }

            APIRequest.shared().EditChatGroup(para: apiPara, image: imgGroupIcon.image) { (response, error) in
                if response != nil && error == nil {
                    var _groupID = "0"
                    if let groupInfo = response![CJsonData] as? [String : Any]{
                        _groupID = groupInfo.valueForString(key: "group_id")
                        // Update group info scrreen screen...
                        if let blockHandler = self.block {
                            blockHandler(groupInfo, "refresh screen")
                        }
                    }
                    
                    // Publish for create group
                    if self.groupID == nil {
                        let arrUserIDS = self.arrSelectedParticipants.map({$0.valueForString(key: CUserId) })
                        if arrUserIDS.count > 0 {
                            MIMQTT.shared().messagePayloadForGroupCreateAndDelete(arrUser: arrUserIDS, status: 0, groupId: _groupID, isSend:0)
                        }
                    }
                    
                    // Update group list screen...
                    for viewController in (self.navigationController?.viewControllers)! {
                        if viewController.isKind(of: GroupsViewController.classForCoder()){
                            let groupVC = viewController as? GroupsViewController
                            groupVC!.getGroupListFromServer(isNew: true)
                            break
                        }
                    }
                    
                    if moveBack {
                        self.navigationController?.popViewController(animated: true)
                        GCDMainThread.async {
                            if let metaInfo = response![CJsonMeta] as? [String : Any]{
                                self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: metaInfo.valueForString(key: CJsonMessage), btnOneTitle: CBtnOk, btnOneTapped: nil)
                            }
                        }
                    }
                    
                }
            }
        }else {
            
             var apiPara = [String : Any]()
             var dict = [String:Any]()
 //            let userIDS = arrSelectedParticipants.map({$0.valueForString(key: CUserId) }).joined(separator: ",")
             let userIDS = arrSelectedParticipants.map({$0.valueForString(key: "friend_user_id") }).joined(separator: ",")
             self.userIdNot = userIDS
              apiParaFriends = userIDS.components(separatedBy: ",")
 //            apiParaFriends = userIDS.joined(separator: ", ")
             
             apiPara[CGroupUsersId] = userIDS
             apiPara[CGroupTitle] = txtGroupTitle.text
             if imgGroupIcon.image != nil {
                 apiPara[CGroupImage] = imgGroupIcon.image
             }
             apiPara[CGroupLink] = btnSwitch.isOn ? 1 : 0
             apiPara[CGroupType] = btnPublic.isSelected ? 1 : 2
             
             // While editing the group.....
             if groupID != nil {
                 apiPara[CGroupId] = groupID
                 if let groupInfo = self.iObject as? [String : Any]{
                     apiPara[CLink] = groupInfo.valueForString(key: CGroupLink)
                 }
             }
            
            
             
             dict[CGroupTitle] = txtGroupTitle.text
             if imgGroupIcon.image != nil {
                 dict[CGroupImage] = imgName
             }else {
                dict[CGroupImage] = self.defaultImgUrl
                }
             
             let btnpublick = String(btnPublic.isSelected ? 1 : 2)
             
             apiParaFriends.insert(userID, at: 0)
             
             dict[CGroupType] =  btnpublick
             dict[CGroupLink] = ""
             dict["pending_request"] = "0"
             dict["block_unblock_status"] = "0"
             dict["hash_group_id"] = ""
             dict["friends_list"] = apiParaFriends
            
            APIRequest.shared().addEditChatGroup(para: dict, image: imgGroupIcon.image) { [self] (response, error) in
                 if response != nil && error == nil {
//                    if let metaInfo = response![CJsonMeta] as? [String:Any]{
//                        guard  let errorUserinfo = error?.userInfo["error"] as? String else {return}
//                        let errorMsg = errorUserinfo.stringAfter(":")
//
//                        print("erroMsg\(errorMsg)")
//
//                    }
                     
                     var _groupID = "0"
                    var _groupName = ""
                     if let groupInfo = response![CJsonData] as? [String : Any]{
                         _groupID = groupInfo.valueForString(key: "group_id")
                        let groupName = groupInfo.valueForString(key: "group_Name")
                        _groupName = groupName
                        
                         // Update group info scrreen screen...
                        self.grptopicCreate(groupID:_groupID)
                         if let blockHandler = self.block {
                             blockHandler(groupInfo, "refresh screen")
                         }
                     }
                    
                    let data = response![CJsonMeta] as? [String:Any] ?? [:]
                    let stausLike = data["status"] as? String  ?? ""
                    if stausLike == "0"{
                        let strArr = self.arrSelectedParticipants.map({$0.valueForString(key: "friend_user_id")})
                        strArr.forEach { friends_ID in
                            guard let groupID = appDelegate.loginUser?.user_id else { return }
                            if friends_ID == groupID.description{
                            }else {
                                MIGeneralsAPI.shared().sendNotification(friends_ID, userID: groupID.description, subject: "Group is added successfully", MsgType: "GROUP_ADD", MsgSent: "", showDisplayContent: "Group is added successfully", senderName: self.txtGroupTitle.text ?? "" )
                            }
                        }
                      
                    }
                     // Update group list screen...
                     for viewController in (self.navigationController?.viewControllers)! {
                         if viewController.isKind(of: GroupsViewController.classForCoder()){
                             let groupVC = viewController as? GroupsViewController
                             groupVC!.getGroupListFromServer(isNew: true)
                             break
                         }
                     }
                     if moveBack {
                         self.navigationController?.popViewController(animated: true)
                         GCDMainThread.async {
                             if let metaInfo = response![CJsonMeta] as? [String : Any]{
                                 self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CgroupCreated, btnOneTitle: CBtnOk, btnOneTapped: nil)
                             }
                         }
                     }
                 }
             }
        }
//        self.grptopicCreate(groupID:groupID_New ?? "")
    }
}
// MARK:- --------- UITextField Delegate
extension CreateChatGroupViewController{
    @objc func keyboardWillDisappear(_ textField : UITextField){
        cnViewGroupSuggestionHeight.constant = 0
    }
    
    @objc func textFieldDidChange(_ textField : UITextField){
        
        if apiTask?.state == URLSessionTask.State.running {
            apiTask?.cancel()
        }
        
        if (textField.text?.count)! > 0 {
            currentPage = 1
             //existed group and
//            self.loadSearchGroup(showLoader: false)
        }

        if textField.text?.count == 0{
            cnViewGroupSuggestionHeight.constant = 0
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
}

// MARK:- --------- UITableView Datasources/Delegate
extension CreateChatGroupViewController : UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView == tblGroupSuggestion ? arrGroupSuggestion.count : arrSelectedParticipants.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView == tblGroupSuggestion ? 40 : CScreenWidth * 65 / 375
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if tableView == tblGroupSuggestion{
            if let cell = tableView.dequeueReusableCell(withIdentifier: "GroupSuggetionTblCell", for: indexPath) as? GroupSuggetionTblCell {
                let groupInfo = arrGroupSuggestion[indexPath.row]
                cell.lblGroupName.text = groupInfo.valueForString(key: CGroup_Title)
                cell.lblGroupType.text = groupInfo.valueForString(key: CGroup_Type) == "1" ? CGroupPublic : CGroupPrivate
                cell.btnJoin.setTitle("  \(CBtnJoin)  ", for: .normal)
                
                cell.btnJoin.touchUpInside { [weak self] (sender) in
                    guard let self = self else { return }
                    self.txtGroupTitle.resignFirstResponder()
                    
//                    APIRequest.shared().joinGroup(group_id: groupInfo.valueForInt(key: CGroupId), completion: { (response, error) in
//                        if response != nil && error == nil {
//                            if let metaInfo = response![CJsonMeta] as? [String : Any]{
//                                if let blockHandler = self.block {
//                                    blockHandler(nil, "refresh screen")
//                                }
//                                self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: metaInfo.valueForString(key: CJsonMessage), btnOneTitle: CBtnOk, btnOneTapped: { (alert) in
//                                    self.navigationController?.popToRootViewController(animated: true)
//                                })
//                            }
//                        }
//                    })
                }
                
                if indexPath == tblGroupSuggestion.lastIndexPath() {
                    self.loadSearchGroup(showLoader: false)
                }
                return cell
            }
        }else{
            if let cell = tableView.dequeueReusableCell(withIdentifier: "AddParticipantsTblCell", for: indexPath) as? AddParticipantsTblCell {
                let userInfo = arrSelectedParticipants[indexPath.row]
                cell.lblUserName.text = userInfo.valueForString(key: CFirstname) + " " + userInfo.valueForString(key: CLastname)
                cell.imgUser.loadImageFromUrl(userInfo.valueForString(key: CImage), true)
                
                cell.btnDeleteUser.touchUpInside { [weak self] (sender) in
                    guard let self = self else { return }
                    self.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: CAlertGroupRemoveParticipant, btnOneTitle: CBtnYes, btnOneTapped: { (alert) in
                        
                        if userInfo.valueForJSON(key: CGroupId) != nil{
                            APIRequest.shared().removeMemberFromGroup(group_id: userInfo.valueForInt(key: CGroupId), group_users_id: userInfo.valueForString(key: CUserId), completion: { (response, error) in
                                if response != nil && error == nil{
                                    self.arrSelectedParticipants.remove(at: indexPath.row)
                                    self.tblParticipants.reloadData()
                                    self.showHideTableAddParticipants()
                                    
                                    let data = response![CJsonMeta] as? [String:Any] ?? [:]
                                    guard let userID = appDelegate.loginUser?.user_id.description else { return }
                                    let stausLike = data["status"] as? String ?? "0"
                                    if stausLike == "0" {
                                        MIGeneralsAPI.shared().sendNotification(userInfo.valueForString(key: CUserId), userID: userID, subject: "Remove group Member", MsgType: "GROUP_CHAT", MsgSent: "", showDisplayContent: "Remove group Member", senderName: "")
                                    }
                                }
                            })
                        }else{
                            self.arrSelectedParticipants.remove(at: indexPath.row)
                            self.tblParticipants.reloadData()
                            self.showHideTableAddParticipants()
                        }
                        
                    }, btnTwoTitle: CBtnNo, btnTwoTapped: nil)
                }
                return cell
            }
        }
        
        return tableView.tableViewDummyCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if tableView == tblGroupSuggestion{
            return UIView()
        }
        
        let headerVW:CreateGroupHeader = CreateGroupHeader.viewFromXib as! CreateGroupHeader
        headerVW.lblMemberCount.text = arrSelectedParticipants.count == 1 ? "\(self.arrSelectedParticipants.count) \(CGroupMember)" : "\(self.arrSelectedParticipants.count) \(CGroupMembers)"
        headerVW.btnAddMore.touchUpInside { [weak self] (sender) in
            guard let self = self else { return }
            self.btnAddParticipantsCLK(UIButton())
        }
        return headerVW
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == tblGroupSuggestion{
            return 0
        }
        return CScreenWidth * 45 / 375
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
}


// MARK:- ------------ Action Event
extension CreateChatGroupViewController{
    
    @objc fileprivate func btnDoneCLK(_ sender : UIBarButtonItem) {
            self.addEditGroup(true)
    }
    
    @IBAction func btnAddParticipantsCLK(_ sender : UIButton){

        // Group users...
        var arrGroupAddedUser = [[String : Any]]()
        arrGroupAddedUser = arrSelectedParticipants.filter({$0[CGroupId] != nil  })
        
        // New added users...
        var arrGroupAddedLocalUser = [[String : Any]]()
        arrGroupAddedLocalUser = arrSelectedParticipants.filter({$0[CGroupId] == nil  })

        if let addPartVC = CStoryboardGroup.instantiateViewController(withIdentifier: "AddParticipantsViewController") as? AddParticipantsViewController {
            addPartVC.arrSelectedParticipant = arrGroupAddedLocalUser
            addPartVC.arrAllreadySelectedParticipants = arrGroupAddedUser
            
            addPartVC.groupID = groupID
            addPartVC.setBlock(block: { (arrSelected, message) in
                if let arr = arrSelected as? [[String : Any]] {
                    self.arrSelectedParticipants.removeAll()
                    self.arrSelectedParticipants = arr + arrGroupAddedUser
                    self.tblParticipants.reloadData()
                    self.showHideTableAddParticipants()
                }
            })
            
            self.navigationController?.pushViewController(addPartVC, animated: true)
        }
    }
    
    func grptopicCreate(groupID:String){
        if apiTask?.state == URLSessionTask.State.running {
            apiTask?.cancel()
        }
        apiTask = APIRequest.shared().ChatFriendsTopicCrt(TopicName: groupID, completion: { (response, error) in
            if response != nil{
                if let status =  response?["status"] as? Int {
                    if status == 0{
                        print("successFullyCreateTopic")
                        
                    }
                }
            }
        })
    }
    
    
    
    
    @IBAction func btnGroupTypeCLK(_ sender : UIButton){

        if groupID != nil{
            
            let alertmessage = btnPrivate.isSelected ? CMessageGroupTypeChangeAlertToPublic + " \(CMessageGroupTypeChangeAlertToPublicMessage)" : CMessageGroupTypeChangeAlertToPrivate + " \(CMessagegroupTypeChangeAlertToPrivateMessage)"
            
            self.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: alertmessage, btnOneTitle: CBtnYes, btnOneTapped: { (alert) in
                self.btnPublic.isSelected = false
                self.btnPrivate.isSelected = false
                
                switch sender.tag {
                case 0:
                    self.btnPublic.isSelected = true
                default:
                    self.btnPrivate.isSelected = true
                }
                self.addEditGroup(false)
            }, btnTwoTitle: CBtnNo, btnTwoTapped: nil)
        }else{
            btnPublic.isSelected = false
            btnPrivate.isSelected = false
            
            switch sender.tag {
            case 0:
                btnPublic.isSelected = true
            default:
                btnPrivate.isSelected = true
            }
        }
    }
    
    @IBAction func btnUplaodImageCLK(_ sender : UIButton){
        
        self.presentImagePickerController(allowEditing: false) { (image, info) in
            if image != nil{
                self.imgGroupIcon.image = image
                self.viewAddImageContainer.isHidden = true
                self.viewUploadedImageContainer.isHidden = false
                self.groupImage = image
                
//                if let imageURL = info?[UIImagePickerController.InfoKey.imageURL] as? NSURL {
//                    self.imgName = imageURL.absoluteString ?? ""
//                }else if let imageURL =  info?[UIImagePickerController.InfoKey.originalImage] as? UIImage {
//                    
////                    try? image?.pngData()?.write(to: imageURL)
//
//
//                }
//                self.imgName = imageURL.absoluteString ?? ""
                guard let mobileNum = appDelegate.loginUser?.mobile else {
                    return
                }
                MInioimageupload.shared().uploadMinioimages(mobileNo: mobileNum, ImageSTt: image!,isFrom:"",uploadFrom:"")
                MInioimageupload.shared().callback = { message in
                print("UploadImage::::::::::::::\(message)")
                self.imgName = message
                }
            }
        }
    }
    
    @IBAction func btnEditImageCLK(_ sender : UIButton){
        self.isSelected = true
        self.presentImagePickerController(allowEditing: false) { (image, info) in
            if image != nil{
                self.imgGroupIcon.image = image
                self.viewAddImageContainer.isHidden = true
                self.viewUploadedImageContainer.isHidden = false
                self.groupImage = image
                
                guard let imageURL = info?[UIImagePickerController.InfoKey.imageURL] as? NSURL else {
                    return
                }
                self.imgName = imageURL.absoluteString ?? ""
                guard let mobileNum = appDelegate.loginUser?.mobile else {
                    return
                }
                MInioimageupload.shared().uploadMinioimages(mobileNo: mobileNum, ImageSTt: image!,isFrom:"",uploadFrom:"")
                MInioimageupload.shared().callback = { message in
                print("UploadImage::::::::::::::\(message)")
                self.imgName = message
                }
            }
        }
    }
    
}
