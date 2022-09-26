//
//  CommentTblCell.swift
//  Sevenchats
//
//  Created by mac-0005 on 17/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit
import ActiveLabel
import SDWebImage

class CommentTblCell: UITableViewCell {

    @IBOutlet var imgUser : UIImageView!
    @IBOutlet var lblUserName : UILabel!
    @IBOutlet var lblCommentText : ActiveLabel!
    @IBOutlet var lblCommentPostDate : UILabel!
    @IBOutlet var btnUserImage : UIButton!
    @IBOutlet var btnUserName : UIButton!
    @IBOutlet var btnMoreOption : UIButton!
    @IBOutlet var viewDevider : UIView!
    @IBOutlet weak var imgUserGIF: FLAnimatedImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.btnMoreOption.isHidden = true
        GCDMainThread.async {
            self.imgUser.layer.cornerRadius = self.imgUser.frame.size.width/2
            self.imgUser.layer.borderWidth = 2
            self.imgUser.layer.borderColor = #colorLiteral(red: 0, green: 0.7881455421, blue: 0.7100172639, alpha: 1)
            
            self.imgUserGIF.layer.cornerRadius = self.imgUserGIF.frame.size.width/2
            self.imgUserGIF.layer.borderWidth = 2
            self.imgUserGIF.layer.borderColor = #colorLiteral(red: 0, green: 0.7881455421, blue: 0.7100172639, alpha: 1)
        }
    }
}
