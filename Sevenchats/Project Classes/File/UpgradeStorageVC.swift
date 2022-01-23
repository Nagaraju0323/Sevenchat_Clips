//
//  UpgradeStorageVC.swift
//  Sevenchats
//
//  Created by mac-00018 on 30/05/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//
/*********************************************************
 * Author  : Chandrika.R                                 *
 * Model   : UpgradeStorageVC                            *
 * Changes :                                             *
 *                                                       *
 ********************************************************/


import UIKit

class UpgradeStorageVC: ParentViewController {
    
    /// It's Logo of upgrade storage
    @IBOutlet weak var imgVUpgrade: UIImageView! {
        didSet {
            imgVUpgrade.image = UIImage(named:"ic_upload_storage_popup")
        }
    }
    
    @IBOutlet weak var tblUpgradeStorage: UITableView! {
        didSet {
            self.tblUpgradeStorage.tableFooterView = UIView(frame: .zero)
            self.tblUpgradeStorage.delegate = self
            self.tblUpgradeStorage.dataSource = self
        }
    }
    
    /// List of available plans
    var arrTotalStorage : [MDLUpgradPlan] = []
    
      //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialization()
        self.getUpgradStoragePlan()
    }
    
    deinit {
        print("deinit -> UpgradeStorageVC")
    }
}

// MARK:- Initilazation
extension UpgradeStorageVC {
    
    fileprivate func initialization() {
        self.title = CNavUpgradeStorage
    }
}

//MARK: - API Function
extension UpgradeStorageVC {
    
    func getUpgradStoragePlan(isLoader:Bool = true) {
        
//        _ = APIRequest.shared().upgradStoragePlanList(showLoader: isLoader) { (response, error) in
//            if response != nil {
//                let data = response![CData] as? [[String : Any]] ?? []
//                DispatchQueue.main.async {
//                    for obj in data{
//                        self.arrTotalStorage.append(MDLUpgradPlan(fromDictionary: obj))
//                    }
//                    self.tblUpgradeStorage.reloadData()
//                }
//            }
//        }
    }
}

// MARK:- UITableView Delegates & Data Source
extension UpgradeStorageVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTotalStorage.count
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TblUpgradeStorageCell") as? TblUpgradeStorageCell {
            let storageInfo = arrTotalStorage[indexPath.row]
            cell.lblTotalStorage.text = storageInfo.name
            let strPrice = "₹\(storageInfo.monthlyCost!)/\(CMonth)"
            cell.btnTotalPrize.setTitle(strPrice, for: .normal)
            cell.btnTotalPrize.tag = indexPath.row
            cell.btnTotalPrize.touchUpInside {[weak self] (sender) in
                guard let _ = self else {return}
                if let upgradView = UpgradeStoragePopUpView.popupView() {
                    upgradView.upgradPlan = self?.arrTotalStorage[sender.tag]
                    upgradView.onCompleted = { [weak self] (isSuccess,message)in
                        if isSuccess{
                            if let controller = self?.navigationController?.getViewControllerFromNavigation(FileSharingViewController.self){
                                controller.fileVC?.pullToRefresh()
                                self?.navigationController?.popViewController(animated: false)
                            }
                        }else{
                            guard let _message = message else {return}
                            self?.presentAlertViewWithOneButton(alertTitle: nil, alertMessage: _message, btnOneTitle: CBtnOk, btnOneTapped: nil)
                        }
                    }
                }
            }
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
