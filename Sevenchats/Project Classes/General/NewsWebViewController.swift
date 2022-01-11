//
//  NewsWebViewController.swift
//  Sevenchats
//
//  Created by mac-00010 on 28/01/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//

import UIKit
import WebKit

class NewsWebViewController: ParentViewController {
    
    var webView: WKWebView!
    var pslTitle = ""
    var pslUrl = ""
    
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
    
    @IBOutlet weak var activityLoader : UIActivityIndicatorView!
    
    var isFavWebSite = false
    var isPSLwebStire:Bool?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialization()
        if isPSLwebStire == true {
            self.initializationPsl()
        }
    }
    
    func initialization() {
        if let newInfo = self.iObject as? [String : Any] {
            
            activityLoader.isHidden = false
            activityLoader.startAnimating()
            self.webView.frame = self.view.bounds
            
            
            if isFavWebSite {
                self.title = newInfo.valueForString(key: "title")
                self.load(newInfo.valueForString(key: "favourite_website_url"),isFrom:false)
            }else {
                self.title = newInfo.valueForString(key: "title")
                self.load(newInfo.valueForString(key: "url"),isFrom:false)
            }
        }
    }
    
    func initializationPsl(){
        self.title = pslTitle
        self.loadPSL(pslUrl)
    }
 
    
    func loadPSL(_ urlString: String) {
        
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            self.webView.load(request)
        }
    }
    
    func load(_ urlString: String,isFrom:Bool) {
        if isFrom == true {
            if let url = URL(string: "https://\(urlString)") {
                let request = URLRequest(url: url)
                self.webView.load(request)
            }
        }else {
            
            if let url = URL(string:(urlString)) {
                let request = URLRequest(url: url)
                self.webView.load(request)
            }
        }
        
    }
}

//MARK:-
//MARK:- Webview Delegate
extension NewsWebViewController : WKUIDelegate,WKNavigationDelegate{
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activityLoader.isHidden = true
        activityLoader.stopAnimating()
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityLoader.isHidden = true
        activityLoader.stopAnimating()
    }
}
