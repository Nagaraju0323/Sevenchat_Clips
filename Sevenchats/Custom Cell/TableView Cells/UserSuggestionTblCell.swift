//
//  UserSuggestionTblCell.swift
//  Sevenchats
//
//  Created by mac-0005 on 28/12/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//
/*********************************************************
 * Author  : Chandrika.R                                 *
 * Model   : UserSuggestionTblCell                       *
 * Changes :                                             *
 *                                                       *
 ********************************************************/

import UIKit

class UserSuggestionTblCell: UITableViewCell {

    @IBOutlet weak var lblUserName : UILabel!
    @IBOutlet weak var imgUser : UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        GCDMainThread.async {
            self.imgUser.layer.cornerRadius = self.imgUser.frame.width/2
        }
    }
}
