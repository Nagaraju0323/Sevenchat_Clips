//
//  MDLRewardSummary.swift
//  Sevenchats
//
//  Created by mac-00020 on 15/02/20.
//  Copyright © 2020 mac-0005. All rights reserved.
//

import Foundation

enum RewardCategory : Int {
    case AdminCorrection = 1
    case SellPosts
    case Advertisements
    case AdFreeSubscription
    case UsageTime
    case Profile
    case Connections
    case Posts
    case Feedback
}

struct MDLRewards {
    var name : String = ""
    var level : String = ""
    var points : Int = 0
}

struct MDLRewardSummary {
    
    var name : String!
    var points : String!
    var id : Int!
    var type : RewardCategory {
        return RewardCategory(rawValue: id) ?? RewardCategory.Posts
    }
    init(fromDictionary dictionary: [String:Any]) {
        id = dictionary["category_id"] as? Int ?? 0
        name = dictionary["category_name"] as? String ?? ""
        points = dictionary["points"] as? String ?? ""
    }
}

//struct MDLRewardDetail {
//
//    var id : Int!
//    var pointsConfigId : Int!
//    var points : Int!
//    var messageText : String!
//    fileprivate var _creditedDate : Double!
//    var creditedDate : String {
//        let date = Date(timeIntervalSince1970: _creditedDate)
//        let dateFormatter = DateFormatter()
//        dateFormatter.locale = DateFormatter.shared().locale
//        dateFormatter.dateFormat = "dd MMM yyyy, hh:mm a"
//        return dateFormatter.string(from: date)
//    }
//
//    var friendId : Int!
//    var postId : Int!
//    var postType : Int!
//    var advertisementId : String!
//    var productId : Int!
//    var detailText : String!
//    var friendImage : String!
//    var isPostImage : Int!
//
//    init(fromDictionary dictionary: [String:Any]) {
//
//        id = dictionary["id"] as? Int ?? 0
//        pointsConfigId = dictionary["points_config_id"] as? Int ?? 0
//        points = dictionary["points"] as? Int ?? 0
//        messageText = dictionary["message_text"] as? String ?? ""
//        _creditedDate = dictionary["credited_date"] as? Double ?? 0
//        friendId = dictionary["friend_id"] as? Int ?? 0
//        postId = dictionary["post_id"] as? Int ?? 0
//        postType = dictionary["post_type"] as? Int ?? 0
//        advertisementId = dictionary["advertisement_id"] as? String ?? ""
//        productId = dictionary["product_id"] as? Int ?? 0
//        detailText = dictionary["detail_text"] as? String ?? ""
//        friendImage = dictionary["friend_image"] as? String ?? ""
//        isPostImage = dictionary["is_post_image"] as? Int ?? 0
//
//    }
//}



struct MDLRewardDetail {
    
    var id : Int!
    var pointsConfigId : Int!
    var points : Int!
    var messageText : String!
//    fileprivate var _creditedDate : Double!
//    var creditedDate : String {
//        let date = Date(timeIntervalSince1970: _creditedDate)
//        let dateFormatter = DateFormatter()
//        dateFormatter.locale = DateFormatter.shared().locale
//        dateFormatter.dateFormat = "dd MMM yyyy, hh:mm a"
//        return dateFormatter.string(from: date)
//    }
    
    var friendId : Int!
    var postId : Int!
    var postType : String!
    var advertisementId : String!
    var productId : Int!
    var detailText : String!
    var friendImage : String!
    var isPostImage : Int!
    var title:String!
    var name:String!
    var icon:String!
    var category:String!
    
    init(fromDictionary dictionary: [String:Any]) {
        
       
//        _creditedDate = dictionary["credited_date"] as? Double ?? 0
        friendId = dictionary["friend_id"] as? Int ?? 0
        postId = dictionary["post_id"] as? Int ?? 0
        advertisementId = dictionary["advertisement_id"] as? String ?? ""
        productId = dictionary["product_id"] as? Int ?? 0
//        detailText = dictionary["detail_text"] as? String ?? ""
        friendImage = dictionary["friend_image"] as? String ?? ""
        isPostImage = dictionary["is_post_image"] as? Int ?? 0
        
        
        points = (dictionary["points"] as? String ?? "0").toInt
        messageText = dictionary["message"] as? String ?? ""
        id = dictionary["rewards_history_id"] as? Int ?? 0
        pointsConfigId = (dictionary["target_id"] as? String ?? "").toInt
        title = dictionary["title"] as? String ?? ""
        name = dictionary["name"] as? String ?? ""
        icon = dictionary["icon"] as? String ?? ""
        postType = dictionary["type"] as? String ?? ""
        detailText = dictionary["detail_text"] as? String ?? ""
        category = dictionary["category"] as? String ?? ""
    }
}
