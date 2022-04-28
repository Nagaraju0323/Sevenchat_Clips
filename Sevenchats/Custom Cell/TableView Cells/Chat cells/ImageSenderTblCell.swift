//
//  ImageSenderTblCell.swift
//  Sevenchats
//
//  Created by mac-0005 on 31/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
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

class ImageSenderTblCell: UITableViewCell {
    
    @IBOutlet weak var imgMessage : UIImageView!
    @IBOutlet weak var lblMessageTime : UILabel!
    @IBOutlet weak var btnFailed : UIButton!
    @IBOutlet weak var imgMessageDelivered : UIImageView!
    @IBOutlet weak var activityIndicator : UIActivityIndicatorView!
    @IBOutlet weak var btnVideoPlay : UIButton!
    @IBOutlet weak var btnVideoDownload : UIButton!
    @IBOutlet weak var viewVideoControl : UIView!
    @IBOutlet weak var btnZoomImage : UIButton!
    @IBOutlet var viewMessageContainer : UIView!
    @IBOutlet weak var lblForwarded : MIGenericLabel!
    @IBOutlet var vwForwarded : UIView!
    @IBOutlet var cntVWFrwHieght : NSLayoutConstraint!
    
    var messageInformation: TblMessages!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        GCDMainThread.async {
            self.imgMessageDelivered.tintColor = UIColor(hex: "#0080F3")
            self.imgMessage.layer.cornerRadius = 8
            self.viewVideoControl.layer.cornerRadius = 8
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
        if (degrees == 0)
        {
            self.transform = CGAffineTransform(rotationAngle: .pi)
        }
    }
}

// MARK:- ------ Configuration
// MARK:-

extension ImageSenderTblCell {
    func configureImageSenderCell(_ messageInfo: TblMessages?, _ isGesture: Bool) {
        
        messageInformation = messageInfo
        self.cntVWFrwHieght.constant = (messageInfo?.forwarded_msg_id?.isEmpty ?? true) ? 0 : 21
        //self.vwForwarded.hide(byHeight: (messageInfo?.forwarded_msg_id?.isEmpty ?? true))
//        created_at
//        self.lblMessageTime.text = DateFormatter.dateStringFrom(timestamp: messageInfo?.msg_time, withFormate: "HH:mm a")
 
        self.lblMessageTime.text = DateFormatter.dateStringFrom(timestamp: messageInfo?.msg_time, withFormate: "HH:mm a")
 
        // Delivered Status
        switch messageInfo?.message_Delivered {
        case 1:
            // Local
            //self.imgMessageDelivered.image = UIImage(named: "ic_message_not_sent")
            self.imgMessageDelivered.image = UIImage(named: "ic_message_delivered")
        case 2:
            // Sent
            //self.imgMessageDelivered.image = UIImage(named: "ic_message_sent")
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
        var isFileExists = false
        if messageInfo?.localMediaUrl != nil {
            let filePath = CTopMostViewController.applicationDocumentsDirectory()! + "/" + (messageInfo?.localMediaUrl)!
            if FileManager.default.fileExists(atPath: filePath) {
               isFileExists = true
            }
        }
        
        if messageInfo?.msg_type == 2 {
            /* -------------------------------------------------- */
            /* ------------------- Image Message ------------- */
            /* -------------------------------------------------- */

            self.imgMessage.backgroundColor = UIColor.lightGray
            self.viewVideoControl.isHidden = true
            self.btnZoomImage.isHidden = false
//            if messageInfo?.message_Delivered != 1 && isGesture {
//                self.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(self.messageLongPress(_:))))
//            }
            
            // Not Sent yet so showing from local...
//            if messageInfo?.localMediaUrl != nil {
//                let imgPath = CTopMostViewController.applicationDocumentsDirectory()! + (messageInfo?.localMediaUrl)!
//                if FileManager.default.fileExists(atPath: imgPath) {
//                    self.imgMessage.image = UIImage(contentsOfFile: imgPath)
//                }else {
//                    self.imgMessage.loadImageFromUrl(messageInfo?.message, false)
//                }
//            }
//            else {
//                self.imgMessage.loadImageFromUrl(messageInfo?.message, false)
//            }
            
            self.imgMessage.loadImageFromUrl(messageInfo?.message, false)
            
            // Buttom zoom image
            self.btnZoomImage.touchUpInside { [weak self] (sender) in
                guard let self = self else { return }
                self.viewController?.zoomGSImageViewer(self.imgMessage)
            }
        }else {
            /* -------------------------------------------------- */
            /* ------------------- Video Message ------------- */
            /* -------------------------------------------------- */
            self.btnZoomImage.isHidden = true
            self.viewVideoControl.isHidden = false
            self.activityIndicator.isHidden = true
            self.btnVideoPlay.isHidden = true
            self.btnVideoDownload.isHidden = true
            
            self.imgMessage.backgroundColor = UIColor.black

//            if messageInfo?.localMediaUrl == nil  || !isFileExists {
                if messageInfo?.localMediaUrl == nil  || !isFileExists {
                
                self.viewVideoControl.backgroundColor = CRGBA(r: 0, g: 0, b: 0, a: 0.5)
                // If downloading is going on..
                if (messageInfo?.isMediaDownloading)! {
                    activityIndicator.isHidden = false
                    activityIndicator.startAnimating()
                }else {
                    self.btnVideoDownload.isHidden = false
                }
            }else {
                self.btnVideoPlay.isHidden = false
                self.viewVideoControl.backgroundColor = UIColor.clear

                // When Video Downloaded then apply long press gesture..
//                if messageInfo?.message_Delivered != 1 && isGesture {
//                    self.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(self.messageLongPress(_:))))
//                }
            }

            // Get Video Thumbnail
            if messageInfo?.localMediaUrl != nil && messageInfo?.thumb_url == nil {
                
                let videoPath = CTopMostViewController.applicationDocumentsDirectory()! + "/" + (messageInfo?.localMediaUrl)!
                if FileManager.default.fileExists(atPath: videoPath) {
//                    MIMQTT.shared().getVideoThumbNail(URL(fileURLWithPath: videoPath)) { (image) in
//                        GCDMainThread.async {
//                            self.imgMessage.image = image
//                        }
//                    }
                }
            }else {
                if messageInfo?.thumb_url != nil {
                    self.imgMessage.loadImageFromUrl(messageInfo?.thumb_url, false)
                }
                
            }
            
//            self.avPlayerSetup(CTopMostViewController, URL(string: (messageInfo?.message)!))
            
            self.btnVideoPlay.touchUpInside { [weak self] (sender) in
                guard let self = self else { return }
                if messageInfo?.localMediaUrl != nil {
                    let videoPath = CTopMostViewController.applicationDocumentsDirectory()! + "/" + (messageInfo?.localMediaUrl)!
                    if FileManager.default.fileExists(atPath: videoPath) {
                        self.avPlayerSetup(CTopMostViewController, URL(fileURLWithPath: videoPath))
                    }else {
                        MIToastAlert.shared.showToastAlert(position: .bottom, message: CMessageMediaNotExist)
                    }
                }
                else {
                    self.avPlayerSetup(CTopMostViewController, URL(string: (messageInfo?.message)!))
                }
            }
            
            // Video Download button.
            self.btnVideoDownload.touchUpInside { [weak self] (sender) in
                guard let self = self else { return }
                self.btnVideoDownload.isHidden = true
                self.activityIndicator.isHidden = false
                self.activityIndicator.startAnimating()
                
                ChatSocketIo.shared().downloadAudioVideoAndStoreInDocumentDirectorySocket(messageInfo)
                
            }
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
}

// MARK:- ------ AVPlayer
// MARK:-

extension ImageSenderTblCell {
    
    func avPlayerSetup(_ viewController : UIViewController?, _ videoUrl: URL?) {
        
        if let url =  videoUrl {
            let player = AVPlayer(url: url)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            viewController?.present(playerViewController, animated: true) {
                playerViewController.player!.play()
            }
        }
    }
}

// MARK:- ------ UILongPressGestureRecognizer
// MARK:-

extension ImageSenderTblCell {
//    @objc fileprivate func messageLongPress(_ sender : UILongPressGestureRecognizer) {
//    
//        if sender.state == .began {
//            
//            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//            
//            if self.messageInformation.chat_type == 2 {
//                alertController.addAction(UIAlertAction(title: CBtnInfo, style: .default, handler: { (alert) in
//                    if let msgDetailVC = CStoryboardGroup.instantiateViewController(withIdentifier: "MessageDetailViewController") as? MessageDetailViewController {
//                        msgDetailVC.messageInfo = self.messageInformation
//                        self.viewController?.navigationController?.pushViewController(msgDetailVC, animated: true)
//                    }
//                }))
//            }
//            alertController.addAction(UIAlertAction(title: CForward, style: .default, handler: { (alert) in
//                self.redirectToForward(self.messageInformation)
//            }))
//            alertController.addAction(UIAlertAction(title: CBtnShare, style: .default, handler: { (alert) in
//                if self.messageInformation.msg_type == 2 {
//                    // Share Image
//                    if self.imgMessage.image != nil {
//                        self.viewController?.presentActivityViewController(mediaData: self.imgMessage.image, contentTitle: CSharePostContentMsg)
//                    }
//                } else {
//                    // Share Video
//                    if self.messageInformation.localMediaUrl != nil {
//                        let videoPath = CTopMostViewController.applicationDocumentsDirectory()! + "/" + (self.messageInformation.localMediaUrl ?? "")
//                        if FileManager.default.fileExists(atPath: videoPath) {
//                            self.viewController?.presentActivityViewController(mediaData: URL(fileURLWithPath: videoPath), contentTitle: CSharePostContentMsg)
//                        }
//                    }
//                }
//                /*let videoPath = CTopMostViewController.applicationDocumentsDirectory()! + "/" + (self.messageInformation.localMediaUrl ?? "")
//                print(URL(fileURLWithPath: videoPath).description)
//                guard let url = URL(string: self.messageInformation.message ?? "") else{return}
//                
//                if let fileSharing = FileSharingProgressVC.getInstance(){
//                    //fileSharing.presentController(controller:self)
//                    
//                    fileSharing.downloadfile(controller: self.viewController!, fileUrl: url, folderID: -500, completion: { (status, url) in
//                        if status{
//                            print("url : \(url?.absoluteString ?? "N/A")")
//                            let objectsToShare = [url]
//                            let activityVC = UIActivityViewController(activityItems: objectsToShare as [Any], applicationActivities: nil)
//                            
//                            //New Excluded Activities Code
//                            //activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop]
//                            
//                            //activityVC.popoverPresentationController?.sourceView = sender
//                            self.viewController?.present(activityVC, animated: true, completion: nil)
//                            activityVC.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) -> Void in
//                                print("activityVC.completionWithItemsHandler")
//                                if let _url = url {
//                                    try! FileManager.default.removeItem(at: _url)
//                                }
//                                if completed == true {
//                                }
//                            }
//                        }
//                    })
//                    return
//                }*/
//            }))
//
//            alertController.addAction(UIAlertAction(title: CBtnDelete, style: .default, handler: { (alert) in
//                MIMQTT.shared().deleteDeliveredMessage(self.messageInformation, isSender: true)
//            }))
//            
//            alertController.addAction(UIAlertAction(title: CBtnCancel, style: .cancel, handler: nil))
//            
//            self.viewController?.present(alertController, animated: true, completion: nil)
//        }
//        
//    }
}

// MARK:- Action's

extension ImageSenderTblCell {
    
    func redirectToForward(_ messageInfo: TblMessages?) {
        guard let forwardViewController  = CStoryboardForward.instantiateViewController(withIdentifier: "ForwardViewController") as? ForwardViewController else{
            return
        }
        forwardViewController.forwardMsg = messageInfo
        self.viewController?.navigationController?.pushViewController(forwardViewController, animated: true)
    }
}
