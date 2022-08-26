//
//  ProfilePreferenceViewController.swift
//  Sevenchats
//
//  Created by mac-0005 on 14/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Nagaraju K and Chandrika R                                 *
 * Model   : ProfilePreferenceViewController             *
 * Changes :                                             *
 *                                                       *
 ********************************************************/


import UIKit

class ProfilePreferenceViewController: ParentViewController {
    
    @IBOutlet var btnFriendBasic : UIButton!
    @IBOutlet var btnFriendComplete : UIButton!
    @IBOutlet var btnUnknowsBasic : UIButton!
    @IBOutlet var btnUnknowsComplete : UIButton!
    @IBOutlet var btnBlockedUser : UIButton!
    @IBOutlet var btnDeleteUser : UIButton!
    @IBOutlet var lblBasic : UILabel!
    @IBOutlet var lblUnknown : UILabel!
    @IBOutlet var lblBlockedUser : UILabel!
    @IBOutlet var lblManageContent : UILabel!
    @IBOutlet var lblOwnerShip : UILabel!
    
    @IBOutlet var imgNextArrow : UIImageView!
    
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
        
        self.setLanguageText()
        
        if appDelegate.loginUser?.visible_to_friend == 0 {
            btnFriendBasic.isSelected = true
        } else {
            btnFriendComplete.isSelected = true
        }
        
        if appDelegate.loginUser?.visible_to_other == 0 {
            btnUnknowsBasic.isSelected = true
        } else {
            btnUnknowsComplete.isSelected = true
        }
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: #imageLiteral(resourceName: "ic_info_tint"), style: .plain, target: self, action: #selector(btnHelpInfoClicked(_:)))]
    }
    
    @objc fileprivate func btnHelpInfoClicked(_ sender : UIBarButtonItem){
        if let helpLineVC = CStoryboardHelpLine.instantiateViewController(withIdentifier: "HelpLineViewController") as? HelpLineViewController {
            helpLineVC.fromVC = "profilePreferenceVC"
            self.navigationController?.pushViewController(helpLineVC, animated: true)
        }
        
    }
    
    
    func setLanguageText() {
        self.title = CSettingProfilePreference
        self.lblBasic.text = CProfileVisibleForFriend
        self.lblBlockedUser.text = CBlockedUsers
        self.lblUnknown.text = CProfileVisibleForOther
        self.lblOwnerShip.text = CAccountOwnership
        self.lblManageContent.text = CManage_content
        
        self.btnFriendBasic.setTitle(CProfileBasic, for: .normal)
        self.btnFriendComplete.setTitle(CProfileComplete, for: .normal)
        self.btnUnknowsComplete.setTitle(CProfileComplete, for: .normal)
        self.btnUnknowsBasic.setTitle(CProfileBasic, for: .normal)
    }
    
    func updateUIAccordingToLanguage(){
        
        if Localization.sharedInstance.applicationFlowWithLanguageRTL() {
            // Reverse Flow...
            btnFriendBasic.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 9)
            btnFriendBasic.contentHorizontalAlignment = .right
            
            btnFriendComplete.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 9)
            btnFriendComplete.contentHorizontalAlignment = .right
            
            btnUnknowsBasic.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 9)
            btnUnknowsBasic.contentHorizontalAlignment = .right
            
            btnUnknowsComplete.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 9)
            btnUnknowsComplete.contentHorizontalAlignment = .right
            
            imgNextArrow.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        }else{
            // Normal Flow...
            
            btnFriendBasic.titleEdgeInsets = UIEdgeInsets(top: 0, left: 9, bottom: 0, right: 0)
            btnFriendBasic.contentHorizontalAlignment = .left
            
            btnFriendComplete.titleEdgeInsets = UIEdgeInsets(top: 0, left: 9, bottom: 0, right: 0)
            btnFriendComplete.contentHorizontalAlignment = .left
            
            btnUnknowsBasic.titleEdgeInsets = UIEdgeInsets(top: 0, left: 9, bottom: 0, right: 0)
            btnUnknowsBasic.contentHorizontalAlignment = .left
            
            btnUnknowsComplete.titleEdgeInsets = UIEdgeInsets(top: 0, left: 9, bottom: 0, right: 0)
            btnUnknowsComplete.contentHorizontalAlignment = .left
            
            imgNextArrow.transform = CGAffineTransform.identity
        }
        
    }
}

//MARK:- ---------- API Functions
extension ProfilePreferenceViewController{
    
    func changeProfilePrefrences(friend_visible : Int, unknown_visible : Int) {
        guard let userId = appDelegate.loginUser?.user_id else {return }
        let encryptUser = EncryptDecrypt.shared().encryptDecryptModel(userResultStr: userId.description)
        let dict :[String:Any]  = [
            "user_id":encryptUser,
            "push_notify":"1",
            "email_notify":"1",
            "visible_to_friend":friend_visible.description,
            "visible_to_other":unknown_visible.description
        ]
        APIRequest.shared().changeProfilePreferencesNew(profileDetials: dict as [String : Any]) { (response, error) in
            if response != nil && error == nil {
                if let metaInfo = response![CJsonMeta] as? [String:Any]{
                    let status  = metaInfo.valueForString(key: "status")
                    if status == "0"{
                        guard let useremail = appDelegate.loginUser?.email else {return }
                        let encryptResult = EncryptDecrypt.shared().encryptDecryptModel(userResultStr: useremail ?? "")
                        let dict:[String:Any] = [
                            CEmail_Mobile : encryptResult
                        ]
                        
                        APIRequest.shared().userDetails(para: dict as [String : AnyObject],access_Token:"",viewType: 0) { (response, error) in
                            if response != nil && error == nil {
                                DispatchQueue.main.async {
                                    print("local db server")
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

//MARK:- ---------- Action Event
extension ProfilePreferenceViewController{
    
    @IBAction func btnFriendVisibilityCLK(_ sender : UIButton){
        
        btnFriendBasic.isSelected = false
        btnFriendComplete.isSelected = false
        
        if sender.tag == 0{
            btnFriendBasic.isSelected = true
            self.changeProfilePrefrences(friend_visible: CBasicPrefrence, unknown_visible: Int(Int16((appDelegate.loginUser?.visible_to_other)!)))
        } else {
            btnFriendComplete.isSelected = true
            self.changeProfilePrefrences(friend_visible: CCompletePrefrence, unknown_visible: Int(Int16((appDelegate.loginUser?.visible_to_other)!)))
        }
    }
    
    
    @IBAction func btnUnknowsVisibilityCLK(_ sender : UIButton){
        btnUnknowsBasic.isSelected = false
        btnUnknowsComplete.isSelected = false
        
        if sender.tag == 0 {
            btnUnknowsBasic.isSelected = true
            self.changeProfilePrefrences(friend_visible: Int(Int16((appDelegate.loginUser?.visible_to_friend)!)), unknown_visible: CBasicPrefrence)
        } else {
            btnUnknowsComplete.isSelected = true
            self.changeProfilePrefrences(friend_visible: Int(Int16((appDelegate.loginUser?.visible_to_friend)!)), unknown_visible: CCompletePrefrence)
        }
    }
    
    @IBAction func btnBlockedUserCLK(_ sender : UIButton){
        if let blockUserVC = CStoryboardGeneral.instantiateViewController(withIdentifier: "BlockUserListViewController") as? BlockUserListViewController{
            self.navigationController?.pushViewController(blockUserVC, animated: true)
        }
        
    }
    
    @IBAction func btnDeleteUserCLK(_ sender : UIButton){
        if let blockUserVC = CStoryboardSetting.instantiateViewController(withIdentifier: "DeactiveDelViewController") as? DeactiveDelViewController{
            self.navigationController?.pushViewController(blockUserVC, animated: true)
        }
        
    }
    
}


