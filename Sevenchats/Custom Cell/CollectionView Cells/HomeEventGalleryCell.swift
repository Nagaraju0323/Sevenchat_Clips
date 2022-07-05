//
//  HomeEventGalleryCell.swift
//  Sevenchats
//
//  Created by mac-0005 on 10/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class HomeEventGalleryCell: UICollectionViewCell {
    
    @IBOutlet weak var blurImgView : BlurImageView!
    @IBOutlet weak var ImgView : UIImageView!
    @IBOutlet weak var imgVideoIcon : UIImageView!
    @IBOutlet weak var vwBackgroundImg : MIGenericView!
    
    @IBOutlet weak var imgblurIcon : UIView!
    @IBOutlet weak var imagecountIcon : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
