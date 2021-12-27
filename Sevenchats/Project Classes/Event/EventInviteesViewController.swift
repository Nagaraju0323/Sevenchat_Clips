//
//  EventInviteesViewController.swift
//  Sevenchats
//
//  Created by mac-0005 on 06/09/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class EventInviteesViewController: ParentViewController {

    @IBOutlet var tblInvitees : UITableView!
    var arrInvitees : [[String : Any]] = []
    var eventId : Int?
    
    var pageNumber = 1
    var refreshControl = UIRefreshControl()
    var apiTask : URLSessionTask?
    var actionType : Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Initialization()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func Initialization(){
        self.title = CNavInvitees
        GCDMainThread.async {
            
            self.refreshControl.addTarget(self, action: #selector(self.pullToRefresh), for: .valueChanged)
            self.refreshControl.tintColor = ColorAppTheme
            self.tblInvitees.pullToRefreshControl = self.refreshControl
            self.pageNumber = 1
            self.callAPI(true)

            self.tblInvitees.reloadData()
        }
    }
}

// MARK:- --------- UITableView Datasources/Delegate
extension EventInviteesViewController : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrInvitees.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "LikesTblCell", for: indexPath) as? LikesTblCell {
            let userInfo = arrInvitees[indexPath.row]
            cell.lblUserName.text = userInfo.valueForString(key: CFirstname) + " " + userInfo.valueForString(key: CLastname)
            cell.imgUser.loadImageFromUrl(userInfo.valueForString(key: CUserProfileImage), true)
            
            // LOAD MORE DATA...
            if indexPath == tblInvitees.lastIndexPath() {
                self.callAPI(false)
            }
            return cell
        }
        
        return tableView.tableViewDummyCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}


// MARK:- --------- Api Functions
extension EventInviteesViewController{
    @objc func pullToRefresh() {
        self.pageNumber = 1
        refreshControl.beginRefreshing()
        self.callAPI(false)
    }
    
    func callAPI(_ shouldShowLoader : Bool){
        if (eventId ?? 0) != 0{
            self.getInveetiListFromServer(shouldShowLoader)
        }else{
            refreshControl.endRefreshing()
        }
    }
    
    func getInveetiListFromServer(_ shouldShowLoader : Bool){
//        
//        if apiTask?.state == URLSessionTask.State.running {
//            return
//        }
//        
//        if self.pageNumber > 2{
//            self.tblInvitees.tableFooterView = self.loadMoreIndicator(ColorAppTheme)
//        }else{
//            self.tblInvitees.tableFooterView = nil
//        }
//        
//        if shouldShowLoader{
//            MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: "\(CMessagePleaseWait)...")
//        }
//        apiTask = APIRequest.shared().getEventInveetiList(page: self.pageNumber, postId: self.eventId ?? 0, type: self.actionType,completion: { (response, error) in
//            
//            DispatchQueue.main.async {
//                self.refreshControl.endRefreshing()
//                self.tblInvitees.tableFooterView = nil
//                
//                if response != nil{
//                    if let arrList = response![CJsonData] as? [[String:Any]]{
//                        
//                        // Remove all data here when page number == 1
//                        if self.pageNumber == 1{
//                            self.arrInvitees.removeAll()
//                            self.tblInvitees.reloadData()
//                        }
//                        
//                        // Add Data here...
//                        if arrList.count > 0{
//                            self.arrInvitees = self.arrInvitees + arrList
//                            self.tblInvitees.reloadData()
//                            self.pageNumber += 1
//                        }
//                    }
//                }
//                MILoader.shared.hideLoader()
//            }
//        })
    }
    
}
