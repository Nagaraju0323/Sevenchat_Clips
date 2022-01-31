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
        
        postID = postInfo.valueForString(key: "post_id").toInt ?? 0
        pollIDNew = postInfo.valueForString(key: "post_id").toInt ?? 0
        posted_ID = postInfo.valueForString(key: "user_id")
        tblVAnswre.postinfo = postInfo
        
        postData = postInfo
        lblUserName.text = postInfo.valueForString(key: CFirstname) + " " + postInfo.valueForString(key: CLastname)
        lblPollTitle.text = postInfo.valueForString(key: CTitle)
        imgUser.loadImageFromUrl(postInfo.valueForString(key: CUserProfileImage), true)
        var polls : [MDLPollOption] = []
//        print("polls\(polls)")
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
        let voteCount:Int =  self.totalVotesNew.toInt ?? 0
        self.updateVoteCount(count: voteCount)
        
        tblVAnswre.updateVoteCount = { [weak self] (votesCount) in
            guard let _ = self else {return}
            self?.updateVoteCount(count: votesCount)
        }
        tblVAnswre.totalVotes = voteCount
        tblVAnswre.arrOption = polls
        
        if postInfo.valueForString(key:"is_selected") == "Yes"{
            tblVAnswre.isSelected = true
        }else {
            tblVAnswre.isSelected = false
        }
        tblVAnswre.userVotedPollId = postInfo.valueForInt(key: CUserVotedPoll) ?? 0
        tblVAnswre.userEmailID = postInfo.valueForString(key: "user_email")
        
        lblPollType.text = CTypePoll
        
        
        lblPollCategory.text = postInfo.valueForString(key: CCategory).uppercased()
        tblVAnswre.refreshOnVoteWithData = { [weak self] (optionData) in
            let post_id = optionData["post_id"] as? String
            guard let self = self else {return}
            DispatchQueue.main.async {
                MIGeneralsAPI.shared().refreshPollPostRelatedScreens(self.postData, post_id?.toInt, self.tblVAnswre.userVotedPollId, optionData: optionData, self.viewController)
            }
        }
        
        tblVAnswre.updateVoteCountReload = { [weak self] (optionData) in
            let post_id = optionData["post_id"] as? String
            guard let self = self else {return}
            DispatchQueue.main.async {
                MIGeneralsAPI.shared().refreshPollPostRelatedScreens(self.postData, post_id?.toInt, self.tblVAnswre.userVotedPollId, optionData: optionData, self.viewController)
            }
            
        }
        let is_Liked = postInfo.valueForString(key: CIsLiked)
        if is_Liked == "Yes"{
            btnLike.isSelected = true
        }else {
            btnLike.isSelected = false
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
        }else {
            likeCount = 2
            like = 0
            
        }
        guard let userID = appDelegate.loginUser?.user_id else {
            return
        }
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
                        MIGeneralsAPI.shared().sendNotification(self?.posted_ID, userID: user_ID, subject: "liked your Post", MsgType: "COMMENT", MsgSent: "", showDisplayContent: "liked your Post", senderName: firstName + lastName)
                        
                        if let metaInfo = response![CJsonMeta] as? [String : Any] {
                            let name = (appDelegate.loginUser?.first_name ?? "") + " " + (appDelegate.loginUser?.last_name ?? "")
                            guard let image = appDelegate.loginUser?.profile_img else { return }
                            let stausLike = metaInfo["status"] as? String ?? "0"
                            if stausLike == "0" {
                                
                                MIGeneralsAPI.shared().addRewardsPoints(CPostlike,message:"post_point",type:CPostlike,title:"post Like",name:name,icon:image)
                            }
                        }
                        
                        self?.notifcationIsSlected = false
                    }
                    MIGeneralsAPI.shared().likeUnlikePostWebsites(post_id: Int(self?.postID ?? 0), rss_id: 0, type: 1, likeStatus: self?.like ?? 0 ,info:postInfo, viewController: self?.viewController)
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
                    DispatchQueue.main.async {
                        if let Info = response!["data"] as? [[String:Any]]{
                            for articleInfo in Info {
                                self.totalVotesNew = articleInfo["total_count"] as? String ?? "0"
                                print("self.totalVotes\(self.totalVotesNew)")
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

