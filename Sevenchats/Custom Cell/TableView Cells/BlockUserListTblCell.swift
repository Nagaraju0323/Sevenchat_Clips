//
//  BlockUserListTblCell.swift
//  Sevenchats
//
//  Created by mac-0005 on 21/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Nagaraju K and Chandrika R                                 *
 * Model   : AudioVideoButtonCell                        *
 * Description : BlockUserListTblCell                    *
 *                                                       *
 ********************************************************/

import UIKit

class BlockUserListTblCell: UITableViewCell {

    @IBOutlet var imgUser : UIImageView!
    @IBOutlet var lblUserName : UILabel!
    @IBOutlet var btnUnblock : UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        btnUnblock.setTitle(CUnblock, for: .normal)
        GCDMainThread.async {
            self.imgUser.layer.cornerRadius = self.imgUser.frame.size.width/2
            self.imgUser.layer.borderWidth = 2
            self.imgUser.layer.borderColor = #colorLiteral(red: 0, green: 0.7881455421, blue: 0.7100172639, alpha: 1)
        }
    }

}
