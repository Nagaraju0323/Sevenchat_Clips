//
//  FavWebSitesTblCell.swift
//  Sevenchats
//
//  Created by mac-0005 on 20/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Chandrika.R                                 *
 * Model   : FavWebSitesTblCell                          *
 * Changes :                                             *
 *                                                       *
 ********************************************************/

import UIKit

class FavWebSitesTblCell: UITableViewCell {

    @IBOutlet var viewMainContainer : UIView!
    @IBOutlet var viewSubContainer : UIView!
    @IBOutlet var lblWebSiteType : UILabel!
    @IBOutlet var lblWebSiteTitle : UILabel!
    @IBOutlet var lblWebSiteDescription : UILabel!
    @IBOutlet var lblWebSitePostDate : UILabel!
    @IBOutlet var btnLike : UIButton!
    @IBOutlet var btnLikeCount : UIButton!
    @IBOutlet var btnComment : UIButton!
    @IBOutlet var btnReport : UIButton!
    @IBOutlet var btnShare : UIButton!

    var likeCount = 0
    var commentCount = 0
    var commentCounts = ""
    var likeCounts = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        GCDMainThread.async {
            self.viewSubContainer.layer.cornerRadius = 8
            self.viewMainContainer.layer.cornerRadius = 8
            self.viewMainContainer.shadow(color: CRGB(r: 237, g: 236, b: 226), shadowOffset: CGSize(width: 0, height: 5), shadowRadius: 10.0, shadowOpacity: 10.0)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.updateUIAccordingToLanguage()
    }
   
    func updateUIAccordingToLanguage(){
        
        if Localization.sharedInstance.applicationFlowWithLanguageRTL() {
            // Reverse Flow...
            btnLike.contentHorizontalAlignment = .left
            btnLikeCount.contentHorizontalAlignment = .right
            btnComment.contentHorizontalAlignment = .right
        }else{
            // Normal Flow...
            btnLike.contentHorizontalAlignment = .right
            btnLikeCount.contentHorizontalAlignment = .left
            btnComment.contentHorizontalAlignment = .left
        }
    }

}
