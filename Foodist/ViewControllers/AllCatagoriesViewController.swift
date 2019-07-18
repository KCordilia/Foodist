//
//  CatagoryViewController.swift
//  Foodist
//
//  Created by Namitha Pavithran on 17/07/2019.
//  Copyright © 2019 Karim Cordilia. All rights reserved.
//

import UIKit

class AllCatagoriesViewController: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- Properties
    let cellIdentifier = "allCatagoryCell"
    var catagories: [Category]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        
        //load catagory. find catagories and attach it to Url and pass the url to networking function. for now default catagory is main+course.
        let urlString = "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/search?type=main+course"
        var recipeList: RecipeList?
        let networkHandler = NetworkHandler()
        networkHandler.getAPIData(urlString, result: recipeList) { (result) in
            recipeList = result as? RecipeList
            self.catagories = [Category(name: "Main Course", recipes: recipeList!.results, isUserPreference: false)]
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension AllCatagoriesViewController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catagories?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? AllCatagoriesTableViewCell
            else { preconditionFailure("deque cell failed in selected allcatagory table view ") }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
