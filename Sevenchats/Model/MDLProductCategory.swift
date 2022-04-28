//
//  MDLProductCategory.swift
//  Sevenchats
//
//  Created by mac-00020 on 23/09/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Nagaraju K and Chandrika R                                 *
 * Model   : MDLProductCategory                          *
 * Description :                                         *
 *                                                       *
 ********************************************************/

import Foundation


//MARK: - MDLProductCategory
public class MDLProductCategory {
    
    public var categoryId : String!
    public var categoryName : String!
    var isSelected = false
    init(name:String,isSelected:Bool = false) {
        self.categoryName = name
        self.isSelected = isSelected
    }
    init(fromDictionary dictionary: [String:Any]){
        categoryId = dictionary["category_id"] as? String ?? ""
        categoryName = dictionary["category_name"] as? String ?? ""
    }
}
