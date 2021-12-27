//
//  ForwardPageViewController.swift
//  Sevenchats
//
//  Created by mac-00012 on 30/04/20.
//  Copyright © 2020 mac-00020. All rights reserved.
//

import UIKit

protocol ForwardPageViewControllerDelegate : class {
    func changedController(index:Int)
}

class ForwardPageViewController: UIPageViewController {

    weak var mForwardDelegate : ForwardPageViewControllerDelegate?
    //MARK: - IBOutlet/Object/Variable Declaration
    var orderedViewControllers: [UIViewController] = [UIViewController]()
    var currentIndex : Int = 0
    var txtSearch = ""
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialization()
    }
    
    deinit {
        print("### Deinit -> ForwardPageViewController")
    }
}

// MARK: -
extension ForwardPageViewController {
    fileprivate func initialization() {
        
        self.dataSource = self
        self.delegate = self
        
        for recognizer in self.gestureRecognizers{
            recognizer.isEnabled = false
        }
    }
    
    func config(controllers :[UIViewController]){
        self.orderedViewControllers = controllers
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func setViewControllerAt(index:Int) {
        
        guard index < orderedViewControllers.count else {
            return
        }
        var direction = UIPageViewController.NavigationDirection.forward
        if currentIndex > index {
            direction = UIPageViewController.NavigationDirection.reverse
        }
        currentIndex = index
        setViewControllers([orderedViewControllers[index]],direction: direction,animated: true,completion: nil)
    }
    
    func changedController(index:Int){
        mForwardDelegate?.changedController(index: index)
    }
    
   
}

//MARK: - UIPageViewControllerDelegate,UIPageViewControllerDataSource
extension ForwardPageViewController : UIPageViewControllerDelegate,UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if completed {
            guard let vc = self.viewControllers?.last else { return }
            if let index = self.orderedViewControllers.firstIndex(where: { $0 == vc }) {
                currentIndex = index
                changedController(index: index)
            }
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController ) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        // User is on the first view controller and swiped left to loop to
        // the last view controller.
        guard previousIndex >= 0 else {
            //return orderedViewControllers.last
            // Uncommment the line below, remove the line above if you don't want the page control to loop.
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController ) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        // User is on the last view controller and swiped right to loop to
        // the first view controller.
        guard orderedViewControllersCount != nextIndex else {
            //return orderedViewControllers.first
            // Uncommment the line below, remove the line above if you don't want the page control to loop.
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
}
