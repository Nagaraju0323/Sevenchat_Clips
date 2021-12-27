//
//  HomePollTblCell.swift
//  Sevenchats
//
//  Created by mac-0005 on 14/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        lblSharedPostType.text = CSharedPoll
        self.viewSubContainer.layer.cornerRadius = 8
        self.viewMainContainer.layer.cornerRadius = 8
        self.viewMainContainer.shadow(color: CRGB(r: 237, g: 236, b: 226), shadowOffset: CGSize(width: 0, height: 5), shadowRadius: 10.0, shadowOpacity: 10.0)
        
        self.imgUser.layer.cornerRadius = self.imgUser.frame.size.width/2
        self.lblPollType.layer.cornerRadius = 3
        
        self.imgSharedUser.layer.cornerRadius = self.imgSharedUser.frame.size.width/2
        
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
        
        postID = postInfo.valueForInt(key: CId) ?? 0
        if let sharedData = postInfo[CSharedPost] as? [String:Any]{
            self.lblSharedUserName.text = sharedData.valueForString(key: CFullName)
            self.lblSharedPostDate.text = DateFormatter.dateStringFrom(timestamp: sharedData.valueForDouble(key: CCreated_at), withFormate: CreatedAtPostDF)
            imgSharedUser.loadImageFromUrl(sharedData.valueForString(key: CUserProfileImage), true)
            lblMessage.text = sharedData.valueForString(key: CMessage)
        }

        postData = postInfo
        lblUserName.text = postInfo.valueForString(key: CFirstname) + " " + postInfo.valueForString(key: CLastname)
        lblPollPostDate.text = DateFormatter.dateStringFrom(timestamp: postInfo.valueForDouble(key: CCreated_at), withFormate: CreatedAtPostDF)
        lblPollTitle.text = postInfo.valueForString(key: CTitle)
        
        imgUser.loadImageFromUrl(postInfo.valueForString(key: CUserProfileImage), true)
        if let pollsData = postInfo[CPollData] as? [String:Any] {
            
            let voteCount = pollsData.valueForInt(key:CAllVotes) ?? 0
            self.updateVoteCount(count: voteCount)
            tblVAnswre.updateVoteCount = { [weak self] (votesCount) in
                guard let _ = self else {return}
                self?.updateVoteCount(count: votesCount)
            }
            
            tblVAnswre.refreshOnVoteWithData = { [weak self] (optionData) in
                guard let self = self else {return}
                DispatchQueue.main.async {
                    MIGeneralsAPI.shared().refreshPollPostRelatedScreens(self.postData, self.tblVAnswre.postID, self.tblVAnswre.userVotedPollId, optionData: optionData, self.viewController)
                }
            }
            
            var polls : [MDLPollOption] = []
            for obj in pollsData[CPolles] as? [[String : Any]] ?? []{
                polls.append(MDLPollOption(fromDictionary: obj))
            }
            tblVAnswre.totalVotes = voteCount
            tblVAnswre.arrOption = polls
            
            if postInfo.valueForString(key: CUserId) == "\(String(describing: appDelegate.loginUser?.user_id ?? 0))"{
                tblVAnswre.isSelected = true
            }else{
                tblVAnswre.isSelected = postInfo.valueForBool(key: CIsUserVoted)
            }
            
            tblVAnswre.userVotedPollId = postInfo.valueForInt(key: CUserVotedPoll) ?? 0
            
            let isSharedPost = postInfo.valueForInt(key: CIsSharedPost)
            if isSharedPost == 1{
                tblVAnswre.postID = postInfo.valueForInt(key: COriginalPostId) ?? 0
            }else{
                tblVAnswre.postID = postInfo.valueForInt(key: CId) ?? 0
            }
            tblVAnswre.userID = postInfo.valueForInt(key: CUserId) ?? 0
            
            tblVAnswre.reloadData()
        }
        
        lblPollType.text = CTypePoll
        
        lblPollCategory.text = postInfo.valueForString(key: CCategory).uppercased()
        btnLike.isSelected = postInfo.valueForInt(key: CIs_Like) == 1
        
        likeCount = postInfo.valueForInt(key: CTotal_like) ?? 0
        
        let commentCount = postInfo.valueForInt(key: CTotalComment) ?? 0
        
        btnLikesCount.setTitle(appDelegate.getLikeString(like: likeCount), for: .normal)
        btnComment.setTitle(appDelegate.getCommentCountString(comment: commentCount), for: .normal)
        
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
        
        self.btnLike.isSelected = !self.btnLike.isSelected
        self.likeCount = self.btnLike.isSelected ? self.likeCount + 1 : self.likeCount - 1
        self.btnLikesCount.setTitle(appDelegate.getLikeString(like: self.likeCount), for: .normal)
        MIGeneralsAPI.shared().likeUnlikePostWebsite(post_id: self.postID, rss_id: nil, type: 1, likeStatus: self.btnLike.isSelected ? 1 : 0, viewController: self.viewController)
    }
    
    @IBAction func onMorePressed(_ sender:UIButton){
        onMorePressed?(sender.tag)
    }
}
