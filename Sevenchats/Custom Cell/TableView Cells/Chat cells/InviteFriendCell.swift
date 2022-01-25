//
//  InviteFriendCell.swift
//  Sevenchats
//
//  Created by mac-0005 on 08/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//
/*********************************************************
 * Author  : Chandrika.R                                 *
 * Model   : InviteFriendCell                            *
 * Changes :                                             *
 *                                                       *
 ********************************************************/

import UIKit

class InviteFriendCell: UITableViewCell {

    @IBOutlet var imgUser : UIImageView!
    @IBOutlet var imgUserType : UIImageView!
    @IBOutlet var lblUserName : UILabel!
    @IBOutlet var lblUserInfo : UILabel!
    @IBOutlet var btnInviteConnect : UIButton!
    @IBOutlet var btnInviteContentMove : UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        GCDMainThread.async {
            self.imgUser.layer.cornerRadius = self.imgUser.frame.size.width/2
            self.imgUserType.layer.cornerRadius = self.imgUserType.frame.size.width/2
        }
        
        if Localization.sharedInstance.applicationFlowWithLanguageRTL() {
            // Reverse Flow...
            btnInviteConnect.contentHorizontalAlignment = .left
        }else{
            // Normal Flow...
            btnInviteConnect.contentHorizontalAlignment = .right
        }

    }
}
