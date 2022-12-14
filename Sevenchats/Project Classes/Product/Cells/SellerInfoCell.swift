//
//  SellerInfoCell.swift
//  Sevenchats
//
//  Created by mac-00020 on 26/08/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Nagaraju K and Chandrika R                                 *
 * Model   : SellerInfoCell                           *
 * Changes :                                             *
 *                                                       *
 ********************************************************/

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
        self.imgSeller.layer.borderWidth = 2
        self.imgSeller.layer.borderColor = #colorLiteral(red: 0, green: 0.7881455421, blue: 0.7100172639, alpha: 1)
        lblSellerInfo.text = CSellerInformation
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
            
            guard let user_ID =  appDelegate.loginUser?.user_id.description else { return}
            guard let firstName = appDelegate.loginUser?.first_name else {return}
            guard let lastName = appDelegate.loginUser?.last_name else {return}
            let userName = "\(firstName) \(lastName)"
            var para  = [String:Any]()
            para = [
                "user_id"  : user_ID,
//                "userName" : userName,
                "reciver_userID"  : self.modelData.userId ?? "",
                "type_Details" : "productDetails"
                ]
            MIGeneralsAPI.shared().sendNotification(self.modelData.userId ?? "", userID: user_ID.description, subject: "Viewed your product \(self.modelData.productDescription ?? "") please click to view \(userName)", MsgType: "CHAT_MESSAGE", MsgSent:"", showDisplayContent: "Product Viewed", senderName: firstName + lastName, post_ID: para,shareLink: "sendContactSlrLink")
            contactInfo.productIDs = self.modelData.productID
            contactInfo.productEmailid = self.modelData.pemail
            contactInfo.productUserName = self.modelData.firstName + " " + self.modelData.lastName
            contactInfo.productMobile = self.modelData.pmobileNum
            
//            self.viewController?.navigationController?.pushViewController(contactInfo, animated: true)
        
            let alertWindow = UIWindow(frame: UIScreen.main.bounds)
                        alertWindow.rootViewController = UIViewController()
                        
                        let alertController = UIAlertController(title: "", message: CContactToSellerSuccessfully, preferredStyle: UIAlertController.Style.alert)
                        alertController.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.cancel, handler: { _ in
                            alertWindow.isHidden = true
                            //                            self?.postDetails(postID:self?.postID.toString ?? "")
                          
                            return
                        }))
                        
                        alertWindow.windowLevel = UIWindow.Level.alert + 1;
                        alertWindow.makeKeyAndVisible()
                        alertWindow.rootViewController?.present(alertController, animated: true, completion: nil)
        }
    }

    @IBAction func onBuyPressd(_ sender:UIButton){
    }
    
    @IBAction func onUserPressed(_ sender : UIButton){
        appDelegate.moveOnProfileScreenNew(self.modelData.userId.description, self.modelData.pemail.description, self.viewController)
    }
}
