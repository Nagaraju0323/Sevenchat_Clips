//
//  AddParticipantsTblCell.swift
//  Sevenchats
//
//  Created by mac-0005 on 31/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit
import SDWebImage

class AddParticipantsTblCell: UITableViewCell {

    @IBOutlet var lblUserName : UILabel!
    @IBOutlet var imgUser : UIImageView!
    @IBOutlet var imgUserGIF : FLAnimatedImageView!
    @IBOutlet var btnSelect : UIButton!
    @IBOutlet var btnDeleteUser : UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
        GCDMainThread.async {
            self.imgUser.layer.cornerRadius = self.imgUser.frame.size.width/2
            self.imgUser.layer.borderWidth = 2
            self.imgUser.layer.borderColor = #colorLiteral(red: 0, green: 0.7881455421, blue: 0.7100172639, alpha: 1)
            
            self.imgUserGIF.layer.cornerRadius = self.imgUserGIF.frame.size.width/2
            self.imgUserGIF.layer.borderWidth = 2
            self.imgUserGIF.layer.borderColor = #colorLiteral(red: 0, green: 0.7881455421, blue: 0.7100172639, alpha: 1)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if Localization.sharedInstance.applicationFlowWithLanguageRTL() {
            lblUserName.textAlignment = .right
        }else{
            lblUserName.textAlignment = .left
        }
    }
}
