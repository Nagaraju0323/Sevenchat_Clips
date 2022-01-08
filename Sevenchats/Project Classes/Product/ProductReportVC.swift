//
//  ProductReportVC.swift
//  Sevenchats
//
//  Created by mac-00020 on 28/08/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//

import Foundation
import UIKit

class ProductReportVC: ParentViewController {
    
    //MARK: - IBOutlet/Object/Variable Declaration
    //@IBOutlet weak var txt: UITextField!
    
    @IBOutlet weak var txtProblem: GenericTextView!{
        didSet{
            self.txtProblem.txtDelegate = self
            self.txtProblem.type = "1"
        }
    }
    @IBOutlet weak var lblTextCount: MIGenericLabel!
    
    @IBOutlet weak var lblWhyAreYouReporting: MIGenericLabel!
    @IBOutlet weak var lblIThinkItsScam: MIGenericLabel!
    @IBOutlet weak var lblItsDuplicateList: MIGenericLabel!
    @IBOutlet weak var lblItsWrongCat: MIGenericLabel!
    @IBOutlet weak var lblOther: MIGenericLabel!
    
    @IBOutlet weak var btnSubmit: MIGenericButton!
    @IBOutlet weak var btnIThinkItsScam: MIGenericButton!
    @IBOutlet weak var btnItsDuplicateList: MIGenericButton!
    @IBOutlet weak var btnItsWrongCat: MIGenericButton!
    @IBOutlet weak var btnOther: MIGenericButton!
    
    var reportType : Int = 0
    var productId : Int = 0
    
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
        print("### deinit -> ProductReportVC")
    }
}

//MARK: - SetupUI
extension ProductReportVC {
    fileprivate func setupView() {
        
        self.title = CReportProductTitle
        
        lblWhyAreYouReporting.text = CWhyAreYouReporing
        lblIThinkItsScam.text = CIThinksItSpam
        lblItsDuplicateList.text = CItADuplicateList
        lblItsWrongCat.text = CItsInWrongCat
        lblOther.text = COtherText
        
        btnSubmit.setTitle(CForgotBtnSubmit, for: .normal)
        
        txtProblem.placeHolder = CWriteAboutYourProblem
        txtProblem.isScrollEnabled = true
        txtProblem.txtDelegate = self
        txtProblem.textLimit = "1500"
        lblTextCount.text = "0/\(txtProblem.textLimit ?? "0")"
        
        func setRadioButtonImage(_ sender:UIButton){
//            sender.setImage(UIImage(named: "ic_btn_radio_selected"), for: .selected)
//            sender.setImage(UIImage(named: "ic_btn_radio_unselected"), for: .normal)
            sender.setImage(UIImage(named: "ic_small_checkmark_selected"), for: .selected)
            sender.setImage(UIImage(named: "ic_small_checkmark_unselected"), for: .normal)
        }
        
        let arrButtons = [btnIThinkItsScam,btnItsDuplicateList,btnItsWrongCat,btnItsWrongCat,btnOther]
        arrButtons.forEach { [weak self] (sender) in
            guard let _ = self else {return}
            sender?.isSelected = false
            setRadioButtonImage(sender!)
        }
        btnIThinkItsScam.isSelected = true
        self.reportType = 1
    }
    
    fileprivate func isValidAllFields() -> Bool{
        if (txtProblem.text ?? "").trim.isEmpty && btnOther.isSelected{
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CBlankProductReportText, btnOneTitle: CBtnOk, btnOneTapped: nil)
            return false
        }
        return true
    }
}

//MARK: - IBAction / Selector
extension ProductReportVC {
    
    @IBAction func onSelectReasonPressed(_ sender: UIButton) {
        
        let arrButtons = [btnIThinkItsScam,btnItsDuplicateList,btnItsWrongCat,btnOther]
        arrButtons.forEach({$0?.isSelected = false})
        sender.isSelected = true
        if let index = arrButtons.index(of: sender as? MIGenericButton){
            self.reportType = (index + 1)
        }
        //1=>I think its a scam,2=>It’s a duplicate thing,3=>It’s in the wrong category,4=>Other
    }
    
    @IBAction func onSubmitPressed(_ sender: UIButton) {
       
        DispatchQueue.main.async {
            self.reportProductApi()
        }
//        self.reportProductApi()
//        if isValidAllFields(){
//            print("Ready for submit")
//            self.reportProductApi()
//        }
    }
}

//MARK: - API Function
extension ProductReportVC {
    
    func reportProductApi(){
        var para = [String : Any]()
        para["user_id"] = appDelegate.loginUser?.user_id.description
        para["product_id"] = productId.toString
        para["reported_reason"] = "nice quality"
        para["report_note"] = txtProblem.text ?? ""
        para["status_id"] = "1"
        
        APIRequest.shared().reportProduct(para: para) { [weak self](response, error) in
            //            guard let self = self else { return }
            if response != nil {
                GCDMainThread.async {
                    self?.navigationController?.popToRootViewController(animated: true)
                    if let metaInfo = response![CJsonMeta] as? [String : Any] {
                        CTopMostViewController.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CProductReport, btnOneTitle: CBtnOk, btnOneTapped: nil)
                    }
                }
            }else{
                let errorUserinfo = error?.userInfo["meta"] as? [String:Any] ?? [:]
                let message = errorUserinfo["message"] as?  [String:Any] ?? [:]
                let msg = message["message"] as? String ?? ""
                CTopMostViewController.presentAlertViewWithOneButton(alertTitle: "", alertMessage: msg, btnOneTitle: CBtnOk, btnOneTapped: nil)
                MILoader.shared.hideLoader()
            }
        }
    }
}

// MARK:-  --------- Generic UITextView Delegate
extension ProductReportVC : GenericTextViewDelegate{
    
    func genericTextViewDidChange(_ textView: UITextView, height: CGFloat){
        
        if textView == txtProblem{
            lblTextCount.text = "\(textView.text.count)/\(txtProblem.textLimit ?? "0")"
        }
    }
}
