//
//  SharePostHelper.swift
//  Sevenchats
//
//  Created by mac-00020 on 20/08/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//

import Foundation
import UIKit


class SharePostHelper : NSObject{
    
    var viewcontroller:UIViewController?
    var dataSet: [String:Any]?
    //var postID : Int = 0
    var shareURL : String = ""
    var isFromQuote = false
    deinit {
        print("Deinit --> SharePostHelper")
    }
    
    init(controller:UIViewController?,dataSet:[String:Any]?) {
        self.viewcontroller = controller
        self.dataSet = dataSet
    }
    
    //MARK:-NEW
//        func presentShareActivity() {
//
//            self.viewcontroller?.presentActionsheetWithTwoButtonsNew(actionSheetTitle: nil, actionSheetMessage: nil, btnTwoTitle: CExternalShare, btnTwoStyle: .default) { (_) in
//                var shareText = CSharePostContentMsg
//                if self.isFromQuote{
//                    shareText = self.dataSet?["quote_desc"] as? String ?? ""
//                }
//                DispatchQueue.main.async {
//                    let activityItems = [shareText, self.shareURL]
//                    let activityController = UIActivityViewController(activityItems: activityItems as [Any], applicationActivities: nil)
//                    activityController.excludedActivityTypes = [.airDrop, .addToReadingList, .assignToContact, .copyToPasteboard, .mail, .message, .openInIBooks, .postToWeibo, .postToVimeo, .print]
//                    self.viewcontroller?.present(activityController, animated: true, completion: nil)
//                }
//            }
//        }
//
    func presentShareActivity() {
        self.viewcontroller?.presentActionsheetWithOneButton(actionSheetTitle: nil, actionSheetMessage: nil, btnOneTitle: CShareWithinSevenChats, btnOneStyle: .default) { (_) in
            DispatchQueue.main.async {
                if self.isFromQuote{
                    if let createShoutsVC = CStoryboardHome.instantiateViewController(withIdentifier: "CreateShoutsViewController") as? CreateShoutsViewController{
                        createShoutsVC.shoutsType = .shareQuote
                        createShoutsVC.shoutID = self.dataSet?[CId] as? Int ?? 0
                        createShoutsVC.quoteDesc = self.dataSet?["quote_desc"] as? String ?? ""
                        self.viewcontroller?.navigationController?.pushViewController(createShoutsVC, animated: true)
                    }
                }else{
                    if let sharePost = CStoryboardSharedPost.instantiateViewController(withIdentifier: "SharePostViewController") as? SharePostViewController{
                        sharePost.postData = self.dataSet ?? [:]
                        self.viewcontroller?.navigationController?.pushViewController(sharePost, animated: true)
                    }
                }
            }
        
        }

    /*    self.viewcontroller?.presentActionsheetWithTwoButtons(actionSheetTitle: nil, actionSheetMessage: nil, btnOneTitle: CShareWithinSevenChats, btnOneStyle: .default, btnOneTapped: { (_) in
            DispatchQueue.main.async {
                if self.isFromQuote{
                    if let createShoutsVC = CStoryboardHome.instantiateViewController(withIdentifier: "CreateShoutsViewController") as? CreateShoutsViewController{
                        createShoutsVC.shoutsType = .shareQuote
                        createShoutsVC.shoutID = self.dataSet?[CId] as? Int ?? 0
                        createShoutsVC.quoteDesc = self.dataSet?["quote_desc"] as? String ?? ""
                        self.viewcontroller?.navigationController?.pushViewController(createShoutsVC, animated: true)
                    }
                }else{
                    if let sharePost = CStoryboardSharedPost.instantiateViewController(withIdentifier: "SharePostViewController") as? SharePostViewController{
                        sharePost.postData = self.dataSet ?? [:]
                        self.viewcontroller?.navigationController?.pushViewController(sharePost, animated: true)
                    }
                }
            }
        }, btnTwoTitle: CExternalShare, btnTwoStyle: .default) { (_) in
            var shareText = CSharePostContentMsg
            if self.isFromQuote{
                shareText = self.dataSet?["quote_desc"] as? String ?? ""
            }
            DispatchQueue.main.async {
                let activityItems = [shareText, self.shareURL]
                let activityController = UIActivityViewController(activityItems: activityItems as [Any], applicationActivities: nil)
                activityController.excludedActivityTypes = [.airDrop, .addToReadingList, .assignToContact, .copyToPasteboard, .mail, .message, .openInIBooks, .postToWeibo, .postToVimeo, .print]
                self.viewcontroller?.present(activityController, animated: true, completion: nil)
            }
        }*/
    }
    }

