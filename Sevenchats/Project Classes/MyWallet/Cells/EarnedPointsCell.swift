//
//  EarnedPointsCell.swift
//  Sevenchats
//
//  Created by mac-00020 on 29/01/20.
//  Copyright © 2020 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Nagaraju K and Chandrika R                                 *
 * Model   : EarnedPointsCell                           *
 * Changes :                                             *
 *                                                       *
 ********************************************************/

import UIKit

class EarnedPointsCell: UITableViewCell {

    //MARK: - IBOutlet/Object/Variable Declaration
    @IBOutlet weak var viewMainContainer: UIView!
    @IBOutlet weak var imgUserProfile: UIImageView!
    @IBOutlet weak var lblPointCount: MIGenericLabel!
    @IBOutlet weak var lblDescription: MIGenericLabel!
    @IBOutlet weak var lblDate: MIGenericLabel!
    @IBOutlet weak var vwInfo: UIView!
    
    var rewardDetail : MDLRewardDetail! {
        didSet {
            let strPoint = rewardDetail.points > 1 ? CPoints : CPoint
            lblPointCount.text = rewardDetail.points.description + " " + strPoint
            if rewardDetail.points < 0 || rewardDetail.pointsConfigId == 20 {
                self.lblPointCount.textColor = UIColor(hexString: "f73d3d") // Red
            } else {
                self.lblPointCount.textColor = UIColor(hexString: "06c0a6") // Green
            }
            lblDescription.attributedText = htmlToAttributedString("Credited for " + rewardDetail.postType, lblDescription.font)
            imgUserProfile.loadImageFromUrl(rewardDetail.friendImage, true)

            switch rewardDetail.postType {
            case "article": // Article
                self.imgUserProfile.image = #imageLiteral(resourceName: "ic_1_article")
            case "gallery": // Gallery
                self.imgUserProfile.image = #imageLiteral(resourceName: "ic_4_gallery")
            case "chirpy": // Chirpy
                self.imgUserProfile.image = #imageLiteral(resourceName: "ic_2_chipy")
            case "shout": // Shout
                self.imgUserProfile.image = #imageLiteral(resourceName: "ic_7_shout")
            case "forum": // Forum
                self.imgUserProfile.image = #imageLiteral(resourceName: "ic_4_forum")
            case "event": // Event
                self.imgUserProfile.image = #imageLiteral(resourceName: "ic_5_events")
            case "poll": // Poll
                self.imgUserProfile.image = #imageLiteral(resourceName: "ic_6_poll")
            default :break
            }
            
        }
    }
    
    var type : RewardCategory! {
        didSet {
            
            self.vwInfo.isHidden = true
            self.imgUserProfile?.superview?.isHidden = true
            
            switch type {
            case .AdminCorrection:
                self.vwInfo.isHidden = false
                break
            case .Connections:
                self.imgUserProfile?.superview?.isHidden = false
                break
            case .Posts:
                self.imgUserProfile?.superview?.isHidden = false
                break
            default:
                break
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.lblDescription.textColor = UIColor(hexString: "a09c9c")
        self.lblDate.textColor = ColorAppTheme
        self.viewMainContainer.layer.cornerRadius = 8
        self.viewMainContainer.shadow(color: CRGB(r: 237, g: 236, b: 226), shadowOffset: CGSize(width: 0, height: 5), shadowRadius: 10.0, shadowOpacity: 10.0)
        self.imgUserProfile.layer.cornerRadius = self.imgUserProfile.frame.size.width / 2
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
 
    func htmlToAttributedString(_ html: String, _ font: UIFont) -> NSAttributedString {
        
        let modifiedFont = "<span style=\"font-family: \(font.fontName); font-size: \(font.pointSize)\">\(html)</span>"
        guard let data = modifiedFont.data(using: String.Encoding.unicode) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType:  NSAttributedString.DocumentType.html], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    
    func configureCell() {
        self.vwInfo.isHidden = true
        self.lblDescription.text = "Lorem Ipsum is simply dummy"
    }
}

//MARK: - IBAction's
extension EarnedPointsCell {
    
    @IBAction func onInfoPressed(_ sender: UIButton) {
        let msg = rewardDetail.detailText
        self.viewController?.presentAlertViewWithOneButton(alertTitle: nil, alertMessage: msg, btnOneTitle: CBtnOk, btnOneTapped: nil)
    }
}
