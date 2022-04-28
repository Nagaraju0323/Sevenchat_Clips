//
//  PSLTblCell.swift
//  Sevenchats
//
//  Created by CHANDU on 11/01/22.
//  Copyright © 2022 mac-00020. All rights reserved.
//

/*********************************************************
 * Author  : Nagaraju K and Chandrika R                                 *
 * Model   : PSLTblCell                                  *
 * Changes :                                             *
 *                                                       *
 ********************************************************/
import UIKit

class PSLTblCell: UITableViewCell {

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
        
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
