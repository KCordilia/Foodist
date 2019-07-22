//
//  PageViewController.swift
//  Foodist
//
//  Created by Namitha Pavithran on 18/07/2019.
//  Copyright © 2019 Karim Cordilia. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController {

   
    let favouriteCatagory = "dessert"
    var endPoint = "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/search?type="
    let numberOfPages = 5
    var recipeList: RecipeList?
    
    fileprivate func setUpPageControl() {
        let appearance = UIPageControl.appearance(whenContainedInInstancesOf: [UIPageViewController.self])
        appearance.pageIndicatorTintColor = .yellow
        appearance.currentPageIndicatorTintColor = .red
    }
    
    func instantiateViewController()->SelectedCatagoryViewController {
        let selectedCatagoryVC = UIStoryboard(name: "Main", bundle: nil) .
            instantiateViewController(withIdentifier: "selectedCatagoryVC") as! SelectedCatagoryViewController
       
        return selectedCatagoryVC
    }
    
    fileprivate func setUpInitialPage() {
        let firstViewController = instantiateViewController()
        if let results = recipeList?.results[0] {
        firstViewController.recipe = results
       
        firstViewController.index = 0
        }
        setViewControllers([firstViewController],
                           direction: .forward,
                           animated: true,
                           completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        endPoint = endPoint + favouriteCatagory + "&number=\(numberOfPages)"
        
        let networkHandler = NetworkHandler()
        networkHandler.getAPIData(endPoint) { (recipeList: RecipeList?) in
            self.recipeList = recipeList
            if self.recipeList != nil {
                DispatchQueue.main.async {
                    self.setUpInitialPage()
                }
                
            }
          }
        
        setUpPageControl()
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
                if let result = recipeList?.results[currentIndex - 1] {
                previousViewController.recipe = result
                   // previousViewController.setUpViewController()
                }
                return previousViewController
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if let selectedCatagoryViewController = viewController as? SelectedCatagoryViewController {
            
            let currentIndex = selectedCatagoryViewController.index
            if let recipeList = recipeList {
                let results = recipeList.results
                if currentIndex == results.count - 1{
                    return nil
                }
                else {
                    let nextViewController = instantiateViewController()
                    nextViewController.index = currentIndex + 1
                    nextViewController.recipe = recipeList.results[currentIndex+1]
                   
                    return nextViewController
                }
            }
        }
        return nil
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return numberOfPages
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
}
