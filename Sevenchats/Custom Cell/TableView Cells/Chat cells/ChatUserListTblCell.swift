//
//  ChatUserListTblCell.swift
//  Sevenchats
//
//  Created by mac-0005 on 30/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Nagaraju K and Chandrika R                                 *
 * Model   : ChatUserListTblCell                         *
 * Changes : ChatUserListTblCell                         *
 *                                                       *
 ********************************************************/

import UIKit
import SDWebImage

class ChatUserListTblCell: UITableViewCell {
    
    @IBOutlet var imgUser : UIImageView!
    @IBOutlet var imgUserGIF : FLAnimatedImageView!
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
        
        self.imgUserGIF.layer.cornerRadius = self.imgUserGIF.frame.size.width/2
        self.imgUserGIF.layer.borderWidth = 2
        self.imgUserGIF.layer.borderColor = #colorLiteral(red: 0, green: 0.7881455421, blue: 0.7100172639, alpha: 1)
        self.imgUserGIF.clipsToBounds = true
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
    
    func groupChatCellConfigurations(_ groupInfo : [String:Any]) {
        
//        for groupInfo in groupInfos{
       let group_titile = groupInfo["group_title"] as? String
        
        let str_Back_desc_share = group_titile?.return_replaceBack(replaceBack: group_titile ?? "")
        lblUserName.text = str_Back_desc_share
       // lblUserName.text = groupInfo.group_title
//        lblMessage.text = groupInfo.last_message
//        imgUser.loadImageFromUrl(groupInfo["group_image"] as? String, true)
        
        let imgExt = URL(fileURLWithPath:groupInfo["group_image"] as? String ?? "").pathExtension
        
        
        if imgExt == "gif"{
                    print("-----ImgExt\(imgExt)")
                    
            imgUser.isHidden  = true
                    self.imgUserGIF.isHidden = false
            self.imgUserGIF.sd_setImage(with: URL(string:groupInfo["group_image"] as? String ?? ""), completed: nil)
            self.imgUserGIF.sd_cacheFLAnimatedImage = false
                    
                }else {
                    self.imgUserGIF.isHidden = true
                    imgUser.isHidden  = false
                    imgUser.loadImageFromUrl(groupInfo["group_image"] as? String, true)
                    _ = appDelegate.loginUser?.total_friends ?? 0
                }
        
//
//        if JSON(rawValue: groupInfo.status_id!) ?? "" == 2 || JSON(rawValue: groupInfo.status_id!) ?? "" == 3 {
//            self.lblMessage.textColor = UIColor.lightGray
//            self.lblMessage.font = CFontPoppins(size: 12, type: .boldItalic).setUpAppropriateFont()
//            self.lblMessage.text = JSON(rawValue: groupInfo.status_id!) ?? "" == 3 ? CDeleteMessageByAdmin : CDeleteMessageByUser
//        } else {
//            self.lblMessage.textColor = CRGB(r: 122, g: 115, b: 115)
//            self.lblMessage.font = CFontPoppins(size: 12, type: .light).setUpAppropriateFont()
//
//            groupInfo.msg_type
//            switch groupInfo.msg_type {
//            case 1: // TEXT
//                self.lblMessage.text = CTypeImage
//            case 2:// IMAGE
//                self.lblMessage.text = CTypeImage
//            case 3: // VIDEO
//                self.lblMessage.text = CBtnVideo
//            case 4: // AUDIO
//                self.lblMessage.text = CBtnAudio
//            case 6: // SHARED LOCATION
//                self.lblMessage.text = CLocation
//            default:
//                self.lblMessage.text = ""
//            }
//        }
        
        lblUnreadCount.isHidden = true
        self.lblMessage.isHidden = true 
        
//        if groupInfo.unread_count > 0 {
//            lblUnreadCount.isHidden = false
//            lblUnreadCount.text = "\(groupInfo.unread_count)"
//        }else {
//            lblUnreadCount.isHidden = true
//        }
        
        //        self.lblMessageTime.text = DateFormatter.dateStringFrom(timestamp: groupInfo.datetime, withFormate: "HH:mm")
//        self.lblMessageTime.text = DateFormatter.shared().durationString(duration: "\(groupInfo.chat_time)")
        
        btnMemberInfo.isHidden = true
        //olde code replace later
//        if groupInfo.created_at == appDelegate.loginUser?.user_id{
//            btnMemberInfo.isHidden = !(groupInfo.pending_request > 0)
//        }
        //ChangeLatter
        btnMemberInfo.isHidden = true
        if "166183056" == "166183056"{
//            btnMemberInfo.isHidden = !(JSON(rawValue: groupInfo.pending_request!) ?? "" > 0)
        }
//        }
        
    }
    
    
    
    func groupChatCellConfiguration(_ groupInfo : TblChatGroupList) {
        let str_Back_desc_share = groupInfo.group_title?.return_replaceBack(replaceBack: groupInfo.group_title ?? "")
        lblUserName.text = str_Back_desc_share
       // lblUserName.text = groupInfo.group_title
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
//        self.imgUser.loadImageFromUrl(chatUserInfo.image, true)
        
        
        let imgExt = URL(fileURLWithPath:chatUserInfo.image ?? "").pathExtension
        
        
        if imgExt == "gif"{
                    print("-----ImgExt\(imgExt)")
                    
            imgUser.isHidden  = true
                    self.imgUserGIF.isHidden = false
            self.imgUserGIF.sd_setImage(with: URL(string:chatUserInfo.image ?? ""), completed: nil)
            self.imgUserGIF.sd_cacheFLAnimatedImage = false
                    
                }else {
                    self.imgUserGIF.isHidden = true
                    imgUser.isHidden  = false
                    self.imgUser.loadImageFromUrl(chatUserInfo.image, true)
                    _ = appDelegate.loginUser?.total_friends ?? 0
                }
        
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


class ChatUserListTblCellTop: UITableViewCell {
  
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
