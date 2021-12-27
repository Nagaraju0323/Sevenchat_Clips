//
//  RestrictedFileTblCell.swift
//  Sevenchats
//
//  Created by mac-00020 on 01/07/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//

import UIKit

class RestrictedFileTblCell: UITableViewCell {

    @IBOutlet weak var lblFileName: UILabel!
    @IBOutlet weak var lblDivider: UILabel!
    var data: MDLRestractedFile!{
        didSet{
            self.lblFileName.text = data.fileName ?? ""
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
