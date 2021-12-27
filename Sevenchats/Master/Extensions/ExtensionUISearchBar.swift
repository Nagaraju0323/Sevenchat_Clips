//
//  ExtensionUISearchBar.swift
//  Sevenchats
//
//  Created by mac-00020 on 05/06/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//

import Foundation
import UIKit

extension UISearchBar {
    
    func change(textFont : UIFont?) {
        
        if #available(iOS 13.0, *) {
            searchTextField.font  = textFont
            searchTextField.textColor = .black
            return
        }
        for view: UIView in (self.subviews) {
            
            if let textField = view as? UITextField {
                textField.font = textFont
                textField.textColor = .black
            }
        }
    }
}
