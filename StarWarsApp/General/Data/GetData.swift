//
//  GetData.swift
//  StarWarsApp
//
//  Created by Bruno Martins on 18/07/2024.
//

import Foundation

class Services {
    private static let apiPath = "https://swapi.dev/api/"
    private let getData: GetData
    
    init(getData: GetData = GetData()) {
        self.getData = getData
    }

    static func getID(from url: String) -> String {
        return String(url
            .replacingOccurrences(of: Services.apiPath, with: "")
            .split(separator: "/")
            .last!)
    }
    
    func getCharacters(searchText: String?, pageNumber: Int, completion: @escaping GetData.NetworkCompletion<GetData.APIResponse<Person>>) {
        var url = "\(Services.apiPath)people?page=\(pageNumber)"
        if let searchText = searchText,
           !searchText.isEmpty {
            url = url.appending("&search=\(searchText)")
        }
        print("Fetching people from URL: \(url)")
        getData.getData(from: url, completion: completion)
    }
    
    func getSpecies(byID id: String, completion: @escaping GetData.NetworkCompletion<Species>) {
        let url = "\(Services.apiPath)species/\(id)/"
        print("Fetching species from URL: \(url)")
        getData.getData(from: url, completion: completion)
    }

    func getVehicle(byID id: String, completion: @escaping GetData.NetworkCompletion<Vehicle>) {
        let url = "\(Services.apiPath)vehicles/\(id)/"
        print("Fetching vehicle from URL: \(url)")
        getData.getData(from: url, completion: completion)
    }
}


class GetData {
    typealias NetworkCompletion<T> = (Result<T, Error>) -> Void

    func getData<T: Decodable>(from url: String, completion: @escaping NetworkCompletion<T>) {
        guard let url = URL(string: url) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
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
