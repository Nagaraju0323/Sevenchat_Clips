//
//  OnboardingCollectionView.swift
//  Sevenchats
//
//  Created by mac-0005 on 07/02/20.
//  Copyright © 2020 mac-0005. All rights reserved.
//

import UIKit

class OnboardingCollectionView: UICollectionView {
    
    var onChangePage: ((_ index: Int) ->Void)?
    var arrOnboarding: [OnboardingModel] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureCollectionView()
        configureOnboradingData()
    }
}

// MARK:- Configuratio
extension OnboardingCollectionView {
    
    private func configureCollectionView() {
        
        self.register(
            UINib(nibName: "OnboardingCell", bundle: nil),
            forCellWithReuseIdentifier: "OnboardingCell"
        )
        
        self.delegate = self
        self.dataSource = self
    }
    
    private func configureOnboradingData() {
        
        arrOnboarding = [
            OnboardingModel(title: C_1_Onboarding_title, description: C_1_Onboarding_Description, image: "ic_1_onboarding_new"),
            OnboardingModel(title: C_2_Onboarding_title, description: C_2_Onboarding_Description, image: "ic_2_onboarding_new"),
//            OnboardingModel(title: C_3_Onboarding_title, description: C_3_Onboarding_Description, image: "ic_3_onboarding"),
            OnboardingModel(title: C_4_Onboarding_title, description: C_4_Onboarding_Description, image: "ic_4_onboarding_new"),
            OnboardingModel(title: C_5_Onboarding_title, description: C_5_Onboarding_Description, image: "ic_5_onboarding_new"),
            OnboardingModel(title: C_6_Onboarding_title, description: C_6_Onboarding_Description, image: "ic_6_onboarding_new")
        ]
        
        self.reloadData()
        
    }
    
    func scrollToIndex(_ index: Int) {
        
        guard index < arrOnboarding.count else {
            return
        }
        
        let indexpath: IndexPath = IndexPath(item: index, section: 0)
        self.scrollToItem(at: indexpath, at: .centeredHorizontally, animated: true)
    }
}

//MARK:- Collection View Delegate and Data Source Methods
extension OnboardingCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrOnboarding.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingCell", for: indexPath) as? OnboardingCell else {
            return UICollectionViewCell(frame: .zero)
        }
        
        let onboardingModel: OnboardingModel = arrOnboarding[indexPath.item]
        cell.configureOnboardingCell(onboardingModel: onboardingModel)
        return cell
    }
}

//MARK:- UICollectionViewDelegateFlowLayout
extension OnboardingCollectionView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(
            width: collectionView.frame.size.width,
            height: collectionView.frame.size.height)
    }
}

extension OnboardingCollectionView {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        setCurrentImageCount()
    }
    
    func setCurrentImageCount() {
        
        var visibleRect = CGRect()
        visibleRect.origin = self.contentOffset
        visibleRect.size = self.bounds.size
        
        let visiblePoint = CGPoint(
            x: CGFloat(visibleRect.midX),
            y: CGFloat(visibleRect.midY)
        )
        
        guard let indexPath: IndexPath = self.indexPathForItem(at: visiblePoint),
            let onChangePage = onChangePage else {
                return
        }
        
        let index = indexPath.row
        onChangePage(index)
    }
}
