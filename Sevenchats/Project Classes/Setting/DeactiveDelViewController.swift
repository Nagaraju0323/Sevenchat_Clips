//
//  DeactiveDelViewController.swift
//  Sevenchats
//
//  Created by nagaraju k on 01/08/22.
//  Copyright © 2022 mac-00020. All rights reserved.
//

import UIKit

class DeactiveDelViewController: ParentViewController {
    
    @IBOutlet weak var deleteBtn: MIGenericButton!
    
    @IBOutlet weak var deactiveBtn: MIGenericButton!
    
    @IBOutlet weak var continueBtn: MIGenericButton!
    
    @IBOutlet weak var cancelBtn: MIGenericButton!
    
    @IBOutlet weak var deleteImg: UIImageView!
    
    @IBOutlet weak var deactiveImg: UIImageView!
    
    
    
    
    var deactivebtnIsselected : Bool?
    var deletebtnselected : Bool?
    var deactbtnselected : Bool?
    var activate:Int = 0
    var userDetails = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Intilization()
        
        // Do any additional setup after loading the view.
    }
    
    func Intilization(){
        
        self.continueBtn.isHidden = true
        self.cancelBtn.isHidden = true
    }
    
    //MARK :- @IBAction Delete & Deacvivate
    
    @IBAction func deactiveDeleBtnCLK(_ sender:UIButton){
        
        self.continueBtn.isHidden = false
        self.cancelBtn.isHidden = false
        if(sender.tag == 0){
            deactivebtnIsselected = true
            deactiveBtn.isSelected = true
            deleteBtn.isSelected = false
            deactiveImg.image = UIImage(named: "checked-4")
            deleteImg.image = UIImage(named: "dry-clean")
            
        }
        else if(sender.tag == 1){
            deactivebtnIsselected = false
            deleteBtn.isSelected = true
            deactiveBtn.isSelected = false
            deleteImg.image = UIImage(named: "checked-4")
            deactiveImg.image = UIImage(named: "dry-clean")
        }
    }
    
    @IBAction func continueBtnCLK(_ sender : UIButton){
        
        //change languageHear
        if deactivebtnIsselected == true {
            let alert = UIAlertController(title: "", message: CSELECTCHOICE, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: CSIGNUPEMAILID, style: .default, handler: { (_) in
                self.userAccountDeactive()
            }))
            alert.addAction(UIAlertAction(title: CBtnCancel, style: .default, handler: { (_) in
                alert.dismiss(animated: true, completion: nil)
            }))
            
            self.present(alert, animated: true, completion: nil)
            
        }else {
            if let blockUserVC = CStoryboardSetting.instantiateViewController(withIdentifier: "EnterPasswordViewController") as? EnterPasswordViewController{
                if (appDelegate.loginUser?.email?.description != ""){
                    userDetails = appDelegate.loginUser?.email?.description ?? ""
                }else if (appDelegate.loginUser?.mobile?.description != ""){
                    userDetails = appDelegate.loginUser?.mobile?.description ?? ""
                }
                blockUserVC.userData = userDetails.description
                self.navigationController?.pushViewController(blockUserVC, animated: true)
            }
        }
        
    }
    
    @IBAction func cancelBtnCLK(_ sender : UIButton){
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
    
}

extension DeactiveDelViewController{
    
    func userAccountDeactive(){
        let userid = appDelegate.loginUser?.user_id.description ?? ""
        let dict:[String:Any] = [
            "user_id": userid,
            "type": "2",
        ]
        APIRequest.shared().userAccountDeactivate(para: dict as [String : AnyObject]) { (response, error) in
            if response != nil && error == nil {
                DispatchQueue.main.async {
//                    appDelegate.logOut()
                    let loginViewController = CStoryboardLRF.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
                    UIApplication.shared.keyWindow?.rootViewController = loginViewController
                }
            }else {
                //change LanguageHear
                guard  let errorUserinfo = error?.userInfo["error"] as? String else {return}
                let errorMsg = errorUserinfo.stringAfter(":")
                self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CMessageEmailExists, btnOneTitle: CBtnOk, btnOneTapped: nil)
            }
        }
    }
    
    
}
