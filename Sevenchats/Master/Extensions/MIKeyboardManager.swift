//
//  MIKeyboardManager.swift
//  Swifty_Master
//
//  Created by Mac-0002 on 15/11/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import Foundation
import UIKit

protocol MIKeyboardManagerDelegate : class {
    func keyboardWillShow(notification:Notification , keyboardHeight:CGFloat)
    func keyboardDidHide(notification:Notification)
}

class MIKeyboardManager  {
    
    private init() {}
    
    private static let miKeyboardManager:MIKeyboardManager = {
        let miKeyboardManager = MIKeyboardManager()
        return miKeyboardManager
    }()
    
    static var shared:MIKeyboardManager {
        return miKeyboardManager
    }
    
    weak var delegate:MIKeyboardManagerDelegate?
    
    func enableKeyboardNotification() {
        
        
        NotificationCenter.default.addObserver(MIKeyboardManager.shared, selector: #selector(self.keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(MIKeyboardManager.shared, selector: #selector(self.keyboardDidHide(notification:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    func disableKeyboardNotification() {
        
        NotificationCenter.default.removeObserver(MIKeyboardManager.shared, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(MIKeyboardManager.shared, name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    @objc  private func keyboardWillShow(notification:Notification) {
        
        if let info = notification.userInfo {
            
            if let keyboardRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                
                delegate?.keyboardWillShow(notification: notification, keyboardHeight: keyboardRect.height)
            }
        }
    }
    
    @objc private func keyboardDidHide(notification:Notification) {
        delegate?.keyboardDidHide(notification: notification)
    }
}
