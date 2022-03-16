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
 * Description : HomePollTblCell                         *
 ********************************************************/


import UIKit

class HomePollTblCell: UITableViewCell {
    
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
    
    var postData : [String:Any] = [:]
    var likeCount = 0
    var postID = 0
    
    var onMorePressed : ((Int) -> Void)?
    var likeTotalCount = 0
    var like =  0
    var info = [String:Any]()
    
    var chngString:String?
    var posted_ID = ""
    var profileImg = ""
    var totalVotesNew = ""
    var pollIDNew : Int?
    var notifcationIsSlected = false
    var fullNameArr:[String] = []
    var isLikesOthers:Bool?
    var isLikeSelected = false
    var isFinalLikeSelected = false
    var isLikesOthersPage:Bool?
    var isLikesHomePage:Bool?
    var isLikesMyprofilePage:Bool?
    var posted_IDOthers = ""
    var  is_Selected: String = ""
    var notificationInfo = [String:Any]()
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
        self.viewSubContainer.layer.cornerRadius = 8
        self.viewMainContainer.layer.cornerRadius = 8
        self.viewMainContainer.shadow(color: CRGB(r: 237, g: 236, b: 226), shadowOffset: CGSize(width: 0, height: 5), shadowRadius: 10.0, shadowOpacity: 10.0)
        self.imgUser.layer.cornerRadius = self.imgUser.frame.size.width/2
        self.imgUser.layer.borderWidth = 2
        self.imgUser.layer.borderColor = #colorLiteral(red: 0, green: 0.7881455421, blue: 0.7100172639, alpha: 1)
        self.lblPollType.layer.cornerRadius = 3
        self.tblVAnswre.reloadData()
        self.layoutIfNeeded()
        self.tblVAnswre.layoutIfNeeded()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

// MARK:- ---------- Data Setup
extension HomePollTblCell{
    
    func homePollDataSetup(_ postInfo : [String : Any],isSelected:Bool){
        self.info  = postInfo
        notificationInfo = postInfo
        tblVAnswre.postinfo = postInfo
        postID = postInfo.valueForString(key: "post_id").toInt ?? 0
        pollIDNew = postInfo.valueForString(key: "post_id").toInt ?? 0
        if isLikesOthersPage == true {
            posted_ID = self.posted_IDOthers
            tblVAnswre.isSelectedByUser = postInfo.valueForString(key: "is_selected")
            self.is_Selected = postInfo.valueForString(key: "is_selected")
            voteCount = postInfo.valueForString(key: "total_count").toInt ?? 0
            tblVAnswre.totalVotes = voteCount ?? 0
            tblVAnswre.isLikesOthersPage = true
        }else {
            posted_ID = postInfo.valueForString(key: "user_id")
            tblVAnswre.isSelectedByUser = postInfo.valueForString(key: "is_selected")
            self.is_Selected = postInfo.valueForString(key: "is_selected")
            voteCount = postInfo.valueForString(key: "total_count").toInt ?? 0
            tblVAnswre.totalVotes = voteCount ?? 0
            tblVAnswre.isLikesOthersPage = false
        }
        postData = postInfo
        lblUserName.text = postInfo.valueForString(key: CFirstname) + " " + postInfo.valueForString(key: CLastname)
        lblPollTitle.text = postInfo.valueForString(key: CTitle)
        imgUser.loadImageFromUrl(postInfo.valueForString(key: CUserProfileImage), true)
        var polls : [MDLPollOption] = []
        if isSelected == true {
            //myprofile
            let pollstring = postData["options"] as? String
//            let rplstr_Frirst = pollstring?.replacingOccurrences(of: "\"", with: "")
//            let rplstr_Second = rplstr_Frirst?.replacingOccurrences(of: "[", with: "")
//            let rplstr_Three = rplstr_Second?.replacingOccurrences(of: "]", with: "")
//            chngString = rplstr_Three
            fullNameArr =  jsonToStringConvert(pollString: postData["options"] as? String ?? "")
            
        }else {
            //homeviewcontroller
            let pollstring = postData["options"] as? String
//            let rplstr_Frirst = pollstring?.replacingOccurrences(of: "\"", with: "")
//            let rplstr_Second = rplstr_Frirst?.replacingOccurrences(of: "[", with: "")
//            let rplstr_Three = rplstr_Second?.replacingOccurrences(of: "]", with: "")
//            chngString = rplstr_Three
             fullNameArr =  jsonToStringConvert(pollString: postData["options"] as? String ?? "")
        }
        
//        let fullNameArr:[String] = chngString?.components(separatedBy:",") ?? []
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
        //        tblVAnswre.totalVotes = voteCount ?? 0
        tblVAnswre.arrOption = polls
        
        if postInfo.valueForString(key:"is_selected") == "N/A" {
            tblVAnswre.isSelected = false
        }else {
            tblVAnswre.isSelected = false
        }
        tblVAnswre.userVotedPollId = postInfo.valueForInt(key: CUserVotedPoll) ?? 0
        tblVAnswre.userEmailID = postInfo.valueForString(key: "user_email")
        
        lblPollType.text = CTypePoll
        tblVAnswre.dictArray = self.dictArray
        //        tblVAnswre.totalVotesNew = totalVotes
        tblVAnswre.totalVotesNew = postInfo.valueForString(key: "total_count")
        
        lblPollCategory.text = postInfo.valueForString(key: CCategory).uppercased()
        tblVAnswre.refreshOnVoteWithData = { [weak self] (optionData,countuser) in
            let post_id = optionData["post_id"] as? String
            guard let self = self else {return}
            DispatchQueue.main.async {
                MIGeneralsAPI.shared().refreshPollPostRelatedScreens(self.postData, post_id?.toInt, self.tblVAnswre.userVotedPollId, optionData: optionData, self.viewController, .polladded, isSelected: false)
            }
        }
        
        //Other Profiel  Like Button update
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
        //Home Profile & My profile Like Button update
        if isLikesHomePage == true  || isLikesMyprofilePage == true {
            if postInfo.valueForString(key:CIs_Liked) == "Yes"{
                btnLike.isSelected = true
            }else {
                btnLike.isSelected = false
            }
        }
        
        likeCount = postInfo.valueForString(key: CLikes).toInt ?? 0
        btnLikesCount.setTitle(appDelegate.getLikeString(like: likeCount), for: .normal)
        let commentCount = postInfo.valueForString(key: "comments").toInt
        btnComment.setTitle(appDelegate.getCommentCountString(comment: commentCount ?? 0), for: .normal)
        btnShare.setTitle(CBtnShare, for: .normal)
        
        //Dateconvert
        let created_At = postInfo.valueForString(key: CCreated_at)
        let cnvStr = created_At.stringBefore("G")
        let startCreated = DateFormatter.shared().convertDatereversLatest(strDate: cnvStr)
        self.lblPollPostDate.text = startCreated
        self.tblVAnswre.reloadData()
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
extension HomePollTblCell {
    
    @IBAction func onLikePressed(_ sender:UIButton){
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
        
        guard let userID = appDelegate.loginUser?.user_id else {return}
        APIRequest.shared().likeUnlikeProducts(userId: Int(userID), productId: Int(self.postID) , isLike: likeCount){ [weak self](response, error) in
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
                    //                    info = response!["liked_users"] as? [String:Any] ?? [:]
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
                            self?.notificationInfo["options"] = ""
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
        
        if let artID = self.pollIDNew {
            MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: "\(CMessagePleaseWait)...")
            APIRequest.shared().viewPollDetailNew(postID: artID){ [weak self] (response, error) in
                guard let self = self else { return }
                if response != nil {
                    MILoader.shared.hideLoader()
                    if let Info = response!["data"] as? [[String:Any]]{
                        for articleInfo in Info {
                            self.totalVotesNew = articleInfo["total_count"] as? String ?? "0"
                            self.is_Selected = articleInfo["is_selected"] as? String ?? ""
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
                        }
                    }
                    self.arr.removeAll()
                    var arrayData  = ["0","0","0","0"]
                    if let data = response![CData] as? [[String:Any]]{
                        if data.count == 1 {
                            for datas in data{
                                self.polls = []
                                let objarray = (datas["options"] as? String ?? "" ).replace(string: "\"", replacement: "")
                                
                                self.pollOptionArr =  self.jsonToStringConvert(pollString:datas["options"] as? String ?? "") ?? []
                                
                                let obj = datas["results"] as? [String : AnyObject] ?? [:]
                                if obj.count == 1 {
                                    self.arrPostList =  obj
                                    for (key, value) in obj {
                                        let indexOfA  = self.pollOptionArr.firstIndex(of: key)
                                        if indexOfA == 0{
                                            self.arr = ["\(value)","0","0","0"]
                                        }else if indexOfA == 1{
                                            self.arr = ["0","\(value)","0","0"]
                                        }else if indexOfA == 2{
                                            self.arr = ["0","0","\(value)","0"]
                                        }else if indexOfA == 3{
                                            self.arr = ["0","0","0","\(value)",]
                                        }
                                    }
                                }else {
                                    self.arrPostList =  obj
                                    for (key, value) in obj {
                                        let indexOfA  = self.pollOptionArr.firstIndex(of: key)
                                        arrayData.remove(at: indexOfA ?? 0)
                                        arrayData.insert("\(value)", at: indexOfA ?? 0)
                                    }
                                    self.arr += arrayData
                                }
                                self.dictArray = self.arr
                            }
                        }
                    }
                }
            }
        }
    }
}

extension HomePollTblCell{
    
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



