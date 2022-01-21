//
//  MDLProductDetail.swift
//  Sevenchats
//
//  Created by mac-00020 on 26/08/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//

import Foundation

enum ProductDetailCellType: String{
    case ProductDetailCell
    case SellerInfoCell
    case AddReviewProductCell
    case ReviewProductCell
    case MakeAsSoldProduceCell
    
}

protocol ProductBaseModel {
    
    var tpye: ProductDetailCellType { get }
}

protocol ProductDetailBaseCell: class {
    func configure(withModel: ProductBaseModel)
}

//struct MDLProductDetail: ProductBaseModel {
//    var tpye: ProductDetailCellType {return .ProductDetailCell }
//}

struct MDLSellerInfo: ProductBaseModel {
    var tpye: ProductDetailCellType {return .SellerInfoCell }
    
    var userId : String!
    var id : Int!
    var userProfileImage : String!
    var firstName : String!
    var lastName : String!
    var productID : String!
    var pemail :String!
    var pmobileNum:String!
    var productDescription:String!
    
    var paymentType : ProductPaymentMode{
        return ProductPaymentMode(rawValue: strPaymentType.toInt ?? 1) ?? .Offline
    }
    fileprivate var strPaymentType : String!
    
    init(fromDictionary dictionary: [String:Any]){

        firstName = dictionary["first_name"] as? String ?? ""
        productDescription = dictionary["product_title"] as? String ?? ""
        productID = dictionary["product_id"] as? String ?? ""
        id = dictionary["id"] as? Int ?? 0
        lastName = dictionary["last_name"] as? String ?? ""
        userId = dictionary["user_id"] as? String ?? ""
        
//        userProfileImage = dictionary["user_profile_image"] as? String ?? ""
        userProfileImage = dictionary["profile_image"] as? String ?? ""
        strPaymentType = dictionary["payment_type"] as? String ?? "1"
        pemail = dictionary["email"] as? String ?? "1"
        pmobileNum = dictionary["mobile"] as? String ?? ""
        
    }
}

struct MDLMarkAsSold: ProductBaseModel {
    var tpye: ProductDetailCellType {return .MakeAsSoldProduceCell }
    var  available_status : String!
     var userEmail : String?
    init(fromDictionary dictionary: [String:Any]){
        available_status = dictionary["available_status"] as? String ?? ""
        userEmail = dictionary["user_email"] as? String ?? ""
        
    }
}

struct MDLProductAddRating: ProductBaseModel {
    var tpye: ProductDetailCellType {return .AddReviewProductCell }
    var id : Int!
    init(fromDictionary dictionary: [String:Any]){
        id = dictionary["id"] as? Int ?? 0
    }
}

struct MDLProductReview: ProductBaseModel {
    var tpye: ProductDetailCellType {return .ReviewProductCell }
}
