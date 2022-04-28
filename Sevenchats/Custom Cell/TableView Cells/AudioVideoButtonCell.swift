//
//  AudioVideoButtonCell.swift
//  Sevenchats
//
//  Created by Ghanshyam on 09/04/20.
//  Copyright © 2020 mac-00020. All rights reserved.
//

/*********************************************************
 * Author  : Nagaraju K and Chandrika R                                 *
 * Model   : AudioVideoButtonCell                        *
 * Description : AudioVideoButtonCell                    *
 *                                                       *
 ********************************************************/

import UIKit

class AudioVideoButtonCell: UITableViewCell {

    @IBOutlet weak var btnAudioCall : MIGenericButton!
    @IBOutlet weak var btnVideoCall : MIGenericButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btnAudioCall.setTitle(CAudioCall, for: .normal)
        btnVideoCall.setTitle(CVideoCall, for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

