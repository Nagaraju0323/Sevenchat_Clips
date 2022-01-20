//
//  ImageReceiverTblCell.swift
//  Sevenchats
//
//  Created by mac-0005 on 31/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation


class ImageReceiverTblCell: UITableViewCell {

    @IBOutlet weak var imgUser : UIImageView!
    @IBOutlet weak var lblUserName : UILabel!
    @IBOutlet weak var imgMessage : UIImageView!
    @IBOutlet weak var lblMessageTime : UILabel!
    @IBOutlet weak var btnZoomImage : UIButton!
    @IBOutlet weak var btnVideoPlay : UIButton!
    @IBOutlet weak var btnVideoDownload : UIButton!
    @IBOutlet weak var viewVideoControl : UIView!
    @IBOutlet weak var activityIndicator : UIActivityIndicatorView!
    @IBOutlet weak var viewMessageContainer : UIView!
    @IBOutlet weak var vwForwarded : UIView!
    @IBOutlet weak var lblForwarded : MIGenericLabel!
    @IBOutlet var cntVWFrwHieght : NSLayoutConstraint!
    var messageInformation: TblMessages!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        GCDMainThread.async {
            self.imgUser.layer.cornerRadius = self.imgUser.frame.size.width/2
            self.imgMessage.layer.cornerRadius = 8
            self.viewVideoControl.layer.cornerRadius = 8
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
        if (degrees == 0)
        {
            self.transform = CGAffineTransform(rotationAngle: .pi)
        }
    }
}

// MARK:- ------ Configuration
// MARK:-

extension ImageReceiverTblCell {
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
        
        if messageInfo?.msg_type == 2 {
            /* -------------------------------------------------- */
            /* ------------------- Image Message ------------- */
            /* -------------------------------------------------- */
            self.btnZoomImage.isHidden = false
            self.viewVideoControl.isHidden = true
            self.imgMessage.loadImageFromUrl(messageInfo?.message, false)
//            self.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(self.messageLongPress(_:))))
            
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
            
            if messageInfo?.localMediaUrl == nil {
                
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
                
//                self.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(self.messageLongPress(_:))))
            }
            
            self.btnVideoPlay.touchUpInside { [weak self] (sender) in
                guard let self = self else { return }
                if messageInfo?.localMediaUrl != nil {
                    let videoPath = CTopMostViewController.applicationDocumentsDirectory()! + "/" + (messageInfo?.localMediaUrl)!
                    if FileManager.default.fileExists(atPath: videoPath) {
                        self.avPlayerSetup(CTopMostViewController, URL(fileURLWithPath: videoPath))
                    }else {
                        self.avPlayerSetup(CTopMostViewController, URL(string: (messageInfo?.message)!))
//                        MIToastAlert.shared.showToastAlert(position: .bottom, message: CMessageMediaNotExist)
                    }
                }
                else {
                    self.avPlayerSetup(CTopMostViewController, URL(string: (messageInfo?.message)!))
                }
            }
            
            
//            self.btnVideoPlay.touchUpInside { [weak self] (sender) in
//                guard let self = self else { return }
//                if messageInfo?.localMediaUrl != nil {
//                    let videoPath = CTopMostViewController.applicationDocumentsDirectory()! + "/" + (messageInfo?.localMediaUrl)!
//                    if FileManager.default.fileExists(atPath: videoPath) {
//                        self.avPlayerSetup(CTopMostViewController, URL(fileURLWithPath: videoPath))
//                    }else {
//                        MIToastAlert.shared.showToastAlert(position: .bottom, message: CMessageMediaNotExist)
//                    }
//                }
//                else {
//                    self.avPlayerSetup(CTopMostViewController, URL(string: (messageInfo?.message)!))
//                }
//            }
            
            
            self.btnVideoDownload.touchUpInside { [weak self] (sender) in
                guard let self = self else { return }
                self.btnVideoDownload.isHidden = true
                self.activityIndicator.isHidden = false
                self.activityIndicator.startAnimating()
                ChatSocketIo.shared().downloadAudioVideoAndStoreInDocumentDirectorySocket(messageInfo)
//                MIMQTT.shared().downloadAudioVideoAndStoreInDocumentDirectory(messageInfo)
            }
        }
    }
}

// MARK:- ------ AVPlayer
// MARK:-

extension ImageReceiverTblCell {
    func avPlayerSetup(_ viewController : UIViewController?, _ videoUrl: URL?) {
        
        if let url =  videoUrl {
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            }
            catch {
                print("Setting category to AVAudioSessionCategoryPlayback failed.")
            }
            
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

extension ImageReceiverTblCell {
    
//    @objc fileprivate func messageLongPress(_ sender : UILongPressGestureRecognizer) {
//        
//        if sender.state == .began {
//            
//            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//            alertController.addAction(UIAlertAction(title: CBtnShare, style: .default, handler: { (alert) in
//                
//                if self.messageInformation.msg_type == 2 {
//                    // Share Image
//                    if self.imgMessage.image != nil {
//                        self.viewController?.presentActivityViewController(mediaData: self.imgMessage.image, contentTitle: CSharePostContentMsg)
//                    }
//                } else {
//                    // Share Video
//                    /*guard let urlToDownload = URL(string: self.messageInformation?.message ?? "") else{
//                        return
//                    }
//                    
//                    if self.messageInformation.localMediaUrl != nil {
//                        let videoPath = CTopMostViewController.applicationDocumentsDirectory()! + "/" + (self.messageInformation.localMediaUrl!)
//                        if FileManager.default.fileExists(atPath: videoPath) {
//                            self.viewController?.presentActivityViewController(mediaData: URL(fileURLWithPath: videoPath), contentTitle: CSharePostContentMsg)
//                        }
//                    }*/
//                    guard let url = URL(string: self.messageInformation.message ?? "") else{return}
//                    
//                    if let fileSharing = FileSharingProgressVC.getInstance(){
//                        //fileSharing.presentController(controller:self)
//                        
//                        fileSharing.downloadfile(controller: self.viewController!, fileUrl: url, folderID: -500, completion: { (status, url) in
//                            if status{
//                                let objectsToShare = [url]
//                                let activityVC = UIActivityViewController(activityItems: objectsToShare as [Any], applicationActivities: nil)
//                                
//                                //New Excluded Activities Code
//                                //activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop]
//                                
//                                //activityVC.popoverPresentationController?.sourceView = sender
//                                self.viewController?.present(activityVC, animated: true, completion: nil)
//                                activityVC.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) -> Void in
//                                    print("activityVC.completionWithItemsHandler")
//                                    if let _url = url {
//                                        try! FileManager.default.removeItem(at: _url)
//                                    }
//                                    if completed == true {
//                                    }
//                                }
//                            }
//                        })
//                        return
//                    }
//                }
//            }))
//            alertController.addAction(UIAlertAction(title: CForward, style: .default, handler: { (alert) in
//                self.redirectToForward(self.messageInformation)
//            }))
//            alertController.addAction(UIAlertAction(title: CBtnDelete, style: .default, handler: { (alert) in
//                MIMQTT.shared().deleteDeliveredMessage(self.messageInformation, isSender: false)
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

extension ImageReceiverTblCell {
    
    func redirectToForward(_ messageInfo: TblMessages?) {
        guard let forwardViewController  = CStoryboardForward.instantiateViewController(withIdentifier: "ForwardViewController") as? ForwardViewController else{
            return
        }
        forwardViewController.forwardMsg = messageInfo
        self.viewController?.navigationController?.pushViewController(forwardViewController, animated: true)
    }
}
