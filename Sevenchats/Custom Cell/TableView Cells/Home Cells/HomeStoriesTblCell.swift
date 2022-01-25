//
//  HomeStoriesTblCell.swift
//  Sevenchats
//
//  Created by APPLE on 08/03/21.
//  Copyright © 2021 mac-00020. All rights reserved.
//
/*********************************************************
 * Author  : Chandrika.R                                 *
 * Model   : HomeStoriesTblCell                          *
 * Changes : HomeStoriesTblCell                          *
 *                                                       *
 ********************************************************/

import UIKit

class HomeStoriesTblCell: UITableViewCell {
    
    @IBOutlet weak var postStoriesCl: UICollectionView!
    @IBOutlet weak var ViewMainContainer: UIView!
    var userDetails: [UserDetails] = []
    
    let arrayvalues2 = ["ravi","chandu","divya","rahul","madhu","naveen","royal","sonyy","chinna","sagar"]
    let arrayvalues1 = ["sunil"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        postStoriesCl.delegate = self
        postStoriesCl.dataSource = self
        self.postStoriesCl.register(UINib(nibName: "MyStoriesCollCell", bundle: nil), forCellWithReuseIdentifier: "MyStoriesCollCell")
        self.postStoriesCl.register(UINib(nibName: "PostStoriesCollCell", bundle: nil), forCellWithReuseIdentifier: "PostStoriesCollCell")
        GCDMainThread.async {
            self.ViewMainContainer.layer.cornerRadius = 8
            self.ViewMainContainer.layer.masksToBounds = false
            self.ViewMainContainer.shadow(color: CRGB(r: 230, g: 235, b: 239), shadowOffset: CGSize(width: 0, height: 3), shadowRadius: 2.5, shadowOpacity: 2)
        }
        
        self.fetchUserData()
        
    }
  
    // MARK: Private func
    private func fetchUserData() {
        let path = Bundle.main.path(forResource: "user-details", ofType: "json")
        let data = NSData(contentsOfFile: path ?? "") as Data?
        do {
            let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
            if let aUserDetails = json["userDetails"] as? [[String : Any]] {
                for element in aUserDetails {
                    userDetails += [UserDetails(userDetails: element)]
                }
            }
        } catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
        }
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

//MARK: ----- Post Stories Delegate Data Source
extension HomeStoriesTblCell:UICollectionViewDelegate,UICollectionViewDataSource{
    
    private func numberOfSectionsInCollectionView(collectionView: UICollectionView!) -> Int{
        return 2
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0{
            return 0
        }else {
            return arrayvalues2.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyStoriesCollCell", for: indexPath) as? MyStoriesCollCell else { fatalError() }
            return cell
        }else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostStoriesCollCell",for: indexPath) as? PostStoriesCollCell else { fatalError() }
            cell.lblUserName.text = arrayvalues2[indexPath.row]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row == 0{
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Stories", bundle:nil)
//            let Vc = storyBoard.instantiateViewController(withIdentifier: "showCameraViewController") as? showCameraViewController
//            self.navigationController?.pushViewController(Vc, animated: true)
            
            
            if let vc = storyBoard.instantiateViewController(withIdentifier: "showCameraViewController") as? showCameraViewController {
                vc.modalPresentationStyle = .overFullScreen
                self.viewController?.present(vc, animated: true, completion: nil)
            }

            
        }else {
            DispatchQueue.main.async {
                if let vc = CStoryboardHome.instantiateViewController(withIdentifier: "ContentView") as? ContentViewController {
                    vc.modalPresentationStyle = .overFullScreen
                    vc.pages = self.userDetails
                    vc.currentIndex = indexPath.row
                    self.viewController?.present(vc, animated: true, completion: nil)
                }
            }
        }
    }
    
}
extension HomeStoriesTblCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.row == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyStoriesCollCell", for: indexPath) as? MyStoriesCollCell else { fatalError() }
            let size: CGSize = cell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            //            return CGSize(width: size.width, height: 100)
            
            return CGSize(width: 65, height: 100)
            
        }else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostStoriesCollCell",for: indexPath) as? PostStoriesCollCell else { fatalError()}
            let size: CGSize = cell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            return CGSize(width: 65, height: 100)
            //            return CGSize(width: size.width, height: (size.width) - 10)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
}


