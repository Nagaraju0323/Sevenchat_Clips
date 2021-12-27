//
//  BlockBarButtonItem.swift
//  Link4Prof
//
//  Created by mac-00020 on 16/05/19.
//  Copyright © 2019 mac-00019. All rights reserved.
//

import Foundation
import UIKit

class BlockBarButtonItem: UIBarButtonItem {
    
    private var actionHandler: ((UIBarButtonItem?) -> Void)? = nil
    
    convenience init(title: String?, style: UIBarButtonItem.Style, actionHandler: ((UIBarButtonItem?) -> Void)?) {
        self.init(title: title, style: style, target: nil, action: #selector(barButtonItemPressed))
        self.target = self
        self.actionHandler = actionHandler
    }
    
    convenience init(image: UIImage?, style: UIBarButtonItem.Style, actionHandler: ((UIBarButtonItem?) -> Void)?) {
        self.init(image: image, style: style, target: nil, action: #selector(barButtonItemPressed))
        self.target = self
        self.actionHandler = actionHandler
    }
    
    @objc func barButtonItemPressed(sender: UIBarButtonItem) {
        actionHandler?(sender)
    }
}
