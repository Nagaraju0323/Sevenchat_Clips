//
//  SettingsTblCell.swift
//  Sevenchats
//
//  Created by mac-0005 on 14/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Chandrika.R                                 *
 * Model   : SettingsTblCell                             *
 * Changes :                                             *
 *                                                       *
 ********************************************************/
import UIKit

class SettingsTblCell: UITableViewCell {
    
    @IBOutlet var lblTSettingText : UILabel!
    @IBOutlet var imgArrow : UIImageView!
    @IBOutlet var btnSwitch : UISwitch!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if Localization.sharedInstance.applicationFlowWithLanguageRTL() {
            // Reverse Flow...
            imgArrow.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        }else{
            // Normal Flow...
            imgArrow.transform = CGAffineTransform.identity
        }
    }
}
