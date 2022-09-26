//
//  HomeSharedArticleImageCell.swift
//  Sevenchats
//
//  Created by CHANDU on 13/06/22.
//  Copyright © 2022 mac-00020. All rights reserved.
//
/*********************************************************
 * Author  : Nagaraju K and Chandrika R                                 *
 * Model   : HomeSharedPollTblCell                       *
 * Changes : HomeShareArticleCell                        *
 *                                                       *
 ********************************************************/

import UIKit
import Lightbox
import SDWebImage

class HomeSharedArticleImageCell: UITableViewCell {

    @IBOutlet weak var viewMainContainer : UIView!
    @IBOutlet weak var viewSubContainer : UIView!
    //@IBOutlet weak var imgArticle : UIImageView!
    @IBOutlet weak var lblArticleTitle : UILabel!
    @IBOutlet weak var lblArticleDescription : UILabel!
    @IBOutlet weak var imgUser : UIImageView!
    @IBOutlet weak var imgUserGIF: FLAnimatedImageView!
    @IBOutlet weak var lblUserName : UILabel!
    @IBOutlet weak var lblArticlePostDate : UILabel!
    @IBOutlet weak var lblArticleType : UILabel!
    @IBOutlet weak var btnLikesCount : UIButton!
    @IBOutlet weak var btnLike : MIGenericButton!
    
    @IBOutlet weak var btnComment : UIButton!
    @IBOutlet weak var btnMore : UIButton!
    @IBOutlet weak var btnProfileImg : UIButton!
    @IBOutlet weak var btnUserName : UIButton!
    @IBOutlet weak var btnShare : UIButton!
    @IBOutlet weak var btnIconShare : UIButton!
    @IBOutlet weak var lblArticleCategory : UILabel!
    
    @IBOutlet weak var blurImgView : BlurImageView!
    @IBOutlet weak var imgSharedView : UIImageView!
    @IBOutlet weak var imgSharedViewGIF: FLAnimatedImageView!
    
    @IBOutlet weak var lblSharedPostDate : UILabel!
    @IBOutlet weak var imgSharedUser : UIImageView!
    @IBOutlet weak var imgSharedUserGIF: FLAnimatedImageView!
    @IBOutlet weak var lblSharedUserName : UILabel!
    @IBOutlet weak var btnSharedProfileImg : UIButton!
    @IBOutlet weak var btnSharedUserName : UIButton!
    @IBOutlet weak var lblMessage : UILabel!
    @IBOutlet weak var lblSharedPostType : UILabel!
    
    var likeCount = 0
    var imgURL = ""
    var postID = 0
    var likeTotalCount = 0
    var like =  0
    var info = [String:Any]()
    var posted_ID = ""
    var profileImg = ""
    var notifcationIsSlected = false
    var isLikesOthers:Bool?
    var isLikeSelected = false
    var isFinalLikeSelected = false
    var isLikesOthersPage:Bool?
    var isLikesHomePage:Bool?
    var isLikesMyprofilePage:Bool?
    var posted_IDOthers = ""
    var notificationInfo = [String:Any]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        lblSharedPostType.text = CSharedArticle
        GCDMainThread.async {
            self.viewSubContainer.layer.cornerRadius = 8
            self.viewMainContainer.layer.cornerRadius = 8
            self.viewMainContainer.shadow(color: CRGB(r: 237, g: 236, b: 226), shadowOffset: CGSize(width: 0, height: 5), shadowRadius: 10.0, shadowOpacity: 10.0)
            self.imgUser.layer.cornerRadius = self.imgUser.frame.size.width/2
            self.imgUser.layer.borderWidth = 2
            self.imgUser.layer.borderColor = #colorLiteral(red: 0, green: 0.7881455421, blue: 0.7100172639, alpha: 1)
            self.lblArticleType.layer.cornerRadius = 3
            self.btnComment.isUserInteractionEnabled = false
            self.imgSharedUser.layer.cornerRadius = self.imgSharedUser.frame.size.width/2
            self.imgSharedUser.layer.borderWidth = 2
            self.imgSharedUser.layer.borderColor = #colorLiteral(red: 0, green: 0.7881455421, blue: 0.7100172639, alpha: 1)
            self.lblArticleDescription.adjustsFontSizeToFitWidth = true
//            self.lblMessage.adjustsFontSizeToFitWidth = true
            
            self.imgUserGIF.layer.cornerRadius = self.imgUserGIF.frame.size.width/2
            // self.btnShare.layer.cornerRadius = 5
            self.imgUserGIF.layer.borderWidth = 3
            self.imgUserGIF.layer.borderColor = #colorLiteral(red: 0, green: 0.7881455421, blue: 0.7100172639, alpha: 1)
            
            self.imgSharedUserGIF.layer.cornerRadius = self.imgSharedUserGIF.frame.size.width/2
            // self.btnShare.layer.cornerRadius = 5
            self.imgSharedUserGIF.layer.borderWidth = 3
            self.imgSharedUserGIF.layer.borderColor = #colorLiteral(red: 0, green: 0.7881455421, blue: 0.7100172639, alpha: 1)
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
            //btnShare.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        }
    }
}

// MARK:- ---------- Data Setup
extension HomeSharedArticleImageCell{
    
    func homeArticleDataSetup(_ postInfo : [String : Any]){
        
        postID = postInfo.valueForString(key: "post_id").toInt ?? 0
        notificationInfo = postInfo
        
        if isLikesOthersPage == true {
            posted_ID = self.posted_IDOthers
        }else {
            posted_ID = postInfo.valueForString(key: "user_id")
        }
        
       self.lblSharedUserName.text = postInfo.valueForString(key: CFullName) + " " + postInfo.valueForString(key: CLastName)
        let shared_created_at = postInfo.valueForString(key: CShared_Created_at)
        let shared_cnvStr = shared_created_at.stringBefore("G")
        let shared_Date = DateFormatter.shared().convertDatereversLatest(strDate: shared_cnvStr)
        lblSharedPostDate.text = shared_Date
         //   imgSharedUser.loadImageFromUrl(postInfo.valueForString(key: CUserSharedProfileImage), true)
        
        let imgExtShare = URL(fileURLWithPath:postInfo.valueForString(key: CUserSharedProfileImage)).pathExtension
        if imgExtShare == "gif"{
                    print("-----ImgExt\(imgExtShare)")
                    
            imgSharedUser.isHidden  = true
                    self.imgSharedUserGIF.isHidden = false
                    self.imgSharedUserGIF.sd_setImage(with: URL(string:postInfo.valueForString(key: CUserSharedProfileImage)), completed: nil)
                    self.imgSharedUserGIF.sd_cacheFLAnimatedImage = false
                    
                }else {
                    self.imgSharedUserGIF.isHidden = true
                    imgSharedUser.isHidden  = false
                    imgSharedUser.loadImageFromUrl(postInfo.valueForString(key: CUserSharedProfileImage), true)
                    _ = appDelegate.loginUser?.total_friends ?? 0
                }
        
        
        let str_Back_desc_share = postInfo.valueForString(key: CMessage).return_replaceBack(replaceBack: postInfo.valueForString(key: CMessage))
        lblMessage.text = str_Back_desc_share
            //lblMessage.text = postInfo.valueForString(key: CMessage)
        self.lblUserName.text = postInfo.valueForString(key: CFirstname) + " " + postInfo.valueForString(key: CLastname)
        let created_at = postInfo.valueForString(key: CCreated_at)
        let cnvStr = created_at.stringBefore("G")
        let Created_Date = DateFormatter.shared().convertDatereversLatest(strDate: cnvStr)
        lblArticlePostDate.text = Created_Date
        let image = postInfo.valueForString(key: "image")
       // blurImgView.loadImageFromUrl(postInfo.valueForString(key: "image"), false)
        
        let imgExtView = URL(fileURLWithPath:postInfo.valueForString(key: "image")).pathExtension
        
        
        if imgExtView == "gif"{
                    print("-----ImgExt\(imgExtView)")
                    
            imgSharedView.isHidden  = true
                    self.imgSharedViewGIF.isHidden = false
                    self.imgSharedViewGIF.sd_setImage(with: URL(string:postInfo.valueForString(key: "image")), completed: nil)
            self.imgSharedViewGIF.sd_cacheFLAnimatedImage = false
                    
                }else {
                    self.imgSharedViewGIF.isHidden = true
                    imgSharedView.isHidden  = false
                    imgSharedView.loadImageFromUrl(postInfo.valueForString(key: "image"), false)

                    _ = appDelegate.loginUser?.total_friends ?? 0
                }
        
        
        
//        imgSharedView.loadImageFromUrl(postInfo.valueForString(key: "image"), false)
        
        
//        if image.isEmpty {
//            blurImgView.heightAnchor.constraint(equalToConstant: CGFloat(0)).isActive = true
//        }else{
//            blurImgView.loadImageFromUrl(postInfo.valueForString(key: "image"), false)
//        }
        imgURL = postInfo.valueForString(key: CImage)
        
        let imgExt = URL(fileURLWithPath:postInfo.valueForString(key: CUserProfileImage)).pathExtension
        
        
        if imgExt == "gif"{
                    print("-----ImgExt\(imgExt)")
                    
            imgUser.isHidden  = true
                    self.imgUserGIF.isHidden = false
                    self.imgUserGIF.sd_setImage(with: URL(string:postInfo.valueForString(key: CUserProfileImage)), completed: nil)
            self.imgUserGIF.sd_cacheFLAnimatedImage = false
                    
                }else {
                    self.imgUserGIF.isHidden = true
                    imgUser.isHidden  = false
                    imgUser.loadImageFromUrl(postInfo.valueForString(key: CUserProfileImage), true)
                    _ = appDelegate.loginUser?.total_friends ?? 0
                }
        
        
       // imgUser.loadImageFromUrl(postInfo.valueForString(key: CUserProfileImage), true)
        
        
        
        let str_Back_title = postInfo.valueForString(key: CTitle).return_replaceBack(replaceBack: postInfo.valueForString(key: CTitle))
        self.lblArticleTitle.text = str_Back_title
        
         let str_Back_desc = postInfo.valueForString(key: CContent).return_replaceBack(replaceBack: postInfo.valueForString(key: CContent))
        self.lblArticleDescription.text  = str_Back_desc
//        lblArticleTitle.text = postInfo.valueForString(key: CTitle)
//        lblArticleDescription.text = postInfo.valueForString(key: CContent)
        
        lblArticleType.text = CTypeArticle
        self.lblArticleCategory.text = postInfo.valueForString(key: CCategory).uppercased()
        
        
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
        
        
        likeCount = postInfo.valueForString(key: CLikes).toInt ?? 0
        btnLikesCount.setTitle(appDelegate.getLikeString(like: likeCount), for: .normal)
        
//        btnLike.isSelected = postInfo.valueForInt(key: CIs_Like) == 1
//        likeCount = postInfo.valueForInt(key: CTotal_like) ?? 0
//        btnLikesCount.setTitle(appDelegate.getLikeString(like: likeCount), for: .normal)
        
        
        
        
        
//        let commentCount = postInfo.valueForInt(key: CTotalComment) ?? 0
        let commentCount = postInfo.valueForString(key: "comments").toInt ?? 0
        btnComment.setTitle(appDelegate.getCommentCountString(comment: commentCount), for: .normal)
        self.btnShare.isHidden = true
        btnShare.setTitle(CBtnShare, for: .normal)
    }
}

//MARK: - IBAction's
extension HomeSharedArticleImageCell{
    
    @IBAction func onImageTapped(_ sender:UIButton){
        let lightBoxHelper = LightBoxControllerHelper()
        weak var weakSelf = self.viewController
        //lightBoxHelper.openSingleImage(image: blurImgView.image, viewController: weakSelf)
        lightBoxHelper.openSingleImage(image: imgSharedView.image, viewController: weakSelf)
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
                        MIGeneralsAPI.shared().sendNotification(self?.posted_ID, userID: user_ID, subject: "liked your Post", MsgType: "COMMENT", MsgSent: "", showDisplayContent: "liked your Post", senderName: firstName + lastName, post_ID: self?.notificationInfo ?? [:],shareLink: "shareLikes")
                        
                        if let metaInfo = response![CJsonMeta] as? [String : Any] {
                            let stausLike = metaInfo["status"] as? String ?? "0"
                            if stausLike == "0" {
                            }
                        }
                      }
                        self?.notifcationIsSlected = false
                    }
                    
//                    MIGeneralsAPI.shared().likeUnlikePostWebsites(post_id: Int(self?.postID ?? 0), rss_id: 0, type: 1, likeStatus: self?.like ?? 0 ,info:postInfo, viewController: self?.viewController)
                    
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
}
