//
//  GroupInfoUserTblCell.swift
//  Sevenchats
//
//  Created by mac-0005 on 01/09/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Chandrika.R                                 *
 * Model   : GroupInfoUserTblCell                        *
 * Changes : GroupInfoUserTblCell                        *
 *                                                       *
 ********************************************************/

import UIKit

class GroupInfoUserTblCell: UITableViewCell {
    @IBOutlet var lblUserName : UILabel!
    @IBOutlet var imgUser : UIImageView!
    @IBOutlet var btnAdmin : UIButton!
    @IBOutlet var btnDeleteMember : UIButton!
    @IBOutlet var btnUserInfo : UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        GCDMainThread.async {
            self.imgUser.layer.cornerRadius = self.imgUser.frame.size.width/2
            self.btnAdmin.layer.cornerRadius = 3
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.btnAdmin.setTitle("  \(CGroupAdmin)  ", for: .normal)
    }

}
