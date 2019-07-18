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

func getAPIData(completion: @escaping (Data) -> Void) {
    let session = URLSession.shared
    guard
        let url = URL(string:"https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/613045/ingredientWidget.json")
       
        else { return }
    var request = URLRequest(url: url)
    request.addValue("6d4b0c4e3bmsh16b8d0615ae873bp1510ccjsnc4cc6ac1e186", forHTTPHeaderField: "X-RapidAPI-Key")
    request.addValue("spoonacular-recipe-food-nutrition-v1.p.rapidapi.com", forHTTPHeaderField: "X-RapidAPI-Host")
    
    
    let task = session.dataTask(with: request) { (data, response, error) in
        completion(data!)
    }
    task.resume()
}

getAPIData { resultData in
    do {
        let decoder = JSONDecoder()
        let decodedResult = try decoder.decode(RecipeIngredient.self, from: resultData)
        print(decodedResult)
    } catch let error{
        print(error)
    }
}
