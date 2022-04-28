//
//  ProductDetailCell.swift
//  Sevenchats
//
//  Created by mac-00020 on 26/08/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Nagaraju K and Chandrika R                                 *
 * Model   : ProductDetailCell                           *
 * Changes :                                             *
 *                                                       *
 ********************************************************/


import UIKit

class ProductDetailCell: UITableViewCell, ProductDetailBaseCell {
    
    //MARK: - IBOutlet/Object/Variable Declaration
    @IBOutlet weak var lblAddrees: MIGenericLabel!
    @IBOutlet weak var lblLastDOSPlaceH: MIGenericLabel!
    @IBOutlet weak var lblLastDOS: MIGenericLabel!
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
    var productNotfi = [String:Any]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        
        btnSold.layer.cornerRadius = 4
        btnSold.setTitle(CSold, for: .normal)
        btnSold.backgroundColor = UIColor(hex: "21bfa6")
        collVImages.isProductDetails = true
        lblLastDOSPlaceH.text = CLastDateOfProductSelling
        btnLikesCount.setTitle(CLike, for: .normal)
        btnComment.setTitle(CComment, for: .normal)
        self.collVImages.scrollToIndex = { [weak self] (index) in
//            self?.lblCountImage.text = ""
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
        self.lblName.text = self.modelData.productTitle
        self.lblAddrees.text = self.modelData.address
        self.lblCountImage.text = "\( self.collVImages.arrMedia.count) \("/") \("5")"
        self.btnLike.isSelected = self.modelData.isLike == 1
        self.likeCounts = self.modelData.likes
        likeCount = self.likeCounts.toInt ?? 0
        self.btnLikesCount.setTitle(appDelegate.getLikeString(like: self.likeCount), for: .normal)
        
        if self.modelData.productState == "1"{
            self.btnSold.setTitle(CAvailable, for: .normal)
            self.btnSold.backgroundColor = UIColor(hex: "21bfa6")
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
        let commentCount = self.modelData.totalComments.toInt ?? 0
        self.btnComment.setTitle(appDelegate.getCommentCountString(comment: commentCount), for: .normal)
        let lastDate =  self.modelData.lastdateSelling.stringBefore("G")
        let  lastMod = DateFormatter.shared().convertDatereversLatestsell(strDate: lastDate)
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
        self.lblName.text = self.modelData.productTitle
        self.lblAddrees.text = self.modelData.address
        self.btnLike.isSelected = self.modelData.isLike == 1
        self.likeCounts = self.modelData.likes
        likeCount = self.likeCounts.toInt ?? 0
        self.btnLikesCount.setTitle(appDelegate.getLikeString(like: self.likeCount), for: .normal)
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
        self.btnLike.isSelected = !self.btnLike.isSelected
        if self.btnLike.isSelected == true{
            likeCount = 1
            notifcationIsSlected = true
        }else {
            likeCount = 2
        }
        
        guard let userID = appDelegate.loginUser?.user_id else {return}
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
                }
            }
        }
    }
    //MARK :- Button Like count
    func likeCountfromSever(productId: Int,isliked:String){
        
        APIRequest.shared().likeUnlikeProductCount(productId: Int(self.modelData.productID) ?? 0){ [weak self](response, error) in
            guard let _ = self else { return }
            if response != nil {
                GCDMainThread.async { [self] in
                    _ = response!["liked_users"] as? [String:Any] ?? [:]
                    self?.likeTotalCount = response?["likes_count"] as? Int ?? 0
                    if self?.notifcationIsSlected == true{
                        guard let user_ID = appDelegate.loginUser?.user_id.description else { return }
                        guard let firstName = appDelegate.loginUser?.first_name else {return}
                        guard let lastName = appDelegate.loginUser?.last_name else {return}
                        
                        self?.productNotfi["type"] = "productDetails"
                        self?.productNotfi["product_id"] = self?.modelData.productID
                        self?.productNotfi["productUserID"] = self?.modelData.productUserID
                        
                        MIGeneralsAPI.shared().sendNotification(self?.modelData.productUserID, userID: user_ID, subject: "liked your Product", MsgType: "COMMENT", MsgSent: "", showDisplayContent: "liked your Product", senderName: firstName + lastName, post_ID: self?.productNotfi ?? [:],shareLink: "sendProductLikeLink")
                        self?.notifcationIsSlected = false
                    }
                    self?.btnLikesCount.setTitle(appDelegate.getLikeString(like: self?.likeTotalCount ?? 0), for: .normal)
                    if isliked == "No"{
                        self?.islike = 0
                    }else {
                        self?.islike = 1
                    }
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
