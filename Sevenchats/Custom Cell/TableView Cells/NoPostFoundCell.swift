//
//  NoPostFoundCell.swift
//  Sevenchats
//
//  Created by mac-00020 on 04/07/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//

import UIKit

class NoPostFoundCell: UITableViewCell {

    @IBOutlet weak var lblMessage : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        //lblMessage.text = CMessageNoPost
        lblMessage.text = CToEnhanceFeed
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
