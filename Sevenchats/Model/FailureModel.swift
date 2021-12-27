//
//  FailureModel.swift
//  SF-GenericAPIClass
//
//  Created by mac-00016 on 03/05/19.
//  Copyright © 2019 Mac-00016. All rights reserved.
//

//Please Go through the Instruction File to Follow The Monitoring steps of Api Responce diffrent cases.
import Foundation
import ObjectMapper

/**
 * For Map API Data in This Model, this model is called automatically in case of failure, This model is used for login,signup,coverimage,userdata,verificationcode,edit failure case.
 *
 * - parameter test: songs
 */
class FailureModel : Mappable {
    
    var message :  String = ""
    var status_code :Int = 0
    
    required convenience public init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        
        // For Login
        message <- map["message"]
        status_code <- map["status_code"]
    }
}

