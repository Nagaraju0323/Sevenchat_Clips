//
//  OtherUserProfileHeaderTblCell.swift
//  Sevenchats
//
//  Created by mac-0005 on 30/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

/*import UIKit
import Lightbox


class OtherUserProfileHeaderTblCell: UITableViewCell {

    @IBOutlet var imgUser : UIImageView!
    @IBOutlet var viewFriendFirst : UIView!
    @IBOutlet var viewFriendSecond : UIView!
   // @IBOutlet var viewMobileAndBOBSeparator : UIView!
    
    @IBOutlet var viewFriendThird : UIView!
    @IBOutlet var viewFriendFourth : UIView!
    @IBOutlet var btnFriendFirst : UIButton!
    @IBOutlet var btnFriendSecond : UIButton!
    @IBOutlet var btnFriendThird : UIButton!
    @IBOutlet var btnFriendFourth : UIButton!
    
    @IBOutlet var btnTotalFriend : UIButton!
    @IBOutlet var btnMore : UIButton!
    @IBOutlet var btnViewCompleteProfile : UIButton!
    @IBOutlet var btnAddFriend : UIButton!
    @IBOutlet var btnMessage : UIButton!
    //@IBOutlet var btnBlockUser : UIButton!
    //@IBOutlet var btnReportUser : UIButton!
    @IBOutlet var btnRequestAccept : UIButton!
    @IBOutlet var btnRequestReject : UIButton!
    
    @IBOutlet var lblTitleFriends : UILabel!
    @IBOutlet var lblBdate : UILabel!
    @IBOutlet var lblLineBehindDoB : UILabel!
    @IBOutlet var lblMobileNo : UILabel!
    @IBOutlet var lblUserName : UILabel!
    @IBOutlet var lblEmail : UILabel!
    @IBOutlet var lblAddress : UILabel!
    @IBOutlet var viewAcceptReject : UIView!
    @IBOutlet weak var btnUserProfile : UIButton!

    var userProfileImg = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        GCDMainThread.async {
            self.imgUser.layer.cornerRadius = self.imgUser.frame.size.width/2
            self.btnMore.layer.cornerRadius = 5
            self.btnViewCompleteProfile.layer.cornerRadius = 5
            self.btnAddFriend.layer.cornerRadius = 5
            self.btnMessage.layer.cornerRadius = 5
            
            self.btnRequestAccept.layer.cornerRadius = 5
            self.btnRequestReject.layer.cornerRadius = 5
            self.btnRequestReject.layer.borderWidth = 1
            self.btnRequestReject.layer.borderColor = CRGB(r: 119, g: 171, b: 110).cgColor
            
            /*self.btnBlockUser.layer.cornerRadius = 5
            self.btnBlockUser.layer.borderWidth = 1
            self.btnBlockUser.layer.borderColor = CRGB(r: 119, g: 171, b: 110).cgColor
            
            self.btnReportUser.layer.cornerRadius = 5
            self.btnReportUser.layer.borderWidth = 1
            self.btnReportUser.layer.borderColor = CRGB(r: 119, g: 171, b: 110).cgColor*/
            self.btnMessage.setTitle(CMessageText, for: .normal)
            
            self.btnTotalFriend.layer.cornerRadius = self.btnTotalFriend.frame.size.width/2
            
            self.updateUIAccordingToLanguage()
        }
        
        self.btnUserProfile.touchUpInside(genericTouchUpInsideHandler: { [weak self](_) in
            let lightBoxHelper = LightBoxControllerHelper()
            lightBoxHelper.openSingleImage(image: self?.imgUser.image, viewController: self?.viewController)
        })

    }
    
    func updateUIAccordingToLanguage(){
        
        if Localization.sharedInstance.applicationFlowWithLanguageRTL() {
            // Reverse Flow...
            lblMobileNo.textAlignment = .left
            lblBdate.textAlignment = .right
        }else{
            // Normal Flow...
            lblMobileNo.textAlignment = .right
            lblBdate.textAlignment = .left
        }
        
        lblTitleFriends.text = CProfileFriends
        btnMore.setTitle(CMore, for: .normal)
        btnViewCompleteProfile.setTitle(CProfileBtnViewCompleteProfile, for: .normal)
        //btnReportUser.setTitle(CBtnReportUser, for: .normal)
        btnRequestAccept.setTitle(CBtnAccept, for: .normal)
        btnRequestReject.setTitle(CBtnReject, for: .normal)
        
    }
    
    fileprivate func hideShowMobileAndEmail(_ isHide : Bool){
        if isHide {
            self.lblEmail.hide(byHeight: true)
            self.lblMobileNo.hide(byHeight: true)
            _ = self.lblTitleFriends.setConstraintConstant(-10, edge: .top, ancestor: true)
            self.lblBdate.hide(byHeight: true)
            self.lblAddress.hide(byHeight: true)
            self.lblLineBehindDoB.isHidden = true
        } else {
            self.lblEmail.hide(byHeight: false)
            self.lblMobileNo.hide(byHeight: false)
            _ = self.lblTitleFriends.setConstraintConstant(8, edge: .top, ancestor: true)
            self.lblBdate.hide(byHeight: false)
            self.lblAddress.hide(byHeight: false)
            self.lblLineBehindDoB.isHidden = false
        }
    }
    
    func friendViewBorderCornerRadius(_ view: UIView) {
        view.layer.cornerRadius = view.frame.size.width/2
        view.layer.borderWidth = 1.5
        view.layer.borderColor = UIColor.white.cgColor
    }
    
    func cellConfigureForUserDetail(_ userInfo : [String : Any]) {
        
        lblUserName.text = userInfo.valueForString(key: CFirstname) + " " + userInfo.valueForString(key: CLastname)
        lblEmail.text = userInfo.valueForString(key: CEmail)
        lblMobileNo.text = userInfo.valueForString(key: CCountrycode) + userInfo.valueForString(key: CMobile)
        lblAddress.text = userInfo.valueForString(key: CAddress)
        let date = DateFormatter.shared().date(fromString: userInfo.valueForString(key: CDob), dateFormat: "yyyy-MM-dd")
        if date != nil{
            lblBdate.text = DateFormatter.shared().string(fromDate: date!, dateFormat: "dd MMM yyyy")
        }else{
            lblBdate.text = ""
        }
        lblLineBehindDoB.isHidden = (lblBdate.text?.isBlank ?? true)
        self.userProfileImg = userInfo.valueForString(key: CImage)
        imgUser.loadImageFromUrl(userInfo.valueForString(key: CImage), true)
        //btnTotalFriend.setTitle(userInfo.valueForString(key: CTotal_friends), for: .normal)
        /*if (totalFriend) <= 0{
            hideFriendsList(isHide: true)
        }else{
            hideFriendsList(isHide: false)
        }*/
        let totalFriend = userInfo.valueForInt(key: CTotal_friends) ?? 0
        btnTotalFriend.hide(byWidth: !(totalFriend > 4))
        btnTotalFriend.setTitle("\(totalFriend)", for: .normal)
        
        viewFriendFirst.hide(byWidth: true)
        viewFriendSecond.hide(byWidth: true)
        _ = viewFriendSecond.setConstraintConstant(0, edge: .leading, ancestor: true)
        viewFriendThird.hide(byWidth: true)
        _ = viewFriendThird.setConstraintConstant(0, edge: .leading, ancestor: true)
        viewFriendFourth.hide(byWidth: true)
        _ = viewFriendFourth.setConstraintConstant(0, edge: .leading, ancestor: true)
        
        
        if let arrFriends = userInfo.valueForJSON(key: CFriends) as? [[String : Any]] {
            if arrFriends.count > 0{
                switch arrFriends.count {
                case 1:
                    viewFriendFirst.hide(byWidth: false)
                    btnFriendFirst.sd_setImage(with: URL(string: arrFriends[0].valueForString(key: CImage)), for: .normal, completed: nil)
                case 2:
                    viewFriendFirst.hide(byWidth: false)
                    btnFriendFirst.sd_setImage(with: URL(string: arrFriends[0].valueForString(key: CImage)), for: .normal, completed: nil)
                    viewFriendSecond.hide(byWidth: false)
                    _ = self.viewFriendSecond.setConstraintConstant(CGFloat(CUserFriendLeadingSpace), edge: .leading, ancestor: true)
                    btnFriendSecond.sd_setImage(with: URL(string: arrFriends[1].valueForString(key: CImage)), for: .normal, completed: nil)
                case 3:
                    viewFriendFirst.hide(byWidth: false)
                    btnFriendFirst.sd_setImage(with: URL(string: arrFriends[0].valueForString(key: CImage)), for: .normal, completed: nil)
                    viewFriendSecond.hide(byWidth: false)
                    _ = viewFriendSecond.setConstraintConstant(CGFloat(CUserFriendLeadingSpace), edge: .leading, ancestor: true)
                    btnFriendSecond.sd_setImage(with: URL(string: arrFriends[1].valueForString(key: CImage)), for: .normal, completed: nil)
                    viewFriendThird.hide(byWidth: false)
                    _ = viewFriendThird.setConstraintConstant(CGFloat(CUserFriendLeadingSpace), edge: .leading, ancestor: true)
                    btnFriendThird.sd_setImage(with: URL(string: arrFriends[2].valueForString(key: CImage)), for: .normal, completed: nil)
                case 4:
                    viewFriendFirst.hide(byWidth: false)
                    btnFriendFirst.sd_setImage(with: URL(string: arrFriends[0].valueForString(key: CImage)), for: .normal, completed: nil)
                    viewFriendSecond.hide(byWidth: false)
                    _ = viewFriendSecond.setConstraintConstant(CGFloat(CUserFriendLeadingSpace), edge: .leading, ancestor: true)
                    btnFriendSecond.sd_setImage(with: URL(string: arrFriends[1].valueForString(key: CImage)), for: .normal, completed: nil)
                    viewFriendThird.hide(byWidth: false)
                    _ = viewFriendThird.setConstraintConstant(CGFloat(CUserFriendLeadingSpace), edge: .leading, ancestor: true)
                    btnFriendThird.sd_setImage(with: URL(string: arrFriends[2].valueForString(key: CImage)), for: .normal, completed: nil)
                    viewFriendFourth.hide(byWidth: false)
                    _ = viewFriendFourth.setConstraintConstant(CGFloat(CUserFriendLeadingSpace), edge: .leading, ancestor: true)
                    btnFriendFourth.sd_setImage(with: URL(string: arrFriends[3].valueForString(key: CImage)), for: .normal, completed: nil)
                
                    _ = btnTotalFriend.setConstraintConstant(CGFloat(CUserFriendLeadingSpace), edge: .leading, ancestor: true)
                default:
                    break;
                }
            }
        }
        
//        btnTotalFriend.isHidden = userInfo.valueForInt(key: CTotal_friends)! > 4 ? false : true

        // Hide view complete profile button
        // For Friend user
        // Basic -> 1, Completed -> 2
        if userInfo.valueForInt(key: CFriend_status) == 5 {
            if userInfo.valueForInt(key: CVisible_to_friend) == 1 {
                _ = self.btnViewCompleteProfile.setConstraintConstant(-10, edge: .top, ancestor: true)
                self.btnViewCompleteProfile.hide(byHeight: true)
                self.hideShowMobileAndEmail(true)
            }else {
                self.btnViewCompleteProfile.hide(byHeight: false)
                self.hideShowMobileAndEmail(false)
            }
            
        }else {
            // For Unknown user
            _ = self.btnViewCompleteProfile.setConstraintConstant(-10, edge: .top, ancestor: true)
            self.btnViewCompleteProfile.hide(byHeight: true)
            self.hideShowMobileAndEmail(true)
            if userInfo.valueForInt(key: CVisible_to_other) == 1{
                lblTitleFriends.hide(byHeight: true)
                hideFriendsList(isHide: true)
            }else{
                lblTitleFriends.hide(byHeight: false)
                hideFriendsList(isHide: false)
                _ = self.lblTitleFriends.setConstraintConstant(-60, edge: .top, ancestor: true)
            }
        }
        
        self.friendViewBorderCornerRadius(self.viewFriendFirst)
        self.friendViewBorderCornerRadius(self.viewFriendSecond)
        self.friendViewBorderCornerRadius(self.viewFriendThird)
        self.friendViewBorderCornerRadius(self.viewFriendFourth)
    }
    
    func hideFriendsList(isHide:Bool){
        lblTitleFriends.isHidden = isHide
        btnTotalFriend.isHidden = isHide
        viewFriendFirst.isHidden = isHide
        viewFriendSecond.isHidden = isHide
        viewFriendThird.isHidden = isHide
        viewFriendFourth.isHidden = isHide
    }
}
*/

/**************NEW CODE *********************/

import UIKit
import Lightbox


class OtherUserProfileHeaderTblCell: UITableViewCell {

    @IBOutlet var imgUser : UIImageView!
    @IBOutlet var imgUserCover : UIImageView!
   
    
    @IBOutlet var viewFriendFirst : UIView!
    @IBOutlet var viewFriendSecond : UIView!
    @IBOutlet var viewFriendThird : UIView!
    @IBOutlet var viewFriendFourth : UIView!
    @IBOutlet var btnFriendFirst : UIButton!
    @IBOutlet var btnFriendSecond : UIButton!
    @IBOutlet var btnFriendThird : UIButton!
    @IBOutlet var btnFriendFourth : UIButton!
    
    @IBOutlet var btnTotalFriend : UIButton!
    @IBOutlet var btnMore : UIButton!
    @IBOutlet var btnViewCompleteProfile : UIButton!
    @IBOutlet var btnAddFriend : UIButton!
    @IBOutlet var btnMessage : UIButton!
    @IBOutlet var btnRequestAccept : UIButton!
    @IBOutlet var btnRequestReject : UIButton!
    
    @IBOutlet var lblTitleFriends : UILabel!
    @IBOutlet var lblLocation : UILabel!
    @IBOutlet var lblGender : UILabel!
    @IBOutlet var lblUserName : UILabel!
    @IBOutlet var viewAcceptReject : UIView!
    @IBOutlet weak var btnUserProfile : UIButton!
    @IBOutlet weak var lblStatus: UILabel!
    var frdsofFrds = [[String:Any]]()
    var frdList = [[String : Any]?]()
    var Friend_status : Int?

    var userProfileImg = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        GCDMainThread.async {
           self.imgUser.layer.cornerRadius = self.imgUser.frame.size.width/2
            self.btnMore.layer.cornerRadius = 5
            self.imgUser.layer.borderWidth = 3
            self.imgUser.layer.borderColor = #colorLiteral(red: 0, green: 0.7881455421, blue: 0.7100172639, alpha: 1)
            self.btnViewCompleteProfile.layer.cornerRadius = 5
            self.btnAddFriend.layer.cornerRadius = 5
            self.btnMessage.layer.cornerRadius = 5
            
            self.btnRequestAccept.layer.cornerRadius = 5
            self.btnRequestReject.layer.cornerRadius = 5
            self.btnRequestReject.layer.borderWidth = 1
            self.btnRequestReject.layer.borderColor = CRGB(r: 119, g: 171, b: 110).cgColor
            self.btnViewCompleteProfile.heightAnchor.constraint(equalToConstant: CGFloat(0)).isActive = true
            self.btnMessage.setTitle(CMessageText, for: .normal)
            
            self.btnTotalFriend.layer.cornerRadius = self.btnTotalFriend.frame.size.width/2
            
            self.updateUIAccordingToLanguage()
        }
        
        self.btnUserProfile.touchUpInside(genericTouchUpInsideHandler: { [weak self](_) in
            let lightBoxHelper = LightBoxControllerHelper()
            lightBoxHelper.openSingleImage(image: self?.imgUser.image, viewController: self?.viewController)
        })

    }
    
    func updateUIAccordingToLanguage(){
        
        if Localization.sharedInstance.applicationFlowWithLanguageRTL() {
            // Reverse Flow...
//            lblMobileNo.textAlignment = .left
//            lblBdate.textAlignment = .right
        }else{
            // Normal Flow...
//            lblMobileNo.textAlignment = .right
//            lblBdate.textAlignment = .left
        }
        
        lblTitleFriends.text = CProfileFriends
        btnMore.setTitle(CMore, for: .normal)
        btnViewCompleteProfile.setTitle(CProfileBtnViewCompleteProfile, for: .normal)
        //btnReportUser.setTitle(CBtnReportUser, for: .normal)
        btnRequestAccept.setTitle(CBtnAccept, for: .normal)
        btnRequestReject.setTitle(CBtnReject, for: .normal)
        
    }
    
    fileprivate func hideShowMobileAndEmail(_ isHide : Bool){
        if isHide {
//            self.lblEmail.hide(byHeight: true)
//            self.lblMobileNo.hide(byHeight: true)
//            _ = self.lblTitleFriends.setConstraintConstant(-10, edge: .top, ancestor: true)
//            self.lblBdate.hide(byHeight: true)
//            self.lblAddress.hide(byHeight: true)
//            self.lblLineBehindDoB.isHidden = true
        } else {
//            self.lblEmail.hide(byHeight: false)
//            self.lblMobileNo.hide(byHeight: false)
//            _ = self.lblTitleFriends.setConstraintConstant(8, edge: .top, ancestor: true)
//            self.lblBdate.hide(byHeight: false)
//            self.lblAddress.hide(byHeight: false)
//            self.lblLineBehindDoB.isHidden = false
        }
    }
    
    func friendViewBorderCornerRadius(_ view: UIView) {
        view.layer.cornerRadius = view.frame.size.width/2
        view.layer.borderWidth = 1.5
        view.layer.borderColor = UIColor.white.cgColor
    }
    
    func cellConfigureForUserDetail(_ userInfo : [String : Any]) {
        
        lblUserName.text = userInfo.valueForString(key: CFirstname) + " " + userInfo.valueForString(key: CLastname)
        
       // lblLocation.text = "Lives in \(userInfo.valueForString(key: CCountryName) ) \(userInfo.valueForString(key: CStateName))"
       // lblLocation.text = "Lives in \(userInfo.valueForString(key: "city")) , \(userInfo.valueForString(key: "country"))"
        //lblStatus.text = "Relationship \(userInfo.valueForString(key: "relationship"))"
        lblLocation.text =  CLive_in + (appDelegate.loginUser?.city ?? "")
        lblStatus.text = CRelationship_Status + (appDelegate.loginUser?.relationship ?? "")
        
        switch Int(userInfo.valueForString(key: CGender)) {
        case CMale :
            lblGender.text = CRegisterGenderMale
        case CFemale :
            lblGender.text = CRegisterGenderFemale
        default :
            lblGender.text = CRegisterGenderOther
        }
        
//        lblEmail.text = userInfo.valueForString(key: CEmail)
//        lblMobileNo.text = userInfo.valueForString(key: CCountrycode) + userInfo.valueForString(key: CMobile)
        
        
       // lblAddress.text = userInfo.valueForString(key: CAddress)
        let date = DateFormatter.shared().date(fromString: userInfo.valueForString(key: CDob), dateFormat: "yyyy-MM-dd")
        if date != nil{
            //lblBdate.text = DateFormatter.shared().string(fromDate: date!, dateFormat: "dd MMM yyyy")
        }else{
            //lblBdate.text = ""
        }
       // lblLineBehindDoB.isHidden = (lblBdate.text?.isBlank ?? true)
        self.userProfileImg = userInfo.valueForString(key: CImage)
        imgUser.loadImageFromUrl(userInfo.valueForString(key: CImage), true)
        imgUserCover.loadImageFromUrl(userInfo.valueForString(key: "cover_image"), true)
        //btnTotalFriend.setTitle(userInfo.valueForString(key: CTotal_friends), for: .normal)
        /*if (totalFriend) <= 0{
            hideFriendsList(isHide: true)
        }else{
            hideFriendsList(isHide: false)
        }*/
//        let totalFriend = userInfo.valueForInt(key: CTotal_friends) ?? 0
//        let totalFriend = self.frdsofFrds.count
//        btnTotalFriend.hide(byWidth: !(totalFriend > 4))
//        btnTotalFriend.setTitle("\(totalFriend)", for: .normal)
//
//        viewFriendFirst.hide(byWidth: true)
//        viewFriendSecond.hide(byWidth: true)
//        _ = viewFriendSecond.setConstraintConstant(0, edge: .leading, ancestor: true)
//        viewFriendThird.hide(byWidth: true)
//        _ = viewFriendThird.setConstraintConstant(0, edge: .leading, ancestor: true)
//        viewFriendFourth.hide(byWidth: true)
//        _ = viewFriendFourth.setConstraintConstant(0, edge: .leading, ancestor: true)
        
        
        let user_id = userInfo.valueForString(key: "user_id")
        self.getFriendListFromServer(user_id)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.30) {
            print("this acalling")

            
            let totalFriend = self.frdsofFrds.count
//            self.btnTotalFriend.hide(byWidth: !(totalFriend > 4))
            self.btnTotalFriend.setTitle("\(totalFriend)", for: .normal)
            
            self.viewFriendFirst.hide(byWidth: true)
            self.viewFriendSecond.hide(byWidth: true)
            _ = self.viewFriendSecond.setConstraintConstant(0, edge: .leading, ancestor: true)
            self.viewFriendThird.hide(byWidth: true)
            _ = self.viewFriendThird.setConstraintConstant(0, edge: .leading, ancestor: true)
            self.viewFriendFourth.hide(byWidth: true)
            _ = self.viewFriendFourth.setConstraintConstant(0, edge: .leading, ancestor: true)
            
            
//            let totalFriend = self.frdsofFrds.count
            if let arrFriends =  self.frdsofFrds as? [[String : Any]] {
                if arrFriends.count > 0{
                    switch arrFriends.count {
                    case 1:
                        self.viewFriendFirst.hide(byWidth: false)
                        self.btnFriendFirst.sd_setImage(with: URL(string: arrFriends[0].valueForString(key: CImage)), for: .normal, completed: nil)
                    case 2:
                        self.viewFriendFirst.hide(byWidth: false)
                        self.btnFriendFirst.sd_setImage(with: URL(string: arrFriends[0].valueForString(key: CImage)), for: .normal, completed: nil)
                        self.viewFriendSecond.hide(byWidth: false)
                        _ = self.viewFriendSecond.setConstraintConstant(CGFloat(CUserFriendLeadingSpace), edge: .leading, ancestor: true)
                        self.btnFriendSecond.sd_setImage(with: URL(string: arrFriends[1].valueForString(key: CImage)), for: .normal, completed: nil)
                    case 3:
                        self.viewFriendFirst.hide(byWidth: false)
                        self.btnFriendFirst.sd_setImage(with: URL(string: arrFriends[0].valueForString(key: CImage)), for: .normal, completed: nil)
                        self.viewFriendSecond.hide(byWidth: false)
                        _ = self.viewFriendSecond.setConstraintConstant(CGFloat(CUserFriendLeadingSpace), edge: .leading, ancestor: true)
                        self.btnFriendSecond.sd_setImage(with: URL(string: arrFriends[1].valueForString(key: CImage)), for: .normal, completed: nil)
                        self.viewFriendThird.hide(byWidth: false)
                        _ = self.viewFriendThird.setConstraintConstant(CGFloat(CUserFriendLeadingSpace), edge: .leading, ancestor: true)
                        self.btnFriendThird.sd_setImage(with: URL(string: arrFriends[2].valueForString(key: CImage)), for: .normal, completed: nil)
                    case 4:
                        self.viewFriendFirst.hide(byWidth: false)
                        self.btnFriendFirst.sd_setImage(with: URL(string: arrFriends[0].valueForString(key: CImage)), for: .normal, completed: nil)
                        self.viewFriendSecond.hide(byWidth: false)
                        _ = self.viewFriendSecond.setConstraintConstant(CGFloat(CUserFriendLeadingSpace), edge: .leading, ancestor: true)
                        self.btnFriendSecond.sd_setImage(with: URL(string: arrFriends[1].valueForString(key: CImage)), for: .normal, completed: nil)
                        self.viewFriendThird.hide(byWidth: false)
                        _ = self.viewFriendThird.setConstraintConstant(CGFloat(CUserFriendLeadingSpace), edge: .leading, ancestor: true)
                        self.btnFriendThird.sd_setImage(with: URL(string: arrFriends[2].valueForString(key: CImage)), for: .normal, completed: nil)
                        self.viewFriendFourth.hide(byWidth: false)
                        _ = self.viewFriendFourth.setConstraintConstant(CGFloat(CUserFriendLeadingSpace), edge: .leading, ancestor: true)
                        self.btnFriendFourth.sd_setImage(with: URL(string: arrFriends[3].valueForString(key: CImage)), for: .normal, completed: nil)

                        _ = self.btnTotalFriend.setConstraintConstant(CGFloat(CUserFriendLeadingSpace), edge: .leading, ancestor: true)
                    default:
                        break;
                    }
                }
            }
            // Put your code which should be executed with a delay here
        }
        
        
//        btnTotalFriend.isHidden = userInfo.valueForInt(key: CTotal_friends)! > 4 ? false : true

        // Hide view complete profile button
        // For Friend user
        // Basic -> 1, Completed -> 2
//        if userInfo.valueForInt(key: CFriend_status) == 5 {
//           if userInfo.valueForInt(key: CVisible_to_friend) == 1 {
        print(frdList)
       for data in frdList{
        if userInfo.valueForString(key: "user_id") == data?.valueForString(key: "friend_user_id"){
        self.Friend_status = 5
        }
        }
          // let CFriend_status = 5
        let CVisible_to_friend = userInfo.valueForInt(key: "visible_to_friend")
               
                if self.Friend_status == 5 {
                  if CVisible_to_friend == 1 {
                self.btnViewCompleteProfile.setConstraintConstant(-40, edge: .top, ancestor: true)
                self.btnViewCompleteProfile.hide(byHeight: true)
                self.hideShowMobileAndEmail(true)
            }else {
                self.btnViewCompleteProfile.hide(byHeight: false)
                self.hideShowMobileAndEmail(false)
            }
            
        }else {
            // For Unknown user
            self.btnViewCompleteProfile.setConstraintConstant(-20, edge: .top, ancestor: true)
//            self.btnViewCompleteProfile.setConstraintConstant(-20, edge: .top, ancestor: true)
            self.btnViewCompleteProfile.hide(byHeight: true)
            self.hideShowMobileAndEmail(true)
            if userInfo.valueForInt(key: "visible_to_other") == 1{
                lblTitleFriends.hide(byHeight: true)
                hideFriendsList(isHide: true)
            }else{
                lblTitleFriends.hide(byHeight: false)
                hideFriendsList(isHide: false)
               // _ = self.lblTitleFriends.setConstraintConstant(-60, edge: .top, ancestor: true)
            }
        }
        
        self.friendViewBorderCornerRadius(self.viewFriendFirst)
        self.friendViewBorderCornerRadius(self.viewFriendSecond)
        self.friendViewBorderCornerRadius(self.viewFriendThird)
        self.friendViewBorderCornerRadius(self.viewFriendFourth)
    }
    
    func hideFriendsList(isHide:Bool){
        lblTitleFriends.isHidden = isHide
        btnTotalFriend.isHidden = isHide
        viewFriendFirst.isHidden = isHide
        viewFriendSecond.isHidden = isHide
        viewFriendThird.isHidden = isHide
        viewFriendFourth.isHidden = isHide
    }
    
     func getFriendListFromServer(_ userid : String?) {
     
        _ = APIRequest.shared().getOtherUserFriendListNew(user_id: userid) { (response, error) in
           
                if response != nil && error == nil {
                    print("response\(response)")
//                    DispatchQueue.main.async {
                    let list = response!["friends_Of_friend"] as? [String:Any]
                    if let arrList = list![CJsonData] as? [[String:Any]] {
                        print("arraylist\(arrList)")
                        self.frdsofFrds = arrList
                        // Remove all data here when page number == 1
                        
//                    }
                }
            }
            
            }
      
    }
}

