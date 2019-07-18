//
//  RecipeInstructions.swift
//  Foodist
//
//  Created by Karim Cordilia on 18/07/2019.
//  Copyright © 2019 Karim Cordilia. All rights reserved.
//

import Foundation

struct RecipeInstructions: Codable {
    let steps: [RecipeStep]
}

struct RecipeStep: Codable {
    let step: String
}
