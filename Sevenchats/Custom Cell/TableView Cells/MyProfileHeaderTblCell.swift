//
//  MyProfileHeaderTbl swift
//  Sevenchats
//
//  Created by mac-0005 on 29/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Nagaraju K and Chandrika R                                 *
 * Model   : MyProfileHeaderTbl                          *
 * Changes :                                             *
 *                                                       *
 ********************************************************/

import UIKit
import Lightbox
import SDWebImage

let CStates = "states"
let CStatesTitle = "statesTilte"
let CUserFriendLeadingSpace = -8.0

class MyProfileHeaderTblCell: UITableViewCell {
    
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var imgUser : UIImageView!
    @IBOutlet weak var imgUserGIF: FLAnimatedImageView!
    @IBOutlet weak var imgCoverGIF: FLAnimatedImageView!
    @IBOutlet weak var imgCover : UIImageView!
    @IBOutlet weak var btnCoverChange: UIButton!
    @IBOutlet weak var btnProfileChange: UIButton!
    @IBOutlet weak var btnProfileChanges: UIButton!
    @IBOutlet weak var lblGender: UILabel!
    @IBOutlet weak var lblRelationship: UILabel!
    @IBOutlet weak var viewFriendFirst : UIView!
    @IBOutlet weak var viewFriendSecond : UIView!
    @IBOutlet weak var viewFriendThird : UIView!
    @IBOutlet weak var viewFriendFourth : UIView!
    @IBOutlet weak var btnCreateStories : UIButton!
    @IBOutlet weak var btnFriendFirst : UIButton!
    @IBOutlet weak var btnFriendSecond : UIButton!
    @IBOutlet weak var btnFriendThird : UIButton!
    @IBOutlet weak var btnFriendFourth : UIButton!
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
    
    @IBOutlet weak var btnTotalFriend : UIButton!
    @IBOutlet weak var btnViewCompleteProfile : UIButton!
    @IBOutlet weak var lblTitleFriends : UILabel!
    @IBOutlet weak var lblUserName : UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var clUpdateStates : UICollectionView!
    @IBOutlet weak var btnShare : UIButton!
    @IBOutlet weak var btnUserProfile : UIButton!
    @IBOutlet weak var btnUserProfileStatus : UIButton!
    @IBOutlet weak var cntBtnShareTraling : NSLayoutConstraint!
    @IBOutlet weak var btnUEditProfile : UIButton!
    @IBOutlet weak var mainView : UIView!
    @IBOutlet weak var subView : UIView!
    @IBOutlet weak var lblFriend : UILabel!
    @IBOutlet var cnHeaderHight : NSLayoutConstraint!
    
    var pageNumber = 1
    var onTotalFriendAction : (() -> Void)?
    var onEditprofileAction : (() -> Void)?
    var FristuserID  = ""
    var SeconduserID  = ""
    var ThirduserID  = ""
    var FourthuserID  = ""
    var FiveuserID  = ""
    var SixuserID  = ""
    var SevenuserID  = ""
    var EightuserID  = ""
    var callbacks : ((String) -> Void)?
    var apiTask : URLSessionTask?
    var totalFriendsCnt = 0
    var arrFriends = [[String : Any]]()
    var friends_count = 0
    var loginMobileNo = ""
    var loginEmailID = ""
    
    
    var arrUpdateStates = [
        [CStates:(appDelegate.loginUser?.total_post)! as Any,
         CStatesTitle: appDelegate.loginUser?.total_post == 1 ? CProfilePost : CProfilePosts],
        [CStates:(appDelegate.loginUser?.total_like)! as Any,CStatesTitle: appDelegate.loginUser?.total_like == 1 ? CProfileLike : CProfileLikes],
        [CStates:"0",CStatesTitle:CProfileAdsPosts],
        [CStates:"0 MB",CStatesTitle:CProfileDataUpload]
    ]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.friendsListFromServer()
        if UserDefaults.standard.value(forKey: "mobile") != nil {
            loginMobileNo = UserDefaults.standard.value(forKey: "mobile") as! String
            self.myUserDetailsMobile()
        }else if UserDefaults.standard.value(forKey: "email") != nil {
            loginEmailID = UserDefaults.standard.value(forKey: "email") as! String
            self.myUserDetails()
        }
        
        
        GCDMainThread.async {
            
         //   self.btnCreateStories.layer.cornerRadius = 10
            self.mainView.layer.cornerRadius = 10
            self.subView.layer.cornerRadius = 10
            self.btnUEditProfile.layer.borderWidth = 2
            self.btnUEditProfile.layer.borderColor = #colorLiteral(red: 0, green: 0.7881455421, blue: 0.7100172639, alpha: 1)
            self.btnUEditProfile.layer.cornerRadius = 5
            self.imgUser.layer.cornerRadius = self.imgUser.frame.size.width/2
           // self.btnShare.layer.cornerRadius = 5
            self.btnViewCompleteProfile.layer.cornerRadius = 5
            self.imgUser.layer.borderWidth = 3
            self.imgUser.layer.borderColor = #colorLiteral(red: 0, green: 0.7881455421, blue: 0.7100172639, alpha: 1)
            self.imgUserGIF.layer.cornerRadius = self.imgUserGIF.frame.size.width/2
            // self.btnShare.layer.cornerRadius = 5
            self.imgUserGIF.layer.borderWidth = 3
            self.imgUserGIF.layer.borderColor = #colorLiteral(red: 0, green: 0.7881455421, blue: 0.7100172639, alpha: 1)
            
            
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
            
            
//            self.viewFriendFirst.layer.cornerRadius = self.viewFriendFirst.frame.size.width/2
//            self.btnFriendFirst.layer.cornerRadius = self.btnFriendFirst.frame.size.width/2
//            self.viewFriendFirst.layer.borderWidth = 1.5
//            self.viewFriendFirst.layer.borderColor = UIColor.white.cgColor
//
//            self.viewFriendSecond.layer.cornerRadius = self.viewFriendSecond.frame.size.width/2
//            self.btnFriendSecond.layer.cornerRadius = self.btnFriendSecond.frame.size.width/2
//            self.viewFriendSecond.layer.borderWidth = 1.5
//            self.viewFriendSecond.layer.borderColor = UIColor.white.cgColor
//
//            self.viewFriendThird.layer.cornerRadius = self.viewFriendThird.frame.size.width/2
//            self.btnFriendThird.layer.cornerRadius = self.btnFriendThird.frame.size.width/2
//            self.viewFriendThird.layer.borderWidth = 1.5
//            self.viewFriendThird.layer.borderColor = UIColor.white.cgColor
//
//            self.viewFriendFourth.layer.cornerRadius = self.viewFriendFourth.frame.size.width/2
//            self.btnFriendFourth.layer.cornerRadius = self.btnFriendFourth.frame.size.width/2
//            self.viewFriendFourth.layer.borderWidth = 1.5
//            self.viewFriendFourth.layer.borderColor = UIColor.white.cgColor
//            self.btnTotalFriend.layer.cornerRadius = self.btnTotalFriend.frame.size.width/2
            
            self.updateUIAccordingToLanguage()
           // self.btnCreateStories.isHidden = true
            self.btnUserProfile.touchUpInside(genericTouchUpInsideHandler: { [weak self](_) in
                let lightBoxHelper = LightBoxControllerHelper()
                lightBoxHelper.openSingleImage(image: self?.imgUser.image, viewController: self?.viewController)
            })
        }
        
    }
    override func layoutSubviews() {
        let totalFriend = appDelegate.loginUser?.total_friends ?? 0
//        if let vwFriends = self.btnShare.superview, totalFriend == 0 {
//            let centerX  = vwFriends.bounds.width / 2 - (self.btnShare.bounds.width / 2)
//            self.cntBtnShareTraling.constant = centerX
//            self.layoutIfNeeded()
//        }
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
        
       // lblTitleFriends.text = CProfileFriends
        btnViewCompleteProfile.setTitle("\(" ") \(CProfileBtnViewCompleteProfile)", for: .normal)
      //  btnShare.isHidden  = true
    }
    
    func cellConfigureProfileDetail() {
        
        let arr = TblRelation.fetch(predicate: NSPredicate(format: "%K == %d", CRelationship_id, (appDelegate.loginUser?.relationship_id)!), orderBy: CName, ascending: true)
        let arrData = TblRelation.fetch(predicate: nil, orderBy: CName, ascending: true)
        _ = arrData?.value(forKeyPath: CName) as? [Any]
        //...Prefill relation status
        if (arr?.count)! > 0 {
            let dict = arr![0] as? TblRelation
            lblStatus.text = dict?.name
        }
//        lblStatus.attributedText = NSMutableAttributedString().normal(CRelationship_Status).normal(" ").bold((appDelegate.loginUser?.relationship ?? ""))
        
        lblUserName.text = "\(appDelegate.loginUser?.first_name ?? "") \(appDelegate.loginUser?.last_name ?? "")"
        
       // lblLocation.attributedText = NSMutableAttributedString().bold(CLive_in).normal(" ").normal((appDelegate.loginUser?.city ?? ""))
        
        lblLocation.attributedText = NSMutableAttributedString().normal(CLive_in).normal(" ").bold((appDelegate.loginUser?.city ?? ""))
        if appDelegate.loginUser?.relationship == "N/A" ||  appDelegate.loginUser?.relationship == "null" || appDelegate.loginUser?.relationship == "" {
            let relationship = " "
            lblStatus.attributedText = NSMutableAttributedString().normal(CRelationship_Status).normal(" ").bold((relationship))
            
        }else{
            lblStatus.attributedText = NSMutableAttributedString().normal(CRelationship_Status).normal(" ").bold((appDelegate.loginUser?.relationship ?? ""))
            
        }
        
        
        switch Int((appDelegate.loginUser?.gender)!) {
        case CMale :
            lblGender.attributedText = NSMutableAttributedString().normal(gender).normal(" ").bold(CRegisterGenderMale)
        case CFemale :
            lblGender.attributedText = NSMutableAttributedString().normal(gender).normal(" ").bold(CRegisterGenderFemale)
            
        default :
            lblGender.attributedText = NSMutableAttributedString().normal(gender).normal(" ").bold(CRegisterGenderOther)
            
        }
        _ = DateFormatter.shared().date(fromString: (appDelegate.loginUser?.dob)!, dateFormat: "yyyy-MM-dd")
        
        let imgExtCover = URL(fileURLWithPath:appDelegate.loginUser?.cover_image ?? "").pathExtension
        
        
        if imgExtCover == "gif"{
                    print("-----ImgExt\(imgExtCover)")
                    
                    imgCover.isHidden  = true
                    self.imgCoverGIF.isHidden = false
                    self.imgCoverGIF.sd_setImage(with: URL(string:appDelegate.loginUser?.cover_image ?? ""), completed: nil)
                    self.imgCoverGIF.sd_cacheFLAnimatedImage = false
                    
                    
                }else {
                    self.imgCoverGIF.isHidden = true
                    imgCover.isHidden  = false
                    if appDelegate.loginUser?.cover_image  == ""{
                        imgCover.image = UIImage(named: "CoverImage.png")
                    }else {
                        imgCover.loadImageFromUrl((appDelegate.loginUser?.cover_image ?? ""), true)
                    }
                }

        
        
//        if appDelegate.loginUser?.cover_image  == ""{
//            imgCover.image = UIImage(named: "CoverImage.png")
//        }else {
//            imgCover.loadImageFromUrl((appDelegate.loginUser?.cover_image ?? ""), true)
//        }
        let imgExt = URL(fileURLWithPath:appDelegate.loginUser?.profile_url ?? "").pathExtension
        
        
        if imgExt == "gif"{
                    print("-----ImgExt\(imgExt)")
                    
                    imgUser.isHidden  = true
                    self.imgUserGIF.isHidden = false
                    self.imgUserGIF.sd_setImage(with: URL(string:appDelegate.loginUser?.profile_url ?? ""), completed: nil)
                    self.imgUserGIF.sd_cacheFLAnimatedImage = false
                    
                    
                }else {
                    self.imgUserGIF.isHidden = true
                    imgUser.isHidden  = false
                    imgUser.loadImageFromUrl((appDelegate.loginUser?.profile_url ?? ""), true)
                    _ = appDelegate.loginUser?.total_friends ?? 0
                }
        
        
        
//        imgUser.loadImageFromUrl((appDelegate.loginUser?.profile_url ?? ""), true)
        _ = appDelegate.loginUser?.total_friends ?? 0
//        viewFriendFirst.hide(byWidth: true)
//        viewFriendSecond.hide(byWidth: true)
//        _ = viewFriendSecond.setConstraintConstant(0, edge: .leading, ancestor: true)
//        viewFriendThird.hide(byWidth: true)
//        _ = viewFriendThird.setConstraintConstant(0, edge: .leading, ancestor: true)
//        viewFriendFourth.hide(byWidth: true)
//        _ = viewFriendFourth.setConstraintConstant(0, edge: .leading, ancestor: true)
        _ = appDelegate.loginUser?.user_id
        
        let arrs = TblTotalFriends.fetch(predicate: nil, orderBy: "friend_user_id", ascending: true)
        if  let arrFriends =  TblTotalFriends.fetch(predicate: nil, orderBy: "friend_user_id", ascending: true){
            let arrFrdList = arrFriends.prefix(8)
            let frdListCount = Array(arrFrdList)
            
            switch frdListCount.count {
            case 1:
                
                cnHeaderHight.constant = 125
                imgFriendSecond.isHidden = true
                lblFriendSecond.isHidden = true
                btnFriendSecond.isHidden = true
                
                imgFriendThird.isHidden = true
                lblFriendThird.isHidden = true
                btnFriendThird.isHidden = true
                
                imgFriendFourth.isHidden = true
                lblFriendFourth.isHidden = true
                btnFriendFourth.isHidden = true
                
                imgFriendFive.isHidden = true
                lblFriendFive.isHidden = true
                btnFriendFive.isHidden = true
                
                imgFriendSix.isHidden = true
                lblFriendSix.isHidden = true
                btnFriendSix.isHidden = true
                
                imgFriendSeven.isHidden = true
                lblFriendSeven.isHidden = true
                btnFriendSeven.isHidden = true
                
                imgFriendEight.isHidden = true
                lblFriendEight.isHidden = true
                btnFriendEight.isHidden = true
                
               let dict = arrFriends[0] as? TblTotalFriends
                
                if (arrFriends[0] as! TblTotalFriends).profile_image == "" {
                    imgFriendFirst.image = UIImage(named: "user_placeholder.png")
                    lblFriendFirst.text = ((arrFriends[0] as! TblTotalFriends).first_name ?? "") + " " + ((arrFriends[0] as! TblTotalFriends).last_name ?? "")
                    self.FristuserID = (arrFriends[0] as! TblTotalFriends).friend_user_id.description
                }else {
                    imgFriendFirst.loadImageFromUrl((arrFriends[0] as! TblTotalFriends).profile_image, true)
                    lblFriendFirst.text = ((arrFriends[0] as! TblTotalFriends).first_name ?? "") + " " + ((arrFriends[0] as! TblTotalFriends).last_name ?? "")
                    self.FristuserID = (arrFriends[0] as! TblTotalFriends).friend_user_id.description
                }
                
            case 2:
                cnHeaderHight.constant = 125
                imgFriendThird.isHidden = true
                lblFriendThird.isHidden = true
                btnFriendThird.isHidden = true
                
                imgFriendFourth.isHidden = true
                lblFriendFourth.isHidden = true
                btnFriendFourth.isHidden = true
                
                imgFriendFive.isHidden = true
                lblFriendFive.isHidden = true
                btnFriendFive.isHidden = true
                
                imgFriendSix.isHidden = true
                lblFriendSix.isHidden = true
                btnFriendSix.isHidden = true
                
                imgFriendSeven.isHidden = true
                lblFriendSeven.isHidden = true
                btnFriendSeven.isHidden = true
                
                imgFriendEight.isHidden = true
                lblFriendEight.isHidden = true
                btnFriendEight.isHidden = true
                
                if (arrFriends[0] as! TblTotalFriends).profile_image == "" {
                    imgFriendFirst.image = UIImage(named: "user_placeholder.png")
                    lblFriendFirst.text = ((arrFriends[0] as! TblTotalFriends).first_name ?? "") + " " + ((arrFriends[0] as! TblTotalFriends).last_name ?? "")
                    self.FristuserID = (arrFriends[0] as! TblTotalFriends).friend_user_id.description
                    
                }else {
                    imgFriendFirst.loadImageFromUrl((arrFriends[0] as! TblTotalFriends).profile_image, true)
                    lblFriendFirst.text = ((arrFriends[0] as! TblTotalFriends).first_name ?? "") + " " + ((arrFriends[0] as! TblTotalFriends).last_name ?? "")
                    self.FristuserID = (arrFriends[0] as! TblTotalFriends).friend_user_id.description
                }
                
                if (arrFriends[1] as! TblTotalFriends).profile_image == "" {
                    imgFriendSecond.image = UIImage(named: "user_placeholder.png")
                    lblFriendSecond.text = ((arrFriends[1] as! TblTotalFriends).first_name ?? "") + " " + ((arrFriends[1] as! TblTotalFriends).last_name ?? "")
                    self.FristuserID = (arrFriends[1] as! TblTotalFriends).friend_user_id.description
                }else {
                    imgFriendSecond.loadImageFromUrl((arrFriends[1] as! TblTotalFriends).profile_image, true)
                    lblFriendSecond.text  = ((arrFriends[1] as! TblTotalFriends).first_name ?? "") + " " + ((arrFriends[1] as! TblTotalFriends).last_name ?? "")
                    self.FristuserID = (arrFriends[1] as! TblTotalFriends).friend_user_id.description
                }
//
                
            case 3:
                cnHeaderHight.constant = 125
                imgFriendFourth.isHidden = true
                lblFriendFourth.isHidden = true
                btnFriendFourth.isHidden = true
                
                imgFriendFive.isHidden = true
                lblFriendFive.isHidden = true
                btnFriendFive.isHidden = true
                
                imgFriendSix.isHidden = true
                lblFriendSix.isHidden = true
                btnFriendSix.isHidden = true
                
                imgFriendSeven.isHidden = true
                lblFriendSeven.isHidden = true
                btnFriendSeven.isHidden = true
                
                imgFriendEight.isHidden = true
                lblFriendEight.isHidden = true
                btnFriendEight.isHidden = true
                if (arrFriends[0] as! TblTotalFriends).profile_image == "" {
                    imgFriendFirst.image = UIImage(named: "user_placeholder.png")
                    lblFriendFirst.text = ((arrFriends[0] as! TblTotalFriends).first_name ?? "") + " " + ((arrFriends[0] as! TblTotalFriends).last_name ?? "")
                    self.FristuserID = (arrFriends[0] as! TblTotalFriends).friend_user_id.description
                }else {
                    imgFriendFirst.loadImageFromUrl((arrFriends[0] as! TblTotalFriends).profile_image, true)
                    lblFriendFirst.text = ((arrFriends[0] as! TblTotalFriends).first_name ?? "") + " " + ((arrFriends[0] as! TblTotalFriends).last_name ?? "")
                    self.FristuserID = (arrFriends[0] as! TblTotalFriends).friend_user_id.description
                }
                if (arrFriends[1] as! TblTotalFriends).profile_image == "" {
                    imgFriendSecond.image = UIImage(named: "user_placeholder.png")
                    lblFriendSecond.text = ((arrFriends[1] as! TblTotalFriends).first_name ?? "") + " " + ((arrFriends[1] as! TblTotalFriends).last_name ?? "")
                    self.SeconduserID = (arrFriends[1] as! TblTotalFriends).friend_user_id.description
                }else {
                    imgFriendSecond.loadImageFromUrl((arrFriends[1] as! TblTotalFriends).profile_image, true)
                    lblFriendSecond.text  = ((arrFriends[1] as! TblTotalFriends).first_name ?? "") + " " + ((arrFriends[1] as! TblTotalFriends).last_name ?? "")
                    self.SeconduserID = (arrFriends[1] as! TblTotalFriends).friend_user_id.description
                }

                if (arrFriends[2] as! TblTotalFriends).profile_image == "" {
                    imgFriendThird.image = UIImage(named: "user_placeholder.png")
                    lblFriendThird.text = ((arrFriends[2] as! TblTotalFriends).first_name ?? "") + " " + ((arrFriends[2] as! TblTotalFriends).last_name ?? "")
                    self.ThirduserID = (arrFriends[2] as! TblTotalFriends).friend_user_id.description
                }else {
                    imgFriendThird.loadImageFromUrl((arrFriends[2] as! TblTotalFriends).profile_image, true)
                    lblFriendThird.text = ((arrFriends[2] as! TblTotalFriends).first_name ?? "") + " " + ((arrFriends[2] as! TblTotalFriends).last_name ?? "")
                    self.ThirduserID = (arrFriends[2] as! TblTotalFriends).friend_user_id.description
                }
                
            case 4:
                cnHeaderHight.constant = 125
                imgFriendFive.isHidden = true
                lblFriendFive.isHidden = true
                btnFriendFive.isHidden = true
                
                imgFriendSix.isHidden = true
                lblFriendSix.isHidden = true
                btnFriendSix.isHidden = true
                
                imgFriendSeven.isHidden = true
                lblFriendSeven.isHidden = true
                btnFriendSeven.isHidden = true
                
                imgFriendEight.isHidden = true
                lblFriendEight.isHidden = true
                btnFriendEight.isHidden = true
                
                if (arrFriends[0] as! TblTotalFriends).profile_image == "" {
                    imgFriendFirst.image = UIImage(named: "user_placeholder.png")
                    lblFriendFirst.text = ((arrFriends[0] as! TblTotalFriends).first_name ?? "") + " " + ((arrFriends[0] as! TblTotalFriends).last_name ?? "")
                    self.FristuserID = (arrFriends[0] as! TblTotalFriends).friend_user_id.description
                }else {
                    imgFriendFirst.loadImageFromUrl((arrFriends[0] as! TblTotalFriends).profile_image, true)
                    lblFriendFirst.text = ((arrFriends[0] as! TblTotalFriends).first_name ?? "") + " " + ((arrFriends[0] as! TblTotalFriends).last_name ?? "")
                    self.FristuserID = (arrFriends[0] as! TblTotalFriends).friend_user_id.description
                }
                if (arrFriends[1] as! TblTotalFriends).profile_image == "" {
                    imgFriendSecond.image = UIImage(named: "user_placeholder.png")
                    lblFriendSecond.text = ((arrFriends[1] as! TblTotalFriends).first_name ?? "") + " " + ((arrFriends[1] as! TblTotalFriends).last_name ?? "")
                    self.SeconduserID = (arrFriends[1] as! TblTotalFriends).friend_user_id.description
                }else {
                    imgFriendSecond.loadImageFromUrl((arrFriends[1] as! TblTotalFriends).profile_image, true)
                    lblFriendSecond.text  = ((arrFriends[1] as! TblTotalFriends).first_name ?? "") + " " + ((arrFriends[1] as! TblTotalFriends).last_name ?? "")
                    self.SeconduserID = (arrFriends[1] as! TblTotalFriends).friend_user_id.description
                }

                if (arrFriends[2] as! TblTotalFriends).profile_image == "" {
                    imgFriendThird.image = UIImage(named: "user_placeholder.png")
                    lblFriendThird.text = ((arrFriends[2] as! TblTotalFriends).first_name ?? "") + " " + ((arrFriends[2] as! TblTotalFriends).last_name ?? "")
                    self.ThirduserID = (arrFriends[2] as! TblTotalFriends).friend_user_id.description
                 
                }else {
                    
                    imgFriendThird.loadImageFromUrl((arrFriends[2] as! TblTotalFriends).profile_image, true)
                    lblFriendThird.text = ((arrFriends[2] as! TblTotalFriends).first_name ?? "") + " " + ((arrFriends[2] as! TblTotalFriends).last_name ?? "")
                    self.ThirduserID = (arrFriends[2] as! TblTotalFriends).friend_user_id.description
                }
                
                if (arrFriends[3] as! TblTotalFriends).profile_image == "" {
                    imgFriendFourth.image = UIImage(named: "user_placeholder.png")
                    lblFriendFourth.text = ((arrFriends[3] as! TblTotalFriends).first_name ?? "") + " " + ((arrFriends[3] as! TblTotalFriends).last_name ?? "")
                    self.FourthuserID = (arrFriends[3] as! TblTotalFriends).friend_user_id.description
                 
                }else {
                    imgFriendFourth.loadImageFromUrl((arrFriends[3] as! TblTotalFriends).profile_image, true)
                    lblFriendFourth.text = ((arrFriends[3] as! TblTotalFriends).first_name ?? "") + " " + ((arrFriends[3] as! TblTotalFriends).last_name ?? "")
                    self.FourthuserID = (arrFriends[3] as! TblTotalFriends).friend_user_id.description
                }
            case 5:
                imgFriendSix.isHidden = true
                lblFriendSix.isHidden = true
                btnFriendSix.isHidden = true
                
                imgFriendSeven.isHidden = true
                lblFriendSeven.isHidden = true
                btnFriendSeven.isHidden = true
                
                imgFriendEight.isHidden = true
                lblFriendEight.isHidden = true
                btnFriendEight.isHidden = true
                if (arrFriends[0] as! TblTotalFriends).profile_image == "" {
                    imgFriendFirst.image = UIImage(named: "user_placeholder.png")
                    lblFriendFirst.text = ((arrFriends[0] as! TblTotalFriends).first_name ?? "") + " " + ((arrFriends[0] as! TblTotalFriends).last_name ?? "")
                    self.FristuserID = (arrFriends[0] as! TblTotalFriends).friend_user_id.description
                }else {
                    imgFriendFirst.loadImageFromUrl((arrFriends[0] as! TblTotalFriends).profile_image, true)
                    lblFriendFirst.text = ((arrFriends[0] as! TblTotalFriends).first_name ?? "") + " " + ((arrFriends[0] as! TblTotalFriends).last_name ?? "")
                    self.FristuserID = (arrFriends[0] as! TblTotalFriends).friend_user_id.description
                }
                if (arrFriends[1] as! TblTotalFriends).profile_image == "" {
                    imgFriendSecond.image = UIImage(named: "user_placeholder.png")
                    lblFriendSecond.text = ((arrFriends[1] as! TblTotalFriends).first_name ?? "") + " " + ((arrFriends[1] as! TblTotalFriends).last_name ?? "")
                    self.SeconduserID = (arrFriends[1] as! TblTotalFriends).friend_user_id.description
                }else {
                    imgFriendSecond.loadImageFromUrl((arrFriends[1] as! TblTotalFriends).profile_image, true)
                    lblFriendSecond.text  = ((arrFriends[1] as! TblTotalFriends).first_name ?? "") + " " + ((arrFriends[1] as! TblTotalFriends).last_name ?? "")
                    self.SeconduserID = (arrFriends[1] as! TblTotalFriends).friend_user_id.description
                }

                if (arrFriends[2] as! TblTotalFriends).profile_image == "" {
                    imgFriendThird.image = UIImage(named: "user_placeholder.png")
                    lblFriendThird.text = ((arrFriends[2] as! TblTotalFriends).first_name ?? "") + " " + ((arrFriends[2] as! TblTotalFriends).last_name ?? "")
                    self.ThirduserID = (arrFriends[2] as! TblTotalFriends).friend_user_id.description
                 
                }else {
                    imgFriendThird.loadImageFromUrl((arrFriends[2] as! TblTotalFriends).profile_image, true)
                    lblFriendThird.text = ((arrFriends[2] as! TblTotalFriends).first_name ?? "") + " " + ((arrFriends[2] as! TblTotalFriends).last_name ?? "")
                    self.ThirduserID = (arrFriends[2] as! TblTotalFriends).friend_user_id.description
                }
                
                if (arrFriends[3] as! TblTotalFriends).profile_image == "" {
                    imgFriendFourth.image = UIImage(named: "user_placeholder.png")
                    lblFriendFourth.text = ((arrFriends[3] as! TblTotalFriends).first_name ?? "") + " " + ((arrFriends[3] as! TblTotalFriends).last_name ?? "")
                    self.FourthuserID = (arrFriends[3] as! TblTotalFriends).friend_user_id.description
                 
                }else {
                    imgFriendFourth.loadImageFromUrl((arrFriends[3] as! TblTotalFriends).profile_image, true)
                    lblFriendFourth.text = ((arrFriends[3] as! TblTotalFriends).first_name ?? "") + " " + ((arrFriends[3] as! TblTotalFriends).last_name ?? "")
                    self.FourthuserID = (arrFriends[3] as! TblTotalFriends).friend_user_id.description
                }
                if (arrFriends[4] as! TblTotalFriends).profile_image == "" {
                    imgFriendFive.image = UIImage(named: "user_placeholder.png")
                    lblFriendFive.text = ((arrFriends[4] as! TblTotalFriends).first_name ?? "") + " " + ((arrFriends[4] as! TblTotalFriends).last_name ?? "")
                    self.FiveuserID = (arrFriends[4] as! TblTotalFriends).friend_user_id.description
                 
                }else {
                    imgFriendFive.loadImageFromUrl((arrFriends[4] as! TblTotalFriends).profile_image, true)
                    lblFriendFive.text = ((arrFriends[4] as! TblTotalFriends).first_name ?? "") + " " + ((arrFriends[4] as! TblTotalFriends).last_name ?? "")
                    self.FiveuserID = (arrFriends[4] as! TblTotalFriends).friend_user_id.description
                }
                
            case 6:
                imgFriendSeven.isHidden = true
                lblFriendSeven.isHidden = true
                btnFriendSeven.isHidden = true
                
                imgFriendEight.isHidden = true
                lblFriendEight.isHidden = true
                btnFriendEight.isHidden = true
                
                if (arrFriends[0] as! TblTotalFriends).profile_image == "" {
                    imgFriendFirst.image = UIImage(named: "user_placeholder.png")
                    lblFriendFirst.text = ((arrFriends[0] as! TblTotalFriends).first_name ?? "") + " " + ((arrFriends[0] as! TblTotalFriends).last_name ?? "")
                    self.FristuserID = (arrFriends[0] as! TblTotalFriends).friend_user_id.description
                }else {
                    imgFriendFirst.loadImageFromUrl((arrFriends[0] as! TblTotalFriends).profile_image, true)
                    lblFriendFirst.text = ((arrFriends[0] as! TblTotalFriends).first_name ?? "") + " " + ((arrFriends[0] as! TblTotalFriends).last_name ?? "")
                    self.FristuserID = (arrFriends[0] as! TblTotalFriends).friend_user_id.description
                }
                if (arrFriends[1] as! TblTotalFriends).profile_image == "" {
                    imgFriendSecond.image = UIImage(named: "user_placeholder.png")
                    lblFriendSecond.text = ((arrFriends[1] as! TblTotalFriends).first_name ?? "") + " " + ((arrFriends[1] as! TblTotalFriends).last_name ?? "")
                    self.SeconduserID = (arrFriends[1] as! TblTotalFriends).friend_user_id.description
                }else {
                    imgFriendSecond.loadImageFromUrl((arrFriends[1] as! TblTotalFriends).profile_image, true)
                    lblFriendSecond.text  = ((arrFriends[1] as! TblTotalFriends).first_name ?? "") + " " + ((arrFriends[1] as! TblTotalFriends).last_name ?? "")
                    self.SeconduserID = (arrFriends[1] as! TblTotalFriends).friend_user_id.description
                }

                if (arrFriends[2] as! TblTotalFriends).profile_image == "" {
                    imgFriendThird.image = UIImage(named: "user_placeholder.png")
                    lblFriendThird.text = ((arrFriends[2] as! TblTotalFriends).first_name ?? "") + " " + ((arrFriends[2] as! TblTotalFriends).last_name ?? "")
                    self.ThirduserID = (arrFriends[2] as! TblTotalFriends).friend_user_id.description
                 
                }else {
                    imgFriendThird.loadImageFromUrl((arrFriends[2] as! TblTotalFriends).profile_image, true)
                    lblFriendThird.text = ((arrFriends[2] as! TblTotalFriends).first_name ?? "") + " " + ((arrFriends[2] as! TblTotalFriends).last_name ?? "")
                    self.ThirduserID = (arrFriends[2] as! TblTotalFriends).friend_user_id.description
                }
                
                if (arrFriends[3] as! TblTotalFriends).profile_image == "" {
                    imgFriendFourth.image = UIImage(named: "user_placeholder.png")
                    lblFriendFourth.text = ((arrFriends[3] as! TblTotalFriends).first_name ?? "") + " " + ((arrFriends[3] as! TblTotalFriends).last_name ?? "")
                    self.FourthuserID = (arrFriends[3] as! TblTotalFriends).friend_user_id.description
                 
                }else {
                    imgFriendFourth.loadImageFromUrl((arrFriends[3] as! TblTotalFriends).profile_image, true)
                    lblFriendFourth.text = ((arrFriends[3] as! TblTotalFriends).first_name ?? "") + " " + ((arrFriends[3] as! TblTotalFriends).last_name ?? "")
                    self.FourthuserID = (arrFriends[3] as! TblTotalFriends).friend_user_id.description
                }
                if (arrFriends[4] as! TblTotalFriends).profile_image == "" {
                    imgFriendFive.image = UIImage(named: "user_placeholder.png")
                    lblFriendFive.text = ((arrFriends[4] as! TblTotalFriends).first_name ?? "") + " " + ((arrFriends[4] as! TblTotalFriends).last_name ?? "")
                    self.FiveuserID = (arrFriends[4] as! TblTotalFriends).friend_user_id.description
                 
                }else {
                    imgFriendFive.loadImageFromUrl((arrFriends[4] as! TblTotalFriends).profile_image, true)
                    lblFriendFive.text = ((arrFriends[4] as! TblTotalFriends).first_name ?? "") + " " + ((arrFriends[4] as! TblTotalFriends).last_name ?? "")
                    self.FiveuserID = (arrFriends[4] as! TblTotalFriends).friend_user_id.description
                }
                if (arrFriends[5] as! TblTotalFriends).profile_image == "" {
                    imgFriendSix.image = UIImage(named: "user_placeholder.png")
                    lblFriendSix.text = ((arrFriends[4] as! TblTotalFriends).first_name ?? "") + " " + ((arrFriends[4] as! TblTotalFriends).last_name ?? "")
                    self.SixuserID = (arrFriends[5] as! TblTotalFriends).friend_user_id.description
                 
                }else {
                    imgFriendSix.loadImageFromUrl((arrFriends[5] as! TblTotalFriends).profile_image, true)
                    lblFriendSix.text = ((arrFriends[5] as! TblTotalFriends).first_name ?? "") + " " + ((arrFriends[5] as! TblTotalFriends).last_name ?? "")
                    self.SixuserID = (arrFriends[5] as! TblTotalFriends).friend_user_id.description
                }
            case 7:
                imgFriendEight.isHidden = true
                lblFriendEight.isHidden = true
                btnFriendEight.isHidden = true
                if (arrFriends[0] as! TblTotalFriends).profile_image == "" {
                    imgFriendFirst.image = UIImage(named: "user_placeholder.png")
                    lblFriendFirst.text = ((arrFriends[0] as! TblTotalFriends).first_name ?? "") + " " + ((arrFriends[0] as! TblTotalFriends).last_name ?? "")
                    self.FristuserID = (arrFriends[0] as! TblTotalFriends).friend_user_id.description
                }else {
                    imgFriendFirst.loadImageFromUrl((arrFriends[0] as! TblTotalFriends).profile_image, true)
                    lblFriendFirst.text = ((arrFriends[0] as! TblTotalFriends).first_name ?? "") + " " + ((arrFriends[0] as! TblTotalFriends).last_name ?? "")
                    self.FristuserID = (arrFriends[0] as! TblTotalFriends).friend_user_id.description
                }
                if (arrFriends[1] as! TblTotalFriends).profile_image == "" {
                    imgFriendSecond.image = UIImage(named: "user_placeholder.png")
                    lblFriendSecond.text = ((arrFriends[1] as! TblTotalFriends).first_name ?? "") + " " + ((arrFriends[1] as! TblTotalFriends).last_name ?? "")
                    self.SeconduserID = (arrFriends[1] as! TblTotalFriends).friend_user_id.description
                }else {
                    imgFriendSecond.loadImageFromUrl((arrFriends[1] as! TblTotalFriends).profile_image, true)
                    lblFriendSecond.text  = ((arrFriends[1] as! TblTotalFriends).first_name ?? "") + " " + ((arrFriends[1] as! TblTotalFriends).last_name ?? "")
                    self.SeconduserID = (arrFriends[1] as! TblTotalFriends).friend_user_id.description
                }

                if (arrFriends[2] as! TblTotalFriends).profile_image == "" {
                    imgFriendThird.image = UIImage(named: "user_placeholder.png")
                    lblFriendThird.text = ((arrFriends[2] as! TblTotalFriends).first_name ?? "") + " " + ((arrFriends[2] as! TblTotalFriends).last_name ?? "")
                    self.ThirduserID = (arrFriends[2] as! TblTotalFriends).friend_user_id.description
                 
                }else {
                    imgFriendThird.loadImageFromUrl((arrFriends[2] as! TblTotalFriends).profile_image, true)
                    lblFriendThird.text = ((arrFriends[2] as! TblTotalFriends).first_name ?? "") + " " + ((arrFriends[2] as! TblTotalFriends).last_name ?? "")
                    self.ThirduserID = (arrFriends[2] as! TblTotalFriends).friend_user_id.description
                }
                
                if (arrFriends[3] as! TblTotalFriends).profile_image == "" {
                    imgFriendFourth.image = UIImage(named: "user_placeholder.png")
                    lblFriendFourth.text = ((arrFriends[3] as! TblTotalFriends).first_name ?? "") + " " + ((arrFriends[3] as! TblTotalFriends).last_name ?? "")
                    self.FourthuserID = (arrFriends[3] as! TblTotalFriends).friend_user_id.description
                 
                }else {
                    imgFriendFourth.loadImageFromUrl((arrFriends[3] as! TblTotalFriends).profile_image, true)
                    lblFriendFourth.text = ((arrFriends[3] as! TblTotalFriends).first_name ?? "") + " " + ((arrFriends[3] as! TblTotalFriends).last_name ?? "")
                    self.FourthuserID = (arrFriends[3] as! TblTotalFriends).friend_user_id.description
                }
                if (arrFriends[4] as! TblTotalFriends).profile_image == "" {
                    imgFriendFive.image = UIImage(named: "user_placeholder.png")
                    lblFriendFive.text = ((arrFriends[4] as! TblTotalFriends).first_name ?? "") + " " + ((arrFriends[4] as! TblTotalFriends).last_name ?? "")
                    self.FiveuserID = (arrFriends[4] as! TblTotalFriends).friend_user_id.description
                 
                }else {
                    imgFriendFive.loadImageFromUrl((arrFriends[4] as! TblTotalFriends).profile_image, true)
                    lblFriendFive.text = ((arrFriends[4] as! TblTotalFriends).first_name ?? "") + " " + ((arrFriends[4] as! TblTotalFriends).last_name ?? "")
                    self.FiveuserID = (arrFriends[4] as! TblTotalFriends).friend_user_id.description
                }
                if (arrFriends[5] as! TblTotalFriends).profile_image == "" {
                    imgFriendSix.image = UIImage(named: "user_placeholder.png")
                    lblFriendSix.text = ((arrFriends[4] as! TblTotalFriends).first_name ?? "") + " " + ((arrFriends[4] as! TblTotalFriends).last_name ?? "")
                    self.SixuserID = (arrFriends[5] as! TblTotalFriends).friend_user_id.description
                 
                }else {
                    imgFriendSix.loadImageFromUrl((arrFriends[5] as! TblTotalFriends).profile_image, true)
                    lblFriendSix.text = ((arrFriends[5] as! TblTotalFriends).first_name ?? "") + " " + ((arrFriends[5] as! TblTotalFriends).last_name ?? "")
                    self.SixuserID = (arrFriends[5] as! TblTotalFriends).friend_user_id.description
                }
                if (arrFriends[6] as! TblTotalFriends).profile_image == "" {
                    imgFriendSeven.image = UIImage(named: "user_placeholder.png")
                    lblFriendSeven.text = ((arrFriends[6] as! TblTotalFriends).first_name ?? "") + " " + ((arrFriends[6] as! TblTotalFriends).last_name ?? "")
                    self.SevenuserID = (arrFriends[6] as! TblTotalFriends).friend_user_id.description
                 
                }else {
                    imgFriendSeven.loadImageFromUrl((arrFriends[6] as! TblTotalFriends).profile_image, true)
                    lblFriendSeven.text = ((arrFriends[6] as! TblTotalFriends).first_name ?? "") + " " + ((arrFriends[6] as! TblTotalFriends).last_name ?? "")
                    self.SevenuserID = (arrFriends[6] as! TblTotalFriends).friend_user_id.description
                }
            case 8:
                if (arrFriends[0] as! TblTotalFriends).profile_image == "" {
                    imgFriendFirst.image = UIImage(named: "user_placeholder.png")
                    lblFriendFirst.text = ((arrFriends[0] as! TblTotalFriends).first_name ?? "") + " " + ((arrFriends[0] as! TblTotalFriends).last_name ?? "")
                    self.FristuserID = (arrFriends[0] as! TblTotalFriends).friend_user_id.description
                    self.callbacks?((arrFriends[0] as! TblTotalFriends).user_id.description)
                    
                }else {
                    imgFriendFirst.loadImageFromUrl((arrFriends[0] as! TblTotalFriends).profile_image, true)
                    lblFriendFirst.text = ((arrFriends[0] as! TblTotalFriends).first_name ?? "") + " " + ((arrFriends[0] as! TblTotalFriends).last_name ?? "")
                    self.FristuserID = (arrFriends[0] as! TblTotalFriends).friend_user_id.description
                    self.callbacks?((arrFriends[0] as! TblTotalFriends).user_id.description)
                }
                if (arrFriends[1] as! TblTotalFriends).profile_image == "" {
                    imgFriendSecond.image = UIImage(named: "user_placeholder.png")
                    lblFriendSecond.text = ((arrFriends[1] as! TblTotalFriends).first_name ?? "") + " " + ((arrFriends[1] as! TblTotalFriends).last_name ?? "")
                    self.SeconduserID = (arrFriends[1] as! TblTotalFriends).friend_user_id.description
                }else {
                    imgFriendSecond.loadImageFromUrl((arrFriends[1] as! TblTotalFriends).profile_image, true)
                    lblFriendSecond.text  = ((arrFriends[1] as! TblTotalFriends).first_name ?? "") + " " + ((arrFriends[1] as! TblTotalFriends).last_name ?? "")
                    self.SeconduserID = (arrFriends[1] as! TblTotalFriends).friend_user_id.description
                }

                if (arrFriends[2] as! TblTotalFriends).profile_image == "" {
                    imgFriendThird.image = UIImage(named: "user_placeholder.png")
                    lblFriendThird.text = ((arrFriends[2] as! TblTotalFriends).first_name ?? "") + " " + ((arrFriends[2] as! TblTotalFriends).last_name ?? "")
                    self.ThirduserID = (arrFriends[2] as! TblTotalFriends).friend_user_id.description
                 
                }else {
                    imgFriendThird.loadImageFromUrl((arrFriends[2] as! TblTotalFriends).profile_image, true)
                    lblFriendThird.text = ((arrFriends[2] as! TblTotalFriends).first_name ?? "") + " " + ((arrFriends[2] as! TblTotalFriends).last_name ?? "")
                    self.ThirduserID = (arrFriends[2] as! TblTotalFriends).friend_user_id.description
                }
                
                if (arrFriends[3] as! TblTotalFriends).profile_image == "" {
                    imgFriendFourth.image = UIImage(named: "user_placeholder.png")
                    lblFriendFourth.text = ((arrFriends[3] as! TblTotalFriends).first_name ?? "") + " " + ((arrFriends[3] as! TblTotalFriends).last_name ?? "")
                    self.FourthuserID = (arrFriends[3] as! TblTotalFriends).friend_user_id.description
                 
                }else {
                    imgFriendFourth.loadImageFromUrl((arrFriends[3] as! TblTotalFriends).profile_image, true)
                    lblFriendFourth.text = ((arrFriends[3] as! TblTotalFriends).first_name ?? "") + " " + ((arrFriends[3] as! TblTotalFriends).last_name ?? "")
                    self.FourthuserID = (arrFriends[3] as! TblTotalFriends).friend_user_id.description
                }
                if (arrFriends[4] as! TblTotalFriends).profile_image == "" {
                    imgFriendFive.image = UIImage(named: "user_placeholder.png")
                    lblFriendFive.text = ((arrFriends[4] as! TblTotalFriends).first_name ?? "") + " " + ((arrFriends[4] as! TblTotalFriends).last_name ?? "")
                    self.FiveuserID = (arrFriends[4] as! TblTotalFriends).friend_user_id.description
                 
                }else {
                    imgFriendFive.loadImageFromUrl((arrFriends[4] as! TblTotalFriends).profile_image, true)
                    lblFriendFive.text = ((arrFriends[4] as! TblTotalFriends).first_name ?? "") + " " + ((arrFriends[4] as! TblTotalFriends).last_name ?? "")
                    self.FiveuserID = (arrFriends[4] as! TblTotalFriends).friend_user_id.description
                }
                if (arrFriends[5] as! TblTotalFriends).profile_image == "" {
                    imgFriendSix.image = UIImage(named: "user_placeholder.png")
                    lblFriendSix.text = ((arrFriends[5] as! TblTotalFriends).first_name ?? "") + " " + ((arrFriends[5] as! TblTotalFriends).last_name ?? "")
                    self.SixuserID = (arrFriends[5] as! TblTotalFriends).friend_user_id.description
                 
                }else {
                    imgFriendSix.loadImageFromUrl((arrFriends[5] as! TblTotalFriends).profile_image, true)
                    lblFriendSix.text = ((arrFriends[5] as! TblTotalFriends).first_name ?? "") + " " + ((arrFriends[5] as! TblTotalFriends).last_name ?? "")
                    self.SixuserID = (arrFriends[5] as! TblTotalFriends).friend_user_id.description
                }
                if (arrFriends[6] as! TblTotalFriends).profile_image == "" {
                    imgFriendSeven.image = UIImage(named: "user_placeholder.png")
                    lblFriendSeven.text = ((arrFriends[6] as! TblTotalFriends).first_name ?? "") + " " + ((arrFriends[6] as! TblTotalFriends).last_name ?? "")
                    self.SevenuserID = (arrFriends[6] as! TblTotalFriends).friend_user_id.description
                 
                }else {
                    imgFriendSeven.loadImageFromUrl((arrFriends[6] as! TblTotalFriends).profile_image, true)
                    lblFriendSeven.text = ((arrFriends[6] as! TblTotalFriends).first_name ?? "") + " " + ((arrFriends[6] as! TblTotalFriends).last_name ?? "")
                    self.SevenuserID = (arrFriends[6] as! TblTotalFriends).friend_user_id.description
                }
                
                if (arrFriends[7] as! TblTotalFriends).profile_image == "" {
                    imgFriendEight.image = UIImage(named: "user_placeholder.png")
                    lblFriendEight.text = ((arrFriends[6] as! TblTotalFriends).first_name ?? "") + " " + ((arrFriends[6] as! TblTotalFriends).last_name ?? "")
                    self.EightuserID = (arrFriends[7] as! TblTotalFriends).friend_user_id.description
                 
                }else {
                    imgFriendEight.loadImageFromUrl((arrFriends[7] as! TblTotalFriends).profile_image, true)
                    lblFriendEight.text = ((arrFriends[7] as! TblTotalFriends).first_name ?? "") + " " + ((arrFriends[7] as! TblTotalFriends).last_name ?? "")
                    self.EightuserID = (arrFriends[7] as! TblTotalFriends).friend_user_id.description
                }
            
            case 0:
                cnHeaderHight.constant = 30
                imgFriendSecond.isHidden = true
                lblFriendSecond.isHidden = true
                btnFriendSecond.isHidden = true

                imgFriendThird.isHidden = true
                lblFriendThird.isHidden = true
                btnFriendThird.isHidden = true

                imgFriendFourth.isHidden = true
                lblFriendFourth.isHidden = true
                btnFriendFourth.isHidden = true

                imgFriendFirst.isHidden = true
                lblFriendFirst.isHidden = true
                btnFriendFirst.isHidden = true

            default:
                break;
            }
        }
        
        //[CStates:"2 hrs 10 min",CStatesTitle:CProfileTimeSpent]
        arrUpdateStates = [
            [
                CStates:(appDelegate.loginUser?.total_post)! as Any,
                CStatesTitle: appDelegate.loginUser?.total_post == 1 ? CProfilePost : CProfilePosts
            ],
            [
                CStates:(appDelegate.loginUser?.total_like)! as Any,
                CStatesTitle: appDelegate.loginUser?.total_like == 1 ? CProfileLike : CProfileLikes
            ],
            [
                CStates: appDelegate.loginUser?.total_ads ?? 0,
                CStatesTitle:CProfileAdsPosts
            ],
            [
                CStates: self.uploadSizeformat(bytes: appDelegate.loginUser?.total_data_uploaded ?? 0.0),
                CStatesTitle:CProfileDataUpload
            ]
        ]
        //        clUpdateStates.reloadData()
        DispatchQueue.main.async {
            self.layoutIfNeeded()
        }
    }
    
    func uploadSizeformat(bytes: Double) -> String {
        guard bytes > 0 else {
            return "0 MB"
        }
        /*if bytes < 1{
         return "\(bytes) MB"
         }*/
        if bytes < UnitOfBytes{
            //return "\(bytes) MB"
            return String(format: "%.2f MB", bytes)
        }
        if bytes < (UnitOfBytes * UnitOfBytes){
            //return "\(bytes / UnitOfBytes) GB"
            return String(format: "%.2f GB", (bytes / UnitOfBytes))
        }
        if bytes < (UnitOfBytes * UnitOfBytes * UnitOfBytes){
            //return "\(bytes / (UnitOfBytes * UnitOfBytes)) TB"
            return String(format: "%.2f TB", (bytes / (UnitOfBytes * UnitOfBytes)))
        }
        if bytes < (UnitOfBytes * UnitOfBytes * UnitOfBytes * UnitOfBytes){
            //return "\(bytes / (UnitOfBytes * UnitOfBytes * UnitOfBytes)) PB"
            return String(format: "%.2f PB", (UnitOfBytes * UnitOfBytes * UnitOfBytes))
        }
        return ""
    }
}

//MARK: - IBAction's
extension MyProfileHeaderTblCell {
    
    @IBAction fileprivate func onTotalFriends(_ sender:UIButton){
        self.onTotalFriendAction?()
    }
    
    @IBAction fileprivate func onEditProfile(_ sender:UIButton){
        self.onEditprofileAction?()
        
    }


}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension MyProfileHeaderTblCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrUpdateStates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileStatesCollCell", for: indexPath) as! ProfileStatesCollCell
        let dicData = arrUpdateStates[indexPath.row]
        cell.lblStates.text = dicData.valueForString(key: CStates)
        cell.lblStatesTitle.text = dicData.valueForString(key: CStatesTitle)
        cell.viewSeprator.isHidden = indexPath.row == arrUpdateStates.count - 1
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let fontToResize =  CFontPoppins(size: 12, type: .light).setUpAppropriateFont()
        let dicData = arrUpdateStates[indexPath.row]
        let title = dicData.valueForString(key: CStatesTitle)
        var size = title.size(withAttributes: [NSAttributedString.Key.font: fontToResize!])
        
        /*size.width = CGFloat(ceilf(Float(size.width + 10)))
         
         if size.width  < 65 {
         size.width = 65
         }*/
        size.width = collectionView.bounds.size.width / CGFloat(self.arrUpdateStates.count)
        size.height = clUpdateStates.frame.size.height
        return size
    }
}

//MARK :- API CALL
extension MyProfileHeaderTblCell{
    func friendsListFromServer(){
        guard  let userID = appDelegate.loginUser?.user_id else {return}
        apiTask = APIRequest.shared().getMyfriendList(page: self.pageNumber, user_id: Int(userID), search_type: nil) { [weak self](response, error) in
            if response != nil && error == nil {
                GCDMainThread.async{
                    let totalCnt = response?["total_my_friends"] as? Int
                    self?.totalFriendsCnt = totalCnt ?? 0
                    self?.lblFriend.attributedText = NSMutableAttributedString().bold((self?.totalFriendsCnt.description)!).normal(" ").bold(CCFriends)
                   // self?.btnTotalFriend.setTitle(self?.totalFriendsCnt.toString, for: .normal)
                }
            }
        }
    }
    
    func myUserDetails(){
        if let userID = appDelegate.loginUser?.user_id{
            let encryptResult = EncryptDecrypt.shared().encryptDecryptModel(userResultStr: appDelegate.loginUser?.email ?? "")
            
            let dict:[String:Any] = [
                CEmail_Mobile : encryptResult
            ]
            APIRequest.shared().userDetails(para: dict as [String : AnyObject],access_Token:"",viewType: 0) {(response, error) in

                if response != nil && error == nil {
                    let data = response!["data"] as? [[String:Any]]
                    for Info in data ?? [[:]] {
                        GCDMainThread.async{
                            let friends_no = Info["friends"] as? [[String:Any]]
                            self.friends_count = friends_no?.count ?? 0
//                            self.btnTotalFriend.setTitle(self.friends_count.toString, for: .normal)
                            MILoader.shared.hideLoader()
                        }
   
                    }
                    
                    
                }
            }
        }
    }
    
    func myUserDetailsMobile(){
        if let userID = appDelegate.loginUser?.user_id{
            let encryptMobile = EncryptDecrypt.shared().encryptDecryptModel(userResultStr: appDelegate.loginUser?.mobile ?? "")
            
            let dict:[String:Any] = [
                "mobile" : encryptMobile
            ]
            APIRequest.shared().userDetailsMobile(para: dict as [String : AnyObject],access_Token:"",viewType: 0) {(response, error) in

                if response != nil && error == nil {
                    let data = response!["data"] as? [[String:Any]]
                    for Info in data ?? [[:]] {
                        GCDMainThread.async{
                            let friends_no = Info["friends"] as? [[String:Any]]
                            self.friends_count = friends_no?.count ?? 0
                            //self.btnTotalFriend.setTitle(self.friends_count.toString, for: .normal)
                            MILoader.shared.hideLoader()
                        }
   
                    }
                    
                    
                }
            }
        }
    }
}
