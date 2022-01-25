//
//  HomeHeaderTblCell.swift
//  Sevenchats
//
//  Created by mac-0005 on 17/09/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Chandrika.R                                 *
 * Model   : HomeArticleCell                             *
 * Changes :                                             *
 *                                                       *
 ********************************************************/

import UIKit

class HomeHeaderTblCell: UITableViewCell {

    @IBOutlet var viewSearchContainer : UIView!
    @IBOutlet var viewPostType : UIView!
    @IBOutlet var viewPostTypeContainer : UIView!
    @IBOutlet var btnSearch : UIButton!
    @IBOutlet var txtSearch : UITextField!
    @IBOutlet var lblAll : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        GCDMainThread.async {
            self.lblAll.text = CTypeAll
            
            self.txtSearch.placeholder = CSearch
            self.viewSearchContainer.layer.cornerRadius = 12
            self.viewSearchContainer.layer.masksToBounds = false
            self.viewSearchContainer.shadow(color: CRGB(r: 230, g: 235, b: 239), shadowOffset: CGSize(width: 0, height: 3), shadowRadius: 2.5, shadowOpacity: 2)
            
            self.viewPostType.layer.cornerRadius = self.viewPostType.frame.size.height/2
            self.viewPostTypeContainer.layer.cornerRadius = self.viewPostTypeContainer.frame.size.height/2
            self.viewPostTypeContainer.layer.masksToBounds = false
            self.viewPostTypeContainer.shadow(color: CRGB(r: 230, g: 235, b: 239), shadowOffset: CGSize(width: 0, height: 0), shadowRadius: 3.0, shadowOpacity: 2.0)
        }
    }
}
