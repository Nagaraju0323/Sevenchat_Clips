//
//  ExtensionNSLayoutConstraint.swift
//  Sevenchats
//
//  Created by mac-00020 on 17/10/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//

import Foundation
import UIKit

public extension NSLayoutConstraint {
    
    func changeMultiplier(multiplier: CGFloat) -> NSLayoutConstraint {
        let newConstraint = NSLayoutConstraint(
            item: firstItem!,
            attribute: firstAttribute,
            relatedBy: relation,
            toItem: secondItem,
            attribute: secondAttribute,
            multiplier: multiplier,
            constant: constant)
        newConstraint.priority = priority
        
        NSLayoutConstraint.deactivate([self])
        NSLayoutConstraint.activate([newConstraint])
        
        return newConstraint
    }
}
