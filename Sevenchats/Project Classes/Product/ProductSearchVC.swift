//
//  ProductSearchVC.swift
//  Sevenchats
//
//  Created by mac-00020 on 27/08/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//

import Foundation
import UIKit

class ProductSearchVC: ParentViewController {
    
    //MARK: - IBOutlet/Object/Variable Declaration
    @IBOutlet weak var vwSegment: UIView!
    @IBOutlet weak var cnNavigationHeight : NSLayoutConstraint!
    @IBOutlet weak var viewSearch : UIView!
    @IBOutlet weak var txtSearch : UITextField!{
        didSet{
            txtSearch.placeholder = CSearchSellerPlaceholder
            txtSearch.clearButtonMode = .whileEditing
            txtSearch.returnKeyType = .search
            txtSearch.delegate = self
        }
    }
    
    @IBOutlet weak var txtSearchDropdown : MIGenericTextFiled!
    
    /// Custome Segemtn for All Product and My Product
    weak var sementView: SegmentView!
    
    /// it's contain AllProductListVC and MyProductListVC
    weak var pageVC : PageViewController?
    weak var allProductVC :  AllProductListVC?
    weak var myProductVC :  MyProductListVC?
    var allMyProduct : [MDLProduct] = []
    var allProduct : [MDLProduct] = []
    var searchStatus : Int = 0{
        didSet{
            if self.filterObj.status != searchStatus{
                self.filterObj.status = searchStatus
                self.appliedFilterAndSearch()
            }
            //allProductVC?.searchStatus = searchStatus
            //myProductVC?.searchStatus = searchStatus
        }
    }
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
        print("### deinit -> ProductSearchVC")
    }
}

//MARK: - SetupUI
extension ProductSearchVC {
    
    fileprivate func setupView() {
        
        //registerForKeyboardWillShowNotification(tblse)
        //registerForKeyboardWillHideNotification(txtSearch)
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let navBarHeight = self.navigationController?.navigationBar.bounds.height
        self.cnNavigationHeight.constant = statusBarHeight + (navBarHeight ?? 44)
        
        self.viewSearch.layer.cornerRadius = self.viewSearch.bounds.height / 2
        self.viewSearch.clipsToBounds = true
        
        /// Confiure PageViewController
        self.pageVC?.mDelegate = self
        if allProductVC == nil{
            allProductVC = CStoryboardProduct.instantiateViewController(withIdentifier: "AllProductListVC") as? AllProductListVC
        }
        if myProductVC == nil{
            myProductVC = CStoryboardProduct.instantiateViewController(withIdentifier: "MyProductListVC") as? MyProductListVC
        }
        
        allProductVC?.isFromSearch = true
        myProductVC?.isFromSearch = true
        
        allProductVC?.allProduct = self.allProduct
        myProductVC?.allMyProduct = self.allMyProduct
        
        allProductVC?.filterObj.category = self.filterObj.category
        allProductVC?.filterObj.sort = self.filterObj.sort
        
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
        
        let arrOption = [CTypeAll,CAvailable,CSold] //(0=>all,1=>available,2=>sold)
        txtSearchDropdown.setPickerData(arrPickerData: arrOption, selectedPickerDataHandler: { [weak self](string, row, index) in
            guard let _ = self else {return}
            if self?.searchStatus != row{
                self?.searchStatus = row
            }
            }, defaultPlaceholder: "")
        
        txtSearchDropdown.text = CTypeAll
    }
}

//MARK: - IBAction / Selector
extension ProductSearchVC {
    
    @IBAction func onBackPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
}

//MARK: - UITextFieldDelegate
extension ProductSearchVC: UITextFieldDelegate {
    
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
        searchTextProductList(updatedText)
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        searchTextProductList("")
        return true
    }
    
    func searchTextProductList(_ searchText:String){
       
        if self.filterObj.search != searchText{
            self.filterObj.search = searchText
            self.appliedFilterAndSearch()
        }
    }
}

// MARK: - PageViewControllerDelegate
extension ProductSearchVC : PageViewControllerDelegate {
    
    func changedController(index: Int) {
        sementView.selectedSegmentIndex = index
        appliedFilterAndSearch()
    }
    
    func appliedFilterAndSearch(){
        
        if self.pageVC?.currentIndex == 0{
            //self.allProductVC?.filterObj = self.filterObj
            var isChangeFiler = false
            if self.allProductVC?.filterObj.search != self.filterObj.search{
                self.allProductVC?.filterObj.search = self.filterObj.search
                isChangeFiler = true
            }
            if self.allProductVC?.filterObj.status != self.filterObj.status{
                self.allProductVC?.filterObj.status = self.filterObj.status
                isChangeFiler = true
            }
            if isChangeFiler{
                self.allProductVC?.isLoadMoreCompleted = false
                self.allProductVC?.pageNumber = 1
                self.allProductVC?.apiTask?.cancel()
                self.allProductVC?.allProductList(isLoader: true)
            }
            
        }else {
            var isChangeFiler = false
            if self.myProductVC?.filterObj.search != self.filterObj.search{
                self.myProductVC?.filterObj.search = self.filterObj.search
                isChangeFiler = true
            }
            if self.myProductVC?.filterObj.status != self.filterObj.status{
                self.myProductVC?.filterObj.status = self.filterObj.status
                isChangeFiler = true
            }
            if isChangeFiler{
                self.myProductVC?.isLoadMoreCompleted = false
                self.myProductVC?.pageNumber = 1
                self.myProductVC?.apiTask?.cancel()
                self.myProductVC?.myProductList(isLoader: true)
            }
        }
    }
}

// MARK: - ScrollableSegmentDelegate
extension ProductSearchVC : SegmentViewDelegate {
    
    func didSelectSegmentAt(index: Int) {
        
        if index != self.pageVC?.currentIndex {
            self.pageVC?.setViewControllerAt(index: index)
            appliedFilterAndSearch()
        }
    }
}

