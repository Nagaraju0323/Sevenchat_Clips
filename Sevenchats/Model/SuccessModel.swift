//
//  LoginModel.swift
//  QAAR
//
//  Created by mac-00016 on 13/08/19.
//  Copyright © 2019 00017. All rights reserved.
//

import UIKit
import ObjectMapper

struct BindingSucess: Mappable {
    
    var meta : Meta?
    var data : BindingToken?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        meta <- map["meta"]
        data <- map["data"]
    }
}

struct SuccessModel: Mappable {
    
    var meta : Meta?
    var data : tokenData?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        meta <- map["meta"]
        data <- map["data"]
    }
}

struct tokenData : Mappable {
    
    var token: String = ""
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        
        token <- map["token"]
    }
}

struct BindingToken : Mappable {
    
    var bindingId: String = ""
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        
        bindingId <- map["binding_id"]
    }
}
