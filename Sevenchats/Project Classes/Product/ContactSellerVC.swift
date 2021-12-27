//
//  ContactSellerVC.swift
//  Sevenchats
//
//  Created by mac-00020 on 28/08/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//

import Foundation
import UIKit

class ContactSellerVC: ParentViewController {
    
    //MARK: - IBOutlet/Object/Variable Declaration
    @IBOutlet weak var lblName: MIGenericLabel!
    @IBOutlet weak var lblEmail: MIGenericLabel!
    @IBOutlet weak var lblPhone: MIGenericLabel!
    
    @IBOutlet weak var txtMessage: GenericTextView!
    @IBOutlet weak var lblTextCount: MIGenericLabel!
    
    @IBOutlet weak var lblYourInfo: MIGenericLabel!
    @IBOutlet weak var btnSubmit: MIGenericButton!
    
    @IBOutlet weak var vwContainer: UIView!{
        didSet{
            vwContainer.isHidden = true
        }
    }
    
    var sellerID = 0
    var productID = 0
    var productIDs = ""
    var productEmailid:String?
    var productUserName:String?
    var productMobile:String?
    
    //MARK: - View life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    //MARK: - Memory management methods
    deinit {
        print("### deinit -> ContactSellerVC")
    }
}

//MARK: - SetupUI
extension ContactSellerVC {
    
    fileprivate func setupView() {
        
        self.title = CContactSeller
        lblYourInfo.text = CYourInfo
        self.txtMessage.isHidden = true
        self.lblTextCount.isHidden = true 
//        txtMessage.placeHolder = CMessage.capitalized
//        txtMessage.isScrollEnabled = true
//        txtMessage.txtDelegate = self
//        txtMessage.textLimit = "1500"
//        lblTextCount.text = "0/\(txtMessage.textLimit ?? "0")"
        
        self.btnSubmit.setTitle(CForgotBtnSubmit, for: .normal)
        
        self.lblName.text = productUserName ?? ""
        self.lblEmail.text = productEmailid ?? ""
        self.lblPhone.text = productMobile ?? ""
        self.btnSubmit.isHidden = true
        self.getSellerDetails()
        
    }
    
    fileprivate func isValidAllFields() -> Bool{
        if (txtMessage.text ?? "").trim.isEmpty {
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CBlankContactSellerMessage, btnOneTitle: CBtnOk, btnOneTapped: nil)
            return false
        }
        return true
    }
}

//MARK: - IBAction / Selector
extension ContactSellerVC {
    
    @IBAction func onSubmitPressed(_ sender: UIButton) {
        if isValidAllFields(){
            print("Ready for submit")
            self.contactToSeller()
        }
    }
}

// MARK:-  --------- Generic UITextView Delegate
extension ContactSellerVC: GenericTextViewDelegate{
    
    func genericTextViewDidChange(_ textView: UITextView, height: CGFloat){
        
        if textView == txtMessage {
            lblTextCount.text = "\(textView.text.count)/\(txtMessage.textLimit ?? "0")"
        }
    }
}

//MARK: - API Function
extension ContactSellerVC {
    
    fileprivate func getSellerDetails(){
        self.vwContainer.isHidden = false
//        guard self.sellerID != 0 else{
//            return
//        }
//        APIRequest.shared().getSellerInfo(sellerId: self.sellerID)  { [weak self](response, error) in
//            if response != nil {
//                GCDMainThread.async {
//
//                    let data = response![CData] as? [String : Any] ?? [:]
//                    print(data)
//                    self?.lblName.text = data["full_name"] as? String ?? ""
//                    self?.lblEmail.text = data["email"] as? String ?? ""
//                    let countryCode =  data["country_id"] as? String ?? ""
//                    let mobile =  data["mobile"] as? String ?? ""
//                    self?.lblPhone.text = "+" + countryCode + " " + mobile
//
//                    self?.vwContainer.isHidden = false
//                }
//            }
//        }
    }
    
    fileprivate func contactToSeller(){
        guard self.sellerID != 0, self.productID != 0 else{
            return
        }
        var para = [String : Any]()
        para["product_id"] = self.productID.description
        para["message"] = self.txtMessage!.text
        
        print("Request : \(para)")
//        APIRequest.shared().contactSeller(sellerId: self.sellerID, para: para) { [weak self](response, error) in
//            guard let _ = self else { return }
//            if response != nil {
//                GCDMainThread.async {
//                    //let data = response![CData] as? [String : Any] ?? [:]
//                    self?.navigationController?.popViewController(animated: true)
//                    CTopMostViewController.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CContactToSellerSuccessfully, btnOneTitle: CBtnOk, btnOneTapped: nil)
//                }
//            }
//        }
    }
}
