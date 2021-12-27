//
//  ExtensionString.swift
//  Swifty_Master
//
//  Created by Mac-0002 on 01/09/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import Foundation

// MARK: - Extension of String For Converting it TO Int AND URL.
extension String {
    
    /// A Computed Property (only getter) of Int For getting the Int? value from String.
    /// This Computed Property (only getter) returns Int? , it means this Computed Property (only getter) return nil value also , while using this Computed Property (only getter) please use if let. If you are not using if let and if this Computed Property (only getter) returns nil and when you are trying to unwrapped this value("Int!") then application will crash.
    var toInt:Int? {
        return Int(self)
    }
    
    var toDouble:Double? {
        return Double(self)
    }
    
    var toFloat:Float? {
        return Float(self)
    }
    
    
    /// A Computed Property (only getter) of URL For getting the URL from String.
    /// This Computed Property (only getter) returns URL? , it means this Computed Property (only getter) return nil value also , while using this Computed Property (only getter) please use if let. If you are not using if let and if this Computed Property (only getter) returns nil and when you are trying to unwrapped this value("URL!") then application will crash.
    var toURL:URL? {
        return URL(string: self)
    }
    
}

extension String {
    
    var trim:String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var isBlank:Bool {
        return self.trim.isEmpty
    }
    
    var isAlphanumeric:Bool {
      return !isBlank && rangeOfCharacter(from: .alphanumerics) != nil
    }
    
    var isValidEmail:Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let predicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return predicate.evaluate(with:self)
    }
    
    /*var isPasswordSpecialCharacterValid: Bool{
        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
        return self.rangeOfCharacter(from: characterset.inverted) != nil
    }*/
    
    var isValidPassword:Bool {
        
        let passwordRegEx = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[@$!%*#?&])[A-Za-z\\d@$!%*#?&]{8,}$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return predicate.evaluate(with:self)
        /*let passwordCharacters = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%").inverted
        let arrCharacters = self.components(separatedBy: passwordCharacters)
        return self == arrCharacters.joined(separator: "")*/
    }
    
    var isValidPhoneNo:Bool {
        
        let phoneCharacters = CharacterSet(charactersIn: "+0123456789").inverted
        let arrCharacters = self.components(separatedBy: phoneCharacters)
        return self == arrCharacters.joined(separator: "")
    }
    
    subscript (bounds: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start...end])
    }
    
    subscript (bounds: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
    }
}

extension String {
    func contains(find: String) -> Bool{
        return self.range(of: find) != nil
    }
    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
}

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: String.Encoding.unicode) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType:  NSAttributedString.DocumentType.html], documentAttributes: nil)
            
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}

extension StringProtocol where Index == String.Index {
    func nsRange(of string: String) -> NSRange {
        if let range = self.range(of: string) {
            return NSRange(range, in: self)
        }
        return NSMakeRange(0, 0)
    }
    
}

extension Collection {
    
    func toData() throws -> Data {
        return try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
    }
    
    var json: String {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: [.prettyPrinted])
            guard let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) else {
                print("Can't create string with data.")
                return "{}"
            }
            return jsonString
        } catch let parseError {
            print("json serialization error: \(parseError)")
            return "{}"
        }
    }
}

extension String {
    
    func toJson() -> [String:Any]? {
        guard let data = self.data(using: .utf8) else {
            return [String:Any]()
        }
        do {
            if let jsonObj = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String:Any]{
               return jsonObj
            } else {
                return nil
            }
        } catch let error as NSError {
            print(error)
        }
        return nil
    }
}


extension String {
   func replace(string:String, replacement:String) -> String {
       return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
   }

   func removeWhitespace() -> String {
       return self.replace(string: " ", replacement: "")
   }
   
    func stringBefore(_ delimiter: Character) -> String {
        if let index = firstIndex(of: delimiter) {
            return String(prefix(upTo: index))
        } else {
            return ""
        }
    }
    
    func stringAfter(_ delimiter: Character) -> String {
        if let index = firstIndex(of: delimiter) {
            return String(suffix(from: index).dropFirst())
        } else {
            return ""
        }
    }
    
    func chopPrefix(_ count: Int = 1) -> String {
            return substring(from: index(startIndex, offsetBy: count))
        }

        func chopSuffix(_ count: Int = 1) -> String {
            return substring(to: index(endIndex, offsetBy: -count))
        }
    
    func fileName() -> String {
        return URL(fileURLWithPath: self).deletingPathExtension().lastPathComponent
    }

    func fileExtension() -> String {
        return URL(fileURLWithPath: self).pathExtension
    }
 }



