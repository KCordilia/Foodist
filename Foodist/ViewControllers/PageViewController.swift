//
//  PageViewController.swift
//  Foodist
//
//  Created by Namitha Pavithran on 18/07/2019.
//  Copyright © 2019 Karim Cordilia. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController {

    let sample = ["this is try","try is good","please come properly"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        let appearance = UIPageControl.appearance(whenContainedInInstancesOf: [UIPageViewController.self])
        appearance.pageIndicatorTintColor = .yellow
        appearance.currentPageIndicatorTintColor = .red
      
        let firstViewController = instantiateViewController()
        firstViewController.sampleData = sample[0]
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        
    }
    func instantiateViewController()->SelectedCatagoryViewController {
        let selectedCatagoryVC = UIStoryboard(name: "Main", bundle: nil) .
            instantiateViewController(withIdentifier: "selectedCatagoryVC") as! SelectedCatagoryViewController
       
        return selectedCatagoryVC
    }
}

extension PageViewController: UIPageViewControllerDataSource,UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let selectedCatagoryViewController = viewController as? SelectedCatagoryViewController {
            let currentIndex = selectedCatagoryViewController.index
            if currentIndex == 0 {
                return nil
            }
            else {
                let previousViewController = instantiateViewController()
                previousViewController.index = currentIndex - 1
                //selectedCatagoryViewController.setUpViewController()
                print(sample[currentIndex-1])
                previousViewController.sampleData = sample[currentIndex-1]
                return previousViewController
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if let selectedCatagoryViewController = viewController as? SelectedCatagoryViewController {
        let currentIndex = selectedCatagoryViewController.index
        if currentIndex == sample.count - 1 {
            return nil
        }
        else {
            let nextViewController = instantiateViewController()
            print(sample[currentIndex])
            nextViewController.sampleData = sample[currentIndex + 1]
            nextViewController.index = currentIndex + 1
            return nextViewController
            }
            
        }
        return nil
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return sample.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
}
