//
//  ProductGalleryImagesCell.swift
//  Sevenchats
//
//  Created by mac-0005 on 10/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class ProductGalleryImagesCell: UICollectionViewCell {
    
  @IBOutlet weak var imgProduct : UIImageView!
    @IBOutlet weak var blurImgView : BlurImageView!
    
    @IBOutlet weak var imgVideoIcon : UIImageView!
    //@IBOutlet weak var vwBackgroundImg : MIGenericView!
    
    @IBOutlet weak var showImageBlur : UIView!
    @IBOutlet weak var showLabelCount : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
