//
//  HomeGalleryCell.swift
//  Sevenchats
//
//  Created by mac-0005 on 10/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class HomeGalleryCell: UITableViewCell {

    @IBOutlet weak var viewMainContainer : UIView!
    @IBOutlet weak var viewSubContainer : UIView!
    @IBOutlet weak var imgUser : UIImageView!
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
    
    var arrGalleryImage :[[String : Any]] = []
    
    var didSelectGalleryCell : (() -> Void)?
    
    var imageIndex:Int = 0
    var postID = 0
    var likeCount = 0
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
            //self.btnImageScrollNext.shadow(color: CRGB(r: 0, g: 0, b: 0), shadowOffset: CGSize(width: 5, height: 5), shadowRadius: 10.0, shadowOpacity: 10.0)
            //self.btnImageScrollBack.shadow(color: CRGB(r: 0, g: 0, b: 0), shadowOffset: CGSize(width: 5, height: 5), shadowRadius: 10.0, shadowOpacity: 10.0)
            self.imgUser.layer.cornerRadius = self.imgUser.frame.size.width/2
            self.lblGalleryType.layer.cornerRadius = 3
            self.btnComment.isUserInteractionEnabled = false
            
            self.vwCountImage.layer.cornerRadius = 4
        }
        let layout = RTLCollectionFlow()
        layout.scrollDirection = .horizontal
        clGallery.collectionViewLayout = layout
        clGallery.register(UINib(nibName: "HomeEventGalleryCell", bundle: nil), forCellWithReuseIdentifier: "HomeEventGalleryCell")
        clGallery.isPagingEnabled = false
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
            //clGallery.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            
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
extension HomeGalleryCell {
    func homeGalleryDataSetup(_ postInfo : [String : Any]) {
        
//        postID = postInfo.valueForInt(key: CId) ?? 0
        
        postID = postInfo.valueForString(key: "post_id").toInt ?? 0
        posted_ID = postInfo.valueForString(key: "user_id")
//        if let arrImg = postInfo[CGalleryImages] as? [[String : Any]] {
//            arrGalleryImage = arrImg
//            clGallery.reloadData()
//            setCurrentImageCount()
//        }
        
        if let arrImg = postInfo["image"] as? String {
            let dict = arrImg.convertToDictionary()
            let arrDictGallery = dict ?? []
            arrGalleryImage = arrDictGallery
            clGallery.reloadData()
            setCurrentImageCount()
        }
        
        
        self.vwCountImage.isHidden = (arrGalleryImage.count <= 1)
        
        self.lblUserName.text = postInfo.valueForString(key: CFirstname) + " " + postInfo.valueForString(key: CLastname)
        //"\(CPostedOn) " + DateFormatte
//        self.lblGalleryPostDate.text = DateFormatter.dateStringFrom(timestamp: postInfo.valueForDouble(key: CCreated_at), withFormate: CreatedAtPostDF)
        imgUser.loadImageFromUrl(postInfo.valueForString(key: CUserProfileImage), true)
        lblGalleryType.text = CTypeGallery
        if postInfo.valueForString(key: CCategory) == "0"{
            self.lblGalleryCategory.text = ""
        }else{
            self.lblGalleryCategory.text = postInfo.valueForString(key: CCategory).uppercased()
        }
//        btnLike.isSelected = postInfo.valueForInt(key: CIs_Like) == 1
//        likeCount = postInfo.valueForInt(key: CTotal_like) ?? 0
//        btnLikesCount.setTitle(appDelegate.getLikeString(like: likeCount), for: .normal)
        
        let is_Liked = postInfo.valueForString(key: CIsLiked)
       
        if is_Liked == "Yes"{
            btnLike.isSelected = true
        }else {
            btnLike.isSelected = false
        }
        
         likeCount = postInfo.valueForString(key: CLikes).toInt ?? 0
//        likeCount = product.likes!.toInt!
         btnLikesCount.setTitle(appDelegate.getLikeString(like: likeCount), for: .normal)

//        let commentCount = postInfo.valueForInt(key: CTotalComment) ?? 0
        let commentCount = postInfo.valueForString(key: "comments").toInt
        btnComment.setTitle(appDelegate.getCommentCountString(comment: commentCount ?? 0), for: .normal)
        btnShare.setTitle(CBtnShare, for: .normal)
       
        //Dateconvert
        let created_At = postInfo.valueForString(key: CCreated_at)
        let cnvStr = created_At.stringBefore("G")
//        let removeFrst = cnvStr.chopPrefix(3)
        let startCreated = DateFormatter.shared().convertDatereversLatest(strDate: cnvStr)
        self.lblGalleryPostDate.text = startCreated
        
    }
}

// MARK:- --------- UICollectionView Delegate/Datasources
extension HomeGalleryCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arrGalleryImage.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if arrGalleryImage.count > 1{
            var width = clGallery.frame.size.width
            width = width - ((width * 30) / 100)
            return CGSize(width:width, height: clGallery.bounds.height)
        }
//        return CGSize(width:clGallery.frame.size.width, height: clGallery.frame.size.width)
        return CGSize(width:clGallery.bounds.width, height: clGallery.bounds.height)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        //OLD Code
//       /* if arrGalleryImage.count > 1{
//            var width = clGallery.frame.size.width
//            width = width - ((width * 30) / 100)
//            return CGSize(width:width, height: clGallery.bounds.height)
//        }
//        //return CGSize(width:clGallery.frame.size.width, height: clGallery.frame.size.width)
//        return CGSize(width:clGallery.bounds.width, height: clGallery.bounds.height)*/
//
////        //*********NEWCode********************//
////        if arrGalleryImage.count > 1{
////            if arrGalleryImage.count == 5{
////                self.clGallery.isScrollEnabled = false
////                let width = clGallery.frame.size.width
////                return CGSize(width: ((width / 2) - 5) , height: clGallery.bounds.height / 2)
////            }else if arrGalleryImage.count == 4 {
//////                let margin = clGallery.frame.width * 0.3
//////                let width = clGallery.frame.size.width - (margin / 2)
////
////                return CGSize(width: ((clGallery.frame.width / 2) - 1) , height: clGallery.bounds.height / 2)
////            } else if arrGalleryImage.count == 3{
////                if indexPath.item == 0{
////                    return CGSize(width: self.clGallery.frame.size.width - 3, height: (clGallery.frame.size.height-10)/2)
////                }
////                else {
////                    return CGSize(width: self.clGallery.frame.size.width/2 - 5, height: (clGallery.frame.size.height-10)/2)
////                }
////            } else if arrGalleryImage.count == 2 {
////                let width = clGallery.frame.size.width
////                return CGSize(width: ((width / 2) - 10) , height: clGallery.bounds.height)
////            }else {
////                self.clGallery.isScrollEnabled = true
////                return CGSize(width:clGallery.bounds.width, height: clGallery.bounds.height)
////            }
////          }else {
////            return CGSize(width:clGallery.bounds.width, height: clGallery.bounds.height)
////        }
//
//
//        //*********NEWCode********************//
//        if arrGalleryImage.count > 1{
//            if arrGalleryImage.count == 5{
//                self.clGallery.isScrollEnabled = false
//                let width = clGallery.bounds.size.width
////                return CGSize(width: ((width / 2) - 5) , height: clGallery.bounds.height / 2)
//                return CGSize(width: (width / 2) - 1 , height: clGallery.bounds.height / 2 - 2)
//            }else if arrGalleryImage.count == 4 {
//
//                let width = clGallery.bounds.size.width
//                return CGSize(width: (width / 2) - 1 , height: collectionView.bounds.height / 2 - 2)
//
////                let height =  clGallery.bounds.width / 3
////                let width = ((clGallery.bounds.size.width / 2) - 1)
////                return CGSize(width: width , height: height)
//            } else if arrGalleryImage.count == 3{
//                if indexPath.item == 0{
//                    return CGSize(width: self.clGallery.frame.size.width - 3, height: (clGallery.frame.size.height-10)/2)
//                }
//                else {
//                    return CGSize(width: self.clGallery.frame.size.width/2 - 2, height: (clGallery.frame.size.height-2)/2)
//                }
//            } else if arrGalleryImage.count == 2 {
//                return CGSize(width: (clGallery.bounds.size.width / 2) - 1.5 , height: clGallery.bounds.height - 2)
//
//            }else {
//                self.clGallery.isScrollEnabled = true
//                return CGSize(width:clGallery.bounds.width, height: clGallery.bounds.height - 2)
//            }
//          }else {
//            return CGSize(width:clGallery.bounds.width, height: clGallery.bounds.height - 2)
//        }
//
//
//    }
    
//    func collectionView(_ collectionView: UICollectionView, layoucollectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
////        let margin = clGallery.frame.width * 0.3
////        return UIEdgeInsets(top: 10, left: margin / 2, bottom: 10, right: margin / 2)
//        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
//    }
//
    
    
//
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeEventGalleryCell", for: indexPath) as! HomeEventGalleryCell
        cell.vwBackgroundImg.backgroundColor = UIColor(hex: "DEDDE5")
        let imageInfo = arrGalleryImage[indexPath.row]
//        let mediaType = imageInfo.valueForInt(key: CType) ?? 1
        let mediaType = imageInfo.valueForString(key: "mime")
        if (mediaType == "video") || (mediaType == "vidoe"){
            //cell.imgGalleryEvent.loadImageFromUrl(imageInfo.valueForString(key: CThumbNail), false)
            if let url = URL(string: imageInfo.valueForString(key: "image_path")) {
                if let thumbnailImage = getThumbnailImage(forUrl: url) {
                    cell.blurImgView.image = thumbnailImage
                }
            }
//            cell.blurImgView.loadImageFromUrl(imageInfo.valueForString(key: "image_path"), false)
            cell.imgVideoIcon.isHidden =  false
        }else{
            //cell.imgGalleryEvent.loadImageFromUrl(imageInfo.valueForString(key: CImage), false)
            print(" imageInfo.valueForString(key: CImage)  \(imageInfo.valueForString(key: "image_path"))")
            cell.blurImgView.loadImageFromUrl(imageInfo.valueForString(key: "image_path"), false)
            cell.imgVideoIcon.isHidden =  true 
        }
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let lightBoxHelper = LightBoxControllerHelper()
        weak var weakSelf = self.viewController
        lightBoxHelper.openMultipleImagesWithVideos(arrGalleryImage: arrGalleryImage, controller: weakSelf,selectedIndex: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 6
//    }

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
//            self.lblCountImage.text =  "\(index)" + " / " + "\(self.arrGalleryImage.count)"
            self.lblCountImage.text =  ""
        }
    }
}

//MARK: - IBAction's
extension HomeGalleryCell {
    
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
    
    /********************************************************
     * Author :  Chandrika R                               *
     * Model  :Like button with Notfications               *
     ********************************************************/
    
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
                    guard let lastName = appDelegate.loginUser?.last_name else {return}
                    if self?.notifcationIsSlected == true{
                        MIGeneralsAPI.shared().sendNotification(self?.posted_ID, userID: user_ID, subject: "liked your Post Gallery", MsgType: "COMMENT", MsgSent: "", showDisplayContent: "liked your Post Gallery", senderName: firstName + lastName)
                       
                        
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

extension HomeGalleryCell{
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
