//
//  TutorialPageViewController.swift
//  app
//
//  Created by Paula Wikidal on 19.06.18.
//  Copyright © 2018 Zarah Zahreddin. All rights reserved.
//

import UIKit

class TutorialPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    // MARK: Properties
    var viewControllersList = [UIViewController]()
    var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        
        //load viewControllers
        for i in 0...4 {
            let vc = UIStoryboard(name: "Main", bundle: nil) .
                instantiateViewController(withIdentifier:"tutorial\(i)")
            viewControllersList.append(vc)
        }
 
        //set initial viewcontroller
        if let initialViewController = viewControllersList.first {
            setViewControllers([initialViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
        
        pageControl.numberOfPages = viewControllersList.count
    }
    
    // MARK: UIPageViewControllerDataSource
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentIndex = viewControllersList.index(of: viewController)!
        let previousIndex = currentIndex - 1
        guard previousIndex >= 0 else {
            return nil
        }
        guard viewControllersList.count > previousIndex else {
            return nil
        }
        return viewControllersList[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndex = viewControllersList.index(of: viewController)!
        let nextIndex = currentIndex + 1
        guard nextIndex >= 0 else {
            return nil
        }
        guard viewControllersList.count > nextIndex else {
            return nil
        }
        return viewControllersList[nextIndex]
    }
    
    
    // MARK: UIPageViewControllerDelegate
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        if let firstViewController = viewControllers?.first,
            let index = viewControllersList.index(of: firstViewController) {
            pageControl.currentPage = index
        }
    }

}
