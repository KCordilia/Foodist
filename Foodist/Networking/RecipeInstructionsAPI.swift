//
//  RecipeInstructionsAPI.swift
//  Foodist
//
//  Created by Karim Cordilia on 18/07/2019.
//  Copyright © 2019 Karim Cordilia. All rights reserved.
//

import Foundation

struct RecipeInstructionsServerNetworking {
    static func getAPIData(id: Int, completion: @escaping (Data) -> Void) {
        let session = URLSession.shared
        guard
            let url = URL(string:"https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/\(id)/analyzedInstructions")
            else { return }
        var request = URLRequest(url: url)
        request.addValue("6d4b0c4e3bmsh16b8d0615ae873bp1510ccjsnc4cc6ac1e186", forHTTPHeaderField: "X-RapidAPI-Key")
        request.addValue("spoonacular-recipe-food-nutrition-v1.p.rapidapi.com", forHTTPHeaderField: "X-RapidAPI-Host")
        
        
        let task = session.dataTask(with: request) { (data, response, error) in
            completion(data!)
        }
        task.resume()
    }
    
    static func loadRecipeInstructionsData(id: Int, completion: @escaping ([RecipeInstructions]) -> Void) {
        getAPIData(id: id) { resultData in
            do {
                let decoder = JSONDecoder()
                let decodedResult = try decoder.decode([RecipeInstructions].self, from: resultData)
                completion(decodedResult)
            } catch let error{
                print(error)
                completion([])
            }
        }
    }
}
