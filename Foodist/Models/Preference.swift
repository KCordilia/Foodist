//
//  Preference.swift
//  Foodist
//
//  Created by Namitha Pavithran on 23/07/2019.
//  Copyright © 2019 Karim Cordilia. All rights reserved.
//

import Foundation

protocol ShowPreference {
    var preferences: [Preference] { get set } 
}
struct Preference {
    let catagory: String
    let displayTitle: String
    var options: [PreferenceOption]
    //static let shared = Preference()
   static func getAllPreferenceOptions() -> [Preference] {
        var preferences: [Preference] = []
        let mainCourse = PreferenceOption(name: "main+course", displayTitle: "Main course")
        let sideDish = PreferenceOption(name: "side+dish", displayTitle: "Side dish")
        let dessert = PreferenceOption(name: "dessert", displayTitle: "Dessert")
        let appetizer = PreferenceOption(name: "appetizer", displayTitle: "Appetizer")
        let salad = PreferenceOption(name: "salad", displayTitle: "Salad")
        let breakfast = PreferenceOption(name: "breakfast", displayTitle: "Breakfast")

        let typePreference = Preference(catagory: "type", displayTitle: "Food Type", options: [mainCourse, sideDish, dessert, appetizer, salad, breakfast])

        let irish = PreferenceOption(name: "irish", displayTitle: "Irish")
        let french = PreferenceOption(name: "french", displayTitle: "French")
        let italian = PreferenceOption(name: "italian", displayTitle: "Italian")
        let mexican = PreferenceOption(name: "mexican", displayTitle: "Mexican")
        let spanish = PreferenceOption(name: "spanish", displayTitle: "Spanish")
        let middleEastern = PreferenceOption(name: "middle+eastern", displayTitle: "Middle Eastern")

        let cuisinePreference = Preference(catagory: "cuisine", displayTitle: "cuisine", options: [irish, spanish, french, italian, mexican, middleEastern])

        let dairy = PreferenceOption(name: "dairy", displayTitle: "Dairy")
        let egg = PreferenceOption(name: "egg", displayTitle: "Egg")
        let gluten = PreferenceOption(name: "gluten", displayTitle: "Gluten")
        let peanut = PreferenceOption(name: "peanut", displayTitle: "Peanut")

        let intolerancePreference = Preference(catagory: "intolerances", displayTitle: "Intolerances", options: [dairy, egg, gluten, peanut])

        let vegan = PreferenceOption(name: "vegan", displayTitle: "Vegan")
        let vegetarian = PreferenceOption(name: "vegetarian", displayTitle: "Vegetarian")

        let dietPreference = Preference(catagory: "diet", displayTitle: "Diet", options: [vegan, vegetarian])

        preferences = [typePreference, cuisinePreference, intolerancePreference, dietPreference]
        return preferences
    }

}
struct PreferenceOption {
    let name: String
    let displayTitle: String
}
