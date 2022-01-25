//
//  RewardCategoryCell.swift
//  Sevenchats
//
//  Created by mac-00020 on 01/02/20.
//  Copyright © 2020 mac-0005. All rights reserved.
//
/*********************************************************
 * Author  : Chandrika.R                                 *
 * Model   : RewardCategoryCell                          *
 * Changes :                                             *
 *                                                       *
 ********************************************************/



import UIKit

class RewardCategoryCell: UITableViewCell {

    //MARK: - IBOutlet/Object/Variable Declaration
    @IBOutlet weak var viewMainContainer: UIView!
    @IBOutlet weak var lblCategory: MIGenericLabel!
    @IBOutlet weak var lblPoints: MIGenericLabel!
    
    var rewardSummary : MDLRewardSummary! {
        didSet {
            self.lblCategory.text =  rewardSummary.name
            let strPoint = rewardSummary.points.toInt ?? 0 > 1 ? CPoints : CPoint
            self.lblPoints.text =  rewardSummary.points.description + " " + strPoint
            
            if rewardSummary.points.toInt ?? 0 < 0 {
                self.lblPoints.textColor = UIColor(hexString: "f73d3d")
            } else {
                self.lblPoints.textColor = UIColor(hexString: "06C0A6")
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.viewMainContainer.layer.cornerRadius = 8
        self.viewMainContainer.shadow(color: CRGB(r: 237, g: 236, b: 226), shadowOffset: CGSize(width: 0, height: 5), shadowRadius: 10.0, shadowOpacity: 10.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
