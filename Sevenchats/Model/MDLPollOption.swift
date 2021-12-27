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
//        pollUsers = []
//        for obj in dictionary["users"] as? [[String : Any]] ?? []{
//            pollUsers.append(MDLPollUserList(fromDictionary: obj))
//        }
    }
    
    /*func calculateVote(totalVote:Int){
        //Vote count = Percentace of vote * Total Vote / 100
        voteCount = pollVotePer * totalVote / 100
    }
    func getPercentaceOfVote(totalVote:Int) -> Int {
        //Percentace of vote = Vote count * 100 / Total Vote
        return voteCount * 100 / totalVote
    }*/
    
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



