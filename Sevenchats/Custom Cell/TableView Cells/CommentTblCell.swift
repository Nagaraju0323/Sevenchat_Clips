//
//  CommentTblCell.swift
//  Sevenchats
//
//  Created by mac-0005 on 17/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit
import ActiveLabel

class CommentTblCell: UITableViewCell {

    @IBOutlet var imgUser : UIImageView!
    @IBOutlet var lblUserName : UILabel!
    @IBOutlet var lblCommentText : ActiveLabel!
    @IBOutlet var lblCommentPostDate : UILabel!
    @IBOutlet var btnUserImage : UIButton!
    @IBOutlet var btnUserName : UIButton!
    @IBOutlet var btnMoreOption : UIButton!
    @IBOutlet var viewDevider : UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.btnMoreOption.isHidden = true
        GCDMainThread.async {
            self.imgUser.layer.cornerRadius = self.imgUser.frame.size.width/2
        }
    }
}
