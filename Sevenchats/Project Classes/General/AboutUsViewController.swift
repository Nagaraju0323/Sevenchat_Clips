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
    var arrList = [[String : Any]?]()
    var titles = [String]()

    
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
                
                self.titles.removeAll()
                self.arrList =  data ?? [[:]]
                for arr in self.arrList{
                    let title = arr?.valueForString(key: "title") ?? ""
                    let rmSpaces = title.replacingOccurrences(of: " ", with: "").lowercased()
                    self.titles.append(rmSpaces)
                }

//                switch self.cmsType.rawValue {
//                case CMSType.aboutUS.rawValue :
//
//                    content = data![4]["description"] as! String
//                case CMSType.termsAndConditions.rawValue :
//                    content = data![2]["description"] as! String
//                default :
//                    content = data![3]["description"] as! String
//                }
                
                //Modified Code
                var aboutus : Bool?
                switch self.cmsType.rawValue {
                case CMSType.aboutUS.rawValue :
                    if let index = self.titles.firstIndex(of: "aboutus") {
//                        content = data![index]["description"] as! String
                        content = "https://about.sevenchats.com"
                        aboutus = true
                    }
                case CMSType.termsAndConditions.rawValue :
                    if let index = self.titles.firstIndex(of: "termsandconditions") {
                        content = data![index]["description"] as! String
                        aboutus = false
                    }
                default :
                    if let index = self.titles.firstIndex(of: "privacypolicy") {
                        content = data![index]["description"] as! String
                        aboutus = false
                    }
                }
                
                if aboutus == true {
                    
                    let url = URL(string: "https://about.sevenchats.com")
                     let requestObj = URLRequest(url: url! as URL)
                    self.webView.load(requestObj)
                    aboutus = false
                    
                }else{
                    var htmString = "<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no', shrink-to-fit=YES></header>"
                    htmString += content
                    self.webView.loadHTMLString(htmString, baseURL: nil)
                    aboutus = false
                }
                
                
                
                
                
                
            }
        }
    }
}
