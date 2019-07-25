//
//  NetworkHandler.swift
//  Foodist
//
//  Created by Namitha Pavithran on 18/07/2019.
//  Copyright © 2019 Karim Cordilia. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case networkError(String)
}

struct NetworkHandler {

    func getAPIData<T: Codable>(_ url: String, completion: @escaping (Result<T, NetworkError>) -> Void) {
        let APIKey = "6d4b0c4e3bmsh16b8d0615ae873bp1510ccjsnc4cc6ac1e186"
        let hostHeader = "spoonacular-recipe-food-nutrition-v1.p.rapidapi.com"
        let session = URLSession.shared
        guard
            let url = URL(string: url)
            else { return }
        var request = URLRequest(url: url)
        request.addValue(APIKey, forHTTPHeaderField: "X-RapidAPI-Key")
        request.addValue(hostHeader, forHTTPHeaderField: "X-RapidAPI-Host")
        let task = session.dataTask(with: request) { (data, _, error) in
            if error == nil {
                if let data = data {

                    let result: Result<T, Error> = self.decode(data: data)

                    switch result {
                    case .failure(let error):
                        print(error)
                    case .success(let value):
                        completion(.success(value))
                    }
                }
            } else {
                guard let error = error else { return }
                completion(.failure(.networkError(error.localizedDescription)))
            }

        }
        task.resume()
    }

    private func decode<CodableStruct: Codable> (data: Data) -> Result<CodableStruct, Error> {

        do {
            let decoder = JSONDecoder()
            let decodedResult = try decoder.decode(CodableStruct.self, from: data)
            return .success(decodedResult)
        } catch let error {
            return .failure(error)
        }
    }
}
