//
//  HomeAddFrdTblCell.swift
//  Sevenchats
//
//  Created by mac-00017 on 04/09/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Nagaraju K and Chandrika R                                 *
 * Model   : HomeChirpyImageTblCell                      *
 * Changes :                                             *
 *                                                       *
 ********************************************************/

import UIKit

protocol customProtocol2{
    func protocol2 (myInt: Int)
}


class HomeAddFrdTblCell: UITableViewCell {
    
    @IBOutlet var viewMainContainer : UIView!
    @IBOutlet var viewSubContainer : UIView!
    @IBOutlet var imgUser : UIImageView!
    @IBOutlet var lblUserName : UILabel!
    @IBOutlet var btnAddFrd : UIButton!
    @IBOutlet var btnAccept : UIButton!
    @IBOutlet var btnReject : UIButton!
    @IBOutlet var viewAcceptReject : UIView!
    
    var homesearch = HomeSearchViewController()
    
    var callbacks : ((String) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        GCDMainThread.async {
            self.btnAddFrd.layer.cornerRadius = 5
            self.imgUser.layer.borderWidth = 2
            self.imgUser.layer.borderColor = #colorLiteral(red: 0, green: 0.7881455421, blue: 0.7100172639, alpha: 1)
            self.viewSubContainer.layer.cornerRadius = 8
            self.viewMainContainer.layer.cornerRadius = 8
            self.viewMainContainer.shadow(color: CRGB(r: 237, g: 236, b: 226), shadowOffset: CGSize(width: 0, height: 5), shadowRadius: 10.0, shadowOpacity: 10.0)
            self.imgUser.layer.cornerRadius = self.imgUser.frame.size.width/2
        }
        btnAddFrd.isHidden = true
        btnAccept.isHidden = true
        btnReject.isHidden = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupCell(loan:[String:Any]) {
        var Friend_status:Int?
        let user_id = appDelegate.loginUser?.user_id
        let friendID = loan.valueForString(key: "user_id")
        let dict :[String:Any]  =  [
            "user_id":  appDelegate.loginUser?.user_id ?? "",
            "friend_user_id": friendID
        ]
        APIRequest.shared().getFriendStatus(dict: dict, completion: { [weak self] (response, error) in
            if response != nil && error == nil{
                GCDMainThread.async {
                    if let arrList = response!["data"] as? [[String:Any]]{
                        for arrLst in arrList{
                            
                            if arrLst.valueForString(key: "block_status") == "1" && arrLst.valueForString(key: "blocked_id") == appDelegate.loginUser?.user_id.description {
                                Friend_status = 7
                            }else if arrLst.valueForString(key: "block_status") == "1"  {
                              Friend_status = 6
                            } else if arrLst.valueForString(key: "friend_status") == "1"{
                             Friend_status = 5
                            }else if arrLst.valueForString(key: "request_status") == "1" && arrLst.valueForString(key: "senders_id") == user_id?.description {
                              Friend_status = 1
                            }else if arrLst.valueForString(key: "request_status") == "0" &&  arrLst.valueForString(key: "friend_status") == "0" && arrLst.valueForString(key: "reject_status") == "0" && arrLst.valueForString(key: "cancel_status") == "0" && arrLst.valueForString(key: "unfriend_status") == "0" || arrLst.valueForString(key: "unfriend_status") == "1" &&  arrLst.valueForString(key: "request_status") == "0" && arrLst.valueForString(key: "friend_status") == "0" || arrLst.valueForString(key: "unfriend_status") == "0" &&  arrLst.valueForString(key: "request_status") == "1" && arrLst.valueForString(key: "cancel_status") == "1" {
                            Friend_status = 0
                            }else if arrLst.valueForString(key: "request_status")  == "1" && arrLst.valueForString(key: "senders_id") != user_id?.description {
                                Friend_status = 2
                                
                            }else if arrLst.valueForString(key: "unfriend_status") == "0" &&  arrLst.valueForString(key: "request_status") == "0" && arrLst.valueForString(key: "cancel_status") == "1" || arrLst.valueForString(key: "senders_id").isEmpty {
                                Friend_status = 0
                            }
                            
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
                            
                            if Friend_status == 2 {
                                self?.btnAddFrd.isHidden = true
                                self?.viewAcceptReject.isHidden = false
                                self?.btnAccept.isHidden = false
                                self?.btnReject.isHidden = false
                                
                            }else{
                                self?.btnAddFrd.isHidden = false
                                self?.btnAccept.isHidden = true
                                self?.btnReject.isHidden = true
                                self?.viewAcceptReject.isHidden = true
                                
                                switch Friend_status{
                                case 0:
                                    self?.btnAddFrd.setTitle("  \(CBtnAddFriend)  ", for: .normal)
                                case 1:
                                    self?.btnAddFrd.setTitle("  \(CBtnCancelRequest)  ", for: .normal)
                                case 5:
                                    self?.btnAddFrd.setTitle("  \(CBtnUnfriend)  ", for: .normal)
                                case 6:
                                    self?.btnAddFrd.setTitle("  \(CBlockedUser)  ", for: .normal)
                                case 7:
                                    self?.btnAddFrd.setTitle("  \(CBtnUnblockUser)  ", for: .normal)
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
    
    func setupImgTapGestures(loan:[String:Any]) {
        let friendID = loan.valueForString(key: "user_id")
        let tapGesture = CustomTapGestureRecognizer(target: self,action: #selector(tapSelector(sender:)))
        imgUser.addGestureRecognizer(tapGesture)
        imgUser.isUserInteractionEnabled = true
        tapGesture.friendID = friendID
        
    }
    
    func setupUserStatusChange(loan:[String:Any]) {
//        let friendID = loan.valueForString(key: "user_id")
//        let tapGesture = CustomTapGestureRecognizer(target: self,action: #selector(tapSelector(sender:)))
//        imgUser.addGestureRecognizer(tapGesture)
//        imgUser.isUserInteractionEnabled = true
//        tapGesture.friendID = friendID
        
    }
    
    func setupLblTapGestures(loan:[String:Any]) {
        let friendID = loan.valueForString(key: "user_id")
        let tapGesture = CustomTapGestureRecognizer(target: self,action: #selector(tapSelector(sender:)))
        lblUserName.addGestureRecognizer(tapGesture)
        lblUserName.isUserInteractionEnabled = true
        tapGesture.friendID = friendID
        
    }
    @objc func tapSelector(sender: CustomTapGestureRecognizer) {
        self.callbacks?(sender.friendID?.description ?? "")
    }
    
}
class CustomTapGestureRecognizer: UITapGestureRecognizer {
    var friendID: String?
}
