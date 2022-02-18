//
//  AddPollViewController.swift
//  Sevenchats
//
//  Created by mac-00020 on 27/05/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Chandrika.R                                 *
 * Model   : PollDetailsViewController                   *
 * Changes :                                             *
 *                                                       *
 ********************************************************/


import UIKit

enum PollType : Int {
    case addPoll = 0
}


class MDLAddPollQuestion : NSObject{
    var option : String
    init(option: String) {
        self.option = option
    }
}

class AddPollViewController: ParentViewController {
    
    //MARK: - IBOutlet/Object/Variable Declaration
    @IBOutlet var topContaier : UIView!
    @IBOutlet var btnAddMoreFriends : UIButton!
    @IBOutlet var btnSelectGroupFriend : UIButton!
    @IBOutlet var clGroupFriend : UICollectionView!
    @IBOutlet var viewSelectGroup : UIView!
    @IBOutlet private weak var categoryDropDownView: CustomDropDownView!
    
    @IBOutlet var txtQuestion : GenericTextView!{
        didSet{
            self.txtQuestion.txtDelegate = self
            self.txtQuestion.type = "1"
            self.txtQuestion.isScrollEnabled = true
            self.txtQuestion.textLimit = "150"
        }
    }
    
    @IBOutlet var tblAddQuestion : UITableView!
    @IBOutlet var cntTblAddQuestionHeight : NSLayoutConstraint!
    
    @IBOutlet weak var txtInviteType : MIGenericTextFiled!
    var selectedInviteType : Int = 3 {
        didSet{
            self.didChangeInviteType()
        }
    }
    
    var arrQuestions : [MDLAddPollQuestion] = []
    var minOptions : Int = 2
    var maxOptions : Int = 4
    var heightOfOptionCell: CGFloat = 45
    var arrSelectedGroupFriends = [[String : Any]]()
    var categoryID : Int?
    var pollType : PollType!
    var pollID : Int?
    var optional = [String]()
    var arrSubCategory =  [[String : Any]]()
    var categorysubName : String?
    var apiTask : URLSessionTask?
    var currentPage : Int = 1
    var categoryName : String?
    var pollOptionLst :String?
    var arrsubCategorys : [MDLIntrestSubCategory] = []
    
    //MARK: - View life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        
        topContaier.isHidden = true
        viewSelectGroup.isHidden = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: - Memory management methods
    deinit {
        print("### deinit -> AddPollViewController")
    }
}

//MARK: - SetupUI
extension AddPollViewController {
    fileprivate func setupView() {
        
        self.title = CAddPoll
        
        addBarButtonItems()
        updateUIAccordingToLanguage()
        
        arrQuestions = [
            MDLAddPollQuestion(option: ""),
            MDLAddPollQuestion(option: "")
        ]
        
        let arrCategory = MIGeneralsAPI.shared().fetchCategoryFromLocalPoll()
        
        /// Set Dropdown on txtCategory
        categoryDropDownView.arrDataSource = arrCategory.map({ (obj) -> String in
            return (obj[CCategoryName] as? String ?? "")
        })
        
        /// On select text from the auto-complition
        categoryDropDownView.onSelectText = { [weak self] (item) in
            
            guard let `self` = self else { return }
            
            let objArry = arrCategory.filter({ (obj) -> Bool in
                return ((obj[CCategoryName] as? String) == item)
            })
            
            if (objArry.count > 0) {
                self.categoryName = (objArry.first?[CCategoryName] as? String) ?? ""
            }
        }
        let arrInviteType = [CPostPostsInviteGroups, CPostPostsInviteContacts,  CPostPostsInvitePublic, CPostPostsInviteAllFriends]
        
        txtInviteType.setPickerData(arrPickerData: arrInviteType, selectedPickerDataHandler: { [weak self] (text, row, component) in
            guard let self = self else { return }
            self.selectedInviteType = (row + 1)
            }, defaultPlaceholder: CPostPostsInviteGroups)
        
        // By default `All type` selected
        self.selectedInviteType = 4
        
        //AddPollQuestionCell
        tblAddQuestion.register(UINib(nibName: "AddPollQuestionCell", bundle: nil), forCellReuseIdentifier: "AddPollQuestionCell")
        tblAddQuestion.delegate = self
        tblAddQuestion.dataSource = self
        tblAddQuestion.tableFooterView = UIView()
        tblAddQuestion.separatorStyle = .none
        reloadTblAddPoll()
        
        self.clGroupFriend.delegate = self
        self.clGroupFriend.dataSource = self
    }
    
    fileprivate func addBarButtonItems() {
        
        let addMediaBarButtion = BlockBarButtonItem(image: UIImage(named: "ic_add_post"), style: .plain) { [weak self] (_) in
            guard let _ = self else {return}
            self?.resignKeyboard()
            if self?.isValidForAddPost() ?? false{
                print("Ready for post")
                if self?.txtQuestion.text != "" && self?.pollOptionLst != "" {
                    let characterset = CharacterSet(charactersIn:SPECIALCHAR)
                    if self?.txtQuestion.text.rangeOfCharacter(from: characterset.inverted) != nil || self?.pollOptionLst?.rangeOfCharacter(from: characterset.inverted) != nil  {
                       print("true")
                        self?.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageSpecial, btnOneTitle: CBtnOk, btnOneTapped: nil)
                    } else {
                       print("false")
                        self?.addEditPoll()
                    }
                }
               // self?.addEditPoll()
            }
        }
        self.navigationItem.rightBarButtonItems = [addMediaBarButtion]
    }
    
    fileprivate func updateUIAccordingToLanguage(){
        
        txtQuestion.placeHolder = CAddQuestion
        txtQuestion.textLimit = "200"
        categoryDropDownView.txtCategory.placeholder = CSelectCategoryOfPoll
        btnSelectGroupFriend.setTitle(CMessagePostsSelectFriends, for: .normal)
        txtInviteType.placeHolder = CVisiblity
    
        if arrSelectedGroupFriends.count > 0{
            self.clGroupFriend.reloadData()
            self.clGroupFriend.isHidden = false
            self.btnAddMoreFriends.isHidden = false
            self.btnSelectGroupFriend.isHidden = true
        }
    }
    
    fileprivate func reloadTblAddPoll(){
        DispatchQueue.main.async {
            self.tblAddQuestion.reloadData()
            self.tblAddQuestion.layoutIfNeeded()
            self.cntTblAddQuestionHeight.constant = self.heightOfOptionCell *  CGFloat(self.arrQuestions.count)
        }
    }
    
    fileprivate func isValidForAddPost() -> Bool{
        
        func displayAlertMessage(meesage:String){
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: meesage, btnOneTitle: CBtnOk, btnOneTapped: nil)
        }
        if (categoryDropDownView.txtCategory.text?.isBlank)! {
            displayAlertMessage(meesage: CPleaseSelectPollCategory)
            return false
        }
        
        if (txtQuestion.text?.isBlank)! {
            displayAlertMessage(meesage: CMessagePollQuestion)
            return false
        }
        let blankOptionCount = arrQuestions.filter({!$0.option.isBlank}).count
        if blankOptionCount <= 1 {
            displayAlertMessage(meesage: CMessagePollAddOption)
            return false
        }
        
        var arr = self.arrQuestions.map({$0.option})
        if arr.checkDuplicates(){
            displayAlertMessage(meesage: CPollOptionAlreadyExist)
            return false
        }
        
        if (self.selectedInviteType == 1 || self.selectedInviteType == 2) && arrSelectedGroupFriends.count == 0 {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageSelectContactGroupPoll, btnOneTitle: CBtnOk, btnOneTapped: nil)
            return false
        }
        
        return true
    }
}

//MARK: - API's Calling
extension AddPollViewController {
    
    fileprivate func addEditPoll(){
        
        var apiPara = [String : Any]()
        var apiParaGroups = [String]()
        var apiParaFriends = [String]()
        
        apiPara[CPostType] = 10
        apiPara[CTitle] = txtQuestion.text
        apiPara[CCategory_Id] = categoryDropDownView.txtCategory.text
        
        apiPara[CPublish_To] = self.selectedInviteType
        var arrOptions : [String] = []
        for obj in self.arrQuestions{
            if !obj.option.isBlank{
                arrOptions.append(obj.option)
            }
        }
        let arrOptToString:String = "\(arrOptions)"
        apiPara[COptions] = arrOptions
        let strConvertJson = arrJson(arrString:arrOptions)
        let pollOption = strConvertJson.components(separatedBy: .whitespacesAndNewlines).joined()
        print("jsonconv:::\(pollOption)")
        
        guard let userID = appDelegate.loginUser?.user_id else { return}
        
        do {
                    let data = try JSONEncoder().encode(arrOptions)
                    let string = String(data: data, encoding: .utf8)!
                    let replaced4 = string.replacingOccurrences(of: "\"", with: "\\\"")
                    print(replaced4)
                    pollOptionLst  = replaced4
                    print(replaced4)
                    
                } catch { print(error) }
                
        var dict :[String:Any]  =  [
                    "image" : "",
                    "age_limit":"13",
                    "token" : "1234567890abcdefghijklmnoupqrstuvwxyz",
                    "user_id":userID,
                    "post_category":categoryDropDownView.txtCategory.text!,
                    "post_title":txtQuestion.text!,
                    "options":pollOptionLst as Any,
                  ]
        
        if self.selectedInviteType == 1{
            let groupIDS = arrSelectedGroupFriends.map({$0.valueForString(key: CGroupId) }).joined(separator: ",")
            apiParaGroups = groupIDS.components(separatedBy: ",")
            
        }else if self.selectedInviteType == 2{
            let userIDS = arrSelectedGroupFriends.map({$0.valueForString(key: CFriendUserID) }).joined(separator: ",")
            apiParaFriends = userIDS.components(separatedBy: ",")
        }
        
        if apiParaGroups.isEmpty == false {
            dict[CTargetAudiance] = apiParaGroups
        }else {
            dict[CTargetAudiance] = "none"
        }
        
        if apiParaFriends.isEmpty == false {
            dict[CSelectedPerson] = apiParaFriends
        }else {
            dict[CSelectedPerson] = "none"
        }
        
        APIRequest.shared().addEditPost(para: dict, image: nil, apiKeyCall: CAPITagpolls) { [weak self] (response, error) in
            if response != nil && error == nil{
                
                if let metaInfo = response![CJsonMeta] as? [String : Any] {
                    let name = (appDelegate.loginUser?.first_name ?? "") + " " + (appDelegate.loginUser?.last_name ?? "")
                    guard let image = appDelegate.loginUser?.profile_img else { return }
                    let stausLike = metaInfo["status"] as? String ?? "0"
                    if stausLike == "0" {
                        
                        MIGeneralsAPI.shared().addRewardsPoints(CPostcreate,message:CPostcreate,type:"poll",title: self?.categoryDropDownView.txtCategory.text ?? "",name:name,icon:image, detail_text: "post_point")
                    }
                }
                
                self?.navigationController?.popViewController(animated: true)
                
                CTopMostViewController.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessagePollPostUpload, btnOneTitle: CBtnOk, btnOneTapped: nil)
                
                if let pollInfo = response![CJsonData] as? [String : Any]{
                    MIGeneralsAPI.shared().refreshPostRelatedScreens(pollInfo,self?.pollID, self!,  .addPost, rss_id: 0)
                    
                    APIRequest.shared().saveNewInterest(interestID: pollInfo.valueForInt(key: CCategory_Id) ?? 0, interestName: pollInfo.valueForString(key: CCategory))
                }
            }
        }
        
    }
}

//MARK: - UITableViewDataSource, UITableViewDelegate
extension AddPollViewController : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightOfOptionCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrQuestions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddPollQuestionCell") as? AddPollQuestionCell else{
            return UITableViewCell(frame: .zero)
        }
        cell.option = arrQuestions[indexPath.row]
        cell.btnAdd.isHidden = false
        if (indexPath.row + 1) <= (minOptions - 1) {
            cell.btnAdd.isHidden = true
        }
        
        if (indexPath.row + 1) == maxOptions  {
            // This is for last option
            cell.btnAdd.isSelected = false
        }else{
            cell.btnAdd.isSelected = (indexPath.row == (self.arrQuestions.count - 1))
        }
        cell.txtOption.attributedPlaceholder = NSAttributedString(string:"\(COption) \(indexPath.row + 1)",attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        //cell.txtOption.placeholder = "\(COption) \(indexPath.row + 1)"
        cell.txtOption.tag = indexPath.row
        cell.btnAdd.tag = indexPath.row
        cell.btnAdd.touchUpInside { [weak self] (sender) in
            
            guard let _ = self else {return}
            self?.addOrRemoveOption(isAdd: sender.isSelected,index: sender.tag)
        }
        return cell
    }
    
    func addOrRemoveOption(isAdd:Bool,index:Int){
        if isAdd && maxOptions <= self.arrQuestions.count{
            return
        }
        if isAdd {
            self.arrQuestions.append(MDLAddPollQuestion(option: ""))
            self.reloadTblAddPoll()
            return
        }
        self.arrQuestions.remove(at: index)
        self.reloadTblAddPoll()
    }
}

// MARK:- --------- UICollectionView Delegate/Datasources
extension AddPollViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arrSelectedGroupFriends.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BubbleWithCancelCollCell", for: indexPath) as! BubbleWithCancelCollCell
        let selectedInfo = arrSelectedGroupFriends[indexPath.row]
        
        if (self.selectedInviteType == 2) {
            cell.lblBubbleText.text = selectedInfo.valueForString(key: CFirstname) + " " + selectedInfo.valueForString(key: CLastname)
        }else{
            cell.lblBubbleText.text = selectedInfo.valueForString(key: CGroupTitle)
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        arrSelectedGroupFriends.remove(at: indexPath.row)
        clGroupFriend.reloadData()
        
        if arrSelectedGroupFriends.count == 0{
            btnSelectGroupFriend.isHidden = false
            clGroupFriend.isHidden = true
            btnAddMoreFriends.isHidden = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let selectedInfo = arrSelectedGroupFriends[indexPath.row]
        var title = ""
        if self.selectedInviteType == 2 {
            title = selectedInfo.valueForString(key: CFirstname) + " " + selectedInfo.valueForString(key: CLastname)
        }else{
            title = selectedInfo.valueForString(key: CGroupTitle)
        }
        let fontToResize =  CFontPoppins(size: 12, type: .light).setUpAppropriateFont()
        var size = title.size(withAttributes: [NSAttributedString.Key.font: fontToResize!])
        size.width = CGFloat(ceilf(Float(size.width + 65)))
        size.height = clGroupFriend.frame.size.height
        return size
        
    }
}

// MARK:- ----------- Action Event
extension AddPollViewController{
    
    @IBAction func btnSelectGroupFriendCLK(_ sender : UIButton){
        
        if let groupFriendVC = CStoryboardGeneral.instantiateViewController(withIdentifier: "GroupFriendSelectionViewController") as? GroupFriendSelectionViewController{
            groupFriendVC.arrSelectedGroupFriend = self.arrSelectedGroupFriends
            groupFriendVC.isFriendList = (self.selectedInviteType == 2)
            groupFriendVC.setBlock { (arrSelected, message) in
                if let arr = arrSelected as? [[String : Any]]{
                    self.arrSelectedGroupFriends = arr
                    self.clGroupFriend.isHidden = arr.isEmpty
                    self.btnAddMoreFriends.isHidden = arr.isEmpty
                    self.btnSelectGroupFriend.isHidden = !arr.isEmpty
                    self.clGroupFriend.reloadData()
                }
            }
            self.navigationController?.pushViewController(groupFriendVC, animated: true)
        }
    }
    
    func didChangeInviteType(){
        
        arrSelectedGroupFriends = []
        clGroupFriend.reloadData()
        clGroupFriend.isHidden = true
        btnAddMoreFriends.isHidden = true
        btnSelectGroupFriend.isHidden = false
        
        switch self.selectedInviteType {
        case 1:
            self.txtInviteType.text = CPostPostsInviteGroups
            viewSelectGroup.hide(byHeight: false)
        case 2:
            self.txtInviteType.text = CPostPostsInviteContacts
            viewSelectGroup.hide(byHeight: false)
        case 3:
          
          self.txtInviteType.text = CPostPostsInvitePublic
            btnSelectGroupFriend.isHidden = true
            viewSelectGroup.hide(byHeight: true)
        case 4:
            self.txtInviteType.text = CPostPostsInviteAllFriends
            btnSelectGroupFriend.isHidden = true
            viewSelectGroup.hide(byHeight: true)
        default:
            break
        }
        
        DispatchQueue.main.async {
            self.txtInviteType.updatePlaceholderFrame(true)
        }
    }
}

extension AddPollViewController{
    func fetchsubCategoryFromLocal() -> [[String : Any]] {
        var arrCategory = [[String : Any]]()

        if arrCategory.count < 1 {
            // If not intereste selected by user then show all interest.....
            let arrCategoryTemp = TblSubIntrest.fetchAllObjects()
            for interest in arrCategoryTemp!{
                var dicData = [String : Any]()
                let interestInfo = interest as? TblSubIntrest
                dicData[CinterestLevel2] = interestInfo?.interest_level2
                arrCategory.append(dicData)
            }
        }
        if !arrCategory.isEmpty{
            let sortedResults =  arrCategory.sorted { (obj1, obj2) -> Bool in
                (obj1[CinterestLevel2] as! String).localizedCaseInsensitiveCompare(obj2[CinterestLevel2] as! String) == .orderedAscending
            }
            return sortedResults
        }
        return arrCategory
    }
    
}

extension AddPollViewController{
    
    func arrJson(arrString:[String]) ->String{
        
        var myJsonString = ""
            do {
                let data =  try JSONSerialization.data(withJSONObject:arrString, options: .prettyPrinted)
               myJsonString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as! String
            } catch {
                print(error.localizedDescription)
            }
            return myJsonString
        
    }
    
}


// MARK:-  --------- Generic UITextView Delegate
extension AddPollViewController: GenericTextViewDelegate{
    
    func genericTextViewDidChange(_ textView: UITextView, height: CGFloat){
        
        if textView == txtQuestion{
//            lblTextCount.text = "\(textView.text.count)/\(txtViewArticleContent.textLimit ?? "0")"
        }
    }
    

}
