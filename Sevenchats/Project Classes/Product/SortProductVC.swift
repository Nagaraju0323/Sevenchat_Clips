//
//  SortProductVC.swift
//  Sevenchats
//
//  Created by mac-00020 on 29/08/19.
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

enum ProductSort : Int, CaseIterable {
    case OldToNew = 0
    case NewToOld
    case AtoZ
    
}

class SortProductVC: ParentViewController {
    
    //MARK: - IBOutlet/Object/Variable Declaration
    @IBOutlet weak var tblSort: UITableView!{
        didSet{
            
            tblSort.tableFooterView = UIView(frame: .zero)
            tblSort.separatorStyle = .none
            tblSort.register(UINib(nibName: "ProductFilterCell", bundle: nil), forCellReuseIdentifier: "ProductFilterCell")
            
            tblSort.delegate = self
            tblSort.dataSource = self
        }
    }
    var selectedSortType = ProductSort.NewToOld
    var onAppliedSort : ((ProductSort) -> Void)?
    var onFolderSort : ((ProductSort) -> Void)?
    var arrSort : [MDLProductCategory] = []
    
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
        print("### deinit -> SortProductVC")
    }
}

//MARK: - SetupUI
extension SortProductVC {
    fileprivate func setupView() {
        
        self.title = CSortBy
        self.addBarButtonItems()
        for type in ProductSort.allCases{
            switch type {
            case .OldToNew:
                let oldToNew =  MDLProductCategory(name: COldToNew)
                oldToNew.categoryId = "0"
                arrSort.append(oldToNew)
                break
            case .NewToOld:
                let newToOld =  MDLProductCategory(name: CNewToOld)
                newToOld.categoryId = "1"
                arrSort.append(newToOld)
                break
            case .AtoZ:
                break
            }
        }
        if let selected = self.arrSort.filter({$0.categoryId.toInt == selectedSortType.rawValue}).first{
            selected.isSelected = true
        }
        DispatchQueue.main.async {
            self.tblSort.reloadData()
        }
    }
    
    // Created Right bar button...
    fileprivate func addBarButtonItems() {
        
        let applyBarItem = BlockBarButtonItem(image: UIImage(named: "ic_apply_filter"), style: .plain) { [weak self] (_) in
            guard let _ = self else {return}
            self?.onAppliedSort?(self?.selectedSortType ?? .NewToOld)
            self?.onFolderSort?(self?.selectedSortType ?? .NewToOld)
            self?.navigationController?.popViewController(animated: true)
        }
        
        self.navigationItem.rightBarButtonItem = applyBarItem
    }
}

//MARK: - API Function
extension SortProductVC {
    
    @objc func pullToRefresh() {
    }
}

//MARK: - UITextFieldDelegate
extension SortProductVC: UITextFieldDelegate {
    
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
        print(updatedText)
        return true
    }
}

//MARK: - UITableView Delegates & DataSource
extension SortProductVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSort.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProductFilterCell") as? ProductFilterCell else{
            return UITableViewCell(frame: .zero)
        }
        let filterObj = self.arrSort[indexPath.row]
        cell.category = filterObj
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let filterObj = self.arrSort[indexPath.row]
        self.arrSort.forEach({$0.isSelected = false})
        filterObj.isSelected = true
        self.selectedSortType = ProductSort(rawValue: filterObj.categoryId.toInt ?? 0) ?? .NewToOld
        self.tblSort.reloadData()
    }
}
