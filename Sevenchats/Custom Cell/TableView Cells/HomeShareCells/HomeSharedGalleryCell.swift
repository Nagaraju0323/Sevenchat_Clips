//
//  HomeGalleryCell.swift
//  Sevenchats
//
//  Created by mac-0005 on 10/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//
/*********************************************************
 * Author  : Nagaraju K and Chandrika R                                 *
 * Model   : HomeGalleryCell                             *
 * Changes : HomeGalleryCell                             *
 *                                                       *
 ********************************************************/

import UIKit
import AVKit
import AVFoundation
import SDWebImage

class HomeSharedGalleryCell: UITableViewCell {

    @IBOutlet weak var viewMainContainer : UIView!
    @IBOutlet weak var viewSubContainer : UIView!
    @IBOutlet weak var imgUser : UIImageView!
    @IBOutlet weak var imgUserGIF : FLAnimatedImageView!
    @IBOutlet weak var lblGalleryType : UILabel!
    @IBOutlet weak var lblUserName : UILabel!
    @IBOutlet weak var lblGalleryCategory : UILabel!
    @IBOutlet weak var lblGalleryPostDate : UILabel!
    
    @IBOutlet weak var vwCountImage : UIView!
    @IBOutlet weak var lblCountImage : UILabel!
    
    @IBOutlet weak var clGallery : UICollectionView!
    
    //@IBOutlet weak var btnImageScrollBack : UIButton!
    //@IBOutlet weak var btnImageScrollNext : UIButton!
    
    @IBOutlet weak var btnLikesCount : UIButton!
    @IBOutlet weak var btnLike : UIButton!
    @IBOutlet weak var btnComment : UIButton!
    //@IBOutlet weak var btnReport : UIButton!
    @IBOutlet weak var btnShare : UIButton!
    @IBOutlet weak var btnIconShare : UIButton!
    @IBOutlet weak var btnMore : UIButton!
    @IBOutlet weak var btnProfileImg : UIButton!
    @IBOutlet weak var btnUserName : UIButton!
    
    @IBOutlet weak var lblSharedPostDate : UILabel!
    @IBOutlet weak var imgSharedUser : UIImageView!
    @IBOutlet weak var imgSharedUserGIF : FLAnimatedImageView!
    @IBOutlet weak var lblSharedUserName : UILabel!
    @IBOutlet weak var btnSharedProfileImg : UIButton!
    @IBOutlet weak var btnSharedUserName : UIButton!
    @IBOutlet weak var lblMessage : UILabel!
    @IBOutlet weak var lblSharedPostType : UILabel!
    @IBOutlet var pageControl: UIPageControl!
    
    var arrGalleryImage :[[String : Any]] = []
    
    var didSelectGalleryCell : (() -> Void)?
    
    var imageIndex:Int = 0
    var postID = 0
    var likeCount = 0
    var likeTotalCount = 0
    var like =  0
    var info = [String:Any]()
    var posted_ID = ""
    var notifcationIsSlected = false
    var isLikesOthers:Bool?
    var isLikeSelected = false
    var isFinalLikeSelected = false
    var isLikesOthersPage:Bool?
    var isLikesHomePage:Bool?
    var isLikesMyprofilePage:Bool?
    var posted_IDOthers = ""
    var notificationInfo = [String:Any]()
    var counter = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        lblSharedPostType.text = CSharedGallery
        GCDMainThread.async {
            self.viewSubContainer.layer.cornerRadius = 8
            self.viewMainContainer.layer.cornerRadius = 8
            self.viewMainContainer.shadow(color: CRGB(r: 237, g: 236, b: 226), shadowOffset: CGSize(width: 0, height: 5), shadowRadius: 10.0, shadowOpacity: 10.0)
            //self.btnImageScrollNext.shadow(color: CRGB(r: 0, g: 0, b: 0), shadowOffset: CGSize(width: 5, height: 5), shadowRadius: 10.0, shadowOpacity: 10.0)
            //self.btnImageScrollBack.shadow(color: CRGB(r: 0, g: 0, b: 0), shadowOffset: CGSize(width: 5, height: 5), shadowRadius: 10.0, shadowOpacity: 10.0)
            self.imgUser.layer.cornerRadius = self.imgUser.frame.size.width/2
            self.imgUser.layer.borderWidth = 2
            self.imgUser.layer.borderColor = #colorLiteral(red: 0, green: 0.7881455421, blue: 0.7100172639, alpha: 1)
            self.imgSharedUser.layer.cornerRadius = self.imgSharedUser.frame.size.width/2
            self.imgSharedUser.layer.borderWidth = 2
            self.imgSharedUser.layer.borderColor = #colorLiteral(red: 0, green: 0.7881455421, blue: 0.7100172639, alpha: 1)
            self.lblGalleryType.layer.cornerRadius = 3
            self.btnComment.isUserInteractionEnabled = false
            self.vwCountImage.layer.cornerRadius = 4
            self.vwCountImage.isHidden = true
            self.lblMessage.adjustsFontSizeToFitWidth = true
           
            self.imgUserGIF.layer.cornerRadius = self.imgUserGIF.frame.size.width / 2
            self.imgUserGIF.layer.borderWidth = 2
            self.imgUserGIF.layer.borderColor = #colorLiteral(red: 0, green: 0.7881455421, blue: 0.7100172639, alpha: 1)
            
            self.imgSharedUserGIF.layer.cornerRadius = self.imgSharedUserGIF.frame.size.width / 2
            self.imgSharedUserGIF.layer.borderWidth = 2
            self.imgSharedUserGIF.layer.borderColor = #colorLiteral(red: 0, green: 0.7881455421, blue: 0.7100172639, alpha: 1)


            
        }
        
        clGallery.register(UINib(nibName: "HomeEventGalleryCell", bundle: nil), forCellWithReuseIdentifier: "HomeEventGalleryCell")
      //  clGallery.isPagingEnabled = true
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
            //btnImageScrollNext.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            //btnImageScrollBack.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            clGallery.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        }else{
            // Normal Flow...
            btnLike.contentHorizontalAlignment = .right
            btnLikesCount.contentHorizontalAlignment = .left
            btnComment.contentHorizontalAlignment = .left
            //btnComment.titleEdgeInsets = UIEdgeInsets(top: 0, left: 7, bottom: 0, right: 0)
            btnShare.contentHorizontalAlignment = .left
            //btnShare.titleEdgeInsets = UIEdgeInsets(top: 0, left: 7, bottom: 0, right: 0)
            //btnImageScrollNext.transform = CGAffineTransform.identity
            //btnImageScrollBack.transform = CGAffineTransform.identity
            clGallery.transform = CGAffineTransform.identity
        }
    }
}

// MARK:- ---------- Data Setup
extension HomeSharedGalleryCell {
    func homeGalleryDataSetup(_ postInfo : [String : Any]) {
        
        postID = postInfo.valueForString(key: "post_id").toInt ?? 0
        
        notificationInfo = postInfo
        
        if isLikesOthersPage == true {
            posted_ID = self.posted_IDOthers
        }else {
            posted_ID = postInfo.valueForString(key: "user_id")
        }
        
      //  if let sharedData = postInfo[CSharedPost] as? [String:Any]{
            self.lblSharedUserName.text = postInfo.valueForString(key: CFullName) + " "  + postInfo.valueForString(key: CLastName)
        let shared_created_at = postInfo.valueForString(key: CShared_Created_at)
                let shared_cnvStr = shared_created_at.stringBefore("G")
                let shared_Date = DateFormatter.shared().convertDatereversLatest(strDate: shared_cnvStr)
                lblSharedPostDate.text = shared_Date
           // self.lblSharedPostDate.text = DateFormatter.dateStringFrom(timestamp: postInfo.valueForDouble(key: CCreated_at), withFormate: CreatedAtPostDF)
            //imgSharedUser.loadImageFromUrl(postInfo.valueForString(key: CUserSharedProfileImage), true)
        
        let imgExtShared = URL(fileURLWithPath:postInfo.valueForString(key: CUserSharedProfileImage)).pathExtension
        
        if imgExtShared == "gif"{
                    print("-----ImgExt\(imgExtShared)")
                    
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
        
        
        
        let str_Back_desc = postInfo.valueForString(key: CMessage).return_replaceBack(replaceBack: postInfo.valueForString(key: CMessage))
        lblMessage.text = str_Back_desc
          //  lblMessage.text = postInfo.valueForString(key: CMessage)
       // }
        
        if let arrImg = postInfo["image"] as? String {
            let dict = arrImg.convertToDictionary()
            let arrDictGallery = dict ?? []
            arrGalleryImage = arrDictGallery
            pageControl.numberOfPages = arrGalleryImage.count
            clGallery.reloadData()
            setCurrentImageCount()
        }
       // self.vwCountImage.isHidden = (arrGalleryImage.count <= 1)
        
        self.lblUserName.text = postInfo.valueForString(key: CFirstname) + " " + postInfo.valueForString(key: CLastname)
        //"\(CPostedOn) " + DateFormatte
        let created_at = postInfo.valueForString(key: CCreated_at)
                let cnvStr = created_at.stringBefore("G")
                let Created_Date = DateFormatter.shared().convertDatereversLatest(strDate: cnvStr)
        lblGalleryPostDate.text = Created_Date
       // self.lblGalleryPostDate.text = DateFormatter.dateStringFrom(timestamp: postInfo.valueForDouble(key: CCreated_at), withFormate: CreatedAtPostDF)
//        imgUser.loadImageFromUrl(postInfo.valueForString(key: CUserProfileImage), true)
        
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
        
        lblGalleryType.text = CTypeGallery
        if postInfo.valueForString(key: CCategory) == "0"{
            self.lblGalleryCategory.text = ""
        }else{
            self.lblGalleryCategory.text = postInfo.valueForString(key: CCategory).uppercased()
        }


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
        let commentCount = postInfo.valueForString(key: "comments").toInt ?? 0
//        let commentCount = postInfo.valueForInt(key: CTotalComment) ?? 0
        btnComment.setTitle(appDelegate.getCommentCountString(comment: commentCount), for: .normal)
        self.btnShare.isHidden = true
        btnShare.setTitle(CBtnShare, for: .normal)
    }
}

// MARK:- --------- UICollectionView Delegate/Datasources
extension HomeSharedGalleryCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pageControl.isHidden = !(arrGalleryImage.count > 1)
        return arrGalleryImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if arrGalleryImage.count > 1{
            var width = clGallery.frame.size.width
            width = width - ((width * 30) / 100)
            clGallery.reloadData()
            return CGSize(width:clGallery.frame.size.width, height: clGallery.bounds.height)
        }
        return CGSize(width:clGallery.frame.size.width, height: clGallery.frame.height)
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeEventGalleryCell", for: indexPath) as! HomeEventGalleryCell
        cell.vwBackgroundImg.backgroundColor = UIColor(hex: "DEDDE5")
        let imageInfo = arrGalleryImage[indexPath.row]
        let mediaType = imageInfo.valueForString(key: "mime")
        if (mediaType == "video") || (mediaType == "vidoe"){
            if let url = URL(string: imageInfo.valueForString(key: "image_path")) {
                if let thumbnailImage = getThumbnailImage(forUrl: url) {
                    cell.ImgView.image = thumbnailImage
                }
            }
            cell.imgVideoIcon.isHidden =  false
        }else{
            print(" imageInfo.valueForString(key: CImage)  \(imageInfo.valueForString(key: "image_path"))")
            //cell.blurImgView.loadImageFromUrl(imageInfo.valueForString(key: "image_path"), false)
//            cell.ImgView.loadImageFromUrl(imageInfo.valueForString(key: "image_path"), false)
            
            let imgExtView = URL(fileURLWithPath:imageInfo.valueForString(key: "image_path")).pathExtension
            
            
            if imgExtView == "gif"{
                        print("-----ImgExt\(imgExtView)")
                        
                cell.ImgView.isHidden  = true
                cell.ImgViewGIF.isHidden = false
                cell.ImgViewGIF.sd_setImage(with: URL(string:imageInfo.valueForString(key: "image_path")), completed: nil)
                cell.ImgViewGIF.sd_cacheFLAnimatedImage = false
                        
                    }else {
                        cell.ImgViewGIF.isHidden = true
                        cell.ImgView.isHidden  = false
                        cell.ImgView.loadImageFromUrl(imageInfo.valueForString(key: "image_path"), false)

                        _ = appDelegate.loginUser?.total_friends ?? 0
                    }
            
            
            cell.imgVideoIcon.isHidden =  true
            pagecontroll()
        }
//        let mediaType = imageInfo.valueForInt(key: CType) ?? 1
//        if (mediaType == 2){
//            //cell.imgGalleryEvent.loadImageFromUrl(imageInfo.valueForString(key: CThumbNail), false)
//            cell.blurImgView.loadImageFromUrl(imageInfo.valueForString(key: CThumbNail), false)
//            cell.imgVideoIcon.isHidden =  false
//        }else{
//            //cell.imgGalleryEvent.loadImageFromUrl(imageInfo.valueForString(key: CImage), false)
//            cell.blurImgView.loadImageFromUrl(imageInfo.valueForString(key: CImage), false)
//            cell.imgVideoIcon.isHidden =  true
//        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let lightBoxHelper = LightBoxControllerHelper()
        weak var weakSelf = self.viewController
        lightBoxHelper.openMultipleImagesWithVideos(arrGalleryImage: arrGalleryImage, controller: weakSelf,selectedIndex: indexPath.row)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 6
//    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        setCurrentImageCount()
    }
    
    func setCurrentImageCount(){
        var visibleRect = CGRect()
        visibleRect.origin = self.clGallery.contentOffset
        visibleRect.size = self.clGallery.bounds.size
        let visiblePoint = CGPoint(x: CGFloat(visibleRect.midX), y: CGFloat(visibleRect.midY))
        if let indexPath: IndexPath = self.clGallery.indexPathForItem(at: visiblePoint){
            let index = indexPath.row + 1
            counter = Int(indexPath.row)
//            self.lblCountImage.text =  "\(index)" + " / " + "\(self.arrGalleryImage.count)"
        }
    }
    func pagecontroll() {
        if counter == (arrGalleryImage.count - 1) {
            print("over")
            counter = 0
            let index = IndexPath.init(item: counter, section: 0)
            self.clGallery?.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
            self.pageControl?.currentPage = counter
            
            counter = 1
        }else{
            print("cont")
        }
        
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        pageControl?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {

        pageControl?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
}

//MARK: - IBAction's
extension HomeSharedGalleryCell {
    
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
extension HomeSharedGalleryCell{
    func getThumbnailImage(forUrl url: URL) -> UIImage? {
        let asset: AVAsset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        
        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60), actualTime: nil)
            return UIImage(cgImage: thumbnailImage)
        } catch let error {
            print(error)
        }
        return nil
    }
    
}
