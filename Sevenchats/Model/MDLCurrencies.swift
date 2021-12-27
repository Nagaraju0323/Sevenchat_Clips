//
//  MDLCurrencies.swift
//  Sevenchats
//
//  Created by mac-00020 on 23/09/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//

import Foundation

//MARK: - MDLCurrencies
public class MDLCurrencies {
    
    public var currencyId : Int!
    public var currencyName : String!
    public var currencyiso : String!
    
    init(fromDictionary dictionary: [String:Any]){
        currencyId = dictionary["currency_id"] as? Int ?? 0
        currencyName = dictionary["currency_name"] as? String ?? ""
        currencyiso = dictionary["iso"] as? String ?? ""
    }
}
