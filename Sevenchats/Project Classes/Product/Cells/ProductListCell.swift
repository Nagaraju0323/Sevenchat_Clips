//
//  ProductListCell.swift
//  Sevenchats
//
//  Created by mac-00020 on 27/08/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Chandrika.R                                 *
 * Model   : ProductListCell                             *
 * Description : Like nand comment product list items    *
 *
 ********************************************************/



import UIKit

class ProductListCell: UITableViewCell {
    
    //MARK: - IBOutlet/Object/Variable Declaration
    @IBOutlet var viewMainContainer : UIView!
    @IBOutlet var viewSubContainer : UIView!
    
    @IBOutlet weak var lblName: MIGenericLabel!
    @IBOutlet weak var lblPrice: MIGenericLabel!
    @IBOutlet weak var btnSold: MIGenericButton!
    
    @IBOutlet var imgUser : UIImageView!
    @IBOutlet var lblUserName : UILabel!
    @IBOutlet var lblPostDate : UILabel!
    
    @IBOutlet weak var collVImages: ProductMediaCollectionView!
    
    @IBOutlet var btnLikesCount : MIGenericButton!
    @IBOutlet var btnLike : MIGenericButton!
    @IBOutlet var btnComment : MIGenericButton!
    @IBOutlet var btnShare : MIGenericButton!
    @IBOutlet var btnMore : UIButton!
    
    @IBOutlet weak var vwCountImage : UIView!
    @IBOutlet weak var lblCountImage : UILabel!
    
    var likeCount = 0
    var likeTotalCount = 0
    var arrMedia : [MDLAddMedia] = []
    var notifcationIsSlected = false
    
    
    var product : MDLProduct!{
        didSet{
            collVImages.arrMedia = product.galleryImages
            lblUserName.text = product.firstName + " " + product.lastName
            lblPrice.text = product.formatedPriceAmount
            lblName.text = product.productTitle
            let created_At = product.createdAt
            let cnvStr = created_At?.stringBefore("G")
            let startCreated = DateFormatter.shared().convertDatereversLatest(strDate: cnvStr)
            lblPostDate.text = startCreated
            if product.userAsLiked == "Yes"{
                btnLike.isSelected = true
            }else {
                btnLike.isSelected = false
            }
            imgUser.loadImageFromUrl(product.userProfileImage, true)
            likeCount = product.likes!.toInt!
            btnLikesCount.setTitle(appDelegate.getLikeString(like: likeCount), for: .normal)
            
            if product.productState == "1"{
                btnSold.setTitle(CAvailable, for: .normal)
                btnSold.backgroundColor = UIColor(hex: "21bfa6")
            }else{
                btnSold.setTitle(CSold, for: .normal)
                btnSold.backgroundColor = UIColor(hex: "FF0C00")
            }
            let commentCount = product.totalComments.toInt ?? 0
            btnComment.setTitle(appDelegate.getCommentCountString(comment: commentCount), for: .normal)
            self.vwCountImage.isHidden = (product.galleryImages.count <= 1)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        
        self.btnSold.layer.cornerRadius = 4
        self.vwCountImage.layer.cornerRadius = 4
        
        self.btnLikesCount.setTitle(CLike, for: .normal)
        self.btnComment.setTitle(CComment, for: .normal)
        self.viewSubContainer.layer.cornerRadius = 8
        self.viewMainContainer.layer.cornerRadius = 8
        self.viewMainContainer.shadow(color: CRGB(r: 237, g: 236, b: 226), shadowOffset: CGSize(width: 0, height: 5), shadowRadius: 10.0, shadowOpacity: 10.0)
        self.imgUser.layer.cornerRadius = self.imgUser.frame.size.width / 2
        self.imgUser.layer.borderWidth = 2
        self.imgUser.layer.borderColor = #colorLiteral(red: 0, green: 0.7881455421, blue: 0.7100172639, alpha: 1)
        self.collVImages.scrollToIndex = { [weak self] (index) in
            self?.lblCountImage.text =  ""
        }
    }
    
    func confiureCell(){
        DispatchQueue.main.async {
            self.collVImages.arrMedia = self.arrMedia
            self.collVImages.reloadData()
            self.collVImages.layoutIfNeeded()
            self.layoutIfNeeded()
        }
    }
}

//MARK: - IBAction / Selector
extension ProductListCell {
    
    @IBAction func onMoreOptionPressd(_ sender:UIButton){
        if product.email == appDelegate.loginUser?.email{
            self.editDeleteProduct()
        }else{
            reportProduct()
        }
    }
    
    @IBAction func onUserPressed(_ sender : UIButton){
        appDelegate.moveOnProfileScreenNew(product.productUserID.description, product.email.description, self.viewController)
        
    }
    
    @IBAction func onShareProductPressed(_ sender : UIButton){
        let shareProduct = CShareProductText + " " + self.product.shareUrl
        self.viewController?.presentActivityViewController(mediaData: nil, contentTitle: shareProduct)
    }
    
    @IBAction func onLikePressed(_ sender : UIButton){
        
        self.btnLike.isSelected = !self.btnLike.isSelected
        if self.btnLike.isSelected == true{
            likeCount = 1
            notifcationIsSlected = true
            
        }else {
            likeCount = 2
        }
        guard let userID = appDelegate.loginUser?.user_id else {
            return
        }
        APIRequest.shared().likeUnlikeProducts(userId: Int(userID), productId: Int(product.productID) ?? 0, isLike: likeCount){ [weak self](response, error) in
            
            guard let _ = self else { return }
            if response != nil {
                GCDMainThread.async {
                    
                    let data = response![CJsonMeta] as? [String:Any] ?? [:]
                    let stausLike = data["status"] as? String ?? "0"
                    if stausLike == "0"{
                        self?.likeCountfromSever(productId: Int((self?.product.productID)!) ?? 0)
                    }
                }
            }
        }
    }
    //MARK :- Button Like count
    func likeCountfromSever(productId: Int){
        
        APIRequest.shared().likeUnlikeProductCount(productId: Int(product.productID) ?? 0){ [weak self](response, error) in
            guard let _ = self else { return }
            if response != nil {
                GCDMainThread.async { [self] in
                    self?.likeTotalCount = response?["likes_count"] as? Int ?? 0
                    if self?.notifcationIsSlected == true{
                        if let metaInfo = response![CJsonMeta] as? [String : Any] {
                            let name = (appDelegate.loginUser?.first_name ?? "") + " " + (appDelegate.loginUser?.last_name ?? "")
                            guard let image = appDelegate.loginUser?.profile_img else { return }
                            let stausLike = metaInfo["status"] as? String ?? "0"
                            if stausLike == "0" {

                            }
                        }
                        guard let user_ID = appDelegate.loginUser?.user_id.description else { return }
                        guard let firstName = appDelegate.loginUser?.first_name else {return}
                        guard let lastName = appDelegate.loginUser?.last_name else {return}
                        MIGeneralsAPI.shared().sendNotification(self?.product.productUserID, userID: user_ID, subject: "liked your Product", MsgType: "COMMENT", MsgSent: "", showDisplayContent: "liked your Product", senderName: firstName + lastName, post_ID: [:])
                        self?.notifcationIsSlected = false
                    }
                    
                    self?.btnLikesCount.setTitle(appDelegate.getLikeString(like: self?.likeTotalCount ?? 0), for: .normal)
                    
                }
            }
        }
        
    }
    @IBAction func btnLikesCountCLK(_ sender : UIButton){
        if let likeVC = CStoryboardGeneral.instantiateViewController(withIdentifier: "LikeViewController") as? LikeViewController{
            
            likeVC.postIDNew = self.product.productID
            self.viewController?.navigationController?.pushViewController(likeVC, animated: true)
        }
    }
    
    func editDeleteProduct(){
        //product
        self.viewController?.presentActionsheetWithTwoButtons(actionSheetTitle: nil, actionSheetMessage: nil, btnOneTitle: CBtnEdit, btnOneStyle: .default, btnOneTapped: { [weak self](alert) in
            guard let _ = self else { return }
            guard let addEditProduct = CStoryboardProduct.instantiateViewController(withIdentifier: "AddEditProductVC") as? AddEditProductVC else{
                return
            }
            addEditProduct.myeditStart = "editCLK"
            addEditProduct.product = self?.product
            self?.viewController?.navigationController?.pushViewController(addEditProduct, animated: true)
        }, btnTwoTitle: CBtnDelete, btnTwoStyle: .default) { [weak self](alert) in
            guard let _ = self else { return }
            self?.viewController?.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: CMessageDeleteProduct, btnOneTitle: CBtnYes, btnOneTapped: { [weak self] (alert) in
                guard let _ = self else { return }
                
                APIRequest.shared().deleteProduct(productId:self?.product.productID ?? ""){ [weak self](response, error) in
                    guard let _ = self else { return }
                    if response != nil {
                        GCDMainThread.async {
                            
                            ProductHelper<UIViewController>.deleteProduct(
                                controller: self?.viewController,
                                refreshCnt: [StoreListVC.self,ProductSearchVC.self],
                                productID: (self?.product.productID.toInt ?? 0),
                                isLoader: true
                            )
                            
                            
                        }
                    }
                }
                
            }, btnTwoTitle: CBtnNo, btnTwoTapped: nil)
        }
    }
    
    func reportProduct(){
        
        self.viewController?.presentActionsheetWithOneButton(actionSheetTitle: nil, actionSheetMessage: nil, btnOneTitle: CReport, btnOneStyle: .default) { [weak self] (alert) in
            guard let _ = self else { return }
            if let productReport : ProductReportVC = CStoryboardProduct.instantiateViewController(withIdentifier: "ProductReportVC") as? ProductReportVC{
                productReport.productId = self?.product.product_id.toInt ?? 0
                self?.viewController?.navigationController?.pushViewController(productReport, animated: true)
            }
        }
    }
}
