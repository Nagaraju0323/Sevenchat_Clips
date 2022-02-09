//
//  InviteConnect.swift
//  Sevenchats
//
//  Created by APPLE on 09/02/22.
//  Copyright © 2022 mac-00020. All rights reserved.
//

import Foundation

class MDLInivte : NSObject{
    
    var common_id : String!
    var user_id : String!
    init(fromDictionary dictionary: [String:Any]){
        
        common_id = dictionary["mobile"] as? String ?? ""
        user_id = dictionary["user_id"] as? String ?? ""
    }
}



class MDLUsers:NSObject{
        
    var user_id : String?
    var lang_name : String?
    var profile_image : String?
    var cover_image : String?
    var email : String?
    var first_name : String?
    var last_name : String?
    var gender : String?
    var mobile : String?
    var dob : String?
    var short_biography : String?
    var relationship : String?
    var education_name : String?
    var religion : String?
    var employment_status : String?
    var profession : String?
    var annual_income : String?
    var address : String?
    var latitude : String?
    var longitude : String?
    var user_type : String?
    var account_type : String?
    var city_name : String?
    var state_name : String?
    var country_name : String?
    var country_code : String?
    var articles : String?
    var forums : String?
    var tweets : String?
    var shouts : String?
    var gallery : String?
    var events : String?
    var polls : String?
    var likes : String?
    var push_notify : String?
    var email_notify : String?
    var visible_to_friend : String?
    var visible_to_other : String?
//    var friends : [Friends]?
    var status_id : String?
    
    var block_unblock_status:String?
    var check_status:String?
    var common_id:String?
    var friend_block_unblock_status:String?
    var friend_report_status:String?
    var friend_status:String?
    
    init(fromDictionary dictionary: [String:Any]){
        
        user_id =  dictionary["user_id"] as? String ?? ""
        profile_image = dictionary["profile_image"] as? String ?? ""
        email = dictionary["email"] as? String ?? ""
        first_name = dictionary["first_name"] as? String ?? ""
        last_name = dictionary["last_name"] as? String ?? ""
        mobile = dictionary["mobile"] as? String ?? ""
        block_unblock_status = dictionary["block_unblock_status"] as? String ?? "0"
        check_status = dictionary["block_unblock_status"] as? String ?? "1"
        common_id = dictionary["mobile"] as? String ?? ""
        friend_block_unblock_status = dictionary["friend_block_unblock_status"] as? String ?? "0"
        friend_report_status = dictionary["friend_block_unblock_status"] as? String ?? "0"
        friend_status = dictionary["friend_block_unblock_status"] as? String ?? "0"
        
        
    }
    
}
