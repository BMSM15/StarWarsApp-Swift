//
//  DetailsViewModel.swift
//  StarWarsApp
//
//  Created by Bruno Martins on 17/07/2024.
//

import Foundation

class DetailsViewModel {
    var character: CharacterDetails

    init(character: CharacterDetails) {
        self.character = character
    }

    private let getDataService = GetData()
    private var characterDetailsCache: [String: CharacterDetails] = [:]

    func fetchVehicles(completion: @escaping () -> Void) {
        let group = DispatchGroup()
        var vehicleNames: [String] = []

        func fetchVehiclePage(from url: String) {
            getDataService.getData(from: url) { (result: Result<GetData.APIResponse<Vehicle>, Error>) in
                switch result {
                case .success(let response):
                    vehicleNames.append(contentsOf: response.results.map { $0.name })

                    if let nextURL = response.next {
                        fetchVehiclePage(from: nextURL)
                    } else {
                        group.leave()
                    }
                case .failure(let error):
                    print("Failed to fetch vehicle: \(error.localizedDescription)")
                    group.leave()
                }
            }
        }

        for vehicleURL in character.vehicles {
            group.enter()
            fetchVehiclePage(from: vehicleURL)
        }

        group.notify(queue: .main) {
            self.character.vehicles = vehicleNames
            completion()
        }
    }

    func fetchSpecies(from url: String?, completion: @escaping (String) -> Void) {
        guard let url = url else {
            completion("Unknown")
            return
        }

        getDataService.getData(from: url) { (result: Result<Species, Error>) in
            switch result {
            case .success(let species):
                completion(species.language)
            case .failure(let error):
                print("Failed to fetch species: \(error.localizedDescription)")
                completion("Unknown")
            }
        }
    }

    func fetchCharacterDetails(for person: Person, completion: @escaping (CharacterDetails) -> Void) {
        if let cachedDetails = characterDetailsCache[person.url] {
            print("Cache hit for person: \(person.name)")
            completion(cachedDetails)
            return
        }

        print("Fetching details for person: \(person.name)")
        let group = DispatchGroup()

        group.enter()
        fetchSpecies(from: person.species.first) { language in
            let avatarURL = "https://eu.ui-avatars.com/api/?name=\(language.replacingOccurrences(of: " ", with: "+"))"
            let characterDetails = CharacterDetails(name: person.name, gender: person.gender, language: language, avatarURL: avatarURL, vehicles: person.vehicles)
            self.characterDetailsCache[person.url] = characterDetails
            completion(characterDetails)
            group.leave()
        }
    }
}
