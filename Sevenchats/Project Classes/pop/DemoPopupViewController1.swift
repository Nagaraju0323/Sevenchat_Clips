//
//  DemoPopupViewController1.swift
//  PopupController
//
//  Created by 佐藤 大輔 on 2/4/16.
//  Copyright © 2016 Daisuke Sato. All rights reserved.
//

import UIKit

class DemoPopupViewController1: UIViewController, PopupContentViewController {

    @IBOutlet weak var lblaccept: UILabel!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblRule1: UILabel!
    @IBOutlet weak var lblRule2: UILabel!
    
    @IBOutlet weak var lblrule6: UILabel!
    @IBOutlet weak var lblRule5: UILabel!
    @IBOutlet weak var lblRule4: UILabel!
    @IBOutlet weak var lblRule3: UILabel!
    @IBOutlet weak var imgCheck: UIImageView!
    var closeHandler: (() -> Void)?
    var isselectedHandler: ((String) -> Void)?
    var is_Select : Bool?
   

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.frame.size = CGSize(width: 300, height: 300)
        lblRule1.text = CRule_1
        lblRule2.text = CRule_2
        lblRule3.text = CRule_3
        lblRule4.text = CRule_4
        lblRule5.text = CRule_5
        lblrule6.text = CRule_6
        lblTitle.text = CAcceptRules
        lblaccept.text = CAcceptConditions
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    class func instance() -> DemoPopupViewController1 {
        let storyboard = UIStoryboard(name: "DemoPopupViewController1", bundle: nil)
        if let popupVC = storyboard.instantiateInitialViewController() as? DemoPopupViewController1 {
            return popupVC
        } else {
            fatalError("Unable to get storyboard")
        }
    }

    func sizeForPopup(_ popupController: PopupController, size: CGSize, showingKeyboard: Bool) -> CGSize {
        return CGSize(width: 400, height: 700)
    }

    @IBAction func tappedCloseButton(_ sender: AnyObject) {
        closeHandler?()
    }

    @IBAction func btnAcceptRules(_ sender: AnyObject) {
        if is_Select == true{
            print("signup")
//          let iamge = UIImage(named: "dry-clean")
//            imgCheck.image = iamge
            is_Select = false
        }else{
            print("accept rules")
            isselectedHandler?("true")
            NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil)
//            passwordviewController.Singup()
//            let iamge = UIImage(named: "checked-4")
//              imgCheck.image = iamge
            is_Select = true
       
        }
        
    }
}
