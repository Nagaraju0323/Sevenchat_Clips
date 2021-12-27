//
//  AddImagesCollViewCell.swift
//  QAAR
//
//  Created by mac-00012 on 17/07/19.
//  Copyright © 2019 00017. All rights reserved.
//

import UIKit

class VideoViewCollViewCell: UICollectionViewCell {

    @IBOutlet weak var videoView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configData(imageStr: String) {
        videoView.image = UIImage(named: imageStr)
    }
}
