//
//  QuotesTblCell.swift
//  Sevenchats
//
//  Created by mac-0005 on 21/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Nagaraju K and Chandrika R                                 *
 * Model   : RestrictedFilesVC                           *
 * Description :  QuotesTblCell                          *
 *                                                       *
 ********************************************************/
import UIKit

class QuotesTblCell: UITableViewCell {

    @IBOutlet var viewContainer : UIView!
    @IBOutlet var lblQuotes : UILabel!
    @IBOutlet var lblQuotesWriter : UILabel!
    @IBOutlet var lblQuotesPostDate : UILabel!
    
    @IBOutlet weak var btnShare: MIGenericButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        GCDMainThread.async {
            self.btnShare.isHidden = true
            self.btnShare.setTitle("  " + CBtnShare, for: .normal)
            self.viewContainer.layer.cornerRadius = 8
            self.viewContainer.shadow(color: CRGB(r: 237, g: 236, b: 226), shadowOffset: CGSize(width: 0, height: 3), shadowRadius: 8.0, shadowOpacity: 5.0)
        }
    }

}
