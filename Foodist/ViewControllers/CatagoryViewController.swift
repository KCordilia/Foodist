//
//  SelectedcategoryViewController.swift
//  Foodist
//
//  Created by Namitha Pavithran on 17/07/2019.
//  Copyright © 2019 Karim Cordilia. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeNameLabel: UILabel!

    var index = 0
    var recipe: Recipe?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewController()
    }

    @IBAction func recipeImageTapped(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "showDetail", sender: self)
    }

    func setUpViewController() {
        guard let recipe = recipe else { return }
        let recipeImageEndpoint = "https://spoonacular.com/recipeImages/" + recipe.image
        if let imageUrl = URL(string: recipeImageEndpoint) {
            recipeImageView.kf.setImage(with: imageUrl)
        }
        recipeNameLabel.text = recipe.title
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            guard let destinationController = segue.destination as? RecipeDetailViewController
                else { return }
            guard let recipe = recipe else { return }
            destinationController.recipe = recipe
        }
    }
}
