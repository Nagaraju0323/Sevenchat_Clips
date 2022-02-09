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
    init(fromDictionary dictionary: [String:Any]){
        
        user_id =  dictionary["user_id"] as? String ?? ""
        lang_name = dictionary["lang_name"] as? String ?? ""
        profile_image = dictionary["profile_image"] as? String ?? ""
        cover_image = dictionary["cover_image"] as? String ?? ""
        email = dictionary["email"] as? String ?? ""
        first_name = dictionary["first_name"] as? String ?? ""
        last_name = dictionary["last_name"] as? String ?? ""
        gender = dictionary["gender"] as? String ?? ""
        mobile = dictionary["mobile"] as? String ?? ""
        dob = dictionary["dob"] as? String ?? ""
        short_biography = dictionary["short_biography"] as? String ?? ""
        relationship = dictionary["relationship"] as? String ?? ""
        education_name = dictionary["education_name"] as? String ?? ""
        religion = dictionary["religion"] as? String ?? ""
        employment_status =  dictionary["employment_status"] as? String ?? ""
        profession = dictionary["profession"] as? String ?? ""
        annual_income = dictionary["annual_income"] as? String ?? ""
        address = dictionary["address"] as? String ?? ""
        latitude = dictionary["latitude"] as? String ?? ""
        longitude = dictionary["longitude"] as? String ?? ""
        user_type = dictionary["user_type"] as? String ?? ""
        account_type = dictionary["account_type"] as? String ?? ""
        city_name = dictionary["city_name"] as? String ?? ""
        state_name = dictionary["state_name"] as? String ?? ""
        country_name = dictionary["country_name"] as? String ?? ""
        country_code = dictionary["country_code"] as? String ?? ""
        articles = dictionary["articles"] as? String ?? ""
        forums = dictionary["forums"] as? String ?? ""
        tweets = dictionary["tweets"] as? String ?? ""
        shouts = dictionary["shouts"] as? String ?? ""
        gallery = dictionary["gallery"] as? String ?? ""
        events = dictionary["events"] as? String ?? ""
        polls = dictionary["polls"] as? String ?? ""
        likes = dictionary["likes"] as? String ?? ""
        push_notify = dictionary["push_notify"] as? String ?? ""
        email_notify = dictionary["email_notify"] as? String ?? ""
        visible_to_friend = dictionary["visible_to_friend"] as? String ?? ""
        visible_to_other = dictionary["visible_to_other"] as? String ?? ""
    }
    
}
