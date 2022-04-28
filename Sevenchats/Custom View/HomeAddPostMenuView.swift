//
//  HomeAddPostMenuView.swift
//  Sevenchats
//
//  Created by mac-0005 on 14/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

/*********************************************************
 * Author  : Nagaraju K and Chandrika R                                 *
 * Model   : HomeAddPostMenuView                         *
 * Description :                                         *
 *                                                       *
 ********************************************************/

import UIKit

let CMenuTitle = "title"
let CMenuImage = "image"

protocol PostTypeSelectionDelegate {
    func didSelectPostType(_ item : String)
}

class HomeAddPostMenuView: UIView {
    
    var delegate : PostTypeSelectionDelegate!

    @IBOutlet var tblPostMenu : UITableView!
    @IBOutlet var btnClose : UIButton!
    @IBOutlet var cntHeightTBl : NSLayoutConstraint!
    @IBOutlet var viewPopUp : UIView!
    
    let heightOfRow : CGFloat = 50.0;
    let boardHeight : CGFloat = 5
    var headerFooterHeight : CGFloat = 0;
    
    var arrPostMenu = [
        [CMenuTitle:CTypeArticle, CMenuImage : #imageLiteral(resourceName: "ic_shout_copywriting")],
        [CMenuTitle:CTypeChirpy, CMenuImage : #imageLiteral(resourceName: "ic_shout_bird")],
        [CMenuTitle:CTypeEvent, CMenuImage : #imageLiteral(resourceName: "ic_shout_events")],
        [CMenuTitle:CTypeForum, CMenuImage : #imageLiteral(resourceName: "ic_shout_discussion")],
        [CMenuTitle:CGallery, CMenuImage : #imageLiteral(resourceName: "ic_shout_gallery")],
        [CMenuTitle:CTypePoll, CMenuImage : #imageLiteral(resourceName: "ic_shout_poll")],
        [CMenuTitle:CTypeShout, CMenuImage : #imageLiteral(resourceName: "ic_shout")]
    ]
    
    
    class func initHomeAddPostMenuView() -> HomeAddPostMenuView{
        let objHomeAddPostView : HomeAddPostMenuView = Bundle.main.loadNibNamed("HomeAddPostMenuView", owner: nil, options: nil)?.last as! HomeAddPostMenuView
        objHomeAddPostView.frame = CGRect(x: 0, y: 0, width: CScreenWidth, height: CScreenHeight)
        return objHomeAddPostView
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //HomeAddPostTblCell
        
        self.headerFooterHeight = 0 + self.boardHeight
        self.tblPostMenu.register(UINib(nibName: "HomeAddPostTblCell", bundle: nil), forCellReuseIdentifier: "HomeAddPostTblCell")
        self.tblPostMenu.delegate = self
        self.tblPostMenu.dataSource = self
        self.tblPostMenu.separatorStyle = .none
        self.cntHeightTBl.constant = (self.heightOfRow * CGFloat(self.arrPostMenu.count) + (headerFooterHeight * 2))
        
        viewPopUp.layer.cornerRadius = 8
        viewPopUp.layer.borderWidth = boardHeight
        viewPopUp.layer.borderColor = UIColor.black.withAlphaComponent(0.4).cgColor
        //viewPopUp.backgroundColor = .clear
        viewPopUp.clipsToBounds = true
     
        _ = self.viewPopUp.setConstraintConstant(CScreenWidth, edge: .leading, ancestor: true)
        _ = self.viewPopUp.setConstraintConstant(-CScreenWidth, edge: .trailing, ancestor: true)
        _ = self.btnClose.setConstraintConstant(-100, edge: .bottom, ancestor: true)
        GCDMainThread.async {
        }
    }
    
    func showPostOption(){
        GCDMainThread.async {
            UIView.animate(withDuration: 0.3, animations: {
                //_ = self.tblPostMenu.setConstraintConstant(20, edge: .leading, ancestor: true)
                _ = self.viewPopUp.setConstraintConstant(-5, edge: .trailing, ancestor: true)
                _ = self.btnClose.setConstraintConstant(60, edge: .bottom, ancestor: true)
                self.tblPostMenu.reloadData()
                self.layoutIfNeeded()
            }, completion: { (completed) in
                
            })
        }
    }

    // MARK:- -----------Action Event
    @IBAction func btnCloseCLK(_ sender : UIButton){
        UIView.animate(withDuration: 0.3, animations: {
            _ = self.viewPopUp.setConstraintConstant(CScreenWidth, edge: .leading, ancestor: true)
            _ = self.viewPopUp.setConstraintConstant(-CScreenWidth, edge: .trailing, ancestor: true)
            _ = self.btnClose.setConstraintConstant(-100, edge: .bottom, ancestor: true)
        }) { (completed) in
            self.removeFromSuperview()
            self.delegate.didSelectPostType("100")
        }
    }
}

// MARK:- -----------UITableView Datasources/Delegate
extension HomeAddPostMenuView : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerFooterHeight
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return headerFooterHeight
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightOfRow
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrPostMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomeAddPostTblCell") as? HomeAddPostTblCell else {
            return UITableViewCell.init(frame: .zero)
        }
        let dicData = arrPostMenu[indexPath.row]
        cell.lblTitle.text = dicData.valueForString(key: CMenuTitle)
        cell.imgPost.image = dicData[CMenuImage] as? UIImage
//        cell.imgPost.tintColor = UIColor(red: 217, green: 211, blue: 211, alpha: 1.0)
        cell.lblSeperater.isHidden = false
        if indexPath.row == (arrPostMenu.count - 1){
            cell.lblSeperater.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.removeFromSuperview()
        let dicData = arrPostMenu[indexPath.row]
        self.delegate.didSelectPostType(dicData.valueForString(key: CMenuTitle))
    }
}

// MARK:- -----------UICollectionView Datasources/Delegate
extension HomeAddPostMenuView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arrPostMenu.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width:(collectionView.frame.size.width - 20)/3, height: (collectionView.frame.size.height - 20)/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeAddPostCollCell", for: indexPath) as! HomeAddPostCollCell
        
        let dicData = arrPostMenu[indexPath.row]
        cell.lblTitle.text = dicData.valueForString(key: CMenuTitle)
        cell.imgPost.image = dicData[CMenuImage] as? UIImage
//        cell.imgPost.tintColor = UIColor(red: 217, green: 211, blue: 211, alpha: 1.0)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.removeFromSuperview()
        //self.delegate.didSelectPostType(indexPath.item)
    }
    
}
