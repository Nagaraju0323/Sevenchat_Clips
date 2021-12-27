//
//  MaintenanceView.swift
//  Sevenchats
//
//  Created by mac-00020 on 27/12/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//

import UIKit

class MaintenanceView: UIView {

    
    @IBOutlet weak var lblDescription : UILabel!
    
    override func awakeFromNib() {
        //lblDescription.text = CMaintenanceMode
        lblDescription.textColor = ColorAppTheme
    }
}

