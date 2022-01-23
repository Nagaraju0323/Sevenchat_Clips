//
//  PostFiltersViewController.swift
//  Sevenchats
//
//  Created by mac-0005 on 16/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Chandrika.R                                 *
 * Model   : PostFiltersViewController                   *
 * Changes :                                             *
 ********************************************************/

import UIKit
let CFilterMainCat = "mainCat"
let CFilterSubCat = "subCat"
let CShoutHeaderIndex = 7
let CGalleryHeaderIndex = 5
let CSelectAllHeaderIndex = 0

class PostFiltersViewController: ParentViewController {

    @IBOutlet fileprivate var tblFilter : UITableView! {
        didSet {
            tblFilter.estimatedRowHeight = 10;
            tblFilter.rowHeight = UITableView.automaticDimension;
        }
    }
    
    var arrFilter = [[String : Any]]()
    var arrSelectedSection = [Int]()
    var arrSelectedCategory = [[String : Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Initialization()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func Initialization(){
        self.title = CNavFilters
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: #imageLiteral(resourceName: "ic_apply_filter"), style: .plain, target: self, action: #selector(btnApplyClicked(_:))),UIBarButtonItem(image: #imageLiteral(resourceName: "ic_reset"), style: .plain, target: self, action: #selector(btnResetClicked(_:)))]

        if let index = self.arrSelectedCategory.index(where: {$0[CType] as? Int == CStaticShoutId}) {
            self.arrSelectedSection.append(CShoutHeaderIndex)
            self.arrSelectedCategory.remove(at: index)
        }

        
        // Get Interest list....
        let arrInterest = MIGeneralsAPI.shared().fetchCategoryFromLocal()
        
        // Prepare Article List
        var arrArticleCat = [[String : Any]]()
        for catInfo in arrInterest{
            var catInfoTemp = catInfo
            catInfoTemp[CType] = CStaticArticleId
            arrArticleCat.append(catInfoTemp)
        }
        
        // Prepare Chirpy List
        var arrChirpyCat = [[String : Any]]()
        for catInfo in arrInterest{
            var catInfoTemp = catInfo
            catInfoTemp[CType] = CStaticChirpyId
            arrChirpyCat.append(catInfoTemp)
        }
        
        // Prepare Event List
        var arrEventCat = [[String : Any]]()
        for catInfo in arrInterest{
            var catInfoTemp = catInfo
            catInfoTemp[CType] = CStaticEventId
            arrEventCat.append(catInfoTemp)
        }
        
        // Prepare Forum List
        var arrForumCat = [[String : Any]]()
        for catInfo in arrInterest{
            var catInfoTemp = catInfo
            catInfoTemp[CType] = CStaticForumId
            arrForumCat.append(catInfoTemp)
        }
        
        // Prepare Shout List
        var arrShoutCat = [[String : Any]]()
        for catInfo in arrInterest{
            var catInfoTemp = catInfo
            catInfoTemp[CType] = CStaticShoutId
            arrShoutCat.append(catInfoTemp)
        }
        
        // Prepare Gallery List
        var arrGalleryCat = [[String : Any]]()
        for catInfo in arrInterest{
            var catInfoTemp = catInfo
            catInfoTemp[CType] = CStaticGalleryId
            arrGalleryCat.append(catInfoTemp)
        }
        
        // Prepare Poll List
        var arrPollCat = [[String : Any]]()
        for catInfo in arrInterest{
            var catInfoTemp = catInfo
            catInfoTemp[CType] = CStaticPollId
            arrPollCat.append(catInfoTemp)
        }

        arrFilter = [
            [CFilterMainCat : CSelectAll, CFilterSubCat : []],
            [CFilterMainCat : CTypeArticle, CFilterSubCat : arrArticleCat],
            [CFilterMainCat : CTypeChirpy, CFilterSubCat : arrChirpyCat],
            [CFilterMainCat : CTypeEvent, CFilterSubCat : arrEventCat],
            [CFilterMainCat : CTypeForum, CFilterSubCat : arrForumCat],
            [CFilterMainCat : CTypeGallery, CFilterSubCat : arrGalleryCat],
            [CFilterMainCat : CTypePoll, CFilterSubCat : arrPollCat],
            [CFilterMainCat : CTypeShout, CFilterSubCat : []]
        ]

        tblFilter.reloadData()
    }
}

// MARK:- --------- UITableView Datasources/Delegate
extension PostFiltersViewController : UITableViewDataSource, UITableViewDelegate,FilterDelegate {
    func didSelectFilterCategory(_ category: Any?, isSelected: Bool?, section : Int?) {
        
        if let catInfo = category as? [String : Any] {
            if isSelected! {
                arrSelectedCategory.append(catInfo)
            }else {
                if arrSelectedCategory.contains(where: {$0.valueForInt(key: CId) == catInfo.valueForInt(key: CId) && $0.valueForString(key: CType) == catInfo.valueForString(key: CType)}) {
                    if let index = arrSelectedCategory.index(where: {$0.valueForInt(key: CId) == catInfo.valueForInt(key: CId) && $0.valueForString(key: CType) == catInfo.valueForString(key: CType)}) {
                        arrSelectedCategory.remove(at: index)
                    }
                }
            }
        }
        
        
        UIView.performWithoutAnimation {
            self.tblFilter.reloadData()
        }
    }
        
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrFilter.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if arrSelectedSection.contains(indexPath.section) && (indexPath.section != CShoutHeaderIndex){
            return UITableView.automaticDimension
        }else{
            return 1.1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if arrSelectedSection.contains(indexPath.section) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "FilterSubCatTblCell", for: indexPath) as? FilterSubCatTblCell {
                let dicData = arrFilter[indexPath.section]
                let arrSubCat = dicData[CFilterSubCat]
                
                if (indexPath.section == CShoutHeaderIndex){
                    cell.showSubCategory([], arrSelectedCategory)
                    cell.delegate = self
                }else{
                    cell.showSubCategory((arrSubCat as! [[String : Any]]), arrSelectedCategory)
                    cell.delegate = self
                }
                
                return cell
            }
        }else{
            if let cell = tableView.dequeueReusableCell(withIdentifier: "LineSeparatorTblCell", for: indexPath) as? LineSeparatorTblCell {
                return cell
            }
        }
        
        return tableView.tableViewDummyCell()
    }
    
     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        return 50
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        
        let dicData = arrFilter[section]
        var arrSubCat = [[String : Any]]()
        arrSubCat = dicData[CFilterSubCat] as! [[String : Any]]
        
        // // Checking for Select All Button for all other section ...
        var allSubCategorySelected : Bool = false
        for catInfo in arrSubCat{
            if arrSelectedCategory.contains(where: {$0.valueForInt(key: CId) == catInfo.valueForInt(key: CId) && $0.valueForString(key: CType) == catInfo.valueForString(key: CType)}){
              allSubCategorySelected = true
            }else{
              allSubCategorySelected = false
                break
            }
        }
        
        // Checking for Select All Button for section 1...
        var allMainCategorySelected : Bool = false
        var loopChecking : Int = 0
        for filterInfo in arrFilter{
            if loopChecking == 1{
                break
            }
            
            var arrSubCat = [[String : Any]]()
            arrSubCat = filterInfo[CFilterSubCat] as! [[String : Any]]
            for catInfo in arrSubCat{
                if arrSelectedCategory.contains(where: {$0.valueForInt(key: CId) == catInfo.valueForInt(key: CId) && $0.valueForString(key: CType) == catInfo.valueForString(key: CType)}){
                    allMainCategorySelected = true
                }else{
                    allMainCategorySelected = false
                    loopChecking = 1
                    break
                }
            }
        }
        
        // Checking here that Gallery/Shout is selected or not for All seletion...
        if !self.arrSelectedSection.contains(CShoutHeaderIndex){
            allMainCategorySelected = false
        }
        
        
        let headerView : PostFilterHeaderView = PostFilterHeaderView.viewFromXib as! PostFilterHeaderView
        headerView.lblMainFilterType.text = dicData.valueForString(key: CFilterMainCat)
        
        if section == CSelectAllHeaderIndex || section == CShoutHeaderIndex {
            headerView.imgDownArrow.isHidden = true
            
            if section == CSelectAllHeaderIndex // For select all
            {
                headerView.btnSelectAll.isSelected = allMainCategorySelected
            }else{
                // For Gallery/shout selection...
                headerView.btnSelectAll.isSelected = self.arrSelectedSection.contains(section)
            }
        }else{
            headerView.imgDownArrow.isHidden = false
            headerView.btnSelectAll.isSelected = allSubCategorySelected
        }
        
        // select all Category click event...
        headerView.btnSelectAll.touchUpInside { [weak self] (sender) in
            guard let self = self else { return }
            headerView.btnSelectAll.isSelected = !headerView.btnSelectAll.isSelected

            if section == 0{
                if headerView.btnSelectAll.isSelected{
                    self.arrSelectedCategory.removeAll()
                    // Add all Data..
                    for filterInfo in self.arrFilter{
                        var arrSubCat = [[String : Any]]()
                        arrSubCat = filterInfo[CFilterSubCat] as! [[String : Any]]
                        self.arrSelectedCategory = self.arrSelectedCategory + arrSubCat
                    }

                    // Store Shout Selection
                    if !self.arrSelectedSection.contains(CShoutHeaderIndex){
                        self.arrSelectedSection.append(CShoutHeaderIndex)
                    }
                    
                }else{
                    // Remove all data....
                    self.arrSelectedCategory.removeAll()
                    
                    // Remove Shout Selection
                    if let index = self.arrSelectedSection.index(where: {$0 == CShoutHeaderIndex}) {
                        self.arrSelectedSection.remove(at: index)
                    }
                    
                }
            }else if section == CShoutHeaderIndex{
                // For Gallery/shout selection...
                if self.arrSelectedSection.contains(section){
                    if let index = self.arrSelectedSection.index(where: {$0 == section}) {
                        self.arrSelectedSection.remove(at: index)
                    }
                }else{
                    self.arrSelectedSection.append(section)
                }
            }
            else{
                var arrSubCat = [[String : Any]]()
                arrSubCat = dicData[CFilterSubCat] as! [[String : Any]]
                if headerView.btnSelectAll.isSelected{
                    
                    // Add all Data for paticular section...
                    for catInfo in arrSubCat{
                        if !self.arrSelectedCategory.contains(where: {$0.valueForInt(key: CId) == catInfo.valueForInt(key: CId) && $0.valueForString(key: CType) == catInfo.valueForString(key: CType)}){
                            self.arrSelectedCategory.append(catInfo)
                        }
                    }
                }else{
                    // Remove all data for particular section...
                    var arrSubCat = [[String : Any]]()
                    arrSubCat = dicData[CFilterSubCat] as! [[String : Any]]
                    for catInfo in arrSubCat{
                        if self.arrSelectedCategory.contains(where: {$0.valueForInt(key: CId) == catInfo.valueForInt(key: CId) && $0.valueForString(key: CType) == catInfo.valueForString(key: CType)}){
                            if let index = self.arrSelectedCategory.index(where: {$0.valueForInt(key: CId) == catInfo.valueForInt(key: CId) && $0.valueForString(key: CType) == catInfo.valueForString(key: CType)}) {
                                self.arrSelectedCategory.remove(at: index)
                            }
                        }
                    }
                }
            }
            
            UIView.performWithoutAnimation {
                self.tblFilter.reloadData()
            }
        }
        
        // Expand cell click event...
        headerView.btnExpand.touchUpInside { [weak self] (sender) in
            guard let self = self else { return }
            // For Select ALL/ Shout
            if section == CSelectAllHeaderIndex{
                return
            }
            
            if self.arrSelectedSection.contains(section){
                if let index = self.arrSelectedSection.index(where: {$0 == section}) {
                    self.arrSelectedSection.remove(at: index)
                }
            }else{
                self.arrSelectedSection.append(section)
            }
            
            self.tblFilter.reloadSections(IndexSet(integer: section), with: .automatic)
            
        }
        return headerView
    }
}


// MARK:- --------- Action Event
extension PostFiltersViewController{
    @objc fileprivate func btnResetClicked(_ sender : UIBarButtonItem) {
        arrSelectedCategory.removeAll()
        // Remove Shout Selection
        if let index = self.arrSelectedSection.index(where: {$0 == CShoutHeaderIndex}) {
            self.arrSelectedSection.remove(at: index)
        }
        tblFilter.reloadData()
        
        // Refresh home screen data...
        if let arrViewControllers = self.navigationController?.viewControllers {
            for viewController in arrViewControllers {
                if viewController.isKind(of: HomeViewController.classForCoder()) {
                    if let homeVC = viewController as? HomeViewController {
                        
                        homeVC.arrSelectedFilterOption.removeAll()
                        if homeVC.apiTask?.state == URLSessionTask.State.running {
                            homeVC.apiTask?.cancel()
                        }
                        
                        homeVC.pageNumber = 1
                        homeVC.getPostListFromServer(showLoader: false)
                        homeVC.tblEvents.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                    }
                }
            }
        }
        
//        if let blockHandler = self.block {
//            blockHandler(arrSelectedCategory, "refresh screen")
//        }
//        self.navigationController?.popViewController(animated: true)
    }
    
    @objc fileprivate func btnApplyClicked(_ sender : UIBarButtonItem) {
        
        // Store Shout Selection
        if self.arrSelectedSection.contains(CShoutHeaderIndex){
            var shoutInfo = [String : Any]()
            shoutInfo[CType] = CStaticShoutId
            arrSelectedCategory.append(shoutInfo)
        }

        
        if arrSelectedCategory.count < 1{
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageFilterMinSelection, btnOneTitle: CBtnOk, btnOneTapped: nil)
        }else{
            
            if let blockHandler = self.block {
                blockHandler(self.arrSelectedCategory, "refresh screen")
            }
            self.navigationController?.popViewController(animated: true)
        }
        
    }
}
