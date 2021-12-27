//
//  GalleryListCollCell.swift
//  Sevenchats
//
//  Created by mac-0005 on 23/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class GalleryListCollCell: UICollectionViewCell {
    
    @IBOutlet var viewContainer : UIView!
    @IBOutlet var lblImageNumber : UILabel!
    @IBOutlet var imgGallery : UIImageView!
    @IBOutlet var imgSelected : UIImageView!
    var strImagePath : String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        GCDMainThread.async {
            self.imgGallery.layer.cornerRadius = 8
            self.imgSelected.layer.cornerRadius = self.imgSelected.frame.size.width/2

            self.viewContainer.layer.cornerRadius = 8
            self.viewContainer.layer.masksToBounds = false
            self.viewContainer.layer.shadowColor = CRGB(r: 237, g: 236, b: 226).cgColor
            self.viewContainer.layer.shadowOpacity = 8
            self.viewContainer.layer.shadowOffset = CGSize(width: 0, height: 4)
            self.viewContainer.layer.shadowRadius = 8
            
            self.lblImageNumber.layer.cornerRadius = self.lblImageNumber.frame.size.width/2
            self.lblImageNumber.layer.borderWidth = 1
            self.lblImageNumber.layer.borderColor = UIColor.white.cgColor
            
        }
    }
}
