//
//  HomeChirpyImageTblCell.swift
//  Sevenchats
//
//  Created by mac-0005 on 14/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit
import Lightbox

class HomeChirpyImageTblCell: UITableViewCell {

    @IBOutlet weak var viewMainContainer : UIView!
    @IBOutlet weak var viewSubContainer : UIView!
    //@IBOutlet weak var imgChirpy : UIImageView!
    @IBOutlet weak var blurImgView : BlurImageView!
    @IBOutlet weak var lblChirpyDescription : UILabel!
    @IBOutlet weak var imgUser : UIImageView!
    @IBOutlet weak var lblUserName : UILabel!
    @IBOutlet weak var lblChirpyPostDate : UILabel!
    @IBOutlet weak var lblChirpyCategory : UILabel!
    
    @IBOutlet weak var lblChirpyType : UILabel!
    @IBOutlet weak var btnLikesCount : UIButton!
    @IBOutlet weak var btnLike : UIButton!
    @IBOutlet weak var btnComment : UIButton!
    //@IBOutlet weak var btnReport : UIButton!
    @IBOutlet weak var btnShare : UIButton!
    @IBOutlet weak var btnIconShare : UIButton!
    @IBOutlet weak var btnMore : UIButton!
    @IBOutlet weak var btnProfileImg : UIButton!
    @IBOutlet weak var btnUserName : UIButton!
    var likeCount = 0
    var chirpyImgURL = ""
    var reloadForImageDownload : (() -> Void)?
    var postID = 0
    var likeTotalCount = 0
    var like =  0
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
            self.lblChirpyType.layer.cornerRadius = 3
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

extension HomeChirpyImageTblCell{
    
    func homeChirpyImageDataSetup(_ postInfo : [String : Any]){
        
//        postID = postInfo.valueForInt(key: CId) ?? 0
        postID = postInfo.valueForString(key: "post_id").toInt ?? 0
        posted_ID = postInfo.valueForString(key: "user_id")
        
        self.lblUserName.text = postInfo.valueForString(key: CFirstname) + " " + postInfo.valueForString(key: CLastname)
        //"\(CPostedOn) " + DateFormatte
        self.lblChirpyPostDate.text = DateFormatter.dateStringFrom(timestamp: postInfo.valueForDouble(key: CCreated_at), withFormate: CreatedAtPostDF)
        lblChirpyDescription.text = postInfo.valueForString(key: CContent)
        
        //imgChirpy.loadImageFromUrl(postInfo.valueForString(key: CImage), false)
       // blurImgView.loadImageFromUrl(postInfo.valueForString(key: Cimages), false)
        
        
        let image = postInfo.valueForString(key: Cimages)
        if image.isEmpty {
        //                    blurImgView.isHidden = true
            blurImgView.heightAnchor.constraint(equalToConstant: CGFloat(0)).isActive = true
        }else{
            blurImgView.loadImageFromUrl(postInfo.valueForString(key: Cimages), false)
        }
        
        
        /*imgChirpy.loadImageFromUrlWithCompletion(postInfo.valueForString(key: CImage), false) { [weak self](img) in
            guard let _ = self else { return }
            if let _img = img{
                self?.imgChirpy.image = _img
                self?.reloadForImageDownload?()
            }
        }*/
        
        chirpyImgURL = postInfo.valueForString(key: CImage)
        imgUser.loadImageFromUrl(postInfo.valueForString(key: CUserProfileImage), true)
        lblChirpyType.text = CTypeChirpy
        lblChirpyCategory.text = postInfo.valueForString(key: CCategory).uppercased()
        
//        btnLike.isSelected = postInfo.valueForInt(key: CIs_Like) == 1
//        likeCount = postInfo.valueForInt(key: CTotal_like) ?? 0
//        btnLikesCount.setTitle(appDelegate.getLikeString(like: likeCount), for: .normal)
        
        let commentCount = postInfo.valueForString(key: "comments").toInt ?? 0
//        let commentCount = postInfo.valueForInt(key: CTotalComment) ?? 0
        btnComment.setTitle(appDelegate.getCommentCountString(comment: commentCount), for: .normal)
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
//        let removeFrst = cnvStr.chopPrefix(3)
        let startCreated = DateFormatter.shared().convertDatereversLatest(strDate: cnvStr)
        lblChirpyPostDate.text = startCreated
        
        
    }
    
}

//MARK: - IBAction's
extension HomeChirpyImageTblCell{
    
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
        }else {
            likeCount = 2
            like = 0
           
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
//                        self?.likeCountfromSever(productId: Int((self?.self.postID)!))
                        self?.likeCountfromSever(productId: Int((self?.self.postID)!),likeCount:self?.likeCount ?? 0, postInfo: self?.info ?? [:],like:self?.like ?? 0)
                    }
                }
            }
        }
    }
    
//    func likeCountfromSever(productId: Int){
//        APIRequest.shared().likeUnlikeProductCount(productId: Int(self.postID) ){ [weak self](response, error) in
//            guard let _ = self else { return }
//            if response != nil {
//                GCDMainThread.async { [self] in
//                    self?.likeTotalCount = response?["likes_count"] as? Int ?? 0
//                    self?.btnLikesCount.setTitle(appDelegate.getLikeString(like: self?.likeTotalCount ?? 0), for: .normal)
//                }
//            }
//        }
//    }
    
    func likeCountfromSever(productId: Int,likeCount:Int,postInfo:[String:Any],like:Int){
        APIRequest.shared().likeUnlikeProductCount(productId: Int(self.postID) ){ [weak self](response, error) in
            guard let _ = self else { return }
            if response != nil {
                GCDMainThread.async { [self] in
//                    info = response!["liked_users"] as? [String:Any] ?? [:]
                    self?.likeTotalCount = response?["likes_count"] as? Int ?? 0
                    self?.btnLikesCount.setTitle(appDelegate.getLikeString(like: self?.likeTotalCount ?? 0), for: .normal)
                    
                    guard let user_ID = appDelegate.loginUser?.user_id.description else { return }
                    guard let firstName = appDelegate.loginUser?.first_name else {return}
                    guard let lassName = appDelegate.loginUser?.last_name else {return}
                    
                    if self?.notifcationIsSlected == true{
                        MIGeneralsAPI.shared().sendNotification(self?.posted_ID, userID: user_ID, subject: "liked your Post Chiripy", MsgType: "COMMENT", MsgSent: "", showDisplayContent: "liked your Post Chiripy", senderName: firstName + lassName)
                        
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
