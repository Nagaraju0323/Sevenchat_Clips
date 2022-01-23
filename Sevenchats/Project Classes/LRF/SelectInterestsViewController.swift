//
//  SelectInterestsViewController.swift
//  Sevenchats
//
//  Created by mac-0005 on 08/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//


/*********************************************************
 * Author  : Chandrika.R                                 *
 * Model   : SelectInterestsViewController               *
 * Changes :                                             *
 * User can Selecte own Intrest                          *
 ********************************************************/

import UIKit

class SelectInterestsViewController: ParentViewController {
    
    @IBOutlet var imgSelectAllFriend : UIImageView!
    @IBOutlet var btnSelectAllFriend : UIButton!
    @IBOutlet var tblInterest : UITableView!
    @IBOutlet var viewSearchBar : UIView!
    @IBOutlet var btnSearch : UIButton!
    @IBOutlet var btnBack : UIButton!
    @IBOutlet var btnCancel : UIButton!
    @IBOutlet var txtSearch : UITextField!{
        didSet{
            txtSearch.returnKeyType = .search
        }
    }
    @IBOutlet var viewAddInterest : UIView!
    @IBOutlet var btnBigDone : UIButton!
    @IBOutlet var btnSmallDone : UIButton!
    @IBOutlet var btnSkip : UIButton!
    @IBOutlet var btnAddInterest : UIButton!
    @IBOutlet var lblTitle : UILabel!
    @IBOutlet var lblSelectAll : UILabel!
    
    var refreshControl = UIRefreshControl()
    var currentPage : Int = 1
    var apiTask : URLSessionTask?
    var arrInterest = [[String : Any]]()
    var arrSelectedInterest = [[String : Any]]()
    var isBackButtomHide : Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Initialization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateUIAccordingToLanguage()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK:- --------- Initialization
    func Initialization(){
        btnSelectAllFriend.isSelected = false
        viewAddInterest.layer.cornerRadius = 3
        
        btnBigDone.isHidden = isBackButtomHide
        btnBack.hide(byWidth: isBackButtomHide)
        
        GCDMainThread.async {
            self.viewSearchBar.layer.cornerRadius = self.viewSearchBar.frame.size.height/2
        }
        
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        refreshControl.tintColor = ColorAppTheme
        tblInterest.pullToRefreshControl = refreshControl
        self.loadInterestList(search: txtSearch.text ?? "", showLoader: true)
        
    }
    
    func updateUIAccordingToLanguage(){
        
        if Localization.sharedInstance.applicationFlowWithLanguageRTL() {
            // Reverse Flow...
            btnSearch.contentHorizontalAlignment = .left
            btnBack.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        }else{
            // Normal Flow...
            btnSearch.contentHorizontalAlignment = .right
            btnBack.transform = CGAffineTransform.identity
        }
        
        btnCancel.setTitle(CBtnCancel, for: .normal)
        btnBigDone.setTitle(CBtnDone, for: .normal)
        btnSmallDone.setTitle(CBtnDone, for: .normal)
        btnSkip.setTitle(CBtnSkip, for: .normal)
        btnAddInterest.setTitle("+" + "    " + CBtnAddYourInterest, for: .normal)
        lblTitle.text = CSelectInterestTitle
        lblSelectAll.text = CSelectAll
        
    }
}

// MARK:- --------- API
extension SelectInterestsViewController{
    
    @objc func pullToRefresh() {
        if apiTask?.state == URLSessionTask.State.running {
            apiTask?.cancel()
        }
        
        refreshControl.beginRefreshing()
        currentPage = 1
        self.loadInterestList(search: txtSearch.text ?? "", showLoader: false)
    }
    
    func loadInterestList(search : String, showLoader : Bool) {
        
        if apiTask?.state == URLSessionTask.State.running {
            return
        }
        
        // Add load more indicator here...
        if self.currentPage > 2 {
            self.tblInterest.tableFooterView = self.loadMoreIndicator(ColorAppTheme)
        }else{
            self.tblInterest.tableFooterView = nil
        }
        guard let langName = appDelegate.loginUser?.lang_name else {
            return
        }
        
        
        apiTask = APIRequest.shared().getInterestListNew(search: search,langName : langName, type: CInterestType, page: currentPage, showLoader : showLoader) { (response, error) in
            self.refreshControl.endRefreshing()
            self.arrInterest.removeAll()
            self.tblInterest.tableFooterView = nil
            
            if response != nil && error == nil {
                if let arrData = response![CJsonData] as? [[String : Any]]
                {
                    if self.currentPage == 1 {
                        self.arrInterest.removeAll()
                        self.tblInterest.reloadData()
                    }
                    
                    if arrData.count > 0{
                        self.arrInterest = self.arrInterest + arrData
                        self.tblInterest.reloadData()
                        self.currentPage += 1
                    }
                }
            }
        }
    }
    
    
    func addInterestRequest(interestName : String) {
        
    }
    
    func addSelectedInterest(_ moveOnBackScreen : Bool){
        
        var interestID = arrSelectedInterest.map({"\($0.valueForInt(key: "id") ?? 0)"}).joined(separator: ",")
        
        // For all selected interest...
        if btnSelectAllFriend.isSelected {
            interestID = "0"
        }
        
    }
}


// MARK:- --------- UITextField Delegate
extension SelectInterestsViewController : UITextFieldDelegate {
    
    @IBAction func textFieldDidChanged(textField : UITextField) {
        if apiTask?.state == URLSessionTask.State.running {
            apiTask?.cancel()
        }
        
        currentPage = 1
        self.loadInterestList(search: textField.text ?? "", showLoader: false)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}


// MARK:- --------- UITableView Datasources/Delegate
extension SelectInterestsViewController : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrInterest.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SelectLanguageCell", for: indexPath) as? SelectLanguageCell {
            
            let dict = arrInterest[indexPath.row]
            
            cell.imgSelected.isHidden = !arrSelectedInterest.contains(where: { $0.valueForString(key: "interest_type") == dict.valueForString(key: "interest_type")} )
            cell.lblLanguage.text = dict.valueForString(key: "interest_type")
            
            //...Load More
            if indexPath == tblInterest.lastIndexPath() {
                self.loadInterestList(search: txtSearch.text ?? "", showLoader: false)
            }
            
            return cell
        }
        
        return tableView.tableViewDummyCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dict = arrInterest[indexPath.row]
        
        if arrSelectedInterest.contains(where: { $0.valueForString(key: "interest_type") == dict.valueForString(key: "interest_type")} ){
            if let index = arrSelectedInterest.index(where: { $0.valueForString(key: "interest_type") == dict.valueForString(key: "interest_type")}) {
                arrSelectedInterest.remove(at: index)
            }
        } else {
            arrSelectedInterest.append(dict)
        }
        
        tblInterest.reloadData()
    }
}


// MARK:- --------- Action Event
extension SelectInterestsViewController{
    
    @IBAction func btnSkipDoneCLK(_ sender : UIButton){
        
        switch sender.tag {
        case 0: // Skip CLK
            appDelegate.initHomeViewController()
            break
        case 1: // Done CLK
            self.addSelectedInterest(false)
            break
            
        default:
            break
        }
    }
    
    @IBAction func btnDoneCLK(_ sender : UIButton){
        
        for vwController in (self.navigationController?.viewControllers)! {
            if vwController.isKind(of: CompleteProfileViewController .classForCoder()){
                let completeProfileVC = vwController as? CompleteProfileViewController
                completeProfileVC?.arrInterest = self.arrSelectedInterest
                completeProfileVC?.clInterest.reloadData()
                self.navigationController?.popViewController(animated: true)
                break
            }
        }
    }
    
    @IBAction func btnSelectAllFriendCLK(_ sender : UIButton){
        btnSelectAllFriend.isSelected = !btnSelectAllFriend.isSelected
        imgSelectAllFriend.isHidden = !btnSelectAllFriend.isSelected
        
        if btnSelectAllFriend.isSelected{
            arrSelectedInterest.removeAll()
            arrSelectedInterest = arrInterest
            tblInterest.reloadData()
        }else{
            arrSelectedInterest.removeAll()
            tblInterest.reloadData()
        }
    }
    
    @IBAction func btnAddInterestCLK(_ sender : UIButton){
        let alertController = UIAlertController(title: CMessageAddInterest, message: CCreateOwnInterest, preferredStyle: .alert)
        
        alertController.addTextField { (alertTextField) in
        }
        alertController.addAction(UIAlertAction(title: CBtnCancel, style: .default, handler: nil))
        alertController.addAction(UIAlertAction(title: CBtnSave, style: .default, handler: { (alert) in
            
            if (alertController.textFields?.count)! > 0{
                let textField = alertController.textFields![0]
                if (textField.text?.isBlank)!{
                    self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CInterestBlank, btnOneTitle: CBtnOk, btnOneTapped: { (alert) in
                        self.btnAddInterestCLK(UIButton())
                    })
                }else{
                    //...Add Interest
                    self.addInterestRequest(interestName: textField.text ?? "")
                }
            }
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func btnSearchCancelCLK(_ sender : UIButton){
        
        switch sender.tag {
        case 0:
            viewSearchBar.isHidden = false
            btnCancel.isHidden = false
            btnSearch.isHidden = true
            break
        case 1:
            viewSearchBar.isHidden = true
            btnCancel.isHidden = true
            btnSearch.isHidden = false
            txtSearch.text = nil
            break
            
        case 2:
            txtSearch.text = nil
            break
            
        default:
            break
            
        }
        
        self.loadInterestList(search: txtSearch.text ?? "", showLoader: false)
    }
}



