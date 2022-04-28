//
//  AboutUsViewController.swift
//  Sevenchats
//
//  Created by mac-0005 on 21/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Nagaraju K and Chandrika R                                 *
 * Model   : AboutUsViewController                       *
 * Changes :                                             *
 *                                                       *
 ********************************************************/

import UIKit
import WebKit

enum CMSType : Int {
    case aboutUS = 0
    case termsAndConditions = 1
    case privacyPolicy = 2
}

class AboutUsViewController: ParentViewController {

    var webView: WKWebView!
    @IBOutlet weak var vwWebView : UIView!{
        didSet{
            let webConfiguration = WKWebViewConfiguration()
            webView = WKWebView(frame: vwWebView.bounds, configuration: webConfiguration)
            vwWebView.addSubview(webView)
            vwWebView.sendSubviewToBack(webView)
            NSLayoutConstraint.activate([
                webView.topAnchor.constraint(equalTo: vwWebView.topAnchor),
                webView.bottomAnchor.constraint(equalTo: vwWebView.bottomAnchor),
                webView.leftAnchor.constraint(equalTo: vwWebView.leftAnchor),
                webView.rightAnchor.constraint(equalTo: vwWebView.rightAnchor)
                ])
        }
    }
    
    var cmsType : CMSType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Initialization()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    // MARK:- ---------- Initialization
    
    func Initialization(){
        switch cmsType.rawValue {
        case CMSType.aboutUS.rawValue:
            self.title = CSettingAboutus
            break
            
        case CMSType.termsAndConditions.rawValue:
            self.title = CSettingTermsAndConditions
            break
            
        default:
            self.title = CSettingPrivacyPolicy
            break
        }
        
        APIRequest.shared().loadCMS { [weak self] (response, error) in
            guard let self = self else { return }
            if response != nil && error == nil {
                
                let data = response?.value(forKey: CJsonData) as? [[String : AnyObject]]
                var content = ""
                
                switch self.cmsType.rawValue {
                case CMSType.aboutUS.rawValue :
                    content = data![0]["description"] as! String
                case CMSType.termsAndConditions.rawValue :
                    content = data![1]["description"] as! String
                default :
                    content = data![2]["description"] as! String
                }
                var htmString = "<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></header>"
                htmString += content
                self.webView.loadHTMLString(htmString, baseURL: nil)
            }
        }
    }
}
