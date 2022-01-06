//
//  PSLSideViewController.swift
//  Sevenchats
//
//  Created by CHANDU on 03/01/22.
//  Copyright © 2022 mac-00020. All rights reserved.
// Public service

import UIKit

class PSLSideViewController: ParentViewController {

    @IBOutlet fileprivate weak var collNewCategory : UICollectionView!
    @IBOutlet fileprivate weak var tblNews : UITableView! {
        didSet {
            tblNews.estimatedRowHeight = 100
            tblNews.rowHeight = UITableView.automaticDimension
        }
    }
    
    @IBOutlet fileprivate weak var cnImgVTopBgHeight : NSLayoutConstraint!
    @IBOutlet fileprivate weak var activityLoader : UIActivityIndicatorView!
    @IBOutlet fileprivate weak var lblNoData : UILabel!

    var arrNewsCategory = [TblPslCategory]()
    var arrNews = [[String : Any]]()
    var arrNewsSGovt = [MDLPslCategory]()
    var arrNewsCGovt = [MDLPslCategory]()
    var arrNewsNgo = [MDLPslCategory]()

    var selectedCateIndexPath = IndexPath(item: 0, section: 0)
    var apiTask : URLSessionTask?
    var refreshControl = UIRefreshControl()
    var pageNumber = 1
    var isLoadMoreCompleted = false
    var isSeletedCtg = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initailize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lblNoData.text = CNoDataFoundForNewMsg
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initailize() {
        
        self.title = CNavPSL
        
        if Localization.sharedInstance.applicationFlowWithLanguageRTL() {
            collNewCategory.semanticContentAttribute = UISemanticContentAttribute.forceRightToLeft
        } else {
            collNewCategory.semanticContentAttribute = UISemanticContentAttribute.forceLeftToRight
        }
        
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        refreshControl.tintColor = ColorAppTheme
        tblNews.pullToRefreshControl = refreshControl
        
        //...Fetch News Category From local
        self.getNewsCategoryFromLocal()
        
        if IS_iPhone_X_Series {
            cnImgVTopBgHeight.constant = 148 //Nav height + coll height + 34
        }
    }
    
    fileprivate func getNewsCategoryFromLocal() {
        
        if let arrData = TblPslCategory.fetch(predicate: nil, orderBy: CCategoryName, ascending: true) {
            if arrData.count > 0 {
                arrNewsCategory = arrData as! [TblPslCategory]
                collNewCategory.reloadData()
                self.loadNewsListForParticularCategoryFromServer(categoryID: (arrNewsCategory[selectedCateIndexPath.row].category_name ?? ""), isShowLoader: true)
            }
        }
    }
    
}
//MARK:-
//MARK:- API Methods

extension PSLSideViewController {
    
    @objc fileprivate func pullToRefresh() {
        guard arrNewsCategory.count > selectedCateIndexPath.row else{
            refreshControl.endRefreshing()
            return
        }
        self.pageNumber = 1
        refreshControl.beginRefreshing()
        self.loadNewsListForParticularCategoryFromServer(categoryID: (arrNewsCategory[selectedCateIndexPath.row].category_name ?? ""), isShowLoader: false)
    }
    
    fileprivate func loadNewsListForParticularCategoryFromServer(categoryID: String, isShowLoader: Bool) {
        
        if apiTask?.state == URLSessionTask.State.running {
            return
        }
//        if isShowLoader{
//            MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: nil)
//        }
        
        if self.pageNumber > 2 {
            self.tblNews.tableFooterView = self.loadMoreIndicator(ColorAppTheme)
        }else{
            self.tblNews.tableFooterView = nil
        }
        guard let userID = appDelegate.loginUser?.user_id else {return}
        
        apiTask = APIRequest.shared().getPSLList(page: pageNumber, type: "PSL", showLoader: isShowLoader,userId:userID.description){ [weak self] (response, error) in
            guard let self = self else { return }
            if response != nil{
                //                self.arrFavWebSite.removeAll()
                self.refreshControl.endRefreshing()
                self.tblNews.tableFooterView = nil
               
                if let webarrList = response![CWebsites] as? [String:Any]{
                    let arrList = webarrList["favourite_websites"] as? [[String : Any]] ?? []
                    if self.pageNumber == 1{
                        self.arrNews.removeAll()
                    }
                    self.isLoadMoreCompleted = arrList.isEmpty
                    // Add Data here...
                    if arrList.count > 0{
                        self.arrNews = self.arrNews + arrList
                        self.pageNumber += 1
                    }
                    DispatchQueue.main.async {
                        self.tblNews.reloadData()
                    }
                }
            }
        }
        
//
//        {(response, error) in
//            MILoader.shared.hideLoader()
//            self.apiTask?.cancel()
//            self.refreshControl.endRefreshing()
//            self.activityLoader.stopAnimating()
//
//            if response != nil && error == nil {
//                if let arrData = response?.value(forKey: CJsonData) as? [[String : AnyObject]] {
//                    self.arrNews.removeAll()
//                    self.arrNews = arrData
//                }
//                self.tblNews.reloadData()
//                self.lblNoData.isHidden = self.arrNews.count > 0
//            }
//        }
//
    }
    
    fileprivate func shareNews(shareUrl:String) {
        let activityItems = [CCheckThisInNews, shareUrl]
        let activityController = UIActivityViewController(activityItems: activityItems as [Any], applicationActivities: nil)
        activityController.excludedActivityTypes = [.airDrop, .addToReadingList, .assignToContact, .copyToPasteboard, .mail, .message, .openInIBooks, .postToWeibo, .postToVimeo, .print]
        self.present(activityController, animated: true, completion: nil)
    }
}



//MARK:-
//MARK:- UICollectionView Delegate and Datasource

extension PSLSideViewController : UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrNewsCategory.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize  {
        
        let fontToResize = CFontPoppins(size: 13, type: .meduim).setUpAppropriateFont()
        return CGSize(width:(arrNewsCategory[indexPath.row].category_name?.size(withAttributes: [NSAttributedString.Key.font: fontToResize as Any]).width)! + 30, height: collectionView.CViewHeight)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsCategoryCollCell", for: indexPath) as? NewsCategoryCollCell {
            
            cell.lblCategoryName.text = arrNewsCategory[indexPath.row].category_name
            
            if selectedCateIndexPath == indexPath {
                cell.lblCategoryName.textColor = UIColor.white
            } else {
                cell.lblCategoryName.textColor = CRGB(r: 88, g: 109, b: 61)
            }
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedCateIndexPath = indexPath
        self.collNewCategory.reloadData()
        self.tblNews.setContentOffset(.zero, animated: false)
        isSeletedCtg = arrNewsCategory[indexPath.item].category_name ?? ""
        self.loadNewsListForParticularCategoryFromServer(categoryID: (arrNewsCategory[indexPath.item].category_name ?? ""), isShowLoader: true)
    }
}


//MARK:-
//MARK:- UITableView Delegate and Datasource

extension PSLSideViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrNews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTblCell") as? NewsTblCell {
            
            let newsInfo = arrNews[indexPath.row]
            print("isSeletedCtg\(isSeletedCtg)")
            
//            if arrNewsCategory[selectedCateIndexPath.row].category_name ?? "" == newsInfo.valueForString(key: "category_name"){
                cell.lblTitle.text = newsInfo.valueForString(key: "favourite_website_title")
                cell.lblDesc.text = newsInfo.valueForString(key: "description")
                
                cell.lblProvidedBy.text = "\(CProvidedBy) \(newsInfo.valueForString(key: "source"))"
                cell.imgVNews.loadImageFromUrl(newsInfo.valueForString(key: "urlToImage"), false)
                
                cell.btnShare.touchUpInside { [weak self](sender) in
                    guard let self = self else { return }
                    self.shareNews(shareUrl: newsInfo.valueForString(key: "favourite_website_url"))
//                }
            }
            
//            cell.lblTitle.text = newsInfo.valueForString(key: "favourite_website_title")
//            cell.lblDesc.text = newsInfo.valueForString(key: "description")
//
//            cell.lblProvidedBy.text = "\(CProvidedBy) \(newsInfo.valueForString(key: "source"))"
//            cell.imgVNews.loadImageFromUrl(newsInfo.valueForString(key: "urlToImage"), false)
//
//            cell.btnShare.touchUpInside { [weak self](sender) in
//                guard let self = self else { return }
//                self.shareNews(shareUrl: newsInfo.valueForString(key: "favourite_website_url"))
//            }
            
            cell.lblProvidedBy.isHidden = true
            
            if indexPath == tableView.lastIndexPath() && !self.isLoadMoreCompleted{
                self.loadNewsListForParticularCategoryFromServer(categoryID: (arrNewsCategory[selectedCateIndexPath.row].category_name ?? ""), isShowLoader: false)
            }
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let newsInfo = arrNews[indexPath.row]
        
        if let newsWebVC = CStoryboardGeneral.instantiateViewController(withIdentifier: "NewsWebViewController") as? NewsWebViewController {
            newsWebVC.iObject = newsInfo
            newsWebVC.isPSLwebStire = true
            
            self.navigationController?.pushViewController(newsWebVC, animated: true)
        }
    }
}
