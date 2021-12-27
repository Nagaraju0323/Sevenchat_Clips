//
//  SelectLanguageViewController.swift
//  Sevenchats
//
//  Created by mac-0005 on 07/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class SelectLanguageViewController: ParentViewController,UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tblLanguage : UITableView!
    @IBOutlet var btnBack : UIButton!
    @IBOutlet var viewSearchBar : UIView!
    @IBOutlet var btnSearch : UIButton!
    @IBOutlet var btnCancel : UIButton!
    @IBOutlet var btnDone : UIButton!
    @IBOutlet var lblSelectLanguage : UILabel!
    @IBOutlet var txtSearch : UITextField!{
        didSet{
            txtSearch.returnKeyType = .search
        }
    }
    
    var refreshControl = UIRefreshControl()
    var arrLanguage : [TblLanguage]?
    var selectedLanguage : TblLanguage!
    var isBackButton : Bool = false
    
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
        
        self.setLanguageText()
        
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        refreshControl.tintColor = ColorAppTheme
        tblLanguage.pullToRefreshControl = refreshControl
        
        if isBackButton{
            btnBack.hide(byWidth: false)
        }else{
            btnBack.hide(byWidth: true)
        }
        
        GCDMainThread.async {
            self.viewSearchBar.layer.cornerRadius = self.viewSearchBar.frame.size.height/2
        }
        
        self.loadLanguageList(showLoader: true)
    }
    
    func setLanguageText() {
        lblSelectLanguage.text = (appDelegate.langugaeText?.select_language) == nil ? "Select Language" : CSelectLanguage
        btnCancel.setTitle((appDelegate.langugaeText?.cancel) == nil ? "Cancel" : CBtnCancel, for: .normal)
        btnDone.setTitle((appDelegate.langugaeText?.done) == nil ? "Done" : CBtnDone, for: .normal)
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
    }
    
    func fetchAllLanguagesFromLocal() {
        //...Fetch langugae list from local
        let arr = TblLanguage.fetch(predicate: nil, orderBy: CName, ascending: true)
        arrLanguage?.removeAll()
        if (arr?.count)! > 0 {
            arrLanguage = arr as? [TblLanguage]
        }
        tblLanguage.reloadData()
    }
    
}

// MARK:- --------- UITableView Datasources/Delegate
extension SelectLanguageViewController{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrLanguage?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SelectLanguageCell", for: indexPath) as? SelectLanguageCell {
            let languageInfo = arrLanguage![indexPath.row]
            cell.imgSelected.isHidden = selectedLanguage != languageInfo
            cell.lblLanguage.text = languageInfo.name
            return cell
        }
        
        return tableView.tableViewDummyCell()
    }
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let languageInfo = arrLanguage![indexPath.row]
        selectedLanguage = languageInfo
        tblLanguage.reloadData()
    }
}


// MARK:- --------- UITextField Delegate
extension SelectLanguageViewController : UITextFieldDelegate {
    
    @IBAction func textFieldDidChanged(textField : UITextField) {
        
        if textField.text == "" {
            tblLanguage.restore()
           self.fetchAllLanguagesFromLocal()
        } else {
            
            let arr = TblLanguage.fetch(predicate: NSPredicate(format: "%K contains[c] %@", CName, txtSearch.text ?? ""), orderBy: CName, ascending: true)
            arrLanguage?.removeAll()
            if (arr?.count)! > 0 {
                arrLanguage = arr as? [TblLanguage]
                tblLanguage.restore()
            } else {
                
                // Data getting nil while searching then shoe no Data Found label
                tblLanguage.setEmptyMessage(CMessageNoDataFound)
            }
            tblLanguage.reloadData()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
}

// MARK:- --------- API
extension SelectLanguageViewController{
 
    @objc func pullToRefresh() {
        refreshControl.beginRefreshing()
        
        // For close search Bar
        self.btnSearchCancelCLK(btnCancel)
        
        self.loadLanguageList(showLoader: false)
    }
    
    func loadLanguageList(showLoader : Bool) {
        
        APIRequest.shared().getLanguageList(showLoader: showLoader,completion: { (response, error) in
            self.refreshControl.endRefreshing()
            if response != nil && error == nil{
                self.fetchAllLanguagesFromLocal()
                
                //...Get selected language
                if let langID = CUserDefaults.value(forKey: UserDefaultSelectedLangID) as? Int {
                    if let arrLang  = TblLanguage.fetch(predicate: NSPredicate(format: "lang_id==%d",langID)) as? [TblLanguage] {
                        if arrLang.count > 0 {
                            self.selectedLanguage = arrLang.last
                        }
                    }
                }else {
                //...Get English language if not selected anyone
                    if let arrLang  = TblLanguage.fetch(predicate: nil, orderBy: "lang_id", ascending: true) as? [TblLanguage] {
                        if arrLang.count > 0 {
                            self.selectedLanguage = arrLang.last
                        }
                    }
                }
            }
         })
        
        APIRequest.shared().getLanguageList(showLoader: showLoader,completion: { (response, error) in
            self.refreshControl.endRefreshing()
            if response != nil && error == nil{
                self.fetchAllLanguagesFromLocal()
                
                //...Get selected language
                if let langID = CUserDefaults.value(forKey: UserDefaultSelectedLangID) as? Int {
                    if let arrLang  = TblLanguage.fetch(predicate: NSPredicate(format: "lang_id==%d",langID)) as? [TblLanguage] {
                        if arrLang.count > 0 {
                            self.selectedLanguage = arrLang.last
                        }
                    }
                }else {
                //...Get English language if not selected anyone
                    if let arrLang  = TblLanguage.fetch(predicate: nil, orderBy: "lang_id", ascending: true) as? [TblLanguage] {
                        if arrLang.count > 0 {
                            self.selectedLanguage = arrLang.last
                        }
                    }
                }
            }
         })
        
        
    }
    
    func loadLanguageText() {
        
        APIRequest.shared().loadLanguagesText { (response, error) in
            if response != nil && error == nil {
                DispatchQueue.main.async {
                    let orientation = self.selectedLanguage.orientation ? 1 : 0
                    if orientation == CLTR {
                        UIView.appearance().semanticContentAttribute = .forceLeftToRight
                        UISearchBar.appearance().semanticContentAttribute = .forceLeftToRight
                        UITextView.appearance().semanticContentAttribute = .forceLeftToRight
                        UITextField.appearance().semanticContentAttribute = .forceLeftToRight
                        UINavigationBar.appearance().semanticContentAttribute = .forceLeftToRight
                        UILabel.appearance().semanticContentAttribute = .forceLeftToRight
                        appDelegate.window.semanticContentAttribute = .forceLeftToRight
                    } else {
                        UIView.appearance().semanticContentAttribute = .forceRightToLeft
                        UISearchBar.appearance().semanticContentAttribute = .forceRightToLeft
                        UITextView.appearance().semanticContentAttribute = .forceRightToLeft
                        UITextField.appearance().semanticContentAttribute = .forceRightToLeft
                        UINavigationBar.appearance().semanticContentAttribute = .forceRightToLeft
                        UILabel.appearance().semanticContentAttribute = .forceRightToLeft
                        appDelegate.window.semanticContentAttribute = .forceRightToLeft
                    }

                    MIGeneralsAPI.shared().fetchAllGeneralDataFromServer()
                    if let langCode = self.selectedLanguage.lang_code {
                        DateFormatter.shared().locale = Locale(identifier: langCode)
                    }
                    if self.isBackButton {
                        appDelegate.initHomeViewController()
                    }else{
                        appDelegate.initOnboardingViewController()
                    }
                }
            }
        }
    }
}

// MARK:- --------- Action Event
extension SelectLanguageViewController{
    
    @IBAction func btnDoneCLK(_ sender : UIButton){
        
        if selectedLanguage == nil{
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageSelectLanguage, btnOneTitle: CBtnOk) { (alert) in
            }
            return
        }
        if let langCode = selectedLanguage!.lang_code {
            DateFormatter.shared().locale = Locale(identifier: langCode)
        }
        //...Store selected language id in User defaults
        CUserDefaults.setValue(selectedLanguage.lang_id, forKey: UserDefaultSelectedLangID)
        CUserDefaults.setValue(selectedLanguage.lang_code, forKey: UserDefaultSelectedLangCode)
        CUserDefaults.setValue(selectedLanguage.name, forKey: UserDefaultSelectedLang)
        CUserDefaults.synchronize()
        self.loadLanguageText()
        
    }
    
    @IBAction func btnSearchCancelCLK(_ sender : UIButton){
        
        // Clear Search bar and remove No Data Found Label
        self.txtSearch.text = ""
        tblLanguage.restore()
        
        switch sender.tag {
        case 0:
            viewSearchBar.isHidden = false
            btnCancel.isHidden = false
            btnSearch.isHidden = true
            txtSearch.becomeFirstResponder()
            break
        case 1:
            txtSearch.resignFirstResponder()
            viewSearchBar.isHidden = true
            btnCancel.isHidden = true
            btnSearch.isHidden = false
            txtSearch.text = nil
            txtSearch.resignFirstResponder()
            break
            
        case 2:
            txtSearch.text = nil
            break
            
        default:
            break
            
        }
        self.fetchAllLanguagesFromLocal()
    }
}
