//
//  Ingredients.swift
//  Foodist
//
//  Created by Karim Cordilia on 18/07/2019.
//  Copyright © 2019 Karim Cordilia. All rights reserved.
//

import Foundation

struct RecipeIngredient: Codable {
    let ingredients: [Ingredient]
}

struct Ingredient: Codable {
    let name: String
    let amount: IngredientAmount
}

struct IngredientAmount: Codable {
    let metric: MetricAmount
}

struct MetricAmount: Codable {
    let value: Double
    let unit: String
}

struct SingleIngredient {
    let name: String
    let value: Double
    let unit: String
}
