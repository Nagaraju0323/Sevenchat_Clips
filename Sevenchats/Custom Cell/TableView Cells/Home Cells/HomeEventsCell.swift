//
//  HomeEventsCell.swift
//  Sevenchats
//
//  Created by mac-0005 on 10/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

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
        lblEventTitle.text = postInfo.valueForString(key: CTitle)
        lblEventDescription.text = postInfo.valueForString(key: CContent)
        
        lblStartDate.text = "\(CStartDate)"
        lblEndDate.text = "\(CEndDate)"
        
        lblEventStartDate.text = DateFormatter.dateStringFrom(timestamp: postInfo.valueForDouble(key: CEvent_Start_Date), withFormate: CDateFormat)
        lblEventEndDate.text = DateFormatter.dateStringFrom(timestamp: postInfo.valueForDouble(key: CEvent_End_Date), withFormate: CDateFormat)
        lblEventLocation.text = postInfo.valueForString(key: CEvent_Location)
        imgUser.loadImageFromUrl(postInfo.valueForString(key: CUserProfileImage), true)
        lblEventType.text = CTypeEvent
        lblEventCategory.text = postInfo.valueForString(key: CCategory).uppercased()
        btnShare.setTitle(CBtnShare, for: .normal)
        btnMaybe.setTitle("\(postInfo.valueForString(key: "maybe_count"))\n" + CMaybe, for: .normal)
        btnNotInterested.setTitle("\(postInfo.valueForString(key: "no_count"))\n" + CDeclined, for: .normal)
        btnInterested.setTitle("\(postInfo.valueForString(key: "yes_count"))\n" + CConfirmed, for: .normal)
        
        let currentDateTime = Date().timeIntervalSince1970
        
        if let endDateTime = postInfo.valueForDouble(key: CEvent_End_Date) {

            btnMaybe.isEnabled = Double(currentDateTime) <= endDateTime
            btnNotInterested.isEnabled = Double(currentDateTime) <= endDateTime
            btnInterested.isEnabled = Double(currentDateTime) <= endDateTime
        }
        
        btnMaybe.isSelected = false
        btnNotInterested.isSelected = false
        btnInterested.isSelected = false

        switch postInfo.valueForInt(key: "selected_choice") {
                case 1:
                    btnMaybe.isSelected = true
                case 2:
                    btnInterested.isSelected = true
                case 3:
                    btnNotInterested.isSelected = true
                default:
                    break
                }
        
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
        setSelectedButtonStyle()
    }
    
    func setSelectedButtonStyle() {
        
        btnInterested.layer.borderColor = CRGB(r: 223, g: 234, b: 227).cgColor
        btnInterested.layer.borderWidth = 2
        btnInterested.backgroundColor =  .clear
        
        btnMaybe.layer.borderColor = CRGB(r: 255, g: 237, b: 216).cgColor
        btnMaybe.layer.borderWidth = 2
        btnMaybe.backgroundColor =  .clear
        
        btnNotInterested.layer.borderColor = CRGB(r: 255, g: 214, b: 214).cgColor
        btnNotInterested.layer.borderWidth = 2
        btnNotInterested.backgroundColor =  .clear
        
        let arrButton = [btnInterested,btnMaybe,btnNotInterested]
        if let sender = arrButton.filter({$0?.isSelected ?? false}).first{
            if sender == btnInterested{
                btnInterested.backgroundColor =  CRGB(r: 223, g: 234, b: 227)
            } else if sender == btnMaybe {
                btnMaybe.backgroundColor =  CRGB(r: 255, g: 237, b: 216)
            } else if sender == btnNotInterested {
                btnNotInterested.backgroundColor =  CRGB(r: 255, g: 214, b: 214)
            }
        }
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
    
    @IBAction func onConfirmedPressed(_ sender:UIButton){
        btnMaybe.isSelected = false
        btnNotInterested.isSelected = false
        btnInterested.isSelected = true
        onChangeEventStatus?(CTypeInterested)
    }
    
    @IBAction func onMayBePressed(_ sender:UIButton){
        btnMaybe.isSelected = true
        btnNotInterested.isSelected = false
        btnInterested.isSelected = false
        onChangeEventStatus?(CTypeMayBeInterested)
    }
    
    @IBAction func onDeclinedPressed(_ sender:UIButton){
        btnMaybe.isSelected = false
        btnNotInterested.isSelected = true
        btnInterested.isSelected = false
        onChangeEventStatus?(CTypeNotInterested)
    }
}
