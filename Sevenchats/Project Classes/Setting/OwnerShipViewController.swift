//
//  OwnerShipViewController.swift
//  Sevenchats
//
//  Created by nagaraju k on 01/08/22.
//  Copyright © 2022 mac-00020. All rights reserved.
//

import UIKit

class OwnerShipViewController: ParentViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func btnManageUserCLK(_ sender : UIButton){
        if let blockUserVC = CStoryboardSetting.instantiateViewController(withIdentifier: "ManageFrdsViewController") as? ManageFrdsViewController{
            self.navigationController?.pushViewController(blockUserVC, animated: true)
        }
        
    }
    
    
}
