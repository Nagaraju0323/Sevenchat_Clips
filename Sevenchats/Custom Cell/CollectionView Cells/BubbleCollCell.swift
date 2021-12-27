//
//  BubbleCollCell.swift
//  Sevenchats
//
//  Created by mac-0005 on 16/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class BubbleCollCell: UICollectionViewCell {
 
    @IBOutlet weak var lblCategory : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        GCDMainThread.async {
            self.layer.cornerRadius = self.frame.size.height/2
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if Localization.sharedInstance.applicationFlowWithLanguageRTL() {
            self.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        }else{
            self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
        
    }
}
