//
//  MDLPollOption.swift
//  Sevenchats
//
//  Created by mac-00020 on 12/06/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//

import Foundation

class MDLPollOption : NSObject{
    
    var pollId : Int!
    var pollText : String!
    var pollVotePer : Float!
    var pollUsers : [MDLPollUserList] = []
    var postId : String?
    var voteCount : Int = 0
    var username : String?
    var firstName : String!
    var lastName : String!
    var profileImage : String!
    init(fromDictionary dictionary: [String:Any]){
        
        pollId = dictionary["poll_id"] as? Int ?? 0
        username = dictionary["first_name"] as? String
        pollText = dictionary["poll_text"] as? String ?? ""
        pollVotePer = dictionary["poll_vote_per"] as? Float ?? "\(dictionary["poll_vote_per"] ?? "0.0")".toFloat ?? 0.0
        firstName = dictionary["first_name"] as? String ?? ""
        lastName = dictionary["last_name"] as? String ?? ""
        profileImage = dictionary["profile_image"] as? String ?? ""
        pollUsers.append(MDLPollUserList(fromDictionary: dictionary))

    }
    
    func toDictionary() -> [String:Any] {
        var dictionary = [String:Any]()
        if pollId != nil{
            dictionary["poll_id"] = pollId
        }
        if pollText != nil{
            dictionary["poll_text"] = pollText
        }
        if pollVotePer != nil{
            dictionary["poll_vote_per"] = pollVotePer
        }
        
        return dictionary
    }
}

class MDLPollOptionsNew {
    var firstName : String!
    var lastName : String!
    var profileImage : String!
    init(fromDictionary dictionary: [String:Any]){
        
        firstName = dictionary["first_name"] as? String ?? ""
        lastName = dictionary["last_name"] as? String ?? ""
        profileImage = dictionary["profile_image"] as? String ?? ""
    }
}


class MDLPollInformation : NSObject{
    
    var comments:String?
    var created_at :String?
    var first_name :String?
    var is_liked :String?
    var is_selected :String?
    var last_name: String?
    var likes :String?
    var options :String?
    var post_category :String?
    var post_id :String?
    var post_title :String?
    var profile_image:String?
    var results :String?
    var selected_persons:String?
    var shared_count :String?
    var shared_first_name :String?
    var shared_id :String?
    var shared_last_name :String?
    var shared_message :String?
    var shared_post_date :String?
    var shared_profile_image :String?
    var shared_type :String?
    var status_id :String?
    var targeted_audience :String?
    var total_count  : String?
    var type  : String?
    var updated_at : String?
    var user_email :String?
    var user_id :String?
    
    init(fromDictionary dictionary: [String:Any]){
        comments = dictionary["comments"] as? String ?? ""
        created_at = dictionary["created_at"] as? String ?? ""
        first_name = dictionary["first_name"] as? String ?? ""
        is_liked = dictionary["is_liked"] as? String ?? ""
        is_selected = dictionary["is_selected"] as? String ?? ""
        last_name = dictionary["last_name"] as? String ?? ""
        likes =  dictionary["likes"] as? String ?? ""
        options = dictionary["options"] as? String ?? ""
        post_category = dictionary["post_category"] as? String ?? ""
        post_id = dictionary["post_id"] as? String ?? ""
        post_title = dictionary["post_title"] as? String ?? ""
        profile_image = dictionary["profile_image"] as? String ?? ""
        results = dictionary["results"] as? String ?? ""
        selected_persons = dictionary["selected_persons"] as? String ?? ""
        shared_count = dictionary["shared_count"] as? String ?? ""
        shared_first_name = dictionary["shared_first_name"] as? String ?? ""
        shared_id = dictionary["shared_id"] as? String ?? ""
        shared_last_name = dictionary["shared_last_name"] as? String ?? ""
        shared_message = dictionary["shared_message"] as? String ?? ""
        shared_post_date = dictionary["shared_post_date"] as? String ?? ""
        shared_profile_image = dictionary["shared_profile_image"] as? String ?? ""
        shared_type = dictionary["shared_type"] as? String ?? ""
        status_id = dictionary["status_id"] as? String ?? ""
        targeted_audience = dictionary["targeted_audience"] as? String ?? ""
        total_count  = dictionary["total_count"] as? String ?? ""
        type  = dictionary["type"] as? String ?? ""
        updated_at = dictionary["updated_at"] as? String ?? ""
        user_email = dictionary["user_email"] as? String ?? ""
        user_id = dictionary["user_id"] as? String ?? ""
        
    }
}


