//
//  Recipe.swift
//  Foodist
//
//  Created by Karim Cordilia on 17/07/2019.
//  Copyright © 2019 Karim Cordilia. All rights reserved.
//

import Foundation

struct Recipe: Codable {
    // swiftlint:disable:next identifier_name
    let id: Int
    let title: String
    let readyInMinutes: Int
    let servings: Int
    let image: String
}

enum State {
    case playing
    case paused
    case stopped
}
