import Foundation

class DetailsViewModel {
    var character: CharacterDetails
    private let person: Person
    private let getDataService = GetData()
    private var characterDetailsCache: [String: CharacterDetails] = [:]

    init(character: CharacterDetails, person: Person) {
        self.character = character
        self.person = person
    }

    func fetchVehicles(completion: @escaping () -> Void) {
        let group = DispatchGroup()
        var vehicleNames: [String] = []

        for vehicleURL in person.vehicles {
            group.enter()
            getDataService.getData(from: vehicleURL) { (result: Result<Vehicle, Error>) in
                switch result {
                case .success(let vehicle):
                    vehicleNames.append(vehicle.name)
                case .failure(let error):
                    print("Failed to fetch vehicle: \(error.localizedDescription)")
                }
                group.leave()
            }
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

    func fetchCharacterDetails(completion: @escaping (CharacterDetails) -> Void) {
        if let cachedDetails = characterDetailsCache[person.url] {
            completion(cachedDetails)
            return
        }

        let group = DispatchGroup()
        var language = "Unknown"
        
        if let speciesURL = person.species.first {
            group.enter()
            fetchSpecies(from: speciesURL) { fetchedLanguage in
                language = fetchedLanguage
                group.leave()
            }
        }

        group.enter()
        fetchVehicles {
            group.leave()
        }

        group.notify(queue: .main) {
            let avatarURL = "https://eu.ui-avatars.com/api/?name=\(language.replacingOccurrences(of: " ", with: "+"))"
            let characterDetails = CharacterDetails(name: self.person.name, gender: self.person.gender, language: language, avatarURL: avatarURL, vehicles: self.character.vehicles)
            self.characterDetailsCache[self.person.url] = characterDetails
            self.character = characterDetails
            completion(characterDetails)
        }
    }
}
