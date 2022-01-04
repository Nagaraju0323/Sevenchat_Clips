//
//  ProductDetailCell.swift
//  Sevenchats
//
//  Created by mac-00020 on 26/08/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//

import UIKit

class ProductDetailCell: UITableViewCell, ProductDetailBaseCell {
    
    //MARK: - IBOutlet/Object/Variable Declaration
    @IBOutlet weak var lblAddrees: MIGenericLabel!
    
    //@IBOutlet weak var lblPaymentPrefPlaceH: MIGenericLabel!
    //@IBOutlet weak var lblPaymentPref: MIGenericLabel!
    
    @IBOutlet weak var lblLastDOSPlaceH: MIGenericLabel!
    @IBOutlet weak var lblLastDOS: MIGenericLabel!
    
    //@IBOutlet weak var lblDescriptionPlaceH: MIGenericLabel!
    @IBOutlet weak var lblDescription: MIGenericLabel!
    
    @IBOutlet weak var lblName: MIGenericLabel!
    @IBOutlet weak var lblPrice: MIGenericLabel!
    @IBOutlet weak var btnSold: MIGenericButton!
    
    @IBOutlet weak var collVImages: ProductMediaCollectionView!
    @IBOutlet weak var vwCountImage : UIView!
    @IBOutlet weak var lblCountImage : UILabel!
    
    @IBOutlet var btnLikesCount : MIGenericButton!
    @IBOutlet var btnLike : MIGenericButton!
    @IBOutlet var btnComment : MIGenericButton!
    @IBOutlet var btnShare : MIGenericButton!
    
    var likeCount = 0
    var likeCounts = ""
    var likeTotalCount = 0
    var isLiked = ""
    var productId = ""
    var islike:Int?
    var arrMedia : [MDLAddMedia] = []
    var modelData: MDLProduct!
    var notifcationIsSlected = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        
        btnSold.layer.cornerRadius = 4
        btnSold.setTitle(CSold, for: .normal)
        btnSold.backgroundColor = UIColor(hex: "FF0C00")
        
        //lblPaymentPrefPlaceH.text = CPaymentPreference
        lblLastDOSPlaceH.text = CLastDateOfProductSelling
        //lblDescriptionPlaceH.text = CPaymentDescription
        
        btnLikesCount.setTitle(CLike, for: .normal)
        btnComment.setTitle(CComment, for: .normal)
        btnShare.setTitle(CBtnShare, for: .normal)
        
        self.collVImages.scrollToIndex = { [weak self] (index) in
            
            self?.lblCountImage.text = ""
//            self?.lblCountImage.text =  "\(index)" + " / " + "\(self?.modelData.galleryImages.count ?? 0)"
        }
    }
    
    func configure(withModel: ProductBaseModel) {
        
        guard let _model = withModel as? MDLProduct else {
            return
        }
        
        self.modelData = _model
        
        self.collVImages.arrMedia = self.modelData.galleryImages
        self.vwCountImage.isHidden = (self.modelData.galleryImages.count <= 1)
        
        self.lblPrice.text = self.modelData.formatedPriceAmount
//        self.lblPrice.text = self.modelData.productPrice
        self.lblName.text = self.modelData.productTitle
        self.lblAddrees.text = self.modelData.address
        
        self.btnLike.isSelected = self.modelData.isLike == 1
        self.likeCounts = self.modelData.likes
        likeCount = self.likeCounts.toInt ?? 0
        self.btnLikesCount.setTitle(appDelegate.getLikeString(like: self.likeCount), for: .normal)

//        self.btnLikesCount.setTitle((self.likeCounts), for: .normal)
        
        
//        if self.modelData.isSold == 1{
//            self.btnSold.setTitle(CAvailable, for: .normal)
//            self.btnSold.backgroundColor = UIColor(hex: "3a9120")
//        }else{
//            self.btnSold.setTitle(CSold, for: .normal)
//            self.btnSold.backgroundColor = UIColor(hex: "FF0C00")
//        }
        
        if self.modelData.productState == "1"{
            self.btnSold.setTitle(CAvailable, for: .normal)
            self.btnSold.backgroundColor = UIColor(hex: "3a9120")
        }else{
            self.btnSold.setTitle(CSold, for: .normal)
            self.btnSold.backgroundColor = UIColor(hex: "FF0C00")
        }
        
        if modelData.userAsLiked == "Yes"{
            btnLike.isSelected = true
        }else {
            btnLike.isSelected = false
        }
        
       
        
        /*if self.modelData.paymentType == .Offline{
            self.lblPaymentPref.text = COfflinePaymentMode
        }else{
            self.lblPaymentPref.text = COnlinePaymentMode
        }*/
        self.lblDescription.text = self.modelData.productDescription
//        let date = Date.init(timeIntervalSince1970: self.modelData.lastDateSelling)
//        self.setDate(date: date)
        
        let commentCount = self.modelData.totalComments.toInt ?? 0
   
        self.btnComment.setTitle(appDelegate.getCommentCountString(comment: commentCount), for: .normal)
        self.btnShare.setTitle(CBtnShare, for: .normal)
        
//        self.lblLastDOS.text = self.modelData.lastdateSelling
       
//        let created_At =  self.modelData.lastdateSelling
//        let cnvStr = created_At?.stringBefore("G")
//        let removeFrst = cnvStr?.chopPrefix(3)
//        let startCreated = DateFormatter.shared().convertDatereversLatest(strDate: removeFrst)
//        self.lblLastDOS.text = startCreated
        let lastDate =  self.modelData.lastdateSelling.stringBefore("G")
        let  lastMod = DateFormatter.shared().convertDatereversLatest(strDate: lastDate)
            
        
        self.lblLastDOS.text = lastMod
    }
    
    func configures(withModel: ProductBaseModel) {
        
        guard let _model = withModel as? MDLProduct else {
            return
        }
        
        self.modelData = _model
        
        self.collVImages.arrMedia = self.modelData.galleryImages
        self.vwCountImage.isHidden = (self.modelData.galleryImages.count <= 1)
        
        self.lblPrice.text = self.modelData.formatedPriceAmount
//        self.lblPrice.text = self.modelData.productPrice
        self.lblName.text = self.modelData.productTitle
        self.lblAddrees.text = self.modelData.address
        
        self.btnLike.isSelected = self.modelData.isLike == 1
        self.likeCounts = self.modelData.likes
        likeCount = self.likeCounts.toInt ?? 0
        self.btnLikesCount.setTitle(appDelegate.getLikeString(like: self.likeCount), for: .normal)

//        self.btnLikesCount.setTitle((self.likeCounts), for: .normal)
        
        
//        if self.modelData.isSold == 1{
//            self.btnSold.setTitle(CAvailable, for: .normal)
//            self.btnSold.backgroundColor = UIColor(hex: "3a9120")
//        }else{
//            self.btnSold.setTitle(CSold, for: .normal)
//            self.btnSold.backgroundColor = UIColor(hex: "FF0C00")
//        }
        
        if self.modelData.productState == "1"{
            self.btnSold.setTitle(CAvailable, for: .normal)
            self.btnSold.backgroundColor = UIColor(hex: "3a9120")
        }else{
            self.btnSold.setTitle(CSold, for: .normal)
            self.btnSold.backgroundColor = UIColor(hex: "FF0C00")
        }
        
        if modelData.userAsLiked == "Yes"{
            btnLike.isSelected = true
        }else {
            btnLike.isSelected = false
        }
        self.lblDescription.text = self.modelData.productDescription
        let date = Date.init(timeIntervalSince1970: self.modelData.lastDateSelling)
        self.setDate(date: date)
        
        
        
        let commentCount = self.modelData.totalComments.toInt ?? 0
   
        self.btnComment.setTitle(appDelegate.getCommentCountString(comment: commentCount), for: .normal)
        self.btnShare.setTitle(CBtnShare, for: .normal)
      
        print("aboutmetting\(self.modelData.lastdateSelling)")
        
        self.lblLastDOS.text = self.modelData.lastdateSelling
    }
    
    fileprivate func setDate(date:Date){
        let formatter = DateFormatter()
        formatter.locale = DateFormatter.shared().locale
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myString = formatter.string(from: date)
        let strDate = formatter.date(from: myString)
        formatter.dateFormat = "dd MMM, yyyy"
        self.lblLastDOS.text = formatter.string(from: strDate!)
    }
    
    
    
    
}

//MARK: - IBAction / Selector
extension ProductDetailCell {
    
    @IBAction func onShareProductPressed(_ sender : UIButton){
        self.viewController?.presentActivityViewController(mediaData: nil, contentTitle: CShareProductText)
    }
    
    @IBAction func onLikePressed(_ sender : UIButton){
        
//        self.btnLike.isSelected = !self.btnLike.isSelected
//        self.likeCount = self.btnLike.isSelected ? self.likeCount + 1 : self.likeCount - 1
//        self.btnLikesCount.setTitle(appDelegate.getLikeString(like: self.likeCount), for: .normal)
//        APIRequest.shared().likeUnlikeProduct(productId: self.modelData.id, isLike: NSNumber(value: self.btnLike.isSelected).intValue){ [weak self](response, error) in
//            guard let _ = self else { return }
//            if response != nil {
//                GCDMainThread.async {
//                    let data = response![CData] as? [String:Any] ?? [:]
//                    let totalLike = data["total_like"] as? Int ?? 0
//                    let isLike = data["is_like"] as? Int ?? 0
//                    ProductHelper<UIViewController>.likeUnlike(productId: (self?.modelData.id ?? 0) , isLike: isLike, totalLike: totalLike, controller: self?.viewController, refreshCnt: [StoreListVC.self, ProductSearchVC.self])
//                }
//            }
//        }
        self.btnLike.isSelected = !self.btnLike.isSelected
        if self.btnLike.isSelected == true{
            likeCount = 1
            notifcationIsSlected = true
        }else {
            likeCount = 2
        }
        
//        self.likeCount = self.btnLike.isSelected ? self.likeCount + 1 : self.likeCount - 1
//        self.btnLikesCount.setTitle(appDelegate.getLikeString(like: self.likeCount), for: .normal)
        guard let userID = appDelegate.loginUser?.user_id else {
            return
        }
//        let likecount = NSNumber(value: self.btnLike.isSelected).intValue
        
        
//        APIRequest.shared().likeUnlikeProducts(userId: Int(userID), productId: Int(product.productID) ?? 0, isLike: NSNumber(value: self.btnLike.isSelected).intValue){ [weak self](response, error) in
        APIRequest.shared().likeUnlikeProducts(userId: Int(userID), productId: Int(modelData.productID) ?? 0, isLike: likeCount){ [weak self](response, error) in
            
            guard let _ = self else { return }
            if response != nil {
                GCDMainThread.async {
                   
                    let likedata = response![CJsonData] as? [[String:Any]] ?? [[:]]
                    for likesData in likedata{
                        self?.isLiked = likesData["is_liked"] as? String ?? ""
                        self?.productId = likesData["element_id"] as? String ?? ""
                    }

                    let data = response![CJsonMeta] as? [String:Any] ?? [:]
                    let stausLike = data["status"] as? String ?? "0"
                    if stausLike == "0"{
                        self?.likeCountfromSever(productId: Int(self?.productId ?? "0") ?? 0, isliked: self?.isLiked ?? "")
                    }
                
                    
//                    let data = response![CData] as? [String:Any] ?? [:]
//                    let totalLike = data["total_like"] as? Int ?? 0
//                    let isLike = data["is_like"] as? Int ?? 0
//                    ProductHelper<UIViewController>.likeUnlike(productId: (self?.product.id ?? 0), isLike: isLike, totalLike: totalLike, controller: self?.viewController, refreshCnt: [StoreListVC.self, ProductSearchVC.self])
                }
            }
        }
    }
    
    
    /********************************************************
     * Author :  Chandrika R                                *
     * Model   :  product Create Notification               *
     * option                                               *
     ********************************************************/
    
    //MARK :- Button Like count
    func likeCountfromSever(productId: Int,isliked:String){
        
        APIRequest.shared().likeUnlikeProductCount(productId: Int(self.modelData.productID) ?? 0){ [weak self](response, error) in
            guard let _ = self else { return }
            if response != nil {
                GCDMainThread.async { [self] in
                    let data = response!["liked_users"] as? [String:Any] ?? [:]
                    self?.likeTotalCount = response?["likes_count"] as? Int ?? 0
//                    self.likeCount = self.btnLike.isSelected ? self.likeCount + 1 : self.likeCount - 1
                    
                    if self?.notifcationIsSlected == true{
                        guard let user_ID = appDelegate.loginUser?.user_id.description else { return }
                        guard let firstName = appDelegate.loginUser?.first_name else {return}
                        guard let lastName = appDelegate.loginUser?.last_name else {return}
                        MIGeneralsAPI.shared().sendNotification(self?.modelData.productUserID, userID: user_ID, subject: "liked your Product", MsgType: "COMMENT", MsgSent: "", showDisplayContent: "liked your Product", senderName: firstName + lastName)
                        self?.notifcationIsSlected = false
                    }
                    self?.btnLikesCount.setTitle(appDelegate.getLikeString(like: self?.likeTotalCount ?? 0), for: .normal)
                    
                    if isliked == "No"{
                        self?.islike = 0
                    }else {
                        self?.islike = 1
                    }
                    
//                    let isLike = data["is_like"] as? Int ?? 0
                    
                    ProductHelper<UIViewController>.likeUnlike(productId: (Int(self?.modelData.productID ?? "0") ?? 0), isLike: self?.islike ?? 0, totalLike: self?.likeTotalCount ?? 0, controller: self?.viewController, refreshCnt: [StoreListVC.self, ProductSearchVC.self])
                }
            }
        }
        
    }
    
    @IBAction func btnLikesCountCLK(_ sender : UIButton){
        if let likeVC = CStoryboardGeneral.instantiateViewController(withIdentifier: "LikeViewController") as? LikeViewController{
            
            likeVC.postIDNew = self.modelData.productID
            
            self.viewController?.navigationController?.pushViewController(likeVC, animated: true)
        }
    }
}
