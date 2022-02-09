//
//  PollVotesListViewController.swift
//  Sevenchats
//
//  Created by mac-00020 on 07/06/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Chandrika.R                                 *
 * Model   : PollVotesListViewController                 *
 * Changes :                                             *
 *                                                       *
 ********************************************************/

//import Foundation
//import UIKit
//
//class PollVotesListViewController: ParentViewController {
//
//    //MARK: - IBOutlet/Object/Variable Declaration
//    @IBOutlet weak var tblVoteList: UITableView!{
//        didSet {
//            tblVoteList.register(UINib(nibName: "PollVotesListTblCell", bundle: nil), forCellReuseIdentifier: "PollVotesListTblCell")
//            tblVoteList.tableHeaderView = UIView()
//            tblVoteList.separatorStyle = .none
//            tblVoteList.estimatedRowHeight = 50
//            tblVoteList.rowHeight = 50
//            tblVoteList.delegate = self
//            tblVoteList.dataSource = self
//
//            self.refreshControl.addTarget(self, action: #selector(self.pullToRefresh), for: .valueChanged)
//            self.refreshControl.tintColor = ColorAppTheme
//            self.tblVoteList.pullToRefreshControl = self.refreshControl
//            self.pageNumber = 1
//
//            tblVoteList.tableFooterView = UIView(frame: .zero)
//        }
//    }
//
//    var pageNumber = 1
//    var refreshControl = UIRefreshControl()
//    var apiTask : URLSessionTask?
//    var pollUser = [String: Any]()
//    var pollUsers : [MDLPollOptionsNew] = []
//
//    //MARK: - View life cycle methods
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        self.Initialization()
//    }
//
//    //MARK: - Memory management methods
//    deinit {
//        print("### deinit -> PollVotesListViewController")
//    }
//}
//
////MARK: - Initialization
//extension PollVotesListViewController {
//    fileprivate func Initialization()  {
//
//        self.title = CPollUsersList
//       setPollUsers(users: pollUsers)
//        self.tblVoteList.reloadData()
//    }
//
//    @objc func pullToRefresh() {
//        self.pageNumber = 1
//        refreshControl.beginRefreshing()
//        refreshControl.endRefreshing()
//    }
//}
//
////MARK: - API Functions
//extension PollVotesListViewController {
//    func setPollUsers(users:[MDLPollOptionsNew]){
//        self.pollUsers = users
//        self.tblVoteList.reloadData()
//    }
//}
//
////MARK: - UITableViewDelegate, UITableViewDataSource
//extension PollVotesListViewController : UITableViewDelegate, UITableViewDataSource{
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 65
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return pollUsers.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if let cell = tableView.dequeueReusableCell(withIdentifier: "PollVotesListTblCell") as? PollVotesListTblCell {
//          cell.lblName.text = pollUsers[indexPath.row].firstName + pollUsers[indexPath.row].lastName
//            cell.imgVProfile.loadImageFromUrl(pollUsers[indexPath.row].profileImage, true)
//
//            return cell
//        }
//        return UITableViewCell()
//    }
//}
//
////MARK: - IBAction / Selector
//extension PollVotesListViewController {
//
//    @IBAction func onCancel(_ sender: UIButton) {
//    }
//}


import Foundation
import UIKit

class PollVotesListViewController: ParentViewController {
    
    //MARK: - IBOutlet/Object/Variable Declaration
    @IBOutlet weak var tblVoteList: UITableView!{
        didSet {
            tblVoteList.register(UINib(nibName: "PollVotesListTblCell", bundle: nil), forCellReuseIdentifier: "PollVotesListTblCell")
            tblVoteList.tableHeaderView = UIView()
            tblVoteList.separatorStyle = .none
            tblVoteList.estimatedRowHeight = 50
            tblVoteList.rowHeight = 50
            tblVoteList.delegate = self
            tblVoteList.dataSource = self
            
            self.refreshControl.addTarget(self, action: #selector(self.pullToRefresh), for: .valueChanged)
            self.refreshControl.tintColor = ColorAppTheme
            self.tblVoteList.pullToRefreshControl = self.refreshControl
            self.pageNumber = 1
            
            tblVoteList.tableFooterView = UIView(frame: .zero)
        }
    }
    
    var pageNumber = 1
    var refreshControl = UIRefreshControl()
    var apiTask : URLSessionTask?
    var pollUser = [String: Any]()
    var pollUsers : [MDLPollOptionsNew] = []
    
    //MARK: - View life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.Initialization()
    }
    
    //MARK: - Memory management methods
    deinit {
        print("### deinit -> PollVotesListViewController")
    }
}

//MARK: - Initialization
extension PollVotesListViewController {
    fileprivate func Initialization()  {
        
        self.title = CPollUsersList
       setPollUsers(users: pollUsers)
        self.tblVoteList.reloadData()
    }
    
    @objc func pullToRefresh() {
        self.pageNumber = 1
        refreshControl.beginRefreshing()
        refreshControl.endRefreshing()
    }
}

//MARK: - API Functions
extension PollVotesListViewController {
    func setPollUsers(users:[MDLPollOptionsNew]){
        self.pollUsers = users
        self.tblVoteList.reloadData()
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension PollVotesListViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pollUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PollVotesListTblCell") as? PollVotesListTblCell {
          cell.lblName.text = pollUsers[indexPath.row].firstName + pollUsers[indexPath.row].lastName
            cell.imgVProfile.loadImageFromUrl(pollUsers[indexPath.row].profileImage, true)
            
            return cell
        }
        return UITableViewCell()
    }
}

//MARK: - IBAction / Selector
extension PollVotesListViewController {
    
    @IBAction func onCancel(_ sender: UIButton) {
    }
}
