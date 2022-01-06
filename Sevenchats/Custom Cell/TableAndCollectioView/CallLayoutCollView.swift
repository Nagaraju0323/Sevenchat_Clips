////
////  CallLayoutCollView.swift
////  VideoCallCollectionLayoutDemo
////
////  Created by mac-00013 on 01/10/19.
////  Copyright © 2019 swift. All rights reserved.
////
//
//import UIKit
//import TwilioVideo
//
//
//class CallLayoutCollView: UICollectionView {
//    
//    //var arrVideoCallViews = [VideoView()]
//    var arrParticipaint : [AppParticipant] = []
//    let padding : CGFloat = 0
//    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        self.setUpCollView()
//    }
//}
//
////MARK:- General Methods
////MARK:-
//extension CallLayoutCollView {
//    
//    fileprivate func setUpCollView() {
//        
//        self.delegate = self
//        self.dataSource = self
//        self.isScrollEnabled = true
//        self.register(UINib(nibName: "VideoCallCell", bundle: nil), forCellWithReuseIdentifier: "VideoCallCell")
//    }
//}
//
////MARK:- CollectionView Delegate & DataSource
////MARK:-
//extension CallLayoutCollView: UICollectionViewDelegate, UICollectionViewDataSource {
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return self.arrParticipaint.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        
//        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCallCell", for: indexPath) as? VideoCallCell {
//            cell.videoCellModel = self.arrParticipaint[indexPath.row]
//            cell.invalidateIntrinsicContentSize()
//            return cell
//        }
//        return UICollectionViewCell()
//    }
//}
//
//
//extension CallLayoutCollView: UICollectionViewDelegateFlowLayout {
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//    
//        if self.arrParticipaint.count == 1 {
//            return CGSize(width: collectionView.frame.width - padding, height: collectionView.frame.height - padding)
//        } else if self.arrParticipaint.count == 2 {
//            return CGSize(width: collectionView.frame.width - padding, height: ((collectionView.frame.height) / 2) - padding)
//        } else if self.arrParticipaint.count % 2 == 0 {
//            if self.arrParticipaint.count == 4{
//                return CGSize(width: ((collectionView.frame.width) / 2) - padding, height: ((collectionView.frame.height) / 2) - padding)
//            }
//            return CGSize(width: ((collectionView.frame.width) / 2) - padding , height: ((collectionView.frame.width) * 0.65) - padding)
//        } else {
//            
//            if indexPath.item == self.arrParticipaint.count - 1 {
//                if self.arrParticipaint.count == 3{
//                    return CGSize(width: (collectionView.frame.width) - padding, height: ((collectionView.frame.height) / 2) - padding)
//                }
//                return CGSize(width: (collectionView.frame.width) - padding, height: ((collectionView.frame.width) * 0.65) - padding)
//            }
//            if self.arrParticipaint.count == 3{
//                return CGSize(width: (collectionView.frame.width / 2) - padding, height: ((collectionView.frame.height) / 2) - padding)
//            }
//            return CGSize(width: ((collectionView.frame.width) / 2) - padding, height: ((collectionView.frame.width) * 0.65) - padding)
//        }
//        
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
////        return padding / 2
//        return 10
//    }
//    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
////        return padding / 2
//        return 10
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets.init(top: padding / 2, left: padding / 2 , bottom: padding / 2, right: padding / 2)
//    }
//}
//
