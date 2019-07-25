//
//  PageViewController.swift
//  Foodist
//
//  Created by Namitha Pavithran on 18/07/2019.
//  Copyright © 2019 Karim Cordilia. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController {

    var favouritecategory = "dessert"
    var endPoint = "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/search?type="
    let numberOfPages = 5
    var recipeList: RecipeList?
    //var recipeMoreInfo: [Recipe]?

    //TODO: - remove recipes without instructionlist

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        loadUrl()
    }

    fileprivate func setUpPageControl() {
        let appearance = UIPageControl.appearance(whenContainedInInstancesOf: [UIPageViewController.self])
        appearance.pageIndicatorTintColor = .yellow
        appearance.currentPageIndicatorTintColor = .red
    }

    func instantiateViewController() -> CategoryViewController {
        guard
            let selectedCategoryVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "selectedcategoryVC") as? CategoryViewController
            else { preconditionFailure("unexpected viewcontroller") }
            return selectedCategoryVC
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

    func loadUrl() {
        if let parent = self.parent as? BaseViewController {
            let typePreference = parent.preferences.filter { $0.apiCategory == "type" }
            if let randomOption = typePreference.first?.options.randomElement() {
                favouritecategory = randomOption.apiName
                print(randomOption.apiName)
                parent.pageViewPreference = favouritecategory
            }
        }
        endPoint += favouritecategory + "&number=\(numberOfPages)"

        let networkHandler = NetworkHandler()
        networkHandler.getAPIData(endPoint) { (result: Result<RecipeList, NetworkError>) in
            if case .failure(let error) = result {
                switch error {
                case .networkError(let message):
                    DispatchQueue.main.async {
                        self.showAlert(message)
                    }
                }
            }
            guard
                case .success(let value) = result
                else { return }
            self.recipeList = value
            if self.recipeList != nil {
                DispatchQueue.main.async {
                    self.setUpInitialPage()
                    self.setUpPageControl()
                }
            }
        }
    }

    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

extension PageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let selectedcategoryViewController = viewController as? CategoryViewController {
            let currentIndex = selectedcategoryViewController.index
            if currentIndex == 0 {
                return nil
            } else {
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
        if let selectedcategoryViewController = viewController as? CategoryViewController {
            let currentIndex = selectedcategoryViewController.index
            if let recipeList = recipeList {
                let results = recipeList.results
                if currentIndex == results.count - 1 {
                    return nil
                } else {
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
