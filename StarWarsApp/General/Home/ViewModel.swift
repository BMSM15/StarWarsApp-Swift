import Foundation

class ViewModel {
    private let urlPerson = "https://swapi.dev/api/people"
    var people: [Person] = []
    var fetchedURLs: Set<String> = [] // Track fetched URLs to prevent duplicates
    var currentPage: Int = 1
    var isFetching: Bool = false
    let maxPeopleCount: Int = 82
    
    // Cache para detalhes dos personagens
    private var characterDetailsCache: [String: CharacterDetails] = [:]

    func fetchData(completion: @escaping () -> Void) {
        guard !isFetching, people.count < maxPeopleCount else { return }
        isFetching = true
        print("Fetching data from page \(currentPage)...")
        fetchPeople(from: "\(urlPerson)?page=\(currentPage)", completion: completion)
    }
    
    private func fetchPeople(from url: String, completion: @escaping () -> Void) {
        print("Fetching people from URL: \(url)")
        getData(from: url) { [weak self] (response: APIResponse<Person>?, error) in
            guard let self = self else { return }
            self.isFetching = false
            
            if let error = error {
                print("Failed to fetch people: \(error.localizedDescription)")
            } else if let response = response {
                let newPeople = response.results.filter { !self.fetchedURLs.contains($0.url) }
                self.fetchedURLs.formUnion(newPeople.map { $0.url })
                self.people.append(contentsOf: newPeople)
                print("Total People Count: \(self.people.count)")
                
                if self.people.count < self.maxPeopleCount, let _ = response.next {
                    self.currentPage += 1
                }
            }
            completion()
        }
    }
    
    func fetchCharacterDetails(for person: Person, completion: @escaping (CharacterDetails) -> Void) {
        // Verifica se os detalhes do personagem estão em cache
        if let cachedDetails = characterDetailsCache[person.url] {
            print("Cache hit for person: \(person.name)")
            completion(cachedDetails)
            return
        }
        
        print("Fetching details for person: \(person.name)")
        let group = DispatchGroup()
        
        var language = "Unknown"
        
        if let speciesURL = person.species.first {
            group.enter()
            getData(from: speciesURL) { (species: Species?, error) in
                if let species = species {
                    language = species.language
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            let avatarURL = "https://eu.ui-avatars.com/api/?name=\(language.replacingOccurrences(of: " ", with: "+"))"
            let characterDetails = CharacterDetails(name: person.name, gender: person.gender, language: language, avatarURL: avatarURL, vehicles: person.vehicles)
            // Armazena os detalhes no cache
            self.characterDetailsCache[person.url] = characterDetails
            print("Fetched and cached details for person: \(person.name)")
            completion(characterDetails)
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

// Estruturas definidas
struct APIResponse<T: Codable>: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [T]
}

struct Person: Codable {
    let name: String
    let height: String
    let mass: String
    let hair_color: String
    let skin_color: String
    let eye_color: String
    let birth_year: String
    let gender: String
    let homeworld: String
    let films: [String]
    let species: [String]
    let vehicles: [String]
    let starships: [String]
    let created: String
    let edited: String
    let url: String
}

struct Species: Codable {
    let name: String
    let classification: String
    let designation: String
    let average_height: String
    let skin_colors: String
    let hair_colors: String
    let eye_colors: String
    let average_lifespan: String
    let homeworld: String?
    let language: String
    let people: [String]
    let films: [String]
    let created: String
    let edited: String
    let url: String
}

struct Vehicle: Codable {
    let name: String
    let model: String
    let manufacturer: String
    let cost_in_credits: String
    let length: String
    let max_atmosphering_speed: String
    let crew: String
    let passengers: String
    let cargo_capacity: String
    let consumables: String
    let vehicle_class: String
    let pilots: [String]
    let films: [String]
    let created: String
    let edited: String
}

struct CharacterDetails {
    let name: String
    let gender: String
    let language: String
    let avatarURL: String
    var vehicles: [String]
}

