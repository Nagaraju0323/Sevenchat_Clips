//
//  MyProfileHeaderTbl swift
//  Sevenchats
//
//  Created by mac-0005 on 29/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit
import Lightbox

let CStates = "states"
let CStatesTitle = "statesTilte"
let CUserFriendLeadingSpace = -8.0

class MyProfileHeaderTblCell: UITableViewCell {
    
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var imgUser : UIImageView!
    @IBOutlet weak var imgCover : UIImageView!
    
    @IBOutlet weak var btnCoverChange: UIButton!
    @IBOutlet weak var btnProfileChange: UIButton!
    @IBOutlet weak var btnProfileChanges: UIButton!
    
    @IBOutlet weak var lblGender: UILabel!
    @IBOutlet weak var lblRelationship: UILabel!
    //    @IBOutlet weak var viewUpdateStates : UIView!
    @IBOutlet weak var viewFriendFirst : UIView!
    @IBOutlet weak var viewFriendSecond : UIView!
    @IBOutlet weak var viewFriendThird : UIView!
    @IBOutlet weak var viewFriendFourth : UIView!
    
    @IBOutlet weak var btnCreateStories : UIButton!
    
    @IBOutlet weak var btnFriendFirst : UIButton!
    @IBOutlet weak var btnFriendSecond : UIButton!
    @IBOutlet weak var btnFriendThird : UIButton!
    @IBOutlet weak var btnFriendFourth : UIButton!
    @IBOutlet weak var btnTotalFriend : UIButton!
    @IBOutlet weak var btnViewCompleteProfile : UIButton!
    @IBOutlet weak var lblTitleFriends : UILabel!
    @IBOutlet weak var lblUserName : UILabel!
    
    @IBOutlet weak var lblStatus: UILabel!
    
    //    @IBOutlet weak var lblEmail : UILabel!
    //    @IBOutlet weak var lblAddress : UILabel!
    //    @IBOutlet weak var lblMobileNo : UILabel!
    //    @IBOutlet weak var lblBdate : UILabel!
    @IBOutlet weak var clUpdateStates : UICollectionView!
    @IBOutlet weak var btnShare : UIButton!
    @IBOutlet weak var btnUserProfile : UIButton!
    
    @IBOutlet weak var btnUserProfileStatus : UIButton!
    
    
    //@IBOutlet weak var cntBtnShareHorizontal : NSLayoutConstraint!
    @IBOutlet weak var cntBtnShareTraling : NSLayoutConstraint!
    var pageNumber = 1
    var onTotalFriendAction : (() -> Void)?
    var apiTask : URLSessionTask?
    var totalFriendsCnt = 0
    var arrFriends = [[String : Any]]()
    //[CStates:"2 hrs 10 min",CStatesTitle:CProfileTimeSpent],
    var arrUpdateStates = [
        [CStates:(appDelegate.loginUser?.total_post)! as Any,
         CStatesTitle: appDelegate.loginUser?.total_post == 1 ? CProfilePost : CProfilePosts],
        [CStates:(appDelegate.loginUser?.total_like)! as Any,CStatesTitle: appDelegate.loginUser?.total_like == 1 ? CProfileLike : CProfileLikes],
        [CStates:"0",CStatesTitle:CProfileAdsPosts],
        [CStates:"0 MB",CStatesTitle:CProfileDataUpload]
    ]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.friendsListFromServer()
        
        GCDMainThread.async {
            
            self.btnCreateStories.layer.cornerRadius = 10
            self.imgUser.layer.cornerRadius = self.imgUser.frame.size.width/2
            self.btnShare.layer.cornerRadius = 5
            self.btnViewCompleteProfile.layer.cornerRadius = 5
            self.imgUser.layer.borderWidth = 3
            self.imgUser.layer.borderColor = #colorLiteral(red: 0, green: 0.7881455421, blue: 0.7100172639, alpha: 1)
            self.viewFriendFirst.layer.cornerRadius = self.viewFriendFirst.frame.size.width/2
            self.btnFriendFirst.layer.cornerRadius = self.btnFriendFirst.frame.size.width/2
            self.viewFriendFirst.layer.borderWidth = 1.5
            self.viewFriendFirst.layer.borderColor = UIColor.white.cgColor
            
            self.viewFriendSecond.layer.cornerRadius = self.viewFriendSecond.frame.size.width/2
            self.btnFriendSecond.layer.cornerRadius = self.btnFriendSecond.frame.size.width/2
            self.viewFriendSecond.layer.borderWidth = 1.5
            self.viewFriendSecond.layer.borderColor = UIColor.white.cgColor
            
            self.viewFriendThird.layer.cornerRadius = self.viewFriendThird.frame.size.width/2
            self.btnFriendThird.layer.cornerRadius = self.btnFriendThird.frame.size.width/2
            self.viewFriendThird.layer.borderWidth = 1.5
            self.viewFriendThird.layer.borderColor = UIColor.white.cgColor
            
            self.viewFriendFourth.layer.cornerRadius = self.viewFriendFourth.frame.size.width/2
            self.btnFriendFourth.layer.cornerRadius = self.btnFriendFourth.frame.size.width/2
            self.viewFriendFourth.layer.borderWidth = 1.5
            self.viewFriendFourth.layer.borderColor = UIColor.white.cgColor
            
            self.btnTotalFriend.layer.cornerRadius = self.btnTotalFriend.frame.size.width/2
            
            //            self.viewUpdateStates.shadow(color: UIColor.darkGray, shadowOffset: CGSize(width: 0, height: 4), shadowRadius: 5.0, shadowOpacity: 5.0)
            
            self.updateUIAccordingToLanguage()
            
            self.btnCreateStories.isHidden = true 
            
            self.btnUserProfile.touchUpInside(genericTouchUpInsideHandler: { [weak self](_) in
                let lightBoxHelper = LightBoxControllerHelper()
                lightBoxHelper.openSingleImage(image: self?.imgUser.image, viewController: self?.viewController)
            })
        }

    }
    override func layoutSubviews() {
        let totalFriend = appDelegate.loginUser?.total_friends ?? 0
        if let vwFriends = self.btnShare.superview, totalFriend == 0 {
            let centerX  = vwFriends.bounds.width / 2 - (self.btnShare.bounds.width / 2)
            self.cntBtnShareTraling.constant = centerX
            self.layoutIfNeeded()
        }
    }
    func updateUIAccordingToLanguage(){
        
        if Localization.sharedInstance.applicationFlowWithLanguageRTL() {
            // Reverse Flow...
            //            lblMobileNo.textAlignment = .left
            //            lblBdate.textAlignment = .right
        }else{
            // Normal Flow...
            //            lblMobileNo.textAlignment = .right
            //            lblBdate.textAlignment = .left
        }
        
        //        lblTitleFriends.text = CProfileFriends NG
        //        lblTitleFriends.text = ""
        btnViewCompleteProfile.setTitle(CProfileBtnViewCompleteProfile, for: .normal)
        btnShare.setTitle(CBtnShare, for: .normal)
    }
    
    func cellConfigureProfileDetail() {
        
        let arr = TblRelation.fetch(predicate: NSPredicate(format: "%K == %d", CRelationship_id, (appDelegate.loginUser?.relationship_id)!), orderBy: CName, ascending: true)
        let arrData = TblRelation.fetch(predicate: nil, orderBy: CName, ascending: true)
        _ = arrData?.value(forKeyPath: CName) as? [Any]
        //...Prefill relation status
        if (arr?.count)! > 0 {
            let dict = arr![0] as? TblRelation
            lblStatus.text = dict?.name
        }
        lblUserName.text = "\(appDelegate.loginUser?.first_name ?? "") \(appDelegate.loginUser?.last_name ?? "")"
        lblLocation.text = "Lives in \(appDelegate.loginUser?.country ?? "") \(appDelegate.loginUser?.state ?? "")"
        switch Int((appDelegate.loginUser?.gender)!) {
        case CMale :
            lblGender.text = CRegisterGenderMale
        case CFemale :
            lblGender.text = CRegisterGenderFemale
        default :
            lblGender.text = CRegisterGenderOther
        }
        
        //        lblMobileNo.text = "\(appDelegate.loginUser?.country_code ?? "") \(appDelegate.loginUser?.mobile ?? "")"
        
        let date = DateFormatter.shared().date(fromString: (appDelegate.loginUser?.dob)!, dateFormat: "yyyy-MM-dd")
        //        lblBdate.text = DateFormatter.shared().string(fromDate: date!, dateFormat: "dd MMM yyyy")
        //        lblBdate.text  = ""
        //        lblMobileNo.text  = ""
        
        imgCover.loadImageFromUrl((appDelegate.loginUser?.cover_image ?? ""), true)
        imgUser.loadImageFromUrl((appDelegate.loginUser?.profile_url ?? ""), true)
        
        let totalFriend = appDelegate.loginUser?.total_friends ?? 0
        //        lblTitleFriends.isHidden = (totalFriend == 0)
        //self.cntBtnShareHorizontal.priority = totalFriend == 0 ? UILayoutPriority.defaultHigh : UILayoutPriority.defaultLow
        //self.cntBtnShareTraling.priority = totalFriend == 0 ? UILayoutPriority.defaultLow : UILayoutPriority.defaultHigh
        /*if let vwFriends = self.btnShare.superview, totalFriend == 0 {
         let centerX  = vwFriends.bounds.width / 2 - (self.btnShare.bounds.width / 2)
         self.cntBtnShareTraling.constant = centerX
         self.layoutIfNeeded()
         }*/
        
//        btnTotalFriend.hide(byWidth: !(totalFriend > 4))
//        btnTotalFriend.setTitle("\(totalFriend)", for: .normal)
        
        viewFriendFirst.hide(byWidth: true)
        viewFriendSecond.hide(byWidth: true)
        _ = viewFriendSecond.setConstraintConstant(0, edge: .leading, ancestor: true)
        viewFriendThird.hide(byWidth: true)
        _ = viewFriendThird.setConstraintConstant(0, edge: .leading, ancestor: true)
        viewFriendFourth.hide(byWidth: true)
        _ = viewFriendFourth.setConstraintConstant(0, edge: .leading, ancestor: true)
        
        
        _ = appDelegate.loginUser?.user_id
        
       
        
        //      apiTask = APIRequest.shared().getMyfriendList(page: self.pageNumber, user_id: Int(userID ?? 0), search_type: nil) { [weak self](response, error) in
        //                   if response != nil && error == nil {
        //
        //                       let totalCnt = response?["total_my_friends"] as? Int
        //                       print("print\(String(describing: totalCnt))")
        //                       self?.btnTotalFriend.setTitle("\(totalCnt!)", for: .normal)
        //
        //                       if let arrFriends = response?["my_friends"] as? [[String : Any]] {
        //                           print(arrFriends)
        //
        //                        if arrFriends.count > 0 {
        //                            switch arrFriends.count {
        //                            case 1:
        //                                self?.viewFriendFirst.hide(byWidth: false)
        //                                self?.btnFriendFirst.sd_setImage(with: URL(string: arrFriends[0].valueForString(key: CImage)), for: .normal, completed: nil)
        //                            case 2:
        //                                self?.viewFriendFirst.hide(byWidth: false)
        //                                self?.btnFriendFirst.sd_setImage(with: URL(string: arrFriends[0].valueForString(key: CImage)), for: .normal, completed: nil)
        //                                self?.viewFriendSecond.hide(byWidth: false)
        //                                _ = self?.viewFriendSecond.setConstraintConstant(CGFloat(CUserFriendLeadingSpace), edge: .leading, ancestor: true)
        //                                self?.btnFriendSecond.sd_setImage(with: URL(string: arrFriends[1].valueForString(key: CImage)), for: .normal, completed: nil)
        //                            case 3:
        //                                self?.viewFriendFirst.hide(byWidth: false)
        //                                self?.btnFriendFirst.sd_setImage(with: URL(string: arrFriends[0].valueForString(key: CImage)), for: .normal, completed: nil)
        //                                self?.viewFriendSecond.hide(byWidth: false)
        //                                _ = self?.viewFriendSecond.setConstraintConstant(CGFloat(CUserFriendLeadingSpace), edge: .leading, ancestor: true)
        //                                self?.btnFriendSecond.sd_setImage(with: URL(string: arrFriends[1].valueForString(key: CImage)), for: .normal, completed: nil)
        //                                self?.viewFriendThird.hide(byWidth: false)
        //                                _ = self?.viewFriendThird.setConstraintConstant(CGFloat(CUserFriendLeadingSpace), edge: .leading, ancestor: true)
        //                                self?.btnFriendThird.sd_setImage(with: URL(string: arrFriends[2].valueForString(key: CImage)), for: .normal, completed: nil)
        //                            case 4:
        //                                self?.viewFriendFirst.hide(byWidth: false)
        //                                self?.btnFriendFirst.sd_setImage(with: URL(string: arrFriends[0].valueForString(key: CImage)), for: .normal, completed: nil)
        //                                self?.viewFriendSecond.hide(byWidth: false)
        //                                _ = self?.viewFriendSecond.setConstraintConstant(CGFloat(CUserFriendLeadingSpace), edge: .leading, ancestor: true)
        //                                self?.btnFriendSecond.sd_setImage(with: URL(string: arrFriends[1].valueForString(key: CImage)), for: .normal, completed: nil)
        //                                self?.viewFriendThird.hide(byWidth: false)
        //                                _ = self?.viewFriendThird.setConstraintConstant(CGFloat(CUserFriendLeadingSpace), edge: .leading, ancestor: true)
        //                                self?.btnFriendThird.sd_setImage(with: URL(string: arrFriends[2].valueForString(key: CImage)), for: .normal, completed: nil)
        //                                self?.viewFriendFourth.hide(byWidth: false)
        //                                _ = self?.viewFriendFourth.setConstraintConstant(CGFloat(CUserFriendLeadingSpace), edge: .leading, ancestor: true)
        //                                self?.btnFriendFourth.sd_setImage(with: URL(string: arrFriends[3].valueForString(key: CImage)), for: .normal, completed: nil)
        //
        //                                _ = self?.btnTotalFriend.setConstraintConstant(CGFloat(CUserFriendLeadingSpace), edge: .leading, ancestor: true)
        //                            default:
        //                                break;
        //                            }
        //                        }
        //                    }
        //
        //
        //                       }
        //                   }
        
        
        //        let arrs = TblTotalFriends.fetch(predicate: NSPredicate(format: "%K == %d", CUserId, (appDelegate.loginUser?.user_id)!), orderBy: CUserId, ascending: true)
        //            let arrDatas = TblTotalFriends.fetch(predicate: nil, orderBy: CUserId, ascending: true)
        //            print("arrDatas\(arrDatas)")
        
        
//        self.btnTotalFriend.setTitle("\(totalFriendsCnt)", for: .normal)
        let arrs = TblTotalFriends.fetch(predicate: nil, orderBy: "friend_user_id", ascending: true)
        
        
    
        
        
//        if (arrs!.count <= 4){
//
////            if !(arrcount! > 4) {
//                if arrs!.count == 1{
//                let dict = arrs![0] as? TblTotalFriends
//                    viewFriendFirst.hide(byWidth: false)
//                    btnFriendFirst.sd_setImage(with: URL(string: (dict?.profile_image)!), for: .normal, completed: nil)
//                } else if arrs!.count == 2 {
//                    let dict = arrs![0] as? TblTotalFriends
//                    viewFriendFirst.hide(byWidth: false)
//                    btnFriendFirst.sd_setImage(with: URL(string: (dict?.profile_image)!), for: .normal, completed: nil)
//                    viewFriendSecond.hide(byWidth: false)
//                    let dict1 = arrs![1] as? TblTotalFriends
//                    _ = viewFriendSecond.setConstraintConstant(CGFloat(CUserFriendLeadingSpace), edge: .leading, ancestor: true)
//                    btnFriendSecond.sd_setImage(with: URL(string: (dict1?.profile_image)!), for: .normal, completed: nil)
//                }else if arrs!.count == 3 {
//                    let dict = arrs![0] as? TblTotalFriends
//                    viewFriendFirst.hide(byWidth: false)
//                    btnFriendFirst.sd_setImage(with: URL(string: (dict?.profile_image)!), for: .normal, completed: nil)
//                    viewFriendSecond.hide(byWidth: false)
//                    let dict1 = arrs![1] as? TblTotalFriends
//                    _ = viewFriendSecond.setConstraintConstant(CGFloat(CUserFriendLeadingSpace), edge: .leading, ancestor: true)
//                    btnFriendSecond.sd_setImage(with: URL(string: (dict1?.profile_image)!), for: .normal, completed: nil)
//                    viewFriendThird.hide(byWidth: false)
//                    let dict2 = arrs![2] as? TblTotalFriends
//                    _ = viewFriendThird.setConstraintConstant(CGFloat(CUserFriendLeadingSpace), edge: .leading, ancestor: true)
//                    btnFriendThird.sd_setImage(with: URL(string: (dict2?.profile_image)!), for: .normal, completed: nil)
//                } else if arrs!.count == 4 {
//                    let dict = arrs![0] as? TblTotalFriends
//                    viewFriendFirst.hide(byWidth: false)
//                    btnFriendFirst.sd_setImage(with: URL(string: (dict?.profile_image)!), for: .normal, completed: nil)
//                    viewFriendSecond.hide(byWidth: false)
//                    let dict1 = arrs![1] as? TblTotalFriends
//                    _ = viewFriendSecond.setConstraintConstant(CGFloat(CUserFriendLeadingSpace), edge: .leading, ancestor: true)
//                    btnFriendSecond.sd_setImage(with: URL(string: (dict1?.profile_image)!), for: .normal, completed: nil)
//                    viewFriendThird.hide(byWidth: false)
//                    let dict2 = arrs![2] as? TblTotalFriends
//                    _ = viewFriendThird.setConstraintConstant(CGFloat(CUserFriendLeadingSpace), edge: .leading, ancestor: true)
//                    btnFriendThird.sd_setImage(with: URL(string: (dict2?.profile_image)!), for: .normal, completed: nil)
//                    viewFriendFourth.hide(byWidth: false)
//                    let dict3 = arrs![3] as? TblTotalFriends
//                    _ = viewFriendFourth.setConstraintConstant(CGFloat(CUserFriendLeadingSpace), edge: .leading, ancestor: true)
//                    btnFriendFourth.sd_setImage(with: URL(string: (dict3?.profile_image)!), for: .normal, completed: nil)
//                    _ = btnTotalFriend.setConstraintConstant(CGFloat(CUserFriendLeadingSpace), edge: .leading, ancestor: true)
//            }
//        }
        
        
        
//        if let arrFriends = appDelegate.loginUser?.friends as? [[String : Any]] {
        
        
        if  let arrFriends =  TblTotalFriends.fetch(predicate: nil, orderBy: "friend_user_id", ascending: true){
            let arrFrdList = arrFriends.prefix(4)
            let frdListCount = Array(arrFrdList)

            switch frdListCount.count {
                     case 1:
//                        let dict = arrFriends[0] as? TblTotalFriends
                         viewFriendFirst.hide(byWidth: false)
                        btnFriendFirst.sd_setImage(with: URL(string: ((arrFriends[0] as! TblTotalFriends).profile_image)!), for: .normal, completed: nil)
                     case 2:
                        viewFriendFirst.hide(byWidth: false)
                       btnFriendFirst.sd_setImage(with: URL(string: ((arrFriends[0] as! TblTotalFriends).profile_image)!), for: .normal, completed: nil)
                         viewFriendSecond.hide(byWidth: false)
                         _ = self.viewFriendSecond.setConstraintConstant(CGFloat(CUserFriendLeadingSpace), edge: .leading, ancestor: true)
                         btnFriendSecond.sd_setImage(with: URL(string: ((arrFriends[1] as! TblTotalFriends).profile_image)!), for: .normal, completed: nil)
                     case 3:
                        viewFriendFirst.hide(byWidth: false)
                       btnFriendFirst.sd_setImage(with: URL(string: ((arrFriends[0] as! TblTotalFriends).profile_image)!), for: .normal, completed: nil)
                         viewFriendSecond.hide(byWidth: false)
                         _ = viewFriendSecond.setConstraintConstant(CGFloat(CUserFriendLeadingSpace), edge: .leading, ancestor: true)
                        btnFriendSecond.sd_setImage(with: URL(string: ((arrFriends[1] as! TblTotalFriends).profile_image)!), for: .normal, completed: nil)
                         viewFriendThird.hide(byWidth: false)
                         _ = viewFriendThird.setConstraintConstant(CGFloat(CUserFriendLeadingSpace), edge: .leading, ancestor: true)
                         btnFriendThird.sd_setImage(with: URL(string: ((arrFriends[2] as! TblTotalFriends).profile_image)!), for: .normal, completed: nil)
                     case 4:
                        viewFriendFirst.hide(byWidth: false)
                       btnFriendFirst.sd_setImage(with: URL(string: ((arrFriends[0] as! TblTotalFriends).profile_image)!), for: .normal, completed: nil)
                         viewFriendSecond.hide(byWidth: false)
                         _ = viewFriendSecond.setConstraintConstant(CGFloat(CUserFriendLeadingSpace), edge: .leading, ancestor: true)
                        btnFriendSecond.sd_setImage(with: URL(string: ((arrFriends[1] as! TblTotalFriends).profile_image)!), for: .normal, completed: nil)
                         viewFriendThird.hide(byWidth: false)
                         _ = viewFriendThird.setConstraintConstant(CGFloat(CUserFriendLeadingSpace), edge: .leading, ancestor: true)
                           btnFriendThird.sd_setImage(with: URL(string: ((arrFriends[2] as! TblTotalFriends).profile_image)!), for: .normal, completed: nil)
                         viewFriendFourth.hide(byWidth: false)
                         _ = viewFriendFourth.setConstraintConstant(CGFloat(CUserFriendLeadingSpace), edge: .leading, ancestor: true)
                         btnFriendFourth.sd_setImage(with: URL(string: ((arrFriends[3] as! TblTotalFriends).profile_image)!), for: .normal, completed: nil)
                         
                         _ = btnTotalFriend.setConstraintConstant(CGFloat(CUserFriendLeadingSpace), edge: .leading, ancestor: true)
                     default:
                         break;
                     }
             }
        
        //[CStates:"2 hrs 10 min",CStatesTitle:CProfileTimeSpent]
        arrUpdateStates = [
            [
                CStates:(appDelegate.loginUser?.total_post)! as Any,
                CStatesTitle: appDelegate.loginUser?.total_post == 1 ? CProfilePost : CProfilePosts
            ],
            [
                CStates:(appDelegate.loginUser?.total_like)! as Any,
                CStatesTitle: appDelegate.loginUser?.total_like == 1 ? CProfileLike : CProfileLikes
            ],
            [
                CStates: appDelegate.loginUser?.total_ads ?? 0,
                CStatesTitle:CProfileAdsPosts
            ],
            [
                CStates: self.uploadSizeformat(bytes: appDelegate.loginUser?.total_data_uploaded ?? 0.0),
                CStatesTitle:CProfileDataUpload
            ]
        ]
        //        clUpdateStates.reloadData()
        DispatchQueue.main.async {
            self.layoutIfNeeded()
        }
    }
    
    func uploadSizeformat(bytes: Double) -> String {
        guard bytes > 0 else {
            return "0 MB"
        }
        /*if bytes < 1{
         return "\(bytes) MB"
         }*/
        if bytes < UnitOfBytes{
            //return "\(bytes) MB"
            return String(format: "%.2f MB", bytes)
        }
        if bytes < (UnitOfBytes * UnitOfBytes){
            //return "\(bytes / UnitOfBytes) GB"
            return String(format: "%.2f GB", (bytes / UnitOfBytes))
        }
        if bytes < (UnitOfBytes * UnitOfBytes * UnitOfBytes){
            //return "\(bytes / (UnitOfBytes * UnitOfBytes)) TB"
            return String(format: "%.2f TB", (bytes / (UnitOfBytes * UnitOfBytes)))
        }
        if bytes < (UnitOfBytes * UnitOfBytes * UnitOfBytes * UnitOfBytes){
            //return "\(bytes / (UnitOfBytes * UnitOfBytes * UnitOfBytes)) PB"
            return String(format: "%.2f PB", (UnitOfBytes * UnitOfBytes * UnitOfBytes))
        }
        return ""
    }
}

//MARK: - IBAction's
extension MyProfileHeaderTblCell {
    
    @IBAction fileprivate func onTotalFriends(_ sender:UIButton){
        self.onTotalFriendAction?()
    }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension MyProfileHeaderTblCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrUpdateStates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileStatesCollCell", for: indexPath) as! ProfileStatesCollCell
        let dicData = arrUpdateStates[indexPath.row]
        cell.lblStates.text = dicData.valueForString(key: CStates)
        cell.lblStatesTitle.text = dicData.valueForString(key: CStatesTitle)
        cell.viewSeprator.isHidden = indexPath.row == arrUpdateStates.count - 1
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let fontToResize =  CFontPoppins(size: 12, type: .light).setUpAppropriateFont()
        let dicData = arrUpdateStates[indexPath.row]
        let title = dicData.valueForString(key: CStatesTitle)
        var size = title.size(withAttributes: [NSAttributedString.Key.font: fontToResize!])
        
        /*size.width = CGFloat(ceilf(Float(size.width + 10)))
         
         if size.width  < 65 {
         size.width = 65
         }*/
        size.width = collectionView.bounds.size.width / CGFloat(self.arrUpdateStates.count)
        size.height = clUpdateStates.frame.size.height
        return size
    }
}

extension MyProfileHeaderTblCell{
    
    
    @IBAction func btnUploadImageCLK(_ sender : UIButton){
        
        //        if self.imgUser.image != nil {
        //            self.presentActionsheetWithThreeButton(actionSheetTitle: nil, actionSheetMessage: nil, btnOneTitle: CRegisterChooseFromPhone, btnOneStyle: .default, btnOneTapped: { [weak self] (action) in
        //                guard let self = self else { return }
        //
        //                self.presentImagePickerControllerForGallery(imagePickerControllerCompletionHandler: { [weak self] (image, info) in
        //                    guard let self = self else { return }
        //                    if image != nil{
        //                        self.uploadedImg = true
        //                        self.imgEditIcon.isHidden = false
        //                        self.imgUser.image = image
        //                    }
        //                })
        //
        //            }, btnTwoTitle: CRegisterTakePhoto, btnTwoStyle: .default, btnTwoTapped: { [weak self] (action) in
        //                guard let self = self else { return }
        //                self.presentImagePickerControllerForCamera(imagePickerControllerCompletionHandler: { [weak self] (image, info) in
        //                    guard let self = self else { return }
        //                    if image != nil{
        //                        self.uploadedImg = true
        //                        self.imgEditIcon.isHidden = false
        //                        self.imgUser.image = image
        //                    }
        //                })
        //            }, btnThreeTitle: CRegisterRemovePhoto, btnThreeStyle: .default) { [weak self] (action) in
        //                guard let self = self else { return }
        //                self.imgUser.image = nil
        //                self.imgEditIcon.isHidden = true
        //                self.uploadProfilePic()
        //            }
        //
        //        } else {
        //            self.presentImagePickerController(allowEditing: true) { [weak self](image, info) in
        //                guard let self = self else { return }
        //                if image != nil{
        //                    self.uploadedImg = true
        //                    self.imgEditIcon.isHidden = false
        //                    self.imgUser.image = image
        //                }
        //            }
        //        }
        
        
        
    }
    
}


//MARK :- API CALL
//extension MyProfileHeaderTblCell{
//
//    func friendsListFromServer(){
//
//        guard  let userID = appDelegate.loginUser?.user_id else {return}
//        apiTask = APIRequest.shared().getMyfriendList(page: self.pageNumber, user_id: Int(userID), search_type: nil) { [weak self](response, error) in
//                   if response != nil && error == nil {
//
//                    GCDMainThread.async{
//                    let totalCnt = response?["total_my_friends"] as? Int
//                       print("print\(String(describing: totalCnt))")
//                       self?.btnTotalFriend.setTitle("\(totalCnt!)", for: .normal)
//                    let arrFriendslist = response?["my_friends"] as? [[String : Any]] ?? [[:]]
//                    self?.arrFriends = arrFriendslist
//                }
//            }
//        }
//    }
//}

extension MyProfileHeaderTblCell{
    
    func friendsListFromServer(){
        guard  let userID = appDelegate.loginUser?.user_id else {return}
        apiTask = APIRequest.shared().getMyfriendList(page: self.pageNumber, user_id: Int(userID), search_type: nil) { [weak self](response, error) in
            if response != nil && error == nil {
                GCDMainThread.async{
                    let totalCnt = response?["total_my_friends"] as? Int
                    self?.totalFriendsCnt = totalCnt ?? 0
//                    self?.btnTotalFriend.setTitle("\(self?.totalFriendsCnt.toString)", for: .normal)
                    self?.btnTotalFriend.setTitle(self?.totalFriendsCnt.toString, for: .normal)
                }
            }
        }
    }
}
