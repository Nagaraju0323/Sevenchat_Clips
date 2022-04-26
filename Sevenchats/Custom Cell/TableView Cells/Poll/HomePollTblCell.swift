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
    var is_Selected: String = ""
    var notificationInfo = [String:Any]()
    var voteCount:Int?
    var polls : [MDLPollOption] = []
    var arrPostList = [String : Any]()
    var arr = [String]()
    var dictArray = [String]()
    var pollOptionArr:[String] = []
    var totalVotes = ""
    var pollIsSelected = ""
    var postPerArr = [String]()
    
    
    
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
        self.btnComment.isUserInteractionEnabled = false
        self.layoutIfNeeded()
        self.lblPollType.text = CTypePoll
        
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
        if isLikesOthersPage == true {
            posted_ID = self.posted_IDOthers
            tblVAnswre.isLikesOthersPage = true
        }else {
            posted_ID = postInfo.valueForString(key: "user_id")
            tblVAnswre.isLikesOthersPage = false
        }
        postData = postInfo
        lblUserName.text = postInfo.valueForString(key: CFirstname) + " " + postInfo.valueForString(key: CLastname)
        lblPollTitle.text = postInfo.valueForString(key: CTitle)
        imgUser.loadImageFromUrl(postInfo.valueForString(key: CUserProfileImage), true)

        
        if let pollsData = postInfo as? [String:Any]{
            let dispatchGroup = DispatchGroup()
            let voteCount = pollsData.valueForString(key:"total_count").toInt ?? 0
            fullNameArr =  jsonToStringConvert(pollString: postData["options"] as? String ?? "")
            self.updateVoteCount(count: voteCount)
            tblVAnswre.updateVoteCount = { [weak self] (votesCount) in
                guard let _ = self else {return}
                self?.updateVoteCount(count: votesCount)
            }
            
            tblVAnswre.refreshOnVoteWithData = { [weak self] (optionData,countuser) in
                guard let self = self else {return}
                DispatchQueue.main.async {
                    
                    MIGeneralsAPI.shared().refreshPollPostRelatedScreens(self.postData, self.tblVAnswre.postID, self.tblVAnswre.userVotedPollId, optionData: optionData, self.viewController, .polladded, isSelected: false)
                    
                }
            }
            var polls : [MDLPollOption] = []
            var pollinformation = [MDLPollInformation]()
            var dictionary = [String: String]()
            for player in fullNameArr {
                dictionary["poll_text"] = player
                polls.append(MDLPollOption(fromDictionary: dictionary))
            }
            pollinformation.append(MDLPollInformation(fromDictionary: pollsData))
            //tblVAnswre.totalVotes = voteCount
            tblVAnswre.arrOption = polls
            tblVAnswre.arrPollInformation = pollinformation
            
            if postInfo.valueForString(key: CUserId) == "\(String(describing: appDelegate.loginUser?.user_id ?? 0))" {
                tblVAnswre.isSelected = true
            }else{
                tblVAnswre.isSelected = postInfo.valueForBool(key: CIsUserVoted)
            }
            
            tblVAnswre.userVotedPollId = postInfo.valueForInt(key: CUserVotedPoll) ?? 0
            tblVAnswre.userEmailID = postInfo.valueForString(key: "user_email")
            tblVAnswre.postID = postInfo.valueForString(key: "post_id").toInt ?? 0
            postID = postInfo.valueForString(key: "post_id").toInt ?? 0
            tblVAnswre.userID = postInfo.valueForString(key: CUserId).toInt ?? 0
            
            dispatchGroup.enter()
            DispatchQueue.global().async {
                self.getPollDetailsFromServer(postID:self.postID,completion: { [self] success,result,totalVotesCount   in
                    if success == true {
                        print("frames success")
                        self.tblVAnswre.dictArray = result
                        self.tblVAnswre.pollIsSelected = self.pollIsSelected
                        self.tblVAnswre.totalVotes = totalVotesCount.toInt ?? 0

                        let voteCount = totalVotes.toInt ?? 0
                        var dictionarys = [String: Any]()
                        let polltextCnt = self.fullNameArr.count
                        postPerArr.removeAll()
                      
                        if polltextCnt == 1{
                            
                        }else if polltextCnt == 2{
                            let poll_Text1 = result[0]
                            let poll_Text2 = result[1]
                            let poll_Res1 = Int(poll_Text1) ?? 0
                            let poll_Res2 = Int(poll_Text2) ?? 0
                            
                            if voteCount == 0{
                                let pollper_firstArrMul = poll_Res1 * 100
                                let pollper_secondArrMul = poll_Res2 * 100
                                let postdata:Float = Float(pollper_firstArrMul)
                                let poll_friststr = String(format:"%0.02f", (Float(postdata)))
                                self.postPerArr.append(poll_friststr)
                                let postdata1:Float = Float(pollper_secondArrMul)
                                let poll_Secondstr = String(format:"%0.02f", (Float(postdata1)))
                                self.postPerArr.append(poll_Secondstr)
                            }else {
                                let pollper_firstArrMul = (poll_Res1 * 100) / voteCount
                                let pollper_secondArrMul = (poll_Res2 * 100) / voteCount
    //                            let pollper_firstArrMul = (poll_Res1 * 100)
    //                            let pollper_secondArrMul = (poll_Res2 * 100)
                                let postdata:Float = Float(pollper_firstArrMul)
                                let poll_friststr = String(format:"%0.02f", (Float(postdata)))
                                self.postPerArr.append(poll_friststr)
                                let postdata1:Float = Float(pollper_secondArrMul)
                                let poll_Secondstr = String(format:"%0.02f", (Float(postdata1)))
                                self.postPerArr.append(poll_Secondstr)
                            }

                            
                        }else if polltextCnt == 3{
                            print("count\(polltextCnt)")
                            
                            let poll_Text1 = result[0]
                            let poll_Text2 = result[1]
                            let poll_Text3 = result[2]
                            let poll_Res1 = Int(poll_Text1) ?? 0
                            let poll_Res2 = Int(poll_Text2) ?? 0
                            let poll_Res3 = Int(poll_Text3) ?? 0
//                            let pollper_firstArrMul = poll_Res1 * 100
//                            let pollper_secondArrMul = poll_Res2 * 100
//                            let pollper_ThirdArrMul = poll_Res3 * 100

                            if voteCount == 0{
                                
                                let pollper_firstArrMul = poll_Res1 * 100
                                let pollper_secondArrMul = poll_Res2 * 100
                                let pollper_ThirdArrMul = poll_Res3 * 100
                                let postdata1:Float = Float(pollper_firstArrMul)
                                let poll_friststr = String(format:"%0.02f", (Float(postdata1)))
                                self.postPerArr.append(poll_friststr)
                                let postdata2:Float = Float(pollper_secondArrMul)
                                let poll_Secondstr = String(format:"%0.02f", (Float(postdata2)))
                                self.postPerArr.append(poll_Secondstr)
                                let postdata3:Float = Float(pollper_ThirdArrMul)
                                let poll_Thirdstr = String(format:"%0.02f", (Float(postdata3)))
                                self.postPerArr.append(poll_Thirdstr)
                            }else {
                                let pollper_firstArrMul = (poll_Res1 * 100) / voteCount
                                let pollper_secondArrMul = (poll_Res2 * 100) / voteCount
                                let pollper_ThirdArrMul = (poll_Res3 * 100) / voteCount
                                let postdata1:Float = Float(pollper_firstArrMul)
                                let poll_friststr = String(format:"%0.02f", (Float(postdata1)))
                                self.postPerArr.append(poll_friststr)
                                let postdata2:Float = Float(pollper_secondArrMul)
                                let poll_Secondstr = String(format:"%0.02f", (Float(postdata2)))
                                self.postPerArr.append(poll_Secondstr)
                                let postdata3:Float = Float(pollper_ThirdArrMul)
                                let poll_Thirdstr = String(format:"%0.02f", (Float(postdata3)))
                                self.postPerArr.append(poll_Thirdstr)
                            }
                            
//                            let pollper_firstArrMul = (poll_Res1 * 100) / voteCount
//                            let pollper_secondArrMul = (poll_Res2 * 100) / voteCount
//                            let pollper_ThirdArrMul = (poll_Res3 * 100) / voteCount
//                            let postdata1:Float = Float(pollper_firstArrMul)
//                            let poll_friststr = String(format:"%0.02f", (Float(postdata1)))
//                            self.postPerArr.append(poll_friststr)
//                            let postdata2:Float = Float(pollper_secondArrMul)
//                            let poll_Secondstr = String(format:"%0.02f", (Float(postdata2)))
//                            self.postPerArr.append(poll_Secondstr)
//                            let postdata3:Float = Float(pollper_ThirdArrMul)
//                            let poll_Thirdstr = String(format:"%0.02f", (Float(postdata3)))
//                            self.postPerArr.append(poll_Thirdstr)
                        }else if polltextCnt == 4 {
                            print("count\(polltextCnt)")
                            
                            let poll_Text1 = result[0]
                            let poll_Text2 = result[1]
                            let poll_Text3 = result[2]
                            let poll_Text4 = result[3]
                            let poll_Res1 = Int(poll_Text1) ?? 0
                            let poll_Res2 = Int(poll_Text2) ?? 0
                            let poll_Res3 = Int(poll_Text3) ?? 0
                            let poll_Res4 = Int(poll_Text4) ?? 0

                            if voteCount == 0{
                                let pollper_firstArrMul = poll_Res1 * 100
                                let pollper_secondArrMul = poll_Res2 * 100
                                let pollper_ThirdArrMul = poll_Res3 * 100
                                let pollper_FourthArrMul = poll_Res4 * 100
                                
                                let postdata1:Float = Float(pollper_firstArrMul)
                                let poll_friststr = String(format:"%0.02f", (Float(postdata1)))
                                self.postPerArr.append(poll_friststr)
                                let postdata2:Float = Float(pollper_secondArrMul)
                                let poll_Secondstr = String(format:"%0.02f", (Float(postdata2)))
                                self.postPerArr.append(poll_Secondstr)
                                let postdata3:Float = Float(pollper_ThirdArrMul)
                                let poll_Thirdstr = String(format:"%0.02f", (Float(postdata3)))
                                self.postPerArr.append(poll_Thirdstr)
                                let postdata4:Float = Float(pollper_FourthArrMul)
                                let poll_Fourthdstr = String(format:"%0.02f", (Float(postdata4)))
                                self.postPerArr.append(poll_Fourthdstr)
                            }else {
                                let pollper_firstArrMul = (poll_Res1 * 100) / voteCount
                                let pollper_secondArrMul = (poll_Res2 * 100) / voteCount
                                let pollper_ThirdArrMul = (poll_Res3 * 100) / voteCount
                                let pollper_FourthArrMul = (poll_Res4 * 100) / voteCount
                                
                                let postdata1:Float = Float(pollper_firstArrMul)
                                let poll_friststr = String(format:"%0.02f", (Float(postdata1)))
                                self.postPerArr.append(poll_friststr)
                                let postdata2:Float = Float(pollper_secondArrMul)
                                let poll_Secondstr = String(format:"%0.02f", (Float(postdata2)))
                                self.postPerArr.append(poll_Secondstr)
                                let postdata3:Float = Float(pollper_ThirdArrMul)
                                let poll_Thirdstr = String(format:"%0.02f", (Float(postdata3)))
                                self.postPerArr.append(poll_Thirdstr)
                                let postdata4:Float = Float(pollper_FourthArrMul)
                                let poll_Fourthdstr = String(format:"%0.02f", (Float(postdata4)))
                                self.postPerArr.append(poll_Fourthdstr)
                            }
                            

                        }
                        
                        for (index, element) in fullNameArr.enumerated() {
                            print(index, ":", element)
                            dictionarys["poll_text"] = self.fullNameArr[index]
                            dictionarys["poll_vote_per"] = Double(self.postPerArr[index])
                            self.polls.append(MDLPollOption(fromDictionary: dictionarys))
                        }
                    }
                    self.tblVAnswre.arrOption = self.polls
                    dispatchGroup.leave()
                })
            }
            
            dispatchGroup.notify(queue: .main) {
                self.tblVAnswre.reloadData()
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
                            MIGeneralsAPI.shared().sendNotification(self?.posted_ID, userID: user_ID, subject: "liked your Post", MsgType: "COMMENT", MsgSent: "", showDisplayContent: "liked your Post", senderName: firstName + lastName, post_ID: self?.notificationInfo ?? [:],shareLink: "shareLikes")
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
    func getPollDetailsFromServer(postID:Int,completion:@escaping(_ success:Bool,_ result:[String],_ totalVotesCout:String) -> Void ) {
        
        guard let userID = appDelegate.loginUser?.user_id else { return }
        APIRequest.shared().viewPostDetailLatest(postID: postID,userid: userID.description , apiKeyCall: "polls"){ [weak self] (response, error) in
//        APIRequest.shared().viewPollDetailNew(postID: postID){ [weak self] (response, error) in
            guard let self = self else { return }
            if response != nil {
                if let Info = response!["data"] as? [[String:Any]]{
                    for articleInfo in Info {
                        self.totalVotesNew = articleInfo["total_count"] as? String ?? "0"
                        self.pollIsSelected = articleInfo["is_selected"] as? String ?? ""
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
                            _ = (datas["options"] as? String ?? "" ).replace(string: "\"", replacement: "")
                            
                            self.pollOptionArr =  self.jsonToStringConvert(pollString:datas["options"] as? String ?? "")
                            
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
                            self.totalVotes = datas["total_count"] as? String ?? "0"
                            print("TotalVotesBefore::::::\(self.totalVotes)")
                        }
                        completion(true,self.dictArray,self.totalVotes)
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



