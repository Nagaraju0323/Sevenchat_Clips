//
//  MDLProduct.swift
//  Sevenchats
//
//  Created by mac-00020 on 24/09/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//


/*********************************************************
 * Author  : Nagaraju K and Chandrika R                                 *
 * Model   : MDLProduct                                  *
 * Description :                                         *
 *                                                       *
 ********************************************************/


import Foundation

class MDLProduct : NSObject, ProductBaseModel {
    
    var tpye: ProductDetailCellType {return .ProductDetailCell }
    
    var address : String!
    var category : String!
    var categoryId : Int!
    var createdAt : String!
    var currencyId : Int!
    var currencyName : String!
    var countryID : Int!
    var stateID : Int!
    var cityID : Int!
    var countryName : String!
    var stateName : String!
    var cityName : String!
    var firstName : String!
    var galleryImages : [MDLAddMedia] = []
    var galleyimagesArray:String!
    var id : Int!
    var productId : String!
    var isLike : Int!
    var isSold : Int!
    var lastName : String!
    var productDescription : String!
    var productPrice : String!
    var productTitle : String!
    var shareUrl : String!
    var totalComment : Int!
    var totalComments : String!
    var totalLike : Int!
    var userId : Int!
    var userProfileImage : String!
    var email:String!
    var product_id:String!
    var productState:String!
    var userAsLiked :String!
    var likes :String!
    var comments:String!
    var productID:String!
    var mobileNum:String!
    var lastdateSelling:String!
    var productUserID:String!
    var productsubCategroy:String!
    var paymentType : ProductPaymentMode{
        return ProductPaymentMode(rawValue: strPaymentType.toInt ?? 1) ?? .Offline
    }
    fileprivate var strPaymentType : String!
    var latitude : String!
    var longitude : String!
    var lastDateSelling : Double!
    var formatedPriceAmount : String{
        let priceString = productPrice ?? ""
        return self.currencyName + " " + priceString
    }
    
    init(fromDictionary dictionary: [String:Any]){
        productID  = dictionary["product_id"]  as? String ?? ""
        address = dictionary["location"] as? String ?? ""
        category = dictionary["category_name"] as? String ?? ""
        categoryId = dictionary["category_id"] as? Int ?? 0
        createdAt = dictionary["created_at"] as? String ?? ""
        if dictionary["currency_id"] is Int{
            currencyId = dictionary["currency_id"] as? Int ?? 0
        }else{
            let strID = dictionary["currency_id"] as? String ?? "0"
            currencyId = strID.toInt ?? 0
        }
        currencyName = dictionary["currency_name"] as? String ?? ""
        productsubCategroy = dictionary["category_level1"] as? String ?? ""
        firstName = dictionary["first_name"] as? String ?? ""
        id = dictionary["product_id"] as? Int ?? 0
        isLike = dictionary["is_like"] as? Int ?? 0
        isSold = dictionary["is_sold"] as? Int ?? 0
        lastName = dictionary["last_name"] as? String ?? ""
        productDescription = dictionary["description"] as? String ?? ""
        productPrice = dictionary["cost"] as? String ?? ""
        productTitle = dictionary["product_title"] as? String ?? ""
        shareUrl = dictionary["share_url"] as? String ?? ""
        totalComment = dictionary["total_comment"] as? Int ?? 0
        totalLike = dictionary["total_like"] as? Int ?? 0
        userId = dictionary["user_id"] as? Int ?? 0
        productUserID = dictionary["user_id"] as? String ?? ""
        userProfileImage = dictionary["profile_image"] as? String ?? ""
        latitude = dictionary["latitude"] as? String ?? ""
        longitude = dictionary["longitude"]  as? String ?? ""
        strPaymentType = dictionary["payment_type"] as? String ?? "1"
        lastDateSelling = dictionary["created_at"] as? Double ?? 0.0
        product_id = dictionary["product_id"] as? String ?? ""
        userAsLiked = dictionary["user_has_liked"] as? String ?? ""
        likes = dictionary["likes"] as? String ?? ""
        totalComments = dictionary["comments"] as? String ?? ""
        if dictionary["country_id"] is Int{
            countryID = dictionary["country_id"] as? Int ?? 0
        }else{
            let strID = dictionary["country_id"] as? String ?? "0"
            countryID = strID.toInt ?? 0
        }
        if dictionary["state_id"] is Int{
            stateID = dictionary["state_id"] as? Int ?? 0
        }else{
            let strID = dictionary["state_id"] as? String ?? "0"
            stateID = strID.toInt ?? 0
        }
        if dictionary["city_id"] is Int{
            cityID = dictionary["city_id"] as? Int ?? 0
        }else{
            let strID = dictionary["city_id"] as? String ?? "0"
            cityID = strID.toInt ?? 0
        }
        if dictionary["available_status"] is String{
            productState = dictionary["available_status"] as? String ?? ""
        }
        countryName = dictionary["country_name"] as? String ?? ""
        stateName = dictionary["state_name"] as? String ?? ""
        cityName = dictionary["city_name"] as? String ?? ""
        email = dictionary["user_email"] as? String ?? ""
        email = dictionary["email"] as? String ?? ""
        mobileNum = dictionary["mobile"] as? String ?? ""
        lastdateSelling = dictionary["last_date_selling"] as? String ?? ""
        let arrGallerys = dictionary["product_image"] as? String
        galleyimagesArray = dictionary["product_image"] as? String
        let dict = arrGallerys?.convertToDictionary()
        let arrDictGallery = dict ?? []
        print("arrGallerys\(arrDictGallery)")
        for imgData in arrDictGallery{
            let imgID = imgData.valueForString(key: CId)
            let media = MDLAddMedia(mediaID: imgID)
            media.isFromGallery = false
            media.uploadMediaStatus = .Succeed
            media.assetType = AssetTypes(rawValue: imgData.valueForInt(key: CType) ?? 0) ?? AssetTypes.Image
            if media.assetType == .Video ||  imgData.valueForString(key: "mime") == "video"{
                media.serverImgURL = imgData.valueForString(key: "image_path")
                media.url = imgData.valueForString(key: "image_path")
            }else{
                media.serverImgURL = imgData.valueForString(key: "image_path")
                print("imagepath:::::::",imgData.valueForString(key: "image_path"))
            }
            self.galleryImages.append(media)
        }
        
    }
}

extension String{
    func convertToDictionary() -> [[String: Any]]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
            } catch {
            }
        }
        return nil
    }
    
}
