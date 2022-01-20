//
//  GroupMemberListCell.swift
//  Sevenchats
//
//  Created by mac-00020 on 28/08/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//

import UIKit

class GroupMemberListCell: UITableViewCell {

    //MARK: - IBOutlet/Object/Variable Declaration
    @IBOutlet weak var lblName: MIGenericLabel!
    @IBOutlet weak var btnRadio: UIButton!{
        didSet{
            btnRadio.setImage(UIImage(named:"ic_circle_unselect"), for: .normal)
            btnRadio.setImage(UIImage(named:"ic_circle_select"), for: .selected)
        }
    }
    
    var model : MDLFriendsList!{
        didSet{
            lblName.text = model.fullName
            btnRadio.isSelected = model.isSelected
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
    }
    
}
