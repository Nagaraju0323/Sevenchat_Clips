//
//  FilterProductVC.swift
//  Sevenchats
//
//  Created by mac-00020 on 28/08/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Nagaraju K and Chandrika R                                 *
 * Model   : RestrictedFilesVC                           *
 * Changes :                                             *
 *                                                       *
 ********************************************************/

import Foundation
import UIKit

class FilterProductVC: ParentViewController {
    
    //MARK: - IBOutlet/Object/Variable Declaration
    @IBOutlet weak var tblFilter: UITableView!{
        didSet{
            
            tblFilter.tableFooterView = UIView(frame: .zero)
            tblFilter.separatorStyle = .none
            tblFilter.register(UINib(nibName: "ProductFilterCell", bundle: nil), forCellReuseIdentifier: "ProductFilterCell")
            
            tblFilter.delegate = self
            tblFilter.dataSource = self
            
            self.refreshControl.addTarget(self, action: #selector(self.pullToRefresh), for: .valueChanged)
            self.refreshControl.tintColor = ColorAppTheme
            tblFilter.pullToRefreshControl = self.refreshControl
            tblFilter.allowsMultipleSelection = false
            tblFilter.reloadData()
        }
    }
    
    @IBOutlet weak var vwTxtSearch: UIView!{
        didSet{
            vwTxtSearch.layer.cornerRadius = 8
        }
    }
    
    @IBOutlet weak var vwSearch: UIView!
    
    @IBOutlet weak var txtSearch: UITextField!{
        didSet{
            txtSearch.placeholder = CSearch
            txtSearch.clearButtonMode = .whileEditing
            txtSearch.returnKeyType = .search
            txtSearch.delegate = self
        }
    }
    
    var refreshControl = UIRefreshControl()
    
    var arrFilter : [MDLProductCategory] = []
    var searchData : [MDLProductCategory] = []
    var selectAll = MDLProductCategory(name: CSelectAll)
    var apiTask : URLSessionTask?
    var onApplyFilter : ((String) -> Void)?
    var onApplyFilterName : ((String) -> Void)?
    var filterIDs = ""
    var indexNumber:NSInteger = -1
    
    //MARK: - View life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    //MARK: - Memory management methods
    deinit {
        print("### deinit -> FilterProductVC")
    }
}

//MARK: - SetupUI
extension FilterProductVC {
    fileprivate func setupView() {
        
        self.title = CNavProfileFilter
        self.addBarButtonItems()
        
        registerForKeyboardWillShowNotification(tblFilter)
        registerForKeyboardWillHideNotification(tblFilter)
        
        self.vwSearch.shadow(color: UIColor.lightGray.withAlphaComponent(0.3), shadowOffset: CGSize(width: 0, height: 3.0), shadowRadius: 0.0, shadowOpacity: 0.5)
        self.getProductCategory()
    }
    
    // Created Right bar button...
    fileprivate func addBarButtonItems() {
        
        let resetBarItem = BlockBarButtonItem(image: UIImage(named: "ic_reset"), style: .plain) { [weak self] (_) in
            guard let _ = self else {return}
            DispatchQueue.main.async {
                self?.arrFilter.forEach({$0.isSelected = false})
                self?.selectAll.isSelected = false
                self?.tblFilter.reloadData()
                self?.onApplyFilter?("")
                //self?.navigationController?.popViewController(animated: true)
            }
        }
        
        let applyBarItem = BlockBarButtonItem(image: UIImage(named: "ic_apply_filter"), style: .plain) { [weak self] (_) in
            guard let self = self else {return}
            var filterIDs : String = ""
            var filterName : String = ""
            
            if self.selectAll.isSelected{
                filterIDs = self.arrFilter.map({$0.categoryId.description}).joined(separator: ",")
                filterName = self.arrFilter.filter({$0.isSelected}).map({$0.categoryName.description}).joined(separator: ",")
            } else{
                filterIDs = self.arrFilter.filter({$0.isSelected}).map({$0.categoryId.description}).joined(separator: ",")
                filterName = self.arrFilter.filter({$0.isSelected}).map({$0.categoryName.description}).joined(separator: ",")
                
                
            }
            print(filterIDs)
            self.onApplyFilter?(filterIDs)
            self.onApplyFilterName?(filterName)
            self.navigationController?.popViewController(animated: true)
        }
        
        self.navigationItem.rightBarButtonItems = [applyBarItem, resetBarItem]
    }
}

//MARK: - IBAction / Selector
extension FilterProductVC {
    
    @IBAction func on(_ sender: UIButton) {
        
    }
}

//MARK: - API Function
extension FilterProductVC {
    
    @objc func pullToRefresh() {
        self.refreshControl.endRefreshing()
    }
}

//MARK: - UITextFieldDelegate
extension FilterProductVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text,
              let textRange = Range(range, in: text) else{
            return true
        }
        let updatedText = text.replacingCharacters(in: textRange,with: string)
        self.searchCategory(searchText: updatedText)
        return true
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.searchCategory(searchText: "")
        }
        return true
    }
    
    func searchCategory(searchText: String){
        if searchText.trim.isEmpty{
            self.searchData = self.arrFilter
            self.tblFilter.reloadData()
            return
        }
        self.searchData = self.arrFilter.filter({$0.categoryName.containsIgnoringCase(find: searchText)})
        self.tblFilter.reloadData()
    }
}

//MARK: - UITableView Delegates & DataSource
extension FilterProductVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchData.isEmpty{
            self.tblFilter.setEmptyMessage(CNoCategoryFound)
            return 0
        }
        self.tblFilter.restore()
        return searchData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProductFilterCell") as? ProductFilterCell else{
            return UITableViewCell(frame: .zero)
        }
        let filterObj = self.searchData[indexPath.row]
        cell.category = filterObj
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectAll.isSelected = false
        let filterObj = self.searchData[indexPath.row]
        self.arrFilter.forEach({$0.isSelected = selectAll.isSelected})
        filterObj.isSelected.toggle()
        if checkIsAllCategorySelected(){
            selectAll.isSelected.toggle()
            self.searchData.forEach({$0.isSelected = !selectAll.isSelected})
            self.tblFilter.reloadData()
            return
        }
        
        self.tblFilter.reloadData()
    }
    
    
    func checkIsAllCategorySelected() -> Bool{
        return self.arrFilter.filter({$0.isSelected}).count == self.arrFilter.count
    }
}

//MARK: - API Function
extension FilterProductVC {
    
    fileprivate func getProductCategory(searchText:String = "", isLoader : Bool = true){
        if apiTask?.state == URLSessionTask.State.running {
            apiTask?.cancel()
        }
        self.arrFilter.removeAll()
        guard let langName = appDelegate.loginUser?.lang_name else  {
            return
        }
        apiTask = APIRequest.shared().productCategoriesList(searchText: langName,showLoader: isLoader) { [weak self](response, error) in
            if response != nil {
                GCDMainThread.async {
                    let arrData = response![CData] as? [[String : Any]] ?? []
                    let arrFilter = self?.filterIDs.components(separatedBy: ",")
                    for obj in arrData{
                        let catObj = MDLProductCategory(fromDictionary: obj)
                        catObj.isSelected = arrFilter?.contains(catObj.categoryId.description) ?? false
                        self?.arrFilter.append(catObj)
                    }
                    
                    self?.searchData = self?.arrFilter ?? []
                    if self?.checkIsAllCategorySelected() ?? false{
                        self?.selectAll.isSelected.toggle()
                    }
                    self?.tblFilter.reloadData()
                }
            }
        }
    }
}
