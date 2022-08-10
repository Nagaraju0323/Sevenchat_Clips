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
    
    
    @IBOutlet weak var deleteImg: UIImageView!
    
    @IBOutlet weak var deactiveImg: UIImageView!
    
    @IBOutlet weak var deactiveBtn: MIGenericButton!
    
    @IBOutlet weak var continueBtn: MIGenericButton!
    
    @IBOutlet weak var cancelBtn: MIGenericButton!
    
    
    var deactivebtnIsselected : Bool?
    var deletebtnselected : Bool?
    var deactbtnselected : Bool?
    var activate:Int = 0
    

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
    
    @IBAction func deleteActBtnCLK(_ sender:UIButton){
//        sender.isSelected = !sender.isSelected
//        deactiveBtn.isSelected = false
        
            if deactiveBtn.isSelected == true{
//                self.activate = 1
                print("::::::::NotccountSelect")
                deleteImg.image = UIImage(named: "dry-clean")
              } else {
                  // set selected
                  self.activate = 1
//
                  
              }
        
//        deactiveBtn.isSelected = !deactiveBtn.isSelected
  }
    
    
    @IBAction func deactiveBtnCLK(_ sender:UIButton){


        if deleteBtn.isSelected {
            deactivebtnIsselected = false
            deactiveImg.image = UIImage(named: "dry-clean")
            
        }else {
           
            deactivebtnIsselected = true
            if deleteBtn.tag == 0{
                deleteImg.image = UIImage(named: "dry-clean")
            }
            deactiveImg.image = UIImage(named: "checked-4")
        }
        
        deleteBtn.isSelected = !deleteBtn.isSelected
//        if sender.isSelected {
//
//
//        } else {
//
//
//
//
//        }
    }
    
    @IBAction func continueBtnCLK(_ sender : UIButton){
        
        //change languageHear
        if deactivebtnIsselected == true {
            let alert = UIAlertController(title: "", message: CSELECTCHOICE, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: CSIGNUPEMAILID, style: .default, handler: { (_) in
                self.userAccountDeactive()
            }))
            
            self.present(alert, animated: true, completion: nil)
        
        }else {
            if let blockUserVC = CStoryboardSetting.instantiateViewController(withIdentifier: "EnterPasswordViewController") as? EnterPasswordViewController{

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
            "userid": userid,
            "user_id": 2,
        ]
        APIRequest.shared().userAccountDeactivate(para: dict as [String : AnyObject]) { (response, error) in
            if response != nil && error == nil {
                DispatchQueue.main.async {
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
