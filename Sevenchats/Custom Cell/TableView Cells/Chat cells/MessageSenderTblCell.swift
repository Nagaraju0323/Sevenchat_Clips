//
//  MessageSenderTblCell.swift
//  Sevenchats
//
//  Created by mac-0005 on 31/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit
import MessageUI

class ChatTextView : UITextView , UITextViewDelegate {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.delegate = self
    }
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if !NSEqualRanges(textView.selectedRange, NSMakeRange(0, 0)){
            textView.selectedRange = NSMakeRange(0, 0)
        }
    }
}

class MessageSenderTblCell: UITableViewCell {

    @IBOutlet var imgMessageDelivered : UIImageView!
    @IBOutlet var txtMessage : UITextView!
    @IBOutlet var lblMessageTime : UILabel!
    @IBOutlet var viewMessageContainer : UIView!
    @IBOutlet var vwForwarded : UIView!
    @IBOutlet var cntVWFrwHieght : NSLayoutConstraint!
    @IBOutlet weak var lblForwarded : MIGenericLabel!
    var messageInformation : TblMessages!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        txtMessage.delegate = self
        GCDMainThread.async {
            self.imgMessageDelivered.tintColor = UIColor(hex: "#0080F3")
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

// MARK:- ---- Configuration
// MARK:-

extension MessageSenderTblCell {
    func configureMessageSenderCell(_ messageInfo: TblMessages?, _ isGesture: Bool) {
        self.messageInformation = messageInfo
        self.txtMessage.isEditable = false
        self.cntVWFrwHieght.constant = (messageInfo?.forwarded_msg_id?.isEmpty ?? true) ? 0 : 21
        //self.vwForwarded.hide(byHeight: (messageInfo?.forwarded_msg_id?.isEmpty ?? true))
        if messageInfo?.is_auto_delete == 1{
            print("this will count=======")
            viewMessageContainer.backgroundColor = UIColor(red: 233/250.0, green: 218/250.0, blue: 233/250.0, alpha: 1.0)
        }
        if messageInfo?.status_id == 2 || messageInfo?.status_id == 3 {
            // For delete messages
            self.txtMessage.textColor = UIColor.lightGray
            self.txtMessage.font = CFontPoppins(size: 14, type: .boldItalic).setUpAppropriateFont()
            self.txtMessage.text = messageInfo?.status_id == 3 ? CDeleteMessageByAdmin : CDeleteMessageByUser
            self.lblMessageTime.text = nil
            self.imgMessageDelivered.isHidden = true
            _ = self.lblMessageTime.setConstraintConstant(0, edge: .top, ancestor: true)
        } else {
        
          
            _ = self.lblMessageTime.setConstraintConstant(8, edge: .top, ancestor: true)
            self.txtMessage.textColor = UIColor.black
            self.txtMessage.font = CFontPoppins(size: 14, type: .light).setUpAppropriateFont()
            self.txtMessage.text = messageInfo?.message
            self.lblMessageTime.text = DateFormatter.dateStringFrom(timestamp: messageInfo?.msg_time, withFormate: "HH:mm a")
            
//           Add long press to view message detail...
            if messageInfo?.message_Delivered != 1 && isGesture{
//                self.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(self.messageLongPress(_:))))
            }
//            if messageInfo?.message_Delivered != 1 && isGesture{
//                self.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(self.messageLongPress(_:))))
//            }
            
            self.imgMessageDelivered.isHidden = false
            
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
                print("Read Message This methodCall ========= =========")
                
            }
        }
    }
}

// MARK: - UITextViewDelegate
extension MessageSenderTblCell : UITextViewDelegate {
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
extension MessageSenderTblCell : MFMailComposeViewControllerDelegate{
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

// MARK:- Action's

extension MessageSenderTblCell {
    
    func redirectToForward(_ messageInfo: TblMessages?) {
        guard let forwardViewController  = CStoryboardForward.instantiateViewController(withIdentifier: "ForwardViewController") as? ForwardViewController else{
            return
        }
        forwardViewController.forwardMsg = messageInfo
        self.viewController?.navigationController?.pushViewController(forwardViewController, animated: true)
    }
}



