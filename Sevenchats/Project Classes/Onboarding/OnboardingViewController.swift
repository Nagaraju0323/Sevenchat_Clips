//
//  OnboardingViewController.swift
//  Sevenchats
//
//  Created by mac-0005 on 07/02/20.
//  Copyright © 2020 mac-0005. All rights reserved.
//

import UIKit

class OnboardingViewController: ParentViewController {
    
    @IBOutlet var clOnboarding: OnboardingCollectionView!
    @IBOutlet var pageControl: UIPageControl!
    
    @IBOutlet var btnSkip: MIGenericButton! {
        didSet {
            btnSkip.layer.cornerRadius = 5.0
            btnSkip.setTitle(CBtnSkip, for: .normal)
        }
    }
    
    @IBOutlet var btnNext: MIGenericButton!{
        didSet {
            btnNext.layer.cornerRadius = 5.0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurePageControl()
        configureCollectionView()
        configureNextButton()
        
        AppUpdateManager.shared.checkForUpdate()
    }
    
    deinit {
        print("deinit == OnboardingViewController ")
    }
    
}

// MARK:- Configure CollectionView -
extension OnboardingViewController {
    
    private func configureNextButton() {
        if isLastPage() {
            btnNext.setTitle(CBtnDone, for: .normal)
        } else {
            btnNext.setTitle(CBtnNext, for: .normal)
        }
    }
    
    func isLastPage() -> Bool {
        guard let _clOnboarding = clOnboarding else {
            return false
        }
        let currentIndex = self.pageControl.currentPage
        return (currentIndex == _clOnboarding.arrOnboarding.count - 1)
    }
}

// MARK:- Configure CollectionView -
extension OnboardingViewController {
    
    private func configureCollectionView() {
        
        guard let `clOnboarding` = clOnboarding else {
            return
        }
        
        clOnboarding.onChangePage = { [weak self] (index: Int) in
            
            guard let self = self else {
                return
            }
            self.pageControl.currentPage = index
            self.configureNextButton()
        }
    }
    
}


// MARK:- Page Control -
extension OnboardingViewController {
 
    private func configurePageControl() {
        
        guard let _clOnboarding = clOnboarding else {
            return
        }
        pageControl.currentPage = 0
        pageControl.numberOfPages = _clOnboarding.arrOnboarding.count
    }
}

// MARK:- Action Event -
extension OnboardingViewController {
    
    @IBAction func onSkipClick(_ sender: MIGenericButton) {
        
        CUserDefaults.setValue(true, forKey: UserDefaultViewedOnboarding)
        CUserDefaults.synchronize()
        appDelegate.initLoginViewController()
    }
    
    @IBAction func onNextClick(_ sender: MIGenericButton) {
        
        if isLastPage() {
            onSkipClick(btnSkip)
        } else {
            let currentIndex: Int = self.pageControl.currentPage + 1
            clOnboarding.scrollToIndex(currentIndex)
        }
    }
}
