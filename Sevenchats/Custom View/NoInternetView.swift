//
//  NoInternetView.swift
//  Sevenchats
//
//  Created by mac-0005 on 04/04/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//

import UIKit

class NoInternetView: UIView {

    @IBOutlet weak var lblNoInternet : UILabel!
    @IBOutlet weak var lblCheckYourConnection : UILabel!
    @IBOutlet weak var btnTryAgain : UIButton!
    
    override func awakeFromNib() {
        lblNoInternet.text = CNoInternet
        lblCheckYourConnection.text = CPleaseCheckYourIntenet
        btnTryAgain.setTitle(CTryAgain, for: .normal)
    }
}
