//
//  LikesTblCell.swift
//  Sevenchats
//
//  Created by mac-0005 on 16/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//
/*********************************************************
 * Author  : Chandrika.R                                 *
 * Model   : LikesTblCell                                *
 * Changes :  LikesTblCell                               *
 *                                                       *
 ********************************************************/

import UIKit

class LikesTblCell: UITableViewCell {

    @IBOutlet var imgUser : UIImageView!
    @IBOutlet var lblUserName : UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        GCDMainThread.async {
            self.imgUser.layer.cornerRadius = self.imgUser.frame.size.width/2
        }
    }

}
