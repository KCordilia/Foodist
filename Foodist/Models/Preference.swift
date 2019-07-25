//
//  Preference.swift
//  Foodist
//
//  Created by Namitha Pavithran on 23/07/2019.
//  Copyright © 2019 Karim Cordilia. All rights reserved.
//

import Foundation

protocol ShowPreference: class {
    var preferences: [Preference] { get set }
}
struct Preference: Codable {
    let category: String
    let displayTitle: String
    var options: [PreferenceOption]
    static func getAllPreferenceOptions() -> [Preference] {
        var preferences: [Preference] = []
        let mainCourse = PreferenceOption(name: "main+course", displayTitle: "Main course")
        let sideDish = PreferenceOption(name: "side+dish", displayTitle: "Side dish")
        let dessert = PreferenceOption(name: "dessert", displayTitle: "Dessert")
        let appetizer = PreferenceOption(name: "appetizer", displayTitle: "Appetizer")
        let salad = PreferenceOption(name: "salad", displayTitle: "Salad")
        let breakfast = PreferenceOption(name: "breakfast", displayTitle: "Breakfast")

        let typePreference = Preference(category: "type", displayTitle: "Food Type", options: [mainCourse, sideDish, dessert, appetizer, salad, breakfast])

        let irish = PreferenceOption(name: "irish", displayTitle: "Irish")
        let french = PreferenceOption(name: "french", displayTitle: "French")
        let italian = PreferenceOption(name: "italian", displayTitle: "Italian")
        let mexican = PreferenceOption(name: "mexican", displayTitle: "Mexican")
        let spanish = PreferenceOption(name: "spanish", displayTitle: "Spanish")
        let middleEastern = PreferenceOption(name: "middle+eastern", displayTitle: "Middle Eastern")

        let cuisinePreference = Preference(category: "cuisine", displayTitle: "Cuisine", options: [irish, spanish, french, italian, mexican, middleEastern])

        let dairy = PreferenceOption(name: "dairy", displayTitle: "Dairy")
        let egg = PreferenceOption(name: "egg", displayTitle: "Egg")
        let gluten = PreferenceOption(name: "gluten", displayTitle: "Gluten")
        let peanut = PreferenceOption(name: "peanut", displayTitle: "Peanut")

        let intolerancePreference = Preference(category: "intolerances", displayTitle: "Intolerances", options: [dairy, egg, gluten, peanut])

        let vegan = PreferenceOption(name: "vegan", displayTitle: "Vegan")
        let vegetarian = PreferenceOption(name: "vegetarian", displayTitle: "Vegetarian")

        let dietPreference = Preference(category: "diet", displayTitle: "Diet", options: [vegan, vegetarian])

        preferences = [typePreference, cuisinePreference, intolerancePreference, dietPreference]
        return preferences
    }

}
struct PreferenceOption: Codable {
    let name: String
    let displayTitle: String
}
