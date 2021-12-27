//
//  AddParticipantsTblCell.swift
//  Sevenchats
//
//  Created by mac-0005 on 31/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class AddParticipantsTblCell: UITableViewCell {

    @IBOutlet var lblUserName : UILabel!
    @IBOutlet var imgUser : UIImageView!
    @IBOutlet var btnSelect : UIButton!
    @IBOutlet var btnDeleteUser : UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
        GCDMainThread.async {
            self.imgUser.layer.cornerRadius = self.imgUser.frame.size.width/2
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
