//
//  HomeEventsCell.swift
//  Sevenchats
//
//  Created by mac-0005 on 10/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Nagaraju K and Chandrika R                                 *
 * Model   : HomeEventsCell                              *
 * Changes :                                             *
 *                                                       *
 ********************************************************/

import UIKit

class HomeEventsCell: UITableViewCell {

    @IBOutlet weak var viewMainContainer : UIView!
    @IBOutlet weak var viewSubContainer : UIView!
    @IBOutlet weak var imgUser : UIImageView!
    @IBOutlet weak var lblUserName : UILabel!
    @IBOutlet weak var lblEventPostDate : UILabel!
    @IBOutlet weak var lblEventCategory : UILabel!
    @IBOutlet weak var lblEventType : UILabel!
    @IBOutlet weak var lblEventTitle : UILabel!
    @IBOutlet weak var lblEventDescription : UILabel!
    @IBOutlet weak var btnLikesCount : UIButton!
    @IBOutlet weak var btnLike : UIButton!
    @IBOutlet weak var btnComment : UIButton!
    @IBOutlet weak var btnShare : UIButton!
    @IBOutlet weak var btnIconShare : UIButton!
    @IBOutlet weak var btnMore : UIButton!
    @IBOutlet weak var btnProfileImg : UIButton!
    @IBOutlet weak var btnUserName : UIButton!
    @IBOutlet weak var btnInterested : MIGenericButton!
    @IBOutlet weak var btnNotInterested : MIGenericButton!
    @IBOutlet weak var btnMaybe : MIGenericButton!
    @IBOutlet weak var lblEventLocation : UILabel!
    @IBOutlet weak var lblStartDate : UILabel!
    @IBOutlet weak var lblEndDate : UILabel!
    @IBOutlet weak var lblEventStartDate : UILabel!
    @IBOutlet weak var lblEventEndDate : UILabel!
    
    var onChangeEventStatus : ((Int) -> Void)? = nil
    
    var likeCount = 0
    var postID = 0
    var likeTotalCount = 0
    var like =  0
    var info = [String:Any]()
    var Interested = ""
    var notInterested = ""
    var mayBe = ""
    var notificationInfo = [String:Any]()
    var isSelectedChoice = ""
    var isLikesOthersPage:Bool?
    var isLikesHomePage:Bool?
    var isLikesMyprofilePage:Bool?
    var selectedChoice = ""
    var posted_ID = ""
    var posted_IDOthers = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //dedde5
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

            self.imgUser.layer.cornerRadius = self.imgUser.frame.size.width/2
            self.imgUser.layer.borderColor = #colorLiteral(red: 0, green: 0.7881455421, blue: 0.7100172639, alpha: 1)
            self.lblEventType.layer.cornerRadius = 3
            self.btnComment.isUserInteractionEnabled = false
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
            btnShare.contentHorizontalAlignment = .right
            // Reverse Flow...
            btnInterested.contentHorizontalAlignment = .right
            btnInterested.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
            
            btnNotInterested.contentHorizontalAlignment = .right
            btnNotInterested.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
            
            btnMaybe.contentHorizontalAlignment = .right
            btnMaybe.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right:10)
            
        } else {
            // Normal Flow...
            
            btnLike.contentHorizontalAlignment = .right
            btnLikesCount.contentHorizontalAlignment = .left
            btnComment.contentHorizontalAlignment = .left
            btnShare.contentHorizontalAlignment = .left
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
extension HomeEventsCell{
    
    func homeEventDataSetup(_ postInfo : [String : Any]){
        

        postID = postInfo.valueForString(key: "post_id").toInt ?? 0
        
        self.lblUserName.text = postInfo.valueForString(key: CFirstname) + " " + postInfo.valueForString(key: CLastname)
        let str_Back_title = postInfo.valueForString(key: CTitle).return_replaceBack(replaceBack: postInfo.valueForString(key: CTitle))
        lblEventTitle.text = str_Back_title
          let str_Back_desc = postInfo.valueForString(key: CContent).return_replaceBack(replaceBack: postInfo.valueForString(key: CContent))
        lblEventDescription.text = str_Back_desc
//        lblEventTitle.text = postInfo.valueForString(key: CTitle)
  //      lblEventDescription.text = postInfo.valueForString(key: CContent)
        
        let created_At1 = postInfo.valueForString(key: "start_date")
        let cnvStr1 = created_At1.stringBefore("G")
        guard let startCreated1 = DateFormatter.shared().convertDatereversLatest(strDate: cnvStr1)  else { return}
        let created_At2 = postInfo.valueForString(key: "end_date")
        let cnvStr2 = created_At2.stringBefore("G")
        guard let startCreated2 = DateFormatter.shared().convertDatereversLatest(strDate: cnvStr2) else { return}
        lblEventStartDate.text = startCreated1
        lblEventEndDate.text =  startCreated2
        
        lblEventLocation.text = postInfo.valueForString(key: CEvent_Location)
        imgUser.loadImageFromUrl(postInfo.valueForString(key: CUserProfileImage), true)
        lblEventType.text = CTypeEvent
        lblEventCategory.text = postInfo.valueForString(key: CCategory).uppercased()
        
        let is_Liked = postInfo.valueForString(key: CIsLiked)
       
        if is_Liked == "Yes"{
            btnLike.isSelected = true
        }else {
            btnLike.isSelected = false
        }
        
         likeCount = postInfo.valueForString(key: CLikes).toInt ?? 0
         btnLikesCount.setTitle(appDelegate.getLikeString(like: likeCount), for: .normal)
        let commentCount = postInfo.valueForString(key: "comments").toInt
        btnComment.setTitle(appDelegate.getCommentCountString(comment: commentCount ?? 0), for: .normal)
        btnShare.setTitle(CBtnShare, for: .normal)
        let created_At = postInfo.valueForString(key: CCreated_at)
        let cnvStr = created_At.stringBefore("G")
        let startCreated = DateFormatter.shared().convertDatereversLatest(strDate: cnvStr)
        self.lblEventPostDate.text = startCreated
        
        
        btnShare.setTitle(CBtnShare, for: .normal)
        btnMaybe.setTitle("\(postInfo.valueForString(key: "maybe_count"))\n" + CMaybe, for: .normal)
        btnNotInterested.setTitle("\(postInfo.valueForString(key: "no_count"))\n" + CDeclined, for: .normal)
        btnInterested.setTitle("\(postInfo.valueForString(key: "yes_count"))\n" + CConfirmed, for: .normal)
        self.Interested = postInfo.valueForString(key: "yes_count")
        self.notInterested = postInfo.valueForString(key: "no_count")
        self.mayBe = postInfo.valueForString(key: "maybe_count")
        self.isSelectedChoice = postInfo.valueForString(key: "selected_choice")
        
        let currentDateTime = Date().timeIntervalSince1970
        
        if let endDateTime = postInfo.valueForDouble(key: CEvent_End_Date) {

            btnMaybe.isEnabled = Double(currentDateTime) <= endDateTime
            btnNotInterested.isEnabled = Double(currentDateTime) <= endDateTime
            btnInterested.isEnabled = Double(currentDateTime) <= endDateTime
        }
        
        btnMaybe.isSelected = false
        btnNotInterested.isSelected = false
        btnInterested.isSelected = false

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
        
        
//           if postInfo?.valueForString(key:"selected_choice") == "3"{
//               btnMaybe.isSelected = true
//               btnMaybe.backgroundColor =  CRGB(r: 255, g: 237, b: 216)
//           }else if postInfo?.valueForString(key:"selected_choice") == "2"{
//               btnNotInterested.isSelected = true
//               btnNotInterested.backgroundColor =  CRGB(r: 255, g: 214, b: 214)
//           }else if postInfo?.valueForString(key:"selected_choice") == "1"{
//               btnInterested.isSelected = true
//               btnInterested.backgroundColor =  CRGB(r: 223, g: 234, b: 227)
//           }
//
       }
}

//MARK: - IBAction's
extension HomeEventsCell {
    
    @IBAction func onLikePressed(_ sender:UIButton){
        
        self.btnLike.isSelected = !self.btnLike.isSelected
        
        if self.btnLike.isSelected == true{
            likeCount = 1
            like = 1
        }else {
            likeCount = 2
            like = 0
        }
        guard let userID = appDelegate.loginUser?.user_id else {
            return
        }
        APIRequest.shared().likeUnlikeProducts(userId: Int(userID), productId: Int(self.postID) , isLike: likeCount){ [weak self](response, error) in
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
                    MIGeneralsAPI.shared().likeUnlikePostWebsites(post_id: Int(self?.postID ?? 0), rss_id: 0, type: 1, likeStatus: self?.like ?? 0 ,info:postInfo, viewController: self?.viewController)
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

