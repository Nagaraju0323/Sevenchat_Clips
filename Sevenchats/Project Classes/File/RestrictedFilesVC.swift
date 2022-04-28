//
//  RestrictedFilesVC.swift
//  Sevenchats
//
//  Created by mac-00020 on 01/07/19.
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

class RestrictedFilesVC: ParentViewController {
    
    //MARK: - IBOutlet/Object/Variable Declaration
    @IBOutlet weak var tblFiles: UITableView!{
        didSet{
            tblFiles.tableFooterView = UIView(frame: .zero)
            tblFiles.separatorStyle = .none
            tblFiles.register(UINib(nibName: "RestrictedFileTblCell", bundle: nil), forCellReuseIdentifier: "RestrictedFileTblCell")
            tblFiles.delegate = self
            tblFiles.dataSource = self
        }
    }
    
    /// List of extension are added from server for restriction file
    var arrDatasource : [MDLRestractedFile] = []
    
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
        print("### deinit -> RestrictedFilesVC")
    }
}

//MARK: - SetupUI
extension RestrictedFilesVC {
    fileprivate func setupView() {
        self.title = CRestrictedFile
    }
}

//MARK: - SetupUI
extension RestrictedFilesVC : UITableViewDelegate, UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrDatasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RestrictedFileTblCell", for: indexPath) as? RestrictedFileTblCell else{
            return UITableViewCell(frame: .zero)
        }
        cell.data = arrDatasource[indexPath.row]
        return cell
    }
}
