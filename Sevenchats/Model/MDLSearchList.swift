//
//  MDLSearchList.swift
//  Sevenchats
//
//  Created by APPLE on 15/01/22.
//  Copyright © 2022 mac-00020. All rights reserved.
//

/*********************************************************
 * Author  : Chandrika.R                                 *
 * Model   : MDLSearchList                               *
 * Description :                                         *
 *                                                       *
 ********************************************************/

import Foundation


class MDLSearchList : NSObject{

    var request_status : String!
    var friend_status : String!
    var senders_id : String!
    init(fromDictionary dictionary: [String:Any]){
        
        request_status = dictionary["request_status"] as? String
        friend_status = dictionary["friend_status"] as? String
        senders_id = dictionary["senders_id"] as? String
    }
}

