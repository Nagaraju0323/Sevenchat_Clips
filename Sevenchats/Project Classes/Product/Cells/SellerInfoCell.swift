//
//  SellerInfoCell.swift
//  Sevenchats
//
//  Created by mac-00020 on 26/08/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//

import UIKit

class SellerInfoCell: UITableViewCell, ProductDetailBaseCell  {
    
    //MARK: - IBOutlet/Object/Variable Declaration
    @IBOutlet weak var imgSeller: UIImageView!
    @IBOutlet weak var lblSellerInfo: MIGenericLabel!
    @IBOutlet weak var lblSellerName: MIGenericLabel!
    
    @IBOutlet weak var btnContactSeller: MIGenericButton!
    @IBOutlet weak var btnBuyNow: MIGenericButton!
    
    var modelData: MDLSellerInfo!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        self.imgSeller.layer.cornerRadius = self.imgSeller.frame.size.width / 2
        lblSellerInfo.text = CSellerInformation
//        lblSellerInfo.text = "cellerinformation"
        btnContactSeller.setTitle(CContactSeller, for: .normal)
        btnBuyNow.setTitle(CBuyNow, for: .normal)
    }
    
    func configure(withModel: ProductBaseModel) {
        guard let _model = withModel as? MDLSellerInfo else {
            return
        }
        self.modelData = _model
        lblSellerName.text = self.modelData.firstName + " " + self.modelData.lastName
        imgSeller.loadImageFromUrl(self.modelData.userProfileImage, true)
        btnBuyNow.isHidden = (self.modelData.paymentType == .Offline)
    }
    
    @IBAction func onContactSellerPressed(_ sender:UIButton){
        if let contactInfo : ContactSellerVC = CStoryboardProduct.instantiateViewController(withIdentifier: "ContactSellerVC") as? ContactSellerVC{
            contactInfo.productIDs = self.modelData.productID
//            contactInfo.sellerID = self.modelData.userId
            contactInfo.productEmailid = self.modelData.pemail
            contactInfo.productUserName = self.modelData.firstName + " " + self.modelData.lastName
            contactInfo.productMobile = self.modelData.pmobileNum
            
            self.viewController?.navigationController?.pushViewController(contactInfo, animated: true)
            
        }
    }

    @IBAction func onBuyPressd(_ sender:UIButton){
    }
    
    @IBAction func onUserPressed(_ sender : UIButton){
//        appDelegate.moveOnProfileScreen(self.modelData.userId.description, self.viewController)
        appDelegate.moveOnProfileScreenNew(self.modelData.userId.description, self.modelData.pemail.description, self.viewController)
    }
}
