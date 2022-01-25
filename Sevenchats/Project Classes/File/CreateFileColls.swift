//
//  CreateFileColls.swift
//  Sevenchats
//
//  Created by CHINNA on 2/28/21.
//  Copyright © 2021 mac-00020. All rights reserved.
//
/*********************************************************
 * Author  : Chandrika.R                                 *
 * Model   : CreateFileColls                             *
 * Description :                                         *
 * Create Files                                          *
 ********************************************************/


import UIKit

class CreateFileColls: UICollectionViewCell {

    
    @IBOutlet weak var viewBack: UIView!{
        didSet {
            self.viewBack.layer.cornerRadius = ((CScreenWidth/375)*(self.viewBack.frame.height))/10
        }
    }
    @IBOutlet weak var viewMain: UIView! {
        didSet {
            self.viewMain.layer.cornerRadius = ((CScreenWidth/375)*(self.viewMain.frame.height))/10
        }
    }
  
    @IBOutlet weak var lblFileName: UILabel!
    @IBOutlet weak var lblFileDate: UILabel!
    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var btnStatus: UIButton!
    @IBOutlet weak var vwShareFile: UIView!
    @IBOutlet weak var btnShareFile: UIButton!
    
    
    
    func updateStatus(status:UploadMediaStatus){
        switch status{
        case .Pendding:
            self.vwShareFile.isHidden = true
            self.btnStatus.setImage(UIImage(named: "ic_close_green"), for: .normal)
        case .Succeed:
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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
