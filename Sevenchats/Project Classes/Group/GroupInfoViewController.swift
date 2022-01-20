//
//  GroupInfoViewController.swift
//  Sevenchats
//
//  Created by mac-0005 on 01/09/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

/********************************************************
* Author :  Chandrika.R                                *
* Model  : GroupChat Messages                          *
* options: Group Info                                  *
********************************************************/

import UIKit

class GroupInfoViewController: ParentViewController {
    
    @IBOutlet var tblUser : UITableView!
    @IBOutlet var cnTblUserHeight : NSLayoutConstraint!
    @IBOutlet var lblLink : UILabel!
    @IBOutlet var lblGroupType : UILabel!
    @IBOutlet var lblMemberCount : UILabel!
    @IBOutlet var lblGroupLinkTxt : UILabel!
    @IBOutlet var imgGroup : UIImageView!
    @IBOutlet var btnAddMore : UIButton!
    @IBOutlet var btnExitGroup : UIButton!
    @IBOutlet var viewGroupLinkContainer : UIView!
    
    
    var arrMembers = [[String : Any]]()
    var groupInfo =  [String:Any]()
    var strImgGroup = ""
    var strGroupName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Initialization()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK:- --------- Initialization
    func Initialization(){
    
        self.setLanguageText()
        self.setGroupInformation()
        self.getGroupInformationFromServer(true)
    
        btnExitGroup.layer.cornerRadius = 5
        lblGroupType.layer.cornerRadius = 5
        lblGroupType.layer.borderWidth = 1
        lblGroupType.layer.borderColor = CRGB(r: 111, g: 163, b: 170).cgColor
    }
    
    func setLanguageText() {

        lblGroupLinkTxt.text = "\(CGroupInfoLink):"
        btnAddMore.setTitle("+\(CGroupInfoAddMore)", for: .normal)
    }
    
}

// MARK:- --------- Api Functions
extension GroupInfoViewController{
    func setGroupInformation() {
        if let groupInfo = self.iObject as? [String : Any]{
            self.title = groupInfo.valueForString(key: CGroupTitle)
//            lblGroupType.text = groupInfo.valueForInt(key: CGroupType) == 1 ? CGroupPublic : CGroupPrivate
            lblGroupType.isHidden = true
            
            if groupInfo.valueForString(key: CGroupLink).isBlank{
                viewGroupLinkContainer.hide(byHeight: true)
            }else{
                lblLink.text = groupInfo.valueForString(key: CGroupLink)
                viewGroupLinkContainer.hide(byHeight: false)
            }
            imgGroup.loadImageFromUrl(groupInfo.valueForString(key: CGroupImage), false)
            strImgGroup = groupInfo.valueForString(key: CGroupImage)
            strGroupName = groupInfo.valueForString(key: "group_title")
            self.btnAddMore.isHidden = true
//            if Int64(groupInfo.valueForString(key: CCreated_By)) == appDelegate.loginUser?.user_id{
            if Int64(groupInfo.valueForString(key: "group_admin")) == appDelegate.loginUser?.user_id{
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_edit_profile"), style: .plain, target: self, action: #selector(btnEditClicked(_:)))
                self.btnAddMore.isHidden = false
                self.btnExitGroup.setTitle(CGroupDelete, for: .normal)
            }else{
                self.btnExitGroup.setTitle(CGroupExit, for: .normal)
            }
            
        }
    }
    
    func getGroupInformationFromServer(_ showLoader : Bool){
        if let groupInfo = self.iObject as? [String : Any]{
            APIRequest.shared().groupDetail(group_id: groupInfo.valueForString(key: CGroupId),shouldShowLoader:showLoader) { (response, error) in
                if response != nil && error == nil{
                    if let groupInfo = response![CJsonData] as? [[String : Any]]{
                        
                        for groupData in groupInfo{
                            if let uesrInfo = groupData["friends_list"] as? [[String : Any]]{
                            self.arrMembers = uesrInfo
                            self.lblMemberCount.text = self.arrMembers.count == 1 ? "\(self.arrMembers.count) \(CGroupMember)" : "\(self.arrMembers.count) \(CGroupMembers)"
                            self.tblUser.reloadData()
                            self.showHideTableAddParticipants()
                        }
                        }
                    }
                }
            }
        }
    }
    
    fileprivate func showHideTableAddParticipants(){
        if #available(iOS 11.0, *) {
            self.tblUser.performBatchUpdates({
                self.cnTblUserHeight.constant = self.tblUser.contentSize.height
            }) { (completed) in
                self.cnTblUserHeight.constant = self.tblUser.contentSize.height
            }
        } else {
            GCDMainThread.async {
                self.cnTblUserHeight.constant = self.tblUser.contentSize.height
            }
        }

    }
    
}

// MARK:- --------- UITableView Datasources/Delegate
extension GroupInfoViewController : UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMembers.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  65
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "GroupInfoUserTblCell", for: indexPath) as? GroupInfoUserTblCell {
            let userInfo = arrMembers[indexPath.row]
            cell.lblUserName.text = userInfo.valueForString(key: CFirstname) + " " + userInfo.valueForString(key: CLastname)
            cell.imgUser.loadImageFromUrl(userInfo.valueForString(key: CImage), true)
            
            let iObject = self.iObject as? [String : Any]
            cell.btnAdmin.isHidden = userInfo.valueForInt(key: CUserId) == iObject?.valueForInt(key: "group_admin") ? false : true
            cell.btnDeleteMember.isHidden = Int64(iObject!.valueForString(key: "group_admin")) == appDelegate.loginUser?.user_id ? Int64(userInfo.valueForString(key: CUserId)) == appDelegate.loginUser?.user_id : true
            cell.btnDeleteMember.touchUpInside { [weak self] (sender) in
                guard let self = self else { return }
                self.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: CAlertGroupRemoveParticipant, btnOneTitle: CBtnYes, btnOneTapped: { (alert) in
                    APIRequest.shared().removeMemberFromGroup(group_id: iObject?.valueForString(key: CGroupId).toInt, group_users_id: userInfo.valueForString(key: CUserId), completion: { [self] (response, error) in
                        if response != nil && error == nil{
                            
                            // Pulbish to removed user.
                            let user_ID =  appDelegate.loginUser?.user_id.description ?? ""
                            MIGeneralsAPI.shared().sendNotification(userInfo.valueForString(key: CUserId), userID: user_ID.description, subject: "Group Member Deleted By Group Admin", MsgType: "GROUP_REMOVE", MsgSent:"Group Members is Removed From GroupAdmin", showDisplayContent: "send a GROUP message to you", senderName: self.strGroupName)
                            self.arrMembers.remove(at: indexPath.row)
                            self.tblUser.reloadData()
                            self.showHideTableAddParticipants()
                            self.lblMemberCount.text = self.arrMembers.count == 1 ? "\(self.arrMembers.count) \(CGroupMember)" : "\(self.arrMembers.count) \(CGroupMembers)"
                        }
                    })
                }, btnTwoTitle: CBtnNo, btnTwoTapped: nil)
            }
            cell.btnUserInfo.touchUpInside { [weak self] (sender) in
                guard let self = self else { return }
//                appDelegate.moveOnProfileScreen(userInfo.valueForString(key: CUserId), self)
                appDelegate.moveOnProfileScreenNew(userInfo.valueForString(key: CUserId), userInfo.valueForString(key: CUsermailID), self)
            }
            
            return cell
        }
        
        return tableView.tableViewDummyCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
}

// MARK:- --------- Action Event
extension GroupInfoViewController{
    
    @objc fileprivate func btnEditClicked(_ sender : UIBarButtonItem) {
        if let groupInfo = self.iObject as? [String : Any]{
            var arrMemberTemp = arrMembers
            
            // Remove login user from list...
            if let index = arrMemberTemp.index(where: {$0[CUserId] as? Int64 == appDelegate.loginUser?.user_id}){
                arrMemberTemp.remove(at: index)
            }
            if let createGroupVC = CStoryboardGroup.instantiateViewController(withIdentifier: "CreateChatGroupViewController") as? CreateChatGroupViewController {
                createGroupVC.setBlock { (groupInfo, message) in
                    self.iObject = groupInfo
                    self.setGroupInformation()
                    self.getGroupInformationFromServer(false)
                }
                createGroupVC.iObject = groupInfo
                createGroupVC.arrSelectedParticipants = arrMemberTemp
                createGroupVC.groupID = groupInfo.valueForString(key: CGroupId).toInt
                createGroupVC.groupID_New = groupInfo.valueForString(key: CGroupId)
                createGroupVC.editGroup = true
                self.navigationController?.pushViewController(createGroupVC, animated: true)
            }
        }
    }
    
    @IBAction func btnExitGroup(_ sender : UIButton){
        var strMessage = CMessageGroupExit
        var userSelectType = 0
        if let groupInfo = self.iObject as? [String : Any]{
            if Int64(groupInfo.valueForString(key: "group_admin")) == appDelegate.loginUser?.user_id {
                strMessage = CAlertGroupDelete
                userSelectType = 1
            }else{
                strMessage = CAlertGroupExit
                userSelectType = 2
            }
        }
        
        self.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: strMessage, btnOneTitle: CBtnYes, btnOneTapped: { (alert) in
            if let groupInfo = self.iObject as? [String : Any] {
                var user_id = ""
                var groupID = ""
                
                if userSelectType == 1{
                     groupID =  groupInfo.valueForString(key: CGroupId)
                     user_id =  groupInfo.valueForString(key: "group_admin")
                }else {
                    groupID =  groupInfo.valueForString(key: CGroupId)
                    user_id =  appDelegate.loginUser?.user_id.description ?? ""
                }
                
                APIRequest.shared().exitGroup(group_id: groupID,user_id:user_id,user_type:userSelectType) { (response, error) in
                    if response != nil {
                        if let metaData = response?.value(forKey: CJsonMeta) as? [String : AnyObject] {
                            if  metaData.valueForString(key: CJsonStatus).toInt == 0 {
                                if userSelectType == 1 {
                                    let strArr = self.arrMembers.map({$0.valueForString(key: CUserId) })
                                    guard let user_ID =  appDelegate.loginUser?.user_id.description else { return}
                                    strArr.forEach { friends_ID in
                                        if friends_ID == user_ID.description{
                                            
                                        }else{
                                            MIGeneralsAPI.shared().sendNotification(friends_ID, userID: user_ID.description, subject: "Group is Deleted By Group Admin", MsgType: "GROUP_REMOVE", MsgSent:"Group is Removed From GroupAdmin", showDisplayContent: "send a GROUP message to you", senderName: self.strGroupName)
                                    }
                                    }
                                }
                            }
                        }
                        if Int64(groupInfo.valueForString(key: CCreated_By)) == appDelegate.loginUser?.user_id {
                            // Publish for delete status..
                            let arrUserIDS = self.arrMembers.map({$0.valueForString(key: CUserId) })
                            if arrUserIDS.count > 0 {
                                if let groupInfo = self.iObject as? [String : Any] {
//                                    MIMQTT.shared().messagePayloadForGroupCreateAndDelete(arrUser: arrUserIDS, status: 1, groupId: groupInfo.valueForString(key: CGroupId), isSend: 0)
                                }
                            }
                        }
                        
                        for viewController in (self.navigationController?.viewControllers)!{
                            if viewController.isKind(of: GroupsViewController.classForCoder()){
                                let groupVC = viewController as? GroupsViewController
                                groupVC!.getGroupListFromServer(isNew: true)
                                break
                            }
                        }
                        
                        guard let groupID = appDelegate.loginUser?.user_id else { return }
//                        MIGeneralsAPI.shared().sendNotification(friends_ID, userID: groupID.description, subject: "Group is Removed successfully", MsgType: "GROUP_REMOVE", MsgSent: "", showDisplayContent: "Group is Removed successfully")
                        self.navigationController?.popToRootViewController(animated: true)
                        self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CgroupRemoved, btnOneTitle: CBtnOk, btnOneTapped: nil)
                    }
                }
            }
        }, btnTwoTitle: CBtnNo, btnTwoTapped: nil)
    }

    
    @IBAction func btnCopyLink(_ sender : UIButton){
        if lblLink.text != nil && !(lblLink.text?.isBlank)!{
            let pastboard = UIPasteboard.general
            pastboard.string = lblLink.text
            MIToastAlert.shared.showToastAlert(position: .bottom, message: CMessageLinkCopied)
        }
        
    }
    @IBAction func btnGroupImage(_ sender : UIButton){
        let lightBoxHelper =  LightBoxControllerHelper()
        lightBoxHelper.openSingleImage(image: imgGroup.image, viewController: self)
    }
    
    @IBAction func btnAddMoreCLK(_ sender : UIBarButtonItem) {
        if let groupInfo = self.iObject as? [String : Any]{
            var arrMemberTemp = arrMembers
            
            // Remove login user from list...
            if let index = arrMemberTemp.index(where: {$0[CUserId] as? Int64 == appDelegate.loginUser?.user_id}){
                arrMemberTemp.remove(at: index)
            }
            
            if let addPartiVC = CStoryboardGroup.instantiateViewController(withIdentifier: "AddParticipantsViewController") as? AddParticipantsViewController{
                addPartiVC.setBlock { (object, message) in
                    self.getGroupInformationFromServer(false)
                }
                addPartiVC.groupID = groupInfo.valueForInt(key: CGroupId)
                addPartiVC.isAddMoreMember = true
                addPartiVC.arrAllreadySelectedParticipants = arrMemberTemp
                self.navigationController?.pushViewController(addPartiVC, animated: true)
            }
        }
        
    }
}
