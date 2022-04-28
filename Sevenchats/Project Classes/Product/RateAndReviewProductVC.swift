//
//  RateAndReviewProductVC.swift
//  Sevenchats
//
//  Created by mac-00020 on 27/08/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Nagaraju K and Chandrika R                                 *
 * Model   : RestrictedFilesVC                           *
 * Changes :                                             *
 *                                                       *
 ********************************************************/

import Foundation
import UIKit
import Cosmos

class RateAndReviewProductVC: ParentViewController {
    
    //MARK: - IBOutlet/Object/Variable Declaration
    @IBOutlet weak var lblYourRating: MIGenericLabel!
    @IBOutlet weak var vwRating: CosmosView!
    @IBOutlet weak var txtReview: GenericTextView!
    @IBOutlet weak var lblTextCount: MIGenericLabel!
    
    @IBOutlet weak var btnSubmit: MIGenericButton!
    
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
        print("### deinit -> RateAndReviewProductVC")
    }
}

//MARK: - SetupUI
extension RateAndReviewProductVC {
   
    fileprivate func setupView() {
        
        self.title = CRateAndReviewTitle
        
        lblYourRating.text = CYourRating
        txtReview.placeHolder = CPlaceholderAddYourReview
        txtReview.isScrollEnabled = true
        txtReview.txtDelegate = self
        txtReview.textLimit = "1500"
        lblTextCount.text = "0/\(txtReview.textLimit ?? "0")"
        lblTextCount.text = txtReview.textLimit
        
        btnSubmit.setTitle(CForgotBtnSubmit, for: .normal)
    }
    
    fileprivate func isValidAllFields() -> Bool{
        if (txtReview.text ?? "").trim.isEmpty{
            self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CBlankReviewText, btnOneTitle: CBtnOk, btnOneTapped: nil)
            return false
        }
        return true
    }
}

//MARK: - IBAction / Selector
extension RateAndReviewProductVC {
    
    @IBAction func onSubmitPressed(_ sender: UIButton) {
        if isValidAllFields(){
            print("Ready for submit")
        }
    }
}

// MARK:-  --------- Generic UITextView Delegate
extension RateAndReviewProductVC: GenericTextViewDelegate{
    
    func genericTextViewDidChange(_ textView: UITextView, height: CGFloat){
        
        if textView == txtReview{
            lblTextCount.text = "\(textView.text.count)/\(txtReview.textLimit ?? "0")"
        }
    }
}
