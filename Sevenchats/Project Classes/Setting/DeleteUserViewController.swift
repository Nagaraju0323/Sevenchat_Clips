//
//  DeleteUserViewController.swift
//  Sevenchats
//
//  Created by nagaraju k on 01/08/22.
//  Copyright © 2022 mac-00020. All rights reserved.
//

import UIKit

class DeleteUserViewController: ParentViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Account ownership and control"
        // Do any additional setup after loading the view.
    }
    

    @IBAction func btnMemoUserCLK(_ sender : UIButton){
        if let blockUserVC = CStoryboardSetting.instantiateViewController(withIdentifier: "OwnerShipViewController") as? OwnerShipViewController{
            self.navigationController?.pushViewController(blockUserVC, animated: true)
        }
        
    }
    
    @IBAction func btnDeleteUserCLK(_ sender : UIButton){
        if let blockUserVC = CStoryboardSetting.instantiateViewController(withIdentifier: "OwnerShipViewController") as? OwnerShipViewController{
            self.navigationController?.pushViewController(blockUserVC, animated: true)
        }
        
    }

}
