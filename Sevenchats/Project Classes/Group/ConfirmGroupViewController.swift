//
//  ConfirmGroupViewController.swift
//  Sevenchats
//
//  Created by mac-0005 on 31/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Nagaraju K and Chandrika R                                 *
 * Model   : ConfirmGroupViewController                  *
 * Changes :                                             *
 ********************************************************/
import UIKit

class ConfirmGroupViewController: ParentViewController {

    @IBOutlet var imgGroupIcon : UIImageView!
    @IBOutlet var tblUser : UITableView!
    @IBOutlet var lblSelectedMember : UILabel!
    @IBOutlet var cnTblUserHeight : NSLayoutConstraint!
    @IBOutlet var txtGroupTitle : UITextField!
    @IBOutlet var btnPublic : UIButton!
    @IBOutlet var btnPrivate : UIButton!
        @IBOutlet var btnSwitch : UISwitch!
    
    var arrSelectedParticipant = [[String:Any]]()
    var dicSelectedGroupInfo = [String : Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Initialization()
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
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_apply_filter"), style: .plain, target: self, action: #selector(btnDoneCLK(_:)))
        
        self.title = dicSelectedGroupInfo.valueForInt(key: CGroupId) != nil ? CNavEditGroup : CNavNewGroup
        txtGroupTitle.text = dicSelectedGroupInfo.valueForString(key: CGroupTitle)
        arrSelectedParticipant = (dicSelectedGroupInfo[CGroupUsersId] as? [[String : Any]])!
        imgGroupIcon.image = (dicSelectedGroupInfo[CGroupImage] as? UIImage)!
        btnGroupTypeCLK(dicSelectedGroupInfo.valueForInt(key: CGroupType) == 1 ? btnPublic : btnPrivate)
        btnSwitch.isOn = dicSelectedGroupInfo.valueForInt(key: CGroupLink) == 1 ? true : false
        
        if let textInfo = txtGroupTitle as? MIGenericTextFiled {
            textInfo.updatePlaceholderFrame(true)
            textInfo.showHideClearTextButton()
        }
        
        self.updateSelectedParticipants()
        GCDMainThread.async {
            self.tblUser.reloadData()
        }
    }
    
    func updateUIAccordingToLanguage(){
        
        if Localization.sharedInstance.applicationFlowWithLanguageRTL() {
            // Reverse Flow...
            btnPublic.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 3)
            btnPublic.contentHorizontalAlignment = .right
            
            btnPrivate.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 3)
            btnPrivate.contentHorizontalAlignment = .right
            
        }else{
            // Normal Flow...
            btnPublic.titleEdgeInsets = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 0)
            btnPublic.contentHorizontalAlignment = .left
            btnPrivate.titleEdgeInsets = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 0)
            btnPrivate.contentHorizontalAlignment = .left
        }
        
    }
}

// MARK:- --------- Update Participants
extension ConfirmGroupViewController {
    func updateSelectedParticipants(){
        
        lblSelectedMember.text = "\(arrSelectedParticipant.count) members selected"
        self.tblUser.reloadData()
        if #available(iOS 11.0, *) {
            tblUser.performBatchUpdates({
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
extension ConfirmGroupViewController : UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSelectedParticipant.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CScreenWidth * 65 / 375
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "AddParticipantsTblCell", for: indexPath) as? AddParticipantsTblCell {
            let userInfo = arrSelectedParticipant[indexPath.row] 
            cell.lblUserName.text = userInfo.valueForString(key: CFirstname) + " " + userInfo.valueForString(key: CLastname)
            cell.imgUser.loadImageFromUrl(userInfo.valueForString(key: CImage), true)
            return cell
        }
        
        return tableView.tableViewDummyCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
}

// MARK:- ------------ Action Event
extension ConfirmGroupViewController{
    
    @IBAction func btnAddMoreCLK(_ sender : UIBarButtonItem) {
        if let addPartVC = CStoryboardGroup.instantiateViewController(withIdentifier: "AddParticipantsViewController") as?
            AddParticipantsViewController{
            addPartVC.arrSelectedParticipant = arrSelectedParticipant
            addPartVC.setBlock(block: { (arrSelected, message) in
                if let arr = arrSelected as? [[String : Any]]{
                    self.arrSelectedParticipant = arr
                    self.updateSelectedParticipants()
                }
            })
            self.navigationController?.pushViewController(addPartVC, animated: true)
        }
    }
    
    @objc fileprivate func btnDoneCLK(_ sender : UIBarButtonItem) {
        if arrSelectedParticipant.count < 2{
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageChatGroupMinMemebers, btnOneTitle: CBtnOk, btnOneTapped: nil)
        }else {
            
            // call api here....
            let userIDS = arrSelectedParticipant.map({$0.valueForString(key: CUserId) }).joined(separator: ",")
            var apiPara = [String : Any]()
            apiPara[CGroupUsersId] = userIDS
            apiPara[CGroupTitle] = txtGroupTitle.text
            apiPara[CGroupLink] = btnSwitch.isOn ? 1 : 0
            apiPara[CGroupType] = btnPublic.isSelected ? 1 : 2
            
            // While editing group....
            if let groupID = dicSelectedGroupInfo[CGroupId] as? Int{
                apiPara[CGroupId] = groupID
            }
            APIRequest.shared().addEditChatGroup(para: apiPara, image : imgGroupIcon.image) { (response, error) in
                if response != nil && error == nil{
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
            
        }
       
    }
    
    @IBAction func btnGroupTypeCLK(_ sender : UIButton){
        
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
