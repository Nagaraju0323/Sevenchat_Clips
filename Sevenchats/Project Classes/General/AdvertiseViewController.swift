//
//  AdvertiseViewController.swift
//  Sevenchats
//
//  Created by mac-0005 on 11/03/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//



import UIKit
import SDWebImage
import WebKit

class AdvertiseViewController: ParentViewController {
    
    @IBOutlet weak var cnNavigationHeight: NSLayoutConstraint! {
        didSet {
            cnNavigationHeight.constant = IS_iPhone_X_Series ? 84.0 : 64.0
        }
    }
    
    var webView: WKWebView!
    @IBOutlet weak var vwWebView : UIView!{
        didSet{
            let webConfiguration = WKWebViewConfiguration()
            webView = WKWebView(frame: vwWebView.bounds, configuration: webConfiguration)
            webView.navigationDelegate = self
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
    @IBOutlet weak var imgGIF: FLAnimatedImageView!
    @IBOutlet weak var btnCancel: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialization()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        MILoader.shared.hideLoader()
    }
}

// MARK:- ------ Initialization
// MARK:-
extension AdvertiseViewController {
    
    fileprivate func initialization() {
        
        SDWebImageCodersManager.sharedInstance().addCoder(SDWebImageGIFCoder.shared())
        btnCancel.setTitle(CBtnCancel, for: .normal)
        
        if let addInfo = self.iObject as? TblAdvertise {
            
            if addInfo.interactive_type == 1 {
                // URL
                MILoader.shared.showLoader(type: .activityIndicator, message: nil)
                self.webView.isHidden = false
                self.load(addInfo.interactive_value ?? "")
            }else if addInfo.interactive_type == 2 {
                // TEXT
                MILoader.shared.showLoader(type: .activityIndicator, message: nil)
                self.webView.isHidden = false
                var htmString = "<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></header>"
                htmString += addInfo.interactive_value ?? ""
                self.webView.loadHTMLString(htmString, baseURL: nil)
            }else {
                // GIF
                self.imgGIF.isHidden = false
                self.imgGIF.sd_setImage(with: URL(string: addInfo.interactive_value ?? ""), completed: nil)
                self.imgGIF.sd_cacheFLAnimatedImage = false
            }
        }
    }
    func load(_ urlString: String) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            self.webView.load(request)
        }
    }
}

// MARK:- ------ Action Event
// MARK:-
extension AdvertiseViewController : WKUIDelegate,WKNavigationDelegate{
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        MILoader.shared.hideLoader()
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
       MILoader.shared.hideLoader()
    }
}


// MARK:- ------ Action Event
// MARK:-
extension AdvertiseViewController {
    @IBAction func btnCancelCLK(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
