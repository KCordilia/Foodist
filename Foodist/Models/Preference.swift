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
    let apiCategory: String
    let displayTitle: String
    var options: [PreferenceOption]
    static func getAllPreferenceOptions() -> [Preference] {
        var preferences: [Preference] = []
        let mainCourse = PreferenceOption(apiName: "main+course", displayTitle: "Main course")
        let sideDish = PreferenceOption(apiName: "side+dish", displayTitle: "Side dish")
        let dessert = PreferenceOption(apiName: "dessert", displayTitle: "Dessert")
        let appetizer = PreferenceOption(apiName: "appetizer", displayTitle: "Appetizer")
        let salad = PreferenceOption(apiName: "salad", displayTitle: "Salad")
        let breakfast = PreferenceOption(apiName: "breakfast", displayTitle: "Breakfast")

        let typePreference = Preference(apiCategory: "type", displayTitle: "Food Type", options: [mainCourse, sideDish, dessert, appetizer, salad, breakfast])

        let irish = PreferenceOption(apiName: "irish", displayTitle: "Irish")
        let french = PreferenceOption(apiName: "french", displayTitle: "French")
        let italian = PreferenceOption(apiName: "italian", displayTitle: "Italian")
        let mexican = PreferenceOption(apiName: "mexican", displayTitle: "Mexican")
        let spanish = PreferenceOption(apiName: "spanish", displayTitle: "Spanish")
        let middleEastern = PreferenceOption(apiName: "middle+eastern", displayTitle: "Middle Eastern")

        let cuisinePreference = Preference(apiCategory: "cuisine", displayTitle: "Cuisine", options: [irish, spanish, french, italian, mexican, middleEastern])

        let dairy = PreferenceOption(apiName: "dairy", displayTitle: "Dairy")
        let egg = PreferenceOption(apiName: "egg", displayTitle: "Egg")
        let gluten = PreferenceOption(apiName: "gluten", displayTitle: "Gluten")
        let peanut = PreferenceOption(apiName: "peanut", displayTitle: "Peanut")

        let intolerancePreference = Preference(apiCategory: "intolerances", displayTitle: "Intolerances", options: [dairy, egg, gluten, peanut])

        let vegan = PreferenceOption(apiName: "vegan", displayTitle: "Vegan")
        let vegetarian = PreferenceOption(apiName: "vegetarian", displayTitle: "Vegetarian")

        let dietPreference = Preference(apiCategory: "diet", displayTitle: "Diet", options: [vegan, vegetarian])

        preferences = [typePreference, cuisinePreference, intolerancePreference, dietPreference]
        return preferences
    }

}
struct PreferenceOption: Codable,Equatable {
    let apiName: String
    let displayTitle: String
}
