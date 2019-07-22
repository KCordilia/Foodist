//
//  CatagoryViewController.swift
//  Foodist
//
//  Created by Namitha Pavithran on 17/07/2019.
//  Copyright © 2019 Karim Cordilia. All rights reserved.
//

import UIKit

class AllCatagoriesViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!

    // MARK: - Properties
    let cellIdentifier = "allCatagoryTCell"
    let collectionViewcellIdentifier = "allcatagoryCCell"
    let recipeImageEndpoint = "https://spoonacular.com/recipeImages/"
    var catagories: [Category]?
    var selectedRecipe: Recipe?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.separatorStyle = .none

        //load catagory. find catagories and attach it to Url and pass the url to networking function. for now default catagory is main+course.
        let urlString = "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/search?type=main+course"
        var recipeList: RecipeList?
        var networkHandler = NetworkHandler()
        networkHandler.setUpHeaders()
        networkHandler.getAPIData(urlString) { (result: Result<RecipeList, NetworkError>) in
            if case .failure(let error) = result {
                print(error)
            }
            guard
                case .success(let value) = result
                else { return }
            recipeList = value
            if let recipeList = recipeList {
                self.catagories = [Category(name: "Main Course", recipes: recipeList.results, isUserPreference: false)]
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            guard let destinationController = segue.destination as? RecipeDetailViewController
                else { return }

            guard let recipe = selectedRecipe else { return }
            destinationController.recipe = recipe
        }
    }
}

extension AllCatagoriesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catagories?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? AllCatagoriesTableViewCell
            else { preconditionFailure("deque cell failed in selected allcatagory table view ") }
        if let catagory = catagories?[indexPath.row] {
            cell.catagoryName.text = catagory.name
            cell.collectionView.dataSource = self
            cell.collectionView.delegate = self
            cell.collectionView.reloadData()
            cell.collectionView.tag = indexPath.item
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

extension AllCatagoriesViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let catagory = catagories?[collectionView.tag] {
            let recipies = catagory.recipes
            return recipies.count
        }
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewcellIdentifier, for: indexPath) as? AllCatagoryCollectionViewCell
            else { preconditionFailure("deque cell failed in selected catagory collection view ") }

        if let catagory = catagories?[collectionView.tag] {
            let recipe = catagory.recipes[indexPath.item]
            cell.recipeName.text = recipe.title
            let imageUrl = recipeImageEndpoint + recipe.image
            if let url = URL(string: imageUrl) {
                cell.recipeImage.kf.setImage(with: url)
            }
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height
        let width = height
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let catagory = catagories?[collectionView.tag] {
            let recipe = catagory.recipes[indexPath.item]
            selectedRecipe = recipe
            performSegue(withIdentifier: "showDetail", sender: self)
        }
    }
}
