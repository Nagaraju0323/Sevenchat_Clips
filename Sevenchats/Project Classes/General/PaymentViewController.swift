//
//  PaymentViewController.swift
//  Sevenchats
//
//  Created by mac-0005 on 12/09/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Nagaraju K and Chandrika R                                 *
 * Model   : PaymentViewController                       *
 * Changes :                                             *
 *                                                       *
 ********************************************************/

import UIKit
fileprivate let sevenchatsyear = "com.sevenchats.yearlyadv"

class PaymentViewController: ParentViewController {

    @IBOutlet var btnLetsEnjoy : UIButton!
    @IBOutlet var lblInformation : UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Initialization()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK:- ---------- Initialization
    
    func Initialization(){
        self.title = CNavPayment
        
        var imgBack = #imageLiteral(resourceName: "ic_back")
        if Localization.sharedInstance.applicationFlowWithLanguageRTL() {
            imgBack = #imageLiteral(resourceName: "ic_back_reverse")
        }
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: imgBack, style: .plain, target: self, action: #selector(btnBackClicked(_:)))
        btnLetsEnjoy.layer.cornerRadius = 5
        
//        You are the using free version of the social app to have an ads-free experience switch to the paid version worth ₹ 700 per Annum Ada Free app usage.
        let attrs = [NSAttributedString.Key.font : CFontPoppins(size: lblInformation.font.pointSize, type: .light),
                     NSAttributedString.Key.foregroundColor: CRGB(r: 104, g: 104, b: 104)]
        let attrs1 = [NSAttributedString.Key.font : CFontPoppins(size: lblInformation.font.pointSize + 3, type: .semibold),
                      NSAttributedString.Key.foregroundColor: CRGB(r: 116, g: 116, b: 116)]
        
        let attributedString = NSMutableAttributedString(string: "You are the using free version of the social app to have an ads-free experience switch to the paid version worth ", attributes:attrs)
        let price = "$99.99"
        let normalString = NSMutableAttributedString(string: price, attributes:attrs1)
        let attributedString2 = NSMutableAttributedString(string: " per Annum Ada Free app usage.", attributes:attrs)
        attributedString.append(normalString)
        attributedString.append(attributedString2)
        lblInformation.attributedText = attributedString
        
    }
}

// MARK:- --------- Action Event
extension PaymentViewController {
    
    @objc fileprivate func btnBackClicked(_ sender : UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnLetsEnjoyCLK(_ sender : UIButton){
        //...Remove Advretisement API
        MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: "\(CMessagePleaseWait)...")
        MIGeneralsAPI.shared().removeAdvertisement(transactionID: "abc") { (_) in
            MILoader.shared.hideLoader()
        }
    }
}
