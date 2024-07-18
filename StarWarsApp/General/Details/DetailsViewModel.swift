//
//  DetailsViewModel.swift
//  StarWarsApp
//
//  Created by Bruno Martins on 17/07/2024.
//

import Foundation

class CharacterDetailsViewModel {
    private let characterDetails: CharacterDetails
    
    init(character: CharacterDetails) {
        self.characterDetails = character
    }
    
    var name: String {
        return characterDetails.name
    }
    
    var gender: String {
        return characterDetails.gender
    }
    
    var language: String {
        return characterDetails.language
    }
    
    var avatarURL: String {
        return characterDetails.avatarURL
    }
    
    var vehicles: [String] {
        return characterDetails.vehicles
    }
    
    func fetchVehicles(completion: @escaping ([String]) -> Void) {
        let group = DispatchGroup()
        var vehicleNames: [String] = []
        
        for vehicleURL in vehicles {
            group.enter()
            getData(from: vehicleURL) { (vehicle: Vehicle?, error) in
                if let vehicle = vehicle {
                    vehicleNames.append(vehicle.name)
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            print("Vehicle fetch completed for \(self.name)")
            completion(vehicleNames)
        }
    }
    
    // Função genérica para buscar dados da API
    private func getData<T: Codable>(from url: String, completion: @escaping (T?, Error?) -> Void) {
        guard let url = URL(string: url) else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Failed to fetch data from URL: \(url.absoluteString) with error: \(error.localizedDescription)")
            }
            guard let data = data, error == nil else {
                completion(nil, error)
                return
            }
            
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                print("Successfully fetched data from URL: \(url.absoluteString)")
                completion(result, nil)
            } catch {
                print("Failed to decode data from URL: \(url.absoluteString) with error: \(error.localizedDescription)")
                completion(nil, error)
            }
        }
        
        task.resume()
    }
}

