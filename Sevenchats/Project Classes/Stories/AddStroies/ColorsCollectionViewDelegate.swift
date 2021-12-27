//
//  ColorsCollectionViewDelegate.swift
//  Sevenchats
//
//  Created by APPLE on 22/03/21.
//  Copyright © 2021 mac-00020. All rights reserved.
//

import Foundation
import UIKit

protocol ColorDelegate {
    func chosedColor(color: UIColor)
}

class ColorsCollectionViewDelegate: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var colorDelegate : ColorDelegate?
    
    let colors = [UIColor.black, UIColor.darkGray, UIColor.gray,
                  UIColor.lightGray, UIColor.white, UIColor.blue, UIColor.green, UIColor.red, UIColor.yellow,
                  UIColor.orange, UIColor.purple, UIColor.cyan, UIColor.brown, UIColor.purple]
    
    override init() {
        super.init()
    }
    
    var stickerDelegate : StickerDelegate?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        colorDelegate?.chosedColor(color: colors[indexPath.item])
    
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCollectionViewCell", for: indexPath) as! ColorCollectionViewCell
        cell.colorView.backgroundColor = colors[indexPath.item]
        cell.layer.cornerRadius = cell.frame.width / 2
        cell.layer.borderWidth = 2
        cell.layer.borderColor = UIColor.white.cgColor
        return cell
    }
    
}
