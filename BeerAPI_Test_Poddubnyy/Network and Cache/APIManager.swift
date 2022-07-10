//
//  APIManager.swift
//  BeerAPI_Test_Poddubnyy
//
//  Created by Алексей Поддубный on 07.07.2022.
//

import Foundation

class APIManager {
    static let shared = APIManager()
    
    private let basicURL = URL(string: "https://api.punkapi.com/v2/beers")!
    
    var isPaginating: Bool = false
    
    func getBeerList(pagination: Bool, page: Int, completion: @escaping (Result<Beers, Error>) -> Void) {
        var url = basicURL
        if pagination {
            self.isPaginating = true
            let query: [String: String] = ["page": "\(String(describing: page))"]
            url = basicURL.withQueries(query)!
        }
        
        print(url)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
            }
            
            let jsonDecoder = JSONDecoder()
            if let data = data {
                if let jsonData = try? jsonDecoder.decode(Beers.self, from: data) {
                    
                    completion(.success(jsonData))
                    if pagination {
                        self.isPaginating = false
                    }
                } else {
                    print("Could not decode json")
                }
            }
        }
        
        task.resume()
    }
    
    func getBeerImage(url: URL, completion: @escaping () -> Void) {
        
    }
}

extension URL {
    func withQueries(_ queries: [String: String]) -> URL? {
        var components = URLComponents(url: self,
        resolvingAgainstBaseURL: true)
        components?.queryItems = queries.map{ URLQueryItem(name: $0.0, value: $0.1) }
        return components?.url
    }
}

