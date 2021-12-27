//
//  AdvertiseView.swift
//  Social Media
//
//  Created by mac-0005 on 06/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit
import AVKit

class AdvertiseView: UIView {
    
    @IBOutlet weak var btnCloseAdd : UIButton!{
        didSet{
            btnCloseAdd.isHidden = true
        }
    }
    @IBOutlet weak var clAdvertise : UICollectionView! {
        didSet {
            clAdvertise.register(UINib(nibName: "AdvertiseCollCell", bundle: nil), forCellWithReuseIdentifier: "AdvertiseCollCell")
        }
    }
    
    var arrAddList = [TblAdvertise]()
    override func awakeFromNib() {
        super.awakeFromNib()
        self.startInfinityTimer()
    }
}

// MARK:- --------- UICollectionView Delegate/Datasources
// MARK:-
extension AdvertiseView {
    func initialization(_ arrAdd: [TblAdvertise]) {
        arrAddList = arrAdd
        clAdvertise.reloadData()
    }
}

// MARK:- --------- UICollectionView Delegate/Datasources
// MARK:-
extension AdvertiseView {
    func startInfinityTimer () {
        var second = 0
        var secondIncreament = 0
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            secondIncreament = secondIncreament + 1
            if secondIncreament%5 == 0 {
                second = second + 1
                if second > self.arrAddList.count-1 {
                    second = 0
                }
                
                if self.arrAddList.count > 0 {
                    self.clAdvertise.scrollToItem(at: IndexPath(item: second, section: 0), at: .centeredHorizontally, animated: true)
                }
                
            }
        }
    }
}

// MARK:- --------- UICollectionView Delegate/Datasources
// MARK:-
extension AdvertiseView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrAddList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:CScreenWidth, height: collectionView.frame.size.height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AdvertiseCollCell", for: indexPath) as? AdvertiseCollCell {
            let addInfo = arrAddList[indexPath.row]
            cell.imgAdd.loadImageFromUrl(addInfo.ads_image, false)
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let addInfo = arrAddList[indexPath.row]
        if addInfo.display_type == 1 {
            // not interactive
            return
        }
        
        if addInfo.interactive_type == 4 {
            // Play Advertise Video
            self.avPlayerSetup(URL(string: addInfo.interactive_value ?? ""))
        }else {
            if let addVC = CStoryboardHome.instantiateViewController(withIdentifier: "AdvertiseViewController") as? AdvertiseViewController {
                addVC.iObject = addInfo
                self.viewController?.present(addVC, animated: true, completion: nil)
            }
        }
    }
}

// MARK:- ------AVPlayer
// MARK:-
extension AdvertiseView {
    func avPlayerSetup(_ videoUrl: URL?) {
        
        if let url =  videoUrl {
            let player = AVPlayer(url: url)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            
            self.viewController?.present(playerViewController, animated: true) {
                playerViewController.player!.play()
            }
        }
    }
}
