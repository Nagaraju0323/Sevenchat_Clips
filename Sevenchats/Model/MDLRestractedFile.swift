//
//  MDLRestractedFile.swift
//  Sevenchats
//
//  Created by mac-00020 on 01/07/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//

import Foundation

//MARK: - MDLRestractedFile
public struct MDLRestractedFile {
    
    public var fileName : String!
    public var id : Int!
    
    init(fromDictionary dictionary: [String:Any]) {
        fileName = dictionary["name"] as? String ?? ""
        id = dictionary["id"] as? Int ?? 0
    }
}

