//
//  InviteSectionCell.swift
//  Sevenchats
//
//  Created by mac-00020 on 25/02/20.
//  Copyright © 2020 mac-0005. All rights reserved.
//
/*********************************************************
 * Author  : Chandrika.R                                 *
 * Model   : RestrictedFilesVC                           *
 * Description :  InviteSectionCell                      *
 *                                                       *
 ********************************************************/

import UIKit
import ContactsUI

class InviteSectionCell: UITableViewCell {
    
    @IBOutlet var lblInviteText : MIGenericLabel!
    @IBOutlet var btnPhoneBook : UIButton!
    @IBOutlet var btnShareSocialMedia : UIButton!
    
    var onPhoneBook : ((UIButton)->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        lblInviteText.text = CInviteConnectInviteFriend
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onPhoneBookPressed(_ sender : UIButton){
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .authorized, .restricted, .notDetermined:
            onPhoneBook?(sender)
        case .denied:
            self.showSettingsAlert { (_) in
            }
        }
    }
    
    
 
    
}

// MARK: -  Contact permission
extension InviteSectionCell {

    fileprivate func showSettingsAlert(_ completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
        let alert = UIAlertController(title: nil, message: CContactPermissionIsRequired, preferredStyle: .alert)
        if
            let settings = URL(string: UIApplication.openSettingsURLString),
            UIApplication.shared.canOpenURL(settings) {
                alert.addAction(UIAlertAction(title: CNavSettings, style: .default) { action in
                    completionHandler(false)
                    UIApplication.shared.open(settings)
                })
        }
        alert.addAction(UIAlertAction(title: CBtnCancel, style: .cancel) { action in
            completionHandler(false)
        })
        self.viewController?.present(alert, animated: true)
    }
}
