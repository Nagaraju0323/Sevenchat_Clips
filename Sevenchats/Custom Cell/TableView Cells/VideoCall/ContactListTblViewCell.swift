//
//  ContactListTblViewCell.swift
//  MI-VideoCall
//
//  Created by mac-00016 on 02/10/19.
//  Copyright © 2019 Mac-00016. All rights reserved.
//

import UIKit

class ContactListTblViewCell: UITableViewCell {

    //MARK:-
    //MARK: - ------- Public Properties
    @IBOutlet weak var imgUserProfile: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var btnVideoCall: UIButton!
    @IBOutlet weak var btnAudioCall: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configData(userName: String) {
        lblUserName.text = userName
    }
}
