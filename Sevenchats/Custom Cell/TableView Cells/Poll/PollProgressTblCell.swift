//
//  PollProgressTblCell.swift
//  ProgressViewDemo
//
//  Created by mac-00018 on 29/05/19.
//  Copyright © 2019 mac-00018. All rights reserved.
//

/*********************************************************
 * Author  : Chandrika.R                                 *
 * Model   : RestrictedFilesVC                           *
 * Description : PollProgressTblCell                     *
 ********************************************************/

import UIKit

class PollProgressTblCell: UITableViewCell {
    
    @IBOutlet weak var progressV: UIProgressView!
    @IBOutlet weak var lblName: MIGenericLabel!
    @IBOutlet weak var lblPercentage: MIGenericLabel!
    @IBOutlet weak var btnCheckAnwer: UIButton!
    @IBOutlet weak var btnSelectAnwer: UIButton!
    var didSelected : ((Int)->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        self.btnCheckAnwer.setImage(UIImage(named: "new-moon-2"), for: .normal)
        self.btnCheckAnwer.setImage(UIImage(named: "checked-4"), for: .selected)
        //progressV.transform = progressV.transform.scaledBy(x: 1, y: 2)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func onCheckAnswer(_ sender:UIButton){
        self.btnCheckAnwer.isSelected = !self.btnCheckAnwer.isSelected
        didSelected?(sender.tag)
    }
}
