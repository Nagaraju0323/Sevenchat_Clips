//
//  MyProductListVC.swift
//  Sevenchats
//
//  Created by mac-00020 on 27/08/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Chandrika.R                                 *
 * Model   : RestrictedFilesVC                           *
 * Changes :                                             *
 *                                                       *
 ********************************************************/

import Foundation
import UIKit

class MyProductListVC: UIViewController {
    
    //MARK: - IBOutlet/Object/Variable Declaration
    @IBOutlet weak var tblProductList: UITableView!{
        didSet{
            
            tblProductList.tableFooterView = UIView(frame: .zero)
            tblProductList.separatorStyle = .none
            tblProductList.register(UINib(nibName: "ProductListCell", bundle: nil), forCellReuseIdentifier: "ProductListCell")
            
            tblProductList.delegate = self
            tblProductList.dataSource = self
            
            self.refreshControl.addTarget(self, action: #selector(self.pullToRefresh), for: .valueChanged)
            self.refreshControl.tintColor = ColorAppTheme
            self.tblProductList.pullToRefreshControl = self.refreshControl
            
            tblProductList.reloadData()
        }
    }
    var refreshControl = UIRefreshControl()
    var filterObj = MDLStoreAppliedFilter(){
        didSet{
            if apiTask?.state == URLSessionTask.State.running {
                apiTask?.cancel()
            }
            self.pageNumber = 1
            self.isLoadMoreCompleted = false
            self.allMyProduct.removeAll()
            self.myProductList(isLoader: false)
        }
    }
    
    /// handle API request on search
    var apiTask : URLSessionTask?
    var allMyProduct : [MDLProduct] = []
    var pageNumber = 1
    var isLoadMoreCompleted = false
    var noProductsFound = ""
    var isFromSearch = false
    
    //MARK: - View life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "loadder"), object: nil)
        
    }
    
    //MARK: - Memory management methods
    deinit {
        print("### deinit -> MyProductListVC")
    }
    
    @objc func loadList(){
        print("thisis calling")
        self.pullToRefresh()
    }
    
    
}

//MARK: - SetupUI
extension MyProductListVC {
    fileprivate func setupView() {
        if allMyProduct.isEmpty{
            myProductList(isLoader: true)
        }
    }
}

//MARK: - IBAction / Selector
extension MyProductListVC {
    
    @IBAction func onAddProductPressed(_ sender: UIButton) {
        if let addEditProduct : AddEditProductVC = CStoryboardProduct.instantiateViewController(withIdentifier: "AddEditProductVC") as? AddEditProductVC{
            self.navigationController?.pushViewController(addEditProduct, animated: true)
        }
    }
}

//MARK: - API Function
extension MyProductListVC {
    
    @objc func pullToRefresh() {
        self.refreshControl.beginRefreshing()
        self.pageNumber = 1
        self.isLoadMoreCompleted = false
        self.apiTask?.cancel()
        myProductList(isLoader: false)
    }
}

//MARK: - UITableView Delegates & DataSource
extension MyProductListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.allMyProduct.isEmpty && !noProductsFound.isEmpty{
            self.tblProductList.setEmptyMessage(noProductsFound)
            return 0
        }
        self.tblProductList.restore()
        return allMyProduct.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProductListCell") as? ProductListCell, !allMyProduct.isEmpty else{
            return UITableViewCell(frame: .zero)
        }
        
        cell.product = allMyProduct[indexPath.row]
        // Load more data....
        if (indexPath == tblProductList.lastIndexPath()) && !self.isLoadMoreCompleted {
            self.myProductList(isLoader: false)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let productDetail : ProductDetailVC = CStoryboardProduct.instantiateViewController(withIdentifier: "ProductDetailVC") as? ProductDetailVC{
            productDetail.productIds = self.allMyProduct[indexPath.row].product_id
            productDetail.productVC = 1
            self.navigationController?.pushViewController(productDetail, animated: true)
        }
    }
}

//MARK: - API Function
extension MyProductListVC {
    
    /// Fetch data from the server
    /// - Parameter isLoader: used for display loader while getting data from server.
    func myProductList(isLoader:Bool = true) {
        
        if apiTask?.state == URLSessionTask.State.running {
            return
        }
        
        if isFromSearch && filterObj.search.count <= 2 {
            self.noProductsFound = ""
            self.refreshControl.endRefreshing()
            self.pageNumber = 1
            self.isLoadMoreCompleted = false
            self.allMyProduct.removeAll()
            self.tblProductList.reloadData()
            return
        }
        var para = [String : Any]()
        
        para[CPer_limit] = "20"
        para[CPage] = self.pageNumber.toString
        
        guard let userID = appDelegate.loginUser?.user_id else {return}
        let userIDstr = String(describing: userID)
        
        apiTask = APIRequest.shared().getmyProductList(param: para,showLoader: isLoader, userID:userIDstr, completion:{ [weak self](response, error) in
            guard let _ = self else { return }
            self?.refreshControl.endRefreshing()
            //            self?.allMyProduct.removeAll()
            if response != nil {
                GCDMainThread.async {
                    let arrDatass = response!["products"] as? [String : Any] ?? [:]
                    let arrData = arrDatass["my_product"] as? [[String : Any]] ?? []
                    if self?.pageNumber == 1{
                        self?.allMyProduct.removeAll()
                    }
                    if arrData.count == 0{
                        self?.isLoadMoreCompleted = true
                        self?.noProductsFound = (self?.isFromSearch ?? false) ? CNoProductFound : CNoProductAddedInMyProductList
                    }else{
                        self?.pageNumber += 1
                    }
                    for obj in arrData{
                        self?.allMyProduct.append(MDLProduct(fromDictionary: obj))
                    }
                    if self?.tblProductList != nil{
                        self?.tblProductList.reloadData()
                        if self?.pageNumber == 2 && !(self?.isLoadMoreCompleted ?? true){
                            let indexPath = IndexPath(row: 0,section: 0)
                            self?.tblProductList.scrollToRow(at: indexPath, at: .bottom, animated: true)
                        }
                    }
                }
            }else{
                MILoader.shared.hideLoader()
                self?.noProductsFound = (self?.isFromSearch ?? false) ? CNoProductFound : CNoProductAddedInMyProductList
                self?.tblProductList.reloadData()
            }
        })
    }
    
    func myProductListSearch(isLoader:Bool = true,SearchStr:String) {
        
        if apiTask?.state == URLSessionTask.State.running {
            return
        }
        
        if isFromSearch && filterObj.search.count <= 2 {
            self.noProductsFound = ""
            self.refreshControl.endRefreshing()
            self.pageNumber = 1
            self.isLoadMoreCompleted = false
            self.allMyProduct.removeAll()
            self.tblProductList.reloadData()
            return
        }
        var para = [String : Any]()
        
        guard let userid = appDelegate.loginUser?.user_id else {return}
        para["title"] = SearchStr
        para["user_id"] = userid.description
        apiTask = APIRequest.shared().getmyProductListSearch(param: para,showLoader: isLoader, completion:{ [weak self](response, error) in
            guard let _ = self else { return }
            self?.refreshControl.endRefreshing()
            if response != nil {
                GCDMainThread.async {
                    let arrDatass = response!["products"] as? [String : Any] ?? [:]
                    let arrData = arrDatass["my_product"] as? [[String : Any]] ?? []
                    if self?.pageNumber == 1{
                        self?.allMyProduct.removeAll()
                    }
                    if arrData.count == 0{
                        self?.isLoadMoreCompleted = true
                        self?.noProductsFound = (self?.isFromSearch ?? false) ? CNoProductFound : CNoProductAddedInMyProductList
                    }else{
                        self?.pageNumber += 1
                    }
                    for obj in arrData{
                        self?.allMyProduct.append(MDLProduct(fromDictionary: obj))
                    }
                    if self?.tblProductList != nil{
                        self?.tblProductList.reloadData()
                        if self?.pageNumber == 2 && !(self?.isLoadMoreCompleted ?? true){
                            let indexPath = IndexPath(row: 0,section: 0)
                            self?.tblProductList.scrollToRow(at: indexPath, at: .bottom, animated: true)
                        }
                    }
                }
            }else{
                MILoader.shared.hideLoader()
                self?.noProductsFound = (self?.isFromSearch ?? false) ? CNoProductFound : CNoProductAddedInMyProductList
                self?.tblProductList.reloadData()
            }
        })
    }
    func allProductListFilter(isLoader:Bool = true,category:String) {
        
        if apiTask?.state == URLSessionTask.State.running {
            return
        }
        
        if isFromSearch && filterObj.search.count <= 2 {
            self.noProductsFound = ""
            self.refreshControl.endRefreshing()
            self.pageNumber = 1
            self.isLoadMoreCompleted = false
            self.allMyProduct.removeAll()
            self.tblProductList.reloadData()
            return
        }
        var para = [String : Any]()
        
        para[CPer_limit] = "20"
        para[CPage] = self.pageNumber.toString
        
        apiTask = APIRequest.shared().getProductListCategory(param:para ,category:category, showLoader: isLoader, completion:{ [weak self](response, error) in
            guard let _ = self else { return }
            self?.refreshControl.endRefreshing()
            if response != nil {
                GCDMainThread.async {
                    let arrDatass = response!["products"] as? [String : Any] ?? [:]
                    let arrData = arrDatass["products"] as? [[String : Any]] ?? []
                    if self?.pageNumber == 1{
                        self?.allMyProduct.removeAll()
                    }
                    if arrData.count == 0{
                        self?.isLoadMoreCompleted = true
                        self?.noProductsFound = (self?.isFromSearch ?? false) ? CNoProductFound : CNoProductAddedInMyProductList
                    }else{
                        self?.pageNumber += 1
                    }
                    for obj in arrData{
                        if obj.valueForString(key: "user_id") == appDelegate.loginUser?.user_id.description{
                            self?.allMyProduct.append(MDLProduct(fromDictionary: obj))
                        }
                    }
                    if self?.tblProductList != nil{
                        self?.tblProductList.reloadData()
                        if self?.pageNumber == 2 && !(self?.isLoadMoreCompleted ?? true){
                            _ = IndexPath(row: 0,section: 0)
                            // self?.tblProductList.scrollToRow(at: indexPath, at: .bottom, animated: true)
                        }
                    }
                }
            }else{
                MILoader.shared.hideLoader()
                self?.noProductsFound = (self?.isFromSearch ?? false) ? CNoProductFound : CNoProductAddedInMyProductList
                self?.tblProductList.reloadData()
            }
        })
    }
    
    
}
