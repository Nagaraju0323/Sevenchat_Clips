//
//  EventListTblCell.swift
//  Sevenchats
//
//  Created by mac-0005 on 23/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class EventListTblCell: UITableViewCell {

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
    
}
