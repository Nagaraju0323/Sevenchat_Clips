//
//  CreateGroupHeader.swift
//  Sevenchats
//
//  Created by mac-0005 on 29/11/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class CreateGroupHeader: UIView {

    @IBOutlet var lblMemberCount : UILabel!
    @IBOutlet var btnAddMore : UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        btnAddMore.setTitle("+\(CGroupInfoAddMore)", for: .normal)
    }

}
