//
//  intrestSubcategory.swift
//  Sevenchats
//
//  Created by APPLE on 14/09/21.
//  Copyright © 2021 mac-00020. All rights reserved.
//

import Foundation


public class MDLIntrestSubCategory {
    
    public var interestId : String!
    public var interestLevel1 : String!
    public var interestLevel2 : String!
    public var langName : String!
    public var statusId : String!
    public var createdAt : String!
    public var updatedAt : String!
   
    init(interestId:String,interestLevel1:String,interestLevel2:String,langName:String,statusId:String,createdAt:String,updatedAt:String) {
        self.interestId = interestId
        self.interestLevel1 = interestLevel1
        self.interestLevel2 = interestLevel2
        self.langName = langName
        self.statusId = statusId
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        
    }
    init(fromDictionary dictionary: [String:Any]){
        interestId = dictionary["interest_id"] as? String ?? ""
        interestLevel1 = dictionary["interest_level1"] as? String ?? ""
        interestLevel2 = dictionary["interest_level2"] as? String ?? ""
        langName = dictionary["lang_name"] as? String ?? ""
        statusId = dictionary["status_id"] as? String ?? ""
        createdAt = dictionary["created_at"] as? String ?? ""
        updatedAt = dictionary["updated_at"] as? String ?? ""
        
    }
}


public class MDLProductSubCategory {
    
    public var interestId : String!
    public var interestLevel1 : String!
    public var langName : String!
    public var statusId : String!
    public var createdAt : String!
    public var updatedAt : String!
   
    init(interestId:String,interestLevel1:String,interestLevel2:String,langName:String,statusId:String,createdAt:String,updatedAt:String) {
        self.interestId = interestId
        self.interestLevel1 = interestLevel1
      
        self.langName = langName
        self.statusId = statusId
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        
    }
    init(fromDictionary dictionary: [String:Any]){
        interestId = dictionary["category_id"] as? String ?? ""
        interestLevel1 = dictionary["category_level1"] as? String ?? ""
        langName = dictionary["lang_name"] as? String ?? ""
        statusId = dictionary["status_id"] as? String ?? ""
        createdAt = dictionary["created_at"] as? String ?? ""
        updatedAt = dictionary["updated_at"] as? String ?? ""
        
    }
}
