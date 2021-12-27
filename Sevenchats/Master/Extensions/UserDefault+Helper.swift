//
//  UserDefault+Helper.swift
//  Sevenchats
//
//  Created by APPLE on 01/12/21.
//  Copyright © 2021 mac-00020. All rights reserved.
//

import Foundation
import UIKit

private enum Defaults: String {
   case userChatLastMsg = "userChatLastMsg"
  
}

final class UserDefaultHelper {

static var userChatLastMsg: Bool? {
    set{
        _set(value: newValue, key: .userChatLastMsg)
    } get {
        return _get(valueForKay: .userChatLastMsg) as? Bool
    }
}

private static func _set(value: Any?, key: Defaults) {
    UserDefaults.standard.set(value, forKey: key.rawValue)
}

private static func _get(valueForKay key: Defaults)-> Any? {
    return UserDefaults.standard.value(forKey: key.rawValue)
}

static func deleteuserChatLastMsg() {
    UserDefaults.standard.removeObject(forKey: Defaults.userChatLastMsg.rawValue)
 }

}



