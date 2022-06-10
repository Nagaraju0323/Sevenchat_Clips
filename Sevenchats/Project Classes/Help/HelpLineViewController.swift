//
//  HelpLineViewController.swift
//  Sevenchats
//
//  Created by APPLE on 08/06/22.
//  Copyright © 2022 mac-00020. All rights reserved.
//

import UIKit
import PDFKit

enum selectedVC{
    case homeVC
    case article
}

class HelpLineViewController: ParentViewController {
    
    @IBOutlet var pdfView: PDFView!
    var fromVC :String?
    var infoURL:URL?
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: CMessagePleaseWait)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        intilization()
        // Do any additional setup after loading the view.
    }
    func intilization(){
        
        switch fromVC {
        case "homeVC":
        infoURL = URL(string:"https://stg.sevenchats.com:3443/sevenchats/ProfilePic/helpScreeninfo_Home.pdf" )
        case "myProfileVC":
            infoURL = URL(string:"https://stg.sevenchats.com:3443/sevenchats/ProfilePic/helpScreeninfo_Myprofile.pdf" )
        case "ArticleVC":
            infoURL = URL(string:"https://stg.sevenchats.com:3443/sevenchats/ProfilePic/helpScreeninfo_Article.pdf" )
        case "ChirpyVC":
            infoURL = URL(string:"https://stg.sevenchats.com:3443/sevenchats/ProfilePic/helpScreeninfo_Chirpy.pdf" )
        case "EventVC":
            infoURL = URL(string:"https://stg.sevenchats.com:3443/sevenchats/ProfilePic/helpScreeninfo_Event.pdf" )
        case "ForumVC":
            infoURL = URL(string:"https://stg.sevenchats.com:3443/sevenchats/ProfilePic/helpScreeninfo_Forum.pdf" )
        case "ShoutVC":
            infoURL = URL(string:"https://stg.sevenchats.com:3443/sevenchats/ProfilePic/helpScreeninfo_Shout.pdf" )
        case "GalleryVC":
            infoURL = URL(string:"https://stg.sevenchats.com:3443/sevenchats/ProfilePic/helpScreeninfo_Gallery.pdf" )
        case "PollVC":
            infoURL = URL(string:"https://stg.sevenchats.com:3443/sevenchats/ProfilePic/helpScreeninfo_Poll.pdf" )
        case "friendsVC":
            infoURL = URL(string:"https://stg.sevenchats.com:3443/sevenchats/ProfilePic/helpScreeninfo_friends.pdf" )
        case "profilePreferenceVC":
            infoURL = URL(string:"https://stg.sevenchats.com:3443/sevenchats/ProfilePic/helpScreeninfo_profilepre.pdf" )
        case "ediProfileVC":
            infoURL = URL(string:"https://stg.sevenchats.com:3443/sevenchats/ProfilePic/helpScreeninfo_editprofile.pdf" )
        case "FeedBackVC":
            infoURL = URL(string:"https://stg.sevenchats.com:3443/sevenchats/ProfilePic/helpScreeninfo_feedback.pdf" )
        case "quotesVC":
            infoURL = URL(string:"https://stg.sevenchats.com:3443/sevenchats/ProfilePic/helpScreeninfo_quotes.pdf" )
        case "groupVC":
            infoURL = URL(string:"https://stg.sevenchats.com:3443/sevenchats/ProfilePic/helpScreeninfo_group.pdf" )
        case "chatVC":
            infoURL = URL(string:"https://stg.sevenchats.com:3443/sevenchats/ProfilePic/helpScreeninfo_chats.pdf" )
        case "newsVC":
            infoURL = URL(string:"https://stg.sevenchats.com:3443/sevenchats/ProfilePic/helpScreeninfo_news.pdf" )
      
        case "favVC":
            infoURL = URL(string:"https://stg.sevenchats.com:3443/sevenchats/ProfilePic/helpScreeninfofav.pdf" )
//
//        case "notificationVC":
//            infoURL = URL(string:"https://stg.sevenchats.com:3443/sevenchats/ProfilePic/helpScreeninfo_Poll.pdf" )
        case "pslVC":
            infoURL = URL(string:"https://stg.sevenchats.com:3443/sevenchats/ProfilePic/helpScreeninfo_psl.pdf" )
        case "productVC":
            infoURL = URL(string:"https://stg.sevenchats.com:3443/sevenchats/ProfilePic/helpScreeninfo_stores.pdf" )
        case "reportVC":
            infoURL = URL(string:"https://stg.sevenchats.com:3443/sevenchats/ProfilePic/helpScreeninfo_report.pdf" )
      
        case "rewardsVC":
            infoURL = URL(string:"https://stg.sevenchats.com:3443/sevenchats/ProfilePic/helpScreeninfo_rewards.pdf" )
        case "changepasswordVC":
            infoURL = URL(string:"https://stg.sevenchats.com:3443/sevenchats/ProfilePic/helpScreeninfo_changespwd.pdf" )
      
        default:
            print("Type is something else")
//            return
        }
            
        
        if let url = infoURL, let document = PDFDocument(url: url) {
            MILoader.shared.hideLoader()
            pdfView.document = document
            pdfView.displayMode = .singlePageContinuous
            self.edgesForExtendedLayout = []
            pdfView.autoScales = true
            pdfView.displayDirection = .vertical
        }
    }
    
    


}
