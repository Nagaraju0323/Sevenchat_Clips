//
//  PostDeletedDetailCell.swift
//  Sevenchats
//
//  Created by mac-00020 on 24/09/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : PostDeletedDetailCell.R                     *
 * Model   : PostDeletedDetailCell                       *
 * Changes :                                             *
 *                                                       *
 ********************************************************/

import UIKit

class PostDeletedDetailCell: UITableViewCell {
    
    @IBOutlet weak var viewMainContainer : UIView!
    @IBOutlet weak var viewSubContainer : UIView!
    
    @IBOutlet weak var btnLikesCount : UIButton!
    @IBOutlet weak var btnLike : UIButton!
    @IBOutlet weak var btnComment : UIButton!
    
    @IBOutlet weak var lblNoContent : UILabel!
    @IBOutlet weak var lblNoContentDescription : UILabel!
    
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
        
        lblSharedPostType.text = ""
        lblNoContent.text = CContentIsNotAvailable
        lblNoContentDescription.text = CContentIsNotAvailableDescription
        
        GCDMainThread.async {
            self.viewSubContainer.layer.cornerRadius = 8
            self.viewMainContainer.layer.cornerRadius = 8
            self.viewMainContainer.shadow(color: CRGB(r: 237, g: 236, b: 226), shadowOffset: CGSize(width: 0, height: 5), shadowRadius: 10.0, shadowOpacity: 10.0)
            
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
            // Reverse Flow...
            btnLike.contentHorizontalAlignment = .left
            btnLikesCount.contentHorizontalAlignment = .right
            btnComment.contentHorizontalAlignment = .right
            
        }else{
            // Normal Flow...
            btnLike.contentHorizontalAlignment = .right
            btnLikesCount.contentHorizontalAlignment = .left
            btnComment.contentHorizontalAlignment = .left
            
        }
    }
}

extension PostDeletedDetailCell{
    
    func postDataSetup(_ postInfo : [String : Any]){
        
        switch postInfo.valueForInt(key: CPostType) {
        case CStaticArticleId:
            lblSharedPostType.text = CSharedArticle
            break
        case CStaticGalleryId:
            lblSharedPostType.text = CSharedGallery
            break
        case CStaticChirpyId:
            lblSharedPostType.text = CSharedChirpy
            break
        case CStaticShoutId:
            lblSharedPostType.text = CSharedShout
            break
        case CStaticForumId:
            lblSharedPostType.text = CSharedForum
            break
        case CStaticEventId:
            lblSharedPostType.text = CSharedEvents
            break
        case CStaticPollId:
            lblSharedPostType.text = CSharedPoll
            break
        default :
            lblSharedPostType.text = CSharedPost
            break
        }
        
        postID = postInfo.valueForInt(key: CId) ?? 0
        if let sharedData = postInfo[CSharedPost] as? [String:Any]{
            self.lblSharedUserName.text = sharedData.valueForString(key: CFullName)
            self.lblSharedPostDate.text = DateFormatter.dateStringFrom(timestamp: sharedData.valueForDouble(key: CCreated_at), withFormate: CreatedAtPostDF)
            imgSharedUser.loadImageFromUrl(sharedData.valueForString(key: CUserProfileImage), true)
            lblMessage.text = sharedData.valueForString(key: CMessage)
        }
        
        btnLike.isSelected = postInfo.valueForInt(key: CIs_Like) == 1
        likeCount = postInfo.valueForInt(key: CTotal_like) ?? 0
        
        let commentCount = postInfo.valueForInt(key: CTotalComment) ?? 0
        btnLikesCount.setTitle(appDelegate.getLikeString(like: likeCount), for: .normal)
        btnComment.setTitle(appDelegate.getCommentCountString(comment: commentCount), for: .normal)
    }
    
}

//MARK: - IBAction's
extension PostDeletedDetailCell {
    
    @IBAction func onLikePressed(_ sender:UIButton){
        
        self.btnLike.isSelected = !self.btnLike.isSelected
        self.likeCount = self.btnLike.isSelected ? self.likeCount + 1 : self.likeCount - 1
        self.btnLikesCount.setTitle(appDelegate.getLikeString(like: self.likeCount), for: .normal)
        MIGeneralsAPI.shared().likeUnlikePostWebsite(post_id: self.postID, rss_id: nil, type: 1, likeStatus: self.btnLike.isSelected ? 1 : 0, viewController: self.viewController)
    }
}
