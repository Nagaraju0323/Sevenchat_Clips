//
//  FileSharingViewController.swift
//  Sevenchats
//
//  Created by mac-00018 on 31/05/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//


/*********************************************************
 * Author  : Chandrika.R                                 *
 * Model   : FileSharingViewController                   *
 * Changes :                                             *
 *                                                       *
 ********************************************************/


import UIKit

/*protocol FilesSearchTextDelegate: class {
    func didChangeText(search:String)
}*/

class FileSharingViewController: ParentViewController {
    
    @IBOutlet weak var vwSegment: UIView!
    
    /// Custome Segemtn for My File and Shared File
    weak var sementView: SegmentView!
    
    /// it's contain FilesVC and SharedFilesVC
    weak var pageVC : PageViewController?
    
    /// searchBar for search files in list
    fileprivate var searchBar = UISearchBar()
    /// searchBarItem is used search file
    fileprivate var searchBarItem : UIBarButtonItem!
    /// cancelBarItem is used to cancel the searchBar
    fileprivate var cancelBarItem : UIBarButtonItem!
    
    fileprivate var sortBarItem : UIBarButtonItem!
    
    weak var fileVC :  FilesVC?
    weak var sharedFileVC : SharedFilesVC?
    //showmessages
    var closureShowMessages: ((_ data :String)-> ())?
    
    /// It's list of extension. It will be used while uploading file on server to check
    /// file is restricted or not
    var arrRestrictedFileType : [MDLRestractedFile] = []
    
    var defaultPageIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.initialization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //createNavigationRightButton()
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
    
    fileprivate func setupView() {
        
        /// add bar button in UINavigationBar
        addBarButtonItems()
        
        /// Confiure PageViewController
        self.pageVC?.mDelegate = self
        fileVC = CStoryboardFile.instantiateViewController(withIdentifier: "FilesVC") as? FilesVC
        
        sharedFileVC = CStoryboardFile.instantiateViewController(withIdentifier: "SharedFilesVC") as? SharedFilesVC
        
        let arrPage : [UIViewController] = [fileVC!, sharedFileVC!]
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
        
        let myFile : SegmentText = SegmentText.viewFromXib as! SegmentText
        myFile.lblText.text = CtitleMyFiles
        
        let sharedFile : SegmentText = SegmentText.viewFromXib as! SegmentText
        sharedFile.lblText.text = CTitleSharedFiles
        
        sementView.addSubItems(arrViews: [myFile,sharedFile])
        sementView.selectedSegmentIndex = 0
        if defaultPageIndex != 0 {
            self.changedController(index: defaultPageIndex)
            self.sharedFileVC?.txtSearch = ""
        }
    }
    
    // Created Right bar button...
    fileprivate func addBarButtonItems() {
        
        ///... For Searching
        
        self.searchBarItem = BlockBarButtonItem(image: UIImage(named: "ic_btn_search"), style: .plain) { [weak self] (_) in
            guard let _ = self else {return}
            self?.navigationItem.titleView = self?.searchBar
            UIView.animate(withDuration: 0.5, animations: {
                self?.searchBar.alpha = 1
            }, completion: { finished in
                self?.searchBar.becomeFirstResponder()
            })
            self?.navigationItem.rightBarButtonItems = []
            self?.navigationItem.rightBarButtonItem = self?.cancelBarItem
        }
        ///... For Sorting
        self.sortBarItem = BlockBarButtonItem(image: UIImage(named: "ic_sort"), style: .plain) { [weak self] (_) in
            guard let _ = self else {return}
            DispatchQueue.main.async {
                if let sortProduct : SortProductVC = CStoryboardProduct.instantiateViewController(withIdentifier: "SortProductVC") as? SortProductVC{
//                    sortProduct.selectedSortType = self?.filterObj.sort ?? .NewToOld
                    sortProduct.onFolderSort = { [weak self] (selectedSort) in
                        guard let _ = self else {return}
                        let sortMethodStr = String(describing: selectedSort)
//                        self?.fileVC?.closureShowMessages?(OldToNew)
                        self?.fileVC?.txtSearchsort = sortMethodStr
                    }
                    self?.navigationController?.pushViewController(sortProduct, animated: true)
                }
            }
        }
        self.navigationItem.rightBarButtonItems = [searchBarItem,sortBarItem]
        
        ///... For Cancel Search
        self.cancelBarItem = BlockBarButtonItem(title: CBtnCancel, style: .plain, actionHandler: { [weak self] (item) in
            guard let _ = self else {return}
            self?.searchBar.endEditing(true)
            UIView.animate(withDuration: 0.5, animations: {
                self?.searchBar.alpha = 0
            }, completion: { finished in
                self?.setCancelBarButton()
            })
        })
        
        searchBar.alpha = 0
        searchBar.placeholder = CSearch
        searchBar.tintColor = .black
        
        searchBar.change(textFont: CFontPoppins(size: (14 * CScreenWidth)/375, type: .regular))
        searchBar.delegate = self
    }
    
    func setCancelBarButton(){
        self.navigationItem.titleView = nil
        self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.rightBarButtonItems = [self.searchBarItem,self.sortBarItem] as? [UIBarButtonItem] ?? []
    }
}

//MARK: - Initialization
extension FileSharingViewController {
    
    fileprivate func initialization() {
        self.title = CNavFiles
        
        self.getRestrictedType()
    }
    
    // Create navigation right bar button..
    fileprivate func createNavigationRightButton() {
        
        let button = UIButton(type: .custom)
        let btnHeight = 40
        button.frame = CGRect(x: 0, y: 0, width: btnHeight, height: btnHeight)
        button.setImage(UIImage(named: "ic_btn_search"), for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(customView: button)
    }
}


// MARK: - PageViewControllerDelegate
extension FileSharingViewController : PageViewControllerDelegate {
    
    func changedController(index: Int) {
        sementView.selectedSegmentIndex = index
        self.searchBar.endEditing(true)
        self.searchBar.text = ""
        self.searchTextInFile("")
    }
}

// MARK: - ScrollableSegmentDelegate
extension FileSharingViewController : SegmentViewDelegate {
    
    func didSelectSegmentAt(index: Int) {
        
        self.searchBar.endEditing(true)
        self.searchBar.text = ""
        self.searchTextInFile("")
        if index != self.pageVC?.currentIndex {
            self.pageVC?.setViewControllerAt(index: index)
        }
    }
}

//MARK: - UISearchBarDelegate
extension FileSharingViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchTextInFile("")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTextInFile(searchText)
    }
    
    func searchTextInFile(_ searchText:String){
        
        if self.pageVC?.currentIndex == 0{
            if self.fileVC?.txtSearch != searchText{
                self.fileVC?.txtSearch = searchText
            }
        }else if self.pageVC?.currentIndex == 1{
            
            if self.sharedFileVC?.txtSearch != searchText{
                self.sharedFileVC?.txtSearch = searchText
            }
        }
    }
}

//MARK: - API Function
extension FileSharingViewController {
    
    // Get list of restricted file tuye....
    fileprivate func getRestrictedType(){
        
        self.arrRestrictedFileType.removeAll()
    }
}

