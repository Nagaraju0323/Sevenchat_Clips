//
//  TblSharedFileCell.swift
//  Sevenchats
//
//  Created by mac-00018 on 31/05/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//

import UIKit

class TblSharedFileDetailsCell: UITableViewCell {

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
    @IBOutlet weak var btnDelete: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
