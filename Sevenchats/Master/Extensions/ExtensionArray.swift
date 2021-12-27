//
//  ExtensionArray.swift
//  Cam4Sell
//
//  Created by Mac-00014 on 01/12/17.
//  Copyright © 2017 Mac-00014. All rights reserved.
//

import Foundation
//MARK:-
//MARK:- Extension -
extension Array
{
    func mapValue(forKey:String) -> AnyObject
    {
        if let array = self as? Array<[String:AnyObject]>
        {
            return array.map({$0[forKey]! as AnyObject}) as AnyObject
        }
        return Array() as AnyObject
    }
    func filterValue(key:String, value:String, getValueForKey:String) -> AnyObject
    {
        
        if let array = self as? Array<[String:AnyObject]>
        {
            let object =  array.filter({
                $0[key] as! String ==  value }).first
           
            guard let objectValue = object![getValueForKey] else
            {
                return "" as AnyObject
            }
            
            return objectValue
                        
        }
        return "" as AnyObject
        
    }
    
    
}

extension Array where Element: Equatable {
    
    // Remove first collection element that is equal to the given `object`:
    mutating func remove(object: Element) {
        guard let index = index(of: object) else {return}
        remove(at: index)
    }
    
    /// This method will remove the all duplicate data from the array with the array return type.
    func removeDuplicates() -> [Element] {
        
        var result = [Element]()
        
        for value in self where !result.contains(value) {
            result.append(value)
        }
        
        return result
    }
}

extension Array where Element: Equatable {
    mutating func checkDuplicates() -> Bool {
        var result = [Element]()
        for value in self {
            if result.contains(value) {
                result.append(value)
            }
        }
        return (result.count > 1)
    }
}
