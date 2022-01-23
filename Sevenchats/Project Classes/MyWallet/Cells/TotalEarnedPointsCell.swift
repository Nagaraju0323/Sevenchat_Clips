//
//  TotalEarnedPointsCell.swift
//  Sevenchats
//
//  Created by mac-00020 on 29/01/20.
//  Copyright © 2020 mac-0005. All rights reserved.
//

import UIKit

class TotalEarnedPointsCell: UITableViewCell {
    
    //MARK: - IBOutlet/Object/Variable Declaration -
    @IBOutlet weak var viewMainContainer: UIView! {
        didSet {
            viewMainContainer.layer.cornerRadius = 8
        }
    }
    
    @IBOutlet weak var viewSubContainer: UIView! {
        didSet {
            viewSubContainer.layer.cornerRadius = 8
        }
    }
    @IBOutlet weak var lblTotalPoints: MIGenericLabel!
    @IBOutlet weak var imgLevelBG: UIImageView!
    @IBOutlet weak var lblYouhaveEarned: MIGenericLabel!
    @IBOutlet weak var lblLevel: MIGenericLabel!
    @IBOutlet weak var lblPointCount: MIGenericLabel!
    @IBOutlet weak var cntImgBGLeading: NSLayoutConstraint!
    @IBOutlet weak var cntImgBGTop: NSLayoutConstraint!
    
    var reward : MDLRewards! {
        didSet {
            if self.reward.name.isEmpty {
                lblTotalPoints.text = self.reward.points > 1 ? CPoints : CPoint
            } else {
                lblTotalPoints.text = CTotalPoints
            }
            lblLevel.isHidden = self.reward.level.isEmpty
            imgLevelBG.isHidden = self.reward.level.isEmpty
            lblLevel.text = self.reward.level
            lblPointCount.text = self.reward.points.description
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        
        self.viewMainContainer.shadow(
            color: CRGB(
                r: 237,
                g: 236,
                b: 226),
            shadowOffset: CGSize(
                width: 0,
                height: 5),
            shadowRadius: 10.0,
            shadowOpacity: 10.0
        )
        
        if Localization.sharedInstance.applicationFlowWithLanguageRTL() {
            lblLevel.transform = CGAffineTransform(rotationAngle: (CGFloat.pi / 3.5))
            imgLevelBG.transform = CGAffineTransform(rotationAngle: -(180.0 * .pi) / 120.0) // 120
            cntImgBGLeading.constant = -10
            cntImgBGTop.constant = 10
        } else {
            lblLevel.transform = CGAffineTransform(rotationAngle: -(CGFloat.pi / 5.0))
        }
        
        lblYouhaveEarned.text = CYouHaveEarned
        lblTotalPoints.text = CPoints
        lblLevel.text = ""
    }
}
