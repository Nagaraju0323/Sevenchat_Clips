//
//  MessageDetailUserCell.swift
//  Sevenchats
//
//  Created by mac-0005 on 01/09/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Nagaraju K and Chandrika R                                 *
 * Model   : RestrictedFilesVC                           *
 * Changes :                                             *
 *                                                       *
 ********************************************************/

import UIKit

class MessageDetailUserCell: UITableViewCell {

    @IBOutlet var imgUser : UIImageView!
    @IBOutlet var lblUserName : UILabel!
    @IBOutlet var lblDeliverTime : UILabel!
    var messageInformation : TblMessages!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        GCDMainThread.async {
            self.imgUser.layer.cornerRadius = self.imgUser.frame.size.width/2
        }
    }
}

// MARK:- ------Configuration
// MARK:-
extension MessageDetailUserCell {
    func cellConfigureUserData(_ userInfo: [String : Any]) {
        self.imgUser.loadImageFromUrl(userInfo.valueForString(key: CProfileImage), true)
        self.lblUserName.text = userInfo.valueForString(key: CFullName)
        
        let localTimeStamp = DateFormatter.shared().ConvertGMTMillisecondsTimestampToLocalTimestamp(timestamp: userInfo.valueForDouble(key: CCreated_at) ?? 0.0) ?? 0.0
        let readTime = localTimeStamp / 1000
        self.lblDeliverTime.text = CDeliveredOn + ":" + " " + DateFormatter.dateStringFrom(timestamp: readTime, withFormate: "dd MMM, yyyy")
        
    }
}
