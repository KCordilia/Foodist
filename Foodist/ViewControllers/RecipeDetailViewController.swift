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
    var ingredientList: [SingleIngredient] = []
    var instructionList: [RecipeStep] = []
    var ingredient: RecipeIngredient?
    var recipe: Recipe?
    var instruction: [RecipeInstructions]?
    let recipeImageEndpoint = "https://spoonacular.com/recipeImages/"
    weak var speakDelegate: Speakable?
    var spokenTextLengths: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        title = recipe?.title
        guard
            let recipe = recipe
            else { return }
        let ingredientsEndpoint = "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/\(recipe.id)/ingredientWidget.json"
        let instructionsEndpoint = "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/\(recipe.id)/analyzedInstructions"
        let networkHandler = NetworkHandler()
        networkHandler.getAPIData(ingredientsEndpoint) { (result: Result<RecipeIngredient, NetworkError>) in
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
            self.ingredient = value
            DispatchQueue.main.async {
                if let ingredient = self.ingredient {
                    self.loadIngredients(ingredient)
                    self.tableView.reloadData()
                }
            }
        }

        networkHandler.getAPIData(instructionsEndpoint) { (result: Result<[RecipeInstructions], NetworkError>) in
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
            self.instruction = value
            DispatchQueue.main.async {
                if let instruction = self.instruction {
                    self.loadInstructions(instruction)
                    self.tableView.reloadData()
                }
            }
        }
        loadRecipe(recipe)
    }

    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    func loadRecipe(_ recipe: Recipe) {
        recipeTitle.text = recipe.title
        let recipeImageUrl = recipeImageEndpoint + recipe.image
        let cookingTime = recipe.readyInMinutes
        if let url = URL(string: recipeImageUrl) {
            recipeImage.kf.setImage(with: url)
        }
        cookingTimeLabel.text = "\(cookingTime)"
    }

    func loadIngredients(_ ingredient: RecipeIngredient) {
        ingredient.ingredients.forEach { ingredient in
            ingredientList.append(SingleIngredient(name: ingredient.name, value: ingredient.amount.metric.value, unit: ingredient.amount.metric.unit))
        }
    }

    func loadInstructions(_ instruction: [RecipeInstructions]) {
        instruction.forEach { instruction in
            instruction.steps.forEach({ steps in
                instructionList.append(steps)
                 speakDelegate?.setUpTextToSpeak(steps.step)
            })
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSpeech" {
            guard let destinationVC = segue.destination as? SpeechViewController else { return }
            self.speakDelegate = destinationVC
            destinationVC.sourceVC = self
        }
    }

    func highlightText(range: NSRange, indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as?
            InstructionCell else { return }
        let text = instructionList[indexPath.row].step
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttributes([NSAttributedString.Key.backgroundColor: UIColor.yellow], range: range)
        cell.instructionLabel.attributedText = attributedString
    }

    func forTrailingZero(temp: Double) -> String {
        let tempVar = String(format: "%g", temp)
        return tempVar
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
            ingredientCell.detailTextLabel?.text = "\(forTrailingZero(temp: ingredientList[indexPath.row].value)) " + ingredientList[indexPath.row].unit
            return ingredientCell
        } else {
            guard
                let instructionCell = tableView.dequeueReusableCell(withIdentifier: "instructionCell", for: indexPath) as? InstructionCell
                else { preconditionFailure("no cell") }
            instructionCell.instructionLabel.text = instructionList[indexPath.row].step
            return instructionCell
        }
    }

}

extension RecipeDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard
            let header = view as? UITableViewHeaderFooterView
            else { return }
        header.textLabel?.textColor = .white
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        header.textLabel?.frame = header.frame
        header.textLabel?.textAlignment = .center
        header.backgroundView?.backgroundColor = .gray
    }

}
