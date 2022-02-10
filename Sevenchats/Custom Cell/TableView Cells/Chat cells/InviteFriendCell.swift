//
//  InviteFriendCell.swift
//  Sevenchats
//
//  Created by mac-0005 on 08/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//
/*********************************************************
 * Author  : Chandrika.R                                 *
 * Model   : InviteFriendCell                            *
 * Changes :                                             *
 *                                                       *
 ********************************************************/

import UIKit

class InviteFriendCell: UITableViewCell {
    
    @IBOutlet var imgUser : UIImageView!
    @IBOutlet var imgUserType : UIImageView!
    @IBOutlet var lblUserName : UILabel!
    @IBOutlet var lblUserInfo : UILabel!
    @IBOutlet var btnInviteConnect : UIButton!
    @IBOutlet var btnInviteContentMove : UIButton!
    var arrListModel = [MDLUsers]()
    
    var callbacks : (([MDLUsers],String?) -> Void)?
    var callbacksInviteReturn : (([[String:Any]]) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //        self.selectionStyle = .none
        GCDMainThread.async {
            self.imgUser.layer.cornerRadius = self.imgUser.frame.size.width/2
            self.imgUserType.layer.cornerRadius = self.imgUserType.frame.size.width/2
        }
        
        if Localization.sharedInstance.applicationFlowWithLanguageRTL() {
            // Reverse Flow...
            btnInviteConnect.contentHorizontalAlignment = .left
        }else{
            // Normal Flow...
            btnInviteConnect.contentHorizontalAlignment = .right
        }
        
    }
    
    func setupCell(loan:String?) {
        let dict:[String:Any] = [
            CMobile : loan ]
        APIRequest.shared().inviteAndconnect(para: dict as [String : AnyObject]) { (response, error) in
            if response != nil && error == nil {
                if let metaInfo = response![CJsonMeta] as? [String:Any]{
                    let status =  metaInfo["status"] as? String ?? ""
                    if status == "0"{
                        if let arrData = response?.value(forKey: CJsonData) as? [[String : AnyObject]] {
                            for arr in arrData{
                                self.arrListModel.append(MDLUsers(fromDictionary: arr))
                                self.callbacks?(self.arrListModel, "1")
                            }
                        }
                    }else {
                        self.arrListModel.append(MDLUsers(fromDictionary: dict))
                        self.callbacks?(self.arrListModel,"0")
                    }
                }
            }else{
                
            }
        }
    }
    
    
    
    func setupCells(loan:String?) {

        let user_id = appDelegate.loginUser?.user_id
        let friendID = loan
        let dict :[String:Any]  =  [
            "user_id": user_id as Any,
            "friend_user_id": friendID as Any
        ]
        APIRequest.shared().getFriendStatus(dict: dict as [String : AnyObject]) { (response, error) in
            if response != nil && error == nil {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                    if let arrList = response!["data"] as? [[String:Any]]{
                        self.callbacksInviteReturn?(arrList)
                
            }
                
            }
        }
    }
    
    }
    
   
//    func setupCellInvite(loan: String) {
//        var Friend_status:Int?
//        let user_id = appDelegate.loginUser?.user_id
//        let friendID = loan
//        let dict :[String:Any]  =  [
//            "user_id":  appDelegate.loginUser?.user_id.description ?? "",
//            "friend_user_id": friendID
//        ]
//
//        APIRequest.shared().getFriendStatus(dict: dict, completion: { (response, error) in
//            if response != nil && error == nil{
////                GCDMainThread.async {
//                    if let arrList = response!["data"] as? [[String:Any]]{
//                        for arrLst in arrList{
//                            if arrLst.valueForString(key: "block_status") == "1" && arrLst.valueForString(key: "blocked_id") == appDelegate.loginUser?.user_id.description{
//                                Friend_status = 7
//                            }else if arrLst.valueForString(key: "block_status") == "1"  {
//                                Friend_status = 6
//                            }else if arrLst.valueForString(key: "request_status") == "0" &&  arrLst.valueForString(key: "friend_status") == "0" && arrLst.valueForString(key: "unfriend_status") == "0" || arrLst.valueForString(key: "unfriend_status") == "1" &&  arrLst.valueForString(key: "request_status") == "0" && arrLst.valueForString(key: "friend_status") == "0"{
//                                Friend_status = 0
//
//                            }else if arrLst.valueForString(key: "request_status")  == "1" && arrLst.valueForString(key: "senders_id") != user_id?.description {
//                                Friend_status = 2
//                            }else if arrLst.valueForString(key: "friend_status") == "1"{
//                                Friend_status = 5
//                            }else  if arrLst.valueForString(key: "request_status") == "1" && arrLst.valueForString(key: "senders_id")  == user_id?.description {
//                                Friend_status = 1
//                            }
//
////                            if Friend_status == 2 {
////                                self?.btnAddFrd.isHidden = true
////                                self?.viewAcceptReject.isHidden = false
////                            }else{
////                                self?.btnAddFrd.isHidden = false
////                                self?.viewAcceptReject.isHidden = true
////
////                                switch Friend_status{
////                                case 0:
////                                    self?.btnAddFrd.setTitle("  \(CBtnAddFriend)  ", for: .normal)
////                                case 1:
////                                    self?.btnAddFrd.setTitle("  \(CBtnCancelRequest)  ", for: .normal)
////                                case 5:
////                                    self?.btnAddFrd.setTitle("  \(CBtnUnfriend)  ", for: .normal)
////                                case 6:
////                                    self?.btnAddFrd.setTitle("  \(CBlockedUser)  ", for: .normal)
////                                case 7:
////                                    self?.btnAddFrd.setTitle("  \(CBtnUnblockUser)  ", for: .normal)
////                                default:
////                                    break
////                                }
////                            }
//                        }
//
//                    }
//
////                }
//            }
//        })
//
//    }
    
}
