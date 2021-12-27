//
//  MDLStateAndCity.swift
//  Sevenchats
//
//  Created by mac-00020 on 23/09/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//

import Foundation


//MARK: - MDLState
public class MDLState {
    
    public var stateId : Int!
    public var stateName : String!
    
    init(fromDictionary dictionary: [String:Any]){
        stateId = dictionary["state_id"] as? Int ?? 0
        stateName = dictionary["state_name"] as? String ?? ""
    }
}

//MARK: - MDLCity
public class MDLCity {
    
    public var cityId : Int!
    public var cityName : String!
    
    init(fromDictionary dictionary: [String:Any]){
        cityId = dictionary["city_id"] as? Int ?? 0
        cityName = dictionary["city_name"] as? String ?? ""
    }
}
