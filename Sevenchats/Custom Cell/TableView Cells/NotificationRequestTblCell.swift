//
//  NotificationRequestTblCell.swift
//  Sevenchats
//
//  Created by Mac-0006 on 23/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//
/*********************************************************
 * Author  : Chandrika.R                                 *
 * Model   : NotificationRequestTblCell                  *
 * Changes :                                             *
 *                                                       *
 ********************************************************/

import UIKit
import ActiveLabel

class NotificationRequestTblCell: UITableViewCell {

    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblNotificationdetails: ActiveLabel!
    @IBOutlet weak var btnCancel: MIGenericButton!
    @IBOutlet weak var btnAccept: MIGenericButton!
    @IBOutlet weak var lblDate: MIGenericLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblNotificationdetails.font = UIFont(name: lblNotificationdetails.font.fontName, size: round(CScreenWidth * (lblNotificationdetails.font.pointSize / 414)))
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        imgUser.roundView()
        
        if Localization.sharedInstance.applicationFlowWithLanguageRTL() {
            lblNotificationdetails.textAlignment = .right
        }else{
            lblNotificationdetails.textAlignment = .left
        }
    }
    
}
