//
//  NewsTblCell.swift
//  Sevenchats
//
//  Created by mac-00017 on 09/10/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class NewsTblCell: UITableViewCell {

    @IBOutlet weak var vwMainContainer : UIView!
    @IBOutlet weak var vwSubContainer : UIView!
    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var lblDesc : UILabel!
    @IBOutlet weak var lblProvidedBy : UILabel!
    @IBOutlet weak var imgVNews : UIImageView!
    @IBOutlet weak var btnShare : MIGenericButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        GCDMainThread.async {
            
            self.vwSubContainer.layer.cornerRadius = 8
            self.vwMainContainer.layer.cornerRadius = 8
            self.vwMainContainer.shadow(color: CRGB(r: 237, g: 236, b: 226), shadowOffset: CGSize(width: 0, height: 5), shadowRadius: 10.0, shadowOpacity: 10.0)
            self.btnShare.setTitle("  " + CBtnShare, for: .normal)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
