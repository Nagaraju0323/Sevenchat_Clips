//
//  HomeGalleryCell.swift
//  Sevenchats
//
//  Created by mac-0005 on 10/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//
/*********************************************************
 * Author  : Chandrika.R                                 *
 * Model   : HomeGalleryCell                             *
 * Changes : HomeGalleryCell                             *
 *                                                       *
 ********************************************************/

import UIKit
import AVKit
import AVFoundation

class HomeSharedGalleryCell: UITableViewCell {

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
    
    @IBOutlet weak var lblSharedPostDate : UILabel!
    @IBOutlet weak var imgSharedUser : UIImageView!
    @IBOutlet weak var lblSharedUserName : UILabel!
    @IBOutlet weak var btnSharedProfileImg : UIButton!
    @IBOutlet weak var btnSharedUserName : UIButton!
    @IBOutlet weak var lblMessage : UILabel!
    @IBOutlet weak var lblSharedPostType : UILabel!
    
    var arrGalleryImage :[[String : Any]] = []
    
    var didSelectGalleryCell : (() -> Void)?
    
    var imageIndex:Int = 0
    var postID = 0
    var likeCount = 0
    
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
        }
        
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
        
        postID = postInfo.valueForInt(key: CId) ?? 0
        
        if let sharedData = postInfo[CSharedPost] as? [String:Any]{
            self.lblSharedUserName.text = sharedData.valueForString(key: CFullName)
            self.lblSharedPostDate.text = DateFormatter.dateStringFrom(timestamp: sharedData.valueForDouble(key: CCreated_at), withFormate: CreatedAtPostDF)
            imgSharedUser.loadImageFromUrl(sharedData.valueForString(key: CUserProfileImage), true)
            lblMessage.text = sharedData.valueForString(key: CMessage)
        }
        
        if let arrImg = postInfo[CGalleryImages] as? [[String : Any]] {
            arrGalleryImage = arrImg
            clGallery.reloadData()
            setCurrentImageCount()
        }
        self.vwCountImage.isHidden = (arrGalleryImage.count <= 1)
        
        self.lblUserName.text = postInfo.valueForString(key: CFirstname) + " " + postInfo.valueForString(key: CLastname)
        //"\(CPostedOn) " + DateFormatte
        self.lblGalleryPostDate.text = DateFormatter.dateStringFrom(timestamp: postInfo.valueForDouble(key: CCreated_at), withFormate: CreatedAtPostDF)
        imgUser.loadImageFromUrl(postInfo.valueForString(key: CUserProfileImage), true)
        lblGalleryType.text = CTypeGallery
        if postInfo.valueForString(key: CCategory) == "0"{
            self.lblGalleryCategory.text = ""
        }else{
            self.lblGalleryCategory.text = postInfo.valueForString(key: CCategory).uppercased()
        }
        btnLike.isSelected = postInfo.valueForInt(key: CIs_Like) == 1
        
        likeCount = postInfo.valueForInt(key: CTotal_like) ?? 0
        
        let commentCount = postInfo.valueForInt(key: CTotalComment) ?? 0
        
        btnLikesCount.setTitle(appDelegate.getLikeString(like: likeCount), for: .normal)
        btnComment.setTitle(appDelegate.getCommentCountString(comment: commentCount), for: .normal)
        btnShare.setTitle(CBtnShare, for: .normal)
    }
}

// MARK:- --------- UICollectionView Delegate/Datasources
extension HomeSharedGalleryCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
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
        //return CGSize(width:clGallery.frame.size.width, height: clGallery.frame.size.width)
        return CGSize(width:clGallery.bounds.width, height: clGallery.bounds.height)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeEventGalleryCell", for: indexPath) as! HomeEventGalleryCell
        cell.vwBackgroundImg.backgroundColor = UIColor(hex: "DEDDE5")
        let imageInfo = arrGalleryImage[indexPath.row]
        let mediaType = imageInfo.valueForInt(key: CType) ?? 1
        if (mediaType == 2){
            //cell.imgGalleryEvent.loadImageFromUrl(imageInfo.valueForString(key: CThumbNail), false)
            cell.blurImgView.loadImageFromUrl(imageInfo.valueForString(key: CThumbNail), false)
            cell.imgVideoIcon.isHidden =  false
        }else{
            //cell.imgGalleryEvent.loadImageFromUrl(imageInfo.valueForString(key: CImage), false)
            cell.blurImgView.loadImageFromUrl(imageInfo.valueForString(key: CImage), false)
            cell.imgVideoIcon.isHidden =  true
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let lightBoxHelper = LightBoxControllerHelper()
        weak var weakSelf = self.viewController
        lightBoxHelper.openMultipleImagesWithVideo(arrGalleryImage: arrGalleryImage, controller: weakSelf,selectedIndex: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 6
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
//            self.lblCountImage.text =  "\(index)" + " / " + "\(self.arrGalleryImage.count)"
        }
    }
}

//MARK: - IBAction's
extension HomeSharedGalleryCell {
    
    @IBAction func onLikePressed(_ sender:UIButton){
        
        self.btnLike.isSelected = !self.btnLike.isSelected
        self.likeCount = self.btnLike.isSelected ? self.likeCount + 1 : self.likeCount - 1
        self.btnLikesCount.setTitle(appDelegate.getLikeString(like: self.likeCount), for: .normal)
        MIGeneralsAPI.shared().likeUnlikePostWebsite(post_id: self.postID, rss_id: nil, type: 1, likeStatus: self.btnLike.isSelected ? 1 : 0, viewController: self.viewController)
    }
}
