//
//  ProfileFilterViewController.swift
//  Sevenchats
//
//  Created by mac-0005 on 29/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class ProfileFilterViewController: ParentViewController {
    
    @IBOutlet var tblFilter : UITableView!
    @IBOutlet fileprivate var btnAppyFilter : UIButton!
    
    var arrFilter = [
        [CCategoryType:CSelectAll,CCategoryId:CStaticSearchAllType],
        [CCategoryType:CTypeArticle,CCategoryId:CStaticArticleId],
        [CCategoryType:CTypeChirpy,CCategoryId:CStaticChirpyId],
        [CCategoryType:CTypeEvent,CCategoryId:CStaticEventId],
        [CCategoryType:CTypeForum,CCategoryId:CStaticForumId],
        [CCategoryType:CTypeGallery,CCategoryId:CStaticGalleryId],
        [CCategoryType:CTypePoll,CCategoryId:CStaticPollId],
        [CCategoryType:CTypeShout,CCategoryId:CStaticShoutId]
    ]
    
    var arrSelectedFilter = [[String : Any]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Initialization()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- ---------- Initialization
    func Initialization(){
        
        self.title = CNavProfileFilter
        btnAppyFilter.setTitle(CBtnApplyFilter, for: .normal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: CBtnReset, style: .plain, target: self, action: #selector(btnResetClicked(_:)))
    }
    
}

// MARK:- --------- UITableView Datasources/Delegate
extension ProfileFilterViewController : UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrFilter.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileFilterTblCell", for: indexPath) as? ProfileFilterTblCell {
            let filterInfo = arrFilter[indexPath.row]
            cell.lblFilterType.text = filterInfo.valueForString(key: CCategoryType)
            cell.btnSelect.isSelected = arrSelectedFilter.contains(where: {$0.valueForString(key: CCategoryType) == filterInfo.valueForString(key: CCategoryType)})
            return cell
        }
        return tableView.tableViewDummyCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let filterInfo = arrFilter[indexPath.row]
        
        if indexPath.row == 0{
            // selecte all
            if arrSelectedFilter.contains(where: {$0.valueForString(key: CCategoryType) == filterInfo.valueForString(key: CCategoryType)}){
                arrSelectedFilter.removeAll()
            }else{
                arrSelectedFilter = arrFilter
            }
        }else{
            
            if arrSelectedFilter.contains(where: {$0.valueForString(key: CCategoryType) == filterInfo.valueForString(key: CCategoryType)}){
                if let index = arrSelectedFilter.index(where: {$0.valueForString(key: CCategoryType) == filterInfo.valueForString(key: CCategoryType)}) {
                    arrSelectedFilter.remove(at: index)
                }
                // check for select All
                if let index = arrSelectedFilter.index(where: {$0.valueForString(key: CCategoryType) == CSelectAll}) {
                    arrSelectedFilter.remove(at: index)
                }
            }else{
                arrSelectedFilter.append(filterInfo)
            }
        }
        tblFilter.reloadData()
    }
}

// MARK:- ---------- Action Event
extension ProfileFilterViewController{
    @IBAction func btnApplyFilterCLK(_ sender : UIButton) {
        
        if arrSelectedFilter.count < 1 {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageFilterMinSelection, btnOneTitle: CBtnOk, btnOneTapped: nil)
        } else {
            // check for select All (If exist then remove before the pass data)
            if let index = arrSelectedFilter.index(where: {$0.valueForString(key: CCategoryType) == CSelectAll}) {
                arrSelectedFilter.remove(at: index)
            }
            if let blockHandler = self.block {
                blockHandler(arrSelectedFilter, "success")
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc fileprivate func btnResetClicked(_ sender : UIBarButtonItem) {
        
        arrSelectedFilter.removeAll()
        if let blockHandler = self.block {
            blockHandler(arrSelectedFilter, "refresh screen")
        }
        self.navigationController?.popViewController(animated: true)
    }
}
