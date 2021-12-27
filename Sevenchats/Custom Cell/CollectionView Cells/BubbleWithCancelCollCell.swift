//
//  BubbleWithCancelCollCell.swift
//  Sevenchats
//
//  Created by mac-0005 on 17/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class BubbleWithCancelCollCell: UICollectionViewCell {
 
    @IBOutlet var lblBubbleText : UILabel!
    @IBOutlet var viewContainer : UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        GCDMainThread.async {
            self.viewContainer.layer.cornerRadius = self.viewContainer.frame.size.height/2
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
