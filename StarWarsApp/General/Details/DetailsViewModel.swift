import Foundation

class DetailsViewModel {
    var character: CharacterDetails?
    private let person: Person
    let services : Services

    init(person: Person, services: Services) {
        self.services = services
        self.person = person
    }

    // MARK: - Public Functions

    func fetchCharacterDetails(completion: @escaping (CharacterDetails?) -> Void) {

        let group = DispatchGroup()
        var language: String? = nil
        var vehicles: [Vehicle] = []

        if let speciesURL = person.species.first {
            group.enter()
            fetchLanguage(from: speciesURL) { fetchedLanguage in
                language = fetchedLanguage
                group.leave()
            }
        }

        group.enter()
        fetchVehicles {
            vehicles = $0
            group.leave()
        }

        group.notify(queue: .main) {
            self.character = CharacterDetails(name: self.person.name,
                                              gender: self.person.gender,
                                              language: language,
                                              vehicles: vehicles.map { $0.name })
            completion(self.character)
        }
    }
    
    // MARK: - Private Functions

    private func fetchVehicles(completion: @escaping ([Vehicle]) -> Void) {
        let group = DispatchGroup()
        var vehicles: [Vehicle] = []
        

        person.vehiclesIDs.forEach { vehicleID in
            group.enter()
            services.getVehicle(byID: vehicleID) { result in
                switch result {
                case .success(let vehicle):
                    vehicles.append(vehicle)
                case .failure(let error):
                    print("Failed to fetch vehicle: \(error.localizedDescription)")
                }
                group.leave()
            }
        }
        group.notify(queue: .main) {
            completion(vehicles)
        }
    }

    private func fetchLanguage(from id: String, completion: @escaping (String) -> Void) {
        let getData = GetData()
        let services = Services(getData: getData)
        
        services.getSpecies(byID: id) { result in
            switch result {
            case .success(let species):
                completion(species.language)
            case .failure(let error):
                print("Failed to fetch species: \(error.localizedDescription)")
                completion("Unknown")
            }
        }
    }
}
