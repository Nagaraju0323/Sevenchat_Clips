//
//  HomeEventImageTblCell.swift
//  Sevenchats
//
//  Created by mac-0005 on 11/09/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Chandrika.R                                 *
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
            
            self.imgUser.layer.cornerRadius = self.imgUser.frame.size.width/2
            self.lblEventType.layer.cornerRadius = 3
            self.btnComment.isUserInteractionEnabled = false
            
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
        
        postID = postInfo.valueForInt(key: CId) ?? 0
       // if let sharedData = postInfo[CSharedPost] as? [String:Any]{
            self.lblSharedUserName.text = postInfo.valueForString(key: CFullName)
            self.lblSharedPostDate.text = DateFormatter.dateStringFrom(timestamp: postInfo.valueForDouble(key: CCreated_at), withFormate: CreatedAtPostDF)
            imgSharedUser.loadImageFromUrl(postInfo.valueForString(key: CUserProfileImage), true)
            lblMessage.text = postInfo.valueForString(key: CMessage)
       // }
        self.lblUserName.text = postInfo.valueForString(key: CFirstname) + " " + postInfo.valueForString(key: CLastname)
        self.lblEventPostDate.text = DateFormatter.dateStringFrom(timestamp: postInfo.valueForDouble(key: CCreated_at), withFormate: CreatedAtPostDF)
        
        lblEventTitle.text = postInfo.valueForString(key: CTitle)
        lblEventDescription.text = postInfo.valueForString(key: CContent)
        lblStartDate.text = "\(CStartDate)"
        lblEndDate.text = "\(CEndDate)"
        
        lblEventStartDate.text = DateFormatter.dateStringFrom(timestamp: postInfo.valueForDouble(key: CEvent_Start_Date), withFormate: CDateFormat)
        lblEventEndDate.text = DateFormatter.dateStringFrom(timestamp: postInfo.valueForDouble(key: CEvent_End_Date), withFormate: CDateFormat)
        
        blurImgView.loadImageFromUrl(postInfo.valueForString(key: CImage), false)
        //imgEvent.loadImageFromUrl(postInfo.valueForString(key: CImage), false)
        
        imgURL = postInfo.valueForString(key: CImage)
        imgUser.loadImageFromUrl(postInfo.valueForString(key: CUserProfileImage), true)
        
        lblEventType.text = CTypeEvent
        lblEventCategory.text = postInfo.valueForString(key: CCategory).uppercased()
        btnLike.isSelected = postInfo.valueForInt(key: CIs_Like) == 1
        
        likeCount = postInfo.valueForInt(key: CTotal_like) ?? 0
        
        let commentCount = postInfo.valueForInt(key: CTotalComment) ?? 0
        
        btnLikesCount.setTitle(appDelegate.getLikeString(like: likeCount), for: .normal)
        btnComment.setTitle(appDelegate.getCommentCountString(comment: commentCount), for: .normal)
        btnShare.setTitle(CBtnShare, for: .normal)
        
        lblEventLocation.text = postInfo.valueForString(key: CEvent_Location)
        
        btnMaybe.setTitle("\(postInfo.valueForString(key: CTotalMaybeInterestedUsers))\n" + CMaybe, for: .normal)
        btnNotInterested.setTitle("\(postInfo.valueForString(key: CTotalNotInterestedUsers))\n" + CDeclined, for: .normal)
        btnInterested.setTitle("\(postInfo.valueForString(key: CTotalInterestedUsers))\n" + CConfirmed, for: .normal)
        
        btnMaybe.isSelected = false
        btnNotInterested.isSelected = false
        btnInterested.isSelected = false
        
        let currentDateTime = Date().timeIntervalSince1970
        
        if let endDateTime = postInfo.valueForDouble(key: CEvent_End_Date) {

            btnMaybe.isEnabled = Double(currentDateTime) <= endDateTime
            btnNotInterested.isEnabled = Double(currentDateTime) <= endDateTime
            btnInterested.isEnabled = Double(currentDateTime) <= endDateTime
        }
        
        switch postInfo.valueForInt(key: CIsInterested) {
        case 1:
            btnMaybe.isSelected = true
        case 2:
            btnInterested.isSelected = true
        case 3:
            btnNotInterested.isSelected = true
        default:
            break
        }
        
        setSelectedButtonStyle()
    }
    
    func setSelectedButtonStyle(){
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
            }else if sender == btnMaybe{
                btnMaybe.backgroundColor =  CRGB(r: 255, g: 237, b: 216)
            }else if sender == btnNotInterested{
                btnNotInterested.backgroundColor =  CRGB(r: 255, g: 214, b: 214)
            }
        }
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
        
        self.btnLike.isSelected = !self.btnLike.isSelected
        self.likeCount = self.btnLike.isSelected ? self.likeCount + 1 : self.likeCount - 1
        self.btnLikesCount.setTitle(appDelegate.getLikeString(like: self.likeCount), for: .normal)
        MIGeneralsAPI.shared().likeUnlikePostWebsite(post_id: self.postID, rss_id: nil, type: 1, likeStatus: self.btnLike.isSelected ? 1 : 0, viewController: self.viewController)
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
