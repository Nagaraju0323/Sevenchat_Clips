//
//  HomeAddFrdTblCell.swift
//  Sevenchats
//
//  Created by mac-00017 on 04/09/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class HomeAddFrdTblCell: UITableViewCell {

    @IBOutlet var viewMainContainer : UIView!
    @IBOutlet var viewSubContainer : UIView!
    @IBOutlet var imgUser : UIImageView!
    @IBOutlet var lblUserName : UILabel!
    @IBOutlet var btnAddFrd : UIButton!
    @IBOutlet var btnAccept : UIButton!
    @IBOutlet var btnReject : UIButton!
    @IBOutlet var viewAcceptReject : UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        GCDMainThread.async {
            self.btnAddFrd.layer.cornerRadius = 5
            
            self.viewSubContainer.layer.cornerRadius = 8
            self.viewMainContainer.layer.cornerRadius = 8
            self.viewMainContainer.shadow(color: CRGB(r: 237, g: 236, b: 226), shadowOffset: CGSize(width: 0, height: 5), shadowRadius: 10.0, shadowOpacity: 10.0)
            
            self.imgUser.layer.cornerRadius = self.imgUser.frame.size.width/2
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
