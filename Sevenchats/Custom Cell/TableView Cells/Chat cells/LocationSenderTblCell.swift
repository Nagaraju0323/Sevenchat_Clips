//
//  LocationSenderTblCell.swift
//  Sevenchats
//
//  Created by mac-00020 on 11/10/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Nagaraju K and Chandrika R                                 *
 * Model   : RestrictedFilesVC                           *
 * Changes :                                             *
 *                                                       *
 ********************************************************/

import UIKit
import AVKit
import AVFoundation
import PhotosUI
import MapKit

class LocationSenderTblCell: UITableViewCell {
    
    @IBOutlet weak var imgMessage : UIImageView!
    @IBOutlet weak var lblMessageTime : UILabel!
    @IBOutlet weak var lblAddress : UILabel!
    @IBOutlet weak var btnFailed : UIButton!
    @IBOutlet weak var imgMessageDelivered : UIImageView!
    
    @IBOutlet weak var btnZoomImage : UIButton!
    @IBOutlet var viewMessageContainer : UIView!
    @IBOutlet var vwForwarded : UIView!
    @IBOutlet weak var lblForwarded : MIGenericLabel!
    @IBOutlet var cntVWFrwHieght : NSLayoutConstraint!
    var messageInformation: TblMessages!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        GCDMainThread.async {
            self.imgMessageDelivered.tintColor = UIColor(hex: "#0080F3")
            self.imgMessage.layer.cornerRadius = 8
            self.lblAddress.numberOfLines = 2
            self.viewMessageContainer.layer.cornerRadius = 8
            self.lblForwarded.text = CForwarded
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
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
extension LocationSenderTblCell {
    func configureImageSenderCell(_ messageInfo: TblMessages?, _ isGesture: Bool) {
        
        messageInformation = messageInfo
        self.cntVWFrwHieght.constant = (messageInfo?.forwarded_msg_id?.isEmpty ?? true) ? 0 : 21
        //self.vwForwarded.hide(byHeight: (messageInfo?.forwarded_msg_id?.isEmpty ?? true))
        self.lblMessageTime.text = DateFormatter.dateStringFrom(timestamp: messageInfo?.msg_time, withFormate: "HH:mm a")
        self.lblAddress.text = messageInfo?.address ?? ""
        // Delivered Status
        switch messageInfo?.message_Delivered {
        case 1:
            // Local
           // self.imgMessageDelivered.image = UIImage(named: "ic_message_not_sent")
            self.imgMessageDelivered.image = UIImage(named: "ic_message_delivered")
        case 2:
            // Sent
           // self.imgMessageDelivered.image = UIImage(named: "ic_message_sent")
            self.imgMessageDelivered.image = UIImage(named: "ic_message_delivered")
        default:
            // Read
            self.imgMessageDelivered.image = UIImage(named: "ic_message_delivered")
        }
        
        if !(messageInfo?.isMediaUploadedOnServer)! && messageInfo?.isMediaUploadingRunning == 1 {
            // Show Retry Button
            btnFailed.isHidden = false
        }else {
            // Hide Retry Button
            btnFailed.isHidden = true
        }
        
        /* -------------------------------------------------- */
        /* ------------------- Image Message ------------- */
        /* -------------------------------------------------- */
        
        self.imgMessage.backgroundColor = UIColor.lightGray
        self.btnZoomImage.isHidden = false
        if messageInfo?.message_Delivered != 1 && isGesture {
//            self.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(self.messageLongPress(_:))))
        }
        
        // Not Sent yet so showing from local...
        if messageInfo?.localMediaUrl != nil {
            let imgPath = CTopMostViewController.applicationDocumentsDirectory()! + (messageInfo?.localMediaUrl)!
            if FileManager.default.fileExists(atPath: imgPath) {
                self.imgMessage.image = UIImage(contentsOfFile: imgPath)
            }else {
                print("media does not exist in deivce ======== ")
                self.imgMessage.loadImageFromUrl(messageInfo?.message, false)
            }
        }
        else {
            self.imgMessage.loadImageFromUrl(messageInfo?.message, false)
        }
        
        // Buttom zoom image
        self.btnZoomImage.touchUpInside { [weak self] (sender) in
            guard let self = self else { return }
            //self.viewController?.zoomGSImageViewer(self.imgMessage)
            self.openLocationInMap()
        }
        
        // Button Failed
        self.btnFailed.touchUpInside { [weak self] (sender) in
            guard let self = self else { return }
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            alertController.addAction(UIAlertAction(title: CBtnSendAgain, style: .default, handler: { (alert) in
//                MIMQTT.shared().uploadMediaOnServer(messageInfo)
            }))
            
            alertController.addAction(UIAlertAction(title: CBtnDelete, style: .default, handler: { (alert) in
                self.viewController?.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: CMessageDelete, btnOneTitle: CBtnYes, btnOneTapped: { (alert) in
//                    MIMQTT.shared().deleteMessageFromLocal(messageInfo)
                }, btnTwoTitle: CBtnNo, btnTwoTapped: nil)
            }))
            
            alertController.addAction(UIAlertAction(title: CBtnCancel, style: .cancel, handler: nil))
            
            CTopMostViewController.present(alertController, animated: true, completion: nil)
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
extension LocationSenderTblCell {
    
    @objc fileprivate func messageLongPress(_ sender : UILongPressGestureRecognizer) {
        
        if sender.state == .began {
            
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            if self.messageInformation.chat_type == 2 {
                alertController.addAction(UIAlertAction(title: CBtnInfo, style: .default, handler: { (alert) in
                    if let msgDetailVC = CStoryboardGroup.instantiateViewController(withIdentifier: "MessageDetailViewController") as? MessageDetailViewController {
                        msgDetailVC.messageInfo = self.messageInformation
                        self.viewController?.navigationController?.pushViewController(msgDetailVC, animated: true)
                    }
                }))
            }
            
            /*alertController.addAction(UIAlertAction(title: CBtnShare, style: .default, handler: { (alert) in
                if self.imgMessage.image != nil {
                    self.viewController?.presentActivityViewController(mediaData: self.imgMessage.image, contentTitle: CSharePostContentMsg)
                }
            }))*/
            
            alertController.addAction(UIAlertAction(title: CForward, style: .default, handler: { (alert) in
                self.redirectToForward(self.messageInformation)
            }))
            
            alertController.addAction(UIAlertAction(title: CBtnDelete, style: .default, handler: { (alert) in
//                MIMQTT.shared().deleteDeliveredMessage(self.messageInformation, isSender: true)
            }))
            
            alertController.addAction(UIAlertAction(title: CBtnCancel, style: .cancel, handler: nil))
            
            self.viewController?.present(alertController, animated: true, completion: nil)
        }
        
    }
}

// MARK:- Action's

extension LocationSenderTblCell {
    
    func redirectToForward(_ messageInfo: TblMessages?) {
        guard let forwardViewController  = CStoryboardForward.instantiateViewController(withIdentifier: "ForwardViewController") as? ForwardViewController else{
            return
        }
        forwardViewController.forwardMsg = messageInfo
        self.viewController?.navigationController?.pushViewController(forwardViewController, animated: true)
    }
}
