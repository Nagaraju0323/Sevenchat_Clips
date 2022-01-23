//
//  StoreListVC.swift
//  Sevenchats
//
//  Created by mac-00020 on 27/08/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//


/*********************************************************
 * Author  : Chandrika.R                                 *
 * Model   : StoreListVC                                 *
 * Changes :                                             *

 ********************************************************/


import Foundation
import UIKit

/// This is a main controller of product module is containt all product list and my product list.
class StoreListVC: ParentViewController {
    
    //MARK: - IBOutlet/Object/Variable Declaration
    @IBOutlet weak var vwSegment: UIView!
    
    /// Custome Segemtn for All Product and My Product
    weak var sementView: SegmentView!
    
    /// it's contain AllProductListVC and MyProductListVC
    weak var pageVC : PageViewController?
    weak var allProductVC :  AllProductListVC?
    weak var myProductVC :  MyProductListVC?
    
    var filterObj = MDLStoreAppliedFilter()
    
    //MARK: - View life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    /// PageViewController controller embed with this controller
    /// - Parameters:
    ///   - segue: segue type and identifier
    ///   - sender: sender object
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let pageController = segue.destination as? PageViewController {
            self.pageVC = pageController
        }
    }
    
    //MARK: - Memory management methods
    deinit {
        print("### deinit -> StoreListVC")
    }
}

//MARK: - SetupUI
extension StoreListVC {
    fileprivate func setupView() {
        
        self.title = CStores
        self.addBarButtonItems()
        
        /// Confiure PageViewController
        self.pageVC?.mDelegate = self
        allProductVC = CStoryboardProduct.instantiateViewController(withIdentifier: "AllProductListVC") as? AllProductListVC
        myProductVC = CStoryboardProduct.instantiateViewController(withIdentifier: "MyProductListVC") as? MyProductListVC
        
        let arrPage : [UIViewController] = [allProductVC!,myProductVC!]
        self.pageVC?.config(controllers: arrPage)
        
        if sementView != nil {
            sementView.removeFromSuperview()
        }
        
        /// Confiure custome segment controller
        sementView = SegmentView.viewFromXib as? SegmentView
        sementView.delegate = self
        sementView.translatesAutoresizingMaskIntoConstraints = false
        vwSegment.addSubview(sementView)
        
        NSLayoutConstraint.activate([
            sementView.leftAnchor.constraint(equalTo: vwSegment.leftAnchor, constant: 0),
            sementView.rightAnchor.constraint(equalTo: vwSegment.rightAnchor, constant: 0),
            sementView.topAnchor.constraint(equalTo: vwSegment.topAnchor, constant: 0),
            sementView.bottomAnchor.constraint(equalTo: vwSegment.bottomAnchor, constant: 0)
            ])
        
        let allProduct : SegmentText = SegmentText.viewFromXib as! SegmentText
        allProduct.lblText.text = CAllProducts
        
        let myProduct : SegmentText = SegmentText.viewFromXib as! SegmentText
        myProduct.lblText.text = CMyProducts
        
        sementView.addSubItems(arrViews: [allProduct,myProduct])
        sementView.selectedSegmentIndex = 0
    }
    
    // Created Right bar button...
    fileprivate func addBarButtonItems() {
        
        let menuBarItem = UIBarButtonItem(customView: self.createHomeBurgerButton())
        
        ///... For Searching
        let searchBarItem = BlockBarButtonItem(image: UIImage(named: "ic_btn_search"), style: .plain) { [weak self] (_) in
            guard let _ = self else {return}
            
            if let searchProduct : ProductSearchVC = CStoryboardProduct.instantiateViewController(withIdentifier: "ProductSearchVC") as? ProductSearchVC{
                searchProduct.filterObj = MDLStoreAppliedFilter(search: "", category: self?.filterObj.category ?? "", status: 0, sort: self?.filterObj.sort ?? .NewToOld)
                self?.navigationController?.pushViewController(searchProduct, animated: false)
            }
        }
        self.navigationItem.leftBarButtonItems = [menuBarItem,searchBarItem]
        
        ///... For Filter
        let filterBarItem = BlockBarButtonItem(image: UIImage(named: "ic_home_btn_filter"), style: .plain) { [weak self] (_) in
            guard let _ = self else {return}
            DispatchQueue.main.async {
                if let searchProduct : FilterProductVC = CStoryboardProduct.instantiateViewController(withIdentifier: "FilterProductVC") as? FilterProductVC{
                    searchProduct.filterIDs = self?.filterObj.category ?? ""
                    searchProduct.onApplyFilterName = { [weak self] (filterName) in
                        guard let _ = self else {return}
                        if self?.filterObj.categoryName != filterName{
                            self?.filterObj.categoryName = filterName
                            self?.appliedFilterAndSearch()
                        }
                    }
                    self?.navigationController?.pushViewController(searchProduct, animated: true)
                }
            }
        }
        
        ///... For Sorting
        let sortBarItem = BlockBarButtonItem(image: UIImage(named: "ic_sort"), style: .plain) { [weak self] (_) in
            guard let _ = self else {return}
            DispatchQueue.main.async {
                if let sortProduct : SortProductVC = CStoryboardProduct.instantiateViewController(withIdentifier: "SortProductVC") as? SortProductVC{
                    sortProduct.selectedSortType = self?.filterObj.sort ?? .NewToOld
                    sortProduct.onAppliedSort = { [weak self] (selectedSort) in
                        guard let _ = self else {return}
                        if self?.filterObj.sort != selectedSort{
                            self?.filterObj.sort = selectedSort
                            self?.appliedFilterAndSearch()
                        }
                    }
                    self?.navigationController?.pushViewController(sortProduct, animated: true)
                }
            }
        }
        self.navigationItem.rightBarButtonItems = [sortBarItem, filterBarItem]
    }
}

//MARK: - IBAction / Selector
extension StoreListVC {
    
    @IBAction func onAddProductPressed(_ sender: UIButton) {
        if let addEditProduct : AddEditProductVC = CStoryboardProduct.instantiateViewController(withIdentifier: "AddEditProductVC") as? AddEditProductVC{
            self.navigationController?.pushViewController(addEditProduct, animated: true)
        }
    }
}

// MARK: - PageViewControllerDelegate
extension StoreListVC : PageViewControllerDelegate {
    
    func changedController(index: Int) {
        sementView.selectedSegmentIndex = index
        appliedFilterAndSearch()
    }
    
    /// Display list of products with user selected filters and search option.
    func appliedFilterAndSearch(){
        
        if self.pageVC?.currentIndex == 0{ /// for All Products
            
            var isChangeFiler = false /// Used for check, Is there any property update
            
            /// For update text in search textfield
            if self.allProductVC?.filterObj.search != self.filterObj.search{
                self.allProductVC?.filterObj.search = self.filterObj.search
                isChangeFiler = true
            }
            
            if self.allProductVC?.filterObj.categoryName != self.filterObj.categoryName{
                self.allProductVC?.filterObj.categoryName = self.filterObj.categoryName
                isChangeFiler = true
            }
            
            
            /// Change the state : All, Active, Solde
            if self.allProductVC?.filterObj.status != self.filterObj.status{
                self.allProductVC?.filterObj.status = self.filterObj.status
                isChangeFiler = true
            }
            
            /// Change the sort option : Old to New, New to Old
            if self.allProductVC?.filterObj.sort != self.filterObj.sort{
                self.allProductVC?.filterObj.sort = self.filterObj.sort
                isChangeFiler = true
            }
            
            /// Referesh the content data any propery changed.
            if isChangeFiler{
                self.allProductVC?.isLoadMoreCompleted = false
                self.allProductVC?.pageNumber = 1
                self.allProductVC?.apiTask?.cancel()
//                self.allProductVC?.allProductList(isLoader: true)
                self.allProductVC?.allProductListFilter(isLoader: true, category:self.filterObj.categoryName)
            }
            
        }else { /// for My Product
            
            var isChangeFiler = false /// Used for check, Is there any property update
            
            /// For update text in search textfield
            if self.myProductVC?.filterObj.search != self.filterObj.search{
                self.myProductVC?.filterObj.search = self.filterObj.search
                isChangeFiler = true
            }
            
            /// If update categpry in filter list
//            if self.myProductVC?.filterObj.category != self.filterObj.category{
//                self.myProductVC?.filterObj.category = self.filterObj.category
//                isChangeFiler = true
//            }
            
            if self.myProductVC?.filterObj.categoryName != self.filterObj.categoryName{
                self.myProductVC?.filterObj.categoryName = self.filterObj.categoryName
                isChangeFiler = true
            }
            
            /// If update categpry in filter list
            if self.myProductVC?.filterObj.status != self.filterObj.status{
                self.myProductVC?.filterObj.status = self.filterObj.status
                isChangeFiler = true
            }
            
            /// Change the sort option : Old to New, New to Old
            if self.myProductVC?.filterObj.sort != self.filterObj.sort{
                self.myProductVC?.filterObj.sort = self.filterObj.sort
                isChangeFiler = true
            }
            
            /// Referesh the content data any propery changed.
            if isChangeFiler{
                self.myProductVC?.isLoadMoreCompleted = false
                self.myProductVC?.pageNumber = 1
                self.myProductVC?.allProductListFilter(isLoader: true, category:self.filterObj.categoryName)
            }else {
                self.myProductVC?.isLoadMoreCompleted = false
                self.myProductVC?.pageNumber = 1
                self.myProductVC?.allProductListFilter(isLoader: true, category:self.filterObj.categoryName)
            }
        }
    }
}

// MARK: - ScrollableSegmentDelegate
extension StoreListVC : SegmentViewDelegate {
    
    
    func didSelectSegmentAt(index: Int) {
        /// Do not change the segment If current index is same.
        if index != self.pageVC?.currentIndex {
            self.pageVC?.setViewControllerAt(index: index)
            /// Fetch product list from the server  
            appliedFilterAndSearch()
        }
    }
}

