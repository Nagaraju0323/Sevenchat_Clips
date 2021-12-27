//
//  PostStoriesCollCell.swift
//  Sevenchats
//
//  Created by APPLE on 08/03/21.
//  Copyright © 2021 mac-00020. All rights reserved.
//

import UIKit

class PostStoriesCollCell: UICollectionViewCell {

    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var lblUserName: MIGenericLabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImgView.layer.masksToBounds = true
        profileImgView.layer.borderWidth = 2.5
        profileImgView.layer.borderColor = #colorLiteral(red: 0, green: 0.7529411912, blue: 0.650980413, alpha: 1)
        self.profileImgView.layer.cornerRadius = self.profileImgView.bounds.height / 2
        self.profileImgView.layer.cornerRadius = self.profileImgView.frame.size.width/2
        
        // Initialization code
    }

}
