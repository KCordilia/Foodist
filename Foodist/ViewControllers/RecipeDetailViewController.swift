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
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cookingTimeLabel: UILabel!
    let recipeId = 324694
    var ingredientList: [SingleIngredient] = []
    var instructionList: [RecipeStep] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        RecipeServerNetworking.loadRecipeData(id: recipeId) { recipe in
            guard
                let recipeName = recipe?.title,
                let recipeImageUrl = recipe?.image,
                let cookingTime = recipe?.readyInMinutes
                else { return}
            let url = URL(string: recipeImageUrl)
            DispatchQueue.main.async {
                self.recipeTitle.text = recipeName
                self.recipeImage.kf.setImage(with: url)
                self.cookingTimeLabel.text = "\(cookingTime)"
            }
        }
        
        IngredientServerNetworking.loadIngredientData(id: recipeId) { ingredients in
            guard
                let ingredients = ingredients
                else { return }
            ingredients.ingredients.forEach({ singleIngredient in
                DispatchQueue.main.async {
                    self.ingredientList.append(SingleIngredient(name: singleIngredient.name, value: singleIngredient.amount.metric.value, unit: singleIngredient.amount.metric.unit))
                    self.tableView.reloadData()
                }
            })
        }
        
        RecipeInstructionsServerNetworking.loadRecipeInstructionsData(id: recipeId) { instructions in
            instructions.forEach { instruction in
                instruction.steps.forEach { step in
                    self.instructionList.append(step)
                }
            }
        }
    }
    
    
}

extension RecipeDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Ingredients"
        } else {
            return "Instructions"
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return ingredientList.count
        } else {
            return instructionList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let ingredientCell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath)
            ingredientCell.textLabel?.text = ingredientList[indexPath.row].name.capitalized
            ingredientCell.detailTextLabel?.text = "\(ingredientList[indexPath.row].value) " + ingredientList[indexPath.row].unit
            return ingredientCell
        } else {
            guard
                let instructionCell = tableView.dequeueReusableCell(withIdentifier: "instructionCell", for: indexPath) as? InstructionCell
                else { preconditionFailure("no cell") }
            instructionCell.instructionLabel.text = "\(instructionList[indexPath.row].step)"
            return instructionCell
        }
    }
}
