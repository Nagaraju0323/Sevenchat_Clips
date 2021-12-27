//
//  PollVotesList.swift
//  Sevenchats
//
//  Created by mac-00020 on 07/06/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//

import UIKit

class PollVotesListTblCell: UITableViewCell {

    @IBOutlet weak var imgVProfile : UIImageView!
    @IBOutlet weak var lblName : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imgVProfile.roundView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
