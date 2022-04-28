//
//  MDLPollUserList.swift

/*********************************************************
 * Author  : Nagaraju K and Chandrika R                                 *
 * Model   : RestrictedFilesVC                           *
 * Changes :                                             *
 *                                                       *
 ********************************************************/

import Foundation

class MDLPollUserList : NSObject {

    var firstName : String!
    var lastName : String!
    var profileImage : String!
    var userId : Int!
    var userProfileImage : String!

    init(fromDictionary dictionary: [String:Any]){
        firstName = dictionary["first_name"] as? String ?? ""
        lastName = dictionary["last_name"] as? String ?? ""
        profileImage = dictionary["profile_image"] as? String ?? ""
        userId = dictionary["user_id"] as? Int ?? 0
        userProfileImage = dictionary["user_profile_image"] as? String ?? ""
        
    }
    
}
