//
//  HomePollTblCell.swift
//  Sevenchats
//
//  Created by mac-0005 on 14/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Chandrika.R                                 *
 * Model   : HomePollTblCell                             *
 * Changes :  HomeSharedPollTblCell                      *
 *                                                       *
 ********************************************************/

import UIKit

class HomeSharedPollTblCell: UITableViewCell {
    
    @IBOutlet weak var viewMainContainer : UIView!
    @IBOutlet weak var viewSubContainer : UIView!
    @IBOutlet weak var lblPollTitle : UILabel!
    @IBOutlet weak var imgUser : UIImageView!
    @IBOutlet weak var lblUserName : UILabel!
    @IBOutlet weak var lblPollPostDate : UILabel!
    @IBOutlet weak var lblPollType : UILabel!
    @IBOutlet weak var lblPollCategory : UILabel!
    @IBOutlet weak var btnLikesCount : UIButton!
    @IBOutlet weak var btnLike : UIButton!
    @IBOutlet weak var btnComment : UIButton!
    @IBOutlet weak var btnShare : UIButton!
    @IBOutlet weak var btnIconShare : UIButton!
    @IBOutlet weak var btnMore : UIButton!
    @IBOutlet weak var btnProfileImg : UIButton!
    @IBOutlet weak var btnUserName : UIButton!
    @IBOutlet weak var lblVoteCount : UILabel!
    @IBOutlet weak var tblVAnswre: PollOptionTableView!
    
    @IBOutlet weak var lblSharedPostDate : UILabel!
    @IBOutlet weak var imgSharedUser : UIImageView!
    @IBOutlet weak var lblSharedUserName : UILabel!
    @IBOutlet weak var btnSharedProfileImg : UIButton!
    @IBOutlet weak var btnSharedUserName : UIButton!
    @IBOutlet weak var lblMessage : UILabel!
    @IBOutlet weak var lblSharedPostType : UILabel!
    
    var postData : [String:Any] = [:]
    var likeCount = 0
    var postID = 0
    var onMorePressed : ((Int) -> Void)?
    
    var likeTotalCount = 0
    var like =  0
    var info = [String:Any]()
    var posted_ID = ""
    var notifcationIsSlected = false
    var isLikesOthers:Bool?
    var isLikeSelected = false
    var isFinalLikeSelected = false
    var isLikesOthersPage:Bool?
    var isLikesHomePage:Bool?
    var isLikesMyprofilePage:Bool?
    var posted_IDOthers = ""
    var notificationInfo = [String:Any]()
    var  is_Selected: String = ""
    var chngString:String?
    var profileImg = ""
    var totalVotesNew = ""
    var pollIDNew : Int?
    var fullNameArr:[String] = []
    var voteCount:Int?
    var polls : [MDLPollOption] = []
    var arrPostList = [String : Any]()
    var arr = [String]()
    var dictArray = [String]()
    var pollOptionArr:[String] = []
    var totalVotes = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        lblSharedPostType.text = CSharedPoll
        self.viewSubContainer.layer.cornerRadius = 8
        self.viewMainContainer.layer.cornerRadius = 8
        self.viewMainContainer.shadow(color: CRGB(r: 237, g: 236, b: 226), shadowOffset: CGSize(width: 0, height: 5), shadowRadius: 10.0, shadowOpacity: 10.0)
        
        self.imgUser.layer.cornerRadius = self.imgUser.frame.size.width/2
        self.imgUser.layer.borderWidth = 2
        self.imgUser.layer.borderColor = #colorLiteral(red: 0, green: 0.7881455421, blue: 0.7100172639, alpha: 1)
        self.lblPollType.layer.cornerRadius = 3
        
        self.imgSharedUser.layer.cornerRadius = self.imgSharedUser.frame.size.width/2
        self.imgSharedUser.layer.borderWidth = 2
        self.imgSharedUser.layer.borderColor = #colorLiteral(red: 0, green: 0.7881455421, blue: 0.7100172639, alpha: 1)
        
        self.tblVAnswre.reloadData()
        self.layoutIfNeeded()
        self.tblVAnswre.layoutIfNeeded()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

// MARK:- ---------- Data Setup
extension HomeSharedPollTblCell{
    
    func homePollDataSetup(_ postInfo : [String : Any]){
        
        postID = postInfo.valueForString(key: "post_id").toInt ?? 0
        
        notificationInfo = postInfo
        
        if isLikesOthersPage == true {
            posted_ID = self.posted_IDOthers
        }else {
            posted_ID = postInfo.valueForString(key: "user_id")
        }
        
        tblVAnswre.postinfo = postInfo
        postID = postInfo.valueForString(key: "post_id").toInt ?? 0
        pollIDNew = postInfo.valueForString(key: "post_id").toInt ?? 0
        if isLikesOthersPage == true {
            posted_ID = self.posted_IDOthers
            tblVAnswre.isSelectedByUser = postInfo.valueForString(key: "friend_selected")
            self.is_Selected = postInfo.valueForString(key: "friend_selected")
            voteCount = postInfo.valueForString(key: "total_count").toInt ?? 0
            tblVAnswre.isLikesOthersPage = true
        }else {
            posted_ID = postInfo.valueForString(key: "user_id")
            tblVAnswre.isSelectedByUser = postInfo.valueForString(key: "is_selected")
            self.is_Selected = postInfo.valueForString(key: "is_selected")
            voteCount = postInfo.valueForString(key: "total_count").toInt ?? 0
            tblVAnswre.isLikesOthersPage = false
        }
        postData = postInfo
        
        
        
        
       // if let sharedData = postInfo[CSharedPost] as? [String:Any]{
            self.lblSharedUserName.text = postInfo.valueForString(key: CFullName) + " " + postInfo.valueForString(key: CLastName)
        let shared_created_at = postInfo.valueForString(key: CShared_Created_at)
                let shared_cnvStr = shared_created_at.stringBefore("G")
                let shared_Date = DateFormatter.shared().convertDatereversLatest(strDate: shared_cnvStr)
                lblSharedPostDate.text = shared_Date
           // self.lblSharedPostDate.text = DateFormatter.dateStringFrom(timestamp: postInfo.valueForDouble(key: CCreated_at), withFormate: CreatedAtPostDF)
            imgSharedUser.loadImageFromUrl(postInfo.valueForString(key: CUserSharedProfileImage), true)
            lblMessage.text = postInfo.valueForString(key: CMessage)
       // }

        postData = postInfo
        lblUserName.text = postInfo.valueForString(key: CFirstname) + " " + postInfo.valueForString(key: CLastname)
        let created_at = postInfo.valueForString(key: CCreated_at)
                let cnvStr = created_at.stringBefore("G")
                let Created_Date = DateFormatter.shared().convertDatereversLatest(strDate: cnvStr)
        lblPollPostDate.text = Created_Date
        //lblPollPostDate.text = DateFormatter.dateStringFrom(timestamp: postInfo.valueForDouble(key: CCreated_at), withFormate: CreatedAtPostDF)
        lblPollTitle.text = postInfo.valueForString(key: CTitle)
        
        imgUser.loadImageFromUrl(postInfo.valueForString(key: CUserProfileImage), true)
//        if let pollsData = postInfo[CPollData] as? [String:Any] {
//
//            let voteCount = pollsData.valueForInt(key:CAllVotes) ?? 0
//            self.updateVoteCount(count: voteCount)
//            tblVAnswre.updateVoteCount = { [weak self] (votesCount) in
//                guard let _ = self else {return}
//                self?.updateVoteCount(count: votesCount)
//            }
//
//            tblVAnswre.refreshOnVoteWithData = { [weak self] (optionData,countVoted) in
//                guard let self = self else {return}
////                DispatchQueue.main.async {
////                    MIGeneralsAPI.shared().refreshPollPostRelatedScreens(self.postData, self.tblVAnswre.postID, self.tblVAnswre.userVotedPollId, optionData: optionData, self.viewController,isSelected: false)
////                }
//                DispatchQueue.main.async {
//                    MIGeneralsAPI.shared().refreshPollPostRelatedScreens(self.postData, self.tblVAnswre.postID, self.tblVAnswre.userVotedPollId, optionData: optionData, self.viewController!,.polladded, isSelected: false)
//                }
//            }
//
//            var polls : [MDLPollOption] = []
//            for obj in pollsData[CPolles] as? [[String : Any]] ?? []{
//                polls.append(MDLPollOption(fromDictionary: obj))
//            }
//            tblVAnswre.totalVotes = voteCount
//            tblVAnswre.arrOption = polls
//
//            if postInfo.valueForString(key: CUserId) == "\(String(describing: appDelegate.loginUser?.user_id ?? 0))"{
//                tblVAnswre.isSelected = true
//            }else{
//                tblVAnswre.isSelected = postInfo.valueForBool(key: CIsUserVoted)
//            }
//
//            tblVAnswre.userVotedPollId = postInfo.valueForInt(key: CUserVotedPoll) ?? 0
//
//            let isSharedPost = postInfo.valueForInt(key: CIsSharedPost)
//            if isSharedPost == 1{
//                tblVAnswre.postID = postInfo.valueForInt(key: COriginalPostId) ?? 0
//            }else{
//                tblVAnswre.postID = postInfo.valueForInt(key: CId) ?? 0
//            }
//            tblVAnswre.userID = postInfo.valueForInt(key: CUserId) ?? 0
//
//            tblVAnswre.reloadData()
//        }
//
//        lblPollType.text = CTypePoll
//
//        lblPollCategory.text = postInfo.valueForString(key: CCategory).uppercased()

        
        var polls : [MDLPollOption] = []
        if isSelected == true {
            //myprofile
            let pollstring = postData["options"] as? String
            let rplstr_Frirst = pollstring?.replacingOccurrences(of: "\"", with: "")
            let rplstr_Second = rplstr_Frirst?.replacingOccurrences(of: "[", with: "")
            let rplstr_Three = rplstr_Second?.replacingOccurrences(of: "]", with: "")
            chngString = rplstr_Three
        }else {
            //homeviewcontroller
            let pollstring = postData["options"] as? String
            let rplstr_Frirst = pollstring?.replacingOccurrences(of: "\"", with: "")
            let rplstr_Second = rplstr_Frirst?.replacingOccurrences(of: "[", with: "")
            let rplstr_Three = rplstr_Second?.replacingOccurrences(of: "]", with: "")
            chngString = rplstr_Three
            // fullNameArr =  jsonToStringConvert(pollString: postData["options"] as? String ?? "")
        }
        
        let fullNameArr:[String] = chngString?.components(separatedBy:",") ?? []
        var dictionary = [String: String]()
        for player in fullNameArr {
            dictionary["poll_text"] = player
            polls.append(MDLPollOption(fromDictionary: dictionary))
        }
        self.getPollDetailsFromServer()
        voteCount =  self.totalVotesNew.toInt ?? 0
        self.updateVoteCount(count: voteCount ?? 0)
        tblVAnswre.updateVoteCount = { [weak self] (votesCount) in
            guard let _ = self else {return}
            self?.updateVoteCount(count: votesCount)
        }
        tblVAnswre.totalVotes = voteCount ?? 0
        tblVAnswre.arrOption = polls
        
        if postInfo.valueForString(key:"is_selected") == "N/A" ||  postInfo.valueForString(key:"friend_selected") == "N/A"{
            tblVAnswre.isSelected = false
        }else {
            tblVAnswre.isSelected = false
        }
        tblVAnswre.userVotedPollId = postInfo.valueForInt(key: CUserVotedPoll) ?? 0
        tblVAnswre.userEmailID = postInfo.valueForString(key: "user_email")
        
        lblPollType.text = CTypePoll
        tblVAnswre.dictArray = self.dictArray
        tblVAnswre.totalVotesNew = totalVotes
        
        lblPollCategory.text = postInfo.valueForString(key: CCategory).uppercased()
        tblVAnswre.refreshOnVoteWithData = { [weak self] (optionData,countuser) in
            let post_id = optionData["post_id"] as? String
            guard let self = self else {return}
            DispatchQueue.main.async {
                MIGeneralsAPI.shared().refreshPollPostRelatedScreens(self.postData, post_id?.toInt, self.tblVAnswre.userVotedPollId, optionData: optionData, self.viewController, .polladded, isSelected: false)
//                self.tblVAnswre.reloadData()
            }
        }
        

        
        
//        btnLike.isSelected = postInfo.valueForInt(key: CIs_Like) == 1
//        likeCount = postInfo.valueForInt(key: CTotal_like) ?? 0
//        btnLikesCount.setTitle(appDelegate.getLikeString(like: likeCount), for: .normal)
        
        if isLikesOthersPage == true {
            if postInfo.valueForString(key:"friend_liked") == "Yes"  && postInfo.valueForString(key:"is_liked") == "Yes" {
                btnLike.isSelected = true
                if postInfo.valueForString(key:"is_liked") == "No"{
                    isLikeSelected = false
                }
            }else {
                if postInfo.valueForString(key:"is_liked") == "No" && postInfo.valueForString(key:"friend_liked") == "No" {
                    isLikeSelected = true
                }
                btnLike.isSelected = false
            }
            
            if postInfo.valueForString(key:"is_liked") == "Yes" && postInfo.valueForString(key:"friend_liked") == "No" {
                isLikeSelected = true
                btnLike.isSelected = false
            }else if postInfo.valueForString(key:"is_liked") == "No" && postInfo.valueForString(key:"friend_liked") == "Yes"{
                
                isLikeSelected = false
                btnLike.isSelected = true
            }
        }
        if isLikesHomePage == true  || isLikesMyprofilePage == true {
            if postInfo.valueForString(key:CIs_Liked) == "Yes"{
                btnLike.isSelected = true
            }else {
                btnLike.isSelected = false
            }
        }
        likeCount = postInfo.valueForString(key: CLikes).toInt ?? 0
        btnLikesCount.setTitle(appDelegate.getLikeString(like: likeCount), for: .normal)
        let commentCount = postInfo.valueForString(key: "comments").toInt ?? 0
        btnComment.setTitle(appDelegate.getCommentCountString(comment: commentCount), for: .normal)
        
        
        self.tblVAnswre.reloadData()
        
        btnShare.setTitle(CBtnShare, for: .normal)
        self.layoutIfNeeded()
        
        
        
        
        
        
        
        
        
        
    }
    
    fileprivate func updateVoteCount(count:Int){
        if count == 1{
            self.lblVoteCount.text = "\(count) \(CVote)"
        }else{
            self.lblVoteCount.text = "\(count) \(CVotes)"
        }
    }
}

//MARK: - IBAction's
extension HomeSharedPollTblCell {
    
    @IBAction func onLikePressed(_ sender:UIButton){
        
//        self.btnLike.isSelected = !self.btnLike.isSelected
//        self.likeCount = self.btnLike.isSelected ? self.likeCount + 1 : self.likeCount - 1
//        self.btnLikesCount.setTitle(appDelegate.getLikeString(like: self.likeCount), for: .normal)
//        MIGeneralsAPI.shared().likeUnlikePostWebsite(post_id: self.postID, rss_id: nil, type: 1, likeStatus: self.btnLike.isSelected ? 1 : 0, viewController: self.viewController)
        
        
        self.btnLike.isSelected = !self.btnLike.isSelected
        if self.btnLike.isSelected == true{
            likeCount = 1
            like = 1
            notifcationIsSlected = true
            
            if isLikesOthersPage  == true {
                if isLikeSelected == true{
                    self.isFinalLikeSelected = true
                    isLikeSelected = false
                }else {
                    self.isFinalLikeSelected = false
                }
            }
        }else {
            likeCount = 2
            like = 0
            
            if isLikesOthersPage == true {
                if isLikeSelected == false{
                    self.isFinalLikeSelected = false
                    isLikeSelected = false
                }else {
                    self.isFinalLikeSelected = false
                }
            }
        }
        guard let userID = appDelegate.loginUser?.user_id else {
            return
        }
        APIRequest.shared().likeUnlikeProducts(userId: Int(userID), productId: Int(self.postID), isLike: likeCount){ [weak self](response, error) in
            guard let _ = self else { return }
            if response != nil {
                GCDMainThread.async {
                    let infodatass = response![CJsonData] as? [[String:Any]] ?? [[:]]
                    for infora in infodatass{
                        self?.info = infora
                    }
                    let data = response![CJsonMeta] as? [String:Any] ?? [:]
                    let stausLike = data["status"] as? String ?? "0"
                    if stausLike == "0"{
                        self?.likeCountfromSever(productId: Int((self?.self.postID)!),likeCount:self?.likeCount ?? 0, postInfo: self?.info ?? [:],like:self?.like ?? 0)
                    }
                }
            }
        }
    }
    
    func likeCountfromSever(productId: Int,likeCount:Int,postInfo:[String:Any],like:Int){
        APIRequest.shared().likeUnlikeProductCount(productId: Int(self.postID) ){ [weak self](response, error) in
            guard let _ = self else { return }
            if response != nil {
                GCDMainThread.async { [self] in
                    self?.likeTotalCount = response?["likes_count"] as? Int ?? 0
                    self?.btnLikesCount.setTitle(appDelegate.getLikeString(like: self?.likeTotalCount ?? 0), for: .normal)
                    guard let user_ID = appDelegate.loginUser?.user_id.description else { return }
                    guard let firstName = appDelegate.loginUser?.first_name else {return}
                    guard let lastName = appDelegate.loginUser?.last_name else {return}
                    
                    if self?.notifcationIsSlected == true{
                        
                        if self?.posted_ID == user_ID {
                            
                        }else {
                            if self?.isLikesOthersPage == true {
                                self?.notificationInfo["friend_liked"] = "Yes"
                            }
                            if self?.isLikesHomePage == true  || self?.isLikesMyprofilePage == true {
                                self?.notificationInfo["is_liked"] = "Yes"
                            }
                            self?.notificationInfo["likes"] = self?.likeTotalCount.toString
                            MIGeneralsAPI.shared().sendNotification(self?.posted_ID, userID: user_ID, subject: "liked your Post", MsgType: "COMMENT", MsgSent: "", showDisplayContent: "liked your Post", senderName: firstName + lastName, post_ID: self?.notificationInfo ?? [:])
                            
                            if let metaInfo = response![CJsonMeta] as? [String : Any] {
                                let stausLike = metaInfo["status"] as? String ?? "0"
                                if stausLike == "0" {
                                }
                            }
                        }
                        self?.notifcationIsSlected = false
                    }
                    if self?.isLikesOthersPage == true {
                        if self?.isFinalLikeSelected == true{
                            MIGeneralsAPI.shared().likeUnlikePostWebsites(post_id: Int(self?.postID ?? 0), rss_id: 1, type: 1, likeStatus: self?.like ?? 0 ,info:postInfo, viewController: self?.viewController)
                            self?.isLikeSelected = false
                        }else {
                            MIGeneralsAPI.shared().likeUnlikePostWebsites(post_id: Int(self?.postID ?? 0), rss_id: 2, type: 1, likeStatus: self?.like ?? 0 ,info:postInfo, viewController: self?.viewController)
                            
                        }
                    }
                    if  self?.isLikesHomePage == true || self?.isLikesMyprofilePage == true {
                        MIGeneralsAPI.shared().likeUnlikePostWebsites(post_id: Int(self?.postID ?? 0), rss_id: 3, type: 1, likeStatus: self?.like ?? 0 ,info:postInfo, viewController: self?.viewController)
                    }
                    
                }
            }
            
        }
        
    }
    
    @IBAction func onMorePressed(_ sender:UIButton){
        onMorePressed?(sender.tag)
    }
    
    func getPollDetailsFromServer() {
        //        self.parentView.isHidden = true
        if let artID = self.pollIDNew {
            APIRequest.shared().viewPollDetailNew(postID: artID){ [weak self] (response, error) in
                guard let self = self else { return }
                if response != nil {
                    //self.parentView.isHidden = false
//                    DispatchQueue.main.async {
                        if let Info = response!["data"] as? [[String:Any]]{
                            for articleInfo in Info {
                                self.totalVotesNew = articleInfo["total_count"] as? String ?? "0"
//                                self.is_Selected = articleInfo["is_selected"] as? String ?? ""
                                    self.is_Selected = articleInfo["is_selected"] as? String ?? ""
//                                   self.totalVotes = articleInfo["total_count"] as? String ?? ""
//                                var polls : [MDLPollOption] = []
                                let pollstring = articleInfo["options"] as? String
                                    let rplstr_Frirst = pollstring?.replacingOccurrences(of: "\"", with: "")
                                    let rplstr_Second = rplstr_Frirst?.replacingOccurrences(of: "[", with: "")
                                    let rplstr_Three = rplstr_Second?.replacingOccurrences(of: "]", with: "")
                                self.chngString = rplstr_Three
                                
                                let fullNameArr:[String] = self.chngString?.components(separatedBy:",") ?? []
                                var dictionary = [String: String]()
                                for player in fullNameArr {
                                    dictionary["poll_text"] = player
                                    self.polls.append(MDLPollOption(fromDictionary: dictionary))
                                }
                               let postID = articleInfo["post_id"] as? String ?? ""
                                
                                self.postDetails(postID: postID)
                            }
//                        }
                    }
                }
            }
        }
    }
    
    func postDetails(postID:String){
        var para = [String:Any]()
        para["id"] = postID
        para["user_id"] = appDelegate.loginUser?.user_id.description
        
        APIRequest.shared().votePollDetails(para: para) { [weak self] (response, error) in
            guard let _ = self else {return}
            if response != nil{
                self?.arr.removeAll()
                var arrayData  = ["0","0","0","0"]
                if let data = response![CData] as? [[String:Any]]{
                    if data.count == 1 {
                        for datas in data{
                            self?.polls = []
                            let objarray = (datas["options"] as? String ?? "" ).replace(string: "\"", replacement: "")
                            
                            self!.pollOptionArr =  self?.jsonToStringConvert(pollString:datas["options"] as? String ?? "") ?? []
                            let obj = datas["results"] as? [String : AnyObject] ?? [:]
                            if obj.count == 1 {
                                self?.arrPostList =  obj
                                for (key, value) in obj {
                                let indexOfA  = self?.pollOptionArr.firstIndex(of: key)
                                    if indexOfA == 0{
                                        self?.arr = ["\(value)","0","0","0"]
                                 }else if indexOfA == 1{
                                    self?.arr = ["0","\(value)","0","0"]
                                    }else if indexOfA == 2{
                                    self?.arr = ["0","0","\(value)","0"]
                                    }else if indexOfA == 3{
                                    self?.arr = ["0","0","0","\(value)",]
                                    }
                                }
                            }else {
                                self?.arrPostList =  obj
                                for (key, value) in obj {
                                let indexOfA  = self?.pollOptionArr.firstIndex(of: key)
                                    arrayData.remove(at: indexOfA ?? 0)
                                    arrayData.insert("\(value)", at: indexOfA ?? 0)
                                }
                                self?.arr += arrayData
                            }
                            self?.dictArray = self?.arr ?? []
                            self?.totalVotes = datas.valueForString(key: "total_count")
                            
                        }
                    }
                }
            }
        }
    }
}


extension HomeSharedPollTblCell{
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func jsonToStringConvert(pollString:String) -> [String]{
        var jsonStrPoll = [String]()
        let data = pollString.data(using: .utf8)!
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String]{
                jsonStrPoll = jsonArray
            } else {
                print("bad json")
            }
        } catch let error as NSError {
            print(error)
        }
        return jsonStrPoll
    }
    
    
}



