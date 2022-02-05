//
//  MyFriendTblCell.swift
//  Sevenchats
//
//  Created by mac-0005 on 30/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Chandrika.R                                 *
 * Model   : MyFriendTblCell                             *
 * Changes :                                             *
 *                                                       *
 ********************************************************/

import UIKit

class MyFriendTblCell: UITableViewCell {

    @IBOutlet var lblUserName : UILabel!
    @IBOutlet var imgUser : UIImageView!
    @IBOutlet var btnUnfriendCancelRequest : UIButton!
    @IBOutlet var btnAcceptRequest : UIButton!
    @IBOutlet var btnRejectRequest : UIButton!
    @IBOutlet var viewAcceptReject : UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        GCDMainThread.async {
            self.imgUser.layer.cornerRadius = self.imgUser.frame.size.width / 2
            self.imgUser.layer.borderWidth = 1
            self.imgUser.layer.borderColor = #colorLiteral(red: 0, green: 0.7881455421, blue: 0.7100172639, alpha: 1)
        }
    }
    func setupCell(loan:[String:Any]) {
        var Friend_status:Int?
        let user_id = appDelegate.loginUser?.user_id
        let friendID = loan.valueForString(key: "id")
        let dict :[String:Any]  =  [
            "user_id":  appDelegate.loginUser?.user_id ?? "",
            "friend_user_id": friendID
        ]
        APIRequest.shared().getFriendStatus(dict: dict, completion: { [weak self] (response, error) in
            if response != nil && error == nil{
                GCDMainThread.async {
                    if let arrList = response!["data"] as? [[String:Any]]{
                        for arrLst in arrList{
                            if arrLst.valueForString(key: "block_status") == "1" && arrLst.valueForString(key: "blocked_id") == appDelegate.loginUser?.user_id.description{
                                Friend_status = 7
                            }else if arrLst.valueForString(key: "block_status") == "1"  {
                                Friend_status = 6
                            }else if arrLst.valueForString(key: "request_status") == "0" &&  arrLst.valueForString(key: "friend_status") == "0" && arrLst.valueForString(key: "unfriend_status") == "0" || arrLst.valueForString(key: "unfriend_status") == "1" &&  arrLst.valueForString(key: "request_status") == "0" && arrLst.valueForString(key: "friend_status") == "0"{
                                Friend_status = 0
                                
                            }else if arrLst.valueForString(key: "request_status")  == "1" && arrLst.valueForString(key: "senders_id") != user_id?.description {
                                Friend_status = 2
                            }else if arrLst.valueForString(key: "friend_status") == "1"{
                                Friend_status = 5
                            }else  if arrLst.valueForString(key: "request_status") == "1" && arrLst.valueForString(key: "senders_id")  == user_id?.description {
                                Friend_status = 1
                            }
                            
                            if Friend_status == 2 {
                                self?.btnUnfriendCancelRequest.isHidden = true
                                self?.viewAcceptReject.isHidden = false
                            }else{
                                self?.btnUnfriendCancelRequest.isHidden = false
                                self?.viewAcceptReject.isHidden = true
                                
                                switch Friend_status{
                                case 0:
                                    self?.btnUnfriendCancelRequest.setTitle("  \(CBtnAddFriend)  ", for: .normal)
                                case 1:
                                    self?.btnUnfriendCancelRequest.setTitle("  \(CBtnCancelRequest)  ", for: .normal)
                                case 5:
                                    self?.btnUnfriendCancelRequest.setTitle("  \(CBtnUnfriend)  ", for: .normal)
                                case 6:
                                    self?.btnUnfriendCancelRequest.setTitle("  \(CBlockedUser)  ", for: .normal)
                                case 7:
                                    self?.btnUnfriendCancelRequest.setTitle("  \(CBtnUnblockUser)  ", for: .normal)
                                default:
                                    break
                                }
                            }
                        }
                        
                    }
                    
                }
            }
        })
        
    }
}

