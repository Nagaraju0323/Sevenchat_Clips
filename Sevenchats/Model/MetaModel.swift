//
//  MetaModel.swift
//  FTLive
//
//  Created by mac-0005 on 23/04/19.
//  Copyright © 2019 00017. All rights reserved.
//

import Foundation
import ObjectMapper

struct Meta : Mappable {
    
    var code: Int = 0
    var message: String = ""
    var token : String?
    var newOffSet: Int = 0

    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        code <- map["status"]
        message <- map["message"]
        token <- map["token"]
        newOffSet <- map["new_offset"]
        
    }
}
