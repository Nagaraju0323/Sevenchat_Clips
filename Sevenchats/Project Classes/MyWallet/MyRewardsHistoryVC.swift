//
//  MyRewardsHistoryVC.swift
//  Sevenchats
//
//  Created by mac-00020 on 29/01/20.
//  Copyright © 2020 mac-0005. All rights reserved.
//

import Foundation
import UIKit

class MyRewardsHistoryVC: ParentViewController {
    
    
    //MARK: - IBOutlet/Object/Variable Declaration
    @IBOutlet weak var tblHistory: UITableView!
    var refreshControl = UIRefreshControl()
    var isLoadMoreCompleted = false
    var currentPage : Int = 0
    var apiTask : URLSessionTask?
    var arrRewards : [MDLRewardDetail] = []
    var type : RewardCategory = RewardCategory.Posts
    var rewards = MDLRewards(level: "", points: 0)
    var categoryName = ""
    var categoryId = 0
    
    //MARK: - UIViewController life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: - Memory management methods
    deinit {
        print("### deinit -> MyRewardsHistoryVC")
    }
}

//MARK: - SetupUI
extension MyRewardsHistoryVC {
    
    fileprivate func setupView() {
        
        self.title = categoryName
        self.view.backgroundColor = UIColor(hexString: "f9fafa")
        
        self.tblHistory.register(UINib(nibName: "EarnedPointsCell", bundle: nil), forCellReuseIdentifier: "EarnedPointsCell")
        self.tblHistory.register(UINib(nibName: "TotalEarnedPointsCell", bundle: nil), forCellReuseIdentifier: "TotalEarnedPointsCell")
        
        self.tblHistory.separatorStyle = .none
        self.tblHistory.tableFooterView = UIView(frame: .zero)
        
        self.refreshControl.tintColor = ColorAppTheme
        self.refreshControl.addTarget(self, action: #selector(self.pullToRefresh), for: .valueChanged)
        self.tblHistory.pullToRefreshControl = self.refreshControl
        
        self.tblHistory.delegate = self
        self.tblHistory.dataSource = self
        
        self.getRewardsDetail(isLoader: true)
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension MyRewardsHistoryVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        if self.arrRewards.isEmpty {
            tableView.setEmptyMessage("There is no data!")
            return 0
        }
        tableView.restore()
        return self.arrRewards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TotalEarnedPointsCell") as? TotalEarnedPointsCell else {
                return UITableViewCell(frame: .zero)
            }
            cell.reward = self.rewards
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EarnedPointsCell") as? EarnedPointsCell else {
            return UITableViewCell(frame: .zero)
        }
        
        cell.rewardDetail = self.arrRewards[indexPath.row]
        cell.type = self.type
        
        // Load more data....
        if (indexPath == self.tblHistory.lastIndexPath()) && !self.isLoadMoreCompleted {
            self.getRewardsDetail(isLoader: false)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard indexPath.section != 0 else { return }
        
        let rewardObj = self.arrRewards[indexPath.row]
        switch self.type {
        
        case .Connections, .UsageTime:
            appDelegate.moveOnProfileScreen(rewardObj.friendId.description, self)
            break
            
        case .Posts:
            //            self.redirectOnPostDetailScreen(rewardObj)
            break
            
        case .SellPosts:
            self.redirectOnProductDetail(rewardObj)
            break
            
        default: break
        }
    }
}

// MARK:- API's Calling
extension MyRewardsHistoryVC {
    
    @objc func pullToRefresh() {
        
        self.refreshControl.beginRefreshing()
        self.currentPage = 1
        self.isLoadMoreCompleted = false
        
        self.getRewardsDetail(isLoader: false)
    }
    
    
    fileprivate func getRewardsDetail(isLoader: Bool) {
        
        self.currentPage = 1
        if apiTask?.state == URLSessionTask.State.running {
            return
        }
        var dict = [String:Any]()
        guard let userID = appDelegate.loginUser?.user_id.description else { return}
        dict["user_id"] = userID
        dict["category_id"] = categoryId.toString
        dict["page"] = "1"
        dict["limit"] = "20"
        apiTask = APIRequest.shared().rewardsDetail(param:dict,showLoader: isLoader) { [weak self] (response, error) in
            guard let self = self else { return }
            
            self.refreshControl.endRefreshing()
            print(response as Any)
            if response != nil {
                GCDMainThread.async {
                    
                    if self.currentPage == 1 {
                        self.arrRewards.removeAll()
                    }
                    self.currentPage += 1
                    let arrData = response!["rewards_history"] as? [String : Any] ?? [:]
                    let arrDatas = arrData["rewards_history"] as? [[String : Any]] ?? [[:]]
                    _ = arrDatas.map({self.arrRewards.append(MDLRewardDetail(fromDictionary: $0))})
                    let points = arrData.valueForString(key: "total_points").toInt
                    self.rewards = MDLRewards(name: self.categoryName, level: "", points: points ?? 0)
                    self.tblHistory.reloadData()
                }
            }
        }
    }
}

extension MyRewardsHistoryVC {
    func redirectOnProductDetail(_ rewardDetail : MDLRewardDetail) {
        if let productDetail : ProductDetailVC = CStoryboardProduct.instantiateViewController(withIdentifier: "ProductDetailVC") as? ProductDetailVC{
            productDetail.VcController = 2
            productDetail.productId = rewardDetail.productId
            self.navigationController?.pushViewController(productDetail, animated: true)
        }
    }
 
}
