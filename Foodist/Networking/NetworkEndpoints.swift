//
//  NetworkEndpoints.swift
//  Foodist
//
//  Created by Namitha Pavithran on 22/07/2019.
//  Copyright © 2019 Karim Cordilia. All rights reserved.
//

import Foundation

protocol Preference {
    
}
enum SearchParams {
    case type
    case cuisine
    case intolerances
    case diet
}
enum FoodType: String {
    case mainCourse = "main+course",sideDish = "side+dish", dessert, appetizer, salad, bread, breakfast, soup, beverage, sauce, drink
}
enum CuisineType: String {
    case african, chinese, japanese, korean, vietnamese, thai, indian, british, irish, french, italian, mexican, spanish, middleEastern = "middle+eastern", jewish, american, cajun, southern, greek, german, nordic, easterneuropean, caribbean,latinAmerican = "latin+american"
}
enum Intolerances {
    case dairy, egg, gluten, peanut
}
enum Diet: String {
    case pescetarian, lactoVegetarian = "lacto+vegetarian", ovoVegetarian = "ovo+vegetarian", vegan, vegetarian
}
struct NetworkEndpoint {
    let recipeSearch = "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/search?type="
    let recipeImage = "https://spoonacular.com/recipeImages/"
    let ingredients = "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/"
    
    func getAllSearchParams()-> [SearchParams] {
        var searchParams = [SearchParams]()
        searchParams.append(.type)
        searchParams.append(.cuisine)
        searchParams.append(.intolerances)
        return searchParams
    }
    
     func getSearchUrl(for catagory: CuisineType) -> String {
        var searchType = ""
      //  case .failure(let error) = result
        if catagory == CuisineType.middleEastern {
            searchType = catagory.rawValue
        }
        if catagory ==  CuisineType.latinAmerican {
            searchType = catagory.rawValue
        }
        else {
            searchType = "\(catagory)"
        }
        
        let url = recipeSearch + searchType
        return url
    }
    
    func getCombinedUrl() -> String {
        return ""
    }
}
