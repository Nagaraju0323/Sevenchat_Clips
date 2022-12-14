//
//  ClListviewCell.swift
//  Sevenchats
//
//  Created by CHINNA on 2/20/21.
//  Copyright © 2021 mac-00020. All rights reserved.
//

/*********************************************************
 * Author  : Nagaraju K and Chandrika R                                 *
 * Model   : ClListviewCell                              *
 * Changes :                                             *
 *                                                       *
 ********************************************************/

import UIKit

class ClListviewCell: UICollectionViewCell {
    
        @IBOutlet weak var lblFileName: UILabel!
        @IBOutlet weak var lblFileDate: UILabel!
        @IBOutlet weak var imgV: UIImageView!
        @IBOutlet weak var btnStatus: UIButton!
        @IBOutlet weak var vwShareFile: UIView!
        @IBOutlet weak var btnShareFile: UIButton!
    
    @IBOutlet weak var viewBack: UIView!{
        didSet {
            self.viewBack.layer.cornerRadius = ((CScreenWidth/375)*(self.viewBack.frame.height))/12
        }
    }
    @IBOutlet weak var viewMain: UIView! {
        didSet {
            self.viewMain.layer.cornerRadius = ((CScreenWidth/375)*(self.viewMain.frame.height))/12
        }
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        // Initialization code
    }
    
    
    func updateStatus(status:UploadMediaStatus){
        switch status{
        case .Pendding:
            self.vwShareFile.isHidden = true
            self.btnStatus.setImage(UIImage(named: "ic_close_green"), for: .normal)
        case .Succeed:
            //self.btnStatus.setImage(UIImage(named: "ic_checkmark"), for: .normal)
            self.vwShareFile.isHidden = false
            self.btnStatus.setImage(UIImage(named: "ic_close_green"), for: .normal)
        case .Failed, .FailedWithRetry:
            self.vwShareFile.isHidden = true
            self.btnStatus.setImage(UIImage(named: "ic_group_info"), for: .normal)
        case .FileExist:
            self.vwShareFile.isHidden = true
            self.btnStatus.setImage(UIImage(named: "ic_group_info"), for: .normal)
        }
    }
    
}


class DynamicHeightCollectionView: UICollectionView {
    override func layoutSubviews() {
        super.layoutSubviews()
        if bounds.size != intrinsicContentSize {
            self.invalidateIntrinsicContentSize()
        }
    }
    override var intrinsicContentSize: CGSize {
        return collectionViewLayout.collectionViewContentSize
    }
}
