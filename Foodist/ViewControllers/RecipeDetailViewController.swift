//
//  RecipeDetailViewController.swift
//  Foodist
//
//  Created by Karim Cordilia on 18/07/2019.
//  Copyright © 2019 Karim Cordilia. All rights reserved.
//

import UIKit
import Kingfisher

class RecipeDetailViewController: UIViewController {
    
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        RecipeServerNetworking.loadRecipeData(id: 695646) { recipe in
            guard
                let recipeName = recipe?.title,
                let recipeImageUrl = recipe?.image
                else { return}
            let url = URL(string: recipeImageUrl)
            DispatchQueue.main.async {
                self.recipeTitle.text = recipeName
                self.recipeImage.kf.setImage(with: url)
            }
        }
    }
    
    
}
