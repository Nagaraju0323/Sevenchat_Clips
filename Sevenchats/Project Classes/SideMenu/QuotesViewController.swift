//
//  QuotesViewController.swift
//  Sevenchats
//
//  Created by mac-0005 on 21/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class QuotesViewController: ParentViewController {
    
    @IBOutlet weak var tblQuotes : UITableView!
    
    var arrQuotes = [[String : AnyObject]]()
    var refreshControl = UIRefreshControl()
    var apiTask : URLSessionTask?
    var currentPage = 1
    var lastPage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Initialization()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK:- ---------- Initialization
    func Initialization(){
        self.title = CSideQuotes
        tblQuotes.estimatedRowHeight = 105;
        tblQuotes.rowHeight = UITableView.automaticDimension;
        
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        refreshControl.tintColor = ColorAppTheme
        tblQuotes.pullToRefreshControl = refreshControl
        
        self.loadQuotes(showLoader: true)
    }
}

// MARK:- --------- API Functions
extension QuotesViewController {
    
    @objc func pullToRefresh() {
        currentPage = 1
        refreshControl.beginRefreshing()
        self.loadQuotes(showLoader: false)
    }
    
    func loadQuotes(showLoader : Bool) {
        
        if apiTask?.state == URLSessionTask.State.running {
            return
        }
        // Add load more indicator here...
        if self.currentPage > 2 {
            self.tblQuotes.tableFooterView = self.loadMoreIndicator(ColorAppTheme)
        }else{
            self.tblQuotes.tableFooterView = nil
        }
        
        apiTask = APIRequest.shared().loadQuotes(page: currentPage, shouldShowLoader : showLoader, completion: { [weak self] (response, error) in
            guard let self = self else { return }
            self.refreshControl.endRefreshing()
            self.tblQuotes.tableFooterView = nil
            if response != nil && error == nil {
                
                if let arrDatas = response![CQuotes] as? [String:Any]{
                    let arrData = arrDatas[CQuotes] as? [[String : AnyObject]] ?? []
                    
                    // Remove all data here when page number == 1
                    if self.currentPage == 1{
                        self.arrQuotes.removeAll()
                    }
                    // Add Data here...
                    if arrData.count > 0{
                        self.arrQuotes = self.arrQuotes + arrData
                        self.currentPage += 1
                    }
                    DispatchQueue.main.async {
                        self.tblQuotes.reloadData()
                    }
                }
            }
        })
    }
}

// MARK:- --------- UITableView Datasources/Delegate
extension QuotesViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.arrQuotes.isEmpty{
            self.tblQuotes.setEmptyMessage(CNoQuotesYet)
        }else{
            self.tblQuotes.restore()
        }
        return arrQuotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "QuotesTblCell", for: indexPath) as? QuotesTblCell {
            let dict = arrQuotes[indexPath.row]
            
            cell.lblQuotes.text = dict.valueForString(key: "quote_desc")
            cell.lblQuotesWriter.text = dict.valueForString(key: "author_name")
            let created_At = dict.valueForString(key: "created_at")
            let cnvStr = created_At.stringBefore("G")
            let startCreated = DateFormatter.shared().convertDatereversLatest(strDate: cnvStr)
            cell.lblQuotesPostDate.text = startCreated
            cell.btnShare.tag = indexPath.row
            cell.btnShare.touchUpInside { [weak self](sender) in
                guard let _ = self else { return }
                let postData = self?.arrQuotes[sender.tag]
                let sharePost = SharePostHelper(controller: self, dataSet: postData)
                sharePost.isFromQuote = true
                sharePost.shareURL = postData?.valueForString(key: CShare_url) ?? ""
                sharePost.presentShareActivity()
            }
            //...Load More
            if indexPath == tblQuotes.lastIndexPath() {
                self.loadQuotes(showLoader: false)
            }
            return cell
        }
        return tableView.tableViewDummyCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}


