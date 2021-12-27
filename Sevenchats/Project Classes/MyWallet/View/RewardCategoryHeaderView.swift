//
//  RewardCategoryHeaderView.swift
//  Sevenchats
//
//  Created by mac-00020 on 01/02/20.
//  Copyright © 2020 mac-0005. All rights reserved.
//

import UIKit

class RewardCategoryHeaderView: UITableViewHeaderFooterView {

    //MARK: - IBOutlet/Object/Variable Declaration -
    @IBOutlet weak var lblSummary: MIGenericLabel!
    
    override func draw(_ rect: CGRect) {
        self.lblSummary.text = CSummary
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
