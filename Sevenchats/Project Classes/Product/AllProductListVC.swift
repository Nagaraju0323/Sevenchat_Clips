//
//  AllProductVC.swift
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


class AllProductListVC: UIViewController {
    
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
    /// Here you it will search the product
    var filterObj = MDLStoreAppliedFilter(){
        didSet{
            if apiTask?.state == URLSessionTask.State.running {
                apiTask?.cancel()
            }
            self.pageNumber = 1
            self.isLoadMoreCompleted = false
            self.allProduct.removeAll()
            self.allProductList(isLoader: false)
        }
    }
    /// handle API request on search
    var apiTask : URLSessionTask?
    var allProduct : [MDLProduct] = []
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
    }
    
    
    //MARK: - Memory management methods
    deinit {
        print("### deinit -> AllProductVC")
    }
}

//MARK: - SetupUI
extension AllProductListVC {
    fileprivate func setupView() {
        if allProduct.isEmpty{
            allProductList(isLoader: true)
        }
    }
}

//MARK: - IBAction / Selector
extension AllProductListVC {
    
    @IBAction func on(_ sender: UIButton) {
        
    }
}
//MARK: - API Function
extension AllProductListVC {
    
    @objc func pullToRefresh() {
        self.refreshControl.beginRefreshing()
        self.pageNumber = 1
        self.isLoadMoreCompleted = false
        self.apiTask?.cancel()
        self.allProductList(isLoader: false)
    }
}

//MARK: - UITableView Delegates & DataSource
extension AllProductListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.allProduct.isEmpty && !noProductsFound.isEmpty{
            self.tblProductList.setEmptyMessage(noProductsFound)
            return 0
        }
        self.tblProductList.restore()
        return allProduct.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProductListCell") as? ProductListCell, !allProduct.isEmpty else{
            return UITableViewCell(frame: .zero)
        }
        cell.product = allProduct[indexPath.row]
        //         Load more data....
        if (indexPath == tblProductList.lastIndexPath()) && !self.isLoadMoreCompleted {
            // self.allProductList(isLoader: false)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let productDetail : ProductDetailVC = CStoryboardProduct.instantiateViewController(withIdentifier: "ProductDetailVC") as? ProductDetailVC{
            productDetail.VcController = 1
            productDetail.productIds = self.allProduct[indexPath.row].product_id
            productDetail.productUserID = self.allProduct[indexPath.row].productUserID
            self.navigationController?.pushViewController(productDetail, animated: true)
        }
    }
}

//MARK: - API Function
extension AllProductListVC {
    
    /// Fetch data from the server
    /// - Parameter isLoader: used for display loader while getting data from server.
    func allProductList(isLoader:Bool = true) {
        
        if apiTask?.state == URLSessionTask.State.running {
            return
        }
        
        if isFromSearch && filterObj.search.count <= 2 {
            self.noProductsFound = ""
            self.refreshControl.endRefreshing()
            self.pageNumber = 1
            self.isLoadMoreCompleted = false
            self.allProduct.removeAll()
            self.tblProductList.reloadData()
            return
        }
        var para = [String : Any]()
        
        guard let userid = appDelegate.loginUser?.user_id else {
            return
        }
        let userID = String(userid)
        
        para["limit"] = "10"
        para["user_id"] = userID
        para["page"] = self.pageNumber
        
        apiTask = APIRequest.shared().getProductList(param:para ,userID:userID, showLoader: isLoader, completion:{ [weak self](response, error) in
            guard let _ = self else { return }
            self?.refreshControl.endRefreshing()
            if response != nil {
                GCDMainThread.async {
                    let arrDatass = response!["products"] as? [String : Any] ?? [:]
                    let arrData = arrDatass["products"] as? [[String : Any]] ?? []
                    
                    self?.isLoadMoreCompleted = (arrData.count == 0)
                    if self?.pageNumber == 1{
                        self?.allProduct.removeAll()
                    }
                    if arrData.count == 0{
                        self?.noProductsFound = CNoProductFound
                        self?.isLoadMoreCompleted = true
                    }else{
                        self?.pageNumber += 1
                    }
                    print(arrData)
                    for obj in arrData{
                        self?.allProduct.append(MDLProduct(fromDictionary: obj))
                    }
                    if self?.tblProductList != nil{
                        self?.tblProductList.reloadData()
                        if self?.pageNumber == 2 && !(self?.isLoadMoreCompleted ?? false){
                            let indexPath = IndexPath(row: 0,section: 0)
                            self?.tblProductList.scrollToRow(at: indexPath, at: .bottom, animated: true)
                        }
                    }
                }
            }else{
                self?.noProductsFound = CNoProductFound
                MILoader.shared.hideLoader()
                self?.tblProductList.reloadData()
            }
        })
    }
    
    func allProductListSearch(isLoader:Bool = true,SearchStr:String) {
        
        if apiTask?.state == URLSessionTask.State.running {
            return
        }
        
        if isFromSearch && filterObj.search.count <= 2 {
            self.noProductsFound = ""
            self.refreshControl.endRefreshing()
            self.pageNumber = 1
            self.isLoadMoreCompleted = false
            self.allProduct.removeAll()
            self.tblProductList.reloadData()
            return
        }
        var para = [String : Any]()
        guard let userid = appDelegate.loginUser?.user_id else {return}
        para["title"] = SearchStr
        para["user_id"] = userid.description
        
        apiTask = APIRequest.shared().getProductListSearch(param:para,showLoader: isLoader, completion:{ [weak self](response, error) in
            guard let _ = self else { return }
            self?.refreshControl.endRefreshing()
            if response != nil {
                GCDMainThread.async {
                    let arrDatass = response!["products"] as? [String : Any] ?? [:]
                    let arrData = arrDatass["products"] as? [[String : Any]] ?? []
                    
                    self?.isLoadMoreCompleted = (arrData.count == 0)
                    if self?.pageNumber == 1{
                        self?.allProduct.removeAll()
                    }
                    if arrData.count == 0{
                        self?.noProductsFound = CNoProductFound
                        self?.isLoadMoreCompleted = true
                    }else{
                        self?.pageNumber += 1
                    }
                    print(arrData)
                    for obj in arrData{
                        self?.allProduct.append(MDLProduct(fromDictionary: obj))
                    }
                    if self?.tblProductList != nil{
                        self?.tblProductList.reloadData()
                        if self?.pageNumber == 2 && !(self?.isLoadMoreCompleted ?? false){
                            let indexPath = IndexPath(row: 0,section: 0)
                            self?.tblProductList.scrollToRow(at: indexPath, at: .bottom, animated: true)
                        }
                    }
                }
            }else{
                self?.noProductsFound = CNoProductFound
                MILoader.shared.hideLoader()
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
            self.allProduct.removeAll()
            self.tblProductList.reloadData()
            return
        }
        var para = [String : Any]()
        para["limit"] = "10"
        para["page"] = self.pageNumber
        
        apiTask = APIRequest.shared().getProductListCategory(param:para ,category:category, showLoader: isLoader, completion:{ [weak self](response, error) in
            guard let _ = self else { return }
            self?.refreshControl.endRefreshing()
            if response != nil {
                GCDMainThread.async {
                    let arrDatass = response!["products"] as? [String : Any] ?? [:]
                    let arrData = arrDatass["products"] as? [[String : Any]] ?? []
                    
                    self?.isLoadMoreCompleted = (arrData.count == 0)
                    if self?.pageNumber == 1{
                        self?.allProduct.removeAll()
                    }
                    if arrData.count == 0{
                        self?.noProductsFound = CNoProductFound
                        self?.isLoadMoreCompleted = true
                    }else{
                        self?.pageNumber += 1
                    }
                    print(arrData)
                    for obj in arrData{
                        if obj.valueForString(key: "user_id") != appDelegate.loginUser?.user_id.description{
                            self?.allProduct.append(MDLProduct(fromDictionary: obj))
                            
                        }
                        // self?.allProduct.append(MDLProduct(fromDictionary: obj))
                    }
                    if self?.tblProductList != nil{
                        self?.tblProductList.reloadData()
                        if self?.pageNumber == 2 && !(self?.isLoadMoreCompleted ?? false){
                            _ = IndexPath(row: 0,section: 0)
                            // self?.tblProductList.scrollToRow(at: indexPath, at: .bottom, animated: true)
                        }
                    }
                }
            }else{
                self?.noProductsFound = CNoProductFound
                MILoader.shared.hideLoader()
                self?.tblProductList.reloadData()
            }
        })
    }
    
    
}
