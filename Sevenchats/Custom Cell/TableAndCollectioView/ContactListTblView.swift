//
//  AddVehiclesCollView.swift
//  QAAR
//
//  Created by mac-00015 on 16/07/19.
//  Copyright © 2019 00017. All rights reserved.
//

import UIKit

class ContactListTblView: UITableView {

    //MARK:-
    //MARK:- ------- PRIVATE PROPERTIES
    private var arrUserNameList = ["User1", "User2", "User3", "User4", "User5", "User6", "User7", "User8", "User9", "sagar"]
    private let CContactListTblViewCell = "ContactListTblViewCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpView()
    }
}

// MARK:-
// MARK:- ------- General Functions
extension ContactListTblView {
    fileprivate func setUpView() {
        self.delegate = self
        self.dataSource = self
        //...Register Cell
        let nibName = UINib(nibName: CContactListTblViewCell, bundle: nil)
        self.register(nibName, forCellReuseIdentifier: CContactListTblViewCell)
    }
}

//MARK:-
//MARK:- ------- CollectionView Delegate & Datasources
extension ContactListTblView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrUserNameList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CContactListTblViewCell, for: indexPath) as? ContactListTblViewCell {
            cell.configData(userName: arrUserNameList[indexPath.item])

            cell.btnVideoCall.touchUpInside { [weak self] (button) in
                guard let _ = self else {return}
                /*if let videoViewVC = CStoryboardMain.instantiateViewController(withIdentifier: "ViewController") as? ViewController {
                    videoViewVC.userName1 = wkSelf.arrUserNameList[indexPath.row]
                    wkSelf.viewController?.navigationController?.present(videoViewVC, animated: true, completion: nil)
                }*/
            }
            
            cell.btnAudioCall.touchUpInside { (button) in
                print("audio")
               
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //let selectedName = arrUserNameList[indexPath.row]
    }
}
