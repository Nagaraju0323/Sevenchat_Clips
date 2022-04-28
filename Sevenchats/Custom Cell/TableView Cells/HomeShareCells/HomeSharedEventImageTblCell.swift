//
//  HomeEventImageTblCell.swift
//  Sevenchats
//
//  Created by mac-0005 on 11/09/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Nagaraju K and Chandrika R                                 *
 * Model   : HomeEventImageTblCell                       *
 * Changes : HomeSharedEventImageTblCell                 *
 *                                                       *
 ********************************************************/

import UIKit
import Lightbox

class HomeSharedEventImageTblCell: UITableViewCell {

    @IBOutlet weak var viewMainContainer : UIView!
    @IBOutlet weak var viewSubContainer : UIView!
    @IBOutlet weak var imgUser : UIImageView!
    //@IBOutlet weak var imgEvent : UIImageView!
    @IBOutlet weak var lblUserName : UILabel!
    @IBOutlet weak var lblEventPostDate : UILabel!
    
    @IBOutlet weak var lblEventType : UILabel!
    @IBOutlet weak var lblEventCategory : UILabel!
    @IBOutlet weak var lblEventTitle : UILabel!
    @IBOutlet weak var lblEventDescription : UILabel!
    
    @IBOutlet weak var btnLikesCount : UIButton!
    @IBOutlet weak var btnLike : UIButton!
    @IBOutlet weak var btnComment : UIButton!
    
    //@IBOutlet weak var btnReport : UIButton!
    @IBOutlet weak var btnShare : UIButton!
    @IBOutlet weak var btnIconShare : UIButton!
    @IBOutlet weak var btnMore : UIButton!
    @IBOutlet weak var btnProfileImg : UIButton!
    @IBOutlet weak var btnUserName : UIButton!
    
    @IBOutlet weak var btnInterested : MIGenericButton!
    @IBOutlet weak var btnNotInterested : MIGenericButton!
    @IBOutlet weak var btnMaybe : MIGenericButton!
    
    @IBOutlet weak var lblStartDate : UILabel!
    @IBOutlet weak var lblEndDate : UILabel!
    
    @IBOutlet weak var lblEventStartDate : UILabel!
    @IBOutlet weak var lblEventEndDate : UILabel!
    @IBOutlet weak var lblEventLocation : UILabel!
    
    @IBOutlet weak var blurImgView : BlurImageView!
    
    @IBOutlet weak var lblSharedPostDate : UILabel!
    @IBOutlet weak var imgSharedUser : UIImageView!
    @IBOutlet weak var lblSharedUserName : UILabel!
    @IBOutlet weak var btnSharedProfileImg : UIButton!
    @IBOutlet weak var btnSharedUserName : UIButton!
    @IBOutlet weak var lblMessage : UILabel!
    @IBOutlet weak var lblSharedPostType : UILabel!
    
    var likeCount = 0
    var imgURL = ""
    var postID = 0
    var onChangeEventStatus : ((Int) -> Void)? = nil
    var isLikesOthersPage:Bool?
    var Interested = ""
    var notInterested = ""
    var mayBe = ""
    var isSelectedChoice = ""
    var isLikeSelected = false
    var selectedChoice = ""
    var notificationInfo = [String:Any]()
    var posted_ID = ""
    var likeTotalCount = 0
    var like =  0
    var info = [String:Any]()
    var notifcationIsSlected = false
    var isLikesOthers:Bool?
    var isFinalLikeSelected = false
    var isLikesHomePage:Bool?
    var isLikesMyprofilePage:Bool?
    var posted_IDOthers = ""
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        lblSharedPostType.text = CSharedEvents
        func setupInterestButton(sender:UIButton){
            sender.layer.cornerRadius = 3
            sender.clipsToBounds = true
        }
        setupInterestButton(sender: btnInterested)
        setupInterestButton(sender: btnNotInterested)
        setupInterestButton(sender: btnMaybe)
        
        GCDMainThread.async {
            self.viewSubContainer.layer.cornerRadius = 8
            self.viewMainContainer.layer.cornerRadius = 8
            self.viewMainContainer.shadow(color: CRGB(r: 237, g: 236, b: 226), shadowOffset: CGSize(width: 0, height: 5), shadowRadius: 10.0, shadowOpacity: 10.0)
            self.imgUser.layer.borderWidth = 2
            self.imgUser.layer.borderColor = #colorLiteral(red: 0, green: 0.7881455421, blue: 0.7100172639, alpha: 1)
            self.imgSharedUser.layer.borderWidth = 2
            self.imgSharedUser.layer.borderColor = #colorLiteral(red: 0, green: 0.7881455421, blue: 0.7100172639, alpha: 1)
            self.imgUser.layer.cornerRadius = self.imgUser.frame.size.width/2
            self.lblEventType.layer.cornerRadius = 3
            self.btnComment.isUserInteractionEnabled = false
           // self.lblEventDescription.adjustsFontSizeToFitWidth = true
            
            self.imgSharedUser.layer.cornerRadius = self.imgSharedUser.frame.size.width/2
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.updateUIAccordingToLanguage()
    }
    
    func updateUIAccordingToLanguage(){
        
        if Localization.sharedInstance.applicationFlowWithLanguageRTL() {
            
            btnLike.contentHorizontalAlignment = .left
            btnLikesCount.contentHorizontalAlignment = .right
            btnComment.contentHorizontalAlignment = .right
            //btnComment.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 7)
            
            btnShare.contentHorizontalAlignment = .right
            //btnShare.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
            
            // Reverse Flow...
            btnInterested.contentHorizontalAlignment = .right
            btnInterested.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
            
            btnNotInterested.contentHorizontalAlignment = .right
            btnNotInterested.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
            
            btnMaybe.contentHorizontalAlignment = .right
            btnMaybe.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right:10)
            
        }else{
            // Normal Flow...
            btnLike.contentHorizontalAlignment = .right
            btnLikesCount.contentHorizontalAlignment = .left
            btnComment.contentHorizontalAlignment = .left
            //btnComment.titleEdgeInsets = UIEdgeInsets(top: 0, left: 7, bottom: 0, right: 0)
            
            btnShare.contentHorizontalAlignment = .left
            //btnShare.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
            
            // Normal Flow...
            btnInterested.contentHorizontalAlignment = .left
            btnInterested.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
            
            btnNotInterested.contentHorizontalAlignment = .left
            btnNotInterested.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
            
            btnMaybe.contentHorizontalAlignment = .left
            btnMaybe.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        }
    }
}

// MARK:- ---------- Data Setup
extension HomeSharedEventImageTblCell{
    
    func homeEventDataSetup(_ postInfo : [String : Any]){
        
        postID = postInfo.valueForString(key: "post_id").toInt ?? 0
        
        notificationInfo = postInfo
        
        if isLikesOthersPage == true {
            posted_ID = self.posted_IDOthers
        }else {
            posted_ID = postInfo.valueForString(key: "user_id")
        }
        
        
       // if let sharedData = postInfo[CSharedPost] as? [String:Any]{
            self.lblSharedUserName.text = postInfo.valueForString(key: CFullName) + " " + postInfo.valueForString(key: CLastName)
           // self.lblSharedPostDate.text = DateFormatter.dateStringFrom(timestamp: postInfo.valueForDouble(key: CCreated_at), withFormate: CreatedAtPostDF)
        let shared_created_at = postInfo.valueForString(key: CShared_Created_at)
                let shared_cnvStr = shared_created_at.stringBefore("G")
                let shared_Date = DateFormatter.shared().convertDatereversLatest(strDate: shared_cnvStr)
                lblSharedPostDate.text = shared_Date
            imgSharedUser.loadImageFromUrl(postInfo.valueForString(key: CUserSharedProfileImage), true)
            lblMessage.text = postInfo.valueForString(key: CMessage)
       // }
        self.lblUserName.text = postInfo.valueForString(key: CFirstname) + " " + postInfo.valueForString(key: CLastname)
        let created_at = postInfo.valueForString(key: CCreated_at)
        let cnvStr = created_at.stringBefore("G")
        let Created_Date = DateFormatter.shared().convertDatereversLatest(strDate: cnvStr)
        lblEventPostDate.text = Created_Date
       // self.lblEventPostDate.text = DateFormatter.dateStringFrom(timestamp: postInfo.valueForDouble(key: CCreated_at), withFormate: CreatedAtPostDF)
        
        lblEventTitle.text = postInfo.valueForString(key: CTitle)
        lblEventDescription.text = postInfo.valueForString(key: CContent)
        lblStartDate.text = "\(CStartDate)"
        lblEndDate.text = "\(CEndDate)"
        
        let created_At1 = postInfo.valueForString(key: "start_date")
        let cnvStr1 = created_At1.stringBefore("G")
        guard let startCreated1 = DateFormatter.shared().convertDatereversLatest(strDate: cnvStr1)  else { return}
        let created_At2 = postInfo.valueForString(key: "end_date")
        let cnvStr2 = created_At2.stringBefore("G")
        guard let startCreated2 = DateFormatter.shared().convertDatereversLatest(strDate: cnvStr2) else { return}
        self.lblEndDate.text = CEndDate + startCreated2
        self.lblStartDate.text = CStartDate + startCreated1
        let image = postInfo.valueForString(key: Cimages)
        if image.isEmpty {
            blurImgView.heightAnchor.constraint(equalToConstant: CGFloat(0)).isActive = true
        }else{
            blurImgView.loadImageFromUrl(postInfo.valueForString(key: Cimages), false)
        }
        imgURL = postInfo.valueForString(key: CPostImage)
        
//        lblEventStartDate.text = DateFormatter.dateStringFrom(timestamp: postInfo.valueForDouble(key: CEvent_Start_Date), withFormate: CDateFormat)
//        lblEventEndDate.text = DateFormatter.dateStringFrom(timestamp: postInfo.valueForDouble(key: CEvent_End_Date), withFormate: CDateFormat)
//
//        blurImgView.loadImageFromUrl(postInfo.valueForString(key: CImage), false)
//        //imgEvent.loadImageFromUrl(postInfo.valueForString(key: CImage), false)
//
//        imgURL = postInfo.valueForString(key: CImage)
        imgUser.loadImageFromUrl(postInfo.valueForString(key: CUserProfileImage), true)
        
        lblEventType.text = CTypeEvent
        lblEventCategory.text = postInfo.valueForString(key: CCategory).uppercased()
 
        
        
        if isLikesOthersPage == true {
            if postInfo.valueForString(key:"friend_liked") == "Yes"  && postInfo.valueForString(key:"is_liked") == "Yes" {
                btnLike.isSelected = true
                if postInfo.valueForString(key:"is_liked") == "No"{
                    isLikeSelected = false
                }
            }else {
                if postInfo.valueForString(key:"is_liked") == "No" && postInfo.valueForString(key:"friend_liked") == "No" {
                    isLikeSelected = true
                }
                btnLike.isSelected = false
            }
            
            if postInfo.valueForString(key:"is_liked") == "Yes" && postInfo.valueForString(key:"friend_liked") == "No" {
                isLikeSelected = true
                btnLike.isSelected = false
            }else if postInfo.valueForString(key:"is_liked") == "No" && postInfo.valueForString(key:"friend_liked") == "Yes"{
                
                isLikeSelected = false
                btnLike.isSelected = true
            }
        }
        if isLikesHomePage == true  || isLikesMyprofilePage == true {
            if postInfo.valueForString(key:CIs_Liked) == "Yes"{
                btnLike.isSelected = true
            }else {
                btnLike.isSelected = false
            }
        }
//        btnLike.isSelected = postInfo.valueForInt(key: CIs_Like) == 1
//        likeCount = postInfo.valueForInt(key: CTotal_like) ?? 0
//        btnLikesCount.setTitle(appDelegate.getLikeString(like: likeCount), for: .normal)
        
        likeCount = postInfo.valueForString(key: CLikes).toInt ?? 0
        btnLikesCount.setTitle(appDelegate.getLikeString(like: likeCount), for: .normal)
//        let commentCount = postInfo.valueForInt(key: CTotalComment) ?? 0
        let commentCount = postInfo.valueForString(key: "comments").toInt ?? 0

//        let commentCount = postInfo.valueForInt(key: CTotalComment) ?? 0
        btnComment.setTitle(appDelegate.getCommentCountString(comment: commentCount), for: .normal)
        btnShare.setTitle(CBtnShare, for: .normal)
        
        lblEventLocation.text = postInfo.valueForString(key: CEvent_Location)
        
//        btnMaybe.setTitle("\(postInfo.valueForString(key: CTotalMaybeInterestedUsers))\n" + CMaybe, for: .normal)
//        btnNotInterested.setTitle("\(postInfo.valueForString(key: CTotalNotInterestedUsers))\n" + CDeclined, for: .normal)
//        btnInterested.setTitle("\(postInfo.valueForString(key: CTotalInterestedUsers))\n" + CConfirmed, for: .normal)
        btnMaybe.setTitle("\(postInfo.valueForString(key: "maybe_count"))\n" + CMaybe, for: .normal)
        btnNotInterested.setTitle("\(postInfo.valueForString(key: "no_count"))\n" + CDeclined, for: .normal)
        btnInterested.setTitle("\(postInfo.valueForString(key: "yes_count"))\n" + CConfirmed, for: .normal)
        self.Interested = postInfo.valueForString(key: "yes_count")
        self.notInterested = postInfo.valueForString(key: "no_count")
        self.mayBe = postInfo.valueForString(key: "maybe_count")
        self.isSelectedChoice = postInfo.valueForString(key: "selected_choice")
        
        btnMaybe.isSelected = false
        btnNotInterested.isSelected = false
        btnInterested.isSelected = false
        
        let currentDateTime = Date().timeIntervalSince1970
        
        if let endDateTime = postInfo.valueForDouble(key: CEvent_End_Date) {

            btnMaybe.isEnabled = Double(currentDateTime) <= endDateTime
            btnNotInterested.isEnabled = Double(currentDateTime) <= endDateTime
            btnInterested.isEnabled = Double(currentDateTime) <= endDateTime
        }
        
        switch postInfo.valueForString(key: "selected_choice").toInt ?? 0  {
   
                case 3:
                    btnMaybe.isSelected = true
                case 1:
                    btnInterested.isSelected = true
 
                case 2:
                    btnNotInterested.isSelected = true
                default:
                    break
                }

        if isLikesOthersPage == true {
            
            selectedChoice = postInfo.valueForString(key: "friend_selected_choice")
            switch postInfo.valueForString(key: "friend_selected_choice").toInt ?? 0 {
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
            selectedChoice = postInfo.valueForString(key: "selected_choice")
            switch postInfo.valueForString(key: "selected_choice").toInt ?? 0 {
       
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
//        selectedChoic
        setSelectedButtonStyle(postInfo)
    }
    
    func setSelectedButtonStyle(_ postInfo : [String : Any]?){
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
         
            if postInfo?.valueForString(key:"friend_selected_choice") == "3"{
                btnMaybe.isSelected = true
                btnMaybe.backgroundColor =  CRGB(r: 255, g: 237, b: 216)
            }else if postInfo?.valueForString(key:"friend_selected_choice") == "2"{
                btnNotInterested.isSelected = true
                btnNotInterested.backgroundColor =  CRGB(r: 255, g: 214, b: 214)
            }else if postInfo?.valueForString(key:"friend_selected_choice") == "1"{
                btnInterested.isSelected = true
                btnInterested.backgroundColor =  CRGB(r: 223, g: 234, b: 227)
            }
         
            
        }else {
            
            if postInfo?.valueForString(key:"selected_choice") == "3"{
                btnMaybe.isSelected = true
                btnMaybe.backgroundColor =  CRGB(r: 255, g: 237, b: 216)
            }else if postInfo?.valueForString(key:"selected_choice") == "2"{
                btnNotInterested.isSelected = true
                btnNotInterested.backgroundColor =  CRGB(r: 255, g: 214, b: 214)
            }else if postInfo?.valueForString(key:"selected_choice") == "1"{
                btnInterested.isSelected = true
                btnInterested.backgroundColor =  CRGB(r: 223, g: 234, b: 227)
            }
         
            
        }
//        let arrButton = [btnInterested,btnMaybe,btnNotInterested]
//        if let sender = arrButton.filter({$0?.isSelected ?? false}).first{
//            if sender == btnInterested{
//                btnInterested.backgroundColor =  CRGB(r: 223, g: 234, b: 227)
//            }else if sender == btnMaybe{
//                btnMaybe.backgroundColor =  CRGB(r: 255, g: 237, b: 216)
//            }else if sender == btnNotInterested{
//                btnNotInterested.backgroundColor =  CRGB(r: 255, g: 214, b: 214)
//            }
//        }
    }
}

//MARK: - IBAction's
extension HomeSharedEventImageTblCell{
    
    @IBAction func onImageTapped(_ sender:UIButton){
        let lightBoxHelper = LightBoxControllerHelper()
        weak var weakSelf = self.viewController
        lightBoxHelper.openSingleImage(image: blurImgView.image, viewController: weakSelf)
    }
    
    @IBAction func onLikePressed(_ sender:UIButton){
        
//        self.btnLike.isSelected = !self.btnLike.isSelected
//        self.likeCount = self.btnLike.isSelected ? self.likeCount + 1 : self.likeCount - 1
//        self.btnLikesCount.setTitle(appDelegate.getLikeString(like: self.likeCount), for: .normal)
//        MIGeneralsAPI.shared().likeUnlikePostWebsite(post_id: self.postID, rss_id: nil, type: 1, likeStatus: self.btnLike.isSelected ? 1 : 0, viewController: self.viewController)
        
        self.btnLike.isSelected = !self.btnLike.isSelected
        if self.btnLike.isSelected == true{
            likeCount = 1
            like = 1
            notifcationIsSlected = true
            
            if isLikesOthersPage  == true {
                if isLikeSelected == true{
                    self.isFinalLikeSelected = true
                    isLikeSelected = false
                }else {
                    self.isFinalLikeSelected = false
                }
            }
        }else {
            likeCount = 2
            like = 0
            
            if isLikesOthersPage == true {
                if isLikeSelected == false{
                    self.isFinalLikeSelected = false
                    isLikeSelected = false
                }else {
                    self.isFinalLikeSelected = false
                }
            }
        }
        guard let userID = appDelegate.loginUser?.user_id else {
            return
        }
        APIRequest.shared().likeUnlikeProducts(userId: Int(userID), productId: Int(self.postID), isLike: likeCount){ [weak self](response, error) in
            guard let _ = self else { return }
            if response != nil {
                GCDMainThread.async {
                    let infodatass = response![CJsonData] as? [[String:Any]] ?? [[:]]
                    for infora in infodatass{
                        self?.info = infora
                    }
                    let data = response![CJsonMeta] as? [String:Any] ?? [:]
                    let stausLike = data["status"] as? String ?? "0"
                    if stausLike == "0"{
                        self?.likeCountfromSever(productId: Int((self?.self.postID)!),likeCount:self?.likeCount ?? 0, postInfo: self?.info ?? [:],like:self?.like ?? 0)
                    }
                }
            }
        }
    }
    
    
    func likeCountfromSever(productId: Int,likeCount:Int,postInfo:[String:Any],like:Int){
        APIRequest.shared().likeUnlikeProductCount(productId: Int(self.postID) ){ [weak self](response, error) in
            guard let _ = self else { return }
            if response != nil {
                GCDMainThread.async { [self] in
                    self?.likeTotalCount = response?["likes_count"] as? Int ?? 0
                    self?.btnLikesCount.setTitle(appDelegate.getLikeString(like: self?.likeTotalCount ?? 0), for: .normal)
                    guard let user_ID = appDelegate.loginUser?.user_id.description else { return }
                    guard let firstName = appDelegate.loginUser?.first_name else {return}
                    guard let lastName = appDelegate.loginUser?.last_name else {return}
                    
                    if self?.notifcationIsSlected == true{
                        
                        if self?.posted_ID == user_ID {
                            
                        }else {
                            if self?.isLikesOthersPage == true {
                                self?.notificationInfo["friend_liked"] = "Yes"
                            }
                            if self?.isLikesHomePage == true  || self?.isLikesMyprofilePage == true {
                                self?.notificationInfo["is_liked"] = "Yes"
                            }
                            self?.notificationInfo["likes"] = self?.likeTotalCount.toString
                            MIGeneralsAPI.shared().sendNotification(self?.posted_ID, userID: user_ID, subject: "liked your Post", MsgType: "COMMENT", MsgSent: "", showDisplayContent: "liked your Post", senderName: firstName + lastName, post_ID: self?.notificationInfo ?? [:],shareLink: "sendEventChLink")
                            
                            if let metaInfo = response![CJsonMeta] as? [String : Any] {
                                let stausLike = metaInfo["status"] as? String ?? "0"
                                if stausLike == "0" {
                                }
                            }
                        }
                        self?.notifcationIsSlected = false
                    }
                    if self?.isLikesOthersPage == true {
                        if self?.isFinalLikeSelected == true{
                            MIGeneralsAPI.shared().likeUnlikePostWebsites(post_id: Int(self?.postID ?? 0), rss_id: 1, type: 1, likeStatus: self?.like ?? 0 ,info:postInfo, viewController: self?.viewController)
                            self?.isLikeSelected = false
                        }else {
                            MIGeneralsAPI.shared().likeUnlikePostWebsites(post_id: Int(self?.postID ?? 0), rss_id: 2, type: 1, likeStatus: self?.like ?? 0 ,info:postInfo, viewController: self?.viewController)
                            
                        }
                    }
                    if  self?.isLikesHomePage == true || self?.isLikesMyprofilePage == true {
                        MIGeneralsAPI.shared().likeUnlikePostWebsites(post_id: Int(self?.postID ?? 0), rss_id: 3, type: 1, likeStatus: self?.like ?? 0 ,info:postInfo, viewController: self?.viewController)
                    }
                    
                }
            }
            
        }
        
    }
    
    
    
    func selectedoption(){
        if selectedChoice.toInt == 1 {
            btnMaybe.isSelected = false
            btnNotInterested.isSelected = false
            btnInterested.isSelected = true
            onChangeEventStatus?(CTypeInterested)
        }else if selectedChoice.toInt == 3 {
            btnMaybe.isSelected = true
            btnNotInterested.isSelected = false
            btnInterested.isSelected = false
            onChangeEventStatus?(CTypeMayBeInterested)
        }else if selectedChoice.toInt == 2 {
            btnMaybe.isSelected = false
            btnNotInterested.isSelected = true
            btnInterested.isSelected = false
            onChangeEventStatus?(CTypeNotInterested)
        }
    }
    @IBAction func onConfirmedPressed(_ sender:UIButton){
        if selectedChoice.toInt == 1 || selectedChoice.toInt == 2 || selectedChoice.toInt == 3 {
            selectedoption()
        }else{
        btnMaybe.isSelected = false
        btnNotInterested.isSelected = false
        btnInterested.isSelected = true
        onChangeEventStatus?(CTypeInterested)
         
         guard let user_ID = appDelegate.loginUser?.user_id.description else { return }
         guard let firstName = appDelegate.loginUser?.first_name else {return}
         guard let lastName = appDelegate.loginUser?.last_name else {return}
         print(self.posted_ID)
         
         if self.Interested.toInt == 0 && self.notInterested.toInt == 0 && self.mayBe.toInt == 0 || isSelectedChoice == "null"{

             if self.posted_ID == user_ID {
                 
             }else {
                 var intrestCount = self.Interested.toInt
                 intrestCount = +1
                 notificationInfo["yes_count"] = intrestCount?.toString
                 notificationInfo["selected_choice"] = "1"
                 MIGeneralsAPI.shared().sendNotification(self.posted_ID, userID: user_ID, subject: "Accept event", MsgType: "EVENT_CHOICE", MsgSent: "", showDisplayContent: "has tentatively Accept event", senderName: firstName + lastName, post_ID: notificationInfo,shareLink: "sendEventChLink")
             }
         }
        }
    }
    
    @IBAction func onMayBePressed(_ sender:UIButton){
        if selectedChoice.toInt == 1 || selectedChoice.toInt == 2 || selectedChoice.toInt == 3 {
            selectedoption()
        }else{
        btnMaybe.isSelected = true
        btnNotInterested.isSelected = false
        btnInterested.isSelected = false
        onChangeEventStatus?(CTypeMayBeInterested)
         
         guard let user_ID = appDelegate.loginUser?.user_id.description else { return }
         guard let firstName = appDelegate.loginUser?.first_name else {return}
         guard let lastName = appDelegate.loginUser?.last_name else {return}
         
         if self.Interested.toInt == 0 && self.notInterested.toInt == 0 && self.mayBe.toInt == 0 || selectedChoice == "null"{
            
             if self.posted_ID == user_ID {
                 
             }else {
                 
                 var maybeCount = self.mayBe.toInt ?? 0
                 maybeCount = +1
                 notificationInfo["maybe_count"] = maybeCount.toString
                 notificationInfo["selected_choice"] = "3"
                 MIGeneralsAPI.shared().sendNotification(self.posted_ID, userID: user_ID, subject: "Maybe event", MsgType: "EVENT_CHOICE", MsgSent: "", showDisplayContent: "has tentatively Accept event", senderName: firstName + lastName, post_ID:notificationInfo,shareLink: "sendEventChLink")
                 
             }
           }
        }
    }
    
    @IBAction func onDeclinedPressed(_ sender:UIButton){
        if selectedChoice.toInt == 1 || selectedChoice.toInt == 2 || selectedChoice.toInt == 3 {
            selectedoption()
        }else{
            btnMaybe.isSelected = false
            btnNotInterested.isSelected = true
            btnInterested.isSelected = false
            onChangeEventStatus?(CTypeNotInterested)
        
    
         guard let user_ID = appDelegate.loginUser?.user_id.description else { return }
         guard let firstName = appDelegate.loginUser?.first_name else {return}
         guard let lastName = appDelegate.loginUser?.last_name else {return}
         if self.Interested.toInt == 0 && self.notInterested.toInt == 0 && self.mayBe.toInt == 0 ||  selectedChoice == "null"{
             if self.posted_ID == user_ID {
                 
             }else {
                 
                 var notIntrestCount = self.notInterested.toInt ?? 0
                 notIntrestCount = +1
                 notificationInfo["no_count"] = notIntrestCount.toString
                 notificationInfo["selected_choice"] = "2"
                 
              MIGeneralsAPI.shared().sendNotification(self.posted_ID, userID: user_ID, subject: "Maybe event", MsgType: "EVENT_CHOICE", MsgSent: "", showDisplayContent: "has tentatively Accept event", senderName: firstName + lastName, post_ID: notificationInfo,shareLink: "sendEventChLink")
                 
             }
           }
        }
    }
    
    
}
