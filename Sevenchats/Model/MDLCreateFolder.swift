
//  MDLCreateFolder.swift

import Foundation


class MDLCreateFolder : NSObject,NSCopying{
    
    var createdAt : Int!
    var folderName : String!
    var id : Int!
    var isMyFolder : Int!
    var sharedBy : String!
    var folderId : Int!
    
    init(fromDictionary dictionary: [String:Any]) {
        createdAt = dictionary["created_at"] as? Int ?? 0
        folderName = dictionary["folder_name"] as? String ?? ""
        id = dictionary["id"] as? Int ?? 0
        isMyFolder = dictionary["is_my_folder"] as? Int ?? 0
        sharedBy = dictionary["shared_by"] as? String ?? ""
        
        if id == 0{
            folderId = dictionary["folder_id"] as? Int ?? 0
            id = folderId
        }
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = MDLCreateFolder(fromDictionary: [:])
        copy.createdAt = self.createdAt
        copy.folderName = self.folderName
        copy.id = self.id
        copy.isMyFolder = self.isMyFolder
        copy.sharedBy = self.sharedBy
        copy.folderId = self.folderId
        return copy
    }
}
