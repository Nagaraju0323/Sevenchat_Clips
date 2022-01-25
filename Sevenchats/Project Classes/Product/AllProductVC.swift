//
//  AllProductVC.swift
//  SocialMedia
//
//  Created by mac-00020 on 27/08/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Chandrika.R                                 *
 * Model   : RestrictedFilesVC                           *
 * Changes :                                             *
 *                                                       *
 ********************************************************/

import Foundation
import UIKit

class AllProductList: UIViewController {
    
    //MARK: - IBOutlet/Object/Variable Declaration
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
        print("### deinit -> AllProductVC")
    }
}

//MARK: - SetupUI
extension AllProductList {
    fileprivate func setupView() {
    }
}

//MARK: - IBAction / Selector
extension AllProductList {
    
    @IBAction func on(_ sender: UIButton) {
        
    }
}


    
