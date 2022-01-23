//
//  UpgradeStoragePopUpView.swift
//  Sevenchats
//
//  Created by mac-00018 on 30/05/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Chandrika.R                                 *
 * Model   : UpgradeStoragePopUpView                     *
 * Changes :                                             *
 *                                                       *
 ********************************************************/

import UIKit

protocol popupDelegate : class {
    
}

class UpgradeStoragePopUpView: UIView {

    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var viewPopup: UIView!
    
    @IBOutlet weak var lblPlanName: UILabel!
    @IBOutlet weak var lblPlanMonth: UILabel!
    @IBOutlet weak var lblPlanYear: UILabel!
    @IBOutlet weak var lblYouSave: UILabel!
    
    @IBOutlet weak var btnCancel: UIButton!{
        didSet{
            btnCancel.setTitle(CBtnCancel, for: .normal)
        }
    }
    @IBOutlet weak var btnContinue: UIButton!{
        didSet{
            btnContinue.setTitle(CBtnContinue, for: .normal)
        }
    }
    
    @IBOutlet weak var imgVUploadStorage: UIImageView!
    @IBOutlet weak var btnPrMonth: MIGenericButton!
    @IBOutlet weak var btnPrYear: MIGenericButton!
    var onCompleted : ((Bool,String?) -> Void)?
    
    var upgradPlan : MDLUpgradPlan!{
        didSet{
            self.lblPlanName.text = upgradPlan.name
            self.lblPlanMonth.text = "₹\(upgradPlan.monthlyCost!)/\(CMonth)"
            self.lblPlanYear.text = "₹\(upgradPlan.yearlyCost!)/\(CYear)"
            self.upgradPlan.storageType = .Monthly
            let yearCost = (upgradPlan.monthlyCost.toFloat ?? 0.0) * 12.0
            let saveCost = yearCost - (upgradPlan.yearlyCost.toFloat ?? 0.0)
            if saveCost > 0{
                self.lblYouSave.text = "(\(CBtnSave) ₹\(Int(saveCost)))"
            }else{
                self.lblYouSave.text = ""
            }
            self.updateStorageType()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        viewPopup.layer.cornerRadius = 8
        viewPopup.layer.borderWidth = 5
        viewPopup.layer.borderColor = UIColor.black.withAlphaComponent(0.4).cgColor
        
        self.imgVUploadStorage.layoutIfNeeded()
        self.imgVUploadStorage.roundView()
    }
    
    class func popupView() -> UpgradeStoragePopUpView? {
        
        if let popup = UpgradeStoragePopUpView.viewFromXib as? UpgradeStoragePopUpView {
            
            popup.viewPopup.transform = CGAffineTransform(scaleX: 0, y: 0)
            UIView.animate(withDuration: 0.2) {
                popup.viewPopup.transform = CGAffineTransform.identity
            }
            
            popup.frame = appDelegate.window.frame
            CTopMostViewController.view.addSubview(popup)
            
            return popup
        }
        
        return nil
    }
    
    func dissmisPopup(_ completion: (Bool?) -> Void) {
        self.removeFromSuperview()
        completion(true)
    }
    
    func updateStorageType(){
        
        if upgradPlan.storageType == .Monthly{
            btnPrMonth.setImage(UIImage(named: "ic_select_package"), for: .normal)
            btnPrYear.setImage(UIImage(named: ""), for: .normal)
            btnPrMonth.isSelected = true
        }else{
            btnPrYear.setImage(UIImage(named: "ic_select_package"), for: .normal)
            btnPrMonth.setImage(UIImage(named: ""), for: .normal)
            btnPrYear.isSelected = true
        }
    }
}

//MARK: - API Function....
extension UpgradeStoragePopUpView {
    
    func apiForUpgradStorage() {
        
        var para = [String : Any]()
        para["transaction_id"] = 50
        para["transaction_from"] = 2  // (1=>android, 2=>ios).
        para["storage_id"] = self.upgradPlan.id
        para["storage_type"] =  self.upgradPlan.storageType.rawValue
        para["transaction_date"] = Date.generateCurrentWith(dateFormate: "yyyy-MM-dd")
        print(para)

    }
}

// MARK: - Action Events
extension UpgradeStoragePopUpView {
    
    @IBAction func btnContinueAction(_ sender: UIButton) {
        self.apiForUpgradStorage()
    }
    
    @IBAction func btnCancleAction(_ sender: UIButton) {
        dissmisPopup { (_) in
        }
    }
    
    @IBAction func btnMonthAction(_ sender: UIButton) {
        upgradPlan.storageType = .Monthly
        updateStorageType()
    }
    
    @IBAction func btnPrYearAction(_ sender: MIGenericButton) {
        upgradPlan.storageType = .Yearly
        updateStorageType()
    }
}
