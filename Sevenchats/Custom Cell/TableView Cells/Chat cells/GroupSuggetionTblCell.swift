//
//  GroupSuggetionTblCell.swift
//  Sevenchats
//
//  Created by mac-0005 on 31/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//


import UIKit

class GroupSuggetionTblCell: UITableViewCell {

    @IBOutlet var lblGroupName : UILabel!
    @IBOutlet var lblGroupType : UILabel!
    @IBOutlet var btnJoin : UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        GCDMainThread.async {
            self.btnJoin.layer.cornerRadius = 3
        }
    }

    

}
