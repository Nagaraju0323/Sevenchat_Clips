//
//  OtherUserProfileHeaderTblCell.swift
//  Sevenchats
//
//  Created by mac-0005 on 30/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Nagaraju K and Chandrika R                                 *
 * Model   : RestrictedFilesVC                           *
 * Description : OtherUserProfileHeaderTblCell           *                                        
 *                                                       *
 ********************************************************/

import UIKit
import Lightbox
import SDWebImage


class OtherUserProfileHeaderTblCell: UITableViewCell {
    
    @IBOutlet var imgUser : UIImageView!
    @IBOutlet var imgUserGIF : FLAnimatedImageView!
    @IBOutlet var imgUserCover : UIImageView!
    @IBOutlet var imgUserCoverGIF : FLAnimatedImageView!
    @IBOutlet var viewFriendFirst : UIView!
    @IBOutlet var viewFriendSecond : UIView!
    @IBOutlet var viewFriendThird : UIView!
    @IBOutlet var viewFriendFourth : UIView!
   
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
    
    @IBOutlet var btnFriendFirst : UIButton!
    @IBOutlet var btnFriendSecond : UIButton!
    @IBOutlet var btnFriendThird : UIButton!
    @IBOutlet var btnFriendFourth : UIButton!
    @IBOutlet weak var btnFriendFive : UIButton!
    @IBOutlet weak var btnFriendSix : UIButton!
    @IBOutlet weak var btnFriendSeven : UIButton!
    @IBOutlet weak var btnFriendEight: UIButton!
    
    @IBOutlet weak var lblFriendFirst : UILabel!
    @IBOutlet weak var lblFriendSecond : UILabel!
    @IBOutlet weak var lblFriendThird : UILabel!
    @IBOutlet weak var lblFriendFourth : UILabel!
    @IBOutlet weak var lblFriendFive : UILabel!
    @IBOutlet weak var lblFriendSix : UILabel!
    @IBOutlet weak var lblFriendSeven : UILabel!
    @IBOutlet weak var lblFriendEight: UILabel!
    
    
    @IBOutlet weak var imgFriendFirst : UIImageView!
    @IBOutlet weak var imgFriendSecond : UIImageView!
    @IBOutlet weak var imgFriendThird : UIImageView!
    @IBOutlet weak var imgFriendFourth : UIImageView!
    @IBOutlet weak var imgFriendFive : UIImageView!
    @IBOutlet weak var imgFriendSix : UIImageView!
    @IBOutlet weak var imgFriendSeven : UIImageView!
    @IBOutlet weak var imgFriendEight: UIImageView!
    
    @IBOutlet weak var imgFriendFirstGIF : FLAnimatedImageView!
    @IBOutlet weak var imgFriendSecondGIF : FLAnimatedImageView!
    @IBOutlet weak var imgFriendThirdGIF : FLAnimatedImageView!
    @IBOutlet weak var imgFriendFourthGIF : FLAnimatedImageView!
    @IBOutlet weak var imgFriendFiveGIF : FLAnimatedImageView!
    @IBOutlet weak var imgFriendSixGIF : FLAnimatedImageView!
    @IBOutlet weak var imgFriendSevenGIF : FLAnimatedImageView!
    @IBOutlet weak var imgFriendEightGIF: FLAnimatedImageView!
    
    @IBOutlet weak var mainView : UIView!
    @IBOutlet weak var subView : UIView!
    @IBOutlet weak var lblFriend : UILabel!
    @IBOutlet var cnHeaderHight : NSLayoutConstraint!
    @IBOutlet var cnHeaderHightMainView : NSLayoutConstraint!
    @IBOutlet var cnHeaderHightCompleteProfile : NSLayoutConstraint!

    
    
    var frdsofFrds = [[String:Any]]()
    var frdList = [[String : Any]?]()
    var Friend_status : Int?
    var userProfileImg = ""
    var friends_count = 0
    var FristuserID  = ""
    var SeconduserID  = ""
    var ThirduserID  = ""
    var FourthuserID  = ""
    var FiveuserID  = ""
    var SixuserID  = ""
    var SevenuserID  = ""
    var EightuserID  = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    
        self.btnAddFriend.layer.cornerRadius = 5
        //self.cnHeaderHightMainView.constant = 380
        // Initialization code
        GCDMainThread.async {
            self.imgUser.layer.cornerRadius = self.imgUser.frame.size.width/2
           // self.btnMore.layer.cornerRadius = 5
            self.imgUser.layer.borderWidth = 3
            self.imgUser.layer.borderColor = #colorLiteral(red: 0, green: 0.7881455421, blue: 0.7100172639, alpha: 1)
            
            self.imgUserGIF.layer.cornerRadius = self.imgUserGIF.frame.size.width/2
           // self.btnMore.layer.cornerRadius = 5
            self.imgUserGIF.layer.borderWidth = 3
            self.imgUserGIF.layer.borderColor = #colorLiteral(red: 0, green: 0.7881455421, blue: 0.7100172639, alpha: 1)
            
           // self.btnViewCompleteProfile.layer.cornerRadius = 5
          //  self.btnMessage.layer.cornerRadius = 5
           self.btnRequestAccept.layer.cornerRadius = 5
            
            self.btnRequestReject.layer.borderWidth = 2
            self.btnRequestReject.layer.borderColor = #colorLiteral(red: 0, green: 0.7881455421, blue: 0.7100172639, alpha: 1)
            self.btnRequestReject.layer.cornerRadius = 5
            
            self.imgFriendSix.layer.cornerRadius = self.imgFriendSix.frame.size.width/2
            self.imgFriendSix.layer.borderWidth = 2
            self.imgFriendSix.layer.borderColor = #colorLiteral(red: 0, green: 0.7881455421, blue: 0.7100172639, alpha: 1)
            self.imgFriendFive.layer.cornerRadius = self.imgFriendFive.frame.size.width/2
            self.imgFriendFive.layer.borderWidth = 2
            self.imgFriendFive.layer.borderColor = #colorLiteral(red: 0, green: 0.7881455421, blue: 0.7100172639, alpha: 1)
            self.imgFriendEight.layer.cornerRadius = self.imgFriendEight.frame.size.width/2
            self.imgFriendEight.layer.borderWidth = 2
            self.imgFriendEight.layer.borderColor = #colorLiteral(red: 0, green: 0.7881455421, blue: 0.7100172639, alpha: 1)
            self.imgFriendFirst.layer.cornerRadius = self.imgFriendFirst.frame.size.width/2
            self.imgFriendFirst.layer.borderWidth = 2
            self.imgFriendFirst.layer.borderColor = #colorLiteral(red: 0, green: 0.7881455421, blue: 0.7100172639, alpha: 1)
            self.imgFriendSeven.layer.cornerRadius = self.imgFriendSeven.frame.size.width/2
            self.imgFriendSeven.layer.borderWidth = 2
            self.imgFriendSeven.layer.borderColor = #colorLiteral(red: 0, green: 0.7881455421, blue: 0.7100172639, alpha: 1)
            self.imgFriendThird.layer.cornerRadius = self.imgFriendThird.frame.size.width/2
            self.imgFriendThird.layer.borderWidth = 2
            self.imgFriendThird.layer.borderColor = #colorLiteral(red: 0, green: 0.7881455421, blue: 0.7100172639, alpha: 1)
            self.imgFriendFourth.layer.cornerRadius = self.imgFriendFourth.frame.size.width/2
            self.imgFriendFourth.layer.borderWidth = 2
            self.imgFriendFourth.layer.borderColor = #colorLiteral(red: 0, green: 0.7881455421, blue: 0.7100172639, alpha: 1)
            self.imgFriendSecond.layer.cornerRadius = self.imgFriendSecond.frame.size.width/2
            self.imgFriendSecond.layer.borderWidth = 2
            self.imgFriendSecond.layer.borderColor = #colorLiteral(red: 0, green: 0.7881455421, blue: 0.7100172639, alpha: 1)
            
            self.imgFriendSixGIF.layer.cornerRadius = self.imgFriendSixGIF.frame.size.width/2
            self.imgFriendSixGIF.layer.borderWidth = 2
            self.imgFriendSixGIF.layer.borderColor = #colorLiteral(red: 0, green: 0.7881455421, blue: 0.7100172639, alpha: 1)
            self.imgFriendFiveGIF.layer.cornerRadius = self.imgFriendFiveGIF.frame.size.width/2
            self.imgFriendFiveGIF.layer.borderWidth = 2
            self.imgFriendFiveGIF.layer.borderColor = #colorLiteral(red: 0, green: 0.7881455421, blue: 0.7100172639, alpha: 1)
            self.imgFriendEightGIF.layer.cornerRadius = self.imgFriendEightGIF.frame.size.width/2
            self.imgFriendEightGIF.layer.borderWidth = 2
            self.imgFriendEightGIF.layer.borderColor = #colorLiteral(red: 0, green: 0.7881455421, blue: 0.7100172639, alpha: 1)
            self.imgFriendFirstGIF.layer.cornerRadius = self.imgFriendFirstGIF.frame.size.width/2
            self.imgFriendFirstGIF.layer.borderWidth = 2
            self.imgFriendFirstGIF.layer.borderColor = #colorLiteral(red: 0, green: 0.7881455421, blue: 0.7100172639, alpha: 1)
            self.imgFriendSevenGIF.layer.cornerRadius = self.imgFriendSevenGIF.frame.size.width/2
            self.imgFriendSevenGIF.layer.borderWidth = 2
            self.imgFriendSevenGIF.layer.borderColor = #colorLiteral(red: 0, green: 0.7881455421, blue: 0.7100172639, alpha: 1)
            self.imgFriendThirdGIF.layer.cornerRadius = self.imgFriendThirdGIF.frame.size.width/2
            self.imgFriendThirdGIF.layer.borderWidth = 2
            self.imgFriendThirdGIF.layer.borderColor = #colorLiteral(red: 0, green: 0.7881455421, blue: 0.7100172639, alpha: 1)
            self.imgFriendFourthGIF.layer.cornerRadius = self.imgFriendFourthGIF.frame.size.width/2
            self.imgFriendFourthGIF.layer.borderWidth = 2
            self.imgFriendFourthGIF.layer.borderColor = #colorLiteral(red: 0, green: 0.7881455421, blue: 0.7100172639, alpha: 1)
            self.imgFriendSecondGIF.layer.cornerRadius = self.imgFriendSecondGIF.frame.size.width/2
            self.imgFriendSecondGIF.layer.borderWidth = 2
            self.imgFriendSecondGIF.layer.borderColor = #colorLiteral(red: 0, green: 0.7881455421, blue: 0.7100172639, alpha: 1)
            
            

//            self.btnRequestReject.layer.borderColor = CRGB(r: 119, g: 171, b: 110).cgColor
//            self.btnViewCompleteProfile.heightAnchor.constraint(equalToConstant: CGFloat(0)).isActive = true
//            self.btnMessage.setTitle(CMessageText, for: .normal)
           // self.btnTotalFriend.layer.cornerRadius = self.btnTotalFriend.frame.size.width/2
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
        
      //  lblTitleFriends.text = CProfileFriends
        //btnMore.setTitle(CMore, for: .normal)
        btnViewCompleteProfile.setTitle("\(" ") \(CProfileBtnViewCompleteProfile)", for: .normal)
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
        
//        imgUser.loadImageFromUrl(userInfo.valueForString(key: CImage), true)
        
        let imgExt = URL(fileURLWithPath:userInfo.valueForString(key: CImage)).pathExtension
        if imgExt == "gif"{
                    print("-----ImgExt\(imgExt)")
                    
            imgUser.isHidden  = true
            imgUserGIF.isHidden = false
            imgUserGIF.sd_setImage(with: URL(string:userInfo.valueForString(key: CImage)), completed: nil)
            imgUserGIF.sd_cacheFLAnimatedImage = false
                    
                }else {
                    imgUserGIF.isHidden = true
                    imgUser.isHidden  = false
                    imgUser.loadImageFromUrl(userInfo.valueForString(key: CImage), true)
                    _ = appDelegate.loginUser?.total_friends ?? 0
                }
        
        if userInfo.valueForString(key: "cover_image")  == ""{
            imgUserCover.image = UIImage(named: "CoverImage.png")
        }else {
//            imgUserCover.loadImageFromUrl(userInfo.valueForString(key: "cover_image"), true)
            
            let imgExt = URL(fileURLWithPath:userInfo.valueForString(key: "cover_image")).pathExtension
            if imgExt == "gif"{
                        print("-----ImgExt\(imgExt)")
                        
                imgUserCover.isHidden  = true
                imgUserCoverGIF.isHidden = false
                imgUserCoverGIF.sd_setImage(with: URL(string:userInfo.valueForString(key: "cover_image")), completed: nil)
                imgUserCoverGIF.sd_cacheFLAnimatedImage = false
                        
                    }else {
                        imgUserCoverGIF.isHidden = true
                        imgUserCover.isHidden  = false
                        imgUserCover.loadImageFromUrl(userInfo.valueForString(key: "cover_image"), true)
                        _ = appDelegate.loginUser?.total_friends ?? 0
                    }
        }
        
//        imgUserCover.loadImageFromUrl(userInfo.valueForString(key: "cover_image"), true)
        let user_id = userInfo.valueForString(key: "user_id")
        self.getFriendListFromServer(user_id)
        self.myUserDetails(userInfo.valueForString(key: "email"))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.30) {
            
            let totalFriend = self.frdsofFrds.count
            self.lblFriend.attributedText = NSMutableAttributedString().bold((totalFriend.description)).normal(" ").bold(CCFriends)
        // self.btnTotalFriend.setTitle("\(totalFriend)", for: .normal)
//            self.viewFriendFirst.hide(byWidth: true)
//            self.viewFriendSecond.hide(byWidth: true)
//            _ = self.viewFriendSecond.setConstraintConstant(0, edge: .leading, ancestor: true)
//            self.viewFriendThird.hide(byWidth: true)
//            _ = self.viewFriendThird.setConstraintConstant(0, edge: .leading, ancestor: true)
//            self.viewFriendFourth.hide(byWidth: true)
//            _ = self.viewFriendFourth.setConstraintConstant(0, edge: .leading, ancestor: true)
            
            if let arrFriends =  self.frdsofFrds as? [[String : Any]] {
                
                let arrFrdList = arrFriends.prefix(8)
                let frdListCount = Array(arrFrdList)
                
                switch frdListCount.count {
                case 1:
                    
                    self.cnHeaderHight.constant = 125
                    self.imgFriendSecond.isHidden = true
                    self.imgFriendSecondGIF.isHidden = true
                    self.lblFriendSecond.isHidden = true
                    self.btnFriendSecond.isHidden = true
                    
                    self.imgFriendThird.isHidden = true
                    self.imgFriendThirdGIF.isHidden = true
                    self.lblFriendThird.isHidden = true
                    self.btnFriendThird.isHidden = true
                    
                    self.imgFriendFourth.isHidden = true
                    self.imgFriendFourthGIF.isHidden = true
                    self.lblFriendFourth.isHidden = true
                    self.btnFriendFourth.isHidden = true
                    
                    self.imgFriendFive.isHidden = true
                    self.imgFriendFiveGIF.isHidden = true
                    self.lblFriendFive.isHidden = true
                    self.btnFriendFive.isHidden = true
                    
                    self.imgFriendSix.isHidden = true
                    self.imgFriendSixGIF.isHidden = true
                    self.lblFriendSix.isHidden = true
                    self.btnFriendSix.isHidden = true
                    
                    self.imgFriendSeven.isHidden = true
                    self.imgFriendSevenGIF.isHidden = true
                    self.lblFriendSeven.isHidden = true
                    self.btnFriendSeven.isHidden = true
                    
                    self.imgFriendEight.isHidden = true
                    self.imgFriendEightGIF.isHidden = true
                    self.lblFriendEight.isHidden = true
                    self.btnFriendEight.isHidden = true
                   let dict = arrFriends[0] as? TblTotalFriends
                    
                    if arrFriends[0].valueForString(key: CImage) == "" {
                        self.imgFriendFirst.image = UIImage(named: "user_placeholder.png")
                        self.lblFriendFirst.text = arrFriends[0].valueForString(key: "first_name") + " " + arrFriends[0].valueForString(key: "last_name")
                        self.FristuserID = arrFriends[0].valueForString(key: "id")
                    }else {
//                        self.imgFriendFirst.loadImageFromUrl(arrFriends[0].valueForString(key: CImage), true)
                        
                        let imgExt = URL(fileURLWithPath:arrFriends[0].valueForString(key: CImage)).pathExtension
                        if imgExt == "gif"{
                                    print("-----ImgExt\(imgExt)")
                                    
                            self.imgFriendFirst.isHidden  = true
                            self.imgFriendFirstGIF.isHidden = false
                            self.imgFriendFirstGIF.sd_setImage(with: URL(string:arrFriends[0].valueForString(key: CImage)), completed: nil)
                            self.imgFriendFirstGIF.sd_cacheFLAnimatedImage = false
                                    
                                }else {
                                    self.imgFriendFirstGIF.isHidden = true
                                    self.imgFriendFirst.isHidden  = false
                                    self.imgFriendFirst.loadImageFromUrl(arrFriends[0].valueForString(key: CImage), true)
                                   
                                }
                        
                        
                        self.lblFriendFirst.text = arrFriends[0].valueForString(key: "first_name") + " " + arrFriends[0].valueForString(key: "last_name")
                        self.FristuserID = arrFriends[0].valueForString(key: "id")
                    }
                    
                case 2:
                    self.cnHeaderHight.constant = 125
                    self.imgFriendThird.isHidden = true
                    self.imgFriendThirdGIF.isHidden = true
                    self.lblFriendThird.isHidden = true
                    self.btnFriendThird.isHidden = true
                    
                    self.imgFriendFourth.isHidden = true
                    self.imgFriendFourthGIF.isHidden = true
                    self.lblFriendFourth.isHidden = true
                    self.btnFriendFourth.isHidden = true
                    
                    self.imgFriendFive.isHidden = true
                    self.imgFriendFiveGIF.isHidden = true
                    self.lblFriendFive.isHidden = true
                    self.btnFriendFive.isHidden = true
                    
                    self.imgFriendSix.isHidden = true
                    self.imgFriendSixGIF.isHidden = true
                    self.lblFriendSix.isHidden = true
                    self.btnFriendSix.isHidden = true
                    
                    self.imgFriendSeven.isHidden = true
                    self.imgFriendSevenGIF.isHidden = true
                    self.lblFriendSeven.isHidden = true
                    self.btnFriendSeven.isHidden = true
                    
                    self.imgFriendEight.isHidden = true
                    self.imgFriendEightGIF.isHidden = true
                    self.lblFriendEight.isHidden = true
                    self.btnFriendEight.isHidden = true
                    
                    if arrFriends[0].valueForString(key: CImage) == "" {
                        self.imgFriendFirst.image = UIImage(named: "user_placeholder.png")
                        self.lblFriendFirst.text = arrFriends[0].valueForString(key: "first_name") + " " + arrFriends[0].valueForString(key: "last_name")
                        self.FristuserID = arrFriends[0].valueForString(key: "id")
                    }else {
                        //self.imgFriendFirst.loadImageFromUrl(arrFriends[0].valueForString(key: CImage), true)
                        let imgExt = URL(fileURLWithPath:arrFriends[0].valueForString(key: CImage)).pathExtension
                        if imgExt == "gif"{
                                    print("-----ImgExt\(imgExt)")
                                    
                            self.imgFriendFirst.isHidden  = true
                            self.imgFriendFirstGIF.isHidden = false
                            self.imgFriendFirstGIF.sd_setImage(with: URL(string:arrFriends[0].valueForString(key: CImage)), completed: nil)
                            self.imgFriendFirstGIF.sd_cacheFLAnimatedImage = false
                                    
                                }else {
                                    self.imgFriendFirstGIF.isHidden = true
                                    self.imgFriendFirst.isHidden  = false
                                    self.imgFriendFirst.loadImageFromUrl(arrFriends[0].valueForString(key: CImage), true)
                                   
                                }
                        
                        self.lblFriendFirst.text = arrFriends[0].valueForString(key: "first_name") + " " + arrFriends[0].valueForString(key: "last_name")
                        self.FristuserID = arrFriends[0].valueForString(key: "id")
                    }
                    
                    if arrFriends[1].valueForString(key: CImage) == "" {
                        self.imgFriendSecond.image = UIImage(named: "user_placeholder.png")
                        self.lblFriendSecond.text = arrFriends[1].valueForString(key: "first_name") + " " + arrFriends[1].valueForString(key: "last_name")
                        self.SeconduserID = arrFriends[1].valueForString(key: "id")
                    }else {
//                        self.imgFriendSecond.loadImageFromUrl(arrFriends[1].valueForString(key: CImage), true)
                        
                        let imgExt = URL(fileURLWithPath:arrFriends[1].valueForString(key: CImage)).pathExtension
                        if imgExt == "gif"{
                                    print("-----ImgExt\(imgExt)")
                                    
                            self.imgFriendFirst.isHidden  = true
                            self.imgFriendFirstGIF.isHidden = false
                            self.imgFriendFirstGIF.sd_setImage(with: URL(string:arrFriends[1].valueForString(key: CImage)), completed: nil)
                            self.imgFriendFirstGIF.sd_cacheFLAnimatedImage = false
                                    
                                }else {
                                    self.imgFriendFirstGIF.isHidden = true
                                    self.imgFriendFirst.isHidden  = false
                                    self.imgFriendFirst.loadImageFromUrl(arrFriends[1].valueForString(key: CImage), true)
                                   
                                }
                        
                        self.lblFriendSecond.text = arrFriends[1].valueForString(key: "first_name") + " " + arrFriends[1].valueForString(key: "last_name")
                        self.SeconduserID = arrFriends[1].valueForString(key: "id")
                    }
    //
                    
                case 3:
                    self.cnHeaderHight.constant = 125
                    self.imgFriendFourth.isHidden = true
                    self.imgFriendFourthGIF.isHidden = true
                    self.lblFriendFourth.isHidden = true
                    self.btnFriendFourth.isHidden = true
                    
                    self.imgFriendFive.isHidden = true
                    self.imgFriendFiveGIF.isHidden = true
                    self.lblFriendFive.isHidden = true
                    self.btnFriendFive.isHidden = true
                    
                    self.imgFriendSix.isHidden = true
                    self.imgFriendSixGIF.isHidden = true
                    self.lblFriendSix.isHidden = true
                    self.btnFriendSix.isHidden = true
                    
                    self.imgFriendSeven.isHidden = true
                    self.imgFriendSevenGIF.isHidden = true
                    self.lblFriendSeven.isHidden = true
                    self.btnFriendSeven.isHidden = true
                    
                    self.imgFriendEight.isHidden = true
                    self.imgFriendEightGIF.isHidden = true
                    self.lblFriendEight.isHidden = true
                    self.btnFriendEight.isHidden = true
                    
                    if arrFriends[0].valueForString(key: CImage) == "" {
                        self.imgFriendFirst.image = UIImage(named: "user_placeholder.png")
                        self.lblFriendFirst.text = arrFriends[0].valueForString(key: "first_name") + " " + arrFriends[0].valueForString(key: "last_name")
                        self.FristuserID = arrFriends[0].valueForString(key: "id")
                    }else {
                        //self.imgFriendFirst.loadImageFromUrl(arrFriends[0].valueForString(key: CImage), true)
                        let imgExt = URL(fileURLWithPath:arrFriends[0].valueForString(key: CImage)).pathExtension
                        if imgExt == "gif"{
                                    print("-----ImgExt\(imgExt)")
                                    
                            self.imgFriendFirst.isHidden  = true
                            self.imgFriendFirstGIF.isHidden = false
                            self.imgFriendFirstGIF.sd_setImage(with: URL(string:arrFriends[0].valueForString(key: CImage)), completed: nil)
                            self.imgFriendFirstGIF.sd_cacheFLAnimatedImage = false
                                    
                                }else {
                                    self.imgFriendFirstGIF.isHidden = true
                                    self.imgFriendFirst.isHidden  = false
                                    self.imgFriendFirst.loadImageFromUrl(arrFriends[0].valueForString(key: CImage), true)
                                   
                                }
                        
                        self.lblFriendFirst.text = arrFriends[0].valueForString(key: "first_name") + " " + arrFriends[0].valueForString(key: "last_name")
                        self.FristuserID = arrFriends[0].valueForString(key: "id")
                    }
                    if arrFriends[1].valueForString(key: CImage) == "" {
                        self.imgFriendSecond.image = UIImage(named: "user_placeholder.png")
                        self.lblFriendSecond.text = arrFriends[1].valueForString(key: "first_name") + " " + arrFriends[1].valueForString(key: "last_name")
                        self.SeconduserID = arrFriends[1].valueForString(key: "id")
                    }else {
                        //self.imgFriendSecond.loadImageFromUrl(arrFriends[1].valueForString(key: CImage), true)
                        let imgExt = URL(fileURLWithPath:arrFriends[1].valueForString(key: CImage)).pathExtension
                        if imgExt == "gif"{
                                    print("-----ImgExt\(imgExt)")
                                    
                            self.imgFriendFirst.isHidden  = true
                            self.imgFriendFirstGIF.isHidden = false
                            self.imgFriendFirstGIF.sd_setImage(with: URL(string:arrFriends[1].valueForString(key: CImage)), completed: nil)
                            self.imgFriendFirstGIF.sd_cacheFLAnimatedImage = false
                                    
                                }else {
                                    self.imgFriendFirstGIF.isHidden = true
                                    self.imgFriendFirst.isHidden  = false
                                    self.imgFriendFirst.loadImageFromUrl(arrFriends[1].valueForString(key: CImage), true)
                                   
                                }
                        
                        
                        self.lblFriendSecond.text = arrFriends[1].valueForString(key: "first_name") + " " + arrFriends[1].valueForString(key: "last_name")
                        self.SeconduserID = arrFriends[1].valueForString(key: "id")
                    }

                    if arrFriends[2].valueForString(key: CImage) == "" {
                        self.imgFriendThird.image = UIImage(named: "user_placeholder.png")
                        self.lblFriendThird.text = arrFriends[2].valueForString(key: "first_name") + " " + arrFriends[2].valueForString(key: "last_name")
                        self.ThirduserID = arrFriends[2].valueForString(key: "id")
                     
                    }else {
                        //self.imgFriendThird.loadImageFromUrl(arrFriends[2].valueForString(key: CImage), true)
                        let imgExt = URL(fileURLWithPath:arrFriends[2].valueForString(key: CImage)).pathExtension
                        if imgExt == "gif"{
                                    print("-----ImgExt\(imgExt)")
                                    
                            self.imgFriendFirst.isHidden  = true
                            self.imgFriendFirstGIF.isHidden = false
                            self.imgFriendFirstGIF.sd_setImage(with: URL(string:arrFriends[2].valueForString(key: CImage)), completed: nil)
                            self.imgFriendFirstGIF.sd_cacheFLAnimatedImage = false
                                    
                                }else {
                                    self.imgFriendFirstGIF.isHidden = true
                                    self.imgFriendFirst.isHidden  = false
                                    self.imgFriendFirst.loadImageFromUrl(arrFriends[2].valueForString(key: CImage), true)
                                   
                                }
                        
                        self.lblFriendThird.text = arrFriends[2].valueForString(key: "first_name") + " " + arrFriends[2].valueForString(key: "last_name")
                        self.ThirduserID = arrFriends[2].valueForString(key: "id")
                    }
                    
                case 4:
                    self.cnHeaderHight.constant = 125
                    self.imgFriendFive.isHidden = true
                    self.imgFriendFiveGIF.isHidden = true
                    self.lblFriendFive.isHidden = true
                    self.btnFriendFive.isHidden = true
                    
                    self.imgFriendSix.isHidden = true
                    self.imgFriendSixGIF.isHidden = true
                    self.lblFriendSix.isHidden = true
                    self.btnFriendSix.isHidden = true
                    
                    self.imgFriendSeven.isHidden = true
                    self.imgFriendSevenGIF.isHidden = true
                    self.lblFriendSeven.isHidden = true
                    self.btnFriendSeven.isHidden = true
                    
                    self.imgFriendEight.isHidden = true
                    self.imgFriendEightGIF.isHidden = true
                    self.lblFriendEight.isHidden = true
                    self.btnFriendEight.isHidden = true
                    
                    if arrFriends[0].valueForString(key: CImage) == "" {
                        self.imgFriendFirst.image = UIImage(named: "user_placeholder.png")
                        self.lblFriendFirst.text = arrFriends[0].valueForString(key: "first_name") + " " + arrFriends[0].valueForString(key: "last_name")
                        self.FristuserID = arrFriends[0].valueForString(key: "id")
                    }else {
                        //self.imgFriendFirst.loadImageFromUrl(arrFriends[0].valueForString(key: CImage), true)
                        let imgExt = URL(fileURLWithPath:arrFriends[0].valueForString(key: CImage)).pathExtension
                        if imgExt == "gif"{
                                    print("-----ImgExt\(imgExt)")
                                    
                            self.imgFriendFirst.isHidden  = true
                            self.imgFriendFirstGIF.isHidden = false
                            self.imgFriendFirstGIF.sd_setImage(with: URL(string:arrFriends[0].valueForString(key: CImage)), completed: nil)
                            self.imgFriendFirstGIF.sd_cacheFLAnimatedImage = false
                                    
                                }else {
                                    self.imgFriendFirstGIF.isHidden = true
                                    self.imgFriendFirst.isHidden  = false
                                    self.imgFriendFirst.loadImageFromUrl(arrFriends[0].valueForString(key: CImage), true)
                                   
                                }
                        
                        self.lblFriendFirst.text = arrFriends[0].valueForString(key: "first_name") + " " + arrFriends[0].valueForString(key: "last_name")
                        self.FristuserID = arrFriends[0].valueForString(key: "id")
                    }
                    if arrFriends[1].valueForString(key: CImage) == "" {
                        self.imgFriendSecond.image = UIImage(named: "user_placeholder.png")
                        self.lblFriendSecond.text = arrFriends[1].valueForString(key: "first_name") + " " + arrFriends[1].valueForString(key: "last_name")
                        self.SeconduserID = arrFriends[1].valueForString(key: "id")
                    }else {
                       // self.imgFriendSecond.loadImageFromUrl(arrFriends[1].valueForString(key: CImage), true)
                        
                        let imgExt = URL(fileURLWithPath:arrFriends[1].valueForString(key: CImage)).pathExtension
                        if imgExt == "gif"{
                                    print("-----ImgExt\(imgExt)")
                                    
                            self.imgFriendFirst.isHidden  = true
                            self.imgFriendFirstGIF.isHidden = false
                            self.imgFriendFirstGIF.sd_setImage(with: URL(string:arrFriends[1].valueForString(key: CImage)), completed: nil)
                            self.imgFriendFirstGIF.sd_cacheFLAnimatedImage = false
                                    
                                }else {
                                    self.imgFriendFirstGIF.isHidden = true
                                    self.imgFriendFirst.isHidden  = false
                                    self.imgFriendFirst.loadImageFromUrl(arrFriends[1].valueForString(key: CImage), true)
                                   
                                }
                        
                        
                        self.lblFriendSecond.text = arrFriends[1].valueForString(key: "first_name") + " " + arrFriends[1].valueForString(key: "last_name")
                        self.SeconduserID = arrFriends[1].valueForString(key: "id")
                    }

                    if arrFriends[2].valueForString(key: CImage) == "" {
                        self.imgFriendThird.image = UIImage(named: "user_placeholder.png")
                        self.lblFriendThird.text = arrFriends[2].valueForString(key: "first_name") + " " + arrFriends[2].valueForString(key: "last_name")
                        self.ThirduserID = arrFriends[2].valueForString(key: "id")
                     
                    }else {
                        //self.imgFriendThird.loadImageFromUrl(arrFriends[2].valueForString(key: CImage), true)
                        let imgExt = URL(fileURLWithPath:arrFriends[2].valueForString(key: CImage)).pathExtension
                        if imgExt == "gif"{
                                    print("-----ImgExt\(imgExt)")
                                    
                            self.imgFriendFirst.isHidden  = true
                            self.imgFriendFirstGIF.isHidden = false
                            self.imgFriendFirstGIF.sd_setImage(with: URL(string:arrFriends[2].valueForString(key: CImage)), completed: nil)
                            self.imgFriendFirstGIF.sd_cacheFLAnimatedImage = false
                                    
                                }else {
                                    self.imgFriendFirstGIF.isHidden = true
                                    self.imgFriendFirst.isHidden  = false
                                    self.imgFriendFirst.loadImageFromUrl(arrFriends[2].valueForString(key: CImage), true)
                                   
                                }
                        
                        self.lblFriendThird.text = arrFriends[2].valueForString(key: "first_name") + " " + arrFriends[2].valueForString(key: "last_name")
                        self.ThirduserID = arrFriends[2].valueForString(key: "id")
                    }
                    
                    if arrFriends[3].valueForString(key: CImage) == "" {
                        self.imgFriendFourth.image = UIImage(named: "user_placeholder.png")
                        self.lblFriendFourth.text = arrFriends[3].valueForString(key: "first_name") + " " + arrFriends[3].valueForString(key: "last_name")
                        self.FourthuserID = arrFriends[3].valueForString(key: "id")
                     
                    }else {
                        //self.imgFriendFourth.loadImageFromUrl(arrFriends[3].valueForString(key: CImage), true)
                        let imgExt = URL(fileURLWithPath:arrFriends[3].valueForString(key: CImage)).pathExtension
                        if imgExt == "gif"{
                                    print("-----ImgExt\(imgExt)")
                                    
                            self.imgFriendFirst.isHidden  = true
                            self.imgFriendFirstGIF.isHidden = false
                            self.imgFriendFirstGIF.sd_setImage(with: URL(string:arrFriends[3].valueForString(key: CImage)), completed: nil)
                            self.imgFriendFirstGIF.sd_cacheFLAnimatedImage = false
                                    
                                }else {
                                    self.imgFriendFirstGIF.isHidden = true
                                    self.imgFriendFirst.isHidden  = false
                                    self.imgFriendFirst.loadImageFromUrl(arrFriends[3].valueForString(key: CImage), true)
                                   
                                }
                        
                        self.lblFriendFourth.text = arrFriends[3].valueForString(key: "first_name") + " " + arrFriends[3].valueForString(key: "last_name")
                        self.FourthuserID = arrFriends[3].valueForString(key: "id")
                    }
                case 5:
                    self.imgFriendSix.isHidden = true
                    self.imgFriendSixGIF.isHidden = true
                    self.lblFriendSix.isHidden = true
                    self.btnFriendSix.isHidden = true
                    
                    self.imgFriendSeven.isHidden = true
                    self.imgFriendSevenGIF.isHidden = true
                    self.lblFriendSeven.isHidden = true
                    self.btnFriendSeven.isHidden = true
                    
                    self.imgFriendEight.isHidden = true
                    self.imgFriendEightGIF.isHidden = true
                    self.lblFriendEight.isHidden = true
                    self.btnFriendEight.isHidden = true
                    
                    if arrFriends[0].valueForString(key: CImage) == "" {
                        self.imgFriendFirst.image = UIImage(named: "user_placeholder.png")
                        self.lblFriendFirst.text = arrFriends[0].valueForString(key: "first_name") + " " + arrFriends[0].valueForString(key: "last_name")
                        self.FristuserID = arrFriends[0].valueForString(key: "id")
                    }else {
                       // self.imgFriendFirst.loadImageFromUrl(arrFriends[0].valueForString(key: CImage), true)
                        
                        let imgExt = URL(fileURLWithPath:arrFriends[0].valueForString(key: CImage)).pathExtension
                        if imgExt == "gif"{
                                    print("-----ImgExt\(imgExt)")
                                    
                            self.imgFriendFirst.isHidden  = true
                            self.imgFriendFirstGIF.isHidden = false
                            self.imgFriendFirstGIF.sd_setImage(with: URL(string:arrFriends[0].valueForString(key: CImage)), completed: nil)
                            self.imgFriendFirstGIF.sd_cacheFLAnimatedImage = false
                                    
                                }else {
                                    self.imgFriendFirstGIF.isHidden = true
                                    self.imgFriendFirst.isHidden  = false
                                    self.imgFriendFirst.loadImageFromUrl(arrFriends[0].valueForString(key: CImage), true)
                                   
                                }
                        
                        self.lblFriendFirst.text = arrFriends[0].valueForString(key: "first_name") + " " + arrFriends[0].valueForString(key: "last_name")
                        self.FristuserID = arrFriends[0].valueForString(key: "id")
                    }
                    if arrFriends[1].valueForString(key: CImage) == "" {
                        self.imgFriendSecond.image = UIImage(named: "user_placeholder.png")
                        self.lblFriendSecond.text = arrFriends[1].valueForString(key: "first_name") + " " + arrFriends[1].valueForString(key: "last_name")
                        self.SeconduserID = arrFriends[1].valueForString(key: "id")
                    }else {
                       // self.imgFriendSecond.loadImageFromUrl(arrFriends[1].valueForString(key: CImage), true)
                        
                        let imgExt = URL(fileURLWithPath:arrFriends[1].valueForString(key: CImage)).pathExtension
                        if imgExt == "gif"{
                                    print("-----ImgExt\(imgExt)")
                                    
                            self.imgFriendFirst.isHidden  = true
                            self.imgFriendFirstGIF.isHidden = false
                            self.imgFriendFirstGIF.sd_setImage(with: URL(string:arrFriends[1].valueForString(key: CImage)), completed: nil)
                            self.imgFriendFirstGIF.sd_cacheFLAnimatedImage = false
                                    
                                }else {
                                    self.imgFriendFirstGIF.isHidden = true
                                    self.imgFriendFirst.isHidden  = false
                                    self.imgFriendFirst.loadImageFromUrl(arrFriends[1].valueForString(key: CImage), true)
                                   
                                }
                        
                        
                        
                        self.lblFriendSecond.text = arrFriends[1].valueForString(key: "first_name") + " " + arrFriends[1].valueForString(key: "last_name")
                        self.SeconduserID = arrFriends[1].valueForString(key: "id")
                    }

                    if arrFriends[2].valueForString(key: CImage) == "" {
                        self.imgFriendThird.image = UIImage(named: "user_placeholder.png")
                        self.lblFriendThird.text = arrFriends[2].valueForString(key: "first_name") + " " + arrFriends[2].valueForString(key: "last_name")
                        self.ThirduserID = arrFriends[2].valueForString(key: "id")
                     
                    }else {
                        //self.imgFriendThird.loadImageFromUrl(arrFriends[2].valueForString(key: CImage), true)
                        let imgExt = URL(fileURLWithPath:arrFriends[2].valueForString(key: CImage)).pathExtension
                        if imgExt == "gif"{
                                    print("-----ImgExt\(imgExt)")
                                    
                            self.imgFriendFirst.isHidden  = true
                            self.imgFriendFirstGIF.isHidden = false
                            self.imgFriendFirstGIF.sd_setImage(with: URL(string:arrFriends[2].valueForString(key: CImage)), completed: nil)
                            self.imgFriendFirstGIF.sd_cacheFLAnimatedImage = false
                                    
                                }else {
                                    self.imgFriendFirstGIF.isHidden = true
                                    self.imgFriendFirst.isHidden  = false
                                    self.imgFriendFirst.loadImageFromUrl(arrFriends[2].valueForString(key: CImage), true)
                                   
                                }
                        
                        
                        self.lblFriendThird.text = arrFriends[2].valueForString(key: "first_name") + " " + arrFriends[2].valueForString(key: "last_name")
                        self.ThirduserID = arrFriends[2].valueForString(key: "id")
                    }
                    
                    if arrFriends[3].valueForString(key: CImage) == "" {
                        self.imgFriendFourth.image = UIImage(named: "user_placeholder.png")
                        self.lblFriendFourth.text = arrFriends[3].valueForString(key: "first_name") + " " + arrFriends[3].valueForString(key: "last_name")
                        self.FourthuserID = arrFriends[3].valueForString(key: "id")
                     
                    }else {
                        //self.imgFriendFourth.loadImageFromUrl(arrFriends[3].valueForString(key: CImage), true)
                        let imgExt = URL(fileURLWithPath:arrFriends[3].valueForString(key: CImage)).pathExtension
                        if imgExt == "gif"{
                                    print("-----ImgExt\(imgExt)")
                                    
                            self.imgFriendFirst.isHidden  = true
                            self.imgFriendFirstGIF.isHidden = false
                            self.imgFriendFirstGIF.sd_setImage(with: URL(string:arrFriends[3].valueForString(key: CImage)), completed: nil)
                            self.imgFriendFirstGIF.sd_cacheFLAnimatedImage = false
                                    
                                }else {
                                    self.imgFriendFirstGIF.isHidden = true
                                    self.imgFriendFirst.isHidden  = false
                                    self.imgFriendFirst.loadImageFromUrl(arrFriends[3].valueForString(key: CImage), true)
                                   
                                }
                        self.lblFriendFourth.text = arrFriends[3].valueForString(key: "first_name") + " " + arrFriends[3].valueForString(key: "last_name")
                        self.FourthuserID = arrFriends[3].valueForString(key: "id")
                    }
                    if arrFriends[4].valueForString(key: CImage) == "" {
                        self.imgFriendFive.image = UIImage(named: "user_placeholder.png")
                        self.lblFriendFive.text = arrFriends[4].valueForString(key: "first_name") + " " + arrFriends[4].valueForString(key: "last_name")
                        self.FiveuserID = arrFriends[4].valueForString(key: "id")
                     
                    }else {
                        //self.imgFriendFive.loadImageFromUrl(arrFriends[4].valueForString(key: CImage), true)
                        let imgExt = URL(fileURLWithPath:arrFriends[4].valueForString(key: CImage)).pathExtension
                        if imgExt == "gif"{
                                    print("-----ImgExt\(imgExt)")
                                    
                            self.imgFriendFirst.isHidden  = true
                            self.imgFriendFirstGIF.isHidden = false
                            self.imgFriendFirstGIF.sd_setImage(with: URL(string:arrFriends[4].valueForString(key: CImage)), completed: nil)
                            self.imgFriendFirstGIF.sd_cacheFLAnimatedImage = false
                                    
                                }else {
                                    self.imgFriendFirstGIF.isHidden = true
                                    self.imgFriendFirst.isHidden  = false
                                    self.imgFriendFirst.loadImageFromUrl(arrFriends[4].valueForString(key: CImage), true)
                                   
                                }
                        
                        self.lblFriendFive.text = arrFriends[4].valueForString(key: "first_name") + " " + arrFriends[4].valueForString(key: "last_name")
                        self.FiveuserID = arrFriends[4].valueForString(key: "id")
                    }
                    
                case 6:
                    self.imgFriendSeven.isHidden = true
                    self.imgFriendSevenGIF.isHidden = true
                    self.lblFriendSeven.isHidden = true
                    self.btnFriendSeven.isHidden = true
                    
                    self.imgFriendEight.isHidden = true
                    self.imgFriendEightGIF.isHidden = true
                    self.lblFriendEight.isHidden = true
                    self.btnFriendEight.isHidden = true
                    
                    
                    if arrFriends[0].valueForString(key: CImage) == "" {
                        self.imgFriendFirst.image = UIImage(named: "user_placeholder.png")
                        self.lblFriendFirst.text = arrFriends[0].valueForString(key: "first_name") + " " + arrFriends[0].valueForString(key: "last_name")
                        self.FristuserID = arrFriends[0].valueForString(key: "id")
                    }else {
                       // self.imgFriendFirst.loadImageFromUrl(arrFriends[0].valueForString(key: CImage), true)
                        let imgExt = URL(fileURLWithPath:arrFriends[0].valueForString(key: CImage)).pathExtension
                        if imgExt == "gif"{
                                    print("-----ImgExt\(imgExt)")
                                    
                            self.imgFriendFirst.isHidden  = true
                            self.imgFriendFirstGIF.isHidden = false
                            self.imgFriendFirstGIF.sd_setImage(with: URL(string:arrFriends[0].valueForString(key: CImage)), completed: nil)
                            self.imgFriendFirstGIF.sd_cacheFLAnimatedImage = false
                                    
                                }else {
                                    self.imgFriendFirstGIF.isHidden = true
                                    self.imgFriendFirst.isHidden  = false
                                    self.imgFriendFirst.loadImageFromUrl(arrFriends[0].valueForString(key: CImage), true)
                                   
                                }
                        
                        self.lblFriendFirst.text = arrFriends[0].valueForString(key: "first_name") + " " + arrFriends[0].valueForString(key: "last_name")
                        self.FristuserID = arrFriends[0].valueForString(key: "id")
                    }
                    if arrFriends[1].valueForString(key: CImage) == "" {
                        self.imgFriendSecond.image = UIImage(named: "user_placeholder.png")
                        self.lblFriendSecond.text = arrFriends[1].valueForString(key: "first_name") + " " + arrFriends[1].valueForString(key: "last_name")
                        self.SeconduserID = arrFriends[1].valueForString(key: "id")
                    }else {
                        //self.imgFriendSecond.loadImageFromUrl(arrFriends[1].valueForString(key: CImage), true)
                        
                        let imgExt = URL(fileURLWithPath:arrFriends[1].valueForString(key: CImage)).pathExtension
                        if imgExt == "gif"{
                                    print("-----ImgExt\(imgExt)")
                                    
                            self.imgFriendFirst.isHidden  = true
                            self.imgFriendFirstGIF.isHidden = false
                            self.imgFriendFirstGIF.sd_setImage(with: URL(string:arrFriends[1].valueForString(key: CImage)), completed: nil)
                            self.imgFriendFirstGIF.sd_cacheFLAnimatedImage = false
                                    
                                }else {
                                    self.imgFriendFirstGIF.isHidden = true
                                    self.imgFriendFirst.isHidden  = false
                                    self.imgFriendFirst.loadImageFromUrl(arrFriends[1].valueForString(key: CImage), true)
                                   
                                }
                        
                        
                        
                        self.lblFriendSecond.text = arrFriends[1].valueForString(key: "first_name") + " " + arrFriends[1].valueForString(key: "last_name")
                        self.SeconduserID = arrFriends[1].valueForString(key: "id")
                    }

                    if arrFriends[2].valueForString(key: CImage) == "" {
                        self.imgFriendThird.image = UIImage(named: "user_placeholder.png")
                        self.lblFriendThird.text = arrFriends[2].valueForString(key: "first_name") + " " + arrFriends[2].valueForString(key: "last_name")
                        self.ThirduserID = arrFriends[2].valueForString(key: "id")
                     
                    }else {
                        //self.imgFriendThird.loadImageFromUrl(arrFriends[2].valueForString(key: CImage), true)
                        let imgExt = URL(fileURLWithPath:arrFriends[2].valueForString(key: CImage)).pathExtension
                        if imgExt == "gif"{
                                    print("-----ImgExt\(imgExt)")
                                    
                            self.imgFriendFirst.isHidden  = true
                            self.imgFriendFirstGIF.isHidden = false
                            self.imgFriendFirstGIF.sd_setImage(with: URL(string:arrFriends[2].valueForString(key: CImage)), completed: nil)
                            self.imgFriendFirstGIF.sd_cacheFLAnimatedImage = false
                                    
                                }else {
                                    self.imgFriendFirstGIF.isHidden = true
                                    self.imgFriendFirst.isHidden  = false
                                    self.imgFriendFirst.loadImageFromUrl(arrFriends[2].valueForString(key: CImage), true)
                                   
                                }
                        
                        self.lblFriendThird.text = arrFriends[2].valueForString(key: "first_name") + " " + arrFriends[2].valueForString(key: "last_name")
                        self.ThirduserID = arrFriends[2].valueForString(key: "id")
                    }
                    
                    if arrFriends[3].valueForString(key: CImage) == "" {
                        self.imgFriendFourth.image = UIImage(named: "user_placeholder.png")
                        self.lblFriendFourth.text = arrFriends[3].valueForString(key: "first_name") + " " + arrFriends[3].valueForString(key: "last_name")
                        self.FourthuserID = arrFriends[3].valueForString(key: "id")
                     
                    }else {
                       // self.imgFriendFourth.loadImageFromUrl(arrFriends[3].valueForString(key: CImage), true)
                        
                        let imgExt = URL(fileURLWithPath:arrFriends[3].valueForString(key: CImage)).pathExtension
                        if imgExt == "gif"{
                                    print("-----ImgExt\(imgExt)")
                                    
                            self.imgFriendFirst.isHidden  = true
                            self.imgFriendFirstGIF.isHidden = false
                            self.imgFriendFirstGIF.sd_setImage(with: URL(string:arrFriends[3].valueForString(key: CImage)), completed: nil)
                            self.imgFriendFirstGIF.sd_cacheFLAnimatedImage = false
                                    
                                }else {
                                    self.imgFriendFirstGIF.isHidden = true
                                    self.imgFriendFirst.isHidden  = false
                                    self.imgFriendFirst.loadImageFromUrl(arrFriends[3].valueForString(key: CImage), true)
                                   
                                }
                        
                        self.lblFriendFourth.text = arrFriends[3].valueForString(key: "first_name") + " " + arrFriends[3].valueForString(key: "last_name")
                        self.FourthuserID = arrFriends[3].valueForString(key: "id")
                    }
                    if arrFriends[4].valueForString(key: CImage) == "" {
                        self.imgFriendFive.image = UIImage(named: "user_placeholder.png")
                        self.lblFriendFive.text = arrFriends[4].valueForString(key: "first_name") + " " + arrFriends[4].valueForString(key: "last_name")
                        self.FiveuserID = arrFriends[4].valueForString(key: "id")
                     
                    }else {
                       // self.imgFriendFive.loadImageFromUrl(arrFriends[4].valueForString(key: CImage), true)
                        
                        let imgExt = URL(fileURLWithPath:arrFriends[4].valueForString(key: CImage)).pathExtension
                        if imgExt == "gif"{
                                    print("-----ImgExt\(imgExt)")
                                    
                            self.imgFriendFirst.isHidden  = true
                            self.imgFriendFirstGIF.isHidden = false
                            self.imgFriendFirstGIF.sd_setImage(with: URL(string:arrFriends[4].valueForString(key: CImage)), completed: nil)
                            self.imgFriendFirstGIF.sd_cacheFLAnimatedImage = false
                                    
                                }else {
                                    self.imgFriendFirstGIF.isHidden = true
                                    self.imgFriendFirst.isHidden  = false
                                    self.imgFriendFirst.loadImageFromUrl(arrFriends[4].valueForString(key: CImage), true)
                                   
                                }
                        
                        self.lblFriendFive.text = arrFriends[4].valueForString(key: "first_name") + " " + arrFriends[4].valueForString(key: "last_name")
                        self.FiveuserID = arrFriends[4].valueForString(key: "id")
                    }
                    if arrFriends[5].valueForString(key: CImage) == "" {
                        self.imgFriendSix.image = UIImage(named: "user_placeholder.png")
                        self.lblFriendSix.text = arrFriends[5].valueForString(key: "first_name") + " " + arrFriends[5].valueForString(key: "last_name")
                        self.SixuserID = arrFriends[5].valueForString(key: "id")
                     
                    }else {
                       // self.imgFriendSix.loadImageFromUrl(arrFriends[5].valueForString(key: CImage), true)
                        let imgExt = URL(fileURLWithPath:arrFriends[5].valueForString(key: CImage)).pathExtension
                        if imgExt == "gif"{
                                    print("-----ImgExt\(imgExt)")
                                    
                            self.imgFriendFirst.isHidden  = true
                            self.imgFriendFirstGIF.isHidden = false
                            self.imgFriendFirstGIF.sd_setImage(with: URL(string:arrFriends[5].valueForString(key: CImage)), completed: nil)
                            self.imgFriendFirstGIF.sd_cacheFLAnimatedImage = false
                                    
                                }else {
                                    self.imgFriendFirstGIF.isHidden = true
                                    self.imgFriendFirst.isHidden  = false
                                    self.imgFriendFirst.loadImageFromUrl(arrFriends[5].valueForString(key: CImage), true)
                                   
                                }
                        
                        self.lblFriendSix.text = arrFriends[5].valueForString(key: "first_name") + " " + arrFriends[5].valueForString(key: "last_name")
                        self.SixuserID = arrFriends[5].valueForString(key: "id")
                    }
                case 7:
                    self.imgFriendEight.isHidden = true
                    self.imgFriendEightGIF.isHidden = true
                    self.lblFriendEight.isHidden = true
                    self.btnFriendEight.isHidden = true
                    
                    if arrFriends[0].valueForString(key: CImage) == "" {
                        self.imgFriendFirst.image = UIImage(named: "user_placeholder.png")
                        self.lblFriendFirst.text = arrFriends[0].valueForString(key: "first_name") + " " + arrFriends[0].valueForString(key: "last_name")
                        self.FristuserID = arrFriends[0].valueForString(key: "id")
                    }else {
                       // self.imgFriendFirst.loadImageFromUrl(arrFriends[0].valueForString(key: CImage), true)
                        let imgExt = URL(fileURLWithPath:arrFriends[0].valueForString(key: CImage)).pathExtension
                        if imgExt == "gif"{
                                    print("-----ImgExt\(imgExt)")
                                    
                            self.imgFriendFirst.isHidden  = true
                            self.imgFriendFirstGIF.isHidden = false
                            self.imgFriendFirstGIF.sd_setImage(with: URL(string:arrFriends[0].valueForString(key: CImage)), completed: nil)
                            self.imgFriendFirstGIF.sd_cacheFLAnimatedImage = false
                                    
                                }else {
                                    self.imgFriendFirstGIF.isHidden = true
                                    self.imgFriendFirst.isHidden  = false
                                    self.imgFriendFirst.loadImageFromUrl(arrFriends[0].valueForString(key: CImage), true)
                                   
                                }
                        
                        self.lblFriendFirst.text = arrFriends[0].valueForString(key: "first_name") + " " + arrFriends[0].valueForString(key: "last_name")
                        self.FristuserID = arrFriends[0].valueForString(key: "id")
                    }
                    
                    if arrFriends[1].valueForString(key: CImage) == "" {
                        self.imgFriendSecond.image = UIImage(named: "user_placeholder.png")
                        self.lblFriendSecond.text = arrFriends[1].valueForString(key: "first_name") + " " + arrFriends[1].valueForString(key: "last_name")
                        self.SeconduserID = arrFriends[1].valueForString(key: "id")
                    }else {
                        //self.imgFriendSecond.loadImageFromUrl(arrFriends[1].valueForString(key: CImage), true)
                        
                        let imgExt = URL(fileURLWithPath:arrFriends[1].valueForString(key: CImage)).pathExtension
                        if imgExt == "gif"{
                                    print("-----ImgExt\(imgExt)")
                                    
                            self.imgFriendFirst.isHidden  = true
                            self.imgFriendFirstGIF.isHidden = false
                            self.imgFriendFirstGIF.sd_setImage(with: URL(string:arrFriends[1].valueForString(key: CImage)), completed: nil)
                            self.imgFriendFirstGIF.sd_cacheFLAnimatedImage = false
                                    
                                }else {
                                    self.imgFriendFirstGIF.isHidden = true
                                    self.imgFriendFirst.isHidden  = false
                                    self.imgFriendFirst.loadImageFromUrl(arrFriends[1].valueForString(key: CImage), true)
                                   
                                }
                        
                        
                        self.lblFriendSecond.text = arrFriends[1].valueForString(key: "first_name") + " " + arrFriends[1].valueForString(key: "last_name")
                        self.SeconduserID = arrFriends[1].valueForString(key: "id")
                    }

                    if arrFriends[2].valueForString(key: CImage) == "" {
                        self.imgFriendThird.image = UIImage(named: "user_placeholder.png")
                        self.lblFriendThird.text = arrFriends[2].valueForString(key: "first_name") + " " + arrFriends[2].valueForString(key: "last_name")
                        self.ThirduserID = arrFriends[2].valueForString(key: "id")
                     
                    }else {
                       // self.imgFriendThird.loadImageFromUrl(arrFriends[2].valueForString(key: CImage), true)
                        let imgExt = URL(fileURLWithPath:arrFriends[2].valueForString(key: CImage)).pathExtension
                        if imgExt == "gif"{
                                    print("-----ImgExt\(imgExt)")
                                    
                            self.imgFriendFirst.isHidden  = true
                            self.imgFriendFirstGIF.isHidden = false
                            self.imgFriendFirstGIF.sd_setImage(with: URL(string:arrFriends[2].valueForString(key: CImage)), completed: nil)
                            self.imgFriendFirstGIF.sd_cacheFLAnimatedImage = false
                                    
                                }else {
                                    self.imgFriendFirstGIF.isHidden = true
                                    self.imgFriendFirst.isHidden  = false
                                    self.imgFriendFirst.loadImageFromUrl(arrFriends[2].valueForString(key: CImage), true)
                                   
                                }
                        self.lblFriendThird.text = arrFriends[2].valueForString(key: "first_name") + " " + arrFriends[2].valueForString(key: "last_name")
                        self.ThirduserID = arrFriends[2].valueForString(key: "id")
                    }
                    
                    if arrFriends[3].valueForString(key: CImage) == "" {
                        self.imgFriendFourth.image = UIImage(named: "user_placeholder.png")
                        self.lblFriendFourth.text = arrFriends[3].valueForString(key: "first_name") + " " + arrFriends[3].valueForString(key: "last_name")
                        self.FourthuserID = arrFriends[3].valueForString(key: "id")
                     
                    }else {
                        //self.imgFriendFourth.loadImageFromUrl(arrFriends[3].valueForString(key: CImage), true)
                        let imgExt = URL(fileURLWithPath:arrFriends[3].valueForString(key: CImage)).pathExtension
                        if imgExt == "gif"{
                                    print("-----ImgExt\(imgExt)")
                                    
                            self.imgFriendFirst.isHidden  = true
                            self.imgFriendFirstGIF.isHidden = false
                            self.imgFriendFirstGIF.sd_setImage(with: URL(string:arrFriends[3].valueForString(key: CImage)), completed: nil)
                            self.imgFriendFirstGIF.sd_cacheFLAnimatedImage = false
                                    
                                }else {
                                    self.imgFriendFirstGIF.isHidden = true
                                    self.imgFriendFirst.isHidden  = false
                                    self.imgFriendFirst.loadImageFromUrl(arrFriends[3].valueForString(key: CImage), true)
                                   
                                }
                        
                        self.lblFriendFourth.text = arrFriends[3].valueForString(key: "first_name") + " " + arrFriends[3].valueForString(key: "last_name")
                        self.FourthuserID = arrFriends[3].valueForString(key: "id")
                    }
                    if arrFriends[4].valueForString(key: CImage) == "" {
                        self.imgFriendFive.image = UIImage(named: "user_placeholder.png")
                        self.lblFriendFive.text = arrFriends[4].valueForString(key: "first_name") + " " + arrFriends[4].valueForString(key: "last_name")
                        self.FiveuserID = arrFriends[4].valueForString(key: "id")
                     
                    }else {
                        //self.imgFriendFive.loadImageFromUrl(arrFriends[4].valueForString(key: CImage), true)
                        let imgExt = URL(fileURLWithPath:arrFriends[4].valueForString(key: CImage)).pathExtension
                        if imgExt == "gif"{
                                    print("-----ImgExt\(imgExt)")
                                    
                            self.imgFriendFirst.isHidden  = true
                            self.imgFriendFirstGIF.isHidden = false
                            self.imgFriendFirstGIF.sd_setImage(with: URL(string:arrFriends[4].valueForString(key: CImage)), completed: nil)
                            self.imgFriendFirstGIF.sd_cacheFLAnimatedImage = false
                                    
                                }else {
                                    self.imgFriendFirstGIF.isHidden = true
                                    self.imgFriendFirst.isHidden  = false
                                    self.imgFriendFirst.loadImageFromUrl(arrFriends[4].valueForString(key: CImage), true)
                                   
                                }
                        
                        self.lblFriendFive.text = arrFriends[4].valueForString(key: "first_name") + " " + arrFriends[4].valueForString(key: "last_name")
                        self.FiveuserID = arrFriends[4].valueForString(key: "id")
                    }
                    if arrFriends[5].valueForString(key: CImage) == "" {
                        self.imgFriendSix.image = UIImage(named: "user_placeholder.png")
                        self.lblFriendSix.text = arrFriends[5].valueForString(key: "first_name") + " " + arrFriends[5].valueForString(key: "last_name")
                        self.SixuserID = arrFriends[5].valueForString(key: "id")
                     
                    }else {
                       // self.imgFriendSix.loadImageFromUrl(arrFriends[5].valueForString(key: CImage), true)
                        let imgExt = URL(fileURLWithPath:arrFriends[5].valueForString(key: CImage)).pathExtension
                        if imgExt == "gif"{
                                    print("-----ImgExt\(imgExt)")
                                    
                            self.imgFriendFirst.isHidden  = true
                            self.imgFriendFirstGIF.isHidden = false
                            self.imgFriendFirstGIF.sd_setImage(with: URL(string:arrFriends[5].valueForString(key: CImage)), completed: nil)
                            self.imgFriendFirstGIF.sd_cacheFLAnimatedImage = false
                                    
                                }else {
                                    self.imgFriendFirstGIF.isHidden = true
                                    self.imgFriendFirst.isHidden  = false
                                    self.imgFriendFirst.loadImageFromUrl(arrFriends[5].valueForString(key: CImage), true)
                                   
                                }
                        
                        self.lblFriendSix.text = arrFriends[5].valueForString(key: "first_name") + " " + arrFriends[5].valueForString(key: "last_name")
                        self.SixuserID = arrFriends[5].valueForString(key: "id")
                    }
                    if arrFriends[6].valueForString(key: CImage) == "" {
                        self.imgFriendSeven.image = UIImage(named: "user_placeholder.png")
                        self.lblFriendSeven.text = arrFriends[6].valueForString(key: "first_name") + " " + arrFriends[6].valueForString(key: "last_name")
                        self.SevenuserID = arrFriends[6].valueForString(key: "id")
                     
                    }else {
                        //self.imgFriendSeven.loadImageFromUrl(arrFriends[6].valueForString(key: CImage), true)
                        let imgExt = URL(fileURLWithPath:arrFriends[6].valueForString(key: CImage)).pathExtension
                        if imgExt == "gif"{
                                    print("-----ImgExt\(imgExt)")
                                    
                            self.imgFriendFirst.isHidden  = true
                            self.imgFriendFirstGIF.isHidden = false
                            self.imgFriendFirstGIF.sd_setImage(with: URL(string:arrFriends[6].valueForString(key: CImage)), completed: nil)
                            self.imgFriendFirstGIF.sd_cacheFLAnimatedImage = false
                                    
                                }else {
                                    self.imgFriendFirstGIF.isHidden = true
                                    self.imgFriendFirst.isHidden  = false
                                    self.imgFriendFirst.loadImageFromUrl(arrFriends[6].valueForString(key: CImage), true)
                                   
                                }
                        
                        self.lblFriendSeven.text = arrFriends[6].valueForString(key: "first_name") + " " + arrFriends[6].valueForString(key: "last_name")
                        self.SevenuserID = arrFriends[6].valueForString(key: "id")
                    }
                case 8:
                    if arrFriends[0].valueForString(key: CImage) == "" {
                        self.imgFriendFirst.image = UIImage(named: "user_placeholder.png")
                        self.lblFriendFirst.text = arrFriends[0].valueForString(key: "first_name") + " " + arrFriends[0].valueForString(key: "last_name")
                        self.FristuserID = arrFriends[0].valueForString(key: "id")
                    }else {
                       // self.imgFriendFirst.loadImageFromUrl(arrFriends[0].valueForString(key: CImage), true)
                        
                        let imgExt = URL(fileURLWithPath:arrFriends[0].valueForString(key: CImage)).pathExtension
                        if imgExt == "gif"{
                                    print("-----ImgExt\(imgExt)")
                                    
                            self.imgFriendFirst.isHidden  = true
                            self.imgFriendFirstGIF.isHidden = false
                            self.imgFriendFirstGIF.sd_setImage(with: URL(string:arrFriends[0].valueForString(key: CImage)), completed: nil)
                            self.imgFriendFirstGIF.sd_cacheFLAnimatedImage = false
                                    
                                }else {
                                    self.imgFriendFirstGIF.isHidden = true
                                    self.imgFriendFirst.isHidden  = false
                                    self.imgFriendFirst.loadImageFromUrl(arrFriends[0].valueForString(key: CImage), true)
                                   
                                }
                        
                        self.lblFriendFirst.text = arrFriends[0].valueForString(key: "first_name") + " " + arrFriends[0].valueForString(key: "last_name")
                        self.FristuserID = arrFriends[0].valueForString(key: "id")
                    }
                    
                    if arrFriends[1].valueForString(key: CImage) == "" {
                        self.imgFriendSecond.image = UIImage(named: "user_placeholder.png")
                        self.lblFriendSecond.text = arrFriends[1].valueForString(key: "first_name") + " " + arrFriends[1].valueForString(key: "last_name")
                        self.SeconduserID = arrFriends[1].valueForString(key: "id")
                    }else {
                        //self.imgFriendSecond.loadImageFromUrl(arrFriends[1].valueForString(key: CImage), true)
                        
                        let imgExt = URL(fileURLWithPath:arrFriends[1].valueForString(key: CImage)).pathExtension
                        if imgExt == "gif"{
                                    print("-----ImgExt\(imgExt)")
                                    
                            self.imgFriendFirst.isHidden  = true
                            self.imgFriendFirstGIF.isHidden = false
                            self.imgFriendFirstGIF.sd_setImage(with: URL(string:arrFriends[1].valueForString(key: CImage)), completed: nil)
                            self.imgFriendFirstGIF.sd_cacheFLAnimatedImage = false
                                    
                                }else {
                                    self.imgFriendFirstGIF.isHidden = true
                                    self.imgFriendFirst.isHidden  = false
                                    self.imgFriendFirst.loadImageFromUrl(arrFriends[1].valueForString(key: CImage), true)
                                   
                                }
                        
                        
                        self.lblFriendSecond.text = arrFriends[1].valueForString(key: "first_name") + " " + arrFriends[1].valueForString(key: "last_name")
                        self.SeconduserID = arrFriends[1].valueForString(key: "id")
                    }

                    if arrFriends[2].valueForString(key: CImage) == "" {
                        self.imgFriendThird.image = UIImage(named: "user_placeholder.png")
                        self.lblFriendThird.text = arrFriends[2].valueForString(key: "first_name") + " " + arrFriends[2].valueForString(key: "last_name")
                        self.ThirduserID = arrFriends[2].valueForString(key: "id")
                     
                    }else {
                       // self.imgFriendThird.loadImageFromUrl(arrFriends[2].valueForString(key: CImage), true)
                        let imgExt = URL(fileURLWithPath:arrFriends[2].valueForString(key: CImage)).pathExtension
                        if imgExt == "gif"{
                                    print("-----ImgExt\(imgExt)")
                                    
                            self.imgFriendFirst.isHidden  = true
                            self.imgFriendFirstGIF.isHidden = false
                            self.imgFriendFirstGIF.sd_setImage(with: URL(string:arrFriends[2].valueForString(key: CImage)), completed: nil)
                            self.imgFriendFirstGIF.sd_cacheFLAnimatedImage = false
                                    
                                }else {
                                    self.imgFriendFirstGIF.isHidden = true
                                    self.imgFriendFirst.isHidden  = false
                                    self.imgFriendFirst.loadImageFromUrl(arrFriends[2].valueForString(key: CImage), true)
                                   
                                }
                        self.lblFriendThird.text = arrFriends[2].valueForString(key: "first_name") + " " + arrFriends[2].valueForString(key: "last_name")
                        self.ThirduserID = arrFriends[2].valueForString(key: "id")
                    }
                    
                    if arrFriends[3].valueForString(key: CImage) == "" {
                        self.imgFriendFourth.image = UIImage(named: "user_placeholder.png")
                        self.lblFriendFourth.text = arrFriends[3].valueForString(key: "first_name") + " " + arrFriends[3].valueForString(key: "last_name")
                        self.FourthuserID = arrFriends[3].valueForString(key: "id")
                     
                    }else {
                        //self.imgFriendFourth.loadImageFromUrl(arrFriends[3].valueForString(key: CImage), true)
                        let imgExt = URL(fileURLWithPath:arrFriends[3].valueForString(key: CImage)).pathExtension
                        if imgExt == "gif"{
                                    print("-----ImgExt\(imgExt)")
                                    
                            self.imgFriendFirst.isHidden  = true
                            self.imgFriendFirstGIF.isHidden = false
                            self.imgFriendFirstGIF.sd_setImage(with: URL(string:arrFriends[3].valueForString(key: CImage)), completed: nil)
                            self.imgFriendFirstGIF.sd_cacheFLAnimatedImage = false
                                    
                                }else {
                                    self.imgFriendFirstGIF.isHidden = true
                                    self.imgFriendFirst.isHidden  = false
                                    self.imgFriendFirst.loadImageFromUrl(arrFriends[3].valueForString(key: CImage), true)
                                   
                                }
                        self.lblFriendFourth.text = arrFriends[3].valueForString(key: "first_name") + " " + arrFriends[3].valueForString(key: "last_name")
                        self.FourthuserID = arrFriends[3].valueForString(key: "id")
                    }
                    if arrFriends[4].valueForString(key: CImage) == "" {
                        self.imgFriendFive.image = UIImage(named: "user_placeholder.png")
                        self.lblFriendFive.text = arrFriends[4].valueForString(key: "first_name") + " " + arrFriends[4].valueForString(key: "last_name")
                        self.FiveuserID = arrFriends[4].valueForString(key: "id")
                     
                    }else {
                        //self.imgFriendFive.loadImageFromUrl(arrFriends[4].valueForString(key: CImage), true)
                        let imgExt = URL(fileURLWithPath:arrFriends[4].valueForString(key: CImage)).pathExtension
                        if imgExt == "gif"{
                                    print("-----ImgExt\(imgExt)")
                                    
                            self.imgFriendFirst.isHidden  = true
                            self.imgFriendFirstGIF.isHidden = false
                            self.imgFriendFirstGIF.sd_setImage(with: URL(string:arrFriends[4].valueForString(key: CImage)), completed: nil)
                            self.imgFriendFirstGIF.sd_cacheFLAnimatedImage = false
                                    
                                }else {
                                    self.imgFriendFirstGIF.isHidden = true
                                    self.imgFriendFirst.isHidden  = false
                                    self.imgFriendFirst.loadImageFromUrl(arrFriends[4].valueForString(key: CImage), true)
                                   
                                }
                        self.lblFriendFive.text = arrFriends[4].valueForString(key: "first_name") + " " + arrFriends[4].valueForString(key: "last_name")
                        self.FiveuserID = arrFriends[4].valueForString(key: "id")
                    }
                    if arrFriends[5].valueForString(key: CImage) == "" {
                        self.imgFriendSix.image = UIImage(named: "user_placeholder.png")
                        self.lblFriendSix.text = arrFriends[5].valueForString(key: "first_name") + " " + arrFriends[5].valueForString(key: "last_name")
                        self.SixuserID = arrFriends[5].valueForString(key: "id")
                     
                    }else {
                       // self.imgFriendSix.loadImageFromUrl(arrFriends[5].valueForString(key: CImage), true)
                        let imgExt = URL(fileURLWithPath:arrFriends[5].valueForString(key: CImage)).pathExtension
                        if imgExt == "gif"{
                                    print("-----ImgExt\(imgExt)")
                                    
                            self.imgFriendFirst.isHidden  = true
                            self.imgFriendFirstGIF.isHidden = false
                            self.imgFriendFirstGIF.sd_setImage(with: URL(string:arrFriends[5].valueForString(key: CImage)), completed: nil)
                            self.imgFriendFirstGIF.sd_cacheFLAnimatedImage = false
                                    
                                }else {
                                    self.imgFriendFirstGIF.isHidden = true
                                    self.imgFriendFirst.isHidden  = false
                                    self.imgFriendFirst.loadImageFromUrl(arrFriends[5].valueForString(key: CImage), true)
                                   
                                }
                        
                        self.lblFriendSix.text = arrFriends[5].valueForString(key: "first_name") + " " + arrFriends[5].valueForString(key: "last_name")
                        self.SixuserID = arrFriends[5].valueForString(key: "id")
                    }
                    
                    if arrFriends[6].valueForString(key: CImage) == "" {
                        self.imgFriendSeven.image = UIImage(named: "user_placeholder.png")
                        self.lblFriendSeven.text = arrFriends[6].valueForString(key: "first_name") + " " + arrFriends[6].valueForString(key: "last_name")
                        self.SevenuserID = arrFriends[6].valueForString(key: "id")
                     
                    }else {
                        //self.imgFriendSeven.loadImageFromUrl(arrFriends[6].valueForString(key: CImage), true)
                        
                        let imgExt = URL(fileURLWithPath:arrFriends[6].valueForString(key: CImage)).pathExtension
                        if imgExt == "gif"{
                                    print("-----ImgExt\(imgExt)")
                                    
                            self.imgFriendFirst.isHidden  = true
                            self.imgFriendFirstGIF.isHidden = false
                            self.imgFriendFirstGIF.sd_setImage(with: URL(string:arrFriends[6].valueForString(key: CImage)), completed: nil)
                            self.imgFriendFirstGIF.sd_cacheFLAnimatedImage = false
                                    
                                }else {
                                    self.imgFriendFirstGIF.isHidden = true
                                    self.imgFriendFirst.isHidden  = false
                                    self.imgFriendFirst.loadImageFromUrl(arrFriends[6].valueForString(key: CImage), true)
                                   
                                }
                        
                        
                        self.lblFriendSeven.text = arrFriends[6].valueForString(key: "first_name") + " " + arrFriends[6].valueForString(key: "last_name")
                        self.SevenuserID = arrFriends[6].valueForString(key: "id")
                    }
                    
                    if arrFriends[7].valueForString(key: CImage) == "" {
                        self.imgFriendEight.image = UIImage(named: "user_placeholder.png")
                        self.lblFriendEight.text = arrFriends[7].valueForString(key: "first_name") + " " + arrFriends[7].valueForString(key: "last_name")
                        self.EightuserID = arrFriends[7].valueForString(key: "id")
                     
                    }else {
                        //self.imgFriendEight.loadImageFromUrl(arrFriends[7].valueForString(key: CImage), true)
                        
                        let imgExt = URL(fileURLWithPath:arrFriends[7].valueForString(key: CImage)).pathExtension
                        if imgExt == "gif"{
                                    print("-----ImgExt\(imgExt)")
                                    
                            self.imgFriendFirst.isHidden  = true
                            self.imgFriendFirstGIF.isHidden = false
                            self.imgFriendFirstGIF.sd_setImage(with: URL(string:arrFriends[7].valueForString(key: CImage)), completed: nil)
                            self.imgFriendFirstGIF.sd_cacheFLAnimatedImage = false
                                    
                                }else {
                                    self.imgFriendFirstGIF.isHidden = true
                                    self.imgFriendFirst.isHidden  = false
                                    self.imgFriendFirst.loadImageFromUrl(arrFriends[7].valueForString(key: CImage), true)
                                   
                                }
                        
                        
                        self.lblFriendEight.text = arrFriends[7].valueForString(key: "first_name") + " " + arrFriends[7].valueForString(key: "last_name")
                        self.EightuserID = arrFriends[7].valueForString(key: "id")
                    }
                
                case 0:
                   // self.cnHeaderHightMainView.constant = 300
                    self.cnHeaderHight.constant = 30
                    self.imgFriendSecond.isHidden = true
                    self.lblFriendSecond.isHidden = true
                    self.btnFriendSecond.isHidden = true

                    self.imgFriendThird.isHidden = true
                    self.lblFriendThird.isHidden = true
                    self.btnFriendThird.isHidden = true

                    self.imgFriendFourth.isHidden = true
                    self.lblFriendFourth.isHidden = true
                    self.btnFriendFourth.isHidden = true

                    self.imgFriendFirst.isHidden = true
                    self.lblFriendFirst.isHidden = true
                    self.btnFriendFirst.isHidden = true

                default:
                    break;
                }
                
//                switch frdListCount.count {
//                case 1:
//                    self.viewFriendFirst.hide(byWidth: false)
//                    print("image:::::\(arrFriends[0].valueForString(key: CImage))")
//
//                    if arrFriends[0].valueForString(key: CImage) == "" {
//                        self.btnFriendFirst.setImage(UIImage(named: "user_placeholder.png"), for: .normal)
//                    }else {
//                        self.btnFriendFirst.sd_setImage(with: URL(string: arrFriends[0].valueForString(key: CImage)), for: .normal, completed: nil)
//                    }
//
//                case 2:
//                    self.viewFriendFirst.hide(byWidth: false)
//                    if arrFriends[0].valueForString(key: CImage) == "" {
//                        self.btnFriendFirst.setImage(UIImage(named: "user_placeholder.png"), for: .normal)
//                    }else {
//                        self.btnFriendFirst.sd_setImage(with: URL(string: arrFriends[0].valueForString(key: CImage)), for: .normal, completed: nil)
//                    }
//                    self.viewFriendSecond.hide(byWidth: false)
//                    _ = self.viewFriendSecond.setConstraintConstant(CGFloat(CUserFriendLeadingSpace), edge: .leading, ancestor: true)
//
//                    if arrFriends[1].valueForString(key: CImage) == "" {
//                        self.btnFriendSecond.setImage(UIImage(named: "user_placeholder.png"), for: .normal)
//                    }else {
//                        self.btnFriendSecond.sd_setImage(with: URL(string: arrFriends[1].valueForString(key: CImage)), for: .normal, completed: nil)
//                    }
//                case 3:
//                    self.viewFriendFirst.hide(byWidth: false)
//                    if arrFriends[0].valueForString(key: CImage) == "" {
//                        self.btnFriendFirst.setImage(UIImage(named: "user_placeholder.png"), for: .normal)
//                    }else {
//                        self.btnFriendFirst.sd_setImage(with: URL(string: arrFriends[0].valueForString(key: CImage)), for: .normal, completed: nil)
//                    }
//                    self.viewFriendSecond.hide(byWidth: false)
//                    _ = self.viewFriendSecond.setConstraintConstant(CGFloat(CUserFriendLeadingSpace), edge: .leading, ancestor: true)
//
//                    if arrFriends[1].valueForString(key: CImage) == "" {
//                        self.btnFriendSecond.setImage(UIImage(named: "user_placeholder.png"), for: .normal)
//                    }else {
//                        self.btnFriendSecond.sd_setImage(with: URL(string: arrFriends[1].valueForString(key: CImage)), for: .normal, completed: nil)
//                    }
//                    self.viewFriendThird.hide(byWidth: false)
//                    _ = self.viewFriendThird.setConstraintConstant(CGFloat(CUserFriendLeadingSpace), edge: .leading, ancestor: true)
//
//                    if arrFriends[2].valueForString(key: CImage) == "" {
//                        self.btnFriendThird.setImage(UIImage(named: "user_placeholder.png"), for: .normal)
//                    }else {
//                        self.btnFriendThird.sd_setImage(with: URL(string: arrFriends[2].valueForString(key: CImage)), for: .normal, completed: nil)
//                    }
//
//                case 4:
//                    self.viewFriendFirst.hide(byWidth: false)
//
//                    if arrFriends[0].valueForString(key: CImage) == "" {
//                        self.btnFriendFirst.setImage(UIImage(named: "user_placeholder.png"), for: .normal)
//                    }else {
//                        self.btnFriendFirst.sd_setImage(with: URL(string: arrFriends[0].valueForString(key: CImage)), for: .normal, completed: nil)
//                    }
//
//                    self.viewFriendSecond.hide(byWidth: false)
//                    _ = self.viewFriendSecond.setConstraintConstant(CGFloat(CUserFriendLeadingSpace), edge: .leading, ancestor: true)
//
//                    if arrFriends[1].valueForString(key: CImage) == "" {
//                        self.btnFriendSecond.setImage(UIImage(named: "user_placeholder.png"), for: .normal)
//                    }else {
//                        self.btnFriendSecond.sd_setImage(with: URL(string: arrFriends[1].valueForString(key: CImage)), for: .normal, completed: nil)
//                    }
//
//                    self.viewFriendThird.hide(byWidth: false)
//                    _ = self.viewFriendThird.setConstraintConstant(CGFloat(CUserFriendLeadingSpace), edge: .leading, ancestor: true)
//
//                    if arrFriends[2].valueForString(key: CImage) == "" {
//                        self.btnFriendThird.setImage(UIImage(named: "user_placeholder.png"), for: .normal)
//                    }else {
//                        self.btnFriendThird.sd_setImage(with: URL(string: arrFriends[2].valueForString(key: CImage)), for: .normal, completed: nil)
//                    }
//
//                    self.viewFriendFourth.hide(byWidth: false)
//                    _ = self.viewFriendFourth.setConstraintConstant(CGFloat(CUserFriendLeadingSpace), edge: .leading, ancestor: true)
//
//                    if arrFriends[3].valueForString(key: CImage) == "" {
//                        self.btnFriendFourth.setImage(UIImage(named: "user_placeholder.png"), for: .normal)
//                    }else {
//                        self.btnFriendFourth.sd_setImage(with: URL(string: arrFriends[3].valueForString(key: CImage)), for: .normal, completed: nil)
//                    }
//                   // _ = self.btnTotalFriend.setConstraintConstant(CGFloat(CUserFriendLeadingSpace), edge: .leading, ancestor: true)
//                default:
//                    break;
//                }
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
        let CVisible_to_other = userInfo.valueForInt(key: "visible_to_other")
        if self.Friend_status == 5 {
            if CVisible_to_friend == 0 {
               // self.btnViewCompleteProfile.setConstraintConstant(-40, edge: .top, ancestor: true)
               // self.btnViewCompleteProfile.hide(byHeight: true)
                self.hideShowMobileAndEmail(true)
                self.btnViewCompleteProfile.isHidden = true
              
            }else {
                // self.btnViewCompleteProfile.hide(byHeight: false)
                
                self.btnViewCompleteProfile.isHidden = false
                self.hideShowMobileAndEmail(false)
            }
        }else {
            // For Unknown user
            if CVisible_to_other == 0 {
                          //  self.btnViewCompleteProfile.setConstraintConstant(-40, edge: .top, ancestor: true)
                          //  self.btnViewCompleteProfile.hide(byHeight: true)
                            self.hideShowMobileAndEmail(true)
                self.hideShowMobileAndEmail(true)
                self.btnViewCompleteProfile.isHidden = true
                        }else {
                            // self.btnViewCompleteProfile.hide(byHeight: false)
                            self.btnViewCompleteProfile.isHidden = false
                            self.hideShowMobileAndEmail(false)
                          
                            self.hideShowMobileAndEmail(false)
                        }
            self.btnViewCompleteProfile.isHidden = false
            self.hideShowMobileAndEmail(false)
//                   self.btnViewCompleteProfile.setConstraintConstant(-20, edge: .top, ancestor: true)
//       self.btnViewCompleteProfile.hide(byHeight: true)
//            self.hideShowMobileAndEmail(true)
            if userInfo.valueForInt(key: "visible_to_other") == 0{
               // lblTitleFriends.hide(byHeight: true)
                hideFriendsList(isHide: true)
            }else{
               // lblTitleFriends.hide(byHeight: false)
                hideFriendsList(isHide: false)
                // _ = self.lblTitleFriends.setConstraintConstant(-60, edge: .top, ancestor: true)
            }
        }
//        self.friendViewBorderCornerRadius(self.viewFriendFirst)
//        self.friendViewBorderCornerRadius(self.viewFriendSecond)
//        self.friendViewBorderCornerRadius(self.viewFriendThird)
//        self.friendViewBorderCornerRadius(self.viewFriendFourth)
    }
    
    func hideFriendsList(isHide:Bool){
       // lblTitleFriends.isHidden = isHide
//        btnTotalFriend.isHidden = isHide
//        viewFriendFirst.isHidden = isHide
//        viewFriendSecond.isHidden = isHide
//        viewFriendThird.isHidden = isHide
//        viewFriendFourth.isHidden = isHide
    }
    
    func getFriendListFromServer(_ userid : String?) {
        _ = APIRequest.shared().getOtherUserFriendListNew(user_id: userid, pageNumber: 1) { (response, error) in
//        _ = APIRequest.shared().getOtherUserFriendListNew(user_id: userid) { (response, error) in
            if response != nil && error == nil {
                let list = response?["friends_Of_friend"] as? [String:Any] ?? [:]
                if let arrList = list[CJsonData] as? [[String:Any]] {
                    print(":::::::::friendsofFreinds\(arrList)")
                    self.frdsofFrds = arrList
                }
            }
        }
    }
    
    func myUserDetails(_ email : String?){
        if (appDelegate.loginUser?.user_id) != nil{
            let encryptUser = EncryptDecrypt.shared().encryptDecryptModel(userResultStr: email ?? "")
            let dict:[String:Any] = [
                CEmail_Mobile : encryptUser
            ]
            APIRequest.shared().otheruserDetails(para: dict as [String : AnyObject],access_Token:"",viewType: 0) {(response, error) in

                if response != nil && error == nil {
                    let data = response!["data"] as? [[String:Any]]
                    for Info in data ?? [[:]] {
                        GCDMainThread.async{
                            let friends_no = Info["friends"] as? [[String:Any]]
                            self.friends_count = friends_no?.count ?? 0
                            //self.btnTotalFriend.setTitle(self.friends_count.toString, for: .normal)
                        }

                    }


                }
            }
        }
    }
}

