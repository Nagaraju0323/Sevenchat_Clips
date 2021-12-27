//
//  NotificationAlertView.swift
//  Nerd
//
//  Created by Mac-00014 on 16/05/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

class NotificationAlertView: UIView {

    @IBOutlet var vwContent : UIView!
    @IBOutlet var imgView : UIImageView!
    @IBOutlet var lblTitle : UILabel!
    @IBOutlet var lblMessage : UILabel!
    @IBOutlet var btnDetails : UIButton!
    
    var gradient:CAGradientLayer?
    var gradientBlack:CAGradientLayer?
    
    
    private static let notificationAlertView:NotificationAlertView? = {
        guard let notificationAlertView = NotificationAlertView.viewFromXib as? NotificationAlertView else { return nil}
        return notificationAlertView
    }()
    
    static var shared:NotificationAlertView? {
        return notificationAlertView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        vwContent.layer.cornerRadius = 10
        vwContent.layer.borderWidth = 4
        vwContent.layer.borderColor = ColorAppTheme.cgColor
        vwContent.layer.masksToBounds = true
        self.tag = -99856
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if gradient != nil {
            gradient?.frame =  vwContent.bounds
        }
        if gradientBlack != nil {
            gradientBlack?.frame =  self.bounds
        }
    }
    func showNotification(_ title : String?, message : String?, imageName: String?, completion: ((Bool) -> Void)?) {
        
        
        if let alert = appDelegate.window.viewWithTag(-99856) {
            gradient?.removeFromSuperlayer()
            gradientBlack?.removeFromSuperlayer()
            alert.removeFromSuperview()
        }
        
            lblTitle.text = title
            lblMessage.text = message
        
        if imageName == nil || imageName?.count == 0 {
            imgView.hide(byWidth: true)
            imgView.hide(byHeight: true)
            _ = imgView.setConstraintConstant(0, edge: .leading, ancestor: true)
            
        } else {
            imgView.hide(byWidth: false)
            imgView.hide(byHeight: false)
            _ = imgView.setConstraintConstant(12, edge: .leading, ancestor: true)
            imgView.image = UIImage(named: imageName!)
            imgView.sd_setImage(with: URL(string: imageName!), placeholderImage: nil)
        }
        
        if gradient == nil {
            gradient = CAGradientLayer()
            gradient?.frame = vwContent.bounds
            
            vwContent.layer.insertSublayer(gradient!, at: 0)
            gradient?.colors = [
                ColorAppTheme.cgColor,
                CRGB(r: 106, g: 155, b: 104).cgColor
            ]
        }
        
        if gradientBlack == nil {
            gradientBlack = CAGradientLayer()
            gradientBlack?.frame = self.bounds
            
            self.layer.insertSublayer(gradientBlack!, at: 0)
            gradientBlack?.colors = [
//                CRGB(r: 0, g: 0, b: 0).cgColor,
//                CRGBA(r: 60, g: 66, b: 120, a: 0.3).cgColor
                UIColor.clear.cgColor,
                UIColor.clear.cgColor
            ]
        }
        
        self.CViewSetWidth(width: CScreenWidth)
        self.lblMessage.layoutIfNeeded()
        self.lblMessage.updateConstraintsIfNeeded()
        self.lblTitle.layoutIfNeeded()
        self.lblTitle.updateConstraintsIfNeeded()
        self.layoutIfNeeded()
        let height = self.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        self.CViewSetHeight(height: height)
        self.CViewSetX(x: 0)
        self.CViewSetY(y: IS_iPhone_X ? 44 : 0)
        
        self.CViewSetY(y: -500)
        appDelegate.window.addSubview(self)
        
//        self.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        
        UIView.animate(withDuration: 0.2, animations: {
            self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.CViewSetY(y: IS_iPhone_X ? 44 : 0)
        }, completion: { (completed) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                UIView.animate(withDuration: 0.6, animations: {
                    self.alpha = 0.0
                }, completion: { (complete) in
                    self.removeFromSuperview()
                    self.alpha = 1.0
                })
            }
        })
        
        btnDetails.touchUpInside { [weak self] (sender) in
            guard let self = self else { return }
            if completion != nil {
                self.removeFromSuperview()
                completion!(true)
            }
        }
    }
}
