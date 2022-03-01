//
//  HomeChirpyTblCell.swift
//  Sevenchats
//
//  Created by mac-0005 on 14/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Chandrika.R                                 *
 * Model   : HomeChirpyTblCell                           *
 * Changes : HomeSharedChirpyTblCell                     *
 *                                                       *
 ********************************************************/

import UIKit

class HomeSharedChirpyTblCell: UITableViewCell {

    @IBOutlet weak var viewMainContainer : UIView!
    @IBOutlet weak var viewSubContainer : UIView!
    @IBOutlet weak var lblChirpyDescription : UILabel!
    @IBOutlet weak var imgUser : UIImageView!
    @IBOutlet weak var lblUserName : UILabel!
    @IBOutlet weak var lblChirpyPostDate : UILabel!
    @IBOutlet weak var lblChirpyCategory : UILabel!
    
    @IBOutlet weak var lblChirpyType : UILabel!
    //@IBOutlet weak var btnReport : UIButton!
    @IBOutlet weak var btnShare : UIButton!
    @IBOutlet weak var btnIconShare : UIButton!
    @IBOutlet weak var btnMore : UIButton!
    @IBOutlet weak var btnProfileImg : UIButton!
    @IBOutlet weak var btnUserName : UIButton!
    @IBOutlet weak var btnLikesCount : UIButton!
    @IBOutlet weak var btnLike : UIButton!
    @IBOutlet weak var btnComment : UIButton!
    
    @IBOutlet weak var lblSharedPostDate : UILabel!
    @IBOutlet weak var imgSharedUser : UIImageView!
    @IBOutlet weak var lblSharedUserName : UILabel!
    @IBOutlet weak var btnSharedProfileImg : UIButton!
    @IBOutlet weak var btnSharedUserName : UIButton!
    @IBOutlet weak var lblMessage : UILabel!
    @IBOutlet weak var lblSharedPostType : UILabel!
    
    var likeCount = 0
    var postID = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblSharedPostType.text = CSharedChirpy
        GCDMainThread.async {
            self.viewSubContainer.layer.cornerRadius = 8
            self.viewMainContainer.layer.cornerRadius = 8
            self.viewMainContainer.shadow(color: CRGB(r: 237, g: 236, b: 226), shadowOffset: CGSize(width: 0, height: 5), shadowRadius: 10.0, shadowOpacity: 10.0)
            
            self.imgUser.layer.cornerRadius = self.imgUser.frame.size.width/2
            self.imgUser.layer.borderWidth = 2
            self.imgUser.layer.borderColor = #colorLiteral(red: 0, green: 0.7881455421, blue: 0.7100172639, alpha: 1)
            self.lblChirpyType.layer.cornerRadius = 3
            self.btnComment.isUserInteractionEnabled = false
            
            self.imgSharedUser.layer.cornerRadius = self.imgSharedUser.frame.size.width/2
            self.imgSharedUser.layer.borderWidth = 2
            self.imgSharedUser.layer.borderColor = #colorLiteral(red: 0, green: 0.7881455421, blue: 0.7100172639, alpha: 1)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.updateUIAccordingToLanguage()
    }
    
    func updateUIAccordingToLanguage(){
        
        if Localization.sharedInstance.applicationFlowWithLanguageRTL() {
            // Reverse Flow...
            btnLike.contentHorizontalAlignment = .left
            btnLikesCount.contentHorizontalAlignment = .right
            btnComment.contentHorizontalAlignment = .right
            //btnComment.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 7)
            btnShare.contentHorizontalAlignment = .right
            //btnShare.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
        }else{
            // Normal Flow...
            btnLike.contentHorizontalAlignment = .right
            btnLikesCount.contentHorizontalAlignment = .left
            btnComment.contentHorizontalAlignment = .left
            //btnComment.titleEdgeInsets = UIEdgeInsets(top: 0, left: 7, bottom: 0, right: 0)
            btnShare.contentHorizontalAlignment = .left
            //btnShare.titleEdgeInsets = UIEdgeInsets(top: 0, left: 7, bottom: 0, right: 0)
        }
    }
}
extension HomeSharedChirpyTblCell{
    
    func homeChirpyDataSetup(_ postInfo : [String : Any]){
        
        postID = postInfo.valueForString(key: "post_id").toInt ?? 0

       // if let sharedData = postInfo[CSharedPost] as? [String:Any]{
            self.lblSharedUserName.text = postInfo.valueForString(key: CFullName) + " " + postInfo.valueForString(key: CLastName)
        let shared_created_at = postInfo.valueForString(key: CShared_Created_at)
                let shared_cnvStr = shared_created_at.stringBefore("G")
                let shared_Date = DateFormatter.shared().convertDatereversLatest(strDate: shared_cnvStr)
                lblSharedPostDate.text = shared_Date
            //self.lblSharedPostDate.text = DateFormatter.dateStringFrom(timestamp: postInfo.valueForDouble(key: CCreated_at), withFormate: CreatedAtPostDF)
            imgSharedUser.loadImageFromUrl(postInfo.valueForString(key: CUserProfileImage), true)
            lblMessage.text = postInfo.valueForString(key: CMessage)
      //  }

        lblChirpyType.text = CTypeChirpy
        self.lblUserName.text = postInfo.valueForString(key: CFirstname) + " " + postInfo.valueForString(key: CLastname)
        lblChirpyDescription.text = postInfo.valueForString(key: CContent)
        lblChirpyCategory.text = postInfo.valueForString(key: CCategory).uppercased()
        let created_at = postInfo.valueForString(key: CCreated_at)
                let cnvStr = created_at.stringBefore("G")
                let Created_Date = DateFormatter.shared().convertDatereversLatest(strDate: cnvStr)
        lblChirpyPostDate.text = Created_Date
       // self.lblChirpyPostDate.text = DateFormatter.dateStringFrom(timestamp: postInfo.valueForDouble(key: CCreated_at), withFormate: CreatedAtPostDF)
        
        imgUser.loadImageFromUrl(postInfo.valueForString(key: CUserProfileImage), true)
        btnLike.isSelected = postInfo.valueForInt(key: CIs_Like) == 1
        
        likeCount = postInfo.valueForInt(key: CTotal_like) ?? 0
        
        let commentCount = postInfo.valueForInt(key: CTotalComment) ?? 0
        
        btnLikesCount.setTitle(appDelegate.getLikeString(like: likeCount), for: .normal)
        btnComment.setTitle(appDelegate.getCommentCountString(comment: commentCount), for: .normal)
        btnShare.setTitle(CBtnShare, for: .normal)
    }
    
}

//MARK: - IBAction's
extension HomeSharedChirpyTblCell {
    
    @IBAction func onLikePressed(_ sender:UIButton){
        
        self.btnLike.isSelected = !self.btnLike.isSelected
        self.likeCount = self.btnLike.isSelected ? self.likeCount + 1 : self.likeCount - 1
        self.btnLikesCount.setTitle(appDelegate.getLikeString(like: self.likeCount), for: .normal)
        MIGeneralsAPI.shared().likeUnlikePostWebsite(post_id: self.postID, rss_id: nil, type: 1, likeStatus: self.btnLike.isSelected ? 1 : 0, viewController: self.viewController)
    }
}
