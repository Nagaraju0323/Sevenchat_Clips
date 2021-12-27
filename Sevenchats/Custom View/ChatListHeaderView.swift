//
//  ChatListHeaderView.swift
//  Nerd
//
//  Created by Mac-00014 on 17/04/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

class ChatListHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var vWBg : UIView! {
        didSet {
            vWBg.layer.cornerRadius = vWBg.frame.height / 2
        }
    }
    @IBOutlet var lblDate : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let radians = atan2f(Float(self.transform.b), Float(self.transform.a))
        let degrees = Double(radians) * (180 / .pi)
        if (degrees == 0)
        {
            self.transform = CGAffineTransform(rotationAngle: .pi)
        }
    }

}
