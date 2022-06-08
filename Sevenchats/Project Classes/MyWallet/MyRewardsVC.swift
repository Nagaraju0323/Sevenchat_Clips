//
//  MyRewardsVC.swift
//  Sevenchats
//
//  Created by mac-00020 on 01/02/20.
//  Copyright © 2020 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Nagaraju K and Chandrika R                                 *
 * Model   : MyRewardsVC                                 *
 * Changes :                                             *
 *                                                       *
 ********************************************************/


import UIKit

class MyRewardsVC: ParentViewController {
    
    //MARK: - IBOutlet/Object/Variable Declaration -
    @IBOutlet weak var tblHistory: UITableView!
    
    var arrHistory : [MDLRewardSummary] = []
    var rewards = MDLRewards(points:0)
    var refreshControl = UIRefreshControl()
    var dict = [String:Any]()
    var nameArr = [String]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupView()
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: #imageLiteral(resourceName: "ic_info_tint"), style: .plain, target: self, action: #selector(btnHelpInfoClicked(_:)))]
    }
    
    @objc fileprivate func btnHelpInfoClicked(_ sender : UIBarButtonItem){
        if let helpLineVC = CStoryboardHelpLine.instantiateViewController(withIdentifier: "HelpLineViewController") as? HelpLineViewController {
            helpLineVC.fromVC = "rewardsVC"
            self.navigationController?.pushViewController(helpLineVC, animated: true)
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: - Memory management methods -
    deinit {
        print("### deinit -> MyRewardsVC")
    }
}

//MARK: - SetupUI -
extension MyRewardsVC {
    
    fileprivate func setupView() {
        
        self.title = CMyRewards
        self.view.backgroundColor = UIColor(hexString: "f9fafa")
        
        self.tblHistory.register(UINib(nibName: "TotalEarnedPointsCell", bundle: nil), forCellReuseIdentifier: "TotalEarnedPointsCell")
        self.tblHistory.register(UINib(nibName: "RewardCategoryCell", bundle: nil), forCellReuseIdentifier: "RewardCategoryCell")
        self.tblHistory.register(UINib(nibName: "RewardCategoryHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "RewardCategoryHeaderView")
        
        self.tblHistory.separatorStyle = .none
        self.tblHistory.tableFooterView = UIView(frame: .zero)
        self.refreshControl.tintColor = ColorAppTheme
        self.refreshControl.addTarget(self, action: #selector(self.pullToRefresh), for: .valueChanged)
        self.tblHistory.pullToRefreshControl = self.refreshControl
        self.tblHistory.delegate = self
        self.tblHistory.dataSource = self
        
        self.getRewardsSummaryNew(isLoader: true)
    }
}   

//MARK: - UITableViewDelegate, UITableViewDataSource -
extension MyRewardsVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return self.arrHistory.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard section == 1,
            let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "RewardCategoryHeaderView") else {
                return nil
        }
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        guard section == 1 else {
            return 0
        }
        
        return CScreenWidth*37/375
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TotalEarnedPointsCell") as? TotalEarnedPointsCell else {
                return UITableViewCell(frame: .zero)
            }
            cell.reward = self.rewards
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RewardCategoryCell") as? RewardCategoryCell else {
            return UITableViewCell(frame: .zero)
        }
        cell.rewardSummary = self.arrHistory[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard indexPath.section != 0 else { return }
        guard let myWalletHistory = CStoryboardRewards.instantiateViewController(withIdentifier: "MyRewardsHistoryVC") as? MyRewardsHistoryVC else { return }
        myWalletHistory.type = self.arrHistory[indexPath.row].type
        myWalletHistory.categoryName = self.arrHistory[indexPath.row].name
        myWalletHistory.categoryId = self.arrHistory[indexPath.row].id
        
        self.navigationController?.pushViewController(myWalletHistory, animated: true)
    }
}

// MARK:- API's Calling
extension MyRewardsVC {
    
    @objc func pullToRefresh() {
        self.refreshControl.beginRefreshing()
        self.getRewardsSummaryNew(isLoader: false)
    }
    fileprivate func getRewardsSummaryNew(isLoader: Bool) {
        
        MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: "\(CMessagePleaseWait)...")
        
        guard let userID = appDelegate.loginUser?.user_id.description else { return }
        dict[CUserId] = userID
        APIRequest.shared().rewardsSummaryNew(dict:dict,showLoader: isLoader) { [weak self] (response, error) in
            
            guard let self = self else { return }
            var dict = [String:Any]()
            self.refreshControl.endRefreshing()
            print(response as Any)
            self.arrHistory.removeAll()
            MILoader.shared.hideLoader()
            if response != nil {
                let arrData = response![CData] as? [[String : Any]] ?? []
                if let arrMessageList : [TblRewardCategory] = TblRewardCategory.fetch(predicate: nil, orderBy: CCategoryName, ascending: true) as? [TblRewardCategory] {
                    for interest in arrMessageList {
                        let interestInfo = interest
                        dict[CCategory_Id] = interestInfo.category_id?.toInt
                        dict[CCategoryName] = interestInfo.category_name
                        let arrNameList:[String] = arrData.map({$0.valueForString(key: CName)})
                        let points:[String] = arrData.map({$0.valueForString(key: CPointreward)})
                        if arrNameList.contains(where: { $0.description == interest.category_name }) {
                            let indexname = arrNameList.firstIndex{$0 == interest.category_name}
                            dict[CPointreward] = points[indexname ?? 0]
                        } else {
                            dict[CPointreward] = "0"
                        }
                        self.arrHistory.append(MDLRewardSummary(fromDictionary: dict))
                    }
                } else {
                    return
                }
            }
            let points = response?["total_points"] as? String ?? ""
            if points.toInt == 0{
                if let arrMessageList : [TblRewardCategory] = TblRewardCategory .fetch(predicate: nil, orderBy: CCategoryName, ascending: true) as? [TblRewardCategory] {
                    for interest in arrMessageList {
                        let interestInfo = interest
                        dict[CCategory_Id] = interestInfo.category_id?.toInt
                        dict[CCategoryName] = interestInfo.category_name
                        dict[CPointreward] = "0"
                        self.arrHistory.append(MDLRewardSummary(fromDictionary: dict))
                    }
                } else {
                    return
                }
            }
            self.rewards = MDLRewards(points: points.toInt ?? 0)
            self.tblHistory.reloadData()
        }
    }
    }
    

