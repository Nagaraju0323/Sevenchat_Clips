//
//  EventHldListTblCell.swift
//  Sevenchats
//
//  Created by APPLE on 22/03/21.
//  Copyright © 2021 mac-00020. All rights reserved.
//

/*********************************************************
 * Author  : Nagaraju K and Chandrika R                                 *
 * Model   : RestrictedFilesVC                           *
 * Description : EventHldListTblCell                     *
 *                                                       *
 ********************************************************/
import UIKit


class EventHldListTblCell: UITableViewCell {
 
    @IBOutlet weak var viewContainer : UIView!
    @IBOutlet weak var imgUser : UIImageView!
    @IBOutlet weak var lblEventDescription : UILabel!
    @IBOutlet weak var lblUserName : UILabel!
    @IBOutlet weak var lblEventDate : UILabel!
    @IBOutlet weak var btnProfileImg : UIButton!
    @IBOutlet weak var btnUserName : UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        GCDMainThread.async {
            self.imgUser.layer.cornerRadius = self.imgUser.frame.size.width/2
            self.viewContainer.shadow(color: CRGB(r: 237, g: 236, b: 226), shadowOffset: CGSize(width: 0, height: 5), shadowRadius: 5.0, shadowOpacity: 5.0)
        }
    }
    
    
  

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

