//
//  LocationReceiverTblCell.swift
//  Sevenchats
//
//  Created by mac-00020 on 11/10/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//
/*********************************************************
 * Author  : Chandrika.R                                 *
 * Model   : RestrictedFilesVC                           *
 * Changes :                                             *
 *                                                       *
 ********************************************************/


import UIKit
import AVKit
import AVFoundation
import MapKit

class LocationReceiverTblCell: UITableViewCell {
    
    @IBOutlet weak var imgUser : UIImageView!
    @IBOutlet weak var lblUserName : UILabel!
    @IBOutlet weak var imgMessage : UIImageView!
    @IBOutlet weak var lblAddress : UILabel!
    @IBOutlet weak var lblMessageTime : UILabel!
    @IBOutlet weak var btnZoomImage : UIButton!
    @IBOutlet var vwForwarded : UIView!
    @IBOutlet weak var lblForwarded : MIGenericLabel!
    @IBOutlet var cntVWFrwHieght : NSLayoutConstraint!
    @IBOutlet var viewMessageContainer : UIView!
    var messageInformation: TblMessages!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        GCDMainThread.async {
            self.imgUser.layer.cornerRadius = self.imgUser.frame.size.width/2
            self.imgMessage.layer.cornerRadius = 8
            self.lblAddress.numberOfLines = 2
            self.viewMessageContainer.layer.cornerRadius = 8
            self.lblForwarded.text = CForwarded
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if Localization.sharedInstance.applicationFlowWithLanguageRTL() {
            lblUserName.textAlignment = .right
        }else{
            lblUserName.textAlignment = .left
        }
    }
    
    func rotateCell(){
        let radians = atan2f(Float(self.transform.b), Float(self.transform.a))
        let degrees = Double(radians) * (180 / .pi)
        if (degrees == 0){
            self.transform = CGAffineTransform(rotationAngle: .pi)
        }
    }
}

// MARK:- ------ Configuration
// MARK:-

extension LocationReceiverTblCell {
    func configureImageReceiverCell(_ messageInfo: TblMessages?) {
        
        messageInformation = messageInfo
        self.cntVWFrwHieght.constant = (messageInfo?.forwarded_msg_id?.isEmpty ?? true) ? 0 : 21
        //self.vwForwarded.hide(byHeight: (messageInfo?.forwarded_msg_id?.isEmpty ?? true))
        self.lblMessageTime.text = DateFormatter.dateStringFrom(timestamp: messageInfo?.msg_time, withFormate: "HH:mm a")
        self.imgUser.loadImageFromUrl(messageInfo?.profile_image, true)
//        self.lblUserName.text = messageInfo?.full_name
        
        //NEW CODE
//        self.lblUserName.text = messageInfo?.full_name
        if messageInfo?.chat_type == 2{
            self.lblUserName.text = messageInfo?.full_name
        }else {
            self.lblUserName.text = ""
        }
        self.lblAddress.text = messageInfo?.address ?? ""
        /* -------------------------------------------------- */
        /* ------------------- Image Message ------------- */
        /* -------------------------------------------------- */
        self.btnZoomImage.isHidden = false
        self.imgMessage.loadImageFromUrl(messageInfo?.message, false)
//        self.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(self.messageLongPress(_:))))
        
        // Buttom zoom image
        self.btnZoomImage.touchUpInside { [weak self] (sender) in
            guard let self = self else { return }
            self.openLocationInMap()
        }
    }
    
    func openLocationInMap(){
        let coordinate = CLLocationCoordinate2D(latitude: self.messageInformation.latitude, longitude: self.messageInformation.longitude)
        let mapAppsHelper = MapAppsHelper(coordinate: coordinate, address: self.messageInformation.address ?? "")
        
        let actionSheet = MapActionSheetViewController(mapOptions: mapAppsHelper.availableMapApps, coordinate: coordinate, address: self.messageInformation.address ?? "")
        // Show the action sheet
        self.viewController?.present(actionSheet, animated: true, completion: nil)
    }
    
}

// MARK:- ------ UILongPressGestureRecognizer
// MARK:-
extension LocationReceiverTblCell {
    
    @objc fileprivate func messageLongPress(_ sender : UILongPressGestureRecognizer) {
        
        if sender.state == .began {
            
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            /*alertController.addAction(UIAlertAction(title: CBtnShare, style: .default, handler: { (alert) in
                
                if self.imgMessage.image != nil {
                    self.viewController?.presentActivityViewController(mediaData: self.imgMessage.image, contentTitle: CSharePostContentMsg)
                }
            }))*/
            alertController.addAction(UIAlertAction(title: CForward, style: .default, handler: { (alert) in
                self.redirectToForward(self.messageInformation)
            }))
            alertController.addAction(UIAlertAction(title: CBtnDelete, style: .default, handler: { (alert) in
//                MIMQTT.shared().deleteDeliveredMessage(self.messageInformation, isSender: false)
            }))
            
            alertController.addAction(UIAlertAction(title: CBtnCancel, style: .cancel, handler: nil))
            
            self.viewController?.present(alertController, animated: true, completion: nil)
        }
        
    }
}
// MARK:- Action's

extension LocationReceiverTblCell {
    
    func redirectToForward(_ messageInfo: TblMessages?) {
        guard let forwardViewController  = CStoryboardForward.instantiateViewController(withIdentifier: "ForwardViewController") as? ForwardViewController else{
            return
        }
        forwardViewController.forwardMsg = messageInfo
        self.viewController?.navigationController?.pushViewController(forwardViewController, animated: true)
    }
}
