//
//  NotificationInvitationTblCell.swift
//  Sevenchats
//
//  Created by Mac-0006 on 23/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//
/*********************************************************
 * Author  : Chandrika.R                                 *
 * Model   : NotificationInvitationTblCell               *
 * Description :  NotificationInvitationTblCell          *
 *                                                       *
 ********************************************************/

import UIKit
import ActiveLabel

class NotificationInvitationTblCell: UITableViewCell {
    
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblDate: MIGenericLabel!
    @IBOutlet weak var lblNotificationInvitation: ActiveLabel!
    
    @IBOutlet weak var btnInterest: MIGenericButton!
    @IBOutlet weak var btnNotInterested: MIGenericButton!
    @IBOutlet weak var btnMayBe: MIGenericButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        lblNotificationInvitation.font = UIFont(name: lblNotificationInvitation.font.fontName, size: round(CScreenWidth * (lblNotificationInvitation.font.pointSize / 414)))
        
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if Localization.sharedInstance.applicationFlowWithLanguageRTL() {
            lblNotificationInvitation.textAlignment = .right
            
            // Reverse Flow...
            btnInterest.contentHorizontalAlignment = .right
            btnInterest.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
            
            btnNotInterested.contentHorizontalAlignment = .right
            btnNotInterested.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
            
            btnMayBe.contentHorizontalAlignment = .right
            btnMayBe.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right:10)

        } else {
            lblNotificationInvitation.textAlignment = .left
            
            // Normal Flow...
            btnInterest.contentHorizontalAlignment = .left
            btnInterest.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
            
            btnNotInterested.contentHorizontalAlignment = .left
            btnNotInterested.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
            
            btnMayBe.contentHorizontalAlignment = .left
            btnMayBe.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        }
    }
}

//MARK:- ----- Configuration
extension NotificationInvitationTblCell {
    
    func ConfigureNotificationInvitationTblCell(_ notificationInfo: [String : Any]) {

//        self.lblDate.text = "\(DateFormatter.dateStringFrom(timestamp: notificationInfo.valueForDouble(key: "created_at"), withFormate: "dd MMM yyyy"))"
        self.lblDate.text = "\(DateFormatter.dateStringFrom(timestamp: notificationInfo.valueForDouble(key: "created_at")!/1000, withFormate: "dd MMM yyyy"))"

        btnMayBe.setTitle("\(notificationInfo.valueForString(key: CTotalMaybeInterestedUsers))\n " + CMaybe, for: .normal)
        btnNotInterested.setTitle("\(notificationInfo.valueForString(key: CTotalNotInterestedUsers))\n" + CDeclined, for: .normal)
        btnInterest.setTitle("\(notificationInfo.valueForString(key: CTotalInterestedUsers))\n" + CConfirmed, for: .normal)
        
        btnMayBe.isSelected = false
        btnNotInterested.isSelected = false
        btnInterest.isSelected = false
        
        switch notificationInfo.valueForInt(key: CIsInterested) {
        case 1:
            btnMayBe.isSelected = true
        case 2:
            btnInterest.isSelected = true
        case 3:
            btnNotInterested.isSelected = true
        default:
            break
        }
        
        let currentDateTime = Date().timeIntervalSince1970
        
        if let endDateTime = notificationInfo.valueForDouble(key: CEvent_End_Date) {

            btnMayBe.isEnabled = Double(currentDateTime) <= endDateTime
            btnNotInterested.isEnabled = Double(currentDateTime) <= endDateTime
            btnInterest.isEnabled = Double(currentDateTime) <= endDateTime
        }
        setSelectedButtonStyle()
    }
    
    func setSelectedButtonStyle(){
        btnInterest.layer.borderColor = CRGB(r: 223, g: 234, b: 227).cgColor
        btnInterest.layer.borderWidth = 2
        btnInterest.backgroundColor =  .clear
        
        btnMayBe.layer.borderColor = CRGB(r: 255, g: 237, b: 216).cgColor
        btnMayBe.layer.borderWidth = 2
        btnMayBe.backgroundColor =  .clear
        
        btnNotInterested.layer.borderColor = CRGB(r: 255, g: 214, b: 214).cgColor
        btnNotInterested.layer.borderWidth = 2
        btnNotInterested.backgroundColor =  .clear
        
        let arrButton = [btnInterest,btnMayBe,btnNotInterested]
        if let sender = arrButton.filter({$0?.isSelected ?? false}).first{
            if sender == btnInterest{
                btnInterest.backgroundColor =  CRGB(r: 223, g: 234, b: 227)
            }else if sender == btnMayBe{
                btnMayBe.backgroundColor =  CRGB(r: 255, g: 237, b: 216)
            }else if sender == btnNotInterested{
                btnNotInterested.backgroundColor =  CRGB(r: 255, g: 214, b: 214)
            }
        }
    }
}
