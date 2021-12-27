//
//  MDLFriendsList.swift

import Foundation


class MDLFriendsList : NSObject{

    var createdAt : Int!
    var datetime : Double!
    var firstName : String!
    var friendStatus : Int!
    var id : Int!
    var image : String!
    var lastName : String!
    var reportStatus : Int!
    var groupTitle : String! = ""
    var userId : Int!
    var isSelected = false
    var groupUsersId : [String] = []
    
    var fullName : String {
        return firstName + " " + lastName
    }
    
    init(fromDictionary dictionary: [String:Any]){
        firstName = dictionary["first_name"] as? String  ?? ""
        friendStatus = dictionary["friend_status"] as? Int
        id = dictionary["id"] as? Int
        image = dictionary["image"] as? String
        lastName = dictionary["last_name"] as? String  ?? ""
        reportStatus = dictionary["report_status"] as? Int
        userId = dictionary["user_id"] as? Int
        createdAt = dictionary["created_at"] as? Int ?? 0
    }
    
    init(forGroupUserList dictionary: [String:Any]){
        id = dictionary["group_id"] as? Int
        userId = dictionary["user_id"] as? Int
        firstName = dictionary["first_name"] as? String ?? ""
        lastName = dictionary["last_name"] as? String ?? ""
        image = dictionary["image"] as? String
    }
    
    init(forGroup dictionary: [String:Any]){
        
        id = dictionary["group_id"] as? Int
        groupTitle = dictionary["group_title"] as? String ?? ""
        image = dictionary["group_image"] as? String
        datetime = dictionary["datetime"] as? Double ?? 0
        let usersId = dictionary["group_users_id"] as? String ?? ""
        if !usersId.isEmpty {
            self.groupUsersId = usersId.components(separatedBy: ",")
        }
    }
}
