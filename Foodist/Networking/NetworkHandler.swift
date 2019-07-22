//
//  NetworkHandler.swift
//  Foodist
//
//  Created by Namitha Pavithran on 18/07/2019.
//  Copyright © 2019 Karim Cordilia. All rights reserved.
//

import Foundation

/**
 enum CatError: Error {
 case catArrayMissing
 }
 
 func downloadCats(_ url: String, completion: (Result<[Cat], CatError>) -> Void) {
 //....
 let arrayOfCats = [Cat(name: "Suzi"), Cat(name: "Tom")]
 // good result
 completion(.success(arrayOfCats))
 // error case
 completion(.failure(.catArrayMissing))
 }
 
 downloadCats("http://") { result in
 if case .failure(let error) = result {
 print(error)
 }
 guard
 case .success(let value) = result
 else { return }
 print(value)
 }**/

enum NetworkError: Error {
    case tooSlow
    case serverDown
}

struct NetworkHandler {
    var APIKey: String!
    var hostHeader: String!
    
   mutating func setUpHeaders() {
        APIKey = "6d4b0c4e3bmsh16b8d0615ae873bp1510ccjsnc4cc6ac1e186"
        hostHeader = "spoonacular-recipe-food-nutrition-v1.p.rapidapi.com"
    }
    
    func getAPIData<T: Codable>(_ url: String, completion: @escaping (Result<T,NetworkError>) -> Void) {
        
        let session = URLSession.shared
        guard
            let url = URL(string: url)
            else { return }
        var request = URLRequest(url: url)
        request.addValue(APIKey, forHTTPHeaderField: "X-RapidAPI-Key")
        request.addValue(hostHeader, forHTTPHeaderField: "X-RapidAPI-Host")
        let task = session.dataTask(with: request) { (data, response, error) in
            if error == nil {
                if let data = data {
                    
                    let result: Result<T,Error> = self.decode(data: data)
                    
                    if case .failure(let error) = result {
                        print(error)
                    }
                    guard
                        case .success(let value) = result
                        else { return }
                    completion(.success(value))
                }
            }
                
            else {
                print(error!)
                completion(.failure(.serverDown))
            }
            
        }
        task.resume()
    }

    
    private func decode<CodableStruct: Codable> (data: Data) -> Result<CodableStruct,Error> {
        
        do {
            let decoder = JSONDecoder()
            let decodedResult = try decoder.decode(CodableStruct.self, from: data)
            return .success(decodedResult)
        } catch let error{
            return .failure(error)
        }
    }
}
    

