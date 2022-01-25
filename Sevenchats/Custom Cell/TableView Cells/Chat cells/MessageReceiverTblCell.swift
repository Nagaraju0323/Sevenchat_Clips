//
//  MessageReceiverTblCell.swift
//  Sevenchats
//
//  Created by mac-0005 on 31/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Chandrika.R                                 *
 * Model   : MessageReceiverTblCell                      *
 * Changes :                                             *
 *                                                       *
 ********************************************************/

enum CheckboxState: Int {
    case Checked = 1
    case Unchecked = 0
}

protocol MyTableViewCellDelegate {
    func tableViewCell(tableViewCell: MessageReceiverTblCell, didChangeCheckboxToState state: CheckboxState)
}


import UIKit
import MessageUI
class MessageReceiverTblCell: UITableViewCell {
    
    @IBOutlet var imgUser : UIImageView!
    @IBOutlet var lblUserName : UILabel!
    @IBOutlet var txtMessage : UITextView!
    @IBOutlet var lblMessageTime : UILabel!
    @IBOutlet var viewMessageContainer : UIView!
    @IBOutlet var vwForwarded : UIView!
    @IBOutlet var cntVWFrwHieght : NSLayoutConstraint!
    @IBOutlet weak var lblForwarded : MIGenericLabel!
    var arrSelectedRows:[Int] = []
  
    var messageInformation: TblMessages!
    var originalCenter = CGPoint()
    var deleteOnDragRelease = false, completeOnDragRelease = false
    var delegate: MyTableViewCellDelegate?
    
    static var ReciviedMsgCLK: ((_ messageinfo :TblMessages)-> ())?
    static var SelectedMsgCLK: ((_ messageinfo :TblMessages)-> ())?
    
    let userchatDetails = UserChatDetailViewController()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        GCDMainThread.async {
            self.imgUser.layer.cornerRadius = self.imgUser.frame.size.width/2
            self.viewMessageContainer.layer.cornerRadius = 8
            self.lblForwarded.text = CForwarded
        }
        txtMessage.delegate = self
       
    }

    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = panGestureRecognizer.translation(in: superview!)
            if abs(translation.x) > abs(translation.y) {
                return true
            }
            return false
        }
        return false
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


// MARK: - UITextViewDelegate
extension MessageReceiverTblCell : UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        print(URL.absoluteString)
        if (URL.scheme ?? "") == "mailto"{
            guard let email = URL.absoluteString.components(separatedBy: ":").last else {
                return false
            }
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = self
            mailComposer.setToRecipients(["\(email)"])
            mailComposer.setSubject("")
            mailComposer.setMessageBody("", isHTML: false)
            if MFMailComposeViewController.canSendMail() {
                self.viewController?.present(mailComposer, animated: true, completion: nil)
            }
            print(email)
            return false
        }else if (URL.scheme ?? "") == "tel" {
            callNumber(phoneCallURL: URL)
            return false
        }
        return true
    }
    
    func callNumber(phoneCallURL: URL) {
        let application:UIApplication = UIApplication.shared
        if (application.canOpenURL(phoneCallURL)){
            application.open(phoneCallURL, options: [:], completionHandler: nil)
        }
    }
}

// MARK: - MFMailComposeViewControllerDelegate
extension MessageReceiverTblCell : MFMailComposeViewControllerDelegate{
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

// MARK:- ---- Configuration
// MARK:-
extension MessageReceiverTblCell {
    func configureMessageReceiverCell(_ messageInfo: TblMessages?) {
        messageInformation = messageInfo
        
        self.cntVWFrwHieght.constant = (messageInfo?.forwarded_msg_id?.isEmpty ?? true) ? 0 : 21
        //self.vwForwarded.hide(byHeight: (messageInfo?.forwarded_msg_id?.isEmpty ?? true))
        
        if messageInfo?.chat_type == 2{
                  self.lblUserName.text = messageInfo?.full_name
                 self.imgUser.loadImageFromUrl(messageInfo?.profile_image, true)
              }else{
                  self.lblUserName.text = ""
              }
        
        
        
//                self.lblUserName.text = messageInfo?.full_name
//        self.lblUserName.text = ""
//        self.imgUser.loadImageFromUrl(messageInfo?.profile_image, true)
        self.txtMessage.isEditable = false
        
        if messageInfo?.is_auto_delete == 1{
//            viewMessageContainer.backgroundColor = UIColor(red: 233/250.0, green: 218/250.0, blue: 233/250.0, alpha: 1.0)
        }
        if messageInfo?.status_id == 2 || messageInfo?.status_id == 3{
            // For delete messages
            self.txtMessage.textColor = UIColor.lightGray
            self.txtMessage.font = CFontPoppins(size: 14, type: .boldItalic).setUpAppropriateFont()
            self.txtMessage.text = messageInfo?.status_id == 3 ? CDeleteMessageByAdmin : CDeleteMessageByUser
            self.lblMessageTime.text = nil
            _ = self.lblMessageTime.setConstraintConstant(0, edge: .top, ancestor: true)
        }else {
            _ = self.lblMessageTime.setConstraintConstant(8, edge: .top, ancestor: true)
            self.txtMessage.textColor = UIColor.black
            self.txtMessage.font = CFontPoppins(size: 14, type: .light).setUpAppropriateFont()
            self.txtMessage.text = messageInfo?.message
//            self.lblMessageTime.text = DateFormatter.dateStringFrom(timestamp: messageInfo?.msg_time, withFormate: "HH:mm a")
            self.lblMessageTime.text = DateFormatter.dateStringFrom(timestamp: messageInfo?.msg_time, withFormate: "HH:mm a")

        }
    }
        @objc func messageSwipePress(_ sender: UIPanGestureRecognizer) {
    
            if sender.state == .began {
                originalCenter = center
            }
            if sender.state == .changed {
                let translation = sender.translation(in: self)
                
                CGPoint(x: originalCenter.x + translation.x,y :originalCenter.y)
                center = CGPoint(x: originalCenter.x + translation.x,y :originalCenter.y)
                deleteOnDragRelease = frame.origin.x < -frame.size.width / 2.0
                completeOnDragRelease = frame.origin.x > frame.size.width / 2.0
                _ = abs(frame.origin.x) / (frame.size.width / 2.0)
            }
            if sender.state == .ended {
                let originalFrame = CGRect(x: 0, y: frame.origin.y,
                                           width: bounds.size.width, height: bounds.size.height)
                if deleteOnDragRelease {
                } else if completeOnDragRelease {
                    UIView.animate(withDuration: 0.2, animations: {self.frame = originalFrame})
                } else {
                    MessageReceiverTblCell.SelectedMsgCLK?(messageInformation)
                    UIView.animate(withDuration: 0.2, animations: {self.frame = originalFrame})
                }
            }
        }
}

// MARK:- Action's
extension MessageReceiverTblCell {
    
    func redirectToForward(_ messageInfo: TblMessages?) {
        guard let forwardViewController  = CStoryboardForward.instantiateViewController(withIdentifier: "ForwardViewController") as? ForwardViewController else{
            return
        }
        forwardViewController.forwardMsg = messageInfo
        self.viewController?.navigationController?.pushViewController(forwardViewController, animated: true)
    }
}



