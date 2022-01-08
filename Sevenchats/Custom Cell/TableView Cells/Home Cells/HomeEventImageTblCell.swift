//
//  HomeEventImageTblCell.swift
//  Sevenchats
//
//  Created by mac-0005 on 11/09/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit
import Lightbox
import MapKit
import CoreLocation

class HomeEventImageTblCell: UITableViewCell {

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
    
    var likeCount = 0
    var imgURL = ""
    var postID = 0
    var likeTotalCount = 0
    var like =  0
    var info = [String:Any]()
    var posted_ID = ""
    var profileImg = ""
    var notifcationIsSlected = false
    
    
    var onChangeEventStatus : ((Int) -> Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
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
extension HomeEventImageTblCell{
    
    func homeEventDataSetup(_ postInfo : [String : Any]){
        
//        postID = postInfo.valueForInt(key: CId) ?? 0
        postID = postInfo.valueForString(key: "post_id").toInt ?? 0
        posted_ID = postInfo.valueForString(key: "user_id")
        
        self.lblUserName.text = postInfo.valueForString(key: CFirstname) + " " + postInfo.valueForString(key: CLastname)
        lblEventTitle.text = postInfo.valueForString(key: CTitle)
        lblEventDescription.text = postInfo.valueForString(key: CContent)
        let created_At1 = postInfo.valueForString(key: "start_date")
        let cnvStr1 = created_At1.stringBefore("G")
        guard let startCreated1 = DateFormatter.shared().convertDatereversLatest(strDate: cnvStr1)  else { return}
        let created_At2 = postInfo.valueForString(key: "end_date")
        let cnvStr2 = created_At2.stringBefore("G")
        guard let startCreated2 = DateFormatter.shared().convertDatereversLatest(strDate: cnvStr2) else { return}
        self.lblEndDate.text = CEndDate + startCreated2
        self.lblStartDate.text = CStartDate + startCreated1
        let image = postInfo.valueForString(key: Cimages)
        if image.isEmpty {
            blurImgView.heightAnchor.constraint(equalToConstant: CGFloat(0)).isActive = true
        }else{
            blurImgView.loadImageFromUrl(postInfo.valueForString(key: Cimages), false)
        }
        imgURL = postInfo.valueForString(key: CImage)
        imgUser.loadImageFromUrl(postInfo.valueForString(key: CUserProfileImage), true)
        
        lblEventType.text = CTypeEvent
        lblEventCategory.text = postInfo.valueForString(key: CCategory).uppercased()
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
        self.lblEventPostDate.text = startCreated
        
        
//        lblEventLocation.text = postInfo.valueForString(key: CEvent_Location)
        print("postinfo.location\(postInfo.valueForString(key: "address_line1"))")
        
//        let location = CLLocation(latitude: postInfo.valueForString(key: CLatitude).toDouble ?? 0.0, longitude: postInfo.valueForString(key: CLongitude).toDouble ?? 0.0)
//        let strAddress = selectLocation(location: location)
        lblEventLocation.text = postInfo.valueForString(key:CEvent_Location)
        
//        btnMaybe.setTitle("\(postInfo.valueForString(key: CTotalMaybeInterestedUsers))\n" + CMaybe, for: .normal)
//        btnNotInterested.setTitle("\(postInfo.valueForString(key: CTotalNotInterestedUsers))\n" + CDeclined, for: .normal)
//        btnInterested.setTitle("\(postInfo.valueForString(key: CTotalInterestedUsers))\n" + CConfirmed, for: .normal)
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
        

        
        switch postInfo.valueForInt(key: CIsInterested) {
                case 3:
                    btnMaybe.isSelected = true
                case 1:
                    btnInterested.isSelected = true
                case 2:
                    btnNotInterested.isSelected = true
                default:
                    break
                }
        setSelectedButtonStyle(postInfo)
    }
    func setSelectedButtonStyle(_ postInfo : [String : Any]?){
           btnInterested.layer.borderColor = CRGB(r: 223, g: 234, b: 227).cgColor
           btnInterested.layer.borderWidth = 2
           btnInterested.backgroundColor =  .clear

           btnMaybe.layer.borderColor = CRGB(r: 255, g: 237, b: 216).cgColor
           btnMaybe.layer.borderWidth = 2
           btnMaybe.backgroundColor =  .clear

           btnNotInterested.layer.borderColor = CRGB(r: 255, g: 214, b: 214).cgColor
           btnNotInterested.layer.borderWidth = 2
           btnNotInterested.backgroundColor =  .clear
           
           if postInfo?.valueForString(key:"selected_choice") == "3"{
               btnMaybe.isSelected = true
               btnMaybe.backgroundColor =  CRGB(r: 255, g: 237, b: 216)
           }else if postInfo?.valueForString(key:"selected_choice") == "2"{
               btnNotInterested.isSelected = true
               btnNotInterested.backgroundColor =  CRGB(r: 255, g: 214, b: 214)
           }else if postInfo?.valueForString(key:"selected_choice") == "1"{
               btnInterested.isSelected = true
               btnInterested.backgroundColor =  CRGB(r: 223, g: 234, b: 227)
           }
   //        let arrButton = [btnInterested,btnMaybe,btnNotInterested]
   //        if let sender = arrButton.filter({$0?.isSelected ?? false}).first{
   //            if sender == btnInterested{
   //                btnInterested.backgroundColor =  CRGB(r: 223, g: 234, b: 227)
   //            }else if sender == btnMaybe{
   //                btnMaybe.backgroundColor =  CRGB(r: 255, g: 237, b: 216)
   //            }else if sender == btnNotInterested{
   //                btnNotInterested.backgroundColor =  CRGB(r: 255, g: 214, b: 214)
   //            }
   //        }
       }
//    func setSelectedButtonStyle(){
////        btnInterested.layer.borderColor = CRGB(r: 223, g: 234, b: 227).cgColor
////        btnInterested.layer.borderWidth = 2
////        btnInterested.backgroundColor =  .clear
////
////        btnMaybe.layer.borderColor = CRGB(r: 255, g: 237, b: 216).cgColor
////        btnMaybe.layer.borderWidth = 2
////        btnMaybe.backgroundColor =  .clear
////
////        btnNotInterested.layer.borderColor = CRGB(r: 255, g: 214, b: 214).cgColor
////        btnNotInterested.layer.borderWidth = 2
////        btnNotInterested.backgroundColor =  .clear
//
//        let arrButton = [btnInterested,btnMaybe,btnNotInterested]
//        if let sender = arrButton.filter({$0?.isSelected ?? false}).first{
//            if sender == btnInterested{
//                btnInterested.backgroundColor =  CRGB(r: 223, g: 234, b: 227)
//            }else if sender == btnMaybe{
//                btnMaybe.backgroundColor =  CRGB(r: 255, g: 237, b: 216)
//            }else if sender == btnNotInterested{
//                btnNotInterested.backgroundColor =  CRGB(r: 255, g: 214, b: 214)
//            }
//        }
//    }
}

//MARK: - IBAction's
extension HomeEventImageTblCell{
    
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
//                    info = response!["liked_users"] as? [String:Any] ?? [:]
                    self?.likeTotalCount = response?["likes_count"] as? Int ?? 0
                    self?.btnLikesCount.setTitle(appDelegate.getLikeString(like: self?.likeTotalCount ?? 0), for: .normal)
                    guard let user_ID = appDelegate.loginUser?.user_id.description else { return }
                    guard let firstName = appDelegate.loginUser?.first_name else {return}
                    guard let lastName = appDelegate.loginUser?.last_name else {return}
                    
                    if self?.notifcationIsSlected == true{
                        MIGeneralsAPI.shared().sendNotification(self?.posted_ID, userID: user_ID, subject: "liked your Post Event", MsgType: "COMMENT", MsgSent: "", showDisplayContent: "liked your Post Event", senderName: firstName + lastName)
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

extension HomeEventImageTblCell{
  
    func selectLocation(location: CLLocation) -> String {
        let geocoder = CLGeocoder()
        var strAddress = ""
        geocoder.cancelGeocode()
        geocoder.reverseGeocodeLocation(location) { response, error in
            if let error = error as NSError?, error.code != 10 { // ignore cancelGeocode errors
                // show error and remove annotation
             
            } else if let placemark = response?.first {
                
                if let addressDic = placemark.addressDictionary {
                    var _strAddress = ""
                    if let lines = addressDic["FormattedAddressLines"] as? [String] {
                        _strAddress = lines.joined(separator: ", ")
                    }
                    strAddress = _strAddress
                }
            }
        }
        return strAddress
    }
}
