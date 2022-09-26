//
//  TblFriendsCell.swift
//  Sevenchats
//
//  Created by mac-00018 on 05/06/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//

import UIKit
import SDWebImage

class TblFriendsCell: UITableViewCell {
    
    @IBOutlet weak var imgVFriend: UIImageView!
    @IBOutlet weak var imgVFriendGIF: FLAnimatedImageView!
    @IBOutlet weak var lblFriendName: UILabel!
    
    @IBOutlet weak var btnSelectFriend: UIButton!
    @IBOutlet weak var btnProfileImage: UIButton!
    @IBOutlet weak var btnUserName: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imgVFriend.roundView()
        self.btnSelectFriend.setImage(UIImage(named: "ic_select"), for: .selected)
        self.btnSelectFriend.setImage(UIImage(named: "ic_unselect"), for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
