//
//  ConnectAllHeaderView.swift
//  Sevenchats
//
//  Created by mac-00020 on 25/02/20.
//  Copyright © 2020 mac-0005. All rights reserved.
//

import UIKit

class ConnectAllHeaderView: UITableViewHeaderFooterView {

    @IBOutlet var lblSelectAll : UILabel!
    @IBOutlet var imgSelectAllFriend : UIImageView!
    @IBOutlet var btnSelectAllFriend : UIButton!

    var onConnectAll : ((UIButton)->Void)?
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        lblSelectAll.text = CConnectAll
    }
    
    @IBAction func onConnectAllPressed(_ sender : UIButton){
        onConnectAll?(sender)
    }
}
