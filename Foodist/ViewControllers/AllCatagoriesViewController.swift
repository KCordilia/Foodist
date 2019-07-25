//
//  CatagoryViewController.swift
//  Foodist
//
//  Created by Namitha Pavithran on 17/07/2019.
//  Copyright © 2019 Karim Cordilia. All rights reserved.
//

import UIKit

class AllCatagoriesViewController: BaseViewController {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!

    // MARK: - Properties
    let cellIdentifier = "allCatagoryTCell"
    let collectionViewcellIdentifier = "allcatagoryCCell"
    let recipeImageEndpoint = "https://spoonacular.com/recipeImages/"
    var catagories: [Category] = []
    var selectedRecipe: Recipe?
    let dispatchQueue = DispatchQueue(label: "queue_for_catagories")
    let dispatchGroup = DispatchGroup()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadUrls()
    }

    func loadUrls() {
        if let parent = self.parent as? BaseViewController {
            let allPreferences = parent.preferences
          //  let searchParameters = allPreferences.filter { $0.catagory == "intolerances" || $0.catagory == "diet" }
            //allPreferences.re
            let otherCatagories = allPreferences.map { (element) -> [PreferenceOption] in
                return element.options
            }
            var concatinated = Array(otherCatagories.joined())
            concatinated.removeFirst()
            for index in 0..<concatinated.count {
            let urlString = "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/search?type=\(concatinated[index].name)"
            var recipeList: RecipeList?
            let networkHandler = NetworkHandler()
            dispatchGroup.enter()
            networkHandler.getAPIData(urlString) { (result: Result<RecipeList, NetworkError>) in

                switch result {
                case .failure(let error):
                    switch error {
                    case .networkError(let message):
                        DispatchQueue.main.async {
                            print("before leave in network error index : ", index)
                            self.dispatchGroup.leave()
                            self.showAlert(message)
                        }
                    }
                case .success(let value):
                    recipeList = value
                    print("appending catagory")
                    if let recipeList = recipeList {
                        let catagory = Category(name: concatinated[index].displayTitle, recipes: recipeList.results, isUserPreference: true)
                        self.catagories.append(catagory)
                    }
                    print("before leave in success index : ", index)
                    self.dispatchGroup.leave()
                }
            }
        }
            dispatchGroup.notify(queue: dispatchQueue) {
                print("notified")
                DispatchQueue.main.async {
                    self.tableView.reloadData()
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
        return catagories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? AllCatagoriesTableViewCell
            else { preconditionFailure("deque cell failed in selected allcatagory table view ") }
         let catagory = catagories[indexPath.row]
            cell.catagoryName.text = catagory.name
            cell.collectionView.dataSource = self
            cell.collectionView.delegate = self
            cell.collectionView.reloadData()
            cell.collectionView.tag = indexPath.item
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

extension AllCatagoriesViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         let catagory = catagories[collectionView.tag]
            let recipies = catagory.recipes
            return recipies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewcellIdentifier, for: indexPath) as? AllCatagoryCollectionViewCell
            else { preconditionFailure("deque cell failed in selected catagory collection view ") }

         let catagory = catagories[collectionView.tag]
            let recipe = catagory.recipes[indexPath.item]
            cell.recipeName.text = recipe.title
            let imageUrl = recipeImageEndpoint + recipe.image
            if let url = URL(string: imageUrl) {
                cell.recipeImage.kf.setImage(with: url)
            }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height
        let width = height
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let catagory = catagories[collectionView.tag]
            let recipe = catagory.recipes[indexPath.item]
            selectedRecipe = recipe
            performSegue(withIdentifier: "showDetail", sender: self)
    }
}
