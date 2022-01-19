//
//  AudioSenderTblCell.swift
//  Sevenchats
//
//  Created by mac-0005 on 01/09/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

protocol AudioSenderCellDelegate {
    func cell(_ cell : AudioSenderTblCell, isPlay : Bool?)
}

class AudioSenderTblCell: UITableViewCell {

    var audioSenderCellDelegate : AudioSenderCellDelegate!
    @IBOutlet weak var lblMessageTime : UILabel!
    @IBOutlet weak var viewMessageContainer : UIView!
    @IBOutlet weak var audioSlider : UISlider!
    @IBOutlet weak var btnPlayPause : UIButton!
    @IBOutlet weak var imgMessageDelivered : UIImageView!
    @IBOutlet weak var btnFailed : UIButton!
    @IBOutlet weak var activityIndicator : UIActivityIndicatorView!
    @IBOutlet weak var btnAudioDownload : UIButton!
    @IBOutlet weak var lblForwarded : MIGenericLabel!
    
    @IBOutlet var vwForwarded : UIView!
    @IBOutlet var cntVWFrwHieght : NSLayoutConstraint!
    
    var messageInformation: TblMessages!
    
    var audioUrl: URL!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        GCDMainThread.async {
            self.imgMessageDelivered.tintColor = UIColor(hex: "#0080F3")
            self.viewMessageContainer.layer.cornerRadius = 8
            self.lblForwarded.text = CForwarded
        }
        
        audioSlider.setThumbImage(#imageLiteral(resourceName: "ic_slider_not"), for: .normal)
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

// MARK:- -------- Configuration
// MARK:-
extension AudioSenderTblCell {
    func configureAudioSenderCell(_ messageInfo: TblMessages?, _ isGesture: Bool) {
        
        messageInformation = messageInfo
        self.cntVWFrwHieght.constant = (messageInfo?.forwarded_msg_id?.isEmpty ?? true) ? 0 : 21
        //self.vwForwarded.hide(byHeight: (messageInfo?.forwarded_msg_id?.isEmpty ?? true))
        btnPlayPause.isSelected = false

        self.lblMessageTime.text = DateFormatter.dateStringFrom(timestamp: messageInfo?.msg_time, withFormate: "HH:mm a")
        
        // Delivered Status
        switch messageInfo?.message_Delivered {
        case 1:
            // Local
            self.imgMessageDelivered.image = UIImage(named: "ic_message_not_sent")
        case 2:
            // Sent
            self.imgMessageDelivered.image = UIImage(named: "ic_message_sent")
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
        
        self.activityIndicator.isHidden = true
        self.btnPlayPause.isHidden = true
        self.btnAudioDownload.isHidden = true
        
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
            
            // When Audio Downloaded then apply long press gesture..
//            if messageInfo?.message_Delivered != 1 && isGesture {
//                self.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(self.messageLongPress(_:))))
//            }
            
        }
        
        // Video Download button.
        self.btnAudioDownload.touchUpInside { [weak self] (sender) in
            guard let self = self else { return }
            self.btnAudioDownload.isHidden = true
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            ChatSocketIo.shared().downloadAudioVideoAndStoreInDocumentDirectorySocket(messageInfo)
//            MIMQTT.shared().downloadAudioVideoAndStoreInDocumentDirectory(messageInfo)
        }
        
        self.btnPlayPause.touchUpInside { [weak self] (sender) in
            guard let self = self else { return }
            if messageInfo?.localMediaUrl != nil {
                let audioPath = CTopMostViewController.applicationDocumentsDirectory()! + "/" + (messageInfo?.localMediaUrl)!
                if FileManager.default.fileExists(atPath: audioPath) {
                    self.btnPlayPause.isSelected = !self.btnPlayPause.isSelected
                    self.audioUrl = URL(fileURLWithPath: audioPath)
                    if self.audioSenderCellDelegate != nil{
                        self.audioSenderCellDelegate.cell(self, isPlay: self.btnPlayPause.isSelected)
                    }
                }else {
                    MIToastAlert.shared.showToastAlert(position: .bottom, message: CMessageMediaNotExist)
                }
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

// MARK:- -------- UILongPressGestureRecognizer
// MARK:-

extension AudioSenderTblCell {
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
            
            alertController.addAction(UIAlertAction(title: CBtnShare, style: .default, handler: { (alert) in
                /*// Share Audio
                let videoPath = CTopMostViewController.applicationDocumentsDirectory()! + "/" + (self.messageInformation.localMediaUrl ?? "")
                if FileManager.default.fileExists(atPath: videoPath) {
                    self.viewController?.presentActivityViewController(mediaData: URL(fileURLWithPath: videoPath), contentTitle: CSharePostContentMsg)
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
//                MIMQTT.shared().deleteDeliveredMessage(self.messageInformation, isSender: true)
            }))
            
            alertController.addAction(UIAlertAction(title: CBtnCancel, style: .cancel, handler: nil))
            
            self.viewController?.present(alertController, animated: true, completion: nil)
        }
        
    }
}

// MARK:- -------- Action Event
// MARK:-
extension AudioSenderTblCell{
    
    @IBAction func sliderDrag(_ slider : UISlider) {
        MIAudioPlayer.shared().seekToTime(Double(slider.value))
    }
    
}

// MARK:- Action's

extension AudioSenderTblCell {
    
    func redirectToForward(_ messageInfo: TblMessages?) {
        guard let forwardViewController  = CStoryboardForward.instantiateViewController(withIdentifier: "ForwardViewController") as? ForwardViewController else{
            return
        }
        forwardViewController.forwardMsg = messageInfo
        self.viewController?.navigationController?.pushViewController(forwardViewController, animated: true)
    }
}
