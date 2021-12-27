//
//  MDLStorage.swift
//  Sevenchats
//
//  Created by mac-00020 on 17/06/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//

import Foundation

let UnitOfBytes : Double = 1024.0

class MDLStorage : NSObject {
    
    var percent : Double = 0.0
   
    var uploaded : Double = 0.0
    var uploadedUnit : String{
        get{ return format(bytes: uploaded) }
    }
    
    var remaining : Double = 0.0
    var remainingUnit : String{
        get{ return format(bytes: remaining) }
    }
    var totalSpace : Double{
        get{ return uploaded + remaining}
    }
    var totalSpaceUnit : String{
        get{ return format(bytes: totalSpace.rounded()) }
    }
    
    init(fromDictionary dictionary: [String:Any]){
        percent = dictionary["percent"] as? Double ?? 0.0
        remaining = dictionary["remaining"] as? Double ?? 0.0
        uploaded = dictionary["uploaded"] as? Double ?? 0.0
    }
    
    func format(bytes: Double) -> String {
        guard bytes > 0 else {
            return "0 MB"
        }
        /*if bytes < 1{
            return "\(bytes) MB"
        }*/
        if bytes < UnitOfBytes{
            //return "\(bytes) MB"
            return String(format: "%.2f MB", bytes)
        }
        if bytes < (UnitOfBytes * UnitOfBytes){
            //return "\(bytes / UnitOfBytes) GB"
            return String(format: "%.2f GB", (bytes / UnitOfBytes))
        }
        if bytes < (UnitOfBytes * UnitOfBytes * UnitOfBytes){
            //return "\(bytes / (UnitOfBytes * UnitOfBytes)) TB"
            return String(format: "%.2f TB", (bytes / (UnitOfBytes * UnitOfBytes)))
        }
        if bytes < (UnitOfBytes * UnitOfBytes * UnitOfBytes * UnitOfBytes){
            //return "\(bytes / (UnitOfBytes * UnitOfBytes * UnitOfBytes)) PB"
            return String(format: "%.2f PB", (UnitOfBytes * UnitOfBytes * UnitOfBytes))
        }
        return ""
    }
}
