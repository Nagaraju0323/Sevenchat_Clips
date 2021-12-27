//
//  MDLStoreAppliedFilter.swift
//  Sevenchats
//
//  Created by mac-00020 on 01/10/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//

import Foundation

//MARK: - MDLStoreAppliedFilter
class MDLStoreAppliedFilter {
    
    var search : String!
    var category : String!
    var status : Int!
    var categoryName : String!
    var sort : ProductSort!
    
    init(search : String = "",category : String = "",categoryName : String = "",status : Int = 0,sort : ProductSort = .NewToOld) {
        self.search = search
        self.category = category
        self.categoryName = categoryName
        self.status = status
        self.sort = sort
    }
}
