//
//  MDLFileList.swift
//  Sevenchats
//
//  Created by mac-00020 on 14/06/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//

import Foundation

class MDLFileList : NSObject{
    
    var createdAt : Int!
    var fileName : String!
    var id : Int!
    fileprivate var path : String!
    var thumbNail : String!
    var type : String!
    var filePath : String!{
        let escapedString = path.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        return escapedString ?? ""
    }
    
    var createdDate : String{
        get{
            if createdAt == 0{
               return ""
            }
            let date = Date(timeIntervalSince1970: Double(createdAt))
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            dateFormatter.locale = DateFormatter.shared().locale
            //dateFormatter.locale = NSLocale.current
            print(dateFormatter.string(from: date))
            return dateFormatter.string(from: date)
        }
    }
    
    init(fromDictionary dictionary: [String:Any]){
        createdAt = dictionary["created_at"] as? Int ?? 0
        fileName = dictionary["file_name"] as? String ?? ""
        id = dictionary["id"] as? Int ?? 0
        path = dictionary["path"] as? String ?? ""
        thumbNail = dictionary["thumb_nail"] as? String ?? ""
        type = dictionary["type"] as? String ?? ""
    }
}
