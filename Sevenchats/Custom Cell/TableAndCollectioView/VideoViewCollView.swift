//
//  AddVehiclesCollView.swift
//  QAAR
//
//  Created by mac-00015 on 16/07/19.
//  Copyright © 2019 00017. All rights reserved.
//

import UIKit

class VideoViewCollView: UICollectionView {

    //MARK:-
    //MARK:- ------- PROPERTIES

//    var arrOtherImages = [UIImage(named: "nature1"), UIImage(named: "nature1"), UIImage(named: "nature1"), UIImage(named: "nature1"), UIImage(named: "nature1"), UIImage(named: "nature1"), UIImage(named: "nature1"), UIImage(named: "nature1"), UIImage(named: "nature1"), UIImage(named: "nature1"), UIImage(named: "nature1"), UIImage(named: "nature1"), UIImage(named: "nature1")]
    
    var arrOtherImages = ["nature1", "nature1", "nature1", "nature1", "nature1", "nature1", "nature1", "nature1", "nature1"]
    
    let cAddImagesCollViewCell = "VideoViewCollViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpView()
    }
}

// MARK:-
// MARK:- ------- General Functions
extension VideoViewCollView {
    fileprivate func setUpView() {
        self.delegate = self
        self.dataSource = self
        //...Register Cell
        let nibName = UINib(nibName: "VideoViewCollViewCell", bundle: nil)
        self.register(nibName, forCellWithReuseIdentifier: cAddImagesCollViewCell)
    }
}

//MARK:-
//MARK:- ------- CollectionView Delegate & Datasources
extension VideoViewCollView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // This ternary is used for only two collectionView (if 101 & else 102) if you have any 3rd than please reamove ternary & use switch case
       return arrOtherImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //here else condition is used only for collectionView.tag == 102
        
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cAddImagesCollViewCell, for: indexPath) as? VideoViewCollViewCell {
                cell.configData(imageStr: arrOtherImages[indexPath.item] )
                return cell
            }
        return UICollectionViewCell()
        }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

//MARK:-
//MARK:- ------- Collection View FlowLayout
extension VideoViewCollView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let cellHeight = collectionView.frame.size.height / 3
        let cellHeight = collectionView.frame.size.height / 3
        let cellWeight = collectionView.frame.size.width
        return CGSize(width: cellWeight, height:cellHeight)
    }
}
