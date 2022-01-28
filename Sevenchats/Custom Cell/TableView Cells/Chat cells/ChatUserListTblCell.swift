//
//  ChatUserListTblCell.swift
//  Sevenchats
//
//  Created by mac-0005 on 30/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Chandrika.R                                 *
 * Model   : ChatUserListTblCell                         *
 * Changes : ChatUserListTblCell                         *
 *                                                       *
 ********************************************************/

import UIKit

class ChatUserListTblCell: UITableViewCell {
    
    @IBOutlet var imgUser : UIImageView!
    @IBOutlet var lblUserName : UILabel!
    @IBOutlet var lblMessage : UILabel!
    @IBOutlet var lblUnreadCount : UILabel!
    @IBOutlet var lblMessageTime : UILabel!
    @IBOutlet var btnMemberInfo : UIButton!
    @IBOutlet var btngroupInfo : UIButton!
    @IBOutlet weak var btnUserInfo: UIButton!
    
    
    
    @IBOutlet var imgOnline : UIImageView! {
        didSet {
            imgOnline.layer.cornerRadius = imgOnline.frame.size.width/2
            imgOnline.layer.borderWidth = 1
            imgOnline.layer.borderColor = UIColor.white.cgColor
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    
        self.imgUser.layer.cornerRadius = self.imgUser.frame.size.width/2
        self.imgUser.layer.borderWidth = 2
        self.imgUser.layer.borderColor = #colorLiteral(red: 0, green: 0.7881455421, blue: 0.7100172639, alpha: 1)
        self.imgUser.clipsToBounds = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        GCDMainThread.async {
            self.lblUnreadCount.layer.cornerRadius = self.lblUnreadCount.frame.size.width/2
            self.imgUser.layer.cornerRadius = self.imgUser.frame.size.width/2
            self.imgUser.clipsToBounds = true
        }
    }
}

extension ChatUserListTblCell {
    
    func groupChatCellConfiguration(_ groupInfo : TblChatGroupList) {
        lblUserName.text = groupInfo.group_title
        lblMessage.text = groupInfo.last_message
        imgUser.loadImageFromUrl(groupInfo.group_image, true)
        
        
        if JSON(rawValue: groupInfo.status_id!) ?? "" == 2 || JSON(rawValue: groupInfo.status_id!) ?? "" == 3 {
            self.lblMessage.textColor = UIColor.lightGray
            self.lblMessage.font = CFontPoppins(size: 12, type: .boldItalic).setUpAppropriateFont()
            self.lblMessage.text = JSON(rawValue: groupInfo.status_id!) ?? "" == 3 ? CDeleteMessageByAdmin : CDeleteMessageByUser
        } else {
            self.lblMessage.textColor = CRGB(r: 122, g: 115, b: 115)
            self.lblMessage.font = CFontPoppins(size: 12, type: .light).setUpAppropriateFont()
            
            switch groupInfo.msg_type {
            case 1: // TEXT
                self.lblMessage.text = groupInfo.last_message!
            case 2:// IMAGE
                self.lblMessage.text = CTypeImage
            case 3: // VIDEO
                self.lblMessage.text = CBtnVideo
            case 4: // AUDIO
                self.lblMessage.text = CBtnAudio
            case 6: // SHARED LOCATION
                self.lblMessage.text = CLocation
            default:
                self.lblMessage.text = ""
            }
        }
        
        if groupInfo.unread_count > 0 {
            lblUnreadCount.isHidden = false
            lblUnreadCount.text = "\(groupInfo.unread_count)"
        }else {
            lblUnreadCount.isHidden = true
        }
        
        //        self.lblMessageTime.text = DateFormatter.dateStringFrom(timestamp: groupInfo.datetime, withFormate: "HH:mm")
//        self.lblMessageTime.text = DateFormatter.shared().durationString(duration: "\(groupInfo.chat_time)")
        
        btnMemberInfo.isHidden = true
        //olde code replace later
//        if groupInfo.created_at == appDelegate.loginUser?.user_id{
//            btnMemberInfo.isHidden = !(groupInfo.pending_request > 0)
//        }
        //ChangeLatter
        if "166183056" == "166183056"{
            btnMemberInfo.isHidden = !(JSON(rawValue: groupInfo.pending_request!) ?? "" > 0)
        }
        
    }
    
    func userChatCellConfiguration(_ chatUserInfo : TblChatUserList) {
        self.lblUserName.text = chatUserInfo.first_name! + " " + chatUserInfo.last_name!
        //        self.lblMessageTime.text = DateFormatter.dateStringFrom(timestamp: chatUserInfo.created_at, withFormate: "HH:mm")
        
//        self.lblMessageTime.text = DateFormatter.shared().durationString(duration: "\(chatUserInfo.chat_time)")
        self.imgUser.loadImageFromUrl(chatUserInfo.image, true)
        self.imgOnline.isHidden = !chatUserInfo.isOnline
        
        
        if chatUserInfo.unread_cnt > 0 {
            lblUnreadCount.isHidden = false
            lblUnreadCount.text = "\(chatUserInfo.unread_cnt)"
        }else {
            lblUnreadCount.isHidden = true
        }
        
        if chatUserInfo.status_id == 2 || chatUserInfo.status_id == 3 {
            self.lblMessage.textColor = UIColor.lightGray
            self.lblMessage.font = CFontPoppins(size: 12, type: .boldItalic).setUpAppropriateFont()
            self.lblMessage.text = chatUserInfo.status_id == 3 ? CDeleteMessageByAdmin : CDeleteMessageByUser
        } else {
            self.lblMessage.textColor = CRGB(r: 122, g: 115, b: 115)
            self.lblMessage.font = CFontPoppins(size: 12, type: .light).setUpAppropriateFont()
            
            switch chatUserInfo.msg_type {
            case 1: // TEXT
                self.lblMessage.text = chatUserInfo.message
            case 2:// IMAGE
                self.lblMessage.text = CTypeImage
            case 3: // VIDEO
                self.lblMessage.text = CBtnVideo
            case 4: // AUDIO
                self.lblMessage.text = CBtnAudio
            case 6: // SHARED LOCATION
                self.lblMessage.text = CLocation
            default:
                self.lblMessage.text = ""
            }
        }
        
    }
}
