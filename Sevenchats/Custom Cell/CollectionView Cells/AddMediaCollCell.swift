//
//  AddMediaCollCell.swift
//  Sevenchats
//
//  Created by mac-00020 on 28/05/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//

import UIKit
//import Photos
//import AssetsLibrary
//import TLPhotoPicker

class AddMediaCollCell: UICollectionViewCell {

    @IBOutlet weak var imgView: BlurImageView!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var media : MDLAddMedia!{
        didSet{
            if let url = media.serverImgURL{
                self.imgView.loadImageFromUrl(url, false)
                self.media.isDownloadedFromiCloud = true
            }else {
                self.imgView.image = media.image
            }
            if media.isDownloadedFromiCloud{
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                //self.imgView.backgroundColor = .white
            }else{
                self.activityIndicator.startAnimating()
                self.activityIndicator.isHidden = false
                //self.imgView.backgroundColor = .lightGray
            }
            self.btnPlay.isHidden = !(media.assetType == .Video && media.isDownloadedFromiCloud)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
