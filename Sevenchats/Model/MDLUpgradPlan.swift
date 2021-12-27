//
//  MDLUpgradPlan.swift
//  Sevenchats
//
//  Created by mac-00020 on 24/06/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//

import Foundation

enum StorageType : Int{
    case Monthly = 1
    case Yearly = 2
}

class MDLUpgradPlan : NSObject{
    
    var id : Int!
    var monthlyCost : String!
    var name : String!
    var yearlyCost : String!
    
    var iosProductIdMonthly : String!
    var iosProductIdYearly : String!
    var androidProductIdMonthly : String!
    var androidProductIdYearly : String!
    var storageType = StorageType.Monthly
    
    init(fromDictionary dictionary: [String:Any]){
        id = dictionary["id"] as? Int ?? 0
        monthlyCost = dictionary["monthly_cost"] as? String ?? ""
        name = dictionary["name"] as? String ?? ""
        yearlyCost = dictionary["yearly_cost"] as? String ?? ""
        
        iosProductIdMonthly = dictionary["ios_product_id_monthly"] as? String ?? ""
        iosProductIdYearly = dictionary["ios_product_id_yearly"] as? String ?? ""
        androidProductIdMonthly = dictionary["android_product_id_monthly"] as? String ?? ""
        androidProductIdYearly = dictionary["android_product_id_yearly"] as? String ?? ""
    }
}
