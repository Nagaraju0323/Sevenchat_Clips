//
//  GroupInfoUserTblCell.swift
//  Sevenchats
//
//  Created by mac-0005 on 01/09/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Nagaraju K and Chandrika R                                 *
 * Model   : GroupInfoUserTblCell                        *
 * Changes : GroupInfoUserTblCell                        *
 *                                                       *
 ********************************************************/

import UIKit
import SDWebImage

class GroupInfoUserTblCell: UITableViewCell {
    @IBOutlet var lblUserName : UILabel!
    @IBOutlet var imgUser : UIImageView!
    @IBOutlet var imgUserGIF : FLAnimatedImageView!
    @IBOutlet var btnAdmin : UIButton!
    @IBOutlet var btnDeleteMember : UIButton!
    @IBOutlet var btnUserInfo : UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        GCDMainThread.async {
            self.imgUser.layer.cornerRadius = self.imgUser.frame.size.width/2
            self.imgUser.layer.borderWidth = 2
            self.imgUser.layer.borderColor = #colorLiteral(red: 0, green: 0.7881455421, blue: 0.7100172639, alpha: 1)
            self.btnAdmin.layer.cornerRadius = 3
            
            self.imgUserGIF.layer.cornerRadius = self.imgUserGIF.frame.size.width/2
            self.imgUserGIF.layer.borderWidth = 2
            self.imgUserGIF.layer.borderColor = #colorLiteral(red: 0, green: 0.7881455421, blue: 0.7100172639, alpha: 1)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.btnAdmin.setTitle("  \(CGroupAdmin)  ", for: .normal)
    }

}
