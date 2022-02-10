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
    
    var callBackInviteReturn: ((Int,Int) -> Void)?
    var check_Status:Int?
    var Friend_status = 0
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
    
    func setupCell(loan:String?,arrSyncUser:[[String : Any]]) {
        let dict:[String:Any] = [
            CMobile : loan as Any ]
        APIRequest.shared().inviteAndconnect(para: dict as [String : AnyObject]) { (response, error) in
            if response != nil && error == nil {
                if let metaInfo = response![CJsonMeta] as? [String:Any]{
                    let status =  metaInfo["status"] as? String ?? ""
                    if status == "0"{
                        if let arrData = response?.value(forKey: CJsonData) as? [[String : AnyObject]] {
                            for arr in arrData{
                                
                                let userMobileNo = arr["mobile"] as? String
                                let userIDs = arr["user_id"] as? String
                                
                                self.arrListModel.append(MDLUsers(fromDictionary: arr))
                                //                                self.callbacks?(self.arrListModel, "1")
                                
                                self.inviteContacts(appDelegate.loginUser?.user_id.description, friend_user_id: self.arrListModel.first?.mobile ?? "",Check_status:"1",phoneNumber:loan ?? "",arrSyncUser:arrSyncUser,userMobileNo:userMobileNo ?? "",userIDs:userIDs ?? "")
                                
                            }
                        }
                    }else {
                        self.arrListModel.append(MDLUsers(fromDictionary: dict))
                        //                        self.callbacks?(self.arrListModel,"0")
                        
                        self.inviteContacts(appDelegate.loginUser?.user_id.description, friend_user_id: loan ?? "",Check_status:"0",phoneNumber:loan ?? "",arrSyncUser:arrSyncUser,userMobileNo:loan ?? "",userIDs:"")
                    }
                }
            }else{
                
            }
        }
    }
    
    
    func inviteContacts(_ userID:String?,friend_user_id:String,Check_status:String,phoneNumber:String,arrSyncUser:[[String : Any]],userMobileNo:String,userIDs:String){
        
        
        if userMobileNo == phoneNumber{
            let index = arrSyncUser.firstIndex(where: { $0["mobile"] as? String == phoneNumber}) ?? 0
            
            if userIDs == appDelegate.loginUser?.user_id.description{
                btnInviteConnect.isHidden = true
                
            }else{
                btnInviteConnect.isHidden = false
                
            }
            //            btnInviteConnect.isHidden = userIDs == appDelegate.loginUser?.user_id.description ? true : false
            //             btnInviteConnect.setImage(nil, for: .normal)
            //             btnInviteConnect.setTitle(nil, for: .normal)
            //
            let dict :[String:Any]  =  [
                "user_id":  appDelegate.loginUser?.user_id.description ?? "",
                "friend_user_id": userIDs.description
            ]
            let user_id = appDelegate.loginUser?.user_id
            
            
            APIRequest.shared().getFriendStatus(dict: dict, completion: { (response, error) in
                if response != nil && error == nil{
                    GCDMainThread.async {
                        if let arrList = response!["data"] as? [[String:Any]]{
                            for arrLst in arrList{
                                if arrLst.valueForString(key: "block_status") == "1" && arrLst.valueForString(key: "blocked_id") == appDelegate.loginUser?.user_id.description{
                                    self.Friend_status = 7
                                }else if arrLst.valueForString(key: "block_status") == "1"  {
                                    self.Friend_status = 6
                                }else if arrLst.valueForString(key: "request_status") == "0" &&  arrLst.valueForString(key: "friend_status") == "0" && arrLst.valueForString(key: "unfriend_status") == "0" || arrLst.valueForString(key: "unfriend_status") == "1" &&  arrLst.valueForString(key: "request_status") == "0" && arrLst.valueForString(key: "friend_status") == "0"{
                                    self.Friend_status = 0
                                    
                                }else if arrLst.valueForString(key: "request_status")  == "1" && arrLst.valueForString(key: "senders_id") != user_id?.description {
                                    self.Friend_status = 2
                                }else if arrLst.valueForString(key: "friend_status") == "1"{
                                    self.Friend_status = 5
                                }else  if arrLst.valueForString(key: "request_status") == "1" && arrLst.valueForString(key: "senders_id")  == user_id?.description {
                                    self.Friend_status = 1
                                }
                                let friendStatus = Check_status
                                if friendStatus.toInt == 0{
                                    self.check_Status = 0
                                    self.btnInviteConnect.setTitle(CBtnInvite, for: .normal)
                                }else{
//                                    self.check_Status = 1
                                    switch self.Friend_status {
                                    case 0, 4, 3:
                                        //                                if self.arrConnectAllFriend.contains(where: {$0[CUserId] as? Int == syncUserInfo.valueForInt(key: CUserId)}){
                                        //                                    cell.btnInviteConnect.setImage(UIImage(named: "ic_right"), for: .normal)
                                        //                                }else{
                                        self.btnInviteConnect.setTitle("  \(CBtnConnect)  ", for: .normal)
                                        self.check_Status = 1
                                    //}
                                    case 1:
                                        self.btnInviteConnect.setTitle("  \(CBtnCancelRequest)  ", for: .normal)
                                        self.check_Status = 1
                                    case 5:
                                        self.btnInviteConnect.setTitle("  \(CBtnUnfriend)  ", for: .normal)
                                        self.check_Status = 1
                                    case 2:
                                        self.btnInviteConnect.setTitle("  \(CBtnAccept)  ", for: .normal)
                                        self.check_Status = 1
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
//        self.myCallBack?(Friend_status)
    }
    
    
    @IBAction func btnInviteConnect(_ sender: UIButton) {
       //Call your closure here
        self.callBackInviteReturn?(Friend_status, check_Status ?? 0)
       
    }
    

}


