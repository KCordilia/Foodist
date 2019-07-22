//
//  Category.swift
//  Foodist
//
//  Created by Karim Cordilia on 17/07/2019.
//  Copyright © 2019 Karim Cordilia. All rights reserved.
//

import Foundation

struct Category: Codable {
    let name: String
    let recipes: [Recipe]
    let isUserPreference: Bool
}

struct RecipeList: Encodable, Decodable {
    let results: [Recipe]
}
