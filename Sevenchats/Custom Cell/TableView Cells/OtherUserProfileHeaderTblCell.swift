//
//  OtherUserProfileHeaderTblCell.swift
//  Sevenchats
//
//  Created by mac-0005 on 30/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Chandrika.R                                 *
 * Model   : RestrictedFilesVC                           *
 * Description : OtherUserProfileHeaderTblCell           *                                        
 *                                                       *
 ********************************************************/

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
        
        lblLocation.attributedText = NSMutableAttributedString().normal(CLive_in).normal(" ").bold((userInfo.valueForString(key: "city") )).normal(" , ").bold(userInfo.valueForString(key: "state"))
        
        if userInfo.valueForString(key: "relationship") == "null"{
            lblStatus.attributedText = NSMutableAttributedString().normal(CRelationship_Status).bold("N/A")
        }else {
            lblStatus.attributedText = NSMutableAttributedString().normal(CRelationship_Status).normal(" ").bold((userInfo.valueForString(key: "relationship")))
        }
        switch Int(userInfo.valueForString(key: CGender)) {
        case CMale :
            lblGender.attributedText = NSMutableAttributedString().normal(gender).normal(" ").bold(CRegisterGenderMale)
        case CFemale :
            lblGender.attributedText = NSMutableAttributedString().normal(gender).normal(" ").bold(CRegisterGenderFemale)
        default :
            lblGender.attributedText = NSMutableAttributedString().normal(gender).normal(" ").bold(CRegisterGenderOther)
        }
        let date = DateFormatter.shared().date(fromString: userInfo.valueForString(key: CDob), dateFormat: "yyyy-MM-dd")
        if date != nil{
            //lblBdate.text = DateFormatter.shared().string(fromDate: date!, dateFormat: "dd MMM yyyy")
        }else{
//            lblBdate.text = ""
        }
        self.userProfileImg = userInfo.valueForString(key: CImage)
        
        imgUser.loadImageFromUrl(userInfo.valueForString(key: CImage), true)
        
        if userInfo.valueForString(key: "cover_image")  == ""{
            imgUserCover.image = UIImage(named: "CoverImage.png")
        }else {
            imgUserCover.loadImageFromUrl(userInfo.valueForString(key: "cover_image"), true)
        }
        
//        imgUserCover.loadImageFromUrl(userInfo.valueForString(key: "cover_image"), true)
        let user_id = userInfo.valueForString(key: "user_id")
        self.getFriendListFromServer(user_id)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.30) {
            
            let totalFriend = self.frdsofFrds.count
            self.btnTotalFriend.setTitle("\(totalFriend)", for: .normal)
            self.viewFriendFirst.hide(byWidth: true)
            self.viewFriendSecond.hide(byWidth: true)
            _ = self.viewFriendSecond.setConstraintConstant(0, edge: .leading, ancestor: true)
            self.viewFriendThird.hide(byWidth: true)
            _ = self.viewFriendThird.setConstraintConstant(0, edge: .leading, ancestor: true)
            self.viewFriendFourth.hide(byWidth: true)
            _ = self.viewFriendFourth.setConstraintConstant(0, edge: .leading, ancestor: true)
            
            if let arrFriends =  self.frdsofFrds as? [[String : Any]] {
                
                let arrFrdList = arrFriends.prefix(4)
                let frdListCount = Array(arrFrdList)
                
                switch frdListCount.count {
                case 1:
                    self.viewFriendFirst.hide(byWidth: false)
                    print("image:::::\(arrFriends[0].valueForString(key: CImage))")
                    
                    if arrFriends[0].valueForString(key: CImage) == "" {
                        self.btnFriendFirst.setImage(UIImage(named: "user_placeholder.png"), for: .normal)
                    }else {
                        self.btnFriendFirst.sd_setImage(with: URL(string: arrFriends[0].valueForString(key: CImage)), for: .normal, completed: nil)
                    }
                    
                case 2:
                    self.viewFriendFirst.hide(byWidth: false)
                    if arrFriends[0].valueForString(key: CImage) == "" {
                        self.btnFriendFirst.setImage(UIImage(named: "user_placeholder.png"), for: .normal)
                    }else {
                        self.btnFriendFirst.sd_setImage(with: URL(string: arrFriends[0].valueForString(key: CImage)), for: .normal, completed: nil)
                    }
                    self.viewFriendSecond.hide(byWidth: false)
                    _ = self.viewFriendSecond.setConstraintConstant(CGFloat(CUserFriendLeadingSpace), edge: .leading, ancestor: true)
                    
                    if arrFriends[1].valueForString(key: CImage) == "" {
                        self.btnFriendSecond.setImage(UIImage(named: "user_placeholder.png"), for: .normal)
                    }else {
                        self.btnFriendSecond.sd_setImage(with: URL(string: arrFriends[1].valueForString(key: CImage)), for: .normal, completed: nil)
                    }
                case 3:
                    self.viewFriendFirst.hide(byWidth: false)
                    if arrFriends[0].valueForString(key: CImage) == "" {
                        self.btnFriendFirst.setImage(UIImage(named: "user_placeholder.png"), for: .normal)
                    }else {
                        self.btnFriendFirst.sd_setImage(with: URL(string: arrFriends[0].valueForString(key: CImage)), for: .normal, completed: nil)
                    }
                    self.viewFriendSecond.hide(byWidth: false)
                    _ = self.viewFriendSecond.setConstraintConstant(CGFloat(CUserFriendLeadingSpace), edge: .leading, ancestor: true)
                    
                    if arrFriends[1].valueForString(key: CImage) == "" {
                        self.btnFriendSecond.setImage(UIImage(named: "user_placeholder.png"), for: .normal)
                    }else {
                        self.btnFriendSecond.sd_setImage(with: URL(string: arrFriends[1].valueForString(key: CImage)), for: .normal, completed: nil)
                    }
                    self.viewFriendThird.hide(byWidth: false)
                    _ = self.viewFriendThird.setConstraintConstant(CGFloat(CUserFriendLeadingSpace), edge: .leading, ancestor: true)
                    
                    if arrFriends[2].valueForString(key: CImage) == "" {
                        self.btnFriendThird.setImage(UIImage(named: "user_placeholder.png"), for: .normal)
                    }else {
                        self.btnFriendThird.sd_setImage(with: URL(string: arrFriends[2].valueForString(key: CImage)), for: .normal, completed: nil)
                    }
                    
                case 4:
                    self.viewFriendFirst.hide(byWidth: false)
                    
                    if arrFriends[0].valueForString(key: CImage) == "" {
                        self.btnFriendFirst.setImage(UIImage(named: "user_placeholder.png"), for: .normal)
                    }else {
                        self.btnFriendFirst.sd_setImage(with: URL(string: arrFriends[0].valueForString(key: CImage)), for: .normal, completed: nil)
                    }
                    
                    self.viewFriendSecond.hide(byWidth: false)
                    _ = self.viewFriendSecond.setConstraintConstant(CGFloat(CUserFriendLeadingSpace), edge: .leading, ancestor: true)
                    
                    if arrFriends[1].valueForString(key: CImage) == "" {
                        self.btnFriendSecond.setImage(UIImage(named: "user_placeholder.png"), for: .normal)
                    }else {
                        self.btnFriendSecond.sd_setImage(with: URL(string: arrFriends[1].valueForString(key: CImage)), for: .normal, completed: nil)
                    }
                    
                    self.viewFriendThird.hide(byWidth: false)
                    _ = self.viewFriendThird.setConstraintConstant(CGFloat(CUserFriendLeadingSpace), edge: .leading, ancestor: true)
                    
                    if arrFriends[2].valueForString(key: CImage) == "" {
                        self.btnFriendThird.setImage(UIImage(named: "user_placeholder.png"), for: .normal)
                    }else {
                        self.btnFriendThird.sd_setImage(with: URL(string: arrFriends[2].valueForString(key: CImage)), for: .normal, completed: nil)
                    }
                    
                    self.viewFriendFourth.hide(byWidth: false)
                    _ = self.viewFriendFourth.setConstraintConstant(CGFloat(CUserFriendLeadingSpace), edge: .leading, ancestor: true)
                    
                    if arrFriends[3].valueForString(key: CImage) == "" {
                        self.btnFriendFourth.setImage(UIImage(named: "user_placeholder.png"), for: .normal)
                    }else {
                        self.btnFriendFourth.sd_setImage(with: URL(string: arrFriends[3].valueForString(key: CImage)), for: .normal, completed: nil)
                    }
                    _ = self.btnTotalFriend.setConstraintConstant(CGFloat(CUserFriendLeadingSpace), edge: .leading, ancestor: true)
                default:
                    break;
                }
            }
            //            }
            // Put your code which should be executed with a delay here
        }
     
        
        for data in frdList{
            if data?.valueForString(key: "friend_status") == "1"{
                self.Friend_status = 5
            }
        }
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
                let list = response!["friends_Of_friend"] as? [String:Any]
                if let arrList = list![CJsonData] as? [[String:Any]] {
                    print(":::::::::friendsofFreinds\(arrList)")
                    self.frdsofFrds = arrList
                }
            }
        }
    }
}

