//
//  AudioReceiverTblCell.swift
//  Sevenchats
//
//  Created by mac-0005 on 01/09/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit
import AVFoundation

protocol AudioReceiverCellDelegate {
    func cell(_ cell : AudioReceiverTblCell, isPlay : Bool?)
}

class AudioReceiverTblCell: UITableViewCell {
    
    
    @IBOutlet weak var imgUser : UIImageView!
    @IBOutlet weak var lblUserName : UILabel!
    @IBOutlet weak var lblMessageTime : UILabel!
    @IBOutlet weak var viewMessageContainer : UIView!
    @IBOutlet weak var audioSlider : UISlider!
    @IBOutlet weak var btnPlayPause : UIButton!
    @IBOutlet weak var activityIndicator : UIActivityIndicatorView!
    @IBOutlet weak var btnAudioDownload : UIButton!
    @IBOutlet var vwForwarded : UIView!
    @IBOutlet weak var lblForwarded : MIGenericLabel!
    @IBOutlet var cntVWFrwHieght : NSLayoutConstraint!
    var messageInformation: TblMessages!
    
    var audioUrl: URL!
    var trackTimer: Timer?
    var audioReceiverCellDelegate : AudioReceiverCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        GCDMainThread.async {
            self.imgUser.layer.cornerRadius = self.imgUser.frame.size.width/2
            self.viewMessageContainer.layer.cornerRadius = 8
            self.lblForwarded.text = CForwarded
        }
        
        audioSlider.setThumbImage(#imageLiteral(resourceName: "ic_slider_not"), for: .normal)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if Localization.sharedInstance.applicationFlowWithLanguageRTL() {
            lblUserName.textAlignment = .right
        }else{
            lblUserName.textAlignment = .left
        }
    }
    
    func rotateCell() {
        let radians = atan2f(Float(self.transform.b), Float(self.transform.a))
        let degrees = Double(radians) * (180 / .pi)
        if (degrees == 0) {
            self.transform = CGAffineTransform(rotationAngle: .pi)
        }
    }
}

// MARK:- -------- Configuration
// MARK:-

extension AudioReceiverTblCell {
    func configureAudioReceiverCell(_ messageInfo: TblMessages?) {
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
        
        self.activityIndicator.isHidden = true
        self.btnAudioDownload.isHidden = true
        self.btnPlayPause.isHidden = true
        
        var isFileExists = false
        if messageInfo?.localMediaUrl != nil {
            let filePath = CTopMostViewController.applicationDocumentsDirectory()! + "/" + (messageInfo?.localMediaUrl)!
            if FileManager.default.fileExists(atPath: filePath) {
               isFileExists = true
            }
        }
        
        if messageInfo?.localMediaUrl == nil || !isFileExists {
            
            // If downloading is going on..
            if (messageInfo?.isMediaDownloading)! {
                activityIndicator.isHidden = false
                activityIndicator.startAnimating()
            }else {
                self.btnAudioDownload.isHidden = false
            }
        }else {
            self.btnPlayPause.isHidden = false
//            self.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(self.messageLongPress(_:))))
        }
        
        self.btnPlayPause.touchUpInside { [weak self] (sender) in
            guard let self = self else { return }
            if messageInfo?.localMediaUrl != nil {
                let videoPath = CTopMostViewController.applicationDocumentsDirectory()! + "/" + (messageInfo?.localMediaUrl)!
                if FileManager.default.fileExists(atPath: videoPath) {
                    self.btnPlayPause.isSelected = !self.btnPlayPause.isSelected
                    self.audioUrl = URL(fileURLWithPath: videoPath)
                    if self.audioReceiverCellDelegate != nil{
                        self.audioReceiverCellDelegate.cell(self, isPlay: self.btnPlayPause.isSelected)
                    }
                }else {
                    MIToastAlert.shared.showToastAlert(position: .bottom, message: CMessageMediaNotExist)
                }
            }
        }
        
        self.btnAudioDownload.touchUpInside { [weak self] (sender) in
            guard let self = self else { return }
            self.btnAudioDownload.isHidden = true
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            ChatSocketIo.shared().downloadAudioVideoAndStoreInDocumentDirectorySocket(messageInfo)
//            MIMQTT.shared().downloadAudioVideoAndStoreInDocumentDirectory(messageInfo)
        }
        
    }
}

// MARK:- -------- UILongPressGestureRecognizer
// MARK:-

extension AudioReceiverTblCell {
    @objc fileprivate func messageLongPress(_ sender : UILongPressGestureRecognizer) {
        
        if sender.state == .began {

            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            alertController.addAction(UIAlertAction(title: CBtnShare, style: .default, handler: { (alert) in
                // Share Audio
                /*if self.messageInformation.localMediaUrl != nil {
                    let videoPath = CTopMostViewController.applicationDocumentsDirectory()! + "/" + (self.messageInformation.localMediaUrl ?? "")
                    if FileManager.default.fileExists(atPath: videoPath) {
                        self.viewController?.presentActivityViewController(mediaData: URL(fileURLWithPath: videoPath), contentTitle: CSharePostContentMsg)
                    }
                }*/
                guard let url = URL(string: self.messageInformation.message ?? "") else{return}
                
                if let fileSharing = FileSharingProgressVC.getInstance(){
                    //fileSharing.presentController(controller:self)
                    
                    fileSharing.downloadfile(controller: self.viewController!, fileUrl: url, folderID: -500, completion: { (status, url) in
                        if status{
                            let objectsToShare = [url]
                            let activityVC = UIActivityViewController(activityItems: objectsToShare as [Any], applicationActivities: nil)
                            
                            //New Excluded Activities Code
                            //activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop]
                            
                            //activityVC.popoverPresentationController?.sourceView = sender
                            self.viewController?.present(activityVC, animated: true, completion: nil)
                            activityVC.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) -> Void in
                                print("activityVC.completionWithItemsHandler")
                                if let _url = url {
                                    try! FileManager.default.removeItem(at: _url)
                                }
                                if completed == true {
                                }
                            }
                        }
                    })
                    return
                }
            }))
            
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

// MARK:- -------- Action Event
// MARK:-
extension AudioReceiverTblCell{
    
    @IBAction func sliderDrag(_ slider : UISlider){
        MIAudioPlayer.shared().seekToTime(Double(slider.value))
    }
    
}

// MARK:- Action's

extension AudioReceiverTblCell {
    
    func redirectToForward(_ messageInfo: TblMessages?) {
        guard let forwardViewController  = CStoryboardForward.instantiateViewController(withIdentifier: "ForwardViewController") as? ForwardViewController else{
            return
        }
        forwardViewController.forwardMsg = messageInfo
        self.viewController?.navigationController?.pushViewController(forwardViewController, animated: true)
    }
}
