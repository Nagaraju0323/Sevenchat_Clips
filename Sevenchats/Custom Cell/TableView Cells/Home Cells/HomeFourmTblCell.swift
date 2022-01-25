//
//  HomeFourmTblCell.swift
//  Sevenchats
//
//  Created by mac-0005 on 14/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Chandrika.R                                 *
 * Model   : HomeFourmTblCell                            *
 * Changes :                                             *
 *                                                       *
 ********************************************************/

import UIKit

class HomeFourmTblCell: UITableViewCell {
    
    @IBOutlet weak var viewMainContainer : UIView!
    @IBOutlet weak var viewSubContainer : UIView!
    @IBOutlet weak var lblFourmDescription : UILabel!
    @IBOutlet weak var lblFourmTitle : UILabel!
    @IBOutlet weak var imgUser : UIImageView!
    @IBOutlet weak var lblUserName : UILabel!
    @IBOutlet weak var lblFourmPostDate : UILabel!
    @IBOutlet weak var lblFourmType : UILabel!
    @IBOutlet weak var lblFourmCategory : UILabel!
    @IBOutlet weak var btnLikesCount : UIButton!
    @IBOutlet weak var btnLike : UIButton!
    @IBOutlet weak var btnComment : UIButton!
    @IBOutlet weak var btnShare : UIButton!
    @IBOutlet weak var btnIconShare : UIButton!
    @IBOutlet weak var btnMore : UIButton!
    @IBOutlet weak var btnProfileImg : UIButton!
    @IBOutlet weak var btnUserName : UIButton!
    
    var likeCount = 0
    var postID = 0
    var likeTotalCount = 0
    var like = 0
    var info = [String:Any]()
    var posted_ID = ""
    var profileImg = ""
    var notifcationIsSlected = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        GCDMainThread.async {
            self.viewSubContainer.layer.cornerRadius = 8
            self.viewMainContainer.layer.cornerRadius = 8
            self.viewMainContainer.shadow(color: CRGB(r: 237, g: 236, b: 226), shadowOffset: CGSize(width: 0, height: 5), shadowRadius: 10.0, shadowOpacity: 10.0)
            
            self.imgUser.layer.cornerRadius = self.imgUser.frame.size.width/2
            self.lblFourmType.layer.cornerRadius = 3
            self.btnComment.isUserInteractionEnabled = false
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
            btnShare.contentHorizontalAlignment = .right
            
        }else{
            // Normal Flow...
            btnLike.contentHorizontalAlignment = .right
            btnLikesCount.contentHorizontalAlignment = .left
            btnComment.contentHorizontalAlignment = .left
            btnShare.contentHorizontalAlignment = .left
            
        }
    }
}

extension HomeFourmTblCell{
    
    func homeFourmDataSetup(_ postInfo : [String : Any]){
        
        postID = postInfo.valueForString(key: "post_id").toInt ?? 0
        posted_ID = postInfo.valueForString(key: "user_id")
        lblFourmType.text = CTypeForum
        
        self.lblUserName.text = postInfo.valueForString(key: CFirstname) + " " + postInfo.valueForString(key: CLastname)
        lblFourmTitle.text = postInfo.valueForString(key: CTitle)
        lblFourmDescription.text = postInfo.valueForString(key: CContent)
        imgUser.loadImageFromUrl(postInfo.valueForString(key: CUserProfileImage), true)
        self.lblFourmCategory.text = postInfo.valueForString(key: CCategory).uppercased()
        let commentCount = postInfo.valueForString(key: "comments").toInt
        btnComment.setTitle(appDelegate.getCommentCountString(comment: commentCount ?? 0), for: .normal)
        btnShare.setTitle(CBtnShare, for: .normal)
        
        if postInfo.valueForString(key:CIs_Liked) == "Yes"{
            btnLike.isSelected = true
        }else {
            btnLike.isSelected = false
        }
        
        likeCount = postInfo.valueForString(key: CLikes).toInt ?? 0
        btnLikesCount.setTitle(appDelegate.getLikeString(like: likeCount), for: .normal)
        
        let created_At = postInfo.valueForString(key: CCreated_at)
        let cnvStr = created_At.stringBefore("G")
        let startCreated = DateFormatter.shared().convertDatereversLatest(strDate: cnvStr)
        lblFourmPostDate.text = startCreated
    }
}

//MARK: - IBAction's
extension HomeFourmTblCell {
    
    @IBAction func onLikePressed(_ sender:UIButton){
        
        self.btnLike.isSelected = !self.btnLike.isSelected
        
        if self.btnLike.isSelected == true{
            likeCount = 1
            like = 1
            notifcationIsSlected = true
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
                    guard let user_ID = appDelegate.loginUser?.user_id.description else { return }
                    guard let firstName = appDelegate.loginUser?.first_name else {return}
                    guard let lastName = appDelegate.loginUser?.last_name else {return}
                    
                    if self?.notifcationIsSlected == true{
                        MIGeneralsAPI.shared().sendNotification(self?.posted_ID, userID: user_ID, subject: "liked your Post", MsgType: "COMMENT", MsgSent: "", showDisplayContent: "liked your Post", senderName: firstName + lastName)
                        if let metaInfo = response![CJsonMeta] as? [String : Any] {
                            let name = (appDelegate.loginUser?.first_name ?? "") + " " + (appDelegate.loginUser?.last_name ?? "")
                            guard let image = appDelegate.loginUser?.profile_img else { return }
                            let stausLike = metaInfo["status"] as? String ?? "0"
                            if stausLike == "0" {
                                
                                MIGeneralsAPI.shared().addRewardsPoints(CPostlike,message:"post_point",type:CPostlike,title:"post Like",name:name,icon:image)
                            }
                        }
                        self?.notifcationIsSlected = false
                    }
                    MIGeneralsAPI.shared().likeUnlikePostWebsites(post_id: Int(self?.postID ?? 0), rss_id: 0, type: 1, likeStatus: self?.like ?? 0 ,info:postInfo, viewController: self?.viewController)
                }
            }
            
        }
    }
}

