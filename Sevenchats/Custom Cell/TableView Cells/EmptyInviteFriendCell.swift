//
//  EmptyInviteFriendCell.swift
//  Sevenchats
//
//  Created by mac-00020 on 25/02/20.
//  Copyright © 2020 mac-0005. All rights reserved.
//
/*********************************************************
 * Author  : Chandrika.R                                 *
 * Model   : EmptyInviteFriendCell                       *
 * Changes :                                             *
 *                                                       *
 ********************************************************/

import UIKit

class EmptyInviteFriendCell: UITableViewCell {

    @IBOutlet var lblText : MIGenericLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        self.lblText.text = CInviteConnectNoFriend
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
