//
//  HomeAddPostTblCell.swift
//  Sevenchats
//
//  Created by mac-00020 on 27/05/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//

import UIKit

class HomeAddPostTblCell: UITableViewCell {

    @IBOutlet var lblTitle : UILabel!
    @IBOutlet var imgPost : UIImageView!
    @IBOutlet var lblSeperater : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
