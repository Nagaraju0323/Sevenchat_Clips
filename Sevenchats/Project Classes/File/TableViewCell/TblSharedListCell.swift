//
//  TblSharedListCell.swift
//  Sevenchats
//
//  Created by mac-00018 on 05/06/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//

import UIKit

class TblSharedListCell: UITableViewCell {
    
    @IBOutlet weak var lblFriendName: UILabel!
    
    @IBOutlet weak var imgVFriend: UIImageView!{
        didSet {
             self.imgVFriend.roundView()
        }
    }
    
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var btnProfileImage: UIButton!
    @IBOutlet weak var btnUserName: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
