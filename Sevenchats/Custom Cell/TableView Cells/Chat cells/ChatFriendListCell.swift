//
//  ChatFriendListCell.swift
//  Sevenchats
//
//  Created by mac-0005 on 30/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class ChatFriendListCell: UITableViewCell {
    
    @IBOutlet var imgUser : UIImageView!
    @IBOutlet var lblUserName : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        GCDMainThread.async {
            self.imgUser.layer.cornerRadius = self.imgUser.frame.size.width/2
        }
    }
}
