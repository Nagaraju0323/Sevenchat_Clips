//
//  OtherUserCompleteProfileViewController.swift
//  Sevenchats
//
//  Created by mac-0005 on 30/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Nagaraju K and Chandrika R                                 *
 * Model   : OtherUserCompleteProfileViewController      *
 * Changes :                                             *
 *                                                       *
 ********************************************************/


import UIKit

class OtherUserCompleteProfileViewController: ParentViewController,MICollectionViewBubbleLayoutDelegate {
    
    @IBOutlet weak var lblBiography : UILabel!
    @IBOutlet weak var lblGender : UILabel!
    @IBOutlet weak var lblStatus : UILabel!
    @IBOutlet weak var lblEducation : UILabel!
    @IBOutlet weak var lblReligion : UILabel!
    @IBOutlet weak var lblProfession : UILabel!
    @IBOutlet weak var lblIncomeLevel : UILabel!
    @IBOutlet weak var lblTitleBiography : UILabel!
    @IBOutlet weak var lblTitleGender : UILabel!
    @IBOutlet weak var lblTitleStatus : UILabel!
    @IBOutlet weak var lblTitleEducation : UILabel!
    @IBOutlet weak var lblTitleReligion : UILabel!
    @IBOutlet weak var lblTitleProfession : UILabel!
    @IBOutlet weak var lblTitleIncomeLevel : UILabel!
    @IBOutlet weak var lblTitlePersonalInterest : UILabel!
    @IBOutlet weak var clPersonalInterest : UICollectionView!
    @IBOutlet weak var cnCollHeight : NSLayoutConstraint!
    
    var isLoginUser : Bool!
    var arrPersonalInterest = [[String : AnyObject]]()
    var userID : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Initialization()
        clPersonalInterest.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateUIAccordingToLanguage()
        self.prefilledUserDetail()
    }
    
    // MARK:- --------- Initialization
    func Initialization(){
        
        //...UICollectionView setup
        let bubbleLayout = MICollectionViewBubbleLayout()
        bubbleLayout.minimumLineSpacing = 10.0
        bubbleLayout.minimumInteritemSpacing = 10.0
        bubbleLayout.delegate = self
        clPersonalInterest.setCollectionViewLayout(bubbleLayout, animated: false)
    }
    
    func updateUIAccordingToLanguage(){
        
        if Localization.sharedInstance.applicationFlowWithLanguageRTL() {
            // Reverse Flow...
            clPersonalInterest.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        }else{
            // Normal Flow...
            clPersonalInterest.transform = CGAffineTransform.identity
        }
        
        lblTitleBiography.text = CProfilePlaceholderBiography
        lblTitleGender.text = CRegisterPlaceholderGender
        lblTitleStatus.text = CProfilePlaceholderStatus
        lblTitleEducation.text = CProfilePlaceholderEducation
        lblTitleReligion.text = CProfilePlaceholderReligiousInclination
        lblTitleProfession.text = CProfilePlaceholderProfession
        lblTitleIncomeLevel.text = CProfilePlaceholderReligiousIncomeLevel
        lblTitlePersonalInterest.text = CProfilePlaceholderReligiousPersonalInterest
        lblTitlePersonalInterest.isHidden = true 
        
    }
}

// MARK:- --------- API Functions
extension OtherUserCompleteProfileViewController{
    func prefilledUserDetail() {
        if isLoginUser {
            
            self.title = CNavCompleteProfile
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_edit_profile"), style: .plain, target: self, action: #selector(btnEditProfileClicked(_:)))
            let arrEducation = TblEducation.fetch(predicate: NSPredicate(format: "%K == %d", CEducation_id, appDelegate.loginUser?.education_id ?? 0), orderBy: CName, ascending: true)
            if (arrEducation?.count)! > 0 {
                let dict = arrEducation![0] as? TblEducation
                lblEducation.text = dict?.name
            }else{
                lblEducation.text = nil
            }
            //...Relationship
            let arrRelation = TblRelation.fetch(predicate: NSPredicate(format: "%K == %d", CRelationship_id, appDelegate.loginUser?.relationship_id ?? 0), orderBy: CName, ascending: true)
            if (arrRelation?.count)! > 0 {
                let dict = arrRelation![0] as? TblRelation
                lblStatus.text = dict?.name
            }else{
                lblStatus.text = nil
            }
            
            //...Income
            let arrIncome = TblAnnualIncomes.fetch(predicate: NSPredicate(format: "%K == %d", CAnnual_income_id, appDelegate.loginUser?.annual_income_id ?? 0), orderBy: CIncome, ascending: true)
            if (arrIncome?.count)! > 0 {
                let dict = arrIncome![0] as? TblAnnualIncomes
                lblIncomeLevel.text = dict?.income
            }else{
                lblIncomeLevel.text = nil
            }
            
            //...Gender
            switch Int((appDelegate.loginUser?.gender)!) {
            case CMale :
                lblGender.text = CRegisterGenderMale
            case CFemale :
                lblGender.text = CRegisterGenderFemale
            default :
                lblGender.text = CRegisterGenderOther
            }
            
            //...Employee Profession
            switch appDelegate.loginUser?.employment_status {
            case 1:
                lblProfession.text = appDelegate.loginUser?.profession
            case 2:
                lblProfession.text = CBtnUnemployed
            case 3:
                lblProfession.text = CBtnStudent
            default:
                break
            }
            
            lblBiography.text = appDelegate.loginUser?.short_biography
            lblReligion.text = appDelegate.loginUser?.religion
            lblEducation.text  = appDelegate.loginUser?.education_name
            lblStatus.text = appDelegate.loginUser?.relationship
            lblIncomeLevel.text = appDelegate.loginUser?.annual_income
        } else {
            self.loadUserDetail()
        }
    }
    //MARK:- NEW CODE
    
    func loadUserDetail() {
        if let userid = userID{
            APIRequest.shared().userDetailNew(userID: userid.toString,apiKeyCall: "users/id/") { [weak self] (response, error) in
                if response != nil && error == nil {
                    if let Info = response!["data"] as? [[String:Any]]{
                        for userInfo in Info {
                            self?.title = userInfo.valueForString(key: CFirstname) + " " + userInfo.valueForString(key: CLastname)
                            self?.title = userInfo.valueForString(key: CFirstname) + " " + userInfo.valueForString(key: CLastname)
                            
                            self?.lblBiography.text = userInfo.valueForString(key: CShort_biography)
                            self?.lblProfession.text = userInfo.valueForString(key: CProfession)
                            self?.lblReligion.text = userInfo.valueForString(key: CReligion)
                            self?.lblEducation.text = userInfo.valueForString(key: "education")
                            self?.lblStatus.text = userInfo.valueForString(key: "relationship")
                            self?.lblIncomeLevel.text = userInfo.valueForString(key: "income")
                            switch userInfo.valueForInt(key: CGender) {
                            case CMale :
                                self?.lblGender.text = CRegisterGenderMale
                            case CFemale :
                                self?.lblGender.text = CRegisterGenderFemale
                            default :
                                self?.lblGender.text = CRegisterGenderOther
                            }
                            
                            //...Relationship
                            let arrRelation = TblRelation.fetch(predicate: NSPredicate(format: "%K == %d", CRelationship_id, userInfo.valueForInt(key: CRelationship_id) ?? 0), orderBy: CName, ascending: true)
                            if (arrRelation?.count)! > 0 {
                                let dict = arrRelation![0] as? TblRelation
                                self?.lblStatus.text = dict?.name
                            }
                            //...Income
                            let arrIncome = TblAnnualIncomes.fetch(predicate: NSPredicate(format: "%K == %d", CAnnual_income_id, userInfo.valueForInt(key: CAnnual_income_id) ?? 0), orderBy: CIncome, ascending: true)
                            if (arrIncome?.count)! > 0 {
                                let dict = arrIncome![0] as? TblAnnualIncomes
                                self?.lblIncomeLevel.text = dict?.income
                            }
                            
                            if let arrInter = userInfo[CInterest] as? [[String : AnyObject]]{
                                self?.arrPersonalInterest = arrInter
                                self?.clPersonalInterest.reloadData()
                                self?.clPersonalInterest.performBatchUpdates({ [weak self] in
                                    self?.cnCollHeight.constant = self?.clPersonalInterest.contentSize.height ?? 0
                                }) { [weak self](completed) in
                                    guard let _ = self else { return }
                                    self?.cnCollHeight.constant = self?.clPersonalInterest.contentSize.height ?? 0
                                }
                            }
                            
                        }
                    }
                }
            }
        }
    }
}

// MARK:- --------- UICollectionView Delegate/Datasources
extension OtherUserCompleteProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arrPersonalInterest.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BubbleCollCell", for: indexPath) as! BubbleCollCell
        
        let dict = arrPersonalInterest[indexPath.row]
        cell.lblCategory.text = dict.valueForString(key: CName)
        cell.backgroundColor = CRGB(r: 139, g: 180, b: 131)
        cell.lblCategory.textColor = UIColor.white
        return cell
    }
    
    // MARK: -
    // MARK: - MICollectionViewBubbleLayoutDelegate
    
    func collectionView(_ collectionView:UICollectionView, itemSizeAt indexPath:NSIndexPath) -> CGSize{
        let fontToResize =  CFontPoppins(size: 12, type: .light).setUpAppropriateFont()
        let dict = arrPersonalInterest[indexPath.row]
        var size = dict.valueForString(key: CName).size(withAttributes: [NSAttributedString.Key.font: fontToResize!])
        size.width = CGFloat(ceilf(Float(size.width + CGFloat(kItemPadding * 2))))
        size.height = 25
        
        //...Checking if item width is greater than collection view width then set item width == collection view width.
        if size.width > collectionView.frame.size.width {
            size.width = collectionView.frame.size.width
        }
        return size;
    }
}

// MARK:- --------- Action Event
extension OtherUserCompleteProfileViewController{
    @objc fileprivate func btnEditProfileClicked(_ sender : UIBarButtonItem) {
        if let completeProfileVC = CStoryboardProfile.instantiateViewController(withIdentifier: "CompleteProfileViewController") as? CompleteProfileViewController{
            completeProfileVC.dob_edit = appDelegate.loginUser?.dob
            self.navigationController?.pushViewController(completeProfileVC, animated: true)
        }
    }
}


