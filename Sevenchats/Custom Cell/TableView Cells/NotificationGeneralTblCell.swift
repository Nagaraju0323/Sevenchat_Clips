//
//  NotificationGeneralTblCell.swift
//  Sevenchats
//
//  Created by Mac-0006 on 23/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit
import ActiveLabel

class NotificationGeneralTblCell: UITableViewCell {

    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblNotificationDetails: ActiveLabel!
    @IBOutlet weak var lblDate: MIGenericLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblNotificationDetails.font = UIFont(name: lblNotificationDetails.font.fontName, size: round(CScreenWidth * (lblNotificationDetails.font.pointSize / 414)))
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        imgUser.roundView()

        if Localization.sharedInstance.applicationFlowWithLanguageRTL() {
            lblNotificationDetails.textAlignment = .right
        }else{
            lblNotificationDetails.textAlignment = .left
        }
    }

}
