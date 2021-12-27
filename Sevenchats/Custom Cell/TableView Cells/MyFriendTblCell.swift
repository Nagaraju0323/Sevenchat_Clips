//
//  MyFriendTblCell.swift
//  Sevenchats
//
//  Created by mac-0005 on 30/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class MyFriendTblCell: UITableViewCell {

    @IBOutlet var lblUserName : UILabel!
    @IBOutlet var imgUser : UIImageView!
    @IBOutlet var btnUnfriendCancelRequest : UIButton!
    @IBOutlet var btnAcceptRequest : UIButton!
    @IBOutlet var btnRejectRequest : UIButton!
    
    @IBOutlet var viewAcceptReject : UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        GCDMainThread.async {
            self.imgUser.layer.cornerRadius = self.imgUser.frame.size.width / 2
        }
    }

}
