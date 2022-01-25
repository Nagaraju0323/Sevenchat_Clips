//
//  EventInviteesAcceptedTblCell.swift
//  Sevenchats
//
//  Created by mac-00020 on 30/05/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Chandrika.R                                 *
 * Model   : RestrictedFilesVC                           *
 * Description :  EventInviteesAcceptedTblCell           *
 *                                                       *
 ********************************************************/

import UIKit

class EventInviteesAcceptedTblCell: UITableViewCell {

    var arrInvitedUser : [[String : Any]]!{
        didSet{
            collVInvitees.reloadData()
        }
    }
    
    var viewAllInvitees : (()->Void)?
    
    @IBOutlet weak var collVInvitees : UICollectionView!{
        didSet{
            collVInvitees.register(UINib(nibName: "EventInviteesAcceptedCollCell", bundle: nil), forCellWithReuseIdentifier: "EventInviteesAcceptedCollCell")
            collVInvitees.isPagingEnabled = false
            collVInvitees.delegate = self
            collVInvitees.dataSource = self
            collVInvitees.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

//MARK:- Collection View Delegate and Data Source Methods
extension EventInviteesAcceptedTblCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let height = collectionView.bounds.height
        let width = (collectionView.bounds.width - (10 * 8))
        let numOfCell = Int(width / height)
        if arrInvitedUser.count > numOfCell {
            return numOfCell
        }
        return arrInvitedUser.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventInviteesAcceptedCollCell", for: indexPath) as? EventInviteesAcceptedCollCell else {
            return UICollectionViewCell(frame: .zero)
        }
        
        cell.updateLayout()
        cell.layoutIfNeeded()
        cell.imgVUserProfile.layer.cornerRadius = cell.imgVUserProfile.bounds.height / 2
        cell.imgVUserProfile.clipsToBounds = true
        cell.imgVUserProfile.layoutIfNeeded()
        let userInfo = arrInvitedUser[indexPath.row]
        cell.imgVUserProfile.backgroundColor = .white
        /*var index : Int = 6
        if arrInvitedUser.count <= 7{
           index = arrInvitedUser.count - 1
        }*/
        let height = collectionView.bounds.height
        let width = (collectionView.bounds.width - (10 * 8))
        let numOfCell = Int(width / height)
       if indexPath.row == (numOfCell - 1){
            cell.imgVUserProfile.image = UIImage(named:"ic_more_Invitees")
            cell.imgVUserProfile.backgroundColor = .lightGray
        }else{
            cell.imgVUserProfile.loadImageFromUrl(userInfo.valueForString(key: CUserProfileImage), true)
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let height = collectionView.bounds.height
        let width = (collectionView.bounds.width - (10 * 8))
        let numOfCell = Int(width / height)
        /*var index : Int = 6
        if arrInvitedUser.count <= 7{
            index = arrInvitedUser.count - 1
        }*/
        if indexPath.row == (numOfCell - 1){
            viewAllInvitees?()
        }
    }
}

//MARK:- UICollectionViewDelegateFlowLayout
extension EventInviteesAcceptedTblCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.bounds.height
        /*var width = collectionView.bounds.width
        width =  width / 7*/
        return CGSize(width: Int(height), height: Int(height))
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
        //return UIEdgeInsets.init(top: 10, left: 0, bottom: 10, right: 0)
    }
}

