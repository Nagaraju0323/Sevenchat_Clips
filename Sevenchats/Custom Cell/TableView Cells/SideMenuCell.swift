//
//  SideMenuCell.swift
//  Sevenchats
//
//  Created by mac-0005 on 09/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//
/*********************************************************
 * Author  : Chandrika.R                                 *
 * Model   : SideMenuCell                                *
 * Changes :                                             *
 *                                                       *
 ********************************************************/

import UIKit

class SideMenuCell: UITableViewCell {
    @IBOutlet var viewLine : UIView!
    @IBOutlet var btnImage : UIButton!
    @IBOutlet var lblTitle : UILabel!
    @IBOutlet var lblNotficationCount : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        lblNotficationCount.layer.masksToBounds = true
        lblNotficationCount.layer.cornerRadius = lblNotficationCount.frame.height/2
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
