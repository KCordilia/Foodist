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
        guard
            let recipe = recipe
            else { return }
        let ingredientsEndpoint = "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/\(recipe.id)/ingredientWidget.json"
        let instructionsEndpoint = "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/\(recipe.id)/analyzedInstructions"
        var networkHandler = NetworkHandler()
        networkHandler.setUpHeaders()
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
            
        }
    }

   /* func highlightWord(_ text: String, indexPath: IndexPath, characterRange: NSRange,spokenTextLengths: Int) {
        guard
            let instructionCell = tableView.cellForRow(at: indexPath) as? InstructionCell
            else { return }

        let rangeInTotalText = NSMakeRange(spokenTextLengths + characterRange.location, characterRange.length)

        let attributedString = NSMutableAttributedString(string: (instructionCell.instructionLabel.attributedText?.attributedSubstring(from: rangeInTotalText)))

        // Make the text of the selected area orange by specifying a new attribute.
        let currentAttributes = instructionCell.instructionLabel.attributedText?.attributes(at: rangeInTotalText.location, effectiveRange: nil)
        let fontAttribute: AnyObject? = currentAttributes?[NSAttributedString.Key.font] as AnyObject?

        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.orange, range: NSMakeRange(0, attributedString.length))

        // Make sure that the text will keep the original font by setting it as an attribute.
        attributedString.addAttribute(NSAttributedString.Key.font, value: fontAttribute!, range: NSMakeRange(0, attributedString.string.utf16.count))

        instructionCell.instructionLabel.text?.replacingCharacters(in: rangeInTotalText, with: attributedString)
        // Select the specified range in the textfield.
       /* tvEditor.selectedRange = rangeInTotalText

        // Store temporarily the current font attribute of the selected text.
        let currentAttributes = tvEditor.attributedText.attributes(at: rangeInTotalText.location, effectiveRange: nil)
        let fontAttribute: AnyObject? = currentAttributes[NSAttributedString.Key.font] as AnyObject?

        // Assign the selected text to a mutable attributed string.
        let attributedString = NSMutableAttributedString(string: tvEditor.attributedText.attributedSubstring(from: rangeInTotalText).string)

        // Make the text of the selected area orange by specifying a new attribute.
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.orange, range: NSMakeRange(0, attributedString.length))

        // Make sure that the text will keep the original font by setting it as an attribute.
        attributedString.addAttribute(NSAttributedString.Key.font, value: fontAttribute!, range: NSMakeRange(0, attributedString.string.utf16.count))*/

        // In case the selected word is not visible scroll a bit to fix this.
       // tvEditor.scrollRangeToVisible(rangeInTotalText)

        // Begin editing the text storage.
       // tvEditor.textStorage.beginEditing()

        // Replace the selected text with the new one having the orange color attribute.
        tvEditor.textStorage.replaceCharacters(in: rangeInTotalText, with: attributedString)


        let instructionText = "\(instructionList[indexPath.row].step)"
        let arrayOfWords = instructionText.components(separatedBy: " ")

        var currentLocation = 0
        var currentLength = 0
        var arrayOfRanges = [NSRange]()

        for word in arrayOfWords {
            currentLength = word.count
            arrayOfRanges.append(NSRange(location: currentLocation, length: currentLength))

            //                currentLocation += currentLength + 1
        }
        let attributedString = NSMutableAttributedString(string: "\(instructionList[indexPath.row].step)")
        attributedString.addAttribute(.backgroundColor, value: UIColor.yellow, range: NSRange(location: arrayOfRanges[indexPath.row].location, length: arrayOfRanges[indexPath.row].length))
        instructionCell.instructionLabel.attributedText = attributedString


    }*/
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
            instructionCell.instructionLabel.text = instructionList[indexPath.row].step
            return instructionCell
        }
    }

}
