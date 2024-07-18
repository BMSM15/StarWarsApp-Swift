//
//  GetData.swift
//  StarWarsApp
//
//  Created by Bruno Martins on 18/07/2024.
//

import Foundation

class Services {
    
    let getData = GetData()
    
    func getCharacters(from url: String, completion: @escaping GetData.NetworkCompletion<GetData.APIResponse<Person>>) {
        getData.getData(from: url, completion: completion)
    }
}

class GetData {
    
    public typealias NetworkCompletion<T: Decodable> = (_ result: Result<T, Error>) -> Void
    
    public func getData<T: Decodable>(from url: String, completion: @escaping NetworkCompletion<T>) {
        guard let url = URL(string: url) else {
            print("Invalid URL")
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Failed to fetch data from URL: \(url.absoluteString) with error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                completion(.failure(error))
                return
            }
            
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                print("Successfully fetched data from URL: \(url.absoluteString)")
                completion(.success(result))
            } catch {
                print("Failed to decode data from URL: \(url.absoluteString) with error: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    struct APIResponse<T: Codable>: Codable {
        let count: Int
        let next: String?
        let previous: String?
        let results: [T]
    }
}
