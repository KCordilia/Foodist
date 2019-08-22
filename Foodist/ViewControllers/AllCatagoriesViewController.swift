//
//  categoryViewController.swift
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
    let cellIdentifier = "allCategoryTCell"
    let collectionViewcellIdentifier = "allCategoryCCell"
    let recipeImageEndpoint = "https://spoonacular.com/recipeImages/"
    var catagories: [Category] = []
    var selectedRecipe: Recipe?
    let dispatchQueue = DispatchQueue(label: "queue_for_catagories")
    let dispatchGroup = DispatchGroup()
    var allPreferences: [Preference]?
    var endPoint = "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/search?"

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        NotificationCenter.default.addObserver(self, selector: #selector(reloadPage), name: reloadPageNotification, object: nil)
        fetchPreference()
       // loadUrls()
    }

    @objc func reloadPage() {
        print("notification called")
        catagories.removeAll()
        fetchPreference()
    }

    func formUrl(with preferences: [Preference]) {
        var urls: [String] = []
        let typePreference = preferences.filter { $0.apiCategory == "type" }
        let cuisinePreference = preferences.filter { $0.apiCategory == "cuisine" }
        let intolerancePreference = preferences.filter { $0.apiCategory == "intolerances" }
        let dietPreferences = preferences.filter { $0.apiCategory == "diet" }

        var allCategories: [PreferenceOption] = []
        var isIntolerancePresent = false
        var intoleranceString = "intolerances="
        if intolerancePreference.count > 0 {
            isIntolerancePresent = true
            intolerancePreference[0].options.forEach { (option) in
                intoleranceString += option.apiName
                intoleranceString += ","
            }
        }
        intoleranceString.removeLast()

        var isDietPresent = false
        var dietString = "diet="
        if dietPreferences.count > 0 {
            isDietPresent = true
            dietPreferences[0].options.forEach { (option) in
                dietString += option.apiName
                dietString += ","
            }
        }
        dietString.removeLast()

        if typePreference.count > 0 {
            typePreference[0].options.forEach { (option) in
                allCategories.append(option)
               var url = "\(endPoint)type=\(option.apiName)"
                if isIntolerancePresent {
                    url += "&\(intoleranceString)"
                }
                if isDietPresent {
                    url += "&\(dietString)"
                }
                urls.append(url)
            }
        }
        if cuisinePreference.count > 0 {
            cuisinePreference[0].options.forEach { (option) in
                allCategories.append(option)
                var url = "\(endPoint)cuisine=\(option.apiName)"
                if isIntolerancePresent {
                    url += "&\(intoleranceString)"
                }
                if isDietPresent {
                    url += "&\(dietString)"
                }
                urls.append(url)
            }
        }

       for index in 0..<urls.count {
            performNetworkCall(with: urls[index], for: allCategories[index])
        }
    }

    func performNetworkCall(with url: String, for catagory: PreferenceOption) {

        var recipeList: RecipeList?
        let networkHandler = NetworkHandler()
        dispatchGroup.enter()
        networkHandler.getAPIData(url) { (result: Result<RecipeList, NetworkError>) in

            switch result {
            case .failure(let error):
                switch error {
                case .networkError(let message):
                    DispatchQueue.main.async {
                        print("before leave in network error index : ")
                        self.dispatchGroup.leave()
                        self.showAlert(message)
                    }
                }
            case .success(let value):
                recipeList = value
                print("appending category")
                if let recipeList = recipeList {
                    let category = Category(name: catagory.displayTitle, recipes: recipeList.results, isUserPreference: true)
                    self.catagories.append(category)
                }
                print("before leave in success index : ")
                self.dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: dispatchQueue) {
            print("notified")
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    func fetchPreference() {
        if let savedPreference = UserDefaults.standard.object(forKey: "UserPreference") as? Data {
            let decoder = JSONDecoder()
            do {
                let savedPreference = try decoder.decode([Preference].self, from: savedPreference)
               // allPreferences = savedPreference
                formUrl(with: savedPreference)
                print(savedPreference)
            } catch let error {
                print("error in decoding preference ", error)
                return
            }
        } else {
            let mainCourse = PreferenceOption(apiName: "main+course", displayTitle: "Main course")
            let defaultPreference = Preference(apiCategory: "type", displayTitle: "Food Type", options: [mainCourse])
            allPreferences?.append(defaultPreference)
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? AllCategoriesTableViewCell
            else { preconditionFailure("deque cell failed in selected allcategory table view ") }
         let category = catagories[indexPath.row]
            cell.categoryName.text = category.name
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
         let category = catagories[collectionView.tag]
            let recipies = category.recipes
            return recipies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewcellIdentifier, for: indexPath) as? AllcategoryCollectionViewCell
            else { preconditionFailure("deque cell failed in selected category collection view ") }

         let category = catagories[collectionView.tag]
            let recipe = category.recipes[indexPath.item]
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
            let category = catagories[collectionView.tag]
            let recipe = category.recipes[indexPath.item]
            selectedRecipe = recipe
            performSegue(withIdentifier: "showDetail", sender: self)
    }
}
