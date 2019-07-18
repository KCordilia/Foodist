//
//  NetworkHandler.swift
//  Foodist
//
//  Created by Namitha Pavithran on 18/07/2019.
//  Copyright © 2019 Karim Cordilia. All rights reserved.
//

import Foundation

struct NetworkHandler {
    func getAPIData<T: Codable>(_ url: String, result: T,completion: @escaping (Codable) -> Void) {
        let session = URLSession.shared
        guard let url = URL(string: url) else { return }
        var request = URLRequest(url: url)
        request.addValue("6d4b0c4e3bmsh16b8d0615ae873bp1510ccjsnc4cc6ac1e186", forHTTPHeaderField: "X-RapidAPI-Key")
        request.addValue("spoonacular-recipe-food-nutrition-v1.p.rapidapi.com", forHTTPHeaderField: "X-RapidAPI-Host")
        let task = session.dataTask(with: request) { (data, response, error) in
            if error == nil {
                if let data = data {
                    // completion(data)
                    self.decode(codableStruct: result, data: data, completion: { (resultantStructure) in
                        //print(resultantStructure)
                        completion(resultantStructure)
                    })
                }
            }
            else {
                print(error)
            }
            
        }
        task.resume()
    }
    
    private func decode<CodableStruct: Codable> (codableStruct: CodableStruct , data: Data, completion: (CodableStruct?)->Void) {
        
        do {
            let decoder = JSONDecoder()
            let decodedResult = try decoder.decode(CodableStruct.self, from: data)
            completion(decodedResult)
        } catch let error{
            print(error)
            completion(nil)
        }
    }
    
}
